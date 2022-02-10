/*l'idea è di trasformare la stringa in una lista di caratteri e mettere gli altri caratteri in un'altra lista fin quando non incontrano un simbolo speciale*/
uri_parse(URIString, URI) :- string_chars(URIString, ListOfChar),
    writeln(ListOfChar),
    not(gestione_scheme(ListOfChar, List, ListScheme)),
    writeln(ListScheme),
    URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).

confronta_stringhe(Stringa1, ":"):- (Stringa1 \= ":" -> true ; !).
lista_vuota(Lista) :- not(member(_, Lista)), writeln("controllo lista").
/*remover(_, [], []).
remover(R, [R | T], T).
remover(R, [H | T], [H | T2]) :- H \= R, remover(R, T, T2).*/
agg_elemento_lista(El, ListaInput , Lista) :- append([El], ListaInput, Lista), writeln("controllo aggiunta").
crea_scheme([], _).
crea_scheme([Testa | _], Scheme) :- string_concat(Testa, Scheme, Scheme).
% gestione_scheme([Testa | Coda], [], Lista1) :-
% (confronta_stringhe(Testa, ":") ->
%agg_elemento_lista(Testa, [], Lista1),
%writeln(Lista1),
%gestione_scheme(Coda, Lista1, _); !).
/*gestione_scheme([Testa | Coda], [], Lista1) :-  confronta_stringhe(Testa, ":"),
    agg_elemento_lista(Testa, [], Lista1),
    writeln(Lista1).*/
rimozione([]).
rimozione([_ | Coda]) :- rimozione(Coda).
/*gestione_scheme([], [_], [_]).
gestione_scheme([Testa | Coda], Lista1, Lista2) :-(confronta_stringhe(Testa, ":"),
                                                  agg_elemento_lista(Testa, Lista1, Lista2),
                                                   writeln(Lista2),
                                                   gestione_scheme(Coda, Lista2, Lista3));
                                                  gestione_scheme([], _,
                                                  _).*/
gestione_scheme([], [], [_]).
gestione_scheme([":" | _], [_], [_]) :- gestione_scheme([], _, _).
gestione_scheme([Testa | Coda], List1, List2) :- (not(member(_, List1)), Testa \= ":" ->
                                                  agg_elemento_lista(Testa, List1, List2),
                                                  writeln(List2);
                                                 writeln("ramo else"),
                                                  rimozione(Coda)), gestione_scheme(Coda, List2, _).













