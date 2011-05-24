require 'rubygems'
require 'rest-open-uri'
require 'github_api'

class RelationshipBuilder
	def self.read()
		counter = 1
		file = File.open("#{Rails.root}/data/github_handles.txt", "r")
	
		while (line = file.gets)
			puts line
			counter = counter + 1
		end
		
		file.close
	end
	
	def self.add_person(gid)
		if (!Person.find_by_github(gid))
			gp = GitHubApi.get_profile(gid)
		
			if (!gp.nil?)
				Neo4j::Transaction.run do
					person = Person.create!(:name => gp['name'], :email => gp['email'], :company => gp['company'], :github => gid, :github_type => gp['type'], :location => gp['location'])
					
					if (gp['following_count'].to_i > 0)
						followers_gid = GitHubApi.get_followers(gid)
						for follower_gid in followers_gid
							if (!Person.find_by_gihub(follower_id))
								follower = 
								person.incoming(:followers) << follower
							end
						end
					end
					
					if (gp['followers_count'].to_i > 0)
					end
				end
			end
		end
	end
end
