;======================================
;STUDENTI DEL GRUPPO               
;======================================
;Giuliani Viviana 875068
;Gatti Daniel Marco 869310
;=======================================================================================
;PROGETTO APPELLO DEL 25 FEBBRAIO 2022
;=======================================================================================

;=======================================================================================
;COSE DA FARE
;1) creare controlli per indirizzo ip, il path zos con punto e carattere           
;3)capire come poter suddividere bene il path e l'host
;=======================================================================================
  ;STRUCTURE
;=======================================================================================
(defstruct uristruc 
  scheme  
  user_info
  host
  port
  path
  query
  fragment
)

(defun construct(uri-structure)
  (make-uristruc :scheme (uri-scheme uri-structure)
                 :user_info (uri-userinfo uri-structure)
                 :host (uri-host uri-structure)
                 :port (uri-port uri-structure)
                 :path (uri-path uri-structure)
                 :query (uri-query uri-structure)
                 :fragment (uri-fragment uri-structure)
  )
)

(defun crea-struttura(uri-structure)
  (construct uri-structure)
)
;=======================================================================================
  ;URI-PARSE
;=======================================================================================
(defun uri-parse(uri-structure) 
  (coerce uri-structure 'list)
)
;======================================================================================
  ;URI-SCHEME
;======================================================================================
(defun uri-scheme(disco)
  (if(not(eql(uri-scheme-def disco)nil))
  (format nil "~{~a~}" (uri-scheme-def disco)))
)

(defun uri-scheme-def(disco)
   (cond((null disco)nil)
        ((if(or(eql(car disco)#\h)(eql(car disco)#\t)(eql(car disco)#\p)
               (eql(car disco)#\m)(eql(car disco)#\a)(eql(car disco)#\i)
               (eql(car disco)#\l)(eql(car disco)#\o)(eql(car disco)#\n)
               (eql(car disco)#\e)(eql(car disco)#\w)(eql(car disco)#\s)
               (eql(car disco)#\f)(eql(car disco)#\x)(eql(car disco)#\z)) 
               (let x(cons(car disco)(uri-scheme-def(cdr disco))))))))
;======================================================================================
  ;URI-USERINFO
;======================================================================================
(defun uri-userinfo(disco)
  (if(not(eql(uri-userinfo-def disco)nil))
  (format nil "~{~a~}" (uri-userinfo-def disco)))
)

(defun uri-userinfo-def(disco)
  (cond((equal(coerce "mailto" 'list)(uri-scheme-def disco))(uri-userinfo-mailto disco))
       (t(cond((equal(coerce "tel" 'list)(uri-scheme-def disco))(uri-userinfo-tel disco))
         (t(cond((equal(coerce "http" 'list)(uri-scheme-def disco))(uri-userinfo-http disco))
           (t(cond((equal(coerce "fax" 'list)(uri-scheme-def disco))(uri-userinfo-fax disco))
              (t(cond((equal(coerce "zos" 'list)(uri-scheme-def disco))(uri-userinfo-http disco))))))))))))

(defun uri-userinfo-http(disco)
  (if(not(eql(member #\@ disco)nil))
                  (sub-list disco (+ (conta-slash disco) 2)
                                  (-(conta-chiocciola disco)(+(conta-slash disco)2)))))
(defun uri-userinfo-mailto(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\:)(cdr disco)) 
       (t(uri-userinfo-mailto(cdr disco)))))

(defun uri-userinfo-tel(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\:)(cdr disco)) 
       (t(uri-userinfo-tel(cdr disco)))))

(defun uri-userinfo-fax(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\:)(cdr disco)) 
       (t(uri-userinfo-fax(cdr disco)))))
;======================================================================================
  ;URI-HOST
;======================================================================================
(defun uri-host(disco)
  (if(not(eql(uri-host-def disco)nil))
     (format nil "~{~a~}" (uri-host-def disco)))
)
(defun uri-host-def(disco)
  (cond((equal(coerce "http" 'list)(uri-scheme-def disco))(uri-host-http disco))
       (t(cond((equal(coerce "mailto" 'list)(uri-scheme-def disco))(uri-host-mailto disco)) 
         (t(cond((equal(coerce "news" 'list)(uri-scheme-def disco))(uri-host-news disco))
           (t(cond((equal(coerce "zos" 'list)(uri-scheme-def disco))(uri-host-http disco))
))))))))

;potrei risolvere il problema di scelta vedendo se sono minori di quelli iniziali
(defun uri-host-http(disco) ;capire che tipo di stringa può capitare
  (if(not(eql(member #\@ disco)nil)) ;se non è nullo quindi c'è @
      (sub-list disco (+ (conta-chiocciola disco) 1)nil)
      (sub-list disco (+ (conta-slash disco) 2)nil)) 
)

(defun uri-host-mailto(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\@)(cdr disco))
       (t(uri-host-mailto(cdr disco))))) 

(defun uri-host-news(disco)
  (cond((null disco)nil)
       ((eql(car disco)#\:)(cdr disco)) 
       (t(uri-host-news(cdr disco)))))
;======================================================================================
  ;URI-PORT
;======================================================================================
(defun uri-port(disco)
   (uri-port-def disco) 
)
(defun uri-port-def(disco)
  (if(equal(coerce "http" 'list)(uri-scheme-def disco))
      (format nil "~d" 80))              
)
;======================================================================================
  ;URI-PATH
;======================================================================================
(defun uri-path(disco)
  (if(not(eql(uri-path-def disco)nil))
      (format nil "~{~a~}" (uri-path-def disco)))
)
(defun uri-path-def(disco)
  (cond((equal(coerce "http" 'list)(uri-scheme-def disco))(uri-path-http disco))
           (t(cond((equal(coerce "zos" 'list)(uri-scheme-def disco))(uri-path-zos disco))
))))

(defun uri-path-http(disco)
  (sub-list disco (+ (conta-slash disco) 2)
                  (-(conta-puntodomanda disco)(+(conta-slash disco)2))))

(defun uri-path-zos(disco) ;manca controllo punto e carattere alfabetico
  (if(and(<(conta-parentesi-aperta disco) 44)
         (<(-(conta-parentesi-chiusa disco)(conta-parentesi-aperta disco))8))
  (sub-list disco (+ (conta-slash disco) 2)
                  (-(conta-parentesi-chiusa disco)(+(conta-slash disco)2)))
  (write "Path errato")))

;idea per il controllo potrebbe essere di verificare se presente il punto
(defun dot-control(disco)
  
)
;======================================================================================
  ;URI-QUERY
;======================================================================================
(defun uri-query(disco)
  (if(not(eql(uri-query-def disco)nil))
  (format nil "~{~a~}" (uri-query-def disco)))
)

(defun uri-query-def(disco)
   (cond((equal(coerce "http" 'list)(uri-scheme-def disco))(uri-query-http disco))
        (t(cond((equal(coerce "zos" 'list)(uri-scheme-def disco))(uri-query-http disco))
))))


(defun uri-query-http(disco)
  (sub-list disco (+(conta-puntodomanda disco)1)
                  (-(conta-hashtag disco)(+(conta-puntodomanda disco)1)))
)
;======================================================================================
  ;URI-FRAGMENT
;======================================================================================
(defun uri-fragment(disco)
  (if(not(eql(uri-fragment-def disco)nil))
  (format nil "~{~a~}" (uri-fragment-def disco)))
)
(defun uri-fragment-def(disco)
   (sub-list disco (+(conta-hashtag disco)1) nil)
)
;======================================================================================
  ;URI-DISPLAY
;======================================================================================
(defun uri-display(disco)
  (princ "Scheme: ")(prin1(uri-scheme disco))
  (terpri)
  (princ "Userinfo: ")(prin1(uri-userinfo disco))
  (terpri)
  (princ "Host: ")(prin1(uri-host disco))
  (terpri)
  (princ "Port: ")(prin1(uri-port disco))
  (terpri)
  (princ "Path: ")(prin1(uri-path disco))
  (terpri)
  (princ "Query: ")(prin1(uri-query disco))
  (terpri)
  (princ "Fragment: ")(prin1(uri-fragment disco))
  (terpri)
)      
;======================================================================================
  ;OTHER FUNCTIONS
;======================================================================================
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

(defun conta-duepunti(disco)
    (cond((null disco)0)
         ((not(eql(car disco)#\:))(+ 1(conta-duepunti(cdr disco))))
         (t(conta-duepunti()))
    )
)

(defun conta-slash(disco)
    (cond((null disco)0)
         ((not(eql(car disco)#\/))(+ 1(conta-slash(cdr disco))))
         (t(conta-slash()))
    )
)

(defun conta-chiocciola(disco)
    (cond((null disco)0)
         ((not(eql(car disco)#\@))(+ 1(conta-chiocciola(cdr disco))))
         (t(conta-chiocciola()))
    )
)

(defun conta-puntodomanda(disco)
  (cond((null disco)0)
         ((not(eql(car disco)#\?))(+ 1(conta-puntodomanda(cdr disco))))
         (t(conta-puntodomanda())) 
  )   
)

(defun conta-hashtag(disco)
  (cond((null disco)0)
       ((not(eql(car disco)#\#))(+ 1(conta-hashtag(cdr disco))))
       (t(conta-hashtag())))
)

(defun conta-parentesi-aperta(disco)
  (cond((null disco)0)
       ((not(eql(car disco)#\( ))(+ 1(conta-parentesi-aperta(cdr disco))))
       (t(conta-parentesi-aperta())))
)

(defun conta-parentesi-chiusa(disco)
  (cond((null disco)0)
       ((not(eql(car disco)#\) ))(+ 1(conta-parentesi-chiusa(cdr disco))))
       (t(conta-parentesi-chiusa())))
)

