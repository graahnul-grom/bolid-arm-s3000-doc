#!/bin/sh

NAME=quick-start

REPO=$HOME/s3k.git
SRC="${REPO}/${NAME}.md"
DEST=$REPO/pub

mkdir -p $DEST || { echo ".. !mkdir DEST"; exit 1; }
[ -r $SRC ] || { echo ".. !SRC"; exit 1; }

# remove comments
#
# FAIL: sed -E -e 's,<!--.*?-->,,g' $SRC | less
# https://stackoverflow.com/questions/4055837/delete-html-comment-tags-using-regexp
sed -e :a -re 's/<!--.*?-->//g;/<!--/N;//ba' \
    $SRC > \
    $DEST/1-$NAME.md

# replace placeholders, typographics
#
sed -E \
    -e 's,\*\*iso\*\*,**ИСО Орион**,g' \
    -e 's,\*\*pro\*\*,**АРМ Орион Про**,g' \
    -e 's,\*\*s3k\*\*,**АРМ С3000**,g' \
    -e 's,\*\*s2k-eth\*\*,**С2000-Ethernet**,g' \
    -e 's,\*\*s2km\*\*,**С2000М**,g' \
    -e 's,\*\*s2km2\*\*,**С2000М исп. 02**,g' \
    -e 's/ -( |$)/ —\1/g' \
    -e 's,(^|\(| )",\1«,g' -e 's/"( |$|.|,|\)|!|\?)/»\1/g' \
    $DEST/1-$NAME.md > \
    $DEST/2-$NAME.md

# convert
# NOTE: gfm - "GitHub-Flavored Markdown"

mk_odt()
{
    # -f gfm \
    # -f markdown \
pandoc \
    -f gfm \
    -t odt \
    --wrap=preserve \
    -V papersize=A4 \
    $DEST/2-$NAME.md \
    -o $DEST/3-$NAME.odt
}

mk_pdf()
{
pandoc \
    -f gfm \
    -t pdf \
    -V papersize=a4 \
    -V colorlinks=true \
    --toc \
    --pdf-engine=wkhtmltopdf \
    $DEST/2-$NAME.md \
    -s \
    -o $DEST/3-$NAME.pdf
}


mk_odt
# mk_pdf

