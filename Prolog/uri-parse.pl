/*l'idea � di trasformare la stringa in una lista di caratteri e mettere gli altri caratteri in un'altra lista fin quando non incontrano un simbolo speciale*/
uri_parse(URIString, URI) :- string_chars(URIString, ListOfChar),
    writeln(ListOfChar),
    gestione_scheme(ListOfChar, ListScheme),
    URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).
riempi_lista([Testa | Coda], List, [Testa | List]) :- gestione_scheme(Coda, [Testa | List]).
gestione_scheme([], [_]).
gestione_scheme([Testa | Coda], []) :- riempi_lista([Testa | Coda], [],ListScheme), !.
gestione_scheme([Testa | Coda], ListScheme) :- (Testa \= ':' ->
                                               (   append([Testa], ListScheme, ListRis),
                                                   writeln(ListScheme),
                                                gestione_scheme(Coda, ListRis))
                                               ;reverse(ListScheme, ListSchemeInv),
                                               crea_scheme(ListSchemeInv, Coda , _),!).
crea_scheme([Testa | Coda],ListScheme, Scheme) :- atomics_to_string([Testa | Coda], Scheme),
    writeln(Scheme),
    confronta_scheme(Scheme, ListScheme).
confronta_scheme(Scheme, ListScheme) :- (Scheme == "http" ; Scheme == "https" ->
                                                     scheme_http(Scheme, ListScheme, ListUserInfo);
                                                     !).
scheme_http(Scheme, [Testa, Testa1 , Testa2 | Coda], ListUserInfo ) :- (Testa == '/', Testa1 == '/' ->
                                                         (   Testa2 == 'w' ).












