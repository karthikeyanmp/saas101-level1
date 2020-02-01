def get_command_line_argument
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
  dns_records = {}
  dns_raw.
    reject { |line| line.empty? }.
    map { |line| line.strip.split(", ") }.
    reject { |record| record.length < 3 }.
    each { |record| dns_records[record[1]] = { :type => record[0], :target => record[2] } }
  dns_records
end

def resolve(dns_records, lookup_chain, domain)
  #puts dns_records
  record = dns_records[domain] if dns_records.has_key? domain
  #puts record
  if record != nil and record[:type] == "A"
    lookup_chain << record[:target]
  elsif record != nil and record[:type] == "CNAME"
    lookup_chain << record[:target]
    lookup_chain = resolve(dns_records, lookup_chain, record[:target])
  else
    lookup_chain.delete domain
    lookup_chain << "Error: Record not found for " + domain
  end

  #end

end

# ..
# ..
# FILL YOUR CODE HERE
# ..
# ..

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
