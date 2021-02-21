#!/usr/bin/env bash

# Log Each command
set -x

# Bail on first error
set -e

REPO_ROOT="$(dirname $( cd "$(dirname "$0")" ; pwd -P ))"

V_PATH=$REPO_ROOT/.verdaccio

docker run --name verdaccio -d \
  -p 4873:4873 \
  -v $V_PATH/conf:/verdaccio/conf \
  -v $V_PATH/storage:/verdaccio/storage \
  -v $V_PATH/plugins:/verdaccio/plugins \
  verdaccio/verdaccio:4.11.0
