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

URI-USERINFO
La funzione cerca di capire quale scheme ha la stringa uri e in base a quale scheme si è
trovato in precedenza procede ad analizzare lo userinfo con la funzione associata.

URI-HOST
La funzione cerca di capire quale scheme ha la stringa uri e in base a quale scheme si è
trovato in precedenza procede ad analizzare l'host con la funzione associata.

URI-PORT
La funzione riporta la porta 80 di default come è stato scritto all'interno della traccia
del progetto.

URI-PATH
La funzione cerca di capire quale scheme ha la stringa uri e in base a quale scheme si è
trovato in precedenza procede ad analizzare il path con la funzione associata.

URI-QUERY
La funzione cerca di capire quale scheme ha la stringa uri e in base a quale scheme si è
trovato in precedenza procede ad analizzare la query con la funzione associata.

URI-DISPLAY 
Crea la stampa con associate tutte le varie parti dell'uri come viene presentata sulla 
traccia del progetto.
