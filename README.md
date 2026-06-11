# grpc-gateway-openapiv3-bug
A test repo for recreating a grpc-gateway protoc-gen-openapiv3 bug.

Specifically, it seems like protoc-gen-openapiv3 does not work when protoc is run directly by the cli. To test, just run `make` in the root of the repo.

```
1.081 --openapiv3_out: protoc-gen-openapiv3: Plugin failed with status code 1.
```

Two additional branches exist where the same proto definitions can be used to generate openapi specs:
- `with-openapiv2`: Swapping all instances of openapiv3 for openapiv2 allows the openapi specs to be built, even when the proto definitions and build pipeline remain the same.
- `with-buf`: Swapping a direct protoc call for buf allows the openapi specs to be built using the openapiv3 plugin.

Additionally, the `simpler-proto` branch exists where an even simpler proto definition than this one also fails to generate.

If this is not a direct problem with the plugin itself, it's difficult to tell what is failing because the error does not describe much about the problem.
