require 'test_helper'

class GithubApiTest < ActiveSupport::TestCase
	@gh_api
	
	setup do
		puts "setting up"
		@gh_api = GitHubApi.new()
	end
	
	test "getting a user profile" do
		
		profile = @gh_api.get_profile("dustinlucien")
		assert !profile.nil?
		
		profile = @gh_api.get_profile("scooter.html")
		assert profile.nil?
	end
	
	test "get a users followers" do
		followers = @gh_api.get_followers("dustinlucien")
		assert !followers.nil?
		assert followers.size > 0
		
		followers = @gh_api.get_followers("scooter.html")
		assert followers.nil?
	end
	
	test "get a users following" do
		following = @gh_api.get_following("dustinlucien")
		assert !following.nil?
		assert following.size > 0
		
		following = @gh_api.get_following("scooter.html")
		assert following.nil?
	end
	
	test "make too many requests" do
		puts "Requests remaining " + @gh_api.requests_remaining.to_s
		
		@gh_api.get_profile("dustinlucien")
		
		while @gh_api.requests_remaining > 0 do
			@gh_api.get_profile("dustinlucien")
		end
		
		puts "Requests remaining " + @gh_api.requests_remaining.to_s
		
		assert @gh_api.requests_remaining == 0
		
		@gh_api.get_profile("dustinlucien")
		
		puts "Requests remaining " + @gh_api.requests_remaining.to_s

		assert @gh_api.requests_remaining != 0
		
	end
	
	teardown do
		puts "tearing down"
		@gh_api = nil
	end
end
