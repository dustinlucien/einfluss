require 'rubygems'
require 'bossman'
include BOSSMan

class YahooScraper

	def self.scrape()
	
		puts "Getting URLs"
		BOSSMan.application_id = 'dj0yJmk9UGZrQ1NjMWlzMGJVJmQ9WVdrOVJuUkhOVGw2TXpRbWNHbzlNVFEwT0RReU16VTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD0wMQ--'
		offset = 0
		done = false
		urls = []
		while !done
			puts "before call"
			
			results = BOSSMan::Search.web('site:github.com "profile - GitHub"', :start => offset, :count=>50)
			
			puts "after call"
			
			offset += results.count.to_i
			
			if offset > results.totalhits.to_i
			    done = true
			end
			urls += results.results.map { |r| r.url }
		end
		
		puts "moving on to lines"
		
		for line in urls
			line.match(/github.com\/([a-zA-Z0-9-]+)/)
			me = $1

			if me.match(/^(.*)\/$/)
				me = $1
      end
			
			if validate_github_id(me)
				puts me
			end
			
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
