/*l'idea è di trasformare la stringa in una lista di caratteri e mettere gli altri caratteri in un'altra lista fin quando non incontrano un simbolo speciale*/
/*uri_parse(URIString, URI) :- string_codes(URIString, URICodeList),
    writeln(URICodeList),
    gestisci_codici(Lista,URICodeList),
    writeln(Lista),
    URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).

gestisci_codici([Testa | Coda], []) :- Testa \= "", gestisci_codici(Coda, []).
gestisci_codici(Lista, [Testa | Coda]) :- char_code(Char , Testa), append(Lista, [Char], Lista),
    gestisci_codici(Lista, Coda).*/

/*gestione lista*/
/*gestione_scheme([]) :- !.
aggiungi_elemento(Lista_Scheme,Carattere) :-
append(Lista_Scheme,[Carattere], Lista_Scheme).*/
uri_parse(URIString, URI) :- string_chars(URIString, ListOfChar),
    writeln(ListOfChar),
    gestione_scheme(ListOfChar, ListScheme),
    writeln(ListScheme),
    URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).
carattere(":").
remove([], X, []) :- !.
remove([X | T], X, L1) :- !, remove(T, X, L1).
remove([H | T], X, [H | L1]) :- remove(T, X, L1).
gestione_scheme([Testa | Coda], [Testa | _]) :- carattere(C), not(confronta_caratteri(C, Testa)), !, Testa1 is Testa,
    append([Testa1 | _], [Testa], [Testa1 | Testa]).
%aggiungere remove a gestione_scheme
confronta_caratteri(C, Testa) :- C == Testa, !.







