#!/usr/bin/env bash
set -xeu -o pipefail
shopt -s failglob 
export GOVENDOR=${GOVENDOR:="/home/bclow/govendor"}
export GOHOME=${GOHOME:="/home/bclow/tmp/go1.10/go"}

dname=$(readlink -f $(dirname $0))
cd $dname/..
export GOPATH="$dname/../../.."

git_dirty() {
    official="$1"
    project="$2"

#    cd "$dname/.."
    if test "$official" = "1"
    then
        if test ! -z "$(git status --porcelain)"
        then
            git status
            echo ""
            echo ""
            echo ""
            echo "git status is not clean"
            exit 1
        fi
    fi

#    cd "$dname"
}


build() {
    project="$1"

#    cd "$dname/.."
    git_rev=$(git rev-parse HEAD)
    $GOVENDOR/bin/govendor update $project

    go_rev=$($GOHOME/bin/go version)
    go_rev=${go_rev//\ /__}
    build_host=$(hostname)
    # main.go_version_str="$go_rev"
#    $GOHOME/bin/go build -ldflags "-X main.git_version_str=${git_rev} -X main.go_version_str=${go_rev}" $project/cmd/$project
    $GOHOME/bin/go install -ldflags "-X main.git_version_str=${build_host}@${git_rev} -X main.go_version_str=${go_rev}" $project/cmd/$project
}


official=${1:-"1"}
project=${2:-"imageproxy"}
git_dirty $official $project  && build $project 




