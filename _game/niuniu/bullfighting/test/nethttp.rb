require 'net/http'
require 'json'

uri = URI('http://192.168.1.109/ddz/api.php?')
params = Hash.new
params['user'] = 'cat0'
params['password'] = '123456' 

qstr = { :action => 'Login', :param => params.to_json }
uri.query = URI.encode_www_form(qstr)

res = Net::HTTP.get_response(uri)
puts res.body if res.is_a?(Net::HTTPSuccess)

