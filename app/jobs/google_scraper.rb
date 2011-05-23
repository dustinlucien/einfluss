require 'rubygems'
require 'nokogiri'
require 'rest-open-uri'
require 'uri'
require 'github_api'

class GoogleScraper
	@hdrs = {"Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
  @root_search_string = "http://www.google.com/search?hl=en&source=hp&biw=1126&bih=1024&q=site%3Agithub.com+profile+&aq=f&aqi=&aql=f&oq="
	@gh_api = GitHubApi.new()
	
	def self.scrape()
		doc = Nokogiri::HTML(open(@root_search_string, @hdrs))

		doc.search('a.l').each do |link|
		  uri = URI.parse(link['href'].strip())
		end

		num_results = doc.search('div#resultStats')[0].content[/([0-9]{1,3}),([0-9]{1,3})/]
		num_results = num_results.sub(',','')
		  
		(10..num_results.to_i).step(10).each do |start|
		  #I guess i thought i could fork threads for each of these.  oops
		  doc = Nokogiri::HTML(open(@root_search_string + "&start=" + start.to_s, @hdrs))
			self.extract_github(doc)
			#add a sleep to the thread to protect from google throttling
		end
	end
	
	def self.extract_github(doc)
		doc.search('a.l').each do |link|
			uri = URI.parse(link['href'].strip())
			gid = uri.path.gsub('/','')
			puts "The github handle is " + gid

			gp = @gh_api.get_profile(gid)
			
			if (gp.nil?)
				puts "no profile returned for " + gid
			else
				puts "profile returned for " + gid
				puts gp.to_s
			
				if (!Person.find_by_github(gid))
					Person.create!(:name => gp['name'], :email => gp['email'], :company => gp['company'], :github => gid, :github_type => gp['type'], :location => gp['location'])
				end
			end
		end
	end
end
