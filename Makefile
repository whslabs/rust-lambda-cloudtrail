bin/dapper:
	$(eval t := $(shell mktemp))
	@curl -Lso $(t) https://releases.rancher.com/dapper/latest/dapper-$$(uname -s)-$$(uname -m)
	@chmod +x $(t)
	@mkdir -p bin/
	@mv $(t) bin/dapper

.DEFAULT_GOAL :=

all: bin/dapper
	@bin/dapper

s shell: bin/dapper
	@bin/dapper \
		-m bind \
		-s \
		;
