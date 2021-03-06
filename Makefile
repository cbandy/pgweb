BINDATA=

dev: dev-assets
	godep go build
	@echo "You can now execute ./pgweb"

assets:
	go-bindata $(BINDATA) -ignore=\\.gitignore -ignore=\\.DS_Store -ignore=\\.gitkeep static/...

dev-assets:
	@$(MAKE) --no-print-directory assets BINDATA="-debug"

build: assets
	gox -osarch="darwin/amd64 darwin/386 linux/amd64 linux/386 windows/amd64 windows/386" -output="./bin/pgweb_{{.OS}}_{{.Arch}}"

setup:
	go get github.com/tools/godep
	godep get github.com/mitchellh/gox
	godep get github.com/jteeuwen/go-bindata/...
	godep restore

clean:
	rm -f ./pgweb
	rm -f ./bin/*
	rm -f bindata.go

docker:
	docker build -t pgweb .