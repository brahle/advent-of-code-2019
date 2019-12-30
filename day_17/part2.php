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

$start_x = 0;
$start_y = 0;

$output = function($x) use (&$board, &$i, &$j, &$m, &$start_x, &$start_y) {
    if (chr($x) === "^") {
        $start_x = $j;
        $start_y = $i;
    }
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

$direction = 0;
$deltas = array(
    array(0, -1),
    array(1, 0),
    array(0, 1),
    array(-1, 0),
);

$orders = "A,B,A,B,C,A,B,C,A,C";
$functions = array(
    "A" => "R,6,L,6,L,10",
    "B" => "L,8,L,6,L,10,L,6",
    "C" => "R,6,L,8,L,10,R,6",
);

$x = $start_x;
$y = $start_y;

printf("Starting at %d,%d\n", $x, $y);

$command_string = "";
foreach (explode(",", $orders) as $order) {
    $command_string .= $functions[$order] . ",";
}
$commands = explode(",", $command_string);

$ok = true;

foreach ($commands as $idx => $command) {
    if ($command == "R") {
        $direction = ($direction + 1) % 4;
    } else if ($command == "L") {
        $direction = ($direction + 3) % 4;
    } else {
        $cnt = intval($command);
        for ($i = 0; $i < $cnt; ++$i) {
            $x += $deltas[$direction][0];
            $y += $deltas[$direction][1];
            if ($board[$y][$x] != "#" && $board[$y][$x] != 'X') {
                printf("%d: Fell off on %d,%d\n", $idx, $x, $y);
                $board[$y][$x] = '0';
                $ok = false;
                break;
            }
            $board[$y][$x] = 'X';
        }
    }
    if (!$ok) {
        break;
    }
}

if (!$ok) {
    foreach ($board as $y => $row) {
        foreach ($row as $x => $cell) {
            printf("%s", $cell);
        }
        printf("\n");
    }
    exit(1);
}
printf("Have not crashed!\n");
foreach ($board as $y => $row) {
    foreach ($row as $x => $cell) {
        if ($cell == "#") {
            printf("Have not explored all fields\n");
            exit(2);
        }
    }
}
printf("Explored all fields!\n");

$send = sprintf(
    "%s\n%s\n%s\n%s\nn\n",
    $orders,
    $functions["A"],
    $functions["B"],
    $functions["C"],
);
$chars_sent = 0;

printf("%s\n", $send);

$part2_input = function() use (&$send, &$chars_sent) {
    $to_send = $send[$chars_sent];
    $chars_sent += 1;
    printf("%d: Sending '%s' as %d\n", $chars_sent, $to_send, ord($to_send));
    return ord($to_send);
};

$part2_machine = new IntMachine(
    $part2_input,
    function($x) {
        printf("%4d -> %s\n", $x, chr($x));
    },
);
foreach ($memory as $idx => $value) {
    $part2_machine->memory[$idx] = $value;
}
$part2_machine->memory[0] = 2;

$part2_machine->evaluate();

?>
