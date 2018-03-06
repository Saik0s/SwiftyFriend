#!/usr/bin/env bash

set -e

SOURCE=$([[ -z ${BASH_SOURCE[0]} ]] && echo $1 || echo ${BASH_SOURCE[0]})
while [[ -h $SOURCE ]]; do
    DIR=$(cd -P $(dirname "$SOURCE") && pwd)
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
cd $(cd -P $(dirname "$SOURCE") && pwd)

DERIVED_DATA="DerivedData"
SCHEME_NAME="SwiftyFriend-Package"

rm -rf $DERIVED_DATA &&
set -o pipefail &&
xcodebuild test \
    -scheme $SCHEME_NAME \
    -destination "platform=macOS,arch=x86_64" \
    -derivedDataPath $DERIVED_DATA \
    ENABLE_TESTABILITY=YES \
    GCC_GENERATE_DEBUGGING_SYMBOLS=NO \
    RUN_CLANG_STATIC_ANALYZER=NO \
    | xcpretty -t --color --report html \
    --output xcode-test-results-Recipes.html
