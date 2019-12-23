#!/bin/bash

DIR=$(pwd)
cd out/production/day_13

kotlin TestKt < $DIR/test/test.$1.in | grep -e "\(OUTPUT\|DONE\)" > out

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
