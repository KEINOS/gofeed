#!/bin/sh

# gofeed-cli builder
# ==================
# This script checks the requirements and builds the gofeed-cli.
# Aimed to run on docker to build. See the Dockerfile and the
# source code "gofeed-cli.go" for details.

cd $(cd $(dirname $0); pwd)
echo '- Curent directory: ' $(pwd)
echo '- User: ' $(whoami)

NAME_APP=${NAME_APP:-gofeed-cli}
AUTHOR_APP=${AUTHOR_APP:-""}
VERSION_APP=${VERSION_APP:-$(cd $GOPATH/src; git describe --tags)}

# =============================================================================
#  Functions
# =============================================================================

function chk_bin(){
    printf "  - ${1} ... "
    which $1 > /dev/null
    if [ $? -ne 0 ]; then
        echo 'not installed'
        missing_bin=1
        return 1
    fi
    echo 'installed'
    return 0
}

function chk_pkg(){
    printf "  - Go pkg: ${1} ... "
    find $GOPATH -name '*.go' | grep $1 > /dev/null
    if [ $? -ne 0 ]; then
        echo 'not installed'
        install_pkg $1
        return $?
    fi
    echo 'installed'
    return 0
}

function install_pkg(){
    printf "    Installing: ${1} ... "
    go get $1 > /dev/null
    if [ $? -ne 0 ]; then
        echo 'NG'
        echo "* Fail to install package: ${1}"
        exit 1
    fi
    echo 'OK'
}

# =============================================================================
#  Main
# =============================================================================

# Check dependencies
# ==================
echo '- Checking dependencies ...'

list_dep='go git gcc g++'

missing_bin=0
for bin_dep in $list_dep; do
    chk_bin $bin_dep
done
if [ $missing_bin -ne 0 ]; then
    echo '* Missing dependencies found. Please install them before build.'
    exit 1
fi

chk_pkg github.com/mmcdole/gofeed
chk_pkg github.com/urfave/cli

echo '- Tidy go modules:'
go mod tidy

printf '- Go version: '; go version
echo '- Go envs: '; go env
echo '- List packages'; go list ./...

echo '- Double check modules:';
    chk_pkg github.com/mmcdole/gofeed
    chk_pkg github.com/urfave/cli

# Building The App
# ================

echo "- Building app (${VERSION_APP}) ... "

go build \
    -a \
    --ldflags "-w -extldflags \"-static\" \
        -X main.app_version=${VERSION_APP} \
        -X main.app_author=${AUTHOR_APP}" \
    -o ../bin/$NAME_APP \
    ./gofeed-cli.go && \
../bin/$NAME_APP --version && \
../bin/$NAME_APP --help

if [ $? -ne 0 ]; then
    echo '* Failed to build app'
    exit 1
fi
echo "Successfuly built:" $(cd ../bin && pwd)/$NAME_APP
exit 0
