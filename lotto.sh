#!/usr/bin/env bash

N=${1:-1}

for (( i = 0; i < N; i++ )); do
    ./rolls.sh -n 6 -m 1 -M 49 -d ' '
done
