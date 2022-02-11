/*l'idea � di trasformare la stringa in una lista di caratteri e mettere gli altri caratteri in un'altra lista fin quando non incontrano un simbolo speciale*/
uri_parse(URIString, URI) :- string_chars(URIString, ListOfChar),
    writeln(ListOfChar),
    gestione_scheme(ListOfChar),
    writeln(Scheme),
    URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).

gestione_scheme([]).
gestione_scheme([Testa | Coda]):- (Testa \= ':' -> write(Testa), gestione_scheme(Coda)).













