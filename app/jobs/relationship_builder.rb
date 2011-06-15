require 'rubygems'
require 'rest-open-uri'
require 'github_api'

class RelationshipBuilder
	def self.build()
				
		@to_visit = []
		@visited = []
		
		self.read()
	end
	
	def self.read()
		counter = 1
		file = File.open("#{Rails.root}/data/github-test-data.txt", "r")
		
		while (line = file.gets)
			line = line.strip
			
			if (!line.start_with?("pages") && !@to_visit.include?(line))
				puts "GitHub handle from file: " + line
				self.visit_profile(line)
				@visited.push(line)
				puts "visited array " + @visited.to_s
			else
				puts "skipping line >> " + line
			end
		end		
		file.close
		
		#now visit all the uniq ids on the stack
		@to_visit = @to_visit.uniq
		
		while(gid = @to_visit.pop())
			puts "GitHub handle off stack: " + gid
			@visited.push(gid)
			self.visit_profile(gid)
		end
	end
	
	def self.visit_profile(gid)
		Neo4j::Transaction.run do
			person = Person.find_or_create_by_github(gid)
			if (person.nil?)
				return nil
			end

			gp = GitHubApi.get_profile(gid)
			if (gp.nil?)
				return nil
			end
		
			puts "updating the user " + gid
			
			person.update_attributes(:name => gp['name'], :email => gp['email'], :company => gp['company'], :github => gid, :github_type => gp['type'], :location => gp['location'])
		
			if (gp['follower_count'].to_i > 0)
				followers = GitHubApi.get_followers(gid)
				
 				for follower_gid in followers
					follower = Person.find_or_create_by_github(follower_gid)
					if (follower.nil?)
						puts "couldn't create follower in db.  error!"
						return nil
					end
					person.incoming(:followers) << follower
					
					#put the follower's github on a queue to work through as a profile update later
					if (!@visited.include?(follower_gid))
						puts "pushing " + follower_gid + " onto the stack"
						@to_visit.push(follower_gid)
					end
				end
			end
			
			if (gp['following_count'].to_i > 0)
				following = GitHubApi.get_following(gid)

				for following_gid in following
					follow = Person.find_or_create_by_github(following_gid)
					if (follow.nil?)
						puts "couldn't create follow in db. error!"
						return nil
					end
					person.outgoing(:following) << follow
					
					#put follow's github on a queue to work through as a profile update later
					if (!@visited.include?(following_gid))
						puts "pushing " + following_gid + " onto the stack"
						@to_visit.push(following_gid)
					end
				end
			end
			
			if (gp['public_repo_count'].to_i > 0)
				repos = GitHubApi.get_repos(gid)
				
				for repo_desc in repos
					repo = Repository.create!(:name => repo_desc['name']
				end	
			end
			#next, rip through the projects this person is watching, and then find their owners
			person.save
		end
	end
end
