FROM golang:1.25 AS builder

# install tools
RUN apt update
RUN apt install unzip
RUN apt install wget

# intall protoc
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v35.0/protoc-35.0-linux-x86_64.zip
RUN unzip protoc-35.0-linux-x86_64.zip -d protoc-35.0
RUN mv protoc-35.0/bin/protoc /usr/local/bin/
RUN mv protoc-35.0/include/* /usr/local/include/

# install protoc plugins
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

WORKDIR /

RUN git clone https://github.com/grpc-ecosystem/grpc-gateway.git
WORKDIR /grpc-gateway

RUN go mod tidy
RUN go install \
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv3

WORKDIR /go

# files we need
COPY proto proto
COPY docker/protoc.mk Makefile

RUN make

FROM scratch AS artifact
COPY --from=builder /go/gen /gen