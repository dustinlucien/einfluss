require 'rubygems'
require 'nokogiri'
require 'rest-open-uri'
require 'uri'

class UsersController < ApplicationController

  def scrape
    hdrs = {"Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
    
    root_search_string = "http://www.google.com/search?hl=en&source=hp&biw=1126&bih=1024&q=site%3Agithub.com+profile+&aq=f&aqi=&aql=f&oq="

    doc = Nokogiri::HTML(open(root_search_string, hdrs))

    doc.search('a.l').each do |link|
      uri = URI.parse(link['href'].strip())
      puts uri.path.gsub('/','')
    end

    num_results = doc.search('div#resultStats')[0].content[/([0-9]{1,3}),([0-9]{1,3})/]
    num_results = num_results.sub(',','')

    (10..num_results.to_i).step(10).each do |start|
			
      search_string = root_search_string + "&start=" + start.to_s

			Resque.enqueue(GoogleCrawl, start, search_string)

      doc = Nokogiri::HTML(open(search_string, hdrs))
      doc.search('a.l').each do |link|
        uri = URI.parse(link['href'].strip())
        puts uri.path.gsub('/','')
      end
      sleep 0.25
    end
  end

end
