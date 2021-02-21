#!/usr/bin/env bash

# Log Each command
set -x

# Bail on first error
set -e

# This shell script simulates running CI/CD after every commit to master.

REPO_ROOT="$(dirname $( cd "$(dirname "$0")" ; pwd -P ))"
BRANCH_NAME=$(git branch --show-current)
CURR_COMMIT_MSG=$(git log -1 --pretty=format:%B)
BASEDIR=$(dirname $0)

if [[ "$BRANCH_NAME" = "master" ]]; then
  echo "On master branch. Commit message is '$CURR_COMMIT_MSG'."
  # Skip commits containg substring "[skip ci]"
  if [[ "$CURR_COMMIT_MSG" == *"[skip ci]"* ]]; then
    echo "Skipping annotated commit."
    exit 0
  fi

  # Skip if this is a version/release commit
  if [[ "$CURR_COMMIT_MSG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Current commit message is a semantic release ($CURR_COMMIT_MSG). Exiting early."
    exit 0
  fi

  # Recursively remove node_modules directories
  find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;

  # Install all node modules
  CURR_DIR=$PWD
  yarn install
  for d in $REPO_ROOT/packages/*; do echo $d && cd $d && yarn install --verbose; done
  cd $CURR_DIR

  npx --no-install lerna version \
    --conventional-commits \
    --force-publish \
    --no-push \
    --exact \
    --yes

  # If necessary, build here
  # e.g., yarn build

  npx --no-install lerna publish from-git --yes

  ### Steps below are unique to example
  git add .verdaccio
  git commit -m "update registry [skip ci]"
  ### Steps above are unique to example

  git push --follow-tags
fi
