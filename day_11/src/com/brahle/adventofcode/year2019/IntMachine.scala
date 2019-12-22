package com.brahle.adventofcode.year2019
import scala.collection.mutable

class IntMachine {
  private var position = BigInt.int2bigInt(0);
  private var relativeIndex = BigInt.int2bigInt(0);
  private var memory = mutable.Map[BigInt, BigInt]();
  private var inputs = mutable.Queue[BigInt]()
  var input: () => BigInt = () => { inputs.dequeue() };
  var output: (BigInt) => Unit = (x: BigInt) => { println("OUTPUT: " + x.toString()) };

  def this(values: String, inputs: String)
  {
    this();
    values
      .split(",")
      .zipWithIndex
      .foreach(tuple => {
        val pos = BigInt.int2bigInt(tuple._2);
        val value = BigInt(tuple._1);
        memory(pos) = value;
      });
    if (inputs != "") {
      inputs
        .split(",")
        .foreach(value => this.inputs.enqueue(BigInt(value)));
    }
  }

  def evaluate(): Unit = {
    while (evaluateNext()) {}
  }

  def evaluateNext(): Boolean = {
    operation() match {
      case 1 => op1()
      case 2 => op2()
      case 3 => op3()
      case 4 => op4()
      case 5 => op5()
      case 6 => op6()
      case 7 => op7()
      case 8 => op8()
      case 9 => op9()
      case 99 => op99()
    }
  }

  def op1(): Boolean = {
    write(3, resolve(1) + resolve(2))
    position += 4
    true
  }

  def op2(): Boolean = {
    write(3, resolve(1) * resolve(2))
    position += 4
    true
  }

  def op3(): Boolean = {
    write(1, input())
    position += 2
    true
  }

  def op4(): Boolean = {
    output(resolve(1))
    position += 2
    true
  }

  def op5(): Boolean = {
    if (resolve(1) != 0) {
      position = resolve(2)
    } else {
      position += 3
    }
    true
  }

  def op6(): Boolean = {
    if (resolve(1) == 0) {
      position = resolve(2)
    } else {
      position += 3
    }
    true
  }

  def op7(): Boolean = {
    if (resolve(1) < resolve(2)) {
      write(3, 1)
    } else {
      write(3, 0)
    }
    position += 4
    true
  }

  def op8(): Boolean = {
    if (resolve(1) == resolve(2)) {
      write(3, 1)
    } else {
      write(3, 0)
    }
    position += 4
    true
  }

  def op9(): Boolean = {
    relativeIndex += resolve(1)
    position += 2
    true
  }

  def op99(): Boolean = {
    println("DONE " + memory(0).toString())
    false
  }

  def op(): Int = memory(position).toInt

  def operation(): Int = op() % 100

  def resolve(index: Int): BigInt = {
    mode(index) match {
      case 0 => positional(index)
      case 1 => immediate(index)
      case 2 => relative(index)
    }
  }

  def positional(index: Int): BigInt = {
    read(memory(position + index))
  }

  def immediate(index: Int): BigInt = {
    read(position + index)
  }

  def relative(index: Int): BigInt = {
   read(relativeIndex + memory(position + index))
  }

  def read(x: BigInt): BigInt = {
    memory getOrElse(x, 0)
  }

  def write(index: Int, value: BigInt) = {
    memory(getWriteIndex(index)) = value
  }

  def getWriteIndex(index: Int): BigInt = {
    mode(index) match {
      case 0 => read(position + index)
      case 2 => read(position + index) + relativeIndex
    }
  }

  def mode(index: Int): Int = {
    index match {
      case 1 => op() / 100 % 10
      case 2 => op() / 1000 % 10
      case 3 => op() / 10000 % 10
      case 4 => op() / 100000 % 10
    }
  }
}
