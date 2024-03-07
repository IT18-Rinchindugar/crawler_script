#!/bin/bash
# if pm2 is not installed, install it
if ! [ -x "$(command -v pm2)" ]; then
    npm install pm2 -g
fi

# Folder names for crawlers
CRAWLER_NAMES=(crawler1 crawler2 crawler3 crawler4 crawler5 crawler6)
CRAWLER_PORTS=(3000 3001 3002 3003 3004 3005)
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
        start "Git Bash" "C:\Program Files\Git\git-bash.exe" -i -c "cd $(pwd); pm2 start translate.js --name translate_${CRAWLER_NAMES[$i]} && pm2 logs translate_${CRAWLER_NAMES[$i]}; exec bash"
    else
        # macos terminal
        # new terminal to run script
        osascript -e "tell app \"Terminal\" to do script \"cd $(pwd) && pm2 start translate.js --name translate_${CRAWLER_NAMES[$i]} && pm2 logs translate_${CRAWLER_NAMES[$i]}\""

    fi
    cd ..
done

# done with all crawlers
echo "All crawlers are running"
exit 0
