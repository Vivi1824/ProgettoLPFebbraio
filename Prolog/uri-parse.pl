/*----------------------------------------------------------------------------*/
   %STUDENTI DEL GRUPPO
/*----------------------------------------------------------------------------*/
   %Giuliani Viviana 875068
   %Gatti Daniel Marco 869310
/*----------------------------------------------------------------------------*/
   %Progetto appello del 25 febbraio 2022
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
   %URI-PARSE
/*----------------------------------------------------------------------------*/
uri_parse(URIString, URI) :-
    string_chars(URIString, ListOfChar),
    gestione_scheme(ListOfChar, _).
/*----------------------------------------------------------------------------*/
%GESTIONE DELLO SCHEME E LA SUA CREAZIONE
/*----------------------------------------------------------------------------*/
riempi_lista([Testa | Coda], List, [Testa | List]) :-
    gestione_scheme(Coda, [Testa | List]).
gestione_scheme([], [_]) :- fail.
gestione_scheme([Testa | Coda], []) :-
    riempi_lista([Testa | Coda], [],ListScheme), !.
gestione_scheme([Testa | Coda], ListScheme) :-
    (member(':', [Testa | Coda]) ->
      (Testa \= ':' ->
        (   append([Testa], ListScheme, ListRis),
            gestione_scheme(Coda, ListRis));
            reverse(ListScheme, ListSchemeInv),
            crea_scheme(ListSchemeInv, Coda , _),!);
       append(ListScheme, [Testa | Coda], Lista),
       atomics_to_string(Lista, Scheme),
       uri_display([Scheme, [], [], [], [], [], []])).
crea_scheme([Testa | Coda],ListScheme, Scheme) :-
    atomics_to_string([Testa | Coda], Scheme),
    confronta_scheme(Scheme, ListScheme); !.
confronta_scheme([], []).
confronta_scheme(Scheme, []) :- uri_display([Scheme]).
confronta_scheme(Scheme, ListScheme) :-
    (Scheme == "http" ->
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
      scheme_zos(Scheme, ListScheme, _); !))))))).

scheme_http(_, [], []).
scheme_http(Scheme, [Testa, Testa1 | Coda], ListInfo) :-
    (Testa == '/' ->
      (   Testa1 == '/' ->
          userInfo(Scheme, Coda, ListInfo); !);
    !).
/*----------------------------------------------------------------------------*/
    %USER-INFO
/*----------------------------------------------------------------------------*/
userInfo(Scheme, [Testa | Coda], ListUserInfo) :-
    ( member('@', [Testa | Coda]) ->
      ( Testa \= '@' ->
        append([Testa], ListUserInfo, List),
        userInfo(Scheme, Coda, List);
        reverse(ListUserInfo, ListInv),
        crea_user_info(ListInv, Coda, Scheme, _));
    host(Scheme, [], [Testa | Coda], _)).
crea_user_info([], ListUserInfo, Scheme, []) :-
    host(Scheme, [], ListUserInfo, _).
crea_user_info([Testa | Coda], ListUserInfo,Scheme, UserInfo) :-
    atomics_to_string([Testa | Coda], UserInfo),
    host(Scheme, UserInfo, ListUserInfo, _).
/*----------------------------------------------------------------------------*/
    %HOST
/*----------------------------------------------------------------------------*/
riempi_lista_host(Scheme, UserInfo,[Testa | Coda], List, [Testa | List] ) :-
    host(Scheme, UserInfo, Coda, [Testa | List]).
host(Scheme, UserInfo, [Testa | Coda], []) :-
    riempi_lista_host(Scheme, UserInfo,[Testa | Coda],[], ListHost), !.
host(Scheme, UserInfo, [Testa | Coda], ListHost) :-
    (member(':', [Testa | Coda]) ->
      (Testa \= ':' ->
        append([Testa], ListHost, List),
        host(Scheme, UserInfo, Coda, List);
        reverse(ListHost, ListInv),
        crea_host(ListInv, Coda, Scheme, UserInfo, _), !);
    (   member('/', [Testa | Coda]) ->
        (   Testa \= '/' ->
           append([Testa], ListHost, List),
           host(Scheme, UserInfo, Coda, List);
           reverse(ListHost, ListInv),
           atomics_to_string(ListInv, Host),
           path(Scheme, UserInfo, Host, [], Coda, _));
    (   member('?', [Testa | Coda]) ->
        (   Testa \= '?' ->
           append([Testa], ListHost, List),
           host(Scheme, UserInfo, Coda, List);
           reverse(ListHost, ListInv),
           atomics_to_string(ListInv, Host),
           query(Scheme, UserInfo, Host, [], [], Coda, _));
    (   member('#', [Testa | Coda]) ->
       (   Testa \= '#' ->
           append([Testa], ListHost, List),
           host(Scheme, UserInfo, Coda, List);
           reverse(ListHost, ListInv),
           atomics_to_string(ListInv, Host),
           fragment(Scheme, UserInfo, Host, [], [], [], Coda, _));
    append(ListHost, [Testa | Coda], Lista),
    atomics_to_string(Lista, Host),
    uri_display([Scheme, UserInfo, Host, [], [], [], []]))))).

