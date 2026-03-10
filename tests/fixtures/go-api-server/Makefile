.PHONY: build run test lint generate migrate

build:
	go build -o bin/server ./cmd/server

run:
	go run ./cmd/server

test:
	go test ./...

lint:
	golangci-lint run

generate:
	go generate ./ent

migrate:
	go run ./cmd/server migrate
