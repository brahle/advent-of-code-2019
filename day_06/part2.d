module day_06.part2;

import std.algorithm;
import std.array;
import std.container.rbtree;
import std.file;
import std.stdio;

void main() {
    string input_file_name = "/home/brahle/dev/advent-of-code/2019/day_06/sample.2";
    string[][string] edges;
    int[string] distance;

    auto input_file = File(input_file_name);
    auto lines = input_file.byLine()
        .map!(line => split(line, ")"));

    foreach (line; lines) {
        string parent = line[0].idup();
        string child = line[1].idup();
        // if (parent !in edges) {
        //     string[] t;
        //     edges[parent] = t;
        // }
        // if (child !in edges) {
        //     string[] t;
        //     edges[child] = t;
        // }
        distance[parent] = 0x3f3f3f3f;
        distance[child] = 0x3f3f3f3f;
        edges[parent] ~= child;
        edges[child] ~= parent;
    }

    string[] Q;
    distance["YOU"] = 0;
    Q ~= "YOU";

    for (int i = 0; i < Q.length; ++i) {
        string current = Q[i];
        foreach (next; edges[current]) {
            if (distance[current] + 1 < distance[next]) {
                distance[next] = distance[current] + 1;
                Q ~= next;
            }
        }
    }

    writeln(distance["SAN"]);
}
