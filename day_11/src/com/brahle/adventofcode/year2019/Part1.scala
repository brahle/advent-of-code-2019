package com.brahle.adventofcode.year2019

import scala.collection.mutable

object Part1 extends App {
  val values = scala.io.StdIn.readLine()
  val robot = new IntMachine(values, "")

  val BLACK = 0
  val WHITE = 1

  val dx = Array(0, 1, 0, -1)
  val dy = Array(1, 0, -1, 0)
  val turn = Array(-1, 1)

  var x = 0
  var y = 0
  var direction = 0
  var idx = 0

  val memory = mutable.Map[(Int, Int), Int]()
  robot.input = () => BigInt.int2bigInt(memory.getOrElse((x, y), BLACK))

  def first(value: BigInt): Unit = {
    memory((x, y)) = value.toInt
    println("Painting " + value)
  }

  def second(value: BigInt): Unit = {
    direction = (4 + direction + turn(value.toInt)) % 4
    x += dx(direction)
    y += dy(direction)
    println("Moving " + value + " to " + (x,y))
  }

  robot.output = (value: BigInt) => {
    idx += 1
    idx % 2 match {
      case 1 => first(value)
      case 0 => second(value)
    }
  }

  robot.evaluate()
  print(memory.size)
}
