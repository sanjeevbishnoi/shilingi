# syntax = docker/dockerfile:1.3
FROM golang:1.17.6-buster as base

ARG APP_DIR=/app-engine
WORKDIR $APP_DIR

COPY go.* ./
RUN go mod download -x -json

COPY . .
RUN apt update
RUN --mount=type=cache,target=/go/pkg/mod CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags='-linkmode external -extldflags "-static"' -o app-engine ./cmd/server

FROM scratch

WORKDIR /usr/bin

COPY --from=base $APP_DIR/app-engine ./

EXPOSE 8080

ENTRYPOINT ["app-engine"]
