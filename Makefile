bin/dapper:
	$(eval t := $(shell mktemp))
	@curl -Lso $(t) https://releases.rancher.com/dapper/latest/dapper-$$(uname -s)-$$(uname -m)
	@chmod +x $(t)
	@mkdir -p bin/
	@mv $(t) bin/dapper

.DEFAULT_GOAL :=

all: bin/dapper
	@bin/dapper nix build

cache: bin/dapper
	@bin/dapper cachix watch-exec whslabs -- nix build

s shell: bin/dapper
	@bin/dapper \
		-m bind \
		-s \
		;

clean:
	rm -rf bin/
	rm -rf target/
	rm -rf result-bin
