CONTAINER_RUNTIME ?= podman

OPENAPI_GENERATOR_CLI \
	?= \
	$(CONTAINER_RUNTIME) run --rm \
	-v $(PWD):/data \
	-w /data \
	docker.io/openapitools/openapi-generator-cli

OPENAPI_GENERATOR_GENERATE \
	?= \
	$(OPENAPI_GENERATOR_CLI) \
	generate \
	-i openapi.yaml \
	--git-user-id larsks \
	--git-host github.com \
	--git-repo-id moc-microservice

DESTDIR ?= .

all: $(DESTDIR)/html/index.html $(DESTDIR)/python/README.md $(DESTDIR)/go/README.md

publish: all
	ghp-import out
	git push origin gh-pages

$(DESTDIR)/html/index.html: openapi.yaml
	mkdir -p $(DESTDIR)/html
	$(OPENAPI_GENERATOR_GENERATE) -o $(DESTDIR)/html -g html2

$(DESTDIR)/python/README.md: openapi.yaml
	mkdir -p $(DESTDIR)/python
	$(OPENAPI_GENERATOR_GENERATE) -o $(DESTDIR)/python -g python-flask

$(DESTDIR)/go/README.md: openapi.yaml
	mkdir -p $(DESTDIR)/go
	$(OPENAPI_GENERATOR_GENERATE) -o $(DESTDIR)/go -g go-echo-server

clean:
	rm -rf $(DESTDIR)/index.html
