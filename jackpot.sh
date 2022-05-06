#!/bin/bash

SOURCE_FOLDER="${1:-/tmp/Hazard}"
KEY_FILE="magic_numbers"
OUT_FILE="/home/pi/jackpot.out"

PATH="${PATH}:/home/pi/.local/bin"

rolls -n 6 -m 1 -M 49 -u > "${KEY_FILE}"
tote "${KEY_FILE}" -f $(find "${SOURCE_FOLDER}" -type f | paste -sd ' ') > "${OUT_FILE}"

rm -rf "${SOURCE_FOLDER}" &> /dev/null \
&& mkdir "${SOURCE_FOLDER}" &> /dev/null
