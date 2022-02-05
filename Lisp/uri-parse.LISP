;Giuliani Viviana 875068
;Daniel Marco Gatti 869310

(defstruct (uri(:constructor create-uri( 
  (scheme :type string) 
  (user_info :type string)
  (host :type string)
  (port :type int)
  (path :type string)
  (query :type string)
  (fragment :type string)
))))

(defun uri-parse(uri-structure) ;Questa funzione deve ritornare una struttura con i 7 campi della uri. Idea mia: prendo la stringa e la faccio diventare una lista dove ogni elemento con posizione sarà assegnato a un determinato campo
   (cond((streamp uri-structure)
         (string-to-list(uri-structure))))
)

(defun string-to-list(str)
  (let newlist (coerce str 'list)) ;converte la stringa in una lista con #/
  (cond((null newList)0)
       ((let newstring(car newlist))
        (string-trim "#/" newstring)))) ;non so se va
        ;devo creare nuova lista con elementi sistemati

  ;bisogna ora capire come suddividere la lista nelle stringhe che vogliamo

