MAMMOTH := bin/phantomjs-mammoth.coffee
M4 := m4

all: test

test: node_modules
	$(MAMMOTH) test/*coffee

node_modules: package.json
	npm install
	touch $@

README.md: README.m4
	$(M4) $< > $@

.PHONY: test
