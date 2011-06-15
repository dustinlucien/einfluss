require 'rest-open-uri'

class GitHubApi
	attr_accessor :requests_remaining

	def self.get_profile(username)
		username = username.strip
		
		request_url = "http://github.com/api/v2/json/user/show/" + username

		response = self.open_url(request_url)
		
		if response.nil?
			return nil
		end
		
		json = JSON.parse(response)
		json['user']
		
	end

	def self.get_following(username)
		username = username.strip
		
		request_url = "http://github.com/api/v2/json/user/show/" + username + "/following"
		
		response = self.open_url(request_url)
		
		if response.nil?
			return nil
		end
		
		out = JSON.parse(response)
		
		if (!out.nil?)
			out = out['users']
		end
		
		out			
	end
	
	def self.get_followers(username)
		username = username.strip
		
		request_url = "https://api.github.com/users/" + username + "/followers"
		
		response = self.open_url(request_url)
		
		if response.nil?
			return nil
		end
		
		out = JSON.parse(response)
		
		if (!out.nil?)
			out = out['users']
		end
		
		out
	end
	
	def self.get_repos(username)
		username = username.strip
		
		request_url = "https://api.github.com/user/" + username + "/repos"
		
		response = self.open_url(request_url)
		
		if response.nil?
			return nil
		end
		
		out = JSON.parse(response)
		
		return out
	end
	
	def self.get_watchers(username, repo)
		username = username.strip
		
		request_url = "https://api.github.com/repos/" + username + "/" + repo + "/watchers"
		
		response = self.open_url(request_url)
		
		if response.nil?
			return nil
		end
		
		out = JSON.parse(response)
		
		return out
	end
	
	def self.open_url(url)
		response = nil

		attempts = 0;
		
		while(true)
			begin
				response = open(url)
				attempts++
				
				requests_remaining = response.meta['x-ratelimit-remaining'].to_i				
				puts "GitHub Requests Remaining => " + requests_remaining.to_s
				
				if (requests_remaining == 0 && attempts < 100)
				  puts "sleeping..."
				  sleep 60
					next
				else
					break
				end
		 rescue OpenURI::HTTPError => e
				puts "httperror in open_url"
				puts e.to_s
				puts "sleeping..."
				sleep 30
				retry
			end
		end
				
		response.read
	end
	
end
