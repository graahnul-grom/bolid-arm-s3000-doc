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
    -e 's,\*\*iso\*\*,<nobr>**ИСО Орион**</nobr>,g' \
    -e 's,\*\*pro\*\*,<nobr>**АРМ Орион Про**</nobr>,g' \
    -e 's,\*\*s3k\*\*,<nobr>**АРМ С3000**</nobr>,g' \
    -e 's,\*\*s2k-eth\*\*,<nobr>**С2000-Ethernet**</nobr>,g' \
    -e 's,\*\*s2km\*\*,**С2000М**,g' \
    -e 's,\*\*s2km2\*\*,<nobr>**С2000М исп. 02**</nobr>,g' \
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
    # TODO: toc links gets encoded => can't follow
    #       (--toc)
    # --metadata=title:"АРМ С3000: быстрый старт" \ => extra title
    # poh: -V margin-left=0 -V margin-right=0 -V margin-top=0 -V margin-bottom=0 \
pandoc \
    -f gfm \
    -t pdf \
    --wrap=preserve \
    --standalone \
    -V margin-left=1cm -V margin-right=1cm -V margin-top=1cm -V margin-bottom=1cm \
    --pdf-engine=wkhtmltopdf \
    $DEST/2-$NAME.md \
    -o $DEST/3-$NAME.pdf
}
mk_pdf

mk_pdf_2()
{
# --pdf-engine-opt=--no-toc-relocation.
    # -V fontenc=T2A \
    # -V lang -V babel-lang=russian \
pandoc \
    -f gfm \
    -t pdf \
    --pdf-engine=xelatex -V mainfont="Open Sans" \
    --standalone \
    --metadata=title:"АРМ С3000: быстрый старт" \
    $DEST/2-$NAME.md \
    -o $DEST/3-$NAME.pdf
}
# mk_pdf_2

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

