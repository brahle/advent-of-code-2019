import java.lang.Exception
import java.math.BigInteger
import java.util.*
import kotlin.collections.HashMap

class IntMachine {
    var position: BigInteger = BigInteger.ZERO
    var relativeIndex: BigInteger = BigInteger.ZERO
    var memory = mutableMapOf<BigInteger, BigInteger>()
    var inputs = ArrayDeque<BigInteger>()
    var input = { inputs.pop(); }
    var output = { x: BigInteger -> println("OUTPUT: $x") }

    constructor(values: String, inputs: String) {
        values.split(",")
            .mapIndexed { index, s -> memory[BigInteger.valueOf(index.toLong())] = s.toBigInteger() }
        if (inputs != "") {
            inputs.split(",").forEach { value -> this.inputs.push(value.toBigInteger())}
        }
    }

    constructor(other: IntMachine) {
        this.position = other.position
        this.relativeIndex = other.relativeIndex
        this.memory = HashMap(other.memory) as MutableMap<BigInteger, BigInteger>
        this.inputs = ArrayDeque(other.inputs)
        this.input = other.input
        this.output = other.output
    }

    fun evaluate() {
        while (evaluateNext()) {}
    }

    fun evaluateNext(): Boolean {
        return when (operation()) {
            1 -> op1()
            2 -> op2()
            3 -> op3()
            4 -> op4()
            5 -> op5()
            6 -> op6()
            7 -> op7()
            8 -> op8()
            9 -> op9()
            99 -> op99()
            else -> throw Exception("Unexpected operation " + operation())
        }
    }

    private fun op1(): Boolean {
        write(3, resolve(1) + resolve(2))
        position += BigInteger.valueOf(4)
        return true
    }

    private fun op2(): Boolean {
        write(3, resolve(1) * resolve(2))
        position += BigInteger.valueOf(4)
        return true
    }

    private fun op3(): Boolean {
        write(1, input())
        position += BigInteger.TWO
        return true
    }

    private fun op4(): Boolean {
        output(resolve(1))
        position += BigInteger.TWO
        return true
    }

    private fun op5(): Boolean {
        if (resolve(1) != BigInteger.ZERO) {
            position = resolve(2)
        } else {
            position += BigInteger.valueOf(3)
        }
        return true
    }

    private fun op6(): Boolean {
        if (resolve(1) == BigInteger.ZERO) {
            position = resolve(2)
        } else {
            position += BigInteger.valueOf(3)
        }
        return true
    }

    private fun op7(): Boolean {
        if (resolve(1) < resolve(2)) {
            write(3, BigInteger.ONE)
        } else {
            write(3, BigInteger.ZERO)
        }
        position += BigInteger.valueOf(4)
        return true
    }

    private fun op8(): Boolean {
        if (resolve(1) == resolve(2)) {
            write(3, BigInteger.ONE)
        } else {
            write(3, BigInteger.ZERO)
        }
        position += BigInteger.valueOf(4)
        return true
    }

    private fun op9(): Boolean {
        relativeIndex += resolve(1)
        position += BigInteger.TWO
        return true
    }

    private fun op99(): Boolean {
        println("DONE " + memory[BigInteger.ZERO]!!.toString())
        return false
    }

    private fun op(): Int {
        return memory[position]!!.toInt()
    }

    private fun operation(): Int {
        return op() % 100
    }

    private fun resolve(index: Int): BigInteger {
        return when (mode(index)) {
            0 -> positional(index)
            1 -> immediate(index)
            2 -> relative(index)
            else -> throw Exception("Not implemented")
        }
    }

    private fun mode(index: Int): Int {
        return when (index) {
            1 -> op() / 100 % 10
            2 -> op() / 1000 % 10
            3 -> op() / 10000 % 10
            4 -> op() / 100000 % 10
            else -> throw Exception("Not implemented")
        }
    }

    private fun positional(index: Int): BigInteger {
        return read(memory[position + BigInteger.valueOf(index.toLong())]!!)
    }

    private fun immediate(index: Int): BigInteger {
        return read(position + BigInteger.valueOf(index.toLong()))
    }

    private fun relative(index: Int): BigInteger {
        return read(relativeIndex + memory[position + BigInteger.valueOf(index.toLong())]!!)
    }

    private fun read(x: BigInteger): BigInteger {
        return memory.getOrDefault(x, BigInteger.ZERO)
    }

    private fun write(index: Int, value: BigInteger) {
        memory[getWriteIndex(index)] = value
    }

    private fun getWriteIndex(index: Int): BigInteger {
        return when (mode(index)) {
            0 -> read(position + BigInteger.valueOf(index.toLong()))
            2 -> read(position + BigInteger.valueOf(index.toLong())) + relativeIndex
            else -> throw Exception("Unexpected write index " + mode(index))
        }
    }
}