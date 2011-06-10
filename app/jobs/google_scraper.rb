require 'rubygems'
require 'nokogiri'
require 'rest-open-uri'
require 'uri'
require 'github_api'

class GoogleScraper
	@hdrs = {"Accept-Charset"=>"utf-8", "Accept"=>"text/html", "User-Agent"=>"Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.127 Safari/534.16"}
	
  @root_search_string = "http://www.google.com/search?q=site%3Agithub.com+profile+-+GitHub"
	@gh_api = GitHubApi.new()
	
	def self.scrape()
		doc = Nokogiri::HTML(open(@root_search_string, @hdrs))

		doc.search('a.l').each do |link|
		  uri = URI.parse(link['href'].strip())
		end

		num_results = doc.search('div#resultStats')[0].content[/([0-9]{1,3}),([0-9]{1,3})/]
		num_results = num_results.sub(',','')
		
		self.extract_github(doc)
		
		pages = 1
		
		next_url = self.extract_next_url(doc)
		
		while !next_url.nil?
			sleep 1 + rand(20)
			doc = Nokogiri::HTML(open(next_url, @hdrs))			
			self.extract_github(doc)
			pages = pages + 1
			
			puts "pages >> " + pages.to_s

			next_url = self.extract_next_url(doc)
		end		
	end
	
	def self.extract_github(doc)
		doc.search('a.l').each do |link|
			uri = URI.parse(link['href'].strip())
			gid = uri.path.gsub('/','')

			if validate_github_id(gid)
				puts gid
			end
		end
	end
	
	def self.extract_next_url(doc)
		doc.search('a#pnnext').each do |link|
			href = nil
			if (link != nil)
				href = "http://www.google.com" + link['href'].strip()
			end

			return href
		end
	end
	
	def self.validate_github_id(gid)
		
		if gid.match(/[0-9].*/) != nil
			return false
		end
		
		if gid.ends_with?(".htm") 
			return false
		end
		
		if gid.end_with?(".html") 
			return false
		end
		
		if gid.length > 40 
			return false
		end
		
		true
	end
end
