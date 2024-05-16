roundname(2,final).
roundname(4,semi_finals).
roundname(8,quarter_finals).
roundname(16,round_four).
roundname(32,round_five).
roundname(64,round_six).
roundname(128,round_seven).
roundname(256,round_eight).

schedule_round_base(N,B,[]):- B>N/2,!.
schedule_round_base(N,B,[game(B,X,Name)|Rest]):-
    roundname(N,Name),
    St is N/2+1,
    between(St,N,X),
    Bnext is B + 1,
    schedule_round_base(N,Bnext,Rest),
    \+memberchk(game(_,X,Name),Rest).
schedule_round(N,R):- schedule_round_base(N,1,R).

schedule_rounds(1,[]):-!.
schedule_rounds(N,[S|Tail]):-
    schedule_round(N,S),
    Nnext is N/2,
    schedule_rounds(Nnext,Tail).

list_member(X,[X|_]).
list_member(X,[_|TAIL]) :- list_member(X,TAIL).
list_delete(X,[X|L1], L1).
list_delete(X, [Y|L2], [Y|L1]) :- list_delete(X,L2,L1).
member(M,L,R):-
    list_member(M,L),
    list_delete(M,L,R).
ordered2(X,Y):-
    X = game(P1,_,_),
    Y = game(P2,_,_),
    P1 < P2,
    P1+P2=\=3.
ordered3(X,Y,Z):-
    X = game(P1,_,_),
    Y = game(P2,_,_),
    Z = game(P3,_,_),
    P1 < P2, P2 < P3,
    P1+P2=\=3,P1+P3=\=3,P2+P3=\=3.
group([],[]).
group(S,[[X]|Tail]):-
    member(X,S,R1),
    group(R1,Tail).
group(S,[[X,Y]|Tail]):-
    member(X,S,R1),
    member(Y,R1,R2),
    ordered2(X,Y),
    group(R2,Tail).
group(S,[[X,Y,Z]|Tail]):-
    member(X,S,R1),
    member(Y,R1,R2),
    member(Z,R2,R3),
    ordered3(X,Y,Z),
    group(R3,Tail).
tournament_round(N,D,S):-
    schedule_round(N,S),
    group(S,D).

tournament(1,[],[]):-!.
tournament(N,[D|DTail],[S|STail]):-
    tournament_round(N,D,S),
    Nnext is N/2,
    tournament(Nnext,DTail,STail).
