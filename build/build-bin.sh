#!/bin/bash
# =============================================================================
#  Multi Architecture Builder
# =============================================================================
# Run this script to build/compile your script to different architecture.
#
# This script was based on: https://github.com/KEINOS/TPL-Golang-HelloWorld-MultiArch

NAME_APP=gofeed-cli

COUNT_SELECT_MAX=7
BYPASS_TEST_LOCAL=no
NAME_DIR_BIN='bin'
NAME_DIR_SRC='src'
NAME_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
NAME_BASE_IMAGE='dockercore/golang-cross'

PATH_DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATH_DIR_PARENT="$(dirname "${PATH_DIR_SCRIPT}")"
PATH_DIR_BIN="${PATH_DIR_PARENT}/${NAME_DIR_BIN}"
PATH_DIR_SRC="${PATH_DIR_PARENT}/${NAME_DIR_SRC}"
PATH_FILE_SCRIPT="${PATH_DIR_SCRIPT}/${NAME_SCRIPT}"

# -----------------------------------------------------------------------------
#  Functions
# -----------------------------------------------------------------------------

function defecatePrunes () {
    docker container prune -f 1>/dev/null
    docker image prune -f 1>/dev/null
}

function echoHelp () {
cat << HEREDOC
===============================================================================
 BUILD MENU
===============================================================================
Arg number : Target OS/Architecture

    0: All the architectures below
    1: linux/arm64
    2: linux/armv5                  ex: QNAP TS-119P+
    3: linux/armv6                  ex: RaspberryPi ZeroW
    4: linux/armv7                  ex: RaspberryPi3 B
    5: linux/amd64,Intel,x86_64
    6: masOS/amd64,Intel,x86_64     ex: MacBookPro
    7: windows/amd64,Intel,x86_64

HEREDOC
}

function echoHR () {
    echo '-------------------------------------------------------------------------------'
}

function echoTitle () {
    echoHR
    echo '■ ' $1
    echoHR
}

function isArchSameWithHost () {
    HOSTOS=$(docker version --format '{{.Client.Os}}')
    HOSTARCH=$(docker version --format '{{.Client.Arch}}')
    [ "${GOOS}" = "${HOSTOS}" ] && [ "${GOARCH}" = "${HOSTARCH}" ] && {
        return 0
    }
    return 1
}

function isDockerAvailable () {
    docker version 2>/dev/null 1>/dev/null  && {
        return 0
    }
    return 1
}

function isInsideDocker () {
    [ -f /.dockerenv ] && {
        return 0
    }
    return 1
}

function isNumber () {
    case $1 in
        ''|*[!0-9]*) return 1 ;;
    esac

    return 0
}

function isValidInput () {
    ! isNumber $1 && {
        return 1
    }
    # Valid number is between 0 and $COUNT_SELECT_MAX
    [ $1 -ge 0 ] && [ $1 -le $COUNT_SELECT_MAX ] || {
        return 1
    }
    return 0
}

function readInput () {
    echo -n 'Input arg number: '
    while read response; do
        isValidInput $response && {
            NUM_SELECTED=$response
            return 0
        }
        echoHR
        echo 'ERROR: Input out of range. (Must be between 1-6)'
        sleep 1
        echoHelp
        echo -n 'Input arg number: '
    done
}

function setEnvVarToBuild () {
    case $1 in
        1) # linux/arm64
            GOOS=linux
            GOARCH=arm64
            GOARM=
            EXT=
            ;;
        2) # linux/armv5
            GOOS=linux
            GOARCH=arm
            GOARM=5
            EXT=
            ;;
        3) # linux/armv6
            GOOS=linux
            GOARCH=arm
            GOARM=6
            EXT=
            ;;
        4) # linux/armv7
            GOOS=linux
            GOARCH=arm
            GOARM=7
            EXT=
            ;;
        5) # linux/amd64
            GOOS=linux
            GOARCH=amd64
            GOARM=
            EXT=
            ;;
        6) # darwin/amd64
            GOOS=darwin
            GOARCH=amd64
            GOARM=
            EXT=
            ;;
        7) # windows/amd64
            GOOS=windows
            GOARCH=amd64
            GOARM=
            EXT='.exe'
            ;;
        *) echo 'Unknown selection'
            return 1;;
    esac

    return 0
}

