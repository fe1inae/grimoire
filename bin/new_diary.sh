#!/bin/sh

# func to header (====...) a string
header_me() {
    for i in $(seq 1 "$(printf '%s' "$1" | wc -m)"); do
        printf '='
    done
}

# get dates in two formats
DATE_META="$(date "+%Y%m%d")"
DATE_LONG="$(date +"%B %d, %Y")"

# make outfile
OUTFILE="source/diary/$DATE_META.md"

# error if file alreay exists
if [ -f "$OUTFILE" ]; then
    printf 'error: file %s exists\n' "$OUTFILE"
    printf 'press any key to open in editor...\n'
    read
	$EDITOR "$OUTFILE"
	exit
fi

# get title from user
printf 'enter title: '
read -r TITLE

# write template to file
printf '%s\n' "---
title: '$TITLE'
date: '$DATE_META'
backurl: 'index.md'
---

$DATE_LONG
$(header_me "$DATE_LONG")

" > "$OUTFILE"

# write new entry into index
printf '%s\n' "- [$DATE_META]($DATE_META.md) - $TITLE" \
	>> "source/diary/index.md"

$EDITOR "$OUTFILE"
