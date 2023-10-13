#!/bin/sh

NAME=quick-start

REPO=$HOME/s3k.git
SRC="${REPO}/${NAME}.md"
DEST=$REPO/pub

mkdir -p $DEST || { echo ".. !mkdir DEST"; exit 1; }
[ -r $SRC ] || { echo ".. !SRC"; exit 1; }

