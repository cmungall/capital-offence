%% tokens(S, C, W, Term, Type, IsCap, IsFirst, Pos, IsApop).

idspace_regularity('UBERON',label,99).
idspace_regularity('UBERON',_,85).
idspace_regularity('GO',_,99).
%idspace_regularity('MP',_,95).
idspace_regularity('MP',label,95).
idspace_regularity('DOID',label,90).
idspace_regularity('ENVO',label,90).

is_first_word_cap('HP').

is_all_cap('OMIM').

proper(W,Score) :-
        proper1(W,Score),
        \+ blacklisted(W).

proper1(W,Score) :-
        tokens(S, _, W, _, Type, true, _, _, _),
        idspace_regularity(S,Type,Score).

proper1(W,90) :-
        tokens(S, _, W, _, _, true, false, _, _),
        is_first_word_cap(S).

proper1(W,80) :-
        tokens(S, _, W, _, _, true, _, _, true),
        is_all_cap(S).

mistake(should_be_lc,W,C,Term,Type) :-
        should_be_lc(W,C,Term,Type).
mistake(should_be_uc,W,C,Term,Type) :-
        should_be_uc(W,C,Term,Type).

should_be_lc(W,C,Term,Type) :-
        curated_negative(W),
        tokens(S, C, W, Term, Type, true, _, _, _),
        idspace_regularity(S,Type,_).

should_be_lc(W,C,Term,Type) :-
        curated_negative(W),
        tokens(S, C, W, Term, Type, true, false, _, _),
        is_first_word_cap(S).

should_be_uc(WL,C,Term,Type) :-
        proper_est(WU,_),
        downcase_atom(WU,WL),
        tokens(S, C, WL, Term, Type, false, _, _, _),
        idspace_regularity(S,Type,_).

should_be_uc(WL,C,Term,Type) :-
        proper_est(WU,_),
        downcase_atom(WU,WL),
        tokens(S, C, WL, Term, Type, false, false, _, _),
        is_first_word_cap(S).



