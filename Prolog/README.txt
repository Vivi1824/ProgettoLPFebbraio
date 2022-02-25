Studenti del gruppo: Giuliani Viviana 875068, Gatti Daniel Marco 869310
Progetto per appello del 25 febbraio 2022

Spiegazione delle varie parti del progetto

URI_PARSE
Prende in input la stringa passata da linea di comando e un altro parametro URI. All'interno viene chiamata una funzione string_chars per trasformare 
una stringa in una lista di caratteri e questa lista di caratteri viene passata a gestione_scheme.

GESTIONE_SCHEME
In gestione_scheme viene controllato se è presente il carattere ':' all'interno della lista. Se si viene controllato che la testa della lista
sia diversa da ':', perchè significherebbe che si è arrivati alla fine dello scheme. Se è diversa allora si aggiunge il carattere ad una lista di appoggio
altrimenti se si trova i ':' si effettua un inversione della lista che verrà passata a crea_scheme
che effettivamente creerà lo scheme e lo passerà al metodo confronta_scheme. Se non sono presenti i ':' allora il metodo creerà direttamente lo scheme passando
lo scheme creato a uri_display.

CONFRONTA_SCHEME
In confronta scheme si verifica quale scheme viene inserito per poterlo passare alle opportune regole per gestire i vari casi di scheme.

SE LO SCHEME È UGUALE AD HTTP
Se lo scheme è uguale ad http, verrà richiamata per primo una funzione che verificherà che ci sia '//', così si può procedere alla ricerca dello UserInfo, Host, Porta, Path, Query
e Fragment. Nella regola per lo UserInfo si effettua una ricerca del carattere '@', perchè se non presente il resto della stringa dopo '//' verrà considerato come Host. Nei vari
metodi viene controllato se siano presenti i caratteri '@', ':', '/', '?', '#' perchè se non presenti quella parte dell'URI verrà considerata nulla. Una volta arrivati alla fine della
lista di caratteri verrà effettuato il passaggio dei valori ad una regola chiamata uri_completo che avrà il compito di creare una lista contenente le informazioni, e questa lista
verrà passata ad uri_display.

SE LO SCHEME È UGUALE A MAILTO
Se lo scheme è uguale a mailto, per prima cosa controlla prima se è presente il carattere '@', per verificare se è presente uno UserInfo. Se non presente l'host viene creato direttamente
nel metodo scheme_mailto

SE LO SCHEME È UGUALE A NEWS
Se lo scheme è uguale a news, vuol dire che si ha solo l'host, quindi la lista di caratteri rimanente viene trasformata in una stringa e passata direttamente a uri_display.

SE LO SCHEME È UGUALE A TEL O FAX
Se lo scheme è uguale a tel o fax, vuol dire che si ha solo l'host, quindi la lista di caratteri rimanente viene trasformata in una stringa e passata direttamente a uri_display.

SE LO SCHEME È UGUALE A ZOS
Come lo scheme http, controlla se ci siano '//'. Se sono presenti passa la lista alla regola per il controllo dello UserInfo in cui all'interno si ha il controllo della presenza dei caratteri
'@', ':', '/' , perchè se non è presente '@' si controlla se sia presente ':' e se è presente il resto della lista viene passato alla regola che gestisce l'host(che contiene tutti i controlli
e l'eventuale passaggio delle varie parti alle relative regole). Lo stesso vale per '/'. Se non presente anche '/' viene calcolato direttamente l'host e passato all'uri_display. 
L'unica differenza con lo scheme http sta nel path. Nel path nello scheme zos si trova nella forma id44(id8). Ovvero prima delle parentesi si possono avere massimo 44 caratteri, mentre
all'interno delle parentesi si possono avere massimo 8 caratteri. 

