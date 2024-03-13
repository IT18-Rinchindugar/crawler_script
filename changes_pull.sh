#!/bin/bash
# if pm2 is not installed, install it
if ! [ -x "$(command -v pm2)" ]; then
    npm install pm2 -g
fi

# Folder names for crawlers
CRAWLER_NAME_PREFIX=crawler
CRAWLER_COUNT=8

# clone repo and create environment for each crawler
for ((i=0; i<CRAWLER_COUNT; i++)); do
    CRAWLER_NAME="${CRAWLER_NAME_PREFIX}$i"
    # install environment
    cd $CRAWLER_NAME
    git stash
    git pull
    cd ..
done

# done with all crawlers
echo "All crawlers are running"
exit 0
