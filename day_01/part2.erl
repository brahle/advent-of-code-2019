-module(part2).
-export([readlines/1, solve/1]).

solve([]) ->
    0;
solve([First | Rest]) ->
    X = parseAndSolveOne(First),
    X + solveFuel(X) + solve(Rest).

solveFuel(X) when X<9 ->
    0;
solveFuel(X) ->
    Y = solveOne(X),
    Y + solveFuel(Y).

parseAndSolveOne(X) ->
    solveOne(list_to_integer(binary_to_list(X))).
solveOne(X) ->
    X div 3 - 2.

% https://stackoverflow.com/questions/2475270/how-to-read-the-contents-of-a-file-in-erlang
readlines(FileName) ->
    {ok, Data} = file:read_file(FileName),
    binary:split(Data, [<<"\n">>], [global]).
