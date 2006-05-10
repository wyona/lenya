#!/bin/sh

# Perform a global search and replace on each of several files

STRING1=$1
STRING2=$2
SRC_DIR=$3

if [ $# != 3 ]
then
    echo "usage: s-and-r.sh string1 string2 directory"
    echo "    replace all occurrences of string1 by string2 in all xml files below the given directory"
    exit 0
fi

echo "recursively replace $STRING1 by $STRING2 in $SRC_DIR ? (y/n)"
read answer

if [ "$answer" = n ]
then
    echo "Exiting..."
    exit 0
fi

#delimiter for the sed is _, so there is no problem whith the / in STRING1-2 
find $SRC_DIR -name '*.xml' -type f | while read -r file; do
    echo "$file"
    sed -e "s_"$STRING1"_"$STRING2"_g" $file > $file.temp 
    mv -f $file.temp $file
done
