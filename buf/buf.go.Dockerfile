FROM golang:1.25 AS builder

WORKDIR /

RUN git clone https://github.com/grpc-ecosystem/grpc-gateway.git
WORKDIR /grpc-gateway

RUN go mod tidy
RUN go install \
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv3

WORKDIR /bufgo

# files we need
COPY buf/buf.gen.go.yaml .
COPY buf/buf.work.yaml .
COPY proto proto

# install protoc plugins and buf
RUN go install github.com/bufbuild/buf/cmd/buf@v1.65.0
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

RUN buf dep update proto/service_a
RUN buf generate --template buf.gen.go.yaml 

FROM scratch AS artifact
COPY --from=builder /bufgo/gen /gen