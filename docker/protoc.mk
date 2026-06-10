manual_gen_path := gen/go/api
manual_openapi_path := gen/openapi/api
manual_package := example.com/service_a/$(manual_gen_path)
manual_protos := service_a_1.proto service_a_2.proto shared.proto

photongogen:
	mkdir -p $(manual_gen_path)
	mkdir -p $(manual_openapi_path)
	protoc -I proto/googleapis -I proto/service_a \
		--go_out $(manual_gen_path) --go_opt paths=source_relative \
		--go-grpc_out $(manual_gen_path) --go-grpc_opt paths=source_relative \
		--grpc-gateway_out $(manual_gen_path) \
		--openapiv3_out $(manual_openapi_path) \
		--grpc-gateway_opt paths=source_relative \
		--grpc-gateway_opt generate_unbound_methods=true \
		$(foreach proto, $(manual_protos), \
			--go_opt=M$(proto)="$(manual_package)/$(dir $(proto));device_managementv1"  \
		 	--go-grpc_opt=M$(proto)="$(manual_package)/$(dir $(proto));device_managementv1"   \
			--grpc-gateway_opt=M$(proto)="$(manual_package)/$(dir $(proto));device_managementv1"   \
			--openapiv3_opt=M$(proto)="$(manual_package)/$(dir $(proto));device_managementv1"   \
		) \
		$(manual_protos)