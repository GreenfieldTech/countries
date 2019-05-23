all:
	./scripts/import.rb | jq -M --unbuffered . > countries.json
