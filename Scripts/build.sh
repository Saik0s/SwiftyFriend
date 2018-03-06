#!/usr/bin/env bash

set -e

SOURCE=$([[ -z ${BASH_SOURCE[0]} ]] && echo $1 || echo ${BASH_SOURCE[0]})
while [[ -h $SOURCE ]]; do
    DIR=$(cd -P $(dirname "$SOURCE") && pwd)
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
cd $(cd -P $(dirname "$SOURCE") && pwd)

BUILD_CONFIGURATION="debug"
if [ "$1" == "debug" ] || [ "$1" == "release" ]; then
    BUILD_CONFIGURATION=$1
fi
TARGET_NAME="SwiftyFriend"

set -o pipefail &&
swift build -c $BUILD_CONFIGURATION \
-Xswiftc -static-stdlib \
-Xswiftc -no-link-objc-runtime \
-Xswiftc -fixit-all \
-Xswiftc -warn-swift3-objc-inference-complete \
-Xswiftc -update-code \
-Xswiftc -enable-testing \
-Xswiftc -emit-module \
-Xswiftc -emit-dependencies \
-Xswiftc -suppress-warnings &&
cp ".build/$BUILD_CONFIGURATION/$TARGET_NAME" $TARGET_NAME
