import java.math.BigInteger

fun main() {
    val values: String = readLine()!!
    val machine = IntMachine(values, "")
    var idx = 0
    var counter = 0

    machine.output = {x ->
        run {
            print("$idx: $x ")
            idx++
            if (idx % 3 == 0) {
                if (x == BigInteger.TWO) {
                    print(" <---")
                    counter++
                }
                println()
            }
        }
    }
    machine.evaluate()
    println(counter)
}
