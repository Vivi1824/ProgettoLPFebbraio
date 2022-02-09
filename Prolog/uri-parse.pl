/*l'idea è di trasformare la stringa in una lista di caratteri e mettere gli altri caratteri in un'altra lista fin quando non incontrano un simbolo speciale*/
uri_parse(URIString, URI) :- string_chars(URIString, ListOfChar),
    writeln(ListOfChar),
    gestione_scheme(ListOfChar, Scheme),
    writeln(Scheme),
    URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).
% la ricorsione deve terminare quando si incontra il :, mentre prima gli
% elementi vanno aggiunti ad una lista e rimossi dalla lista corrente
% quindi il caso base è quando la lista è vuota oppure quando si
% incontra :.
lungh_lista([], 0).
lungh_lista([_ | Coda], L) :- lungh_lista(Coda, N), L is N+1.
/*gestione_scheme([Testa | Coda], S) :- (Testa \= ":" -> (append([Testa], [Testa], S), gestione_scheme(Coda, S)) ;
                                      (Testa == ":" -> write(":
                                      trovato")); !).*/
/*gestione_scheme([Testa | Coda], [Testa]) :- Testa \= ":"; !; append([Testa], [], S), gestione_scheme(Coda, S).*/
/*gestione_scheme([Testa | Coda], S, Scheme) :- Testa \= ":", ! , write(S), append([Testa], S, S2), gestione_scheme(Coda, S2, _).*/
confronta_stringhe(Stringa1, ":"):- Stringa1 \= ":", writeln("true stringa").
lista_vuota([Testa | _]) :- Testa == "", writeln("true lista vuota").
%aggiungere aggiungi elemento lista
agg_elemento_lista(El, ListaInput , Lista) :- append([El], ListaInput, Lista).
gestione_scheme([Testa | Coda], Lista) :- (not(confronta_stringhe(Testa, _)) ->
                                               (lista_vuota(Lista) -> agg_elemento_lista(Testa, Lista, Ris),
                                                gestione_scheme(Coda, Ris);
                                               agg_elemento_lista([Testa], Lista, Scheme),
                                               gestione_scheme(Coda, Scheme));!).









