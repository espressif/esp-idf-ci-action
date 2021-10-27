#!/usr/bin/env bash
set -e

TARGET="$1"
CODE_PATH="$2"

. $IDF_PATH/export.sh

cd "${CODE_PATH}"

idf.py set-target "${TARGET}"

idf.py build
