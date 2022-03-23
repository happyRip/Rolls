#!/usr/bin/env bash

function getRandom() {
    MIN=${1:-1}
    MAX=${2:-99}
    echo $(($MIN + $RANDOM % $MAX))
}

n=${1:-10}
for (( i = 0; i < n; i++ )); do
    numbers+=( "$(getRandom)" )
done

echo "${numbers[@]}"
