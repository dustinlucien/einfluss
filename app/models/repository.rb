class Repository < Neo4j::Model
	property :name

	has_n(:forkers)
	
	has_one(:language)

	has_n(:watchers).from(:watching)
	
	has_one(:owned_by).from(:owner)
	
end
