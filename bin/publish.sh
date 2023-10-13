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
    -e 's,\*`,***,g' -e 's,`\*,***,g' \
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
    -V papersize=A4 \
    $DEST/2-$NAME.md \
    -o $DEST/3-$NAME.odt
}
# mk_odt

mk_pdf()
{
    # -s \
    # -V colorlinks=true \
    # --wrap=preserve \
pandoc \
    -f gfm \
    -t pdf \
    --wrap=preserve \
    --toc \
    --pdf-engine=wkhtmltopdf \
    --metadata=title:"АРМ С3000: быстрый старт" \
    $DEST/2-$NAME.md \
    -o $DEST/3-$NAME.pdf
}
# mk_pdf

mk_pdf_2()
{
pandoc \
    -f gfm \
    -t pdf \
    --metadata=title:"АРМ С3000: быстрый старт" \
    $DEST/2-$NAME.md \
    -o $DEST/3-$NAME.pdf
}
mk_pdf_2

mk_html()
{
pandoc \
    -f gfm \
    -t html \
    --wrap=preserve \
    --toc \
    --metadata=title:"АРМ С3000: быстрый старт" \
    $DEST/2-$NAME.md \
    -o $DEST/3-$NAME.html
}
# mk_html

