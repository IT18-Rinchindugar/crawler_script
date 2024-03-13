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
    # is windows git bash terminal?
    if [ -x "$(command -v winpty)" ]; then
        # windows git bash terminal
        # new terminal to run translate script
        start "Git Bash" "C:\Program Files\Git\git-bash.exe" -i -c "cd $(pwd); pm2 start translate.js --name translate_$CRAWLER_NAME && pm2 logs translate_$CRAWLER_NAME; exec bash"
    elif [ "$(uname)" = "Darwin" ]; then
        # macos terminal
        # new terminal to run script
        osascript -e "tell app \"Terminal\" to do script \"cd $(pwd) && pm2 start translate.js --name translate_$CRAWLER_NAME && pm2 logs translate_$CRAWLER_NAME\""
    elif [ "$(lsb_release -is)" = "Ubuntu" ]; then
        # ubuntu terminal
        # new terminal to run script
        gnome-terminal -- bash -c "cd $(pwd); pm2 start translate.js --name translate_$CRAWLER_NAME && pm2 logs translate_$CRAWLER_NAME; exec bash"
    else
        echo "Unsupported system"
    fi
    cd ..
done

# done with all crawlers
echo "All crawlers are running"
exit 0
