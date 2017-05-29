#lang racket

(require "utilities.rkt")
(provide uniquify)

; function for uniquify pass
; turns all variables in racket program into unique names
(define (uniquify alist)
  (lambda (e)
    (match e
      [(? number?) e] ; if expr is a number, return the number
      [(? symbol?) (lookup e alist)]
      [`(let ([,x ,e]) ,b)  ; if expr is let stmt
       (define flat_e ((uniquify alist) e))
       (define alist_ext (cons (cons x (gensym x)) alist))  ;incorporating newly uniquified name
       (define flat_b ((uniquify alist_ext) b))
       ; return originial let stmt with unquified names
       `(let ([,(lookup x alist_ext) ,flat_e]) ,flat_b)] 
      [`(program ,e)
       `(program ,((uniquify alist) e))] ; if program module, uniquify all exprs in it
      [`(,op ,es ...)
       `(,op ,@(map (uniquify alist) es))]
      )))