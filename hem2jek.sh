#!/bin/sh


usage() {
    echo "Usage: $0 [-d] Hemmingwayfile" >&2
    exit 1
}

TYPE="post"

while [ $# -gt 0 ]; do
        case $1 in
        -d)     TYPE="draft";
        -*)     usage; ;;
        *)      break; # rest of args are targets
        esac
        shift
done

[ -z "$1" ] && usage
file=$1

hmd=@BINDIR@/hem2md
jekyll="bundle exec jekyll"

if [ ! -x "$hmd" ]; then
    hmd=hem2md
    which hem2md 2>&1 >/dev/null
    [ "$?" != "0" ] && echo "cannot find hem2md in path" && exit 1
fi

which ansi2txt 2>&1 >/dev/null
[ "$?" != "0" ] && echo "cannot find ansi2txt in path" && exit 1

tmpfile="$(mktemp /tmp/hemXXXX)"
$hmd "$file" > "$tmpfile"

# Get the title
#
title="$(grep '^#' "$tmpfile" | sed -e 's/^#[ \t]*//g')"

echo "Title: $title"
#jekyll post "$title"
post=$($jekyll $TYPE "$title")
[ "$?" != "0" ] && echo "jekyll failed" && exit 1
post=$(echo "$post" | grep '^New post created' | \
    sed -e 's/New post created at //g' -e's/[ \t]*$//' | ansi2txt)
echo "Post:  $post"
[ ! -f "$post" ] && echo "jekyll failed" && exit 1

grep -v '^#' $tmpfile >> $post