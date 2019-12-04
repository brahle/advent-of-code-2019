# Advent of Code 2019

Solutions to the [Advent of Code 2019](https://adventofcode.com/2019) problems.
The solution for every day is written in a different language.

Table of contents:

- [Advent of Code 2019](#advent-of-code-2019)
  - [Day 1 - Erlang](#day-1---erlang)
  - [Day 2 - OCaml](#day-2---ocaml)
  - [Day 3 - SQL](#day-3---sql)

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

## Day 3 - SQL

People who have done advent of code before have told me that the problems keep
getting progressively harder. Since 25 is actually a fairly large number in
terms of different programming languages, I want to add some non-traditional
ones to the list as well. I think using SQL for a programming competition falls
into that category so I was excited to find that I had an idea how to solve the
day 3 problem using it. However, since I don't know what to expect in part 2, it
had the potential to turn sour.

The variant of SQL I decided to use was
[PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL), which I had installed
some time ago inside Ubuntu on Windows Subsystem for Linux. Of course it was
turned off and of course I tried to run `service postgresql start` with two
wrong users (myself and postgres) before I Googled that I should probably run it
as root, but all in all, it did not take me very long to set up the environment.

My approach to the problem was as follows:

1. [Generate a table consisting of inputs](day_03/00_init.sql) - one row per
   wire per test case
2. Split the wire on commas into an array
3. Explode the array into multiple rows
4. Parse the x and y deltas (stored as intermediary table
   [exploded_input](day_03/10_explode.sql))
5. Calculate the cumulative sum of x and y deltas for each wire
6. Calculate the starting and ending positions of each wire segment
   ([calculated_xy](day_03/20_calculate_x_y.sql))
7. Join the first wire and the second wire
8. Find where the wires intersect ([intersections](day_03/30_find_intersections.sql))
9. Calculate the Manhattan distance
10. Find the minimum distance ([part 1 solution](day_03/40_part1.sql))

I didn't know the how to do the step 3 (explode) so I turned to my search engine
of choice - [Ecosia](https://www.ecosia.org/), powered by Microsoft - and the
results started giving me a small panic attack that it might not go as planned.
The first result was a fairly [useless documentation
entry](https://www.w3resource.com/PostgreSQL/split_part-function.php) for the
`SPLIT_PART()` function where explode isn't even mentioned on the page. The
second result was a more relevant [thread from
2001.](https://www.postgresql.org/message-id/00e401c12a4c$054036a0$279c10ac@INTERNAL)
saying that it is not possible... I then had to turn to Google to learn about
`UNNEST ... WITH ORDINALITY`. However, after that part, it was mostly smooth
sailing and things went as planned. Oh, and I YOLOd the fact that there were not
going to be purely horizontal or purely vertical intersections and got lucky.

Thankfully for me, [part 2](day_03/45_part2.sql) just required fairly simple
modifications to the intermediary tables I created along the way to keep the
track of the total wire length so far.
