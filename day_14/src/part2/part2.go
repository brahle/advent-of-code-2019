package main

import "bufio"
import "fmt"
import "os"
import "strconv"
import "strings"

type Element struct {
	name string
	count int64
}

type Equation struct {
	inputs []Element
	output Element
}

type Edge struct {
	source string
	cost int64
}

const limit int64 = 1000000000000

func main() {
	reader := bufio.NewReader(os.Stdin)

	equations := make([]Equation, 0, 0)

	for {
		text, err := reader.ReadString('\n');
		if (err != nil) {
			break
		}
		text = strings.TrimSpace(text);
		parts := strings.Split(text, " => ");
		left := strings.Split(parts[0], ", ");
		inputs := make([]Element, 0, 0);
		output := parseElement(parts[1])
		for _, x := range left {
			element := parseElement(x)
			inputs = append(inputs, element)
		}
		equation := Equation {
			inputs: inputs,
			output: output,
		}
		equations = append(equations, equation)
	}


	l := int64(1)
	r := limit
	for {
		if l + 1 == r {
			break
		}
		m := l + (r - l) / 2
		if canMake(m, equations) {
			l = m
		} else {
			r = m
		}
	}
	fmt.Println(l)
}

func parseElement(x string) Element {
	pieces := strings.Split(x, " ");
	count, _ := strconv.Atoi(pieces[0])
	return Element {
		name: pieces[1],
		count: int64(count),
	}
}

func canMake(number int64, equations []Equation) bool {
	var inDegree map[string]int
	inDegree = make(map[string]int)

	var required map[string]int64
	required = make(map[string]int64)

	var equationMap map[string]Equation
	equationMap = make(map[string]Equation)

	for _, eq := range equations {
		required[eq.output.name] = 0
		for _, element := range eq.inputs {
			val, ok := inDegree[element.name]
			if !ok {
				val = 1
			} else {
				val += 1
			}
			inDegree[element.name] = val
			required[element.name] = 0
		}
		equationMap[eq.output.name] = eq
	}

	required["FUEL"] = number
	queue := make([]string, 0)
	queue = append(queue, "FUEL")

	for ; len(queue) > 0; {
		current := queue[0]
		if current == "ORE" {
			fmt.Println(required[current]);
			return required[current] <= limit;
		}
		if (required[current] > limit) {
			return false;
		}
		equation := equationMap[current]
		need := (required[current] + equation.output.count - 1) / equation.output.count
		for _, x := range equation.inputs {
			inDegree[x.name] -= 1
			required[x.name] += x.count * need
			if inDegree[x.name] == 0 {
				queue = append(queue, x.name)
			}
		}
		queue = queue[1:]
	}

	return false;
}