crea_host([Testa | Coda], ListHost, Scheme, UserInfo, Host) :-
    atomics_to_string([Testa | Coda], Host),
    porta(Scheme, UserInfo, Host, ListHost, _).
/*----------------------------------------------------------------------------*/
    %PORT
/*----------------------------------------------------------------------------*/
riempi_lista_porta(Scheme, UserInfo, Host, [Testa | Coda],
                   List, [Testa | List]) :-
    porta(Scheme, UserInfo, Host, Coda, [Testa | List]).
porta(Scheme, UserInfo, Host, [Testa | Coda], []) :-
    riempi_lista_porta(Scheme, UserInfo, Host, [Testa | Coda],[], ListPort), !.
porta(Scheme, UserInfo, Host, [Testa | Coda], ListPort) :-
    (member('/', [Testa | Coda]) ->
      (Testa  \= '/' ->
        append([Testa], ListPort, List),
        porta(Scheme, UserInfo, Host, Coda, List);
        reverse(ListPort, ListInv),
        crea_porta(ListInv, Coda, Scheme, UserInfo, Host, _));
    (   member('?', [Testa | Coda]) ->
      (   Testa \= '?' ->
        append([Testa], ListPort, List),
        porta(Scheme, UserInfo, Host, Coda, List);
        reverse(ListPort, ListInv),
        atomics_to_string(ListInv, Porta),
        query(Scheme, UserInfo, Host, Porta, [], Coda, _));
    (   member('#', [Testa | Coda]) ->
      (   Testa \= '#' ->
        append([Testa], ListPort, List),
        porta(Scheme, UserInfo, Host, Coda, List);
        reverse(ListPort, ListInv),
        atomics_to_string(ListInv, Porta),
        fragment(Scheme, UserInfo, Host, Porta, [], [], Coda, _));
    append(ListPort, [Testa | Coda], Lista),
    atomics_to_string(Lista, Porta),
    uri_display([Scheme, UserInfo, Host, Porta, [], [], []])))).
crea_porta([Testa | Coda], ListPort, Scheme, UserInfo, Host, Porta) :-
    atomics_to_string([Testa | Coda], Porta),
    path(Scheme, UserInfo, Host, Porta, ListPort, _).
/*----------------------------------------------------------------------------*/
   %PATH
/*----------------------------------------------------------------------------*/
riempi_lista_path(Scheme, UserInfo, Host, Porta,
                  [Testa | Coda], List, [Testa | List]) :-
    path(Scheme, UserInfo, Host, Porta, Coda, [Testa | List]).
path(Scheme, UserInfo, Host, Porta, [Testa | Coda], []) :-
    riempi_lista_path(Scheme, UserInfo, Host, Porta,
                      [Testa | Coda], [], ListPath), !.
path(Scheme, UserInfo, Host, Porta, [Testa | Coda], ListPath) :-
    (member('?', [Testa | Coda]) ->
           (Testa  \= '?' ->
             append([Testa], ListPath, List),
             path(Scheme, UserInfo, Host, Porta, Coda, List);
             reverse(ListPath, ListInv),
             crea_path(ListInv, Coda, Scheme, UserInfo, Host, Porta, _));
            (   member('#', [Testa | Coda]) ->
              (   Testa \= '#' ->
                  append([Testa], ListPath, List),
               path(Scheme, UserInfo, Host, Porta, Coda, List);
               reverse(ListPath, ListInv),
               atomics_to_string(ListInv, Path),
               fragment(Scheme, UserInfo, Host, Porta, Path, [], Coda, _));
               append(ListPath, [Testa | Coda], Lista),
               atomics_to_string(Lista, Path),
               uri_display([Scheme, UserInfo, Host, Porta, Path, [], []]))).
crea_path([Testa | Coda], ListPort, Scheme, UserInfo, Host, Porta, Path) :-
    atomics_to_string([Testa | Coda], Path),
    query(Scheme, UserInfo, Host, Porta, Path, ListPort, _).
