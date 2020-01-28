def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
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
	dns_records = Hash.new
	dns_raw.each do |line|
		if !line.start_with?"#" and line!=nil
			record = line.strip.delete(' ').split ","
			dns_records[record[1].strip] = record if record.length==3
		end
	end
	dns_records
end

def resolve(dns_records, lookup_chain, domain)

	#dns_records.each do |r|
		
		record = dns_records[domain] if dns_records.has_key? domain
		
		if record!=nil and record[0] == "A"
			lookup_chain << record[2]
			
		elsif record!=nil and record[0] == "CNAME"
			lookup_chain << record[2]
			lookup_chain=resolve(dns_records, lookup_chain, record[2])
			
		else
			lookup_chain.delete domain
			lookup_chain << "Error: Record not found for "+domain
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
