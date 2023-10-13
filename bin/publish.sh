#!/bin/sh

NAME=quick-start

REPO=$HOME/s3k.git
SRC="${REPO}/${NAME}.md"
DEST=$REPO/pub

mkdir -p $DEST || { echo ".. !mkdir DEST"; exit 1; }
[ -r $SRC ] || { echo ".. !SRC"; exit 1; }

# FAIL: sed -E -e 's,<!--.*?-->,,g' $SRC | less

# https://stackoverflow.com/questions/4055837/delete-html-comment-tags-using-regexp
sed -e :a -re 's/<!--.*?-->//g;/<!--/N;//ba' $SRC > $DEST/0-$NAME.md

