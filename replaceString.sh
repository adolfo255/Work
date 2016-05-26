#!/bin/bash
workspace="$(mktemp)"
cp "$1" "$workspace"
touch newArchive.txt
shift
while (($# >= 1))
do
        from="$(echo $1| tr -d "+")"
        to="$2"
        sed -i -e 's/\("[[:alnum:]|]\+|'"$from"'"\) "[[:alnum:] ]*"/\1 "'"$to"'"/g' "$workspace"
        shift 2
done
cat "$workspace"
