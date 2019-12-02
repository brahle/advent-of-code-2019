-module(part1).
-export([readlines/1, solve/1]).

solve([]) ->
    0;
solve([First | Rest]) ->
    solveOne(First) + solve(Rest).

solveOne(X) ->
    list_to_integer(binary_to_list(X)) div 3 - 2.

% https://stackoverflow.com/questions/2475270/how-to-read-the-contents-of-a-file-in-erlang
readlines(FileName) ->
    {ok, Data} = file:read_file(FileName),
    binary:split(Data, [<<"\n">>], [global]).
