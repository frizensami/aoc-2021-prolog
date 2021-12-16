% Check https://github.com/Limmen/Advent-Of-Code16-Prolog/blob/master/day3/3a.pl for input reading

% Running:
% Test on SWI-Prolog 8.4.1
% Need to `pack_install(reif).` to access the if_ statement.
% swipl day1.pl
% ?- run_part_one.
% ?- run_part_two.

:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).
:- use_module(library(reif)).

% File input parsing using DCGs (Definite Clause Grammar)

% DCG rule: return empty list if we see newlines or end of stream
parse([]) --> ( "\n\n" ;  eos ), !.
% DCG rule: prepend number at head of list once we see an integer, continue to parse rest
parse([Num|Nums]) --> integer(Num), "\n", parse(Nums).
% Read file from the day's input.txt -- apply DCG grammar rule `parse`
readfile(Out):-
    phrase_from_file(parse(Out), "day1.txt").

% Test case
test_one:-
    number_of_increases([123, 456, 222, 222, 223], 2).

% Actual execution, final val printed.
run_part_one:-
    readfile(Nums),
    number_of_increases(Nums, Result),
    print(Result).

% Empty list - no increases, don't backtrack and find alternatives.
number_of_increases([], 0) :- !.
% Same case for similar element
number_of_increases([_], 0) :- !.
% If there are two elements at least..
number_of_increases([X,Y|Rest], N):-
    % If X is less than Y (we're processing the list from the rightmost element first), then add 1
    % otherwise, same result
    (X #< Y -> N #= N0 + 1 ; N #= N0),

    % Recursively, we check the increases without X, and have that result in N0
    number_of_increases([Y | Rest], N0).

    % v1: Base prolog (NOTE: FASTER than clpfd!)
    %% ((X < Y -> N is N0 + 1); (X >= Y -> N is N0)).



% Actual execution, final val printed.
% 1720 is wrong
run_part_two:-
    readfile(Nums),
    number_of_increases_three(Nums, Result),
    print(Result), !.

% Test case
test_two:-
    number_of_increases_three([1, 1, 1, 1, 1, 2, 3, 3], 2), !.

% From AOC website directly
test_two_pt_two:-
    number_of_increases_three([199, 200, 208, 210, 200, 207, 240, 269, 260, 263], 5), !.


number_of_increases_three([N0, N1, N2, N3 | Rest], R):-

    % Define two intermediate variables to compute the two sums
    V0 #= (N0 + N1 + N2),
    V1 #= (N1 + N2 + N3),
    % Check whether one sum is more than the other and update the result value accordingly
    (
        (V0 #< V1) -> R #= R0 + 1 ; R #= R0
    ),

    % Recursively, we check the increases without N0, and have that result in N0
    number_of_increases_three([N1, N2, N3 | Rest], R0).
    % v1: Base prolog (NOTE: FASTER than clpfd!)
    %% % Define two intermediate variables to compute the two sums
    %% V0 is (N0 + N1 + N2),
    %% V1 is (N1 + N2 + N3),
    %% % Check whether one sum is more than the other and update the result value accordingly
    %% (
    %%     (V0 < V1) -> R is R0 + 1;
    %%     (V0 >= V1) -> R is R0
    %% ).

number_of_increases_three(_, 0) :- !.
