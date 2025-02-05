#!/bin/bash

ionice -p $$ -c 3
renice 20 -p $$ >/dev/null

# TODO: Fix uptime not present in httpd image
#
# MAXLOAD=3
# LOAD=$(uptime | egrep -o -e "load average: [0-9]*"|cut -b 15-)
# if [ $LOAD -ge $MAXLOAD ]; then
# 	echo current load $LOAD is higher than maxload $MAXLOAD, aborting sync
# 	exit
# fi

# checks all 
MODROOT=/
MODINFO=modinfo.lua
PACKAGES="${RAPID_PACKAGES:-/home/packages/www/repos.springrts.com}"
GIT_ROOT="${RAPID_GIT:-/home/packages/git}"
REPOS=$(find $GIT_ROOT -maxdepth 1 -mindepth 1 -type d)

for REPO in $REPOS; do
	cd $REPO
	if git fetch --prune &>/dev/null; then
		LOCAL=$(git rev-parse HEAD)
		REMOTE=$(git rev-parse @{u})
		if [ "$LOCAL" != "$REMOTE" ]; then
			TAG=$(basename $REPO)
			(
			echo Stated: $(date)
			echo Updating $REPO from $(git config --get remote.origin.url)
			git pull
			git checkout master
			git reset --hard HEAD~1
			git submodule sync --recursive
			git submodule update --recursive --remote --init
			BuildGit "$REPO" "$MODROOT" "$MODINFO" "$PACKAGES/$TAG" "$REMOTE" "$TAG"
			echo Finished: $(date)
			) &> $PACKAGES/$TAG/log.txt
		fi
	fi
done
