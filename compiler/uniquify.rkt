#lang racket

(provide uniquify)

; function for uniquify pass
; turns all variables in racket program into unique names
(define (uniquify alist)
  (lambda (e)
    (match e
      [(? number?) e] ; if expr is a number, return the number
      [(? symbol?) (hash-ref alist e  ; if the expr is a symbol, return the uniquified verision
                             [lambda ()
                               (printf "Variable name not recognized\n")])]
      [`(let ([,x ,e]) ,b)  ; if expr is let stmt
       (define flat_e ((uniquify alist) e))
       (hash-set! alist x (gensym x))  ;incorporating newly uniquified name
       (define flat_b ((uniquify alist) b))
       ; return originial let stmt with unquified names
       `(let ([,(hash-ref alist x) ,flat_e]) ,flat_b)] 
      [`(program ,e)
       `(program ,((uniquify alist) e))] ; if program module, uniquify all exprs in it
      [`(,op ,es ...)
       `(,op ,@(map (uniquify alist) es))]
      )))