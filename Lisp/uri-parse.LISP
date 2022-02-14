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
(defun uri-scheme(uri-structure)
  (if(not(eql(uri-scheme-def uri-structure)nil))
  (format nil "~{~a~}" (uri-scheme-def uri-structure)))
)

(defun uri-scheme-def(uri-structure)
   (cond((null uri-structure)nil)
        ((if(or(eql(car uri-structure)#\h)(eql(car uri-structure)#\t)(eql(car uri-structure)#\p)
               (eql(car uri-structure)#\m)(eql(car uri-structure)#\a)(eql(car uri-structure)#\i)
               (eql(car uri-structure)#\l)(eql(car uri-structure)#\o)(eql(car uri-structure)#\n)
               (eql(car uri-structure)#\e)(eql(car uri-structure)#\w)(eql(car uri-structure)#\s)
               (eql(car uri-structure)#\f)(eql(car uri-structure)#\x)(eql(car uri-structure)#\z)) 
               (let x(cons(car uri-structure)(uri-scheme-def(cdr uri-structure))))))))
;======================================================================================
  ;URI-USERINFO
;======================================================================================
(defun uri-userinfo(uri-structure)
  (if(not(eql(uri-userinfo-def uri-structure)nil))
  (format nil "~{~a~}" (uri-userinfo-def uri-structure)))
)

(defun uri-userinfo-def(uri-structure)
  (cond((equal(coerce "mailto" 'list)(uri-scheme-def uri-structure))(uri-userinfo-mailto uri-structure))
       (t(cond((equal(coerce "tel" 'list)(uri-scheme-def uri-structure))(uri-userinfo-tel uri-structure))
         (t(cond((equal(coerce "http" 'list)(uri-scheme-def uri-structure))(uri-userinfo-http uri-structure))
           (t(cond((equal(coerce "fax" 'list)(uri-scheme-def uri-structure))(uri-userinfo-fax uri-structure))
              (t(cond((equal(coerce "zos" 'list)(uri-scheme-def uri-structure))(uri-userinfo-http uri-structure))
))))))))))

(defun uri-userinfo-http(uri-structure)
  (if(not(eql(member #\@ uri-structure)nil))
                  (sub-list uri-structure (+ (conta-slash uri-structure) 2)
                                  (-(conta-chiocciola uri-structure)(+(conta-slash uri-structure)2)))))
(defun uri-userinfo-mailto(uri-structure)
  (cond((null uri-structure)nil)
       ((eql(car uri-structure)#\:)(cdr uri-structure)) 
       (t(uri-userinfo-mailto(cdr uri-structure)))))

(defun uri-userinfo-tel(uri-structure)
  (cond((null uri-structure)nil)
       ((eql(car uri-structure)#\:)(cdr uri-structure)) 
       (t(uri-userinfo-tel(cdr uri-structure)))))

(defun uri-userinfo-fax(uri-structure)
  (cond((null uri-structure)nil)
       ((eql(car uri-structure)#\:)(cdr uri-structure)) 
       (t(uri-userinfo-fax(cdr uri-structure)))))
;======================================================================================
  ;URI-HOST
;======================================================================================
(defun uri-host(uri-structure)
  (if(not(eql(uri-host-def uri-structure)nil))
     (format nil "~{~a~}" (uri-host-def uri-structure)))
)
(defun uri-host-def(uri-structure)
  (cond((equal(coerce "http" 'list)(uri-scheme-def uri-structure))(uri-host-http uri-structure))
       (t(cond((equal(coerce "mailto" 'list)(uri-scheme-def uri-structure))(uri-host-mailto uri-structure)) 
         (t(cond((equal(coerce "news" 'list)(uri-scheme-def uri-structure))(uri-host-news uri-structure))
           (t(cond((equal(coerce "zos" 'list)(uri-scheme-def uri-structure))(uri-host-http uri-structure))
))))))))

;potrei risolvere il problema di scelta vedendo se sono minori di quelli iniziali
(defun uri-host-http(uri-structure) ;capire che tipo di stringa può capitare
  (if(not(eql(member #\@ uri-structure)nil)) ;se non è nullo quindi c'è @
      (sub-list uri-structure (+ (conta-chiocciola uri-structure) 1)nil)
      (sub-list uri-structure (+ (conta-slash uri-structure) 2)nil)) 
)

(defun uri-host-mailto(uri-structure)
  (cond((null uri-structure)nil)
       ((eql(car uri-structure)#\@)(cdr uri-structure))
       (t(uri-host-mailto(cdr uri-structure))))) 

(defun uri-host-news(uri-structure)
  (cond((null uri-structure)nil)
       ((eql(car uri-structure)#\:)(cdr uri-structure)) 
       (t(uri-host-news(cdr uri-structure)))))
;======================================================================================
  ;URI-PORT
;======================================================================================
(defun uri-port(uri-structure)
   (uri-port-def uri-structure) 
)
(defun uri-port-def(uri-structure)
  (if(equal(coerce "http" 'list)(uri-scheme-def uri-structure))
      (format nil "~d" 80))              
)
;======================================================================================
  ;URI-PATH      
;======================================================================================
(defun uri-path(uri-structure)
  (if(not(eql(uri-path-def uri-structure)nil))
      (format nil "~{~a~}" (uri-path-def uri-structure)))
)
(defun uri-path-def(uri-structure)
  (cond((equal(coerce "http" 'list)(uri-scheme-def uri-structure))(uri-path-http uri-structure))
           (t(cond((equal(coerce "zos" 'list)(uri-scheme-def uri-structure))(uri-path-zos uri-structure))
))))

(defun uri-path-http(uri-structure)
  (sub-list uri-structure (+ (conta-slash uri-structure) 2)
                  (-(conta-puntodomanda uri-structure)(+(conta-slash uri-structure)2))))

(defun uri-path-zos(uri-structure) ;manca controllo punto e carattere alfabetico
  (dot-control uri-structure)
  (if(and(<(conta-parentesi-aperta uri-structure) 44)
         (<(-(conta-parentesi-chiusa uri-structure)(conta-parentesi-aperta uri-structure))8))
  (sub-list uri-structure (+ (conta-slash uri-structure) 1)
                  (-(conta-parentesi-chiusa uri-structure)(conta-slash uri-structure)))
  (write "Path errato"))
)

(defun dot-control(uri-structure)
   (if(eql(nth(-(conta-parentesi-aperta uri-structure)1) uri-structure)#\.)
      (break "Path errato, c'è un punto alla fine di Id44"))
)
;======================================================================================
  ;URI-QUERY
;======================================================================================
(defun uri-query(uri-structure)
  (if(not(eql(uri-query-def uri-structure)nil))
  (format nil "~{~a~}" (uri-query-def uri-structure)))
)

(defun uri-query-def(uri-structure)
   (cond((equal(coerce "http" 'list)(uri-scheme-def uri-structure))(uri-query-http uri-structure))
        (t(cond((equal(coerce "zos" 'list)(uri-scheme-def uri-structure))(uri-query-http uri-structure))
))))


(defun uri-query-http(uri-structure)
  (sub-list uri-structure (+(conta-puntodomanda uri-structure)1)
                  (-(conta-hashtag uri-structure)(+(conta-puntodomanda uri-structure)1)))
)
;======================================================================================
  ;URI-FRAGMENT
;======================================================================================
(defun uri-fragment(uri-structure)
  (if(not(eql(uri-fragment-def uri-structure)nil))
  (format nil "~{~a~}" (uri-fragment-def uri-structure)))
)
(defun uri-fragment-def(uri-structure)
   (sub-list uri-structure (+(conta-hashtag uri-structure)1) nil)
)
;======================================================================================
  ;URI-DISPLAY
;======================================================================================
(defun uri-display(uri-structure)
  (princ "Scheme: ")(prin1(uri-scheme uri-structure))
  (terpri)
  (princ "Userinfo: ")(prin1(uri-userinfo uri-structure))
  (terpri)
  (princ "Host: ")(prin1(uri-host uri-structure))
  (terpri)
  (princ "Port: ")(prin1(uri-port uri-structure))
  (terpri)
  (princ "Path: ")(prin1(uri-path uri-structure))
  (terpri)
  (princ "Query: ")(prin1(uri-query uri-structure))
  (terpri)
  (princ "Fragment: ")(prin1(uri-fragment uri-structure))
  (terpri)
)      
;======================================================================================
  ;OTHER FUNCTIONS
;======================================================================================
(defun conta (uri-structure)
  (cond ((null uri-structure)0)
        ((numberp (car uri-structure))(+ 1 (conta (cdr uri-structure))))
        (t (conta (cdr uri-structure)))))


(defun sub-list(lst idx len)
    (cond((null lst)nil)
         ((< 0 idx)(sub-list(cdr lst)(1- idx)len))
         ((null len)lst)
         ((< 0 len)(cons(car lst)(sub-list(cdr lst)idx(1- len))))
    )
)

(defun conta-duepunti(uri-structure)
    (cond((null uri-structure)0)
         ((not(eql(car uri-structure)#\:))(+ 1(conta-duepunti(cdr uri-structure))))
         (t(conta-duepunti()))
    )
)

(defun conta-slash(uri-structure)
    (cond((null uri-structure)0)
         ((not(eql(car uri-structure)#\/))(+ 1(conta-slash(cdr uri-structure))))
         (t(conta-slash()))
    )
)

(defun conta-chiocciola(uri-structure)
    (cond((null uri-structure)0)
         ((not(eql(car uri-structure)#\@))(+ 1(conta-chiocciola(cdr uri-structure))))
         (t(conta-chiocciola()))
    )
)

(defun conta-puntodomanda(uri-structure)
  (cond((null uri-structure)0)
         ((not(eql(car uri-structure)#\?))(+ 1(conta-puntodomanda(cdr uri-structure))))
         (t(conta-puntodomanda())) 
  )   
)

(defun conta-hashtag(uri-structure)
  (cond((null uri-structure)0)
       ((not(eql(car uri-structure)#\#))(+ 1(conta-hashtag(cdr uri-structure))))
       (t(conta-hashtag())))
)

(defun conta-parentesi-aperta(uri-structure)
  (cond((null uri-structure)0)
       ((not(eql(car uri-structure)#\( ))(+ 1(conta-parentesi-aperta(cdr uri-structure))))
       (t(conta-parentesi-aperta())))
)

(defun conta-parentesi-chiusa(uri-structure)
  (cond((null uri-structure)0)
       ((not(eql(car uri-structure)#\) ))(+ 1(conta-parentesi-chiusa(cdr uri-structure))))
       (t(conta-parentesi-chiusa())))
)

