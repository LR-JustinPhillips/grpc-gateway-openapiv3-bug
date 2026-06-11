generate: clean gen-go

clean:
	rm -rf gen
	mkdir -p gen/go
	mkdir -p gen/openapi

gen-go:
	@echo "building go protofiles"
	@docker build -f ./buf/buf.go.Dockerfile --target=artifact --output type=local,dest=$(CURDIR) .