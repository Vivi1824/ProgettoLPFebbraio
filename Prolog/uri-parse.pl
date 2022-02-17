/*l'idea è di trasformare la stringa in una lista di caratteri e mettere gli altri caratteri in un'altra lista fin quando non incontrano un simbolo speciale*/
% AGGIUNGERE CONTROLLO SOLO SCHEME PRESENTE, POI GESTIRE IL FATTO CHE
% USERINFO DEVE ESSERCI PER FORZA SE C'è L'HOST E TUTTI GLI ALTRI CASI
% VERIFICARE CHE CI SIANO TUTTI I CASI BASE
uri_parse(URIString, URI) :- string_chars(URIString, ListOfChar),
    gestione_scheme(ListOfChar, ListScheme).
%GESTIONE DELLO SCHEME E LA SUA CREAZIONE
riempi_lista([Testa | Coda], List, [Testa | List]) :- gestione_scheme(Coda, [Testa | List]).
gestione_scheme([], [_]) :- fail.
gestione_scheme([Testa | Coda], []) :- riempi_lista([Testa | Coda], [],ListScheme), !.
gestione_scheme([Testa | Coda], ListScheme) :- (Testa \= ':' ->
                                               (   append([Testa], ListScheme, ListRis),
                                                gestione_scheme(Coda, ListRis))
                                               ;reverse(ListScheme, ListSchemeInv),
                                               crea_scheme(ListSchemeInv, Coda , _),!).
crea_scheme([Testa | Coda],ListScheme, Scheme) :- atomics_to_string([Testa | Coda], Scheme),
    writeln(Scheme),
    confronta_scheme(Scheme, ListScheme); !.
confronta_scheme([], []).
confronta_scheme(Scheme, []) :- uri_display([Scheme], URI).
confronta_scheme(Scheme, ListScheme) :- (Scheme == "http" ->
                                        scheme_http(Scheme, ListScheme, ListInfo);
                                        (   Scheme == "https" ->
                                        scheme_http(Scheme, ListScheme, ListInfo);
                                        (   Scheme == "mailto" ->
                                        scheme_mailto(Scheme, ListScheme, List);
                                        (   Scheme == "news" ->
                                        scheme_news(Scheme, ListScheme, _);
                                        (   Scheme == "tel" ->
                                        scheme_tel_fax(Scheme, ListScheme, _) ;
                                        (   Scheme == "fax" ->
                                        scheme_tel_fax(Scheme, ListScheme, _);
                                        (   Scheme == "zos" ->
                                        scheme_zos(Scheme, ListScheme, _);
                                        !))))))).
%AGGIUNGERE IL CONTROLLO MEMBER PER VEDERE SE E' PRESENTE @
scheme_http(_, [], []).
scheme_http(Scheme, [Testa, Testa1 | Coda], ListInfo) :- (member('@', [Testa , Testa1 | Coda]) ->
                                                         (Testa == '/' ->
                                                         (   Testa1 == '/' ->
                                                         scheme_http(Scheme, Coda, ListInfo); !);
                                                         (   Testa \= '@' ->
                                                         append([Testa], ListInfo, List),
                                                         scheme_http(Scheme, [Testa1 | Coda], List);
                                                         reverse(ListInfo, ListInv),
                                                             crea_user_info(ListInv, [Testa1 | Coda],Scheme, _),!));
                                                         crea_user_info([], [Testa1 | Coda], Scheme, _)).
%GESTIONE DELLO USER INFO E LA SUA CREAZIONE
crea_user_info([], ListUserInfo, Scheme, []) :- host(Scheme, [], ListUserInfo, _).
crea_user_info([Testa | Coda], ListUserInfo,Scheme, UserInfo) :- atomics_to_string([Testa | Coda], UserInfo),
    writeln(UserInfo),
    host(Scheme, UserInfo, ListUserInfo, _).
% GESTIONE DELL'HOST, INTRODURRE IL CASO DEL : NON PRESENTE, PROBLEMA DI
% AGGIUNTA DI / SE NON PRESENTE USERINFO
riempi_lista_host(Scheme, UserInfo,[Testa | Coda], List, [Testa | List] ) :- host(Scheme, UserInfo, Coda, [Testa | List]).
host(Scheme, UserInfo, [Testa | Coda], []) :- riempi_lista_host(Scheme, UserInfo,[Testa | Coda],[], ListHost), !.
host(Scheme, UserInfo, [Testa | Coda], ListHost) :- (Testa \= ':' ->
                                                    append([Testa], ListHost, List),
                                                     host(Scheme, UserInfo, Coda, List);
                                                    reverse(ListHost, ListInv),
                                                    crea_host(ListInv, Coda, Scheme, UserInfo, _), !).
crea_host([Testa | Coda], ListHost, Scheme, UserInfo, Host) :- atomics_to_string([Testa | Coda], Host),
    writeln(Host),
    porta(Scheme, UserInfo, Host, ListHost, _).
%GESTIONE DELLA PORTA, INTRODURRE CASO SE E' NULLA
riempi_lista_porta(Scheme, UserInfo, Host, [Testa | Coda], List, [Testa | List]) :- porta(Scheme, UserInfo, Host, Coda, [Testa | List]).
porta(Scheme, UserInfo, Host, [Testa | Coda], []) :- riempi_lista_porta(Scheme, UserInfo, Host, [Testa | Coda], [], ListPort), !.
porta(Scheme, UserInfo, Host, [Testa | Coda], ListPort) :- (Testa  \= '/' ->
                                                           append([Testa], ListPort, List),
                                                           porta(Scheme, UserInfo, Host, Coda, List);
                                                           reverse(ListPort, ListInv),
                                                           crea_porta(ListInv, Coda, Scheme, UserInfo, Host, _)).
crea_porta([Testa | Coda], ListPort, Scheme, UserInfo, Host, Porta) :- atomics_to_string([Testa | Coda], Porta),
    writeln(Porta),
    path(Scheme, UserInfo, Host, Porta, ListPort, _).
%GESTIONE PATH
riempi_lista_path(Scheme, UserInfo, Host, Porta, [Testa | Coda], List, [Testa | List]) :- path(Scheme, UserInfo, Host, Porta, Coda, [Testa | List]).
path(Scheme, UserInfo, Host, Porta, [Testa | Coda], []) :-
    riempi_lista_path(Scheme, UserInfo, Host, Porta, [Testa | Coda], [], ListPath), !.
path(Scheme, UserInfo, Host, Porta, [Testa | Coda], ListPath) :- (Testa  \= '?' ->
                                                           append([Testa], ListPath, List),
                                                           path(Scheme, UserInfo, Host, Porta, Coda, List);
                                                           reverse(ListPath, ListInv),
                                                           crea_path(ListInv, Coda, Scheme, UserInfo, Host, Porta, _)).
crea_path([Testa | Coda], ListPort, Scheme, UserInfo, Host, Porta, Path) :- atomics_to_string([Testa | Coda], Path),
    writeln(Path),
    query(Scheme, UserInfo, Host, Porta, Path, ListPort, _).
%GESTIONE QUERY
riempi_lista_query(Scheme, UserInfo, Host, Porta, Path, [Testa | Coda], List, [Testa | List]) :-
    query(Scheme, UserInfo, Host, Porta, Path, Coda, [Testa | List]).
query(Scheme, UserInfo, Host, Porta, Path, [Testa | Coda], []) :-
    riempi_lista_query(Scheme, UserInfo, Host, Porta, Path, [Testa | Coda], [], ListQuery), !.
query(Scheme, UserInfo, Host, Porta, Path, [Testa | Coda], ListQuery) :- (Testa  \= '#' ->
                                                           append([Testa], ListQuery, List),
                                                           query(Scheme, UserInfo, Host, Porta, Path, Coda, List);
                                                           reverse(ListQuery, ListInv),
                                                           crea_query(ListInv, Coda, Scheme, UserInfo, Host, Porta, Path, _)).
crea_query([Testa | Coda], ListQuery, Scheme, UserInfo, Host, Porta, Path, Query) :- atomics_to_string([Testa | Coda], Query),
    writeln(Query),
    fragment(Scheme, UserInfo, Host, Porta, Path, Query, ListQuery, _).
%GESTIONE FRAGMENTE E OPERAZIONI PRELIMINARI PER LA VISUALIZZAZIONE
fragment(Scheme, UserInfo,Host, Porta, Path, Query, [Testa | Coda], Fragment ) :- atomics_to_string([Testa | Coda], Fragment),
    writeln(Fragment),
    uri_completo(Scheme, UserInfo, Host, Porta, Path, Query, Fragment, _).
uri_completo(Scheme, UserInfo, Host, Porta, Path, Query, Fragment, ListUri) :-
    append([Scheme], ListUri, List),
    append([UserInfo], List, List1),
    append([Host], List1, List2),
    append([Porta], List2, List3),
    append([Path], List3, List4),
    append([Query], List4, List5),
    append([Fragment], List5, List6),
    reverse(List6, ListaURI),
    writeln(ListaURI),
    uri_display(ListaURI, URI).
uri_display([Scheme, UserInfo, Host, Porta, Path, Query, Fragment], URI) :-
    URI = (Scheme, UserInfo, Host, Porta, Path, Query, Fragment),
    writeln("URI = " :URI).
%AGGIUNGERE UN DISPLAY CON UN PARAMETRO

%MAILTO, AGGIUNGERE I CONTROLLI
scheme_mailto(_, [], []).
scheme_mailto(Scheme, [Testa | Coda], ListUserInfo) :- (Testa \= '@' ->
                                                       append([Testa], ListUserInfo, List),
                                                        scheme_mailto(Scheme, Coda, List);
                                                       reverse(ListUserInfo, ListInv),
                                                       crea_user_info_m(Scheme, ListInv, Coda, _ ), !).
crea_user_info_m(Scheme, [Testa | Coda], ListHost, UserInfo) :- atomics_to_string([Testa | Coda], UserInfo),
    writeln(UserInfo),
    host_m(Scheme, UserInfo, ListHost, _).
host_m(_, _, [], _).
host_m(Scheme, UserInfo, [Testa | Coda], Host) :- atomics_to_string([Testa | Coda], Host),
    uri_display([Scheme, UserInfo, Host, [], [], [], [] ], URI).

%NEWS
scheme_news(_, [], _).
scheme_news(Scheme, [Testa | Coda], Host) :- atomics_to_string([Testa | Coda], Host),
    uri_display([Scheme, [], Host, [], [], [], []], URI).

%TEL E FAX
scheme_tel_fax(_, [], _).
scheme_tel_fax(Scheme, [Testa | Coda], UserInfo) :- atomics_to_string([Testa | Coda], UserInfo),
    uri_display([Scheme, UserInfo, [], [], [], [], []], URI).

%ZOS
scheme_zos(_, [], []).
scheme_zos(Scheme, [Testa, Testa1 | Coda], ListUserInfo) :- (Testa == '/' ->
                                                            (   Testa1 == '/' ->
                                                            scheme_zos(Scheme, Coda, ListUserInfo);
                                                            !) ;
                                                            (   Testa \= '@' ->
                                                            append([Testa], ListUserInfo, List),
                                                            scheme_zos(Scheme, [Testa1 | Coda], List);
                                                            reverse(ListUserInfo, ListInv),
                                                                crea_user_info_z(ListInv, [Testa1 | Coda], Scheme, _),
                                                                !)).
crea_user_info_z([], ListUserInfo, Scheme, []) :- host(Scheme, [], ListUserInfo, _).
crea_user_info_z([Testa | Coda], ListUserInfo, Scheme, UserInfo) :- atomics_to_string([Testa | Coda], UserInfo),
    writeln(UserInfo),
    host_z(Scheme, UserInfo, ListUserInfo, _).
riempi_lista_host_z(Scheme, UserInfo, [Testa | Coda], List, [Testa | List]) :- host_z(Scheme, UserInfo, Coda, [Testa | List]).
host_z(_, _, [], []).
host_z(Scheme, UserInfo, [Testa | Coda], []) :- riempi_lista_host_z(Scheme, UserInfo, [Testa | Coda], [], ListHost), !.
host_z(Scheme, UserInfo, [Testa | Coda], ListHost) :- (Testa \= ':' ->
                                                      append([Testa], ListHost, List),
                                                       host_z(Scheme, UserInfo, Coda, List);
                                                      reverse(ListHost, ListInv),
                                                       crea_host_z(ListInv, Coda, Scheme, UserInfo, _), !).
crea_host_z([Testa | Coda], ListHost, Scheme, UserInfo, Host) :- atomics_to_string([Testa | Coda], Host),
    writeln(Host),
    porta_z(Scheme, UserInfo, Host, ListHost, _).
riempi_lista_porta_z(Scheme, UserInfo, Host, [Testa | Coda], List, [Testa | List]) :- porta_z(Scheme, UserInfo, Host, Coda, [Testa | List]).
porta_z(_, _, _, [], []).
porta_z(Scheme, UserInfo, Host, [Testa | Coda], []) :- riempi_lista_porta_z(Scheme, UserInfo, Host, [Testa | Coda], [], ListPort).
porta_z(Scheme, UserInfo, Host, [Testa | Coda], ListPort) :- (Testa \= '/' ->
                                                             append([Testa], ListPort, List),
                                                              porta_z(Scheme, UserInfo, Host, Coda, List);
                                                             reverse(ListPort, ListInv),
                                                              crea_porta_z(ListInv, Coda, Scheme, UserInfo, Host, _)).
crea_porta_z([Testa | Coda], ListPort, Scheme, UserInfo, Host, Porta) :-  writeln("prova"),
    atomics_to_string([Testa | Coda], Porta),
    writeln(Porta).
   /* path_z_id44(Scheme, UserInfo, Host, Porta, ListPort, _, _)*/

% AGGIUNGERE UN CONTROLLO SU id44 e id8 per vedere se iniziano con un
% carattere alfanumerico
%IL PATH DA ERRORE
riempi_lista_path_z(Scheme, UserInfo, Host, Porta, Cont, [Testa | Coda], Lista, [Testa | Lista]) :-
    path_z_id44(Scheme, UserInfo, Host, Coda, Porta, [Testa | Lista], Cont).
non_inst(Var) :- \+(\+(Var=0)), \+(\+(Var=1)).
inizializza_contatore(Cont, Ris) :- Cont is 0, Ris is Cont .
path_z_id44(_, _, _, _, [], [], _).
path_z_id44(Scheme, UserInfo, Host, Porta, [Testa, Testa1 | Coda], ListPath, Cont) :-
    (   non_inst(Cont) ->
    inizializza_contatore(Cont, Ris),
        riempi_lista_path_z(Scheme, UserInfo, Host, Porta, Ris, [Testa | Coda], [], List),
        path_z_id44(Scheme, UserInfo, Host, Porta, [testa | Coda], List, Ris) ;
    (   Testa \= '?' ->
    (   ((Testa == '.', Testa1 \= '(');
        (   Testa \= '.', Testa1 \= '(')) ->
    (   Cont < 44 ->
    append([Testa], ListPath, List),
    (   Testa1 == '(' ->
    append([Testa1], List, List1),
    path_z_id8(Scheme, UserInfo, Host, Porta, Coda, List1, Cont1),
    Cont is Cont1 + 1;
    path_z_id44(Scheme, UserInfo, Host, Porta, [Testa1 | Coda], List, Cont1),
    Cont is Cont1 + 1));
    (   (Cont == 44, Testa == '(') ->
    append([Testa], ListPath, List),
    path_z_id8(Scheme, UserInfo, Host, Porta, [Testa1 | Coda], List, Cont1),
    Cont is Cont1 + 1; !); !); query_z())).
path_z_id8(Scheme, UserInfo, Host, Porta, [Testa | Coda], ListPath, Cont) :-
    (   non_inst(Cont) ->
    inizializza_contatore(Cont, Ris),
    path_z_id8(Scheme, UserInfo, Host, Porta, [Testa, Testa1 | Coda], ListPath, Ris);
    (   Testa \= ')' ->
    (   Cont < 8 ->
    append([Testa], ListPath, List),
    path_z_id8(Scheme, UserInfo, Host, Porta, Coda, List, Cont1),
    Cont is Cont1+1 ;
    (   ((Cont == 8, Testa == ')', Testa1 == '?') ->
        append([Testa], ListPath, List), writeln(List),
        reverse(List, ListInv),
        crea_path_z(ListInv, Coda, Scheme, UserInfo, Host, Porta, _), !)));
    (   (Cont =< 8, Testa1 == '?') ->
    append([Testa], ListPath, List),
        reverse(List, ListInv),
        crea_path_z(ListInv, Coda, Scheme, UserInfo, Host, Porta, _), !))).
crea_path_z([Testa | Coda], ListPath, Scheme, UserInfo, Host, Porta, Path) :- atomics_to_string([Testa | Coda], Path),
    writeln(Path),
    uri_display([Scheme, UserInfo, Host, Porta, Path, [], []], URI).
query_z().

















