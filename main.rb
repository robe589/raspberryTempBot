#coding: utf-8
require 'bundler'
Bundler.require

require 'csv'

require './myid'
require './TwitterApi'

def main()
	storagePath="date/"
	csvName="temp.csv"
	#保存用フォルダの作成
	Dir.mkdir(storagePath) unless Dir.exists?(storagePath)
	#保存用CSVファイルの作成
	File.open(storagePath+csvName,"w") unless File.exists?(storagePath+csvName)
	#温度を測定
	temp=`cat /sys/class/thermal/thermal_zone0/temp`
	#文字列データに変換
	temp.slice!(3..-1)
	temp.insert(2,".")
	tempNum=temp.to_f
	p tempNum
	nowTime=Time.now
	str=nowTime.strftime("%Y年%m月%d日%H時%M分の温度は")+temp+'度です'
	csvdate=[nowTime.strftime("%m/%d/%H:%M"),temp]
	#CSVファイルに温度データを保存
	CSV.open(storagePath+csvName,'a') do |csv|
		csv << csvdate
	end
	if tempNum<47 
		return true
	end
	#ツイッターログイン処理
	str=Time.now.strftime("%Y年%m月%d日%H時%M分の温度は")+temp+'度です'
	#twitterに投稿
	twitterApi=TwitterApi.new($consumer_key,$consumer_secret,$access_token,$access_token_secret)
	twitterApi.write(str)
end

main()
