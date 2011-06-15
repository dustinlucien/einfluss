class Person < Neo4j::Model
	property :name, :email, :company, :github, :github_type
	property :location, :latitude, :longitude
	
	index :github
	index :location
	
	has_n :following
	has_n :followers
	
	has_n :repos

	has_n :watching
	
	def self.find_or_create_by_github(github)
		github.downcase!
		person = Person.find_by_github(github)
		person ||= begin
			p = Person.create!(:github => github)
			p
		end
		person
	end

	def self.find_or_create_by_email(email)
		email.downcase!
		person = Person.find_by_email(email)
		person ||= begin
			p = Person.create!(:email => email)
			p
		end
		person
	end
		
end
