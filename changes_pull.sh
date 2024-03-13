#!/bin/bash
# if pm2 is not installed, install it
if ! [ -x "$(command -v pm2)" ]; then
    npm install pm2 -g
fi

# Load values from .env file
source .env

# Now you can use the values
echo "Crawler name prefix: $CRAWLER_NAME_PREFIX"
echo "Crawler count: $CRAWLER_COUNT"

# clone repo and create environment for each crawler
for ((i=0; i<CRAWLER_COUNT; i++)); do
    CRAWLER_NAME="${CRAWLER_NAME_PREFIX}$i"
    # install environment
    cd $CRAWLER_NAME
    git pull
    cd ..
done

# done with all crawlers
echo "All crawlers are updated"
exit 0
