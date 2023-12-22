#!/bin/bash

# Crawler repo
CRAWLER_REPO=https://github.com/IT18-Rinchindugar/bundle.git

# Folder names for crawlers
CRAWLER_NAMES=(crawler1 crawler2 crawler3 crawler4 crawler5 crawler6)
CRAWLER_PORTS=(3001 3002 3003 3004 3005 3006)
PORT_START=3000

# clone repo and create environment for each crawler
for i in "${!CRAWLER_NAMES[@]}"
do
    # install environment
    cd ${CRAWLER_NAMES[$i]}
    # is windows git bash terminal?
    if [ -x "$(command -v winpty)" ]; then
        # windows git bash terminal
        # new terminal to run translate script
    else
        # macos terminal
        # new terminal to run script
        osascript -e "tell app \"Terminal\" to do script \"cd $(pwd) &&  ./translate\""

    fi
    cd ..
done

# done with all crawlers
echo "All crawlers are running"
exit 0
