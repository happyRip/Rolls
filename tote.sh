#!/usr/bin/env bash
# shellcheck disable=SC2251
# https://github.com/koalaman/shellcheck/wiki/SC2251#exceptions

# name comes from
# https://en.wikipedia.org/wiki/Tote_board

set -o errexit -o pipefail -o noclobber -o nounset
check_success() { [ $? -eq 0 ] || exit 1; }

! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo "'getopt --test' failed in this environment"
    exit 1
fi

function show_help() {
    echo "Help not yet ready"
}

OPTIONS=f:h
LONGOPTS=file:,help

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

FILE=''
while true; do
    case "$1" in
        -f|--file)
            FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [[ $# -gt 0 ]]; then

    if [[ $# -ne 1 ]]; then
        echo "$0: couldnt parse '$*'"
        exit 4
    fi

    if [[ ${FILE} -ne '' ]]; then
        echo "$0: couldnt parse '$*'"
        exit 4
    fi

    FILE="$1"
    shift
fi

echo "File: ${FILE}"

while IFS= read -r line; do
    printf "Line: %d | " "${line}"
    grep -wE "${line}" "${FILE}" | tr '\n' ' '
    echo
done
