mod intmachine;

use std::io::{self, BufRead};
// use std::vec::Vec;
use std::collections::HashMap;

fn main() {
    let stdin = io::stdin();
    let code = stdin.lock().lines().next().unwrap().unwrap();
    let inputs = stdin.lock().lines().next().unwrap().unwrap();

    let mut memory = HashMap::new();
    let code_split = code.split(",");
    let mut i = 0;
    for s in code_split {
        memory.insert(i, s.parse::<i64>().unwrap());
        i += 1;
    }

    let mut vec = vec![];
    if inputs != "" {
        let parts = inputs.split(",");
        for part in parts {
            vec.push(part.parse::<i64>().unwrap());
        }
    }
    let mut machine = intmachine::machine(
        memory,
        intmachine::queue_input(vec),
        intmachine::sample_output,
    );


    machine.evaluate();
}
