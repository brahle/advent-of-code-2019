# Advent of Code 2019

Solutions to the [Advent of Code 2019](https://adventofcode.com/2019) problems.
The solution for every day is written in a different language.

Table of contents:

- [Advent of Code 2019](#advent-of-code-2019)
  - [Day 1 - Erlang](#day-1---erlang)
  - [Day 2 - OCaml](#day-2---ocaml)

## Day 1 - Erlang

I have solved the day 1 problem using
[Erlang](https://en.wikipedia.org/wiki/Erlang_%28programming_language%29). The
environment setup was very straightforward and I didn't run into any issues.
This was the first time I have ever touched Erlang, so I had to Google how to do
the basic stuff (e.g. read and parse the contents of the file).

[Solution to part 1](day_01/part1.erl) was really straightforward and it does
not require much further commentary.

In [part 2](day_01/part2.erl), I made a mistake of calculating the fuel required
\- I wasn't paying attention to the problem statement and I calculated it once,
on the sum of all values.

## Day 2 - OCaml

I've decided to continue in the functional fashion for day 2 and wrote the
solution in [OCaml](https://en.wikipedia.org/wiki/OCaml). Again, this was the
first time I was using the language. It was a bit more frustrating experience
than Erlang for a variety of reasons. Firstly, the environment setup took a bit
longer as ["The Basics" tutorial](https://ocaml.org/learn/tutorials/basics.html)
recommended to also install `utop` in addition to `ocaml`, and for that I had to
install `opam` as well. Secondly, the fact that `Str.split` is in a library that
needs to be linked into the program is a bit crazy to me and took me a chunk of
time to figure out. It just feels inconsistent because `List.map` or `printf`
worked either directly or via an `open` statement. Finally, and this one is
mostly due to me being a noob, I spent a decent bit of time trying to convert
the input from a list of strings to a list of integers and debugging it was not
the easiest. Again I had to copy the code for reading, this time I did that from
the [official
documentation](https://ocaml.org/learn/tutorials/file_manipulation.html).

As for the problem itself, in the [first part](day_02/part1.ml) I made the
mistake of not changing the 1. and 2. input values to the values specified in
the text of the problem. Another mistake I made, which was partially because I
wasn't fully aware of what I was doing, was using `(List.nth values x)` instead
of `(List.nth values (List.nth values x))`. Finally, I'm pretty sure I make a
copy of the list each time I call my `replace` function, but I don't care as the
input was small enough.

In [part deux](day_02/part2.ml) I for some reason thought I need to modify
positions 0 and 1 for the "verb" and "noun". Thankfully, there were no solutions
like that found so I was able to fix it fairly quickly.


I **really** should read the problem statements more carefully.