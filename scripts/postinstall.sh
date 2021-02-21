REPO_ROOT="$(dirname $( cd "$(dirname "$0")" ; pwd -P ))"

for d in $REPO_ROOT/packages/*; do echo $d && cd $d && yarn install; done

cd $REPO_ROOT
