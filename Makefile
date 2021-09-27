VERSION := 23c02d92c7a1747068eb1fc57dddbad23907d614

build:
	docker build -t us.gcr.io/sentryio/cbtemulator:$(VERSION) --build-arg=GOOGLE_CLOUD_GO_VERSION=$(VERSION) .

# Ideally craft's set up to release to here, but some ops people
# have permissions to push to the sentryio project, and
# cbtemulator doesn't really need updates often.
publish: build
	docker push us.gcr.io/sentryio/cbtemulator:$(VERSION)
