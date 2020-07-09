FROM golang:1.14.1 AS build
WORKDIR /deck
COPY go.mod ./
COPY go.sum ./
RUN go mod download
ADD . .
ARG COMMIT
ARG TAG
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o deck \
      -ldflags "-s -w -X github.com/hbagdi/deck/cmd.VERSION=$TAG -X github.com/hbagdi/deck/cmd.COMMIT=$COMMIT"

FROM alpine:3.11
RUN apk --no-cache add ca-certificates
COPY --from=build /deck/deck /usr/local/bin
ENTRYPOINT ["deck"]
