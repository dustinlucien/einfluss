require 'rest-open-uri'

class GitHubApi
	attr_accessor :requests_remaining

	def initialize()	
		@hdrs = {"Accept-Charset"=>"utf-8", "Accept"=>"text/json"}
		@requests_remaining = 0
	end
	
	def get_profile(username)
		request_url = "http://github.com/api/v2/json/user/show/" + username

		response = open_url(request_url)
		
		if response.nil?
			return nil
		end
		
		json = JSON.parse(response)
		json['user']
		
	end

	def get_following(username)
		request_url = "http://github.com/api/v2/json/user/show/" + username + "/following"
		
		response = open_url(request_url)
		
		if response.nil?
			return nil
		end
		
		JSON.parse(response)
	end
	
	def get_followers(username)
		request_url = "http://github.com/api/v2/json/user/show/" + username + "/followers"
		
		response = open_url(request_url)
		
		if response.nil?
			return nil
		end
		
		JSON.parse(response)
	end
	
	
	def open_url(url)
		response = nil
		begin
			response = open(url)
		
			@requests_remaining = response.meta['x-ratelimit-remaining'].to_i
		
			puts "GitHub Requests Remaining => " + @requests_remaining.to_s
			
			response = response.read
		rescue OpenURI::HTTPError => e
		
		  if @requests_remaining == 0
		  	puts "sleeping..."
				sleep 30
				retry
			end
			
		end

		response
	end
	
end
