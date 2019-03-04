FROM golang:1.12-alpine AS builder

RUN mkdir -p /src/src
WORKDIR /usr/src

ENV GOOGLE_CLOUD_GO_VERSION v0.36.0

RUN apk add --no-cache git

RUN git clone https://github.com/googleapis/google-cloud-go.git . \
    && git checkout "$GOOGLE_CLOUD_GO_VERSION" \
    && go install -v ./bigtable/cmd/emulator

FROM alpine

COPY --from=builder /go/bin/emulator /bin/cbtemulator

EXPOSE 8086
CMD ["/bin/cbtemulator", "-host=0.0.0.0", "-port=8086"]
