#!/bin/bash
./machine.sh < test/test.$1.in | grep -e "\(OUTPUT\|DONE\)" > out

diff -q test/test.$1.out out
if [ $? -ne 0 ]
then
    echo "EXPECTED: "
    cat test/test.$1.out

    echo ""
    echo "GOT: "
    cat out
    exit 1
fi
