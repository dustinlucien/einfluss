class Person < Neo4j::Model
	property :name, :email, :company, :github, :github_type, :location, :latitude, :longitude
	
	index :github
	index :location
	
	has_n :following
	has_n :followers
	
	has_n :repositories
	has_n :owner
	
	has_n :watching
	
	has_n(:forks).from(:forkers)
	
	def self.create_or_find_by_github(github)
		github.downcase!
		person = Person.find_by_github(github)
		person ||= begin
			p = Person.create!(:github => github)
			p
		end
		person
	end

	def self.create_or_find_by_email(email)
		email.downcase!
		person = Person.find_by_email(email)
		person ||= begin
			p = Person.create!(:email => email)
			p
		end
		person
	end
		
end
