# STAGE 1: building the executable
FROM golang:alpine AS builder

WORKDIR /usr/src/app

RUN go mod init victor022/fullcycle

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
RUN go mod download && go mod verify

COPY . .

RUN go build -v -o /usr/local/bin/app ./...

# STAGE 2: build the container to run
FROM scratch AS final

COPY --from=builder /usr/local/bin/app .

CMD ["./app"]
