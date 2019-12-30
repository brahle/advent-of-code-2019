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
  - [Day 7 - Haskell](#day-7---haskell)
  - [Day 8 - Scratch](#day-8---scratch)
  - [Day 9 - C#](#day-9---c)
  - [Day 10 - Ruby](#day-10---Ruby)
  - [Day 11 - Scala](#day-10---Scala)
  - [Day 12 - Perl](#day-12---Perl)
  - [Day 13 - Kotlin](#day-13---Kotlin)
  - [Day 14 - Go](#day-14---Go)
  - [Day 15 - Rust](#day-15---Rust)
  - [Day 16 - Fortran](#day-16---Fortran)
  - [Day 17 - PHP](#day-17---PHP)

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

## Day 8 - Scratch

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

## Day 9 - C#

After being burnt and wasting a lot of time on IntCode re-implementations since
the start of the Advent of Code, I decided to treat it seriously this time. I
used C# for this iteration of it. C# is a language that I'm fairly familiar
with, while not being proficient since it's been a very long since we've crossed
paths the last time.

This was the right choice. Not only does C# have full support for the big
integers (which I'm not sure if they were really necessary), using object
oriented programming made the implementation of the original Machine trivial.
The one bug I had in the implementation was that I fogot to implement the new
relative writes. I probably should have restructed the helper functions to be a
bit nicer, but [this implementation](day_09/Day09/Day09/Machine.cs) did the
trick.

Overall, this was a fairly straightforward implementation, although I
overcomplicated it a bit, e.g. by having the operation 4 (write out) call a
callback instead of just writing out the value directly. The one thing I dislike
about C# is the fact that the default code style is inefficient in terms of new
lines - both the open and the closing brackets are on their own line.

## Day 10 - Ruby

I had to take a pause for a few days because I was busy with work, travel,
company holiday parties... Anyway, there still are 8 languages whose knowledge
I'd describe as suspect at best, so for the problems that seem to be one off
they will have to make do. Problem for day 10 appears to fall into this
category.

[Ruby](https://www.youtube.com/watch?v=qObzgUfCl28) was the language of my
choice for this, for no particular reason whatsoever. For the first part of the
problem, I will implement a fairly slow `O(N^2 M^2 (log(N) + log(M)))` (where
`N x M` is the dimension of the board) algorithm that will count the number of
visible asteroids for every position. My plan is to afix the root to an
asteroid, find the (x,y) distance for every other asteroid, normalize the angle
by finding the (x/gcd(x,y), y/gcd(x,y)) and counting how many different angles
are found. I had an off by one error because I forgot to ignore the central
asteroid.

Part 2 was significantly more complicated. My approach to solve the problem
involve a few steps. First, we find all of the asteroids on the same angle.
Within the same angle, we sort them by their distance to get the to different
"cycles" in which they will be destroyed. Finally, we sort all of the asteroids,
first by their cycle, then by their angle.

That was all well and good, but it took me about 2 hours(!) to figure out all of
the details both intrinsic to the task at hand, like the orientation of the
coordinate system in the input, how does that orientation work with the inital
laser and the computational geometry required to solve the problem.

As for my language choice, I'd say Ruby was a very cooperative language and has
not been a detriment in solving the puzzle.

# Day 11 - Scala

Another day, another
[intcode](day_11/src/com/brahle/adventofcode/year2019/IntMachine.scala). This
time, I opted for a language that I don't typically use, but I know well enough
to get by. Since it's based on a JVM, I thought that it will be a breeze to get
it running on Ubuntu on Windows while using IntelliJ to build it. I
unfortunately have to admit that I was wrong.

While my solution for neither
[part 1](day_11/src/com/brahle/adventofcode/year2019/Part1.scala) nor
[part 2](day_11/src/com/brahle/adventofcode/year2019/Part2.scala) was
particularaly nice, I really liked the power of having callbacks for input and
output - they really make it simple to create interactions with the interpreter.

As for the implementation, I initially tested my intcode solution only on the
large example - and it worked fine on it. Then I implemented the solution to the
problem, ran it on the input for day 11, and received a wrong answer. Obviously,
at that point I decided to double check my intcode interpreter was actually
correct so I decided to reuse the testing script from day 9. This is where
things started going wrong, as I did not have Java installed on Ubuntu. How
difficult can it be to install java? Well, to download it from Oracle you need
to sign in to their website. I did not find a password for it in my password
manager, so I went and created an account only to find that an account using my
email already exists. Password reset then did the trick and I was finally able
to download the JDK for Linux. It then took me about an hour to find the right
magical incantation to run my program from the command line... A minute later, I
ran the program on all of the test cases and found that IntCode did not have a
bug.

My attention then fully went to the "today's" part of the program and it turned
out that I made two errors. I swapped the numbers for black and white colors and
had the wrong order for the write color and move order. In part 2, it was mostly
about printing the board in a way that's readable.

## Day 12 - Perl

I felt like summonning Cthulhu today so I wrote the code in the good, old
fashioned [Perl](https://www.perl.org/). I'd be lying if I said that the curious
input format made me think of using regular expressions immediately, seeing as
I'm used to the `scanf` familiy of input functions that can take care of it with
ease. However, I couldn't justify not using them once I started to write the
solution.

Overall, [part 1](day_12/part1.pl) was mostly a boring "implement this" type of
a problem. There's not much to note here, save for the fact that I ran into some
issues when using the arrays.

[Part 2](day_12/part2.pl), on the other hand, was a much more challenging
problem. The key insight is that the cycles can be broken up individually for
each of the three axis. The full cycle can then be found as the least common
multiplier of the individual cycles. My code is really ugly, and I wasted some
time fixing bugs that were introduced by poor copy-pasting.

## Day 13 - Kotlin

I kind of feel like every other day will be a new int code machine. This time, I
opted for a language that I've never used before but shares a lot of
similiraties with my last intcode attempt - Kotlin. It has the Java's
`BigInteger` class which might not actually be necessary (I have a hunch that
64-bit integers are all that's required) but it does make the implementation
feel safer.

The [IntMachine](day_13/src/IntMachine.kt) part of it was pretty much a carbon
copy of the one from day 11. However, Scala does have a bit better support for
the `BigInt` which made the implementation a tiny bit cleaner.

[Part 1](day_13/src/Part1.kt) was really straightforward and fairly simple. I
made a mistake when I counted all twos and not every third one, but that wasn't
a big deal overall.

[Part 2](day_13/src/Part2.kt) was a whole lot harder. I started with first
creating a visualisation of the map to get an understanding of how the arcanoid
game looks like. Next step was to simulate the game until the end and see how
the ball behaves. I liked the fact that the first bounce off the paddle was done
without having to move the paddle and showed that when ball is one row above,
the paddle needs to be right underneath it.

The approach I took to solve this problem was to create a secondary int machine
to simulate the behaviour after bouncing the ball, see where the ball will fall
and move my primary int machine's paddle to the appropriate X coordinate.
Unfortunately, I was met with a curveball - if you move the paddle as the ball
hits it, the balls direction changes. This mean that each time I'm about hit the
ball, I had to test all three possiblities of moving the joystick and choose any
that doesn't end in a game over. My code ended up being disguisting, but it did
the trick... Save for the fact that there was apparently always at least one
block that didn't get destroyed, but I didn't bother fixing that bug as I got
the correct answer.

## Day 14 - Go

I've chosen to write today's solution in a programming lanuguage that I've used
a couple of times, but I don't feel comfortable in. I tactically decided not to
use it on an odd day (when you have to implement intcode). The part that I
strugled with the most was reading and parsing the input, on the other hand the
output experience was really enjoyable - go prints out all types in a sensible
manner. Another thing I didn't like is how "raw" working with dynamic arrays (so
called `slice`) feels - I guess it has its advantages when you need full
control, but that must not be that common.

The [first part](day_14/src/part1/part1.go) was a fairly straightforward problem
after doing a topolgical sort starting from the FUEL.
[Part two](day_14/src/part2/part2.go) was a bit more interesting. The key
insight is that the number that we have to compute can be binary searched - i.e.
if we can create X amount of fuel, we can also create X-1. The function to check
if we can create X units of fuel is fairly simple we just need to change the
starting condition from having to generate 1 unit of fuel to X.

## Day 15 - Rust

A few of my friends have been solving advent of code this year in
[Rust](https://www.rust-lang.org/) so I decided to try my hand at implementing
intcode in it. Another friend told me that 64 bit signed integers should be
enough for the machine to work as expected. That made me believe that even a
lack of a big integer library should not prevent me from being able to solve
this problem.

How did the implementation go? My god, did it take me a while to grok Rust... I
kept running into problems over and over, the first big one was how to pass in a
closure instead of a function so I had to learn more about traits and
references. That was just the beginning, though, as the real problems started
when I wanted to do a bit more complicated state mangling - borrow, mutable
borrow, immutable borrow kept getting in the way. My first breakthrough happened
when I read the
[What is Ownership?](https://doc.rust-lang.org/stable/book/ch04-01-what-is-ownership.html)
chapter in the Rust book. That was enough to have me finish the initial
impelementation of the [intcode](day_15/intcode.rs) and the
[testing program](day_15/classic.rs).

As I started actually working on the soution for the
[part one](day_15/part1.rs), it became clear that what knowledge I had about
Rust was not enough to implement what I had envisioned. My idea for the solution
was to move the robot in a DFS-like fashion with a simulated stack. The `State`
was to be kept in the stack (really just a `Vec<State>`) and each time sending
an input to the machine is needed, throw the current state and the next state on
the stack. If everything was searched and the robot needs to move back, do not
add anything to the stack. When the intcode machine retruns an output, check if
the robot actually moved to the next position. If it did not, remove the last
element from the stack. The problem here was that I needed to modify the same
variables in multiple different places. Therefore, I had to learn about
[`RefCell`](https://doc.rust-lang.org/stable/book/ch15-05-interior-mutability.html)
which sort of feels like cheating and preventing Rust from doing what it's
supposed to do. To find the solution was as easy as running a BFS at the end
from the start to the end position.

I had a few bugs in my implementation, but those were easily discovered as I
added debugging logging.

[Part two](day_15/part2.rs) after part 1 was a breeze, since all that was needed
was to start the BFS at the end and return the maximal distance that the BFS
found.

I have to say that this was the most miserable experience since Haskell, judging
by the amount of time I spent wrestling with the language compared to the amount
of time it took me to come up with the solution for the problem. With how big of
an investment it turned out to be, I'm kind of sad that I won't be doing more
Rust. It reminds me of C/C++, but requires a very different mindset.

## Day 16 - Fortran

I've decided to try this legendary programming language because of all of the
mythical tales surrounding it. The rumor has it that the programmers who know it
are dying out, but the huge software projects written in it are still powering
large swaths of the infrastructure the human race has become dependent on. Who
knows, maybe learning this language might help with employment down the line...
The first part of today's problem seemed like a fairly basic task that I thought
fortran was mostly well suited to, so I decided to take the risk and implement
my solution in it.

One of the amusing problems I ran into was that the `gfortran` compiler that I
used via `f95` decided the version of fortan based on the file extension.

The biggest issue I had during my implementation in [part 1](day_16/part1.f90)
was the fact that I did not know how to use dynamic strings. This meant I
hardcoded some values so my code was ugly and hard to test.

[Part 2](day_16/part2.f90), on the other hand, was a problem that required some
thought. There were three observation that enabled me to solve this problem. The
first was that no number before the index `i` will ever impact any index from
`i` till the end. The second one was that for each index after the half way
mark, you only need to calculate the sum of all of the elements until the end.
Because my skip index was large, these two optimisations were more than enough.

## Day 17 - PHP

Another day, another intcode. This time, I decided again to use a language that
I have a decent bit of experience with - PHP. This is the first language,
besides SQL, that I used in my professional carreer. I used it, or more
precisely, Hack, when I worked at Facebook. In reality I wanted to use Hack,
however, I ran into issues with compiling it and using pre-compiled binaries on
my platform (Windows and Ubuntu on Windows Subsystem for Linux) so that just
wasted some of my time while I was trying to get it to work.

Another timesink I ran into was in the
[intcode implementation](day_17/intmachine.php), where I used
`$this->$relativeIndex` instead of `$this->relativeIndex`. It took me a
surprising amount of time to spot the mistake, even though I knew the mistake
had to do with `relativeIndex` and it's mentioned a total of 4 times. One thing
I forgot about PHP is the fact that you typically want to `use` variables with a
`&` in the callback, and you must use it if you want to change them.

The solution for [part 1](day_17/part1.php) was really straightforward. I first
started with just printing out the board and later added the storing of the
board and detection of the crossings.

I feel like I cheated in [part 2](day_18/part2.php) because I found the path
manually, but I did write some code to verify that the solution was correct
before passing it into the final int machine. Another bug that crept here was
the fact that I copy-pasted some code and re-used a variable I shouldn't have.
