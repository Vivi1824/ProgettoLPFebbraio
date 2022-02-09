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
;2) creare tutti i controlli per la sintassi dei campi
;3) capire come assegnare i vari risultati delle funzioni alla defstruct
;4)
;L'idea è che venga analizzato prima lo scheme e poi in base a quello che viene 
;riconosciuto allora si va ad analizzare il resto della stringa
;====================================== 

(defstruct uri 
  scheme  
  user_info
  host
  port
  path
  query
  fragment
)

;(make-uri :scheme (uri-scheme uri-structure)
 ;           :user_info (uri-userinfo uri-structure)
 ;           :host (uri-host uri-structure)
 ;           :port (uri-host uri-structure)
 ;           :path (uri-host uri-structure)
 ;           :query (uri-host uri-structure)
 ;           :fragment (uri-host uri-structure)
;)
;===================================================
  ;URI-PARSE
;===================================================  
(defun uri-parse(uri-structure)
  ;(let newlist(coerce uri-structure 'list))
  (format nil "~{~a~}"(coerce uri-structure 'list))
  
  ;prende gli elementi della lista e li formatta come stringa
)

;map nil #'princ   questo serve per levare i # 
;===================================================
  ;URI-SCHEME
;===================================================
(defun uri-scheme(disco)
   (cond((null disco)nil)
        ((if(or(eql(car disco)#\h)(eql(car disco)#\t)(eql(car disco)#\p)
               (eql(car disco)#\m)(eql(car disco)#\a)(eql(car disco)#\i)
               (eql(car disco)#\l)(eql(car disco)#\o)(eql(car disco)#\n)
               (eql(car disco)#\e)(eql(car disco)#\w)(eql(car disco)#\s)
               (eql(car disco)#\f)(eql(car disco)#\x)(eql(car disco)#\z)) 
               (let x(cons(car disco)(uri-scheme(cdr disco))))))))
;===================================================
  ;URI-USERINFO
;===================================================
(defun uri-userinfo(disco);senza la cancellazione
  (cond((equal(coerce "mailto" 'list)(uri-scheme disco))(uri-userinfo-mailto disco))
       (t(cond((equal(coerce "tel" 'list)(uri-scheme disco))(uri-userinfo-tel disco))
         (t(cond((equal(coerce "fax" 'list)(uri-scheme disco))(uri-userinfo-fax disco)))))))
)

(defun uri-userinfo-mailto(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\:)(cdr disco)) 
       (t(uri-userinfo-mailto(cdr disco)))) ;da finire
)
(defun uri-userinfo-tel(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\:)(cdr disco)) 
       (t(uri-userinfo-tel(cdr disco))))
)
(defun uri-userinfo-fax(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\:)(cdr disco)) 
       (t(uri-userinfo-fax(cdr disco))))
)
;potrei prendere la lista e crearne una nuova con solo i caratteri che mi servono
;====================================================
  ;URI-HOST
;====================================================
(defun uri-host(disco)
  (cond((equal(coerce "http" 'list)(uri-scheme disco))(uri-host-http disco))
       (t(cond((equal(coerce "mailto" 'list)(uri-scheme disco))(uri-host-mailto disco))   
         (t(cond((equal(coerce "news" 'list)(uri-scheme disco))(uri-host-news disco))
           (t(cond((equal(coerce "zos" 'list)(uri-scheme disco))(uri-host-zos disco))))))))))


(defun uri-host-http(disco)
   ;Si deve ricavare la stringa presente dopo :// e prima dei :
  (sub-list disco 7  nil)
  
)

(defun uri-host-mailto(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\@)(cdr disco))
       (t(uri-host-mailto(cdr disco))))) 

(defun uri-host-news(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\:)(cdr disco)) 
       (t(uri-host-news(cdr disco)))))

(defun uri-host-zos(disco)
  (write "zos function")
)

;====================================================
  ;OTHER FUNCTIONS
;===================================================
(defun conta (disco)
  (cond ((null disco)0)
        ((numberp (car disco))(+ 1 (conta (cdr disco))))
        (t (conta (cdr disco)))))

(defun sub-list(lst idx len)
    (cond((null lst)nil)
         ((< 0 idx)(sub-list(cdr lst)(1- idx)len))
         ((null len)lst)
         ((< 0 len)(cons(car lst)(sub-list(cdr lst)idx(1- len))))
    )
)
;====================================================
  ;URI-PORT
;====================================================
(defun uri-port(disco)
  (if(equal(coerce "http" 'list)(uri-scheme disco))
      (write 80))
  
  
)

;====================================================
  ;URI-PATH
;====================================================
(defun uri-path(disco)
  
)
;====================================================
  ;URI-QUERY
;====================================================

(defun uri-query(disco)

)
;====================================================
  ;URI-FRAGMENT
;====================================================
(defun uri-fragment(disco)
  
)
;====================================================
  ;URI-DISPLAY
;====================================================
(defun uri-display(disco)
  (princ "Scheme: ")(princ(uri-scheme disco))
  (terpri)
  (princ "Userinfo: ")(princ(uri-userinfo disco))
  (terpri)
  (princ "Host: ")(princ(uri-host disco))
  (terpri)
  (princ "Port: ")(princ(uri-port disco))
  (terpri)
  (princ "Path: ")(princ(uri-path disco))
  (terpri)
  (princ "Query: ")(princ(uri-query disco))
  (terpri)
  (princ "Fragment: ")(princ(uri-fragment disco))
 
)
          



;(defun my-concat( list ) ;per concatenare
  ;(format nil "~{~a~}" list))
