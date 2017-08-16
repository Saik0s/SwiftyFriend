#!/usr/bin/env bash

set -e

SOURCE=$([[ -z ${BASH_SOURCE[0]} ]] && echo $1 || echo ${BASH_SOURCE[0]})
while [[ -h $SOURCE ]]; do
    DIR=$(cd -P $(dirname "$SOURCE") && pwd)
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
cd $(cd -P $(dirname "$SOURCE") && pwd)

swift package generate-xcodeproj --enable-code-coverage
