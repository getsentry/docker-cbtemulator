FROM golang:1.12-alpine AS builder

RUN mkdir -p /src/src
WORKDIR /usr/src

ENV GOOGLE_CLOUD_GO_VERSION v0.39.0

RUN apk add --no-cache git

RUN git clone --depth=1 --branch="$GOOGLE_CLOUD_GO_VERSION" https://github.com/googleapis/google-cloud-go.git . \
    && go install -v ./bigtable/cmd/emulator

FROM alpine:3.9

COPY --from=builder /go/bin/emulator /bin/cbtemulator

EXPOSE 8086
ENTRYPOINT ["/bin/cbtemulator"]
CMD ["-host=0.0.0.0", "-port=8086"]
