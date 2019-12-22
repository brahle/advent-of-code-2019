#!/bin/bash

DIR=$(pwd)
cd out/production/day_11

scala com.brahle.adventofcode.year2019.Test < $DIR/test/test.$1.in | grep -e "\(OUTPUT\|DONE\)" > out

diff -q -b $DIR/test/test.$1.out out
if [ $? -ne 0 ]
then
    echo "EXPECTED: "
    cat $DIR/test/test.$1.out

    echo ""
    echo "GOT: "
    cat out
    exit 1
fi
