#!/bin/sh
cd "$(dirname $(realpath "$0"))"

printf '.\" information\n'
printf '.Dd $Mdocdate$\n'
printf '.Dt diary\ posts\n'
printf '.Os ulthar.cat\n'
printf '.\" control panel\n'
printf '.Lk /index.EXT home\n'
printf '-\n'
printf '.Lk ../index.EXT back\n'
printf '.\" main page\n'
printf '.Sh SOMETHING\n'

for file in *.mdoc; do
    printf '.Pp\n.Lk %s %s' "${file%%mdoc}EXT"
    sed -En 's/^\.Dd //p' "$file"
    sed -En 's/^\.Dt //p' "$file"
done

