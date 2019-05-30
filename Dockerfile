# Common arg values for ENVs accross staging container
ARG NAME_APP=gofeed-cli
ARG VERSION_APP=dev
ARG AUTHOR_APP='KEINOS (https://github.com/KEINOS/gofeed-cli)'
ARG GOOS=linux
ARG GOARCH=amd64
ARG GOARM=

#  BUILD STAGE
# =============
FROM dockercore/golang-cross AS builder

ARG NAME_APP
ARG VERSION_APP
ARG GOOS
ARG GOARCH
ARG GOARM

COPY ./src/ $GOPATH/src
COPY ./.git $GOPATH/src/.git

WORKDIR $GOPATH/src

# Set ENVs to build
ENV \
    GO111MODULE=on \
    NAME_APP=$NAME_APP \
    VERSION_APP=$VERSION_APP \
    GOOS=$GOOS \
    GOARCH=$GOARCH \
    GOARM=$GOARM \
    CGO_ENABLED=0

# Output info for debug
RUN \
    echo 'TAG:' $(git describe --tags) \
    && go version \
    && env

# RUN go get . In case your application has dependencies
RUN \
    export  VERSION_APP=$(git describe --tags) && \
    echo "- Version of the app: ${VERSION_APP}" && \
    go build \
        -a \
        -ldflags "-w -extldflags \"-static\" -X main.appVersion=${VERSION_APP} -X main.app_author=${AUTHOR_APP}" \
        -o $GOPATH/bin/$NAME_APP \
    . && \
    mv $GOPATH/bin/$NAME_APP /$NAME_APP

#  FINAL STAGE
# =============
FROM keinos/alpine

# Fix the missing dependency to avoid "not found" error even the Golang compiled binary exists in Alpine.
# - REF: https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker
RUN [ -f /lib64/ld-linux-x86-64.so.2 ] || { mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2; }

ARG NAME_APP
ENV NAME_APP=$NAME_APP
COPY --from=builder /$NAME_APP /$NAME_APP
COPY --from=builder /$NAME_APP /usr/local/bin/gofeed-cli

ENTRYPOINT [ "/usr/local/bin/gofeed-cli" ]
CMD [ "--help" ]