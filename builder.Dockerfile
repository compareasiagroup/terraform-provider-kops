FROM golang:1.13

ENV GO111MODULE=on
RUN go get github.com/hashicorp/terraform@v0.12.28
