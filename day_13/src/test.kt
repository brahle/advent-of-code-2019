fun main() {
    val values: String = readLine()!!
    val inputs: String = readLine()!!
    val machine = IntMachine(values, inputs)
    machine.evaluate()
}
