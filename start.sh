# Main trainer script
#
# Copyright (c) 2018, Alexander Smirnov

#!/bin/bash

DICTIONARY=/tmp/.dict.tmp

LANG="RU"

XTERM="xterm -fa 'Monospace' -fs 14 -e /bin/bash -e"

generate_dict() {
    rm -f $DICTIONARY

    while [ $# -gt 0 ]
    do
        file="$1"

        echo "Adding: "$(basename $file)

        cat $file >> $DICTIONARY
        shift
    done

    sed -i '/^\s*$/d' $DICTIONARY
}

run_trainer() {
    lines=$(wc -l $DICTIONARY | cut -d ' ' -f 1)

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
}

if [ "$#" = "0" ]; then
    run_trainer
else
    generate_dict "$@"

    export LC_ALL="ru_RU.UTF-8"
    $XTERM $0
    rm $DICTIONARY
fi
