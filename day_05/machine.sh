#!/bin/bash

IFS=',' read -r -a DATA

function position {
    echo ${DATA[$1]}
}

function immediate {
    echo "$1"
}

function resolve {
    arr=(0 100 1000 10000)
    type=$(($1 / ${arr[$2]} % 10))
    if [ $type -eq 0 ]
    then
        position $3
    else
        immediate $3
    fi
}

function opcode_1 {
    idx=$1
    op=${DATA[$idx]}

    p1=$(($idx + 1))
    param_1=$(resolve $op 1 ${DATA[$p1]})
    # echo "P1=$p1 says ${DATA[$p1]}; resolves to $param_1"

    p2=$(($idx + 2))
    param_2=$(resolve $op 2 ${DATA[$p2]})
    # echo "P2=$p2 says ${DATA[$p2]}; resolves to $param_2"

    p3=$(($idx + 3))
    param_3=${DATA[$p3]}

    echo "Operation: ${DATA[$idx]} ${DATA[$p1]} ($param_1) ${DATA[$p2]} ($param_2) ${DATA[$p3]} ($param_3)"
    DATA[$param_3]=$(($param_1 + $param_2))
    echo "Storing $param_1 + $param_2 = ${DATA[$param_3]} into position $param_3"
    return 4
}

function opcode_2 {
    idx=$1
    op=${DATA[$idx]}

    p1=$(($idx + 1))
    param_1=$(resolve $op 1 ${DATA[$p1]})

    p2=$(($idx + 2))
    param_2=$(resolve $op 2 ${DATA[$p2]})

    p3=$(($idx + 3))
    param_3=${DATA[$p3]}

    echo "Operation: ${DATA[$idx]} ${DATA[$p1]} ($param_1) ${DATA[$p2]} ($param_2) ${DATA[$p3]} ($param_3)"
    DATA[$param_3]=$(($param_1 * $param_2))
    echo "Storing $param_1 * $param_2 = ${DATA[$param_3]} into position $param_3"
    return 4
}

function opcode_3 {
    idx=$1
    op=${DATA[$idx]}

    p1=$(($idx + 1))
    param_1=${DATA[$p1]}

    echo "Operation: ${DATA[$idx]} ${DATA[$p1]} ($param_1)"
    read data
    DATA[$param_1]=$data
    echo "Saved ${DATA[$param_1]} to position $param_1"
    return 2
}

function opcode_4 {
    idx=$1
    op=${DATA[$idx]}

    p1=$(($idx + 1))
    param_1=$(resolve $op 1 ${DATA[$p1]})

    echo "Operation: ${DATA[$idx]} ${DATA[$p1]} ($param_1)"
    echo "OUTPUT: $param_1"
    return 2
}

function opcode_5 {
    idx=$1
    op=${DATA[$idx]}

    p1=$(($idx + 1))
    param_1=$(resolve $op 1 ${DATA[$p1]})

    p2=$(($idx + 2))
    param_2=$(resolve $op 2 ${DATA[$p2]})

    echo "Operation: ${DATA[$idx]} ${DATA[$p1]} ($param_1) ${DATA[$p2]} ($param_2)"
    if [ $param_1 -ne 0 ]
    then
        jump_by=$(($param_2 - $idx))
        echo "$param_1 is not 0, jumping to $param_2 (from $idx by $jump_by)"
        return $jump_by
    fi
    echo "Value at ${DATA[$p1]} ($param_1) is 0, skipping the jump"

    return 3
}

function opcode_6 {
    idx=$1
    op=${DATA[$idx]}

    p1=$(($idx + 1))
    param_1=$(resolve $op 1 ${DATA[$p1]})

    p2=$(($idx + 2))
    param_2=$(resolve $op 2 ${DATA[$p2]})

    echo "Operation: ${DATA[$idx]} ${DATA[$p1]} ($param_1) ${DATA[$p2]} ($param_2)"
    if [ $param_1 -eq 0 ]
    then
        jump_by=$(($param_2 - $idx))
        echo "Value at ${DATA[$p1]} is 0, jumping to $param_2 (from $idx by $jump_by)"
        return $jump_by
    fi
    echo "Value at ${DATA[$p1]} ($param_1) is not 0, skipping the jump"

    return 3
}

function opcode_7 {
    idx=$1
    op=${DATA[$idx]}

    p1=$(($idx + 1))
    param_1=$(resolve $op 1 ${DATA[$p1]})

    p2=$(($idx + 2))
    param_2=$(resolve $op 2 ${DATA[$p2]})

    p3=$(($idx + 3))
    # param_3=$(resolve $op 3 ${DATA[$p3]})
    param_3=${DATA[$p3]}

    echo "Operation: ${DATA[$idx]} ${DATA[$p1]} ($param_1) ${DATA[$p2]} ($param_2) ${DATA[$p3]} ($param_3)"
    if [ $param_1 -lt $param_2 ]
    then
        DATA[$param_3]=1
        echo "$param_1 < $param_2 is true, storing 1 to $param_3"
    else
        DATA[$param_3]=0
        echo "$param_1 < $param_2 is false, storing 0 to $param_3"
    fi

    return 4
}

function opcode_8 {
    idx=$1
    op=${DATA[$idx]}

    p1=$(($idx + 1))
    param_1=$(resolve $op 1 ${DATA[$p1]})

    p2=$(($idx + 2))
    param_2=$(resolve $op 2 ${DATA[$p2]})

    p3=$(($idx + 3))
    # param_3=$(resolve $op 3 ${DATA[$p3]})
    param_3=${DATA[$p3]}

    echo "Operation: ${DATA[$idx]} ${DATA[$p1]} ($param_1) ${DATA[$p2]} ($param_2) ${DATA[$p3]} ($param_3)"
    if [ $param_1 -eq $param_2 ]
    then
        DATA[$param_3]=1
        echo "$param_1 == $param_2 is true, storing 1 to $param_3"
    else
        DATA[$param_3]=0
        echo "$param_1 == $param_2 is false, storing 0 to $param_3"
    fi

    return 4
}

function opcode_99 {
    echo "DONE ${DATA[0]}"
    exit 0
}

pos=0


while true
do
    op=${DATA[$pos]}
    operation=$(($op % 100))
    echo "*******"
    echo "On position $pos, operation is $op [$operation]"
    case $operation in
        1)
            opcode_1 $pos
            pos=$(($pos + $?));;
        2)
            opcode_2 $pos
            pos=$(($pos + $?));;
        3)
            opcode_3 $pos
            pos=$(($pos + $?));;
        4)
            opcode_4 $pos
            pos=$(($pos + $?));;
        5)
            opcode_5 $pos
            pos=$(($pos + $?));;
        6)
            opcode_6 $pos
            pos=$(($pos + $?));;
        7)
            opcode_7 $pos
            pos=$(($pos + $?));;
        8)
            opcode_8 $pos
            pos=$(($pos + $?));;
        99)
            opcode_99 $pos
            pos=$(($pos + $?));;
    esac
    for x in ${DATA[@]}; do
        echo -n "$x,"
    done
    echo
done
