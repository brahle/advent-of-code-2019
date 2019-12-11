# Advent of Code 2019

Solutions to the [Advent of Code 2019](https://adventofcode.com/2019) problems.
The solution for every day is written in a different language.

Table of contents:

- [Advent of Code 2019](#advent-of-code-2019)
  - [Day 1 - Erlang](#day-1---erlang)
  - [Day 2 - OCaml](#day-2---ocaml)
  - [Day 3 - SQL](#day-3---sql)
  - [Day 4 - Excel](#day-4---excel)
  - [Day 5 - Bash](#day-5---bash)
  - [Day 6 - D](#day-6---d)

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
`UNNEST ... WITH ORDINALITY`. It was mostly smooth sailing and things went as
planned from that point on. Oh, and I YOLOed the fact that there were not going
to be purely horizontal or purely vertical intersections.

Thankfully [part 2](day_03/45_part2.sql) just required fairly simple
modifications to the intermediary tables I created along the way to keep the
track of the total wire length so far.

## Day 4 - Excel

One of the other non-standard "programming languages" that I have on my list to
use during this advent of code is Excel. Microsoft Excel needs no introduction
as I believe most of the World is already acquainted with it. When I read the
problem today I got really giddy because the first part of the problem has a
fairly straightforward solution in a spread-sheeting system. Nevertheless, I
still couldn't be fully sure about the second part of the exercise but I decided
I liked the odds.

Because the numbers were fairly limited in size, a generating solution where you
try all of the numbers in the range would work in a reasonable amount of time.
Therefore, my approach for the problem was to create a list of all numbers in
the range and check if they fit the criteria. It turns out the hardest part was
to figure out how to solve generate that list without "dragging" the cells for
an hour, but a bit of Googling revealed that I should use the Fill > Series tool
from the Home ribbon.

To solve the first part, I split the checks into two (are the digits
non-decreasing and are there at least two consecutive equal digits). Those
columns were combined with a simple multiplication, and the result was the sum
of those columns.

To make my life a bit easier in the second part, I separated the digits into
individual columns. The second check was reworked into a check wether exactly
two consecutive digits are the same.

Enjoy the [40+ MB spreadsheet](day_04/Solution.xlsx) if you are interested for
the actual implementation of the solution. Column D holds the solution to the
first part, and Column L for the second part.

## Day 5 - Bash

Having read the problem today, I immediately recalled the words of certain
Advent of Code veterans that I will have to re-implement the Intcode machine
over and over in each new language. For this iteration, I've decided to try and
use bash, if for no other reason than to refresh my all but forgotten knowledge
of using arrays.

First thing's first, I need to split the string into an array, and it looks like
using `IFS=',' read ...` will do the trick. Things soon turned into a nightmare
as the syntax for working with arrays is exceptionally ugly in bash. Another
problem is bash being really friendly towards "malformed" variable use because
it will interpret a variable with a missing `$` as a string and `$arr[0]` as
`"${arr[0]}[0]"`...

After a fairly long slog, about an hour, I was able to finally get the first
part to work correctly. I thought part 2 was now going to be a piece of cake,
but boy was I wrong. The new opcodes weren't that difficult to implement,
however, there were a few nuances about when to use the immediate mode and when
the positional. I had to go through all of the examples to figure it out fully.

After about 20 minutes of work on the second problem, my code was working for
all of the test examples from the input to both todays task and the day 2
challenge. I ran my solution on the actual input, got a solution, submitted it
and... Wrong answer.

Hm, that was weird. I must have had a bug somewhere... I spot an instance where
I used `resolve` for the parameters and I really shouldn't have done so. I ran
the program again, I get `751309` this time, I submit that... And I get another
wrong answer.

I ran my program on the all of the inputs again. This takes a few minutes in
each iteration as my input was partially via an exported variable in a different
file and partially via keyboard. To my astonishment, I find nothing wrong with
it. I keep adding more and more debugging output to make sure everything is
working fine. The answer I get is still `751309`. Maybe I copied it wrong the
first time around so I try again and, no, this wasn't the problem. `751309` is
not the expected answer.

I spent the next 2 hours staring at the code, the ever increasing mountain of
the debugging output, and the problem statement, being unable to find the bug.
Defeated and it being already past noon, I had to go to work. While I was on the
underground, I read through the detailed debugging transcript of the program,
trying to follow it manually and hoping to stumble into the problem. That was to
no avail, as all of the outputs appeared correct. The answer from my program is
still `751309`.

At work, I kicked off a few large data transformations, and during the time I
was waiting for them to finish, I decided to refactor the code so that it will
be easier to test it. I switched to reading everything from standard input and
wrote a helper shell script that runs one test and compares it to the expected
output ([test.sh](day_05/test.sh)). I also wrote another shell script that runs
all tests in one single go ([test.all.sh](day_05/test.all.sh)). All of the small
tests passed and then I finally added a failing test, for the final input to
part 2, where I didn't actually know what the expected output was. I ran it just
to see it fail, all the while contemplating my miserable existence, my hate for
the number `751309` and what I am planning to do next. As I glanced over the
output of the test case,

```
Files test/test.22.out and out differ
EXPECTED:
OUTPUT: XXXXX
DONE 314

GOT:
OUTPUT: 742621
DONE 314
```

I realized one thing - the output wasn't `751309` any more - it was `742621`!
Without investigating further, I submitted the new solution and started
celebrating my new gold star. You can read my code [here](day_05/machine.sh).

After a joyous few seconds have passed and the adrenaline rush subsided, I had
one thing left to do - figure out what has changed between this run and previous
runs. Since I did not touch the code - the only thing that changed was the
input. I compared the "new" input from the file with the input from the script
and, sure enough, they did differ - the input in the script was missing a "6" at
the end. I failed at copy-paste. Palm, meet face. Face, meet palm. I wasted 2
hours at the minimum, and probably closer to 3, of my life debugging such a
small mistake.

At the very least, I have learned a lot today, namely:

1. Don't blindly trust copy-paste. I will save the data to an input file instead
   from now on.
2. Bash, although it can handle working with arrays, really isn't designed for
   that. Besides re-learning how to use them, I also recalled why I had
   forgotten it.
3. Bash lacks strong typing, and will handle a lot of typos in the
   code silently. That makes it hard to build complex software in it. I'm really
   glad I won't have to solve other problems in it this year.
4. I totally forgot about `set -eux` - had I remembered it, I would have solved
   the problem slightly differently (i.e. not used return values to move the
   position pointer). I would have also solved it probably a bit quicker as some
   of the the errors would become apparent earlier.
5. Have a good and organized test suite for Intcode. I think this will be of
   huge importance for the coming challenges, especially as I will have to
   re-implement it each time.
6. Do not rely on keyboard input (d'oh) to the programs and automate it if
   possible. I wasted a large amount of time because I was manually typing the
   values for opcode 3. Once I modified the input to my program so that it reads
   both the intcode operations and the inputs from the standard input, running
   tests became very simple and quick. It really did pay off.

## Day 6 - D

Dear diary, today is a great day. I've read today's problem gave it a bit of
thought and decided to use a real programming language for a change. One of the
languages that I always wanted to try is D, so I installed the
[DMD](https://dlang.org/download.html) compiler and got cracking.

For the first problem, I planned on doing a topological sort of the input. That
I saved to a file. Reading the file was a fairly simple endeavor, but parsing it
was much harder than I anticipated. D compiler produced errors that I had some
trouble parsing, and I wasted about an hour fighting the associative array
(otherwise know as map or dictionary) declaration. I used `string[string[]]`
instead of the `string[][string]` to represent what would be a `map<string,
vector<string>>` in C++. I have to say that I am not a huge fan of that form of
template typing - I prefer the longer but easier to understand form of C++ and
Java.

After my struggles with the compiler were done, the algorithm itself for [part
1](day_06/part1.d) was fairly simple. [Part 2](day_06/part2.d) was a basic BFS
that took me just a few minutes to implement.

Overall, while D seems like a powerful language, searching for the documentation
and examples was hard. I also am not sure what the complexity involved when
using the associative arrays are, but I would assume it is implemented as a hash
map. What I found really interesting is the fact that the compiler error
messages do not seem to be that much better than C++ - but at least for the most
part, they fit on the screen.

## Day 7 - Haskell

Another day, another intcode, another new language. This time, the choice fell
on [Haskell](https://en.wikipedia.org/wiki/Haskell_%28programming_language%29).
Why Haskell? Because a colleague at work has been raving on how Haskell is the
perfect choice for implementing the intcode interpreter. It took me three days
to finish writing this solution, mostly because of some obligations I had in
real life that meant I didn't have the time for advent of code. That does not
mean that you will be spared of complaints.

The main reason why I couldn't finish writing my solution in one sitting is
because I simply didn't know Haskell. It's syntax is far less forgiving than the
other langauges I used, pretty much the opposite of bash in which I implemented
my last intcode interpreter. What I discovered was that Haskell really has a
completely different paradigm than any other programming language I've used
before.

The most annoying thing about Haskell comes when you turn to Ecosia (or Google)
to figure something out. You usually are able to find a lost soul asking exactly
what you want, praise the good fortune that their question has an answer but
then read said answer where some prick with a hollier-than-though attitude asks
the question author what they "really mean" because obviously the question makes
no sense to ask in Haskell as Haskell wasn't designed to answer it. The expert
then helpfully proceeds to explain a solution tangential to the problem using
overly complex nomenclature so you have to spend the next 20 minutes Googling
what those terms mean and hoping that you can re-forumlate your question so that
you can re-use that solution. Frustrated, me? No way, where did you get that
idea?

In terms of the actual code I had to write, one of the biggest challenges was
the use of monads (monoids in the category of endofunctors) to handle the input
and output. I've never seen a programming language so determined to prevent any
interaction between the program and the user. In total, I believe I've spent
about four hours just trying to get the input, output and some debugging
going...

Another part of the struggle was figuring out how to send "objects" around
instead of having to send a quadrillion argument to each function, but I managed
to figure it out by "reading the fucking manual". Which brings me to my next
point - the documentation is pretty good, and the biggest flaw it has is that is
also really verbose which made finding specific tidbits of knowledge hard.

Re-implementing the [machine](day_07/Machine.hs) for the third time was much
easier than the previous two times because I had a test suite from before. I
made only one bug that persisted through the annoyingily nitpicky (but in a good
way) Haskell compiler, which the tests caught very easily. The solution to
[part 1](day_07/Part1.hs) was fairly simple and direct - I just take the output
of the machine and pass it around.

[Part 2](day_07/Part2.hs), however, gave me much more trouble, again mostly
because I don't know Haskell. I wanted to implement the feedback loop using
generating functions `() -> Int` that would read/write to lists that all of the
machines have access to, but after about an hour or two of trying I am
embarassed to admit that I failed to write even a generating function that would
return different values on each subsequent call... I ended up settling on
re-writing the `evaluate` function in such a way that it knows of multiple
machines and proceeds to evaulate the next one when opcode 3 is received.

Overall, I am happy with this "day" - I feel like I learnt a lot. I now can sort
of read and write some Haskell code. My implementation is not the most efficient
and I'm just glad that performance wasn't necessary.

# Day 8 - Scratch

After reading today's problem, I decided to take another risk and try and solve
this problem using the
[Scratch](https://en.wikipedia.org/wiki/Scratch_%28programming_language%29)
programming language. I had a pretty good idea how to solve the first part, but
I did not know what to expect in the second part.

My approach was fairly straightforward for both parts. The solutions cannot be
found in the repository, however, they are only available online:
[Part 1](https://scratch.mit.edu/projects/352349465) and
[Part 2](https://scratch.mit.edu/projects/352353880/). For part 2, I exported
the output to a file, and then reformatted it in the textual document to make
the output readable.

Contrary to what you might believe, this problem required me to invest least
amount of time compared to any other so far. Scratch is just an easy and
straightforward programming langauge and is powerful enough to solve problems
like these without much sweat.
