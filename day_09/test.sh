#!/bin/bash
./Day09/Day09/bin/Debug/netcoreapp3.1/Day09.exe < test/test.$1.in | grep -e "\(OUTPUT\|DONE\)" > out

diff -q -b test/test.$1.out out
if [ $? -ne 0 ]
then
    echo "EXPECTED: "
    cat test/test.$1.out

    echo ""
    echo "GOT: "
    cat out
    exit 1
fi
