#!/bin/sh

[ -z "$1" ] && echo "Usage: $0 Hemmingwayfile"
file=$1

hmd=@BINDIR@/hem2md

if [ ! -x "$hmd" ]; then
    hmd=hem2md
    which hem2md 2>&1 >/dev/null
    [ "$?" != "0" ] && echo "cannot find hem2md in path" && exit 1
fi

tmpfile="$(mktemp /tmp/hemXXXX)"
$hmd "$file" > "$tmpfile"

# Get the title
#
title="$(grep '^#' "$tmpfile" | sed -e 's/^#//g')"

echo "Title: $title"
#jekyll post "$title"
post=$(jekyll post "$title")
#    [ "$?" != "0" ] && echo "jekyll failed" && exit 1

echo $post
post=$(echo "$post" | gsed -e 's/\^\[\[.m//g' -e 's/\^\[\[..m//g')
echo $post
post=$(echo "$post" | grep '^New post created' | sed -e 's/New post created at //g')
echo "Post:  $post"
[ ! -f "$post" ] && echo "jekyll failed" && exit 1

grep -v '^#' $tmpfile >> $post
