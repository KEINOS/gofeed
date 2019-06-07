#!/bin/sh

# gofeed-cli builder
# ==================
# This script checks the requirements and builds the gofeed-cli.
# Aimed to run on docker to build. See the Dockerfile and the
# source code "gofeed-cli.go" for details.

cd $(dirname $0)

NAME_APP=${NAME_APP:-gofeed-cli}
VERSION_APP=${VERSION_APP:-$(git describe --tags)}

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

# Building The App
# ================

printf "- Building app (${VERSION_APP}) ... "

go build \
    -a \
    --ldflags "-w -extldflags \"-static\" -X main.app_version=${VERSION_APP}" \
    -o ../bin/$NAME_APP \
    ./gofeed-cli.go && \
../bin/$NAME_APP --version

if [ $? -ne 0 ]; then
    echo '* Failed to build app'
    exit 1
fi
echo "Successfuly built:" $(cd ../bin && pwd)/$NAME_APP
exit 0
