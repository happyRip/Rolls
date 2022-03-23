#!/usr/bin/env bash
# shellcheck disable=SC2251
# https://github.com/koalaman/shellcheck/wiki/SC2251#exceptions

set -o errexit -o pipefail -o noclobber -o nounset
check_success() { [ $? -eq 0 ] || exit 1; }

! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo "'getopt --test' failed in this environment"
    exit 1
fi

OPTIONS=n:m:M:d:
LONGOPTS=numbers:,minimum-value:,maximum-value:,delimeter:

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

n=10 min=1 max=99 d=' '
while true; do
    case "$1" in
        -n|--numbers)
            n="$2"
            shift 2
            ;;
        -m|--minimum-value)
            min="$2"
            shift 2
            ;;
        -M|--maximum-value)
            max="$2"
            shift 2
            ;;
        -d|--delimeter)
            d="$2"
            shift 2
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
    echo "$0: couldnt parse '$*'"
    exit 4
fi

function getRandom() {
    echo $((min + RANDOM % (max-min+1)))
}

function getOutput() {
    local output delimeter_length
    output=$(printf "$d%d" "${numbers[@]}")
    delimeter_length=${#d}
    for (( i=0; i < delimeter_length; i++ )); do output=${output:1}; done
    echo "${output}" | awk '{$1=$1};1'
}

for (( i = 0; i < n; i++ )); do
    numbers+=("$(getRandom)")
done
getOutput