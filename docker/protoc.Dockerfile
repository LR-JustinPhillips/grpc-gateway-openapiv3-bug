FROM golang:1.25 AS builder

# install tools
RUN apt update
RUN apt install -y protobuf-compiler

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

WORKDIR /

RUN git clone https://github.com/grpc-ecosystem/grpc-gateway.git
WORKDIR /grpc-gateway

RUN go mod tidy
RUN go install \
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2

WORKDIR /go

# files we need
COPY proto proto
COPY docker/protoc.mk Makefile

RUN make

FROM scratch AS artifact
COPY --from=builder /go/gen /gen