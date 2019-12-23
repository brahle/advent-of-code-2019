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

func main() {
	reader := bufio.NewReader(os.Stdin)

	var inDegree map[string]int
	inDegree = make(map[string]int)

	var equationMap map[string]Equation
	equationMap = make(map[string]Equation)

	var required map[string]int64
	required = make(map[string]int64)

	equations := make([]Equation, 0, 0)

	for {
		text, err := reader.ReadString('\n');
		if (err != nil) {
			fmt.Println(err)
			break
		}
		text = strings.TrimSpace(text);
		parts := strings.Split(text, " => ");
		left := strings.Split(parts[0], ", ");
		inputs := make([]Element, 0, 0);
		output := parseElement(parts[1])
		required[output.name] = 0
		for _, x := range left {
			element := parseElement(x)
			inputs = append(inputs, element)
			val, ok := inDegree[element.name]
			if !ok {
				val = 1
			} else {
				val += 1
			}
			inDegree[element.name] = val
			required[element.name] = 0
		}
		equation := Equation {
			inputs: inputs,
			output: output,
		}
		equations = append(equations, equation)
		equationMap[output.name] = equation
	}

	required["FUEL"] = 1
	queue := make([]string, 0)
	queue = append(queue, "FUEL")

	for ; len(queue) > 0; {
		current := queue[0]
		if current == "ORE" {
			fmt.Println(required[current]);
			break;
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

}

func parseElement(x string) Element {
	pieces := strings.Split(x, " ");
	count, _ := strconv.Atoi(pieces[0])
	return Element {
		name: pieces[1],
		count: int64(count),
	}
}
