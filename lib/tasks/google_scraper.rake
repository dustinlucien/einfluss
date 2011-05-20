namespace :scrape do
	desc "Scrape google for GitHub accounts and add them to the database with profile information"
	task :scrape_google => :environment do
		GoogleScraper.scrape()
	end
end
