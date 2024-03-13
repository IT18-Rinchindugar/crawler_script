#!/bin/bash
# if pm2 is not installed, install it
if ! [ -x "$(command -v pm2)" ]; then
    npm install pm2 -g
fi

# Folder names for crawlers
CRAWLER_NAME_PREFIX=crawler
CRAWLER_COUNT=8

# clone repo and create environment for each crawler
for ((i=0; i<CRAWLER_COUNT; i++)); do
    CRAWLER_NAME="${CRAWLER_NAME_PREFIX}$i"
    # install environment
    cd $CRAWLER_NAME
    # is windows git bash terminal?
    if [ -x "$(command -v winpty)" ]; then
        # windows git bash terminal
        # new terminal to run translate script
        start "Git Bash" "C:\Program Files\Git\git-bash.exe" -i -c "cd $(pwd); pm2 start translate.js --name translate_$CRAWLER_NAME && pm2 logs translate_$CRAWLER_NAME; exec bash"
    else
        # macos terminal
        # new terminal to run script
        osascript -e "tell app \"Terminal\" to do script \"cd $(pwd) && pm2 start translate.js --name translate_$CRAWLER_NAME && pm2 logs translate_$CRAWLER_NAME\""
    fi
    cd ..
done

# done with all crawlers
echo "All crawlers are running"
exit 0
