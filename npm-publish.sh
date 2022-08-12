#!/usr/bin/env bash

# This script is used to publish Classy Node version

set -e

VERSIONTYPE=$1

if [[ $VERSIONTYPE == "" ]]; then
    echo "Please provide version type major/minor/patch"
	exit 1
fi

# Current branch - Determine current git branch, store in $currentbranch, and exit if not on a branch
if ! currentbranch=$(git symbolic-ref --short -q HEAD)
then
	echo We are not currently on a branch.
	exit 1
fi

# Uncommited Changes - Exit script if there uncommited changes
if ! git diff-index --quiet HEAD --; then
	echo "There are uncommited changes on this repository."
	exit 1
fi

currentbranch=$(git symbolic-ref --short -q HEAD)

if [ "$currentbranch" != "master" ];
then
    echo "Checking out the master branch and taking update"
    git checkout master && git pull origin master
    printf "\n"
else 
    echo Currently on master branch
    printf "\n"
fi

currentbranch=$(git symbolic-ref --short -q HEAD)

# Current branch - Determine current git branch, store in $currentbranch, and exit if not on a branch
if [ "$currentbranch" != "master" ];
then
	echo "There is problem to checkout the master branch"
	exit 1
fi

export NVM_DIR=$HOME/.nvm
source $NVM_DIR/nvm.sh

# Clean install node modules
echo "install packages"
nvm use # && yarn install --frozen-lockfile
printf "\n"

# Run tests
if [[ $(yarn run test | grep -o 'failing') == "failing" ]];
then
    printf "Tests Failed\n"
    exit 1
else
    printf "Tests Succeded\n"
fi

printf "Running build\n"
yarn run build

printf "Creating version\n"
yarn version --${VERSIONTYPE}

printf "Publishing version\n"
yarn publish

printf "Pushing to git\n"
git push && git push --tags

