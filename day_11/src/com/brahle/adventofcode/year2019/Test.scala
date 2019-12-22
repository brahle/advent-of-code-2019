package com.brahle.adventofcode.year2019

object Test extends App {
  val values = scala.io.StdIn.readLine();
  val inputs = scala.io.StdIn.readLine();
  val machine = new IntMachine(values, inputs);
  machine.evaluate();
}
