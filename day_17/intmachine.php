<?php

class IntMachine {
    private $position = 0;
    private $relativeIndex = 0;
    public $memory = array();
    public $input;
    public $output;

    public function __construct($input = null, $output = null) {
        if ($input === null) {
            $input = function() {
                return 0;
            };
        }
        $this->input = $input;
        if ($output === null) {
            $output = function($x) {
                printf("OUTPUT: %d\n", $x);
            };
        }
        $this->output = $output;
    }

    public function evaluate() {
        while ($this->evaluateNext()) {}
    }

    public function evaluateNext() {
        switch ($this->operation()) {
            case 1: return $this->op1();
            case 2: return $this->op2();
            case 3: return $this->op3();
            case 4: return $this->op4();
            case 5: return $this->op5();
            case 6: return $this->op6();
            case 7: return $this->op7();
            case 8: return $this->op8();
            case 9: return $this->op9();
            case 99: return $this->op99();
        }
        throw "Whoops";
    }

    function op1() {
        $this->write(3, $this->resolve(1) + $this->resolve(2));
        $this->position += 4;
        return true;
    }

    function op2() {
        $this->write(3, $this->resolve(1) * $this->resolve(2));
        $this->position += 4;
        return true;
    }

    function op3() {
        $this->write(1, ($this->input)());
        $this->position += 2;
        return true;
    }

    function op4() {
        ($this->output)($this->resolve(1));
        $this->position += 2;
        return true;
    }

    function op5() {
        if ($this->resolve(1) !== 0) {
            $this->position = $this->resolve(2);
        } else {
            $this->position += 3;
        }
        return true;
    }

    function op6() {
        if ($this->resolve(1) === 0) {
            $this->position = $this->resolve(2);
        } else {
            $this->position += 3;
        }
        return true;
    }

    function op7() {
        if ($this->resolve(1) < $this->resolve(2)) {
            $this->write(3, 1);
        } else {
            $this->write(3, 0);
        }
        $this->position += 4;
        return true;
    }

    function op8() {
        if ($this->resolve(1) === $this->resolve(2)) {
            $this->write(3, 1);
        } else {
            $this->write(3, 0);
        }
        $this->position += 4;
        return true;
    }

    function op9() {
        $this->relativeIndex += $this->resolve(1);
        $this->position += 2;
        return true;
    }

    function op99() {
        printf("DONE %d\n", $this->memory[0]);
        return false;
    }

    function operation() {
        return $this->op() % 100;
    }

    function op() {
        return $this->memory[$this->position];
    }

    function resolve($index) {
        switch ($this->mode($index)) {
            case 0: return $this->positional($index);
            case 1: return $this->immediate($index);
            default: return $this->relative($index);
        }
    }

    function mode($index) {
        $op = $this->op();
        switch ($index) {
            case 1: return $op / 100 % 10;
            case 2: return $op / 1000 % 10;
            case 3: return $op / 10000 % 10;
            default: return $op / 100000 % 10;
        }
    }

    function positional($index) {
        return $this->read($this->memory[$this->position + $index]);
    }

    function immediate($index) {
        return $this->read($this->position + $index);
    }

    function relative($index) {
        return $this->read($this->relativeIndex + $this->memory[$this->position + $index]);
    }

    function read($x) {
        if (array_key_exists($x, $this->memory)) {
            return $this->memory[$x];
        }
        return 0;
    }

    function write($index, $x) {
        $this->memory[$this->getWriteIndex($index)] = $x;
    }

    function getWriteIndex($index) {
        switch ($this->mode($index)) {
            case 0: return $this->read($this->position + $index);
            default: return $this->read($this->position + $index) + $this->relativeIndex;
        }
    }
};

?>
