#!/usr/bin/env bash

sum=0
while read line; do
    matched=$(grep -c "$line" $1)
    $(( sum += matched ))
done < <(echo "$FILECONTENT")

echo $sum
