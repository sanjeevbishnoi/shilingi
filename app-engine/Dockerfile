# syntax = docker/dockerfile:1.3
FROM golang:1.17.6-alpine3.14 as base

ARG APP_DIR=/app-engine
WORKDIR $APP_DIR

COPY go.* ./
RUN go mod download -x -json

COPY . .
RUN --mount=type=cache,target=/go/pkg/mod go build -o app-engine ./cmd/server

FROM scratch

WORKDIR /usr/bin

COPY --from=base $APP_DIR/app-engine ./

EXPOSE 8080

USER nobody

ENTRYPOINT ["app-engine"]
