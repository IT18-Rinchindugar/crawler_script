#!/bin/bash

# Load values from .env file
source .env

# Now you can use the values
echo "Crawler name prefix: $CRAWLER_NAME_PREFIX"
echo "Crawler count: $CRAWLER_COUNT"

# delete each crawler
for ((i=0; i<CRAWLER_COUNT; i++)); do
    CRAWLER_NAME="${CRAWLER_NAME_PREFIX}$i"
    # pm2 delete
    pm2 delete translate_$CRAWLER_NAME
done

# done with all crawlers
echo "All crawlers are deleted"
exit 0