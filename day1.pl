% use_module(library(dcg/high_order)).
% Check https://github.com/Limmen/Advent-Of-Code16-Prolog/blob/master/day3/3a.pl for input reading

% Running:
% swipl day1.pl
% ?- test.

:- use_module(library(dcg/basics)).

% File input parsing using DCGs (Definite Clause Grammar)

% DCG rule: return empty list if we see newlines or end of stream
parse([]) --> ( "\n\n" ;  eos ), !.
% DCG rule: prepend number at head of list once we see an integer, continue to parse rest
parse([Num|Nums]) --> integer(Num), "\n", parse(Nums).
% Read file from the day's input.txt -- apply DCG grammar rule `parse`
readfile(Out):-
    phrase_from_file(parse(Out), "day1.txt").

% Test case
test:-
    number_of_increases([123, 456, 222, 222, 223], 2).

% Actual execution, final val printed.
run:-
    readfile(Nums),
    number_of_increases(Nums, Result),
    print(Result).

% Empty list - no increases, don't backtrack and find alternatives.
number_of_increases([], 0) :- !.
% Same case for similar element
number_of_increases([_], 0) :- !.
% If there are two elements at least..
number_of_increases([X,Y|Rest], N):-
    number_of_increases([Y | Rest], N0),
    % If X is less than Y (we're processing the list from the rightmost element first), then add 1
    % otherwise, same result
    ((X < Y -> N is N0 + 1); (X >= Y -> N is N0)).
    % ((Y > X, N0 is N + 1); (Y =< X, N0 is N)),

