#lang racket

(require racket/fixnum)
(provide interp-R0)

; Interpreter for the R0 language
; alist is an association list mapping variable names to values
; e is an expression within a program
(define (interp-R0 alist e)
  (match e
    [(? fixnum?) e]
    [`(read)
     (let ([r (read)])
       (cond [(fixnum? r) r]
             [else (error 'interp-R0 "input␣not␣an␣integer" r)]))]
    [`(- ,(app interp-R0 v))
     (fx- 0 v)]
    [`(+ ,(app interp-R0 v1) ,(app interp-R0 v2))
     (fx+ v1 v2)]
    [`(let ([,x ,exp]) ,b)
     (interp-R0)]
    [`(program ,(app interp-R0 v)) v]
    ))

