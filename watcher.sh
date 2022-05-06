#!/usr/bin/env bash

FILE_NAME="${1:-/home/pi/jackpot.out}"

while inotifywait -e close_write "${FILE_NAME}" &> /dev/null; do
	clear; cat "${FILE_NAME}"
done
