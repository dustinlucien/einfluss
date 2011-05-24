require 'test_helper'

class GoogleScraperTest < ActiveSupport::TestCase
	test "validate github ids" do
		assert GoogleScraper.validate_github_id("dustinlucien")
		assert !GoogleScraper.validate_github_id("99393949589")
		assert !GoogleScraper.validate_github_id("connection-helper-java.html")
		assert !GoogleScraper.validate_github_id("connection-helper-java.htm")
	end
end
