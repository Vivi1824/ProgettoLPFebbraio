;======================================
;STUDENTI DEL GRUPPO               
;======================================
;Giuliani Viviana 875068
;Daniel Marco Gatti 869310
;======================================
;PROGETTO APPELLO DEL 25 FEBBRAIO 2022
;======================================

;======================================
;COSE DA FARE
;1) capire come si fa la cancellazione degli elementi dalle liste 
;   dopo aver fatto la cons
;2) creare tutti i controlli per la sintassi dei campi
;3) capire come assegnare i vari risultati delle funzioni alla defstruct
;4) 
;L'idea è che venga analizzato prima lo scheme e poi in base a quello che viene 
;riconosciuto allora si va ad analizzare il resto della stringa
;====================================== 

(defstruct (uri(:constructor create-uri( 
  (scheme :type string) 
  (user_info :type string)
  (host :type string)
  (port :type int)
  (path :type string)
  (query :type string)
  (fragment :type string)
))))

(defun uri-parse(uri-structure)
  (let newlist(coerce uri-structure 'list))
  ;(format nil "~{~a~}"(coerce uri-structure 'list)) ;prende gli elementi della lista e li formatta come stringa
)
;map nil #'princ   questo serve per levare i # 

(defun uri-scheme(disco)
   (cond((null disco)nil)
        ((if(or(eql(car disco)#\h)(eql(car disco)#\t)(eql(car disco)#\p)
               (eql(car disco)#\m)(eql(car disco)#\a)(eql(car disco)#\i)(eql(car disco)#\l)
               (eql(car disco)#\o)(eql(car disco)#\n)(eql(car disco)#\e)(eql(car disco)#\w)
               (eql(car disco)#\s)(eql(car disco)#\f)(eql(car disco)#\x)(eql(car disco)#\z)) ;if-part
            (let x(cons(car disco)(uri-scheme(cdr disco)))))) 
   )
)

(defun uri-userinfo(disco);senza la cancellazione
    (cond((null disco)nil)
         ((if(or(not(eql(car disco)#\@)))
         (cons(car disco)(uri-userinfo(cdr disco))))))
)

;(defun delete-after-user-info (disco)
 ; (cond((null disco)nil)
  ;     ((if(or(eql(car disco)#\@))
   ;        (cons(cdr disco)(delete-after-user-info(cdr disco))))))
;)

(defun uri-host(disco)
    ;(cond((null disco)nil)
         ;((if(or(not(eql(car disco)#\:)))
         ;(cons(car disco)(uri-host(cdr disco))))))
  (if(equal(coerce "http" 'list)(uri-scheme disco))
      (uri-host-http disco)
  )
)

(defun uri-host-http(disco)
  (cond((null disco)nil)
        ((if(eql(car disco)#\/)
        (cons(car disco)(uri-host-http(cdr disco)))))) 
       
         
) 

;(defun delete-after-host(disco)
 ; (cond((null disco)nil)
  ;     ((if(or(eql(car disco)#\:))
   ;        (cons(car disco)(delete-after-host(cdr disco))))))
;)

(defun uri-port(disco);serve cancellazione
  (cond((null disco)nil)
       ((if(or(eql(car disco)#\8)(eql(car disco)#\0))
           (cons(car disco)(uri-port(cdr disco))))))
       ;bisogna convertire in numero
)
     
(defun uri-path(disco) ;serve cancellazione
  (cond((null disco)nil)
       ((if(or(not(eql(car disco)#\?)))
         (cons(car disco)(uri-path(cdr disco))))))
)
(defun uri-query(disco) ;serve cancellazione
  (cond((null disco)nil)
        ((if(or(not(eql(car disco)#\#)))
         (cons(car disco)(uri-query(cdr disco))))))
)

(defun uri-fragment(disco)
  (cond((null disco)nil)
         (cons(car disco)(uri-fragment(cdr disco))))
)

(defun uri-display(disco))
          



;(defun my-concat( list ) ;per concatenare
  ;(format nil "~{~a~}" list))