/*----------------------------------------------------------------------------*/
    %QUERY
/*----------------------------------------------------------------------------*/
riempi_lista_query(Scheme, UserInfo, Host, Porta, Path,
                   [Testa | Coda], List, [Testa | List]) :-
    query(Scheme, UserInfo, Host, Porta, Path, Coda, [Testa | List]).
query(Scheme, UserInfo, Host, Porta, Path, [Testa | Coda], []) :-
    riempi_lista_query(Scheme, UserInfo, Host, Porta, Path,
                       [Testa | Coda], [], ListQuery), !.
query(Scheme, UserInfo, Host, Porta, Path, [Testa | Coda], ListQuery) :-
    (member('#', [Testa | Coda]) ->
      (Testa  \= '#' ->
      append([Testa], ListQuery, List),
      query(Scheme, UserInfo, Host, Porta, Path, Coda, List);
      reverse(ListQuery, ListInv),
      crea_query(ListInv, Coda, Scheme, UserInfo, Host, Porta, Path, _));
      append(ListQuery, [Testa | Coda], Lista),
      atomics_to_string(Lista, Query),
      uri_display([Scheme, UserInfo, Host, Porta, Path, Query, []])).
crea_query([Testa | Coda], ListQuery, Scheme,
           UserInfo, Host, Porta, Path, Query) :-
    atomics_to_string([Testa | Coda], Query),
    fragment(Scheme, UserInfo, Host, Porta, Path, Query, ListQuery, _).
/*----------------------------------------------------------------------------*/
   %FRAGMENT
/*----------------------------------------------------------------------------*/
fragment(Scheme, UserInfo,Host, Porta, Path, Query,
         [Testa | Coda], Fragment ) :-
    atomics_to_string([Testa | Coda], Fragment),
    uri_completo(Scheme, UserInfo, Host, Porta, Path, Query, Fragment, _).
/*----------------------------------------------------------------------------*/
   %URI-COMPLETO
/*----------------------------------------------------------------------------*/
uri_completo(Scheme, UserInfo, Host, Porta,
             Path, Query, Fragment, ListUri) :-
    append([Scheme], ListUri, List),
    append([UserInfo], List, List1),
    append([Host], List1, List2),
    append([Porta], List2, List3),
    append([Path], List3, List4),
    append([Query], List4, List5),
    append([Fragment], List5, List6),
    reverse(List6, ListaURI),
    uri_display(ListaURI).
/*----------------------------------------------------------------------------*/
   %URI-DISPLAY
/*----------------------------------------------------------------------------*/
uri_display([Scheme, UserInfo, Host, Porta, Path, Query, Fragment]) :-
    writeln("Diplay URI: "),
    write("Scheme: "),
    writeln(Scheme),
    write("UserInfo: "),
    writeln(UserInfo),
    write("Host: "),
    writeln(Host),
    write("Porta: "),
    writeln(Porta),
    write("Path: "),
    writeln(Path),
    write("Query: "),
    writeln(Query),
    write("Fragment: "),
    writeln(Fragment),
    URI = (Scheme, UserInfo, Host, Porta, Path, Query, Fragment),
    writeln("URI" :URI).
/*----------------------------------------------------------------------------*/
   %MAILTO
/*----------------------------------------------------------------------------*/
scheme_mailto(_, [], []).
scheme_mailto(Scheme, [Testa | Coda], ListUserInfo) :-
    (member('@', [Testa | Coda]) ->
      (Testa \= '@' ->
       append([Testa], ListUserInfo, List),
       scheme_mailto(Scheme, Coda, List);
       reverse(ListUserInfo, ListInv),
       crea_user_info_m(Scheme, ListInv, Coda, _ ), !);
       append(ListUserInfo, [Testa | Coda], Lista),
       atomics_to_string(Lista, Host),
       uri_display([Scheme, [], Host, [], [], [], []])).
crea_user_info_m(Scheme, [Testa | Coda], ListHost, UserInfo) :-
    atomics_to_string([Testa | Coda], UserInfo),
    host_m(Scheme, UserInfo, ListHost, _).
host_m(_, _, [], _).
host_m(Scheme, UserInfo, [Testa | Coda], Host) :-
    atomics_to_string([Testa | Coda], Host),
    uri_display([Scheme, UserInfo, Host, [], [], [], [] ]).

/*----------------------------------------------------------------------------*/
   %NEWS
/*----------------------------------------------------------------------------*/
scheme_news(_, [], _).
scheme_news(Scheme, [], _) :- uri_display([Scheme, [], [], [], [], [], []]).
scheme_news(Scheme, [Testa | Coda], Host) :-
    atomics_to_string([Testa | Coda], Host),
    uri_display([Scheme, [], Host, [], [], [], []]).

