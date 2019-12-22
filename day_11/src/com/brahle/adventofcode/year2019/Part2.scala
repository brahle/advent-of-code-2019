package com.brahle.adventofcode.year2019
import scala.collection.mutable

object Part2 extends App {

  val values = scala.io.StdIn.readLine()
  val robot = new IntMachine(values, "")

  val BLACK = 0
  val WHITE = 1

  val dx = Array(0, 1, 0, -1)
  val dy = Array(1, 0, -1, 0)
  val turn = Array(-1, 1)

  var x = 0
  var y = 0
  var minx = 0
  var maxx = 0
  var miny = 0
  var maxy = 0

  var direction = 0
  var idx = 0
  var first = true

  val memory = mutable.Map[(Int, Int), Int]()
  robot.input = () => {
    if (first) {
      first = false
      WHITE
    } else {
      BigInt.int2bigInt(memory.getOrElse((x, y), BLACK))
    }
  }

  def first(value: BigInt): Unit = {
    memory((x, y)) = value.toInt
  }

  def second(value: BigInt): Unit = {
    direction = (4 + direction + turn(value.toInt)) % 4
    x += dx(direction)
    if (x > maxx) {
      maxx = x
    }
    if (x < minx) {
      minx = x
    }
    y += dy(direction)
    if (y > maxy) {
      maxy = y
    }
    if (y < miny) {
      miny = y
    }
    println(x, y)
  }

  robot.output = (value: BigInt) => {
    idx += 1
    idx % 2 match {
      case 1 => first(value)
      case 0 => second(value)
    }
  }

  robot.evaluate()

  for (j <- maxy to miny by -1) {
    for (i <- minx to maxx by 1) {
      val t = memory.getOrElse((i, j), BLACK)
      if (t == BLACK) {
        print(".")
      } else {
        print("#")
      }
    }
    println()
  }
  println((minx, maxx))
  println((miny, maxy))
}
