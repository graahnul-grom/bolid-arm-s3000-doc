#!/bin/sh

# NAME="$1"

NAME=quick-start
TITLE="arm_s3000_quick_start"
# TITLE="АРМ_С3000_быстрый_старт"

# NAME=docker-linux
# TITLE="arm_s3000_docker_linux"
# TITLE="АРМ_С3000_установка_образов_Docker_в_ОС_Linux"

# NAME=docker-windows
# TITLE="arm_s3000_docker_windows"
# TITLE="АРМ_С3000_установка_образов_Docker_в_ОС_Windows"

# NAME=windows
# TITLE="arm_s3000_windows"
# TITLE="АРМ_С3000_установка_в_ОС_Windows"



REPO=$HOME/s3k.git
BIN=$REPO/bin
SRC="${REPO}/${NAME}.md"
DEST=$REPO/pub
TMP=$DEST/tmp
WIP="${TMP}/${NAME}.md"

[ -n "$NAME" ] || { echo ".. !NAME"; exit 1; }
mkdir -p $DEST || { echo ".. !mkdir DEST"; exit 1; }
mkdir -p $DEST/res || { echo ".. !mkdir DEST/res"; exit 1; }
mkdir -p $TMP || { echo ".. !mkdir TMP"; exit 1; }
[ -r $SRC ] || { echo ".. !SRC"; exit 1; }



# remove comments
#
cp -a $SRC $WIP
vim -c "source $BIN/p2_rm_comments.vim" $WIP

exit $?



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
mk_odt

mk_pdf()
{
    local MAR=$1
    # TODO: toc links gets encoded => can't follow
    #       (--toc)
    # --metadata=title:"АРМ С3000: быстрый старт" \ => extra title
    # poh: -V margin-left=0 -V margin-right=0 -V margin-top=0 -V margin-bottom=0 \
    # -V margin-left=1cm -V margin-right=1cm -V margin-top=1cm -V margin-bottom=1cm \
pandoc \
    -f gfm \
    -t pdf \
    --wrap=preserve \
    --standalone \
    -V margin-left=$MAR -V margin-right=$MAR -V margin-top=$MAR -V margin-bottom=$MAR \
    --pdf-engine=wkhtmltopdf \
    $DEST/2-$NAME.md \
    -o $DEST/3-$NAME.pdf
}
# mk_pdf "0.5cm"
# mk_pdf "0"

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



# rename, copy the resulting file
#
cp $DEST/3-$NAME.odt \
    $DEST/res/"${TITLE}_`date +'%y_%m_%d'`".odt

# cp $DEST/3-$NAME.pdf \
    # $DEST/res/"${TITLE}_`date +'%y_%m_%d'`".pdf