/*----------------------------------------------------------------------------*/
  %TEL E FAX
/*----------------------------------------------------------------------------*/
scheme_tel_fax(_, [], _).
scheme_tel_fax(Scheme, [Testa | Coda], UserInfo) :-
    atomics_to_string([Testa | Coda], UserInfo),
    uri_display([Scheme, UserInfo, [], [], [], [], []]).

/*----------------------------------------------------------------------------*/
   %ZOS
/*----------------------------------------------------------------------------*/
scheme_zos(_, [], []).
scheme_zos(Scheme, [], []) :- uri_display([Scheme, [], [], [], [], [], []]).
scheme_zos(Scheme, [Testa, Testa1 | Coda], ListUserInfo) :-
    (Testa == '/' ->
     (   Testa1 == '/' ->
         userInfo_z(Scheme, Coda, ListUserInfo); !); !).
riempi_lista_user_info_z(Scheme, [Testa | Coda], List, [Testa | List] ) :-
    userInfo_z(Scheme, Coda, [Testa | List]).
userInfo_z(_, [], []).
userInfo_z(Scheme, [Testa | Coda], []) :-
    riempi_lista_user_info_z(Scheme, [Testa | Coda], [], ListUser), !.
userInfo_z(Scheme, [Testa | Coda], ListUserInfo) :-
    ( member('@', [Testa | Coda]) ->
      ( Testa \= '@' ->
        append([Testa], ListUserInfo, List),
        userInfo_z(Scheme, Coda, List);
        reverse(ListUserInfo, ListInv),
        crea_user_info_z(ListInv, Coda, Scheme, _));
        (   member(':',[Testa | Coda]) ->
            append(ListUserInfo, [Testa | Coda], Lista),
            host_z(Scheme, [], Lista, _);
           (   member('/', [Testa | Coda]) ->
               append(ListUserInfo, [Testa | Coda], Lista),
               host_z(Scheme, [], Lista, _);
               append(ListUserInfo, [Testa | Coda], Lista),
               atomics_to_string(Lista, Host),
               uri_display([Scheme, [], Host, [], [], [], []])))).
crea_user_info_z([], ListUserInfo, Scheme, []) :-
    host_z(Scheme, [], ListUserInfo, _).
crea_user_info_z([Testa | Coda], ListUserInfo, Scheme, UserInfo) :-
    atomics_to_string([Testa | Coda], UserInfo),
    host_z(Scheme, UserInfo, ListUserInfo, _).

riempi_lista_host_z(Scheme, UserInfo, [Testa | Coda], List, [Testa | List]) :-
    host_z(Scheme, UserInfo, Coda, [Testa | List]).
host_z(_, _, [], []).
host_z(Scheme, UserInfo, [Testa | Coda], []) :-
    riempi_lista_host_z(Scheme, UserInfo, [Testa | Coda], [], ListHost), !.
host_z(Scheme, UserInfo, [Testa | Coda], ListHost) :-
    (member(':', [Testa | Coda]) ->
     (   Testa \= ':' ->
         append([Testa], ListHost, List),
         host_z(Scheme, UserInfo, Coda, List);
         reverse(ListHost, ListInv),
         crea_host_z(ListInv, Coda, Scheme, UserInfo, _));
         (   member('/', [Testa | Coda]) ->
             (   Testa \= '/' ->
                 append([Testa], ListHost, List),
                 host_z(Scheme, UserInfo, Coda, List);
                 reverse(ListHost, ListInv),
                 atomics_to_string(ListInv, Host),
                 path_z_id44(Scheme, UserInfo, Host, [], Coda, _, _));
                 append(ListHost,[Testa | Coda], Lista),
                 atomics_to_string(Lista, Host),
                 uri_display([Scheme, UserInfo, Host, [], [], [], []]))).
crea_host_z([Testa | Coda], ListHost, Scheme, UserInfo, Host) :-
    atomics_to_string([Testa | Coda], Host),
    porta_z(Scheme, UserInfo, Host, ListHost, _).

riempi_lista_porta_z(Scheme, UserInfo, Host,
                     [Testa | Coda], List, [Testa | List]) :-
    porta_z(Scheme, UserInfo, Host, Coda, [Testa | List]).
porta_z(_, _, _, [], []).
porta_z(Scheme, UserInfo, Host, [Testa | Coda], []) :-
    riempi_lista_porta_z(Scheme, UserInfo, Host,
                         [Testa | Coda], [], ListPort), !.
