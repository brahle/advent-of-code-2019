use std::collections::HashMap;
use std::vec::Vec;

pub struct IntMachine<F1, F2> where
        F1: FnMut() -> i64,
        F2: FnMut(i64) -> () {
    pub position: i64,
    pub relative_index: i64,
    pub memory: HashMap<i64, i64>,
    pub input: F1,
    pub output: F2,
}

pub fn sample_input() -> i64 {
    0
}

pub fn sample_output(x: i64) {
    println!("OUTPUT: {}", x);
}

pub fn machine(
    memory: HashMap<i64, i64>,
    input: impl FnMut() -> i64,
    output: impl FnMut(i64) -> (),
) -> IntMachine<impl FnMut() -> i64, impl FnMut(i64) -> ()> {
    IntMachine {
        position: 0,
        relative_index: 0,
        memory: memory,
        input: input,
        output: output,
    }
}

pub fn queue_input(q: Vec<i64>) -> impl FnMut() -> i64 {
    let mut i = 0;
    let _input = move || {
        i += 1;
        return q[i-1];
    };
    return _input;
}


impl<F1, F2> IntMachine<F1, F2> where
        F1: FnMut() -> i64,
        F2: FnMut(i64) -> () {

    pub fn evaluate(&mut self) {
        while self.evaluate_next() {};
    }

    fn evaluate_next(&mut self) -> bool {
        match self.operation() {
            1 => return self.op1(),
            2 => return self.op2(),
            3 => return self.op3(),
            4 => return self.op4(),
            5 => return self.op5(),
            6 => return self.op6(),
            7 => return self.op7(),
            8 => return self.op8(),
            9 => return self.op9(),
            _ => return self.op99(),
        }
    }

    fn op1(&mut self) -> bool {
        // self.write(&3, self.resolve(1) + self.resolve(2));
        self.memory.insert(self.write_index(&3), self.resolve(1) + self.resolve(2));
        self.position += 4;
        return true;
    }

    fn op2(&mut self) -> bool {
        self.memory.insert(self.write_index(&3), self.resolve(1) * self.resolve(2));
        self.position += 4;
        return true;
    }

    fn op3(&mut self) -> bool {
        self.memory.insert(self.write_index(&1), (self.input)());
        self.position += 2;
        return true;
    }

    fn op4(&mut self) -> bool {
        let x = *self.resolve(1);
        (self.output)(x);
        self.position += 2;
        return true;
    }

    fn op5(&mut self) -> bool {
        if *self.resolve(1) != 0 {
            self.position = *self.resolve(2);
        } else {
            self.position += 3;
        }
        return true;
    }

    fn op6(&mut self) -> bool {
        if *self.resolve(1) == 0 {
            self.position = *self.resolve(2);
        } else {
            self.position += 3;
        }
        return true;
    }

    fn op7(&mut self) -> bool {
        if *self.resolve(1) < *self.resolve(2) {
            self.memory.insert(self.write_index(&3), 1);
        } else {
            self.memory.insert(self.write_index(&3), 0);
        }
        self.position += 4;
        return true;
    }

    fn op8(&mut self) -> bool {
        if *self.resolve(1) == *self.resolve(2) {
            self.memory.insert(self.write_index(&3), 1);
        } else {
            self.memory.insert(self.write_index(&3), 0);
        }
        self.position += 4;
        return true;
    }

    fn op9(&mut self) -> bool {
        self.relative_index += *self.resolve(1);
        self.position += 2;
        return true;
    }

    fn op99(&self) -> bool {
        println!("DONE {}", self.memory.get(&0).unwrap());
        return false;
    }

    fn op(&self) -> &i64 {
        self.memory.get(&self.position).unwrap()
    }

    fn operation(&self) -> i64 {
        self.op() % 100
    }

    fn resolve(&self, index: i64) -> &i64 {
        match self.mode(index) {
            0 => return self.positional(index),
            1 => return self.immediate(index),
            _ => return self.relative(index),
        }
    }

    fn mode(&self, index: i64) -> i64 {
        match index {
            1 => return self.op() / 100 % 10,
            2 => return self.op() / 1000 % 10,
            3 => return self.op() / 10000 % 10,
            _ => return self.op() / 100000 % 10,
        }
    }

    fn positional(&self, index: i64) -> &i64 {
        return self.read(self.memory.get(&(self.position + index)).unwrap());
    }

    fn immediate(&self, index: i64) -> &i64 {
        return self.read(&(self.position + index));
    }

    fn relative(&self, index: i64) -> &i64 {
        return self.read(&(
            self.relative_index +
            self.memory.get(&(self.position + index)).unwrap()
        ));
    }

    fn read(&self, index: &i64) -> &i64 {
        return self.memory.get(index).unwrap_or(&0);
    }

    fn write(mut self, index: &i64, value: i64) {
        self.memory.insert(self.write_index(index), value);
    }

    fn write_index(&self, index: &i64) -> i64 {
        match self.mode(*index) {
            0 => return *self.read(&(self.position + index)),
            _ => return self.read(&(self.position + index)) + self.relative_index,
        }
    }
}
