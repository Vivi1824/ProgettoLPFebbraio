/*l'idea è di trasformare la stringa in una lista di caratteri e mettere gli altri caratteri in un'altra lista fin quando non incontrano un simbolo speciale*/
uri_parse(URIString, URI) :- string_chars(URIString, ListOfChar),
    writeln(ListOfChar),
    gestione_scheme(ListOfChar, ListScheme),
    writeln(ListScheme),
    inverti_lista(ListScheme, List, ListaInvertita),
    writeln(ListaInvertita),
    URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).
riempi_lista([Testa | Coda], List, [Testa | List]) :- gestione_scheme(Coda, [Testa | List]).
gestione_scheme([], _).
gestione_scheme([Testa | Coda], []) :- riempi_lista([Testa | Coda], [], ListScheme).
gestione_scheme([Testa | Coda], ListScheme) :- (Testa \= ':' ->
                                               (   append([Testa], ListScheme, ListRis),writeln(ListRis),
                                                gestione_scheme(Coda, ListRis))
                                               ; !).
inverti_lista([], ListaVuota, ListaVuota).
inverti_lista([Testa | Coda], Lista, Ris) :- inverti_lista(Coda, Lista, [Testa | Ris]).