# -----------------------------------------------------------------------------
#  Env checks
# -----------------------------------------------------------------------------

isInsideDocker && {
    echoTitle 'Inside Docker'
    cat << HEREDOC
- ERROR: You are running this script inside docker.

This script uses Docker to build the image and currently it does not support Docker in Docker.
If you are running this script on VSCode via Remote-Containers then reopen locally and run this script again.

HEREDOC
    exit 1
}

! isDockerAvailable && {
    echoTitle 'No Docker Found'
    echo '- ERROR: You need Docker installed'
    exit 1
}

# =============================================================================
#  Main
# =============================================================================

# -----------------------------------------------------------------------------
#  Get selected menu number
# -----------------------------------------------------------------------------
NUM_SELECTED=0
[ $# -eq 0 ] && {
    # Show help as selection menu
    echoHelp
    readInput
} || {
    BYPASS_TEST_LOCAL=yes
    NUM_SELECTED=$1
}

isValidInput $NUM_SELECTED || {
    echo 'Not a valid number.'
    exit 1
}

echoTitle 'Pulling base image'
docker pull $NAME_BASE_IMAGE

# -----------------------------------------------------------------------------
#  Loop all arch if "0" was selected then exit
# -----------------------------------------------------------------------------
[ $NUM_SELECTED -eq 0 ] && {
    echoTitle 'Building All Architectures'
    for i in $(seq 1 $COUNT_SELECT_MAX); do
        echo -n "${i}: Building ... "
        ( $PATH_FILE_SCRIPT $i ) 1>/dev/null && echo 'OK' || echo 'Fail. Try: $ ./'$NAME_SCRIPT $i
    done
    result=$?

    echoHR
    echo '- Remove prune containers and images ...'
    defecatePrunes

    [ $result -eq 0 ] && echo '... All done.' || echo '... Build faild.'

    exit $result
}

# -----------------------------------------------------------------------------
#  Single build
# -----------------------------------------------------------------------------
setEnvVarToBuild $NUM_SELECTED || {
    echo 'Failed to set variables to build.'
    exit 1
}

NAME_IMAGE="${NAME_APP}:local"
NAME_BIN_EXPORT="${NAME_APP}-${GOOS}-${GOARCH}${GOARM}${EXT}"
PATH_BIN_EXPORT="${PATH_DIR_BIN}/${NAME_BIN_EXPORT}"

echoTitle ' Build info'
echo 'NAME_APP =' $NAME_APP
echo 'GOOS =' $GOOS
echo 'GOARCH =' $GOARCH
echo 'GOARM =' $GOARM
echo 'Docker image name:' $NAME_IMAGE
echo 'Name of bin file to export:' $NAME_BIN_EXPORT

echoTitle 'Building Docker image and the binary'
cd $PATH_DIR_PARENT
docker build \
    --file $PATH_DIR_SCRIPT/Dockerfile \
    --no-cache \
    --build-arg NAME_APP=$NAME_APP \
    --build-arg GOOS=$GOOS \
    --build-arg GOARCH=$GOARCH \
    --build-arg GOARM=$GOARM \
    -t $NAME_IMAGE \
    . || {
        echo '* Failed to build image.'
        exit 1
    }

echoTitle 'Fetching built binary'

echo '- Copying binary from container to local under ./bin/ ...'
docker run \
    --rm \
    -v $PATH_DIR_BIN:/root/bin \
    $NAME_IMAGE \
    mv -f /$NAME_APP /root/bin/$NAME_BIN_EXPORT

echo '- Remove prune containers and images ...'
docker image rm -f $NAME_IMAGE
defecatePrunes

echoTitle "Bin created: $NAME_BIN_EXPORT"
ls -la $PATH_BIN_EXPORT

# Run the built binary, only if the OS and ARCH are the same between Docker and the host.
isArchSameWithHost && [ "${BYPASS_TEST_LOCAL}" = "no" ] && {
    echoTitle 'Local Test Run'
    read -n1 -p 'Whould you like to run the binary?(y/N): ' yn
        case "$yn" in
            [yY]*)
                echo
                $PATH_BIN_EXPORT
                ;;
            *) echo
                echo "aborted"
            ;;
        esac
}

echoHR
echo '...  done!'
