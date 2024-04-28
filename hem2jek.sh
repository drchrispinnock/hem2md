#!/bin/sh


usage() {
    echo "Usage: $0 [-df] Hemmingwayfile" >&2
    echo "           -d  add as a draft" >&2
    echo "           -f  overwrite existing post" >&2
    exit 1
}

TYPE="post"
FLAGS=""

while [ $# -gt 0 ]; do
        case $1 in
        -d)     TYPE="draft" ;;
        -f)     FLAGS="$FLAGS -f" ;;
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

[ ! -f "_config.yml" ] && echo "am I in a jekyll installation? cannot find config" && exit 1

tmpfile="$(mktemp /tmp/hemXXXX)"
$hmd -n "$file" > "$tmpfile"

# Get the title
#
title="$(grep '^#' "$tmpfile" | head -1 | sed -e 's/^#[ \t]*//g')"


#jekyll post "$title"
post=$($jekyll $TYPE $FLAGS "$title")
[ "$?" != "0" ] && echo "jekyll failed" && exit 1
post=$(echo "$post" | grep "^New $TYPE created" | \
    sed -e "s/New $TYPE created at //g" -e's/[ \t]*$//' | ansi2txt)

[ ! -f "$post" ] && echo "jekyll failed" && exit 1

echo "Title: $title"
echo "Post:  $post"

grep -v '^# ' $tmpfile >> $post
