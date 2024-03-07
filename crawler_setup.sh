#!/bin/bash

# if pm2 is not installed, install it
if ! [ -x "$(command -v pm2)" ]; then
    npm install pm2 -g
fi

# Crawler repo
CRAWLER_REPO=https://github.com/IT18-Rinchindugar/bundle.git

# Folder names for crawlers
CRAWLER_NAMES=(crawler1 crawler2 crawler3 crawler4 crawler5 crawler6)
CRAWLER_PORTS=(3000 3001 3002 3003 3004 3005)
PORT_START=3000

# clone repo and create environment for each crawler
for i in "${!CRAWLER_NAMES[@]}"
do
    git clone $CRAWLER_REPO ${CRAWLER_NAMES[$i]}
    # is windows git bash terminal?
    if [ -x "$(command -v winpty)" ]; then
        sed -i "s/^PORT=.*/PORT=$(($PORT_START+$i))/" "${CRAWLER_NAMES[$i]}/.env"
    else
        sed -i '' "s/^PORT=.*/PORT=$(($PORT_START+$i))/" "${CRAWLER_NAMES[$i]}/.env"
    fi
    # install environment
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
