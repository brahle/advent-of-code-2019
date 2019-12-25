mod intmachine;

use std::cell::RefCell;
use std::collections::HashMap;
use std::collections::VecDeque;
use std::io::{self, BufRead};
use std::vec::Vec;

struct State {
    pub position: (i32, i32),
    pub parent_direction: i64,
    pub discovered: i64,
}

fn main() {
    let stdin = io::stdin();
    let code = stdin.lock().lines().next().unwrap().unwrap();

    let mut memory = HashMap::new();
    let code_split = code.split(",");
    let mut i = 0;
    for s in code_split {
        memory.insert(i, s.parse::<i64>().unwrap());
        i += 1;
    }

    let map: RefCell<HashMap<(i32, i32), i64>> = RefCell::new(HashMap::new());
    (*map.borrow_mut()).insert((0, 0), 1);

    let full_stack: RefCell<Vec<State>> = RefCell::new(Vec::new());
    (*full_stack.borrow_mut()).push(State {
        position: (0, 0),
        parent_direction: 1,
        discovered: 0
    });
    let asked: RefCell<(i32, i32)> = RefCell::new((0, 0));

    let deltas: RefCell<Vec<(i32, i32)>> = RefCell::new(vec![
        (0, 1),
        (0, -1),
        (1, 0),
        (-1, 0),
    ]);
    let reverse = vec![0, 2, 1, 4, 3];

    let input = || {
        let mut stack = full_stack.borrow_mut();
        if stack.is_empty() {
            return 0;
        }

        let state = stack.pop().unwrap();
        let mut next = state.discovered + 1;
        println!(
            "Position = ({}, {}), discovered so far = {}",
            state.position.0,
            state.position.1,
            state.discovered
        );

        while next < 5 {
            if next == state.parent_direction {
                println!(
                    "Skip: {} is parent direction for ({}, {})",
                    next,
                    state.position.0,
                    state.position.1,
                );
                next += 1;
                continue;
            }
            let delta: (i32, i32) = (*deltas.borrow())[(next-1) as usize];
            let next_pos = (state.position.0 + delta.0, state.position.1 + delta.1);
            if map.borrow().contains_key(&next_pos) {
                println!(
                    "Skip {} from ({}, {}): ({}, {}) has been discoverd",
                    next,
                    state.position.0,
                    state.position.1,
                    next_pos.0,
                    next_pos.1,
                );
                next += 1;
                continue;
            }
            println!(
                "Going {} from ({}, {}) to ({}, {}).",
                next,
                state.position.0,
                state.position.1,
                next_pos.0,
                next_pos.1,
            );
            stack.push(State {
                position: state.position,
                parent_direction: state.parent_direction,
                discovered: next,
            });
            stack.push(State {
                position: next_pos,
                parent_direction: reverse[next as usize],
                discovered: 0,
            });
            *asked.borrow_mut() = next_pos;
            return next;
        }

        let delta: (i32, i32) = (*deltas.borrow())[(state.parent_direction-1) as usize];
        let next_pos = (state.position.0 + delta.0, state.position.1 + delta.1);
        *asked.borrow_mut() = next_pos;
        println!(
            "Going back to parent {} from ({}, {}) to ({}, {}).",
            state.parent_direction,
            state.position.0,
            state.position.1,
            next_pos.0,
            next_pos.1,
    );
        return state.parent_direction;
    };

    let answer: RefCell<(i32, i32)> = RefCell::new((0, 0));

    let output = |x: i64| {
        let pos = *asked.borrow();
        println!("Position ({}, {}) is {}", pos.0, pos.1, get(x));
        (*map.borrow_mut()).insert(pos, x);
        if x == 0 {
            (*full_stack.borrow_mut()).pop();
        }
        if x == 2 {
            *answer.borrow_mut() = pos;
        }
    };

    let mut machine = intmachine::machine(
        memory,
        input,
        output,
    );

    machine.evaluate();

    let mut queue: VecDeque<(i32, i32)> = VecDeque::new();
    let mut dist: HashMap<(i32, i32), i32> = HashMap::new();
    queue.push_back((0, 0));
    dist.insert((0, 0), 0);

    while !queue.is_empty() {
        let pos = queue.pop_front().unwrap();
        let new_distance = dist.get(&pos).unwrap() + 1;
        for delta in deltas.borrow().iter() {
            let next_pos = (pos.0 + delta.0, pos.1 + delta.1);
            if dist.contains_key(&next_pos) {
                continue;
            }
            let map_borrow = map.borrow();
            let maybe_field = map_borrow.get(&next_pos);
            if maybe_field.is_none() {
                continue;
            }
            let field = maybe_field.unwrap();
            if *field == 0 {
                continue;
            }
            dist.insert(next_pos, new_distance);
            queue.push_back(next_pos);
        }
    }

    println!("Distance is {}", dist.get(&answer.borrow()).unwrap());

    for j in -25..25 {
        for i in -20..25 {
                let map_borrow = map.borrow();
            let maybe_field = map_borrow.get(&(i, j));
            if maybe_field.is_none() {
                print!("?");
                continue;
            }
            print!("{}", get(*maybe_field.unwrap()));
        }
        println!()
    }
}

fn get(c: i64) -> char {
    match c {
        0 => return '#',
        1 => return '.',
        _ => return 'O',
    }
}
