BINDATA =

gopath = $(firstword $(subst :, ,$(GOPATH)))

bindata = $(shell go list -f '{{.Target}}' github.com/jteeuwen/go-bindata/go-bindata 2> /dev/null || echo $(gopath)/bin/go-bindata)
gox = $(shell go list -f '{{.Target}}' github.com/mitchellh/gox 2> /dev/null || echo $(gopath)/bin/gox)

dev: build-dev-assets
	go build
	@echo "You can now execute ./pgweb"

build-assets:
	go-bindata $(BINDATA) -ignore=\\.gitignore -ignore=\\.DS_Store -ignore=\\.gitkeep static/...

build-dev-assets:
	@$(MAKE) --no-print-directory build-assets BINDATA="-debug"

build: build-assets
	gox -osarch="darwin/amd64 darwin/386 linux/amd64 linux/386 windows/amd64 windows/386" -output="./bin/pgweb_{{.OS}}_{{.Arch}}"

setup: $(gox) $(bindata) build-dev-assets
	go get

clean:
	rm -f ./pgweb
	rm -f ./bin/*
	rm -f bindata.go

$(bindata):
	go get github.com/jteeuwen/go-bindata/...

$(gox):
	go get github.com/mitchellh/gox
