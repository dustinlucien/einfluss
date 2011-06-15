namespace :scrape do
	desc "Scrape google for GitHub accounts and add them to the database with profile information"
	task :scrape_google => :environment do
		GoogleScraper.scrape()
	end
	
	desc "Scrape Yahoo for GitHub accounts and add them to the database with profile information"
	task :scrape_yahoo => :environment do
		YahooScraper.scrape()
	end
	
	desc "build relationships from data file"
	task :build_graph => :environment do
		RelationshipBuilder.build()
	end
end
