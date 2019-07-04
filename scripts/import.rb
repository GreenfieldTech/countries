#!/usr/bin/ruby

require 'net/http'
require 'uri'
require 'json'

begin

mcresp = Net::HTTP.get_response(URI.parse('https://raw.githubusercontent.com/mledoze/countries/master/dist/countries-unescaped.json'))

raise SystemExit.new "Error loading mledoze country list" unless mcresp.is_a? Net::HTTPSuccess

x = JSON[mcresp.body].collect do |c|
	c.delete('translations')
	c.merge!(
		'flag' => "https://raw.githubusercontent.com/mledoze/countries/db61f75e/data/#{c['cca3'].downcase}.svg"
	)
end.to_a.to_json

puts x

rescue SystemExit => e
	$stderr.puts e.message
	exit 1
end
