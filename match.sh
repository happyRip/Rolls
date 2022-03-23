#!/usr/bin/env bash

sum=0
while read -r line; do
    matched=$(grep -wc "$line" "$1")
    (( sum += matched ))
done

echo $sum
