#!/bin/bash

# if pm2 is not installed, install it
if ! [ -x "$(command -v pm2)" ]; then
    npm install pm2 -g
fi

# Load values from .env file
source .env

# Now you can use the values
echo "Crawler repo: $CRAWLER_REPO"
echo "Crawler name prefix: $CRAWLER_NAME_PREFIX"
echo "Crawler count: $CRAWLER_COUNT"
echo "Crawler start port: $CRAWLER_START_PORT"

# clone repo and create environment for each crawler
for ((i=0; i<CRAWLER_COUNT; i++)); do
    CRAWLER_NAME="${CRAWLER_NAME_PREFIX}$i"
    git clone $CRAWLER_REPO $CRAWLER_NAME
    # is windows git bash terminal?
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
    cd $CRAWLER_NAME
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