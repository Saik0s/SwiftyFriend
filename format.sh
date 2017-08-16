#!/usr/bin/env bash

set -e

[[ ! -z ${JOB_NAME} ]] && echo "Skip pre compile script on Jenkins" && exit 0

START=$(date +%s)
echo "Starting pre-compile-action"

SOURCE=$([[ -z ${BASH_SOURCE[0]} ]] && echo $1 || echo ${BASH_SOURCE[0]})
while [[ -h $SOURCE ]]; do
    DIR=$(cd -P $(dirname "$SOURCE") && pwd)
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
cd $(cd -P $(dirname "$SOURCE") && pwd)

[[ -n ${SRCROOT} ]] || SRCROOT="$PWD"

ERR_NO_SL="warn: SwiftLint is not installed. Visit http://github.com/realm/SwiftLint to learn more."
ERR_NO_SF="warn: SwiftFormat is not installed. Visit https://github.com/nicklockwood/SwiftFormat to learn more."

SWIFT_LINT="swiftlint"
command -v "${SWIFT_LINT}" >/dev/null 2>&1 || {
    echo "${ERR_NO_SL}";
    exit 0;
}

SWIFT_FORMAT="swiftformat"
command -v "${SWIFT_FORMAT}" >/dev/null 2>&1 || {
    echo "${ERR_NO_SF}";
    exit 0;
}


[[ -f ${SRCROOT}/.swiftlint.yml ]] || {
    echo ".swiftlint.yml is required";
    exit 0;
}
[[ -f ${SRCROOT}/.swiftformat.params ]] || {
    echo ".swiftformat.params is required";
    exit 0;
}

echo "Auto correcting"
${SWIFT_LINT}  autocorrect || true

echo "Linting"
${SWIFT_LINT}  lint || true

echo "Formatting"
FORMAT_ARGS=""
while read -r line; do
    [[ $line == --* ]] && FORMAT_ARGS+=" $line " || FORMAT_ARGS+=$line
done < <( cat  ${SRCROOT}/.swiftformat.params )
echo "Going to use  ${SWIFT_FORMAT}  with args:  ${FORMAT_ARGS} "
${SWIFT_FORMAT} ${SRCROOT} ${FORMAT_ARGS} || true

END=$(date +%s)
DIFF=$[ $END - $START ]
echo "Finish format after $DIFF seconds"
exit 0
