/*l'idea è di trasformare la stringa in una lista di caratteri e mettere gli altri caratteri in un'altra lista fin quando non incontrano un simbolo speciale*/
remove(X, [X | Xs], Y) :- remove(X, Xs, Y).
remove(X, [Y | Ys], [Y | Z]) :- X \= Y, remove(X, Ys, Z).
/*gestione lista*/
gestione_scheme([Testa | Coda]) :- (Testa \= ":" -> aggiunta_lista_scheme(Lista, [Testa], ListaScheme), gestione_scheme(Coda); gestione_uri(Coda)).
aggiunta_lista_scheme(Lista, [Testa], ListaScheme) :- append(Lista, [Testa], ListaScheme), writeln(ListaScheme).
gestione_uri([Testa | Coda]).
uri_parse(URIString, URI) :- string_codes(URIString, URICodeList),
    writeln("String_codes fatto"),
    atom_codes(URICharList, URICodeList),
    writeln("atom_codes fatto"),
    gestione_scheme(URICharList),
    writeln("gestione lista fatto"),
    URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).




