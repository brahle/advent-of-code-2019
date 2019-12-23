import javafx.scene.paint.Stop
import java.lang.Exception
import java.math.BigInteger

fun main() {
    val values: String = readLine()!!
    val machine = IntMachine(values, "")
    var idx = 0
    var counter = 0
    var screen = mutableMapOf<Pair<BigInteger, BigInteger>, BigInteger>();
    var x = BigInteger.ZERO
    var y = BigInteger.ONE
    var score = BigInteger.ZERO

    var dx = BigInteger.ONE
    var dy = BigInteger.ONE

    var lastBallX = BigInteger.ZERO
    var lastBallY = BigInteger.ZERO
    var ballX = BigInteger.ZERO
    var ballY = BigInteger.ZERO

    var paddleX = BigInteger.ZERO
    var paddleY = BigInteger.ZERO

    var maxScore = BigInteger.ZERO

    machine.memory[BigInteger.ZERO] = BigInteger.TWO

    machine.output = {value ->
        run {
            when (idx++ % 3) {
                0 -> x = value
                1 -> y = value
                2 -> {
                    if (x == BigInteger.valueOf(-1) && y == BigInteger.valueOf(0)) {
                        score = value
                        if (score > maxScore) {
                            maxScore = score
                        }
                        println("Score = $score")
                    } else {
                        when (value) {
                            BigInteger.TWO -> counter++
                            BigInteger.valueOf(3) -> {
                                paddleX = x
                                paddleY = y
                            }
                            BigInteger.valueOf(4) -> {
                                lastBallX = ballX
                                lastBallY = ballY
                                ballX = x
                                ballY = y
                            }
                        }
                        screen[Pair(x, y)] = value
                    }
                }
            }
        }
    }

    var targetX = BigInteger.valueOf(17);
    var list = listOf<BigInteger>(BigInteger.valueOf(-1), BigInteger.ZERO, BigInteger.ONE);

    fun hackedInput(): BigInteger {
        var myPaddleX = paddleX
//        println("ball = $ballX, $ballY")
//        println("paddle = $paddleX, $paddleY")
//        display(screen)

        if (ballY == BigInteger.valueOf(20)) {
            val left = blocksLeft(screen)
            println("There are $left blocks left, score is $maxScore")
            if (left == 0) {
                println("FINISHED! Score = $maxScore")
                throw StopException()
            }

            val oldScreen = HashMap(screen)
            list = list.shuffled()
            for (i in 0..2) {
                var other = IntMachine(machine)
                var steps = 0
                var first = true
//                println("Will attempt $i. ${list[i]}")
                fun otherInput(): BigInteger {
                    steps += 1
//                    println("Simulating $steps...")
                    if (first) {
                        first = false
                        return list[i]
                    }
                    if (ballY == BigInteger.valueOf(20)) {
                        targetX = ballX
                        throw StopException()
                    }
                    return BigInteger.ZERO
                }
                other.input = { otherInput() }
                try {
                    other.evaluate()
                } catch (e: StopException) {
                    var deltaX = (myPaddleX - targetX).abs()
                    if (deltaX <= steps.toBigInteger()) {
                        println("Target X == $targetX")
                        screen = oldScreen
                        return list[i]
                    } else {
                        println("WTF?!")
                        throw StopException()
                    }
                }
            }

            screen = oldScreen
            return BigInteger.ONE
        }

//        display(screen)
        if (targetX > paddleX) {
            return BigInteger.ONE
        }
        if (targetX < paddleX) {
            return BigInteger.valueOf(-1)
        }

        return BigInteger.ZERO
    }

    machine.input = { hackedInput() }
    try {
        machine.evaluate()
    } catch(e: StopException) {
        println(counter)
        println("Score = $score")
    }
}

fun display(screen: Map<Pair<BigInteger, BigInteger>, BigInteger>) {
    for (j in 0..22) {
        for (i in 0..34) {
            show(screen.getOrDefault(
                Pair(BigInteger.valueOf(i.toLong()), BigInteger.valueOf(j.toLong())),
                BigInteger.ZERO
            ))
        }
        println()
    }
}

fun show(x: BigInteger) {
    when (x) {
        BigInteger.ZERO -> print(" ")
        BigInteger.ONE -> print("#")
        BigInteger.TWO -> print("X")
        BigInteger.valueOf(3) -> print("-")
        BigInteger.valueOf(4) -> print("O")
        else -> print("?")
    }
}

fun blocksLeft(screen: Map<Pair<BigInteger, BigInteger>, BigInteger>): Int {
    var cnt = 0
    for (j in 0..22) {
        for (i in 0..34) {
            if (screen[Pair(BigInteger.valueOf(i.toLong()), BigInteger.valueOf(j.toLong()))] == BigInteger.TWO) {
                ++cnt
            }
        }
    }
    return cnt
}

class StopException: Exception() {

}