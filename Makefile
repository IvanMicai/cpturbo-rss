

network-run:
	@docker network create -d bridge cpturboCrawler

network-stop:
	@docker network rm cpturboCrawler

app-build:
	docker build -t cpturbo/crawler .

app-run: 
	@docker run --name cpturboCrawlerAPP --net=cpturboCrawler -d -v `pwd`:/usr/src/app -p 3000:3000 cpturbo/crawler rails server -b 0.0.0.0

app-stop: 
	@docker stop cpturboCrawlerAPP
	@docker rm cpturboCrawlerAPP

app-initialize:
	sudo rm -rf db-data/
	@docker run --name cpturboCrawlerAPP --net=cpturboCrawler -ti --rm -v `pwd`:/usr/src/app -p 3000:3000 cpturbo/crawler rake db:create

app-migrate:
	@docker run --name cpturboCrawlerAPP --net=cpturboCrawler -ti --rm -v `pwd`:/usr/src/app -p 3000:3000 cpturbo/crawler rake db:migrate RAILS_ENV=development

app-console: 
	@docker run --name cpturboCrawlerAPP --net=cpturboCrawler -ti --rm -e CPTURBO_USER='$(USER)' -e CPTURBO_PASS='$(PASS)' -e CPTURBO_GA='$(GA)' -v `pwd`:/usr/src/app -p 3000:3000 cpturbo/crawler bash

db-run:
	docker run --name cpturboCrawlerDB --net=cpturboCrawler -e POSTGRES_PASSWORD=cpturbocrawler -v `pwd`/db-data:/var/lib/postgresql/data -d postgres


db-stop:
	@docker stop cpturboCrawlerDB
	@docker rm cpturboCrawlerDB