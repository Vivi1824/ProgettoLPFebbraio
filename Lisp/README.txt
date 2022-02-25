Studenti del gruppo: Giuliani Viviana 875068, Gatti Daniel Marco 869310
Progetto per appello del 25 febbraio 2022

Spiegazione delle varie parti del progetto.
STRUCTURE
La struttura viene creata con defstruct, elencando tutti e 7 i campi.
Viene utilizzato il construct per creare ogni campo richiamando le funzioni che li creano.

URI-PARSE
Converte la stringa che viene inserita come input in una lista di caratteri grazie alla 
funzione coerce.

URI-SCHEME
La funzione cerca di capire se esiste uno scheme valido o meno. 
Formatta il risultato come stringa finale.
uri-scheme-def controlla che lo scheme sia tra quelli accettati analizzando le lettere 
grazie alla chiamata ricorsiva. Quindi ogni volta controlla la testa e decide se è 
accettata o meno.

URI-USERINFO
La funzione cerca di capire quale scheme ha la stringa uri e in base a quale scheme si è
trovato in precedenza procede ad analizzare lo userinfo con la funzione associata.
Uri-userinfo-http: controlla se @ è presente, se si crea una sottolista che va dallo slash dello scheme alla 
chiocciola appena trovata.
Uri-userinfo-mailto: ricorsivamente controlla tutto quello che c'è dopo i : che vanno a delimitare 
scheme e userinfo e poi raccoglie la coda.
Uri-userinfo-tel: ragionamento uguale a mailto.
Uri-userinfo-fax: ragionamento uguale a mailto.

URI-HOST
La funzione cerca di capire quale scheme ha la stringa uri e in base a quale scheme si è
trovato in precedenza procede ad analizzare l'host con la funzione associata.
Formatta il risultato come stringa finale.
Uri-host-http: controlla se @ è presente, se si crea una sottolista con inizio il carattere dopo la
chiocciola e come fine il carattere prima dell'inizio del path.
Uri-host-mailto: ricorsivamente controlla tutto quello che c'è dopo la @ che vanno a delimitare 
userinfo e host e poi raccoglie la coda.
Uri-host-news: ricorsivamente controlla tutto quello che c'è dopo i : che vanno a delimitare 
scheme e host e poi raccoglie la coda.

URI-PORT
La funzione riporta la porta 80 di default come è stato scritto all'interno della traccia
del progetto.

URI-PATH
La funzione cerca di capire quale scheme ha la stringa uri e in base a quale scheme si è
trovato in precedenza procede ad analizzare il path con la funzione associata.
Formatta il risultato come stringa finale.
Uri-path-http: raccoglie tutto ciò che c'è dopo lo slash e prima il punto di domanda.
Uri-path-zos: fa il controllo che non ci sia un punto prima della parentesi tonda con la funzione
dot-control e fa il controllo se non ci sono numeri all'inizio delle stringhe con digit-control. Dopo
di che va a raccogliere tutto ciò che c'è nel path prima della tonda e conta se minore di 44. Se si, 
allora passa a vedere se quello che c'è tra le tonde sono minori di 8 caratteri. Se qualcosa non va
bene fa risultare un errore.

URI-QUERY
La funzione cerca di capire quale scheme ha la stringa uri e in base a quale scheme si è
trovato in precedenza procede ad analizzare la query con la funzione associata.
Formatta il risultato come stringa finale.
Prende tutto ciò che c'è tra ? e #.

URI-FRAGMENT
La funzione prende tutto ciò che c'è dopo #.

URI-DISPLAY 
Crea la stampa con associate tutte le varie parti dell'uri come viene presentata sulla 
traccia del progetto.
