ARG NAME_APP=gofeed-cli
ARG VERSION_APP

# Stage 1: Build gofeed-cli binary
# =========================================================
FROM golang:alpine AS build-app

# Set env variable of app name and version
ENV NAME_APP=$NAME_APP VERSION_APP=$VERSION_APP

# Copy the source code
COPY src/ /go/src
COPY .git/ /go/src/.git

# Install dependencies
RUN apk add git gcc g++ && \
    go get github.com/mmcdole/gofeed && \
    go get github.com/urfave/cli
# Build app
RUN /go/src/build.sh
# Run tests
RUN /go/src/run-tests.sh

# Stage 2: Build Docker image w/ only the gofeed-cli binary
# =========================================================
# Whenever the keinos/alpine image is updated, it will
# trigger the Docker Cloud Automated Build to build the
# keinos/gofeed-cli and updates image on Docker Hub.
FROM keinos/alpine

ARG NAME_APP=gofeed-cli

# Avoid "x509: certificate signed by unknown authority" error
# while fetching feed through HTTPS.
RUN apk add ca-certificates \
    && rm -rf /var/cache/apk/*

COPY --from=build-app /go/bin/gofeed-cli /usr/local/bin/gofeed-cli

ENTRYPOINT [ "/usr/local/bin/gofeed-cli" ]
CMD [ "--help" ]
