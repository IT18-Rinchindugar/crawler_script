#!/bin/bash

# Folder names for crawlers
CRAWLER_NAME_PREFIX=crawler
CRAWLER_COUNT=8

# delete each crawler
for ((i=0; i<CRAWLER_COUNT; i++)); do
    CRAWLER_NAME="${CRAWLER_NAME_PREFIX}$i"
    # pm2 delete
    pm2 delete translate_$CRAWLER_NAME
done

# done with all crawlers
echo "All crawlers are deleted"
exit 0