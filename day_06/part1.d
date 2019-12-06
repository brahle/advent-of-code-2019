import std.algorithm;
import std.array;
import std.container.rbtree;
import std.file;
import std.stdio;

void main() {
    string input_file_name = "/home/brahle/dev/advent-of-code/2019/day_06/input";
    string[][string] child_to_parent;
    string[][string] parent_to_child;
    int[string] count_of_children;
    int[string] children_in_subgraph;

    auto input_file = File(input_file_name);
    auto lines = input_file.byLine()
        .map!(line => split(line, ")"));

    foreach (line; lines) {
        string parent = line[0].idup();
        string child = line[1].idup();
        if (parent !in count_of_children) {
            count_of_children[parent] = 0;
            children_in_subgraph[parent] = 0;
            string[] t1;
            parent_to_child[parent] = t1;
            string[] t2;
            child_to_parent[parent] = t2;
        }
        if (child !in count_of_children) {
            count_of_children[child] = 0;
            children_in_subgraph[child] = 0;
            string[] t1;
            parent_to_child[child] = t1;
            string[] t2;
            child_to_parent[child] = t2;
        }
        ++count_of_children[parent];
        child_to_parent[child] ~= parent;
        parent_to_child[parent] ~= child;
    }

    string[] candidates;
    foreach (candidate; count_of_children.keys) {
        if (count_of_children[candidate] == 0) {
            candidates ~= candidate;
        }
    }

    int solution = 0;
    for (int i = 0; i < candidates.length; ++i) {
        auto candidate = candidates[i];
        writeln(candidate);
        foreach (parent; child_to_parent[candidate]) {
            children_in_subgraph[parent] += 1 + children_in_subgraph[candidate];
            solution += 1 + children_in_subgraph[candidate];
            count_of_children[parent] -= 1;
            if (count_of_children[parent] == 0) {
                candidates ~= parent;
            }
        }
    }

    writeln(solution);
}
