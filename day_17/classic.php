<?php

require 'intmachine.php';

$memory = array_map(
    function($x) { return intval($x); },
    explode(",", trim(fgets(STDIN)))
);

$inputs = array_map(
    function($x) { return intval($x); },
    explode(",", trim(fgets(STDIN)))
);
$pos = 0;

$input = function() use ($inputs, $pos) {
    $pos += 1;
    return $inputs[$pos-1];
};

$machine = new IntMachine($input);
foreach ($memory as $idx => $value) {
    $machine->memory[$idx] = $value;
}
$machine->evaluate();


?>
