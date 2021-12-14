% use_module(library(dcg/high_order)).
% Check https://github.com/Limmen/Advent-Of-Code16-Prolog/blob/master/day3/3a.pl for input reading

% Running:
% swipl dayX.pl
% ?- run_part_one.
% ?- run_part_two.

:- use_module(library(dcg/basics)).

% Checks for codepoints and converts them to a proper string
custom_str(Instruction, Str) -->
    string(Instruction),
    { text_to_string(Instruction, Str) }.

% File input parsing using DCGs (Definite Clause Grammar)
parse([]) --> ( "\n\n" ;  eos ), !.
parse([(Str, Num)|Nums]) --> custom_str(Instruction, Str), " ", integer(Num), "\n", parse(Nums).
readfile(Out):-
    phrase_from_file(parse(Out), "day2.txt").

% Test
test:-
    drive([("forward", 5), ("down", 5), ("forward", 8), ("up", 3), ("down", 8), ("forward", 2)], 15, 10).

% Run example
run_pt_one:-
    readfile(Instructions),
    write(Instructions),
    !,
    drive(Instructions, Horiz, Vert),
    write(Horiz),
    write("\n"),
    write(Vert),
    write("\n"),
    V0 is Horiz * Vert,
    write(V0).

drive(Xs, Horiz, Vert):-
    % Reverse the list so we process it in the right order (first instruction to last)
    % This isn't strictly necessary but in case the order matters in the future...
    reverse(Xs, Ys),
    !,
    % Used the reverse list for computation
    path(Ys, Horiz, Vert).

path([], 0, 0) :- !.
path([("forward", Num) | Rest], Horiz, Vert):-
    path(Rest, Horiz0, Vert),
    Horiz is Horiz0 + Num.
path([("down", Num) | Rest], Horiz, Vert):-
    path(Rest, Horiz, Vert0),
    Vert is Vert0 + Num.
path([("up", Num) | Rest], Horiz, Vert):-
    path(Rest, Horiz, Vert0),
    Vert is Vert0 - Num.

% Part2

test2:-
    drive2([("forward", 5), ("down", 5), ("forward", 8), ("up", 3), ("down", 8), ("forward", 2)], 15, 60, _).

% Run example
run_pt2:-
    readfile(Instructions),
    write(Instructions),
    !,
    drive2(Instructions, Horiz, Vert, _),
    write("\n"),
    write(Horiz),
    write("\n"),
    write(Vert),
    write("\n"),
    V0 is Horiz * Vert,
    write(V0).


drive2(Xs, Horiz, Vert, Aim):-
    % Reverse the list so we process it in the right order (first instruction to last)
    % This isn't strictly necessary but in case the order matters in the future...
    reverse(Xs, Ys),
    !,
    % Used the reverse list for computation
    path2(Ys, Horiz, Vert, Aim).

path2([], 0, 0, 0) :- !.
path2([("forward", Num) | Rest], Horiz, Vert, Aim):-
    path2(Rest, Horiz0, Vert0, Aim),
    Horiz is Horiz0 + Num,
    Vert is Vert0 + (Aim * Num).
path2([("down", Num) | Rest], Horiz, Vert, Aim):-
    path2(Rest, Horiz, Vert, Aim0),
    Aim is Aim0 + Num.
path2([("up", Num) | Rest], Horiz, Vert, Aim):-
    path2(Rest, Horiz, Vert, Aim0),
    Aim is Aim0 - Num.
