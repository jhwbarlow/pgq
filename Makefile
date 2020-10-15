.PHONY: tests viewcoverage check ci

GOBIN ?= $(GOPATH)/bin

all: tests check

tests:
	go test .

coverage.txt: $(GOBIN)/go-acc
	go-acc ./... --output=$@

viewcoverage: coverage.txt 
	go tool cover -html=$<

check: $(GOBIN)/golangci-lint
	$(GOBIN)/golangci-lint run --skip-dirs=example

$(GOBIN)/goveralls:
	go get -v -u github.com/mattn/goveralls

$(GOBIN)/golangci-lint:
	curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(GOPATH)/bin v1.12.3

$(GOBIN)/go-acc:
	go get github.com/ory/go-acc

ci: coverage.txt check $(GOBIN)/goveralls
	$(GOBIN)/goveralls -coverprofile=$< -service=travis-ci
