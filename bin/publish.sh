#!/bin/sh

NAME=quick-start

REPO=$HOME/s3k.git
SRC="${REPO}/${NAME}.md"
DEST=$REPO/pub

mkdir -p $DEST || { echo ".. !mkdir DEST"; exit 1; }
[ -r $SRC ] || { echo ".. !SRC"; exit 1; }

# FAIL: sed -E -e 's,<!--.*?-->,,g' $SRC | less
# https://stackoverflow.com/questions/4055837/delete-html-comment-tags-using-regexp
sed -e :a -re 's/<!--.*?-->//g;/<!--/N;//ba' \
    $SRC > \
    $DEST/0-$NAME.md

# TODO: don't replace " (quote) in image tags
# TODO: replace right " (quote) before punctuations
#
sed -E \
    -e 's,\*\*iso\*\*,**ИСО Орион**,g' \
    -e 's,\*\*pro\*\*,**АРМ Орион Про**,g' \
    -e 's,\*\*s3k\*\*,**АРМ С3000**,g' \
    -e 's,\*\*s2k-eth\*\*,**С2000-Ethernet**,g' \
    -e 's,\*\*s2km\*\*,**С2000М**,g' \
    -e 's,\*\*s2km2\*\*,**С2000М исп. 02**,g' \
    -e 's/ - / — /g' \
    -e 's,(^| )",\1«,g' -e 's,"( |$),»\1,g' \
    $DEST/0-$NAME.md > \
    $DEST/1-$NAME.md

