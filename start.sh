#!/bin/bash

DICTIONARY=/tmp/.dict.tmp

LANG="DE"

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

    if [ "$LANG" == "DE" ]; then
        word1=`echo $line | cut -d '=' -f 1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
        word2=`echo $line | cut -d '=' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
    else
        word1=`echo $line | cut -d '=' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
        word2=`echo $line | cut -d '=' -f 1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
    fi

    echo "$word1"
    read -rsn1 input
    if [ "$input" = "u" ]; then
        echo "$word2"
        read -rsn1
    fi

done
