#lang racket

(require racket/fixnum
         "../compiler/utilities.rkt")
(provide interp-R1)

; interpreter for R1 language
; Taken from page 17 of Essentials of Compilation
(define (interp-R1 env)
  (lambda (e)
    (define recur (interp-R1 env))
    (match e
      [(? symbol?) (lookup e env)]
      [`(let ([,x ,(app recur v)]) ,body)
        (define new-env (cons (cons x v) env))
        ((interp-R1 new-env) body)] [(? fixnum?) e]
      [`(read)
        (define r (read)) (cond [(fixnum? r) r]
                                [else (error 'interp-R1 "expected␣an␣integer" r)])]
      [`(- ,(app recur v))
        (fx- 0 v)]
      [`(+ ,(app recur v1) ,(app recur v2))
        (fx+ v1 v2)]
      [`(program ,e) ((interp-R1 '()) e)]
      )))
