-module(part1).
-export([readlines/1, solve/1]).

solve([]) ->
    0;
solve([First | Rest]) ->
    solveOne(First) + solve(Rest).

solveOne(X) ->
    list_to_integer(binary_to_list(X)) div 3 - 2.

readlines(FileName) ->
    {ok, Data} = file:read_file(FileName),
    binary:split(Data, [<<"\n">>], [global]).
