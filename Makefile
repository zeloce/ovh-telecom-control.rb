gem = $(shell basename $(shell git rev-parse --show-toplevel) .rb)
version = $(shell git log -1 --format=%ct)

build:
	gem build $(gem).gemspec

install: build
	gem install $(gem)-$(version).gem

uninstall:
	gem uninstall $(gem) --version $(version)

clean:
	rm -f $(gem)-$(version).gem
