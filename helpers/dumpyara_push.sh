#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright (C) 2019 Shivam Kumar Jha <jha.shivam3@gmail.com>
#
# Helper functions

# Store project path
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null && pwd )"

# Common stuff
source $PROJECT_DIR/helpers/common_script.sh

# Exit if no arguements
[[ -z "$1" ]] && echo -e "Supply dir's as arguements!" && exit 1

# Exit if missing token's
[[ -z "$GIT_TOKEN" ]] && echo -e "Missing GitHub token. Exiting." && exit 1

# o/p
for var in "$@"; do
    ROM_PATH=$( realpath "$var" )
    [[ ! -d "$ROM_PATH" ]] && echo -e "$ROM_PATH is not a valid directory!" && exit 1
    cd "$ROM_PATH"
    [[ ! -d "system/" ]] && echo -e "No system partition found, pushing cancelled!" && exit 1
    # Set variables
    source $PROJECT_DIR/helpers/rom_vars.sh "$ROM_PATH" > /dev/null 2>&1
    if [ -z "$BRAND" ] || [ -z "$DEVICE" ]; then
        echo -e "Could not set variables! Exiting"
        exit 1
    fi
    BRANCH=$(echo $DESCRIPTION | tr ' ' '-')
    repo=$(echo $BRAND\_$DEVICE\_dump | tr '[:upper:]' '[:lower:]')
    repo_desc=$(echo "$MODEL dump")
    ORG=AndroidDumps
    wget "https://raw.githubusercontent.com/$ORG/$repo/$BRANCH/all_files.txt" 2>/dev/null && echo "Firmware already dumped!" && exit 1

    git init > /dev/null 2>&1
    git checkout -b $BRANCH > /dev/null 2>&1
    find -size +97M -printf '%P\n' -o -name *sensetime* -printf '%P\n' -o -name *.lic -printf '%P\n' > .gitignore
    git remote add origin https://github.com/$ORG/${repo,,}.git > /dev/null 2>&1
    curl -s -X POST -H "Authorization: token ${GIT_TOKEN}" -d '{"name": "'"$repo"'","description": "'"$repo_desc"'","private": false,"has_issues": true,"has_projects": false,"has_wiki": true}' "https://api.github.com/orgs/${ORG}/repos" > /dev/null 2>&1
    echo -e "Dumping extras"
    git add --all > /dev/null 2>&1
    git reset system/ vendor/ > /dev/null 2>&1
    git -c "user.name=AndroidDumps" -c "user.email=AndroidDumps@github.com" commit -asm "Add extras for ${DESCRIPTION}" -q
    git push -q https://$GIT_TOKEN@github.com/$ORG/${repo,,}.git $BRANCH
    [[ -d vendor/ ]] && echo -e "Dumping vendor"
    [[ -d vendor/ ]] && git add vendor/ > /dev/null 2>&1
    [[ -d vendor/ ]] && git -c "user.name=AndroidDumps" -c "user.email=AndroidDumps@github.com" commit -asm "Add vendor for ${DESCRIPTION}" -q
    [[ -d vendor/ ]] && git push -q https://$GIT_TOKEN@github.com/$ORG/${repo,,}.git $BRANCH
    echo -e "Dumping apps"
    git add system/system/app/ system/system/priv-app/ > /dev/null 2>&1 || git add system/app/ system/priv-app/ > /dev/null 2>&1
    git -c "user.name=AndroidDumps" -c "user.email=AndroidDumps@github.com" commit -asm "Add apps for ${DESCRIPTION}" -q
    git push -q https://$GIT_TOKEN@github.com/$ORG/${repo,,}.git $BRANCH
    echo -e "Dumping system"
    git add system/ > /dev/null 2>&1
    git -c "user.name=AndroidDumps" -c "user.email=AndroidDumps@github.com" commit -asm "Add system for ${DESCRIPTION}" -q
    git push -q https://$GIT_TOKEN@github.com/$ORG/${repo,,}.git $BRANCH

    # Telegram channel
    if [ ! -z "$TG_API" ]; then
        CHAT_ID="@android_dumps"
        commit_head=$(git log --format=format:%H | head -n 1)
        commit_link=$(echo "https://github.com/$ORG/$repo/commit/$commit_head")
        printf "<b>Brand: $BRAND</b>" > $PROJECT_DIR/working/tg.html
        printf "\n<b>Device: $DEVICE</b>" >> $PROJECT_DIR/working/tg.html
        printf "\n<b>Version:</b> $VERSION" >> $PROJECT_DIR/working/tg.html
        printf "\n<b>Fingerprint:</b> $FINGERPRINT" >> $PROJECT_DIR/working/tg.html
        printf "\n<b>GitHub:</b>" >> $PROJECT_DIR/working/tg.html
        printf "\n<a href=\"$commit_link\">Commit</a>" >> $PROJECT_DIR/working/tg.html
        printf "\n<a href=\"https://github.com/$ORG/$repo/tree/$BRANCH/\">$DEVICE</a>" >> $PROJECT_DIR/working/tg.html
        TEXT=$(cat $PROJECT_DIR/working/tg.html)
        curl -s "https://api.telegram.org/bot${TG_API}/sendmessage" --data "text=${TEXT}&chat_id=${CHAT_ID}&parse_mode=HTML&disable_web_page_preview=True" > /dev/null
        rm -rf $PROJECT_DIR/working/tg.html
    fi
    cd "$PROJECT_DIR"
done
