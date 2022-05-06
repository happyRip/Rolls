#!/usr/bin/env bash

N=${1:-25000}
MAGIC_ROOT=${2:-~/.local/tmp}
MAGIC_FILE="${MAGIC_ROOT}/magic_numbers-${RANDOM}"

true > "${MAGIC_FILE}"
for (( i = 0; i < N; i++ )); do
	rolls -n 6 -m 1 -M 49 -d ' ' >> "${MAGIC_FILE}"
done
