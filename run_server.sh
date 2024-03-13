#!/bin/bash

# if pm2 is not installed, install it
if ! [ -x "$(command -v pm2)" ]; then
    npm install pm2 -g
fi

# Folder names for crawlers
CRAWLER_NAME_PREFIX=crawler
CRAWLER_COUNT=8
CRAWLER_START_PORT=3000

# kill all running crawlers by crawler ports
for ((i=0; i<CRAWLER_COUNT; i++)); do
    # Calculate the port for this crawler
    PORT=$(($CRAWLER_START_PORT+$i))
    # kill it
    lsof -i :$PORT/tcp | awk 'NR!=1 {print $2}' | xargs kill
done

# clone repo and create environment for each crawler
for ((i=0; i<CRAWLER_COUNT; i++)); do
    CRAWLER_NAME="${CRAWLER_NAME_PREFIX}$i"
    cd $CRAWLER_NAME
    if [ -x "$(command -v winpty)" ]; then
        sed -i "s/^PORT=.*/PORT=$(($CRAWLER_START_PORT+$i))/" "$CRAWLER_NAME/.env"
    elif [ "$(uname)" = "Darwin" ]; then
        sed -i '' "s/^PORT=.*/PORT=$(($CRAWLER_START_PORT+$i))/" "$CRAWLER_NAME/.env"
    elif [ "$(lsb_release -is)" = "Ubuntu" ]; then
        sed -i "s/^PORT=.*/PORT=$(($CRAWLER_START_PORT+$i))/" "$CRAWLER_NAME/.env"
    else
        echo "Unsupported system"
    fi
    # install environment
    npm install
    # build and run
    npm run build
    pm2 start dist/app.js --name "${CRAWLER_NAME}_$(($CRAWLER_START_PORT+$i))"
    # done with this crawler
    echo "Crawler $CRAWLER_NAME is running on port $(($CRAWLER_START_PORT+$i))"
    cd ..
done

# done with all crawlers
echo "All crawlers are running"
exit 0
