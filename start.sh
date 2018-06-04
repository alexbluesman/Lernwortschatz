#!/bin/bash

DICTIONARY=/tmp/.dict.tmp

MODE=2

rm -f $DICTIONARY

while [ $# -gt 0 ]
do
    file="$1"

    cat $file >> $DICTIONARY

    shift
done

sed -i '/^\s*$/d' $DICTIONARY

lines=$(wc -l $DICTIONARY | cut -d ' ' -f 1)

echo $lines

while true;
do
    reset
    val=$(( ( RANDOM % $lines )  + 1 ))
    line=`sed $val"q;d" $DICTIONARY`

    word=`echo $line | cut -d '=' -f $MODE | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`

    read -n 1 -s -r -p "$word"
done
