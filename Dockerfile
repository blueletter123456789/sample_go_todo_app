# Container for creating the binary to be included in the deployable container.
FROM golang:1.20.7-bullseye as deploy-builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -trimpath -ldflags "-w -s" -o app


# Deployable container.
FROM debian:bullseye-slim as deploy

RUN apt-get update

COPY --from=deploy-builder /app/app .

CMD ["./app"]


# Hot reload feature for use in the local development environment.
FROM golang:1.20.7 as dev

WORKDIR /app

RUN go install github.com/cosmtrek/air@latest

CMD ["air"]
