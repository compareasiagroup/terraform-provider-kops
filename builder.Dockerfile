FROM golang:1.12

ENV GO111MODULE=on
RUN go get github.com/hashicorp/terraform@v0.12.13
