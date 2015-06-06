#coding: utf-8
require 'bundler'
Bundler.require

require './myid'

def main()
	temp=`cat /sys/class/thermal/thermal_zone0/temp`
	str=Time.now.strftime("%Y年%m月%d日%H時%M分の温度は")+temp+'度です'
	client = Twitter::REST::Client.new do |config|
		config.consumer_key=$consumer_key#API Key
		config.consumer_secret=$consumer_secret#API secret
		config.access_token=$access_token #Access token
		config.access_token_secret=$access_token_secret  #Access token secret
	end
	temp.slice!(2..-1)
	p str
	client.update(str)
end

main()
