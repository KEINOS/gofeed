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
    GOARM=$GOARM

RUN echo 'TAG:' $(git describe --tags)
# RUN go get . # In case your application has dependencies
RUN export  VERSION_APP=$(git describe --tags); go build \
    -a \
    -ldflags "-w -extldflags \"-static\" -X main.appVersion=${VERSION_APP} -X main.app_author=${AUTHOR_APP}" \
    -o $GOPATH/bin/$NAME_APP \
    .

RUN mv $GOPATH/bin/$NAME_APP /$NAME_APP

#  FINAL STAGE
# =============
FROM alpine

ARG NAME_APP
COPY --from=builder /$NAME_APP /$NAME_APP
COPY --from=builder /$NAME_APP /usr/local/bin/$NAME_APP

ENTRYPOINT [ "/usr/local/bin/gofeed-cli" ]
CMD [ "--help" ]