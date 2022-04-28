#!/usr/bin/env bash
# shellcheck disable=SC2251
# https://github.com/koalaman/shellcheck/wiki/SC2251#exceptions

set -o errexit -o pipefail -o noclobber -o nounset
# check_success() { [ $? -eq 0 ] || exit 1; }

! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo "'getopt --test' failed in this environment"
    exit 1
fi

function show_help() {
    echo "Help not yet ready"
}

OPTIONS=n:m:M:d:uh
LONGOPTS=numbers:,minimum-value:,maximum-value:,delimeter:,unique:help

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

n=10 min=1 max=99 d=' ' unique=false
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
        -u|--unique)
            unique=true
            shift
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
    echo "$0: couldnt parse '$*'"
    exit 4
fi


if [[ ${unique} && ${n} -gt $(( max - min )) ]]; then
    echo "$0: Not enough range to support that amount of unique numbers"
    exit 5
fi

function getRandom() {
    echo $((min + RANDOM % (max-min+1)))
}

function getOutput() {
    local _OUTPUT
    _OUTPUT=$(printf "$d%d" "${numbers[@]}")
    _OUTPUT=${_OUTPUT#?}
    echo "${_OUTPUT}"
}

for (( i = 0; i < n; i++ )); do
    random="$(getRandom)"
    ${unique} && while [[ "${numbers[*]}" =~ ${random} ]]; do
        random="$(getRandom)"
    done
    numbers+=("${random}")
done
getOutput
