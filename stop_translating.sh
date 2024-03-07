#!/bin/bash

# Folder names for crawlers
CRAWLER_NAMES=(crawler1 crawler2 crawler3 crawler4 crawler5 crawler6)
CRAWLER_PORTS=(3000 3001 3002 3003 3004 3005)
PORT_START=3000

# clone repo and create environment for each crawler
for i in "${!CRAWLER_NAMES[@]}"
do
    # pm2 delete
    pm2 delete translate_${CRAWLER_NAMES[$i]}
    # kill it
done

# done with all crawlers
echo "All crawlers are deleted"
exit 0
