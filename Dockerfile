FROM golang:1.17-alpine3.14 AS builder

WORKDIR /usr/src
ARG GOOGLE_CLOUD_GO_VERSION
ENV GOOGLE_CLOUD_GO_VERSION $GOOGLE_CLOUD_GO_VERSION

RUN busybox wget "https://github.com/googleapis/google-cloud-go/archive/${GOOGLE_CLOUD_GO_VERSION}.tar.gz" -O- | \
    busybox tar x --strip-components 1 -zf - && \
    cd bigtable && \
    go install -v ./cmd/emulator

FROM alpine:3.14

COPY --from=builder /go/bin/emulator /bin/cbtemulator

EXPOSE 8086
ENTRYPOINT ["/bin/cbtemulator"]
CMD ["-host=0.0.0.0", "-port=8086"]
