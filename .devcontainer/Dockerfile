# Ref: https://github.com/yoskeoka/remote-dev-go/blob/master/.devcontainer/Dockerfile @ GitHub
# Ref: https://qiita.com/yoskeoka/items/01c52c069123e0298660 @ Qiita

FROM dockercore/golang-cross AS develop

# Install useful tools to develop
RUN go get -u -v \
    honnef.co/go/tools/... \
    github.com/acroca/go-symbols \
    github.com/alecthomas/gometalinter \
    github.com/derekparker/delve/cmd/dlv \
    github.com/golangci/golangci-lint/cmd/golangci-lint \
    github.com/mdempsky/gocode \
    github.com/mgechev/revive \
    github.com/ramya-rao-a/go-outline \
    github.com/rogpeppe/godef \
    github.com/sqs/goreturns \
    github.com/uudashr/gopkgs/cmd/gopkgs \
    github.com/zmb3/gogetdoc \
    golang.org/x/lint/golint \
    golang.org/x/tools/cmd/goimports \
    golang.org/x/tools/cmd/gorename \
    golang.org/x/tools/cmd/guru \
    winterdrache.de/goformat/goformat 2>&1

# gocode-gomod
RUN go get -x -d github.com/stamblerre/gocode \
    && go build -o gocode-gomod github.com/stamblerre/gocode \
    && mv gocode-gomod $GOPATH/bin/

# Copy default endpoint specific user settings overrides into container to specify GOENV path
COPY settings.vscode.json /root/.vscode-remote/data/Machine/settings.json

# Verify git, process tools installed
RUN apt-get update && apt-get -y install git procps vim

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Additional dev support
RUN go get -u -v \
    github.com/cespare/reflex

ENV GO111MODULE=on