porta_z(Scheme, UserInfo, Host, [Testa | Coda], ListPort) :-
    (member('/', [Testa | Coda]) ->
      (   Testa \= '/' ->
          append([Testa], ListPort, Lista),
          porta_z(Scheme, UserInfo, Host, Coda, Lista);
          reverse(ListPort, ListInv),
          crea_porta_z(ListInv, Coda, Scheme, UserInfo, Host, _));
          append(ListPort, [Testa | Coda], Lista),
          atomics_to_string(Lista, Porta),
          uri_display([Scheme, UserInfo, Host, Porta, [], [], []])).

crea_porta_z([Testa | Coda], ListPort, Scheme, UserInfo, Host, Porta) :-
    atomics_to_string([Testa | Coda], Porta),
   path_z_id44(Scheme, UserInfo, Host, Porta, ListPort, _, _).

riempi_lista_path_z(Scheme, UserInfo, Host, Porta, Cont,
                    [Testa | Coda], List, [Testa | List] ) :-
    path_z_id44(Scheme, UserInfo, Host, Porta, Coda, [Testa | List], Cont).
non_inst(Var) :- \+(\+(Var=0)), \+(\+(Var=1)).
inizializza_contatore(Cont, Ris) :- Cont is 1, Ris is Cont .
path_z_id44(_, _, _, _, [], [], _).
path_z_id44(Scheme, UserInfo, Host, Porta, [Testa | Coda], [], Cont) :-
    riempi_lista_path_z(Scheme, UserInfo, Host,
                        Porta, Cont, [Testa | Coda], _, ListPath),!.
path_z_id44(Scheme, UserInfo, Host, Porta,
            [Testa | Coda], ListPath, Cont) :-
    (   non_inst(Cont) ->
    inizializza_contatore(Cont, Cont1),
        path_z_id44(Scheme, UserInfo, Host, Porta,
                    [Testa | Coda], ListPath, Cont1);
    (   Testa \= '(' ->
        append([Testa], ListPath, Lista),
        Cont2 is Cont + 1,
        path_z_id44(Scheme, UserInfo, Host, Porta, Coda, Lista, Cont2);
        (   Cont =< 44 ->
            writeln([Testa | Coda]),
    path_z_id8(Scheme, UserInfo, Host, Porta,
               [Testa | Coda], ListPath, _); !))).

riempi_lista_path_id8(Scheme, UserInfo, Host, Porta, Cont,
                      [Testa | Coda], List, [Testa | List]) :-
    path_z_id8(Scheme, UserInfo, Host, Porta, Coda, [Testa | List], Cont).
path_z_id8(_, _, _, _, [], [], _).
path_z_id8(Scheme, UserInfo, Host, Porta, [Testa | Coda], [], Cont) :-
    riempi_lista_path_id8(Scheme, UserInfo, Host, Porta, Cont, [Testa |
    Coda], _, ListPath), !.
path_z_id8(Scheme, UserInfo, Host, Porta, [Testa | Coda], ListPath, Cont) :-
    (   non_inst(Cont) ->
        inizializza_contatore(Cont, Cont1),
        writeln([Testa | Coda]),
        path_z_id8(Scheme, UserInfo, Host, Porta,
                   [Testa | Coda], ListPath, Cont1);
        (   Testa == '(' ->
            append([Testa], ListPath, Lista),
            path_z_id8(Scheme, UserInfo, Host, Porta, Coda, Lista, Cont);
           (   Testa \= ')' ->
               append([Testa], ListPath, Lista),
               Cont2 is Cont + 1,
               path_z_id8(Scheme, UserInfo, Host,
                          Porta, Coda, Lista, Cont2);
               (   Cont =< 8 ->
                   append([Testa], ListPath, Lista),
                   reverse(Lista, ListInv),
                   crea_path_z(Scheme, UserInfo, Host,
                               Porta, ListInv, Coda, _); !)))).

crea_path_z(Scheme, UserInfo, Host, Porta, [Testa | Coda], ListPath, Path) :-
    atomics_to_string([Testa | Coda], Path),
    uri_completo_z(Scheme, UserInfo, Host, Porta, Path, [], [], _).

uri_completo_z(Scheme, UserInfo, Host, Porta,
               Path, Query, Fragment, ListUri) :-
    append([Scheme], ListUri, List),
    append([UserInfo], List, List1),
    append([Host], List1, List2),
    append([Porta], List2, List3),
    append([Path], List3, List4),
    append([Query], List4, List5),
    append([Fragment], List5, List6),
    reverse(List6, ListaURI),
    uri_display(ListaURI).




