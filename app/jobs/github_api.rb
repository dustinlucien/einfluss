require 'rubygems'
require 'rest-open-uri'
require 'uri'
require 'pp'

class GitHubApi
	@hdrs = {"Accept-Charset"=>"utf-8", "Accept"=>"text/json"}

	def self.get_profile(username)
		request_url = "http://github.com/api/v2/json/user/show/" + username

		response = open(request_url, @hdrs)
		
		pp response
		
		json = JSON.parse(response.read)

		if (json != nil)
			json = json['user']
		end
		
		json
	end

	def self.get_following(username)
		request_url = "http://github.com/api/v2/json/user/show/" + username + "/following"
		JSON.parse(open(request_url, @hdrs).read())
	end
	
	def self.get_followers(username)
		request_url = "http://github.com/api/v2/json/user/show/" + username + "/followers"
		JSON.parse(open(request_url, @hdrs).read())
	end
	
end