%% tokens(S, C, W, Type, IsCap, IsFirst, Pos, IsApop).

idspace_regularity('UBERON',label,99).
idspace_regularity('UBERON',_,85).
idspace_regularity('GO',_,99).
idspace_regularity('DOID',label,90).

is_first_word_cap('HP').

is_all_cap('OMIM').


proper(W,Score) :-
        tokens(S, _, W, Type, true, _, _, _),
        idspace_regularity(S,Type,Score).

proper(W,90) :-
        tokens(S, _, W, _, true, false, _, _),
        is_first_word_cap(S).

proper(W,80) :-
        tokens(S, _, W, _, true, _, _, true),
        is_all_cap(S).


