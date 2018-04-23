#!/usr/bin/ruby

require 'net/http'
require 'uri'
require 'json'

begin

obpresp = Net::HTTP.get_response(URI.parse("https://raw.githubusercontent.com/OpenBookPrices/country-data/master/data/countries.json"))

raise SystemExit.new "Error loading OpenBookPrices country list" unless obpresp.is_a? Net::HTTPSuccess
#raise SystemExit.new"Invalid content type fron OpenBookPrices country list: #{resp['content-type']}" unless obpresp['content-type'] == 'application/json'

cccodes = Hash[JSON[obpresp.body].collect do |c|
	[ c['alpha3'], c['countryCallingCodes'].collect do |cc|
		cc.split(" ").first.gsub(/^\+/,'')
	end.uniq.first ]
end]

#p cccodes
#exit

mcresp = Net::HTTP.get_response(URI.parse('https://raw.githubusercontent.com/mledoze/countries/master/dist/countries-unescaped.json'))

raise SystemExit.new "Error loading mledoze country list" unless mcresp.is_a? Net::HTTPSuccess

x = JSON[mcresp.body].collect do |c|
	c.merge(
		'callingCode' => cccodes[c['cca3']],
		'flag' => "https://cdn.rawgit.com/mledoze/countries/db61f75e/data/#{c['cca3'].downcase}.svg"
	)
end.to_a.to_json

puts x

rescue SystemExit => e
	$stderr.puts e.message
	exit 1
end
