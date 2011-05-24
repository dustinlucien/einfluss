require 'test_helper'

class YahooScraperTest < ActiveSupport::TestCase
	test "scrape yahoo" do
		YahooScraper.scrape()
	end
	
	test "validate github ids" do
		assert YahooScraper.validate_github_id("dustinlucien")
		assert !YahooScraper.validate_github_id("99393949589")
		assert !YahooScraper.validate_github_id("connection-helper-java.html")
		assert !YahooScraper.validate_github_id("connection-helper-java.htm")
	end
end
