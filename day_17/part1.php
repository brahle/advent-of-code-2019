<?php

require 'intmachine.php';

$memory = array_map(
    function($x) { return intval($x); },
    explode(",", trim(fgets(STDIN)))
);

$board = array(0 => array());
$i = 0;
$j = 0;
$m = 0;

$output = function($x) use (&$board, &$i, &$j, &$m) {
    if ($x === 10) {
        $i += 1;
        $j = 0;
        $board[$i] = array();
    } else {
        $board[$i][$j] = chr($x);
        $j += 1;
    }
    if ($j > $m) {
        $m = $j;
    }
    printf("%s", chr($x));
};

$machine = new IntMachine(
    function() {
        return 0;
    },
    $output
);
foreach ($memory as $idx => $value) {
    $machine->memory[$idx] = $value;
}

$machine->evaluate();

$n = $i;
$x = 0;

for ($i = 1; $i + 1 < $n; ++$i) {
    for ($j = 1; $j + 1 < $m; ++$j) {
        if ($board[$i][$j] !== '#') {
            continue;
        }
        if ($board[$i+1][$j] !== '#') {
            continue;
        }
        if ($board[$i-1][$j] !== '#') {
            continue;
        }
        if ($board[$i][$j+1] !== '#') {
            continue;
        }
        if ($board[$i][$j-1] !== '#') {
            continue;
        }
        printf("%d,%d\n", $i, $j);
        $x += $i * $j;
    }
}

printf("Solution = %d\n", $x);

?>
