#!/usr/bin/env bash
set -xeu -o pipefail
shopt -s failglob 
dname=$(readlink -f $(dirname $0))

export GOVENDOR=${GOVENDOR:="$dname"}
export GOHOME=${GOHOME:="/home/bclow/tmp/go1.10/go"}
export GOPATH="$dname/../../.."
source $dname/libbuild.sh

vendor_update() {
    $GOVENDOR/govendor update $project
}


official=${1:-"1"}
project=${2:-"imageproxy"}
cd $dname/..
git_dirty $official $project  && vendor_update




