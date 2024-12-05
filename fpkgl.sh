#!/bin/sh
#https://www.linuxquestions.org/questions/slackware-14/slackware-metadata-on-packages-for-15-1-why-not-4175744763/#post6542318
#
#Petri Kaukasoina
#
# find libraries needed by a Slackware package
#
[ $# -lt 1 ] && echo 'Usage: ' $0 ' filename_of_package' && exit 1
EXPLODEDIR=$(mktemp -d)
trap 'rm -rf $EXPLODEDIR' EXIT
tar -C $EXPLODEDIR -xf "$1"
find $EXPLODEDIR -type f -executable -exec objdump -p "{}" 2>/dev/null \; |\
grep NEEDED | sed 's/ *NEEDED *\(l.*\)/\1/' | sort -u
