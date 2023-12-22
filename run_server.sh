#!/bin/bash

# if pm2 is not installed, install it
if ! [ -x "$(command -v pm2)" ]; then
    npm install pm2 -g
fi

# Folder names for crawlers
CRAWLER_NAMES=(crawler1 crawler2 crawler3 crawler4 crawler5 crawler6)
CRAWLER_PORTS=(3001 3002 3003 3004 3005 3006)
PORT_START=3000

# kill all running crawlers by crawler ports
for i in "${!CRAWLER_PORTS[@]}"
do
    # kill it
    lsof -i :${CRAWLER_PORTS[$i]}/tcp | awk 'NR!=1 {print $2}' | xargs kill
done

# clone repo and create environment for each crawler
for i in "${!CRAWLER_NAMES[@]}"
do
    cd ${CRAWLER_NAMES[$i]}
    npm install
    # build and run
    npm run build
    pm2 start dist/app.js --name "${CRAWLER_NAMES[$i]}_${CRAWLER_PORTS[$i]}"
    # done with this crawler
    echo "Crawler ${CRAWLER_NAMES[$i]} is running on port ${CRAWLER_PORTS[$i]}"
    cd ..
done

# done with all crawlers
echo "All crawlers are running"
exit 0
