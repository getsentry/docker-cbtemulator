FROM golang:1.13-alpine3.11 AS builder

RUN mkdir -p /src/src
WORKDIR /usr/src

ENV GOOGLE_CLOUD_GO_VERSION v0.51.0

RUN apk add --no-cache git

RUN git clone --depth=1 --branch="$GOOGLE_CLOUD_GO_VERSION" https://github.com/googleapis/google-cloud-go.git . \
    && cd bigtable \
    && go install -v ./cmd/emulator

FROM alpine:3.11

COPY --from=builder /go/bin/emulator /bin/cbtemulator

EXPOSE 8086
ENTRYPOINT ["/bin/cbtemulator"]
CMD ["-host=0.0.0.0", "-port=8086"]
