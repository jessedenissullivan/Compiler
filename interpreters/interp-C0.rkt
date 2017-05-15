#lang racket

(require racket/fixnum)

; interpreter for the C0 langauge
; accepts (program (vars) (expressions) (return value)) and returns the interpreted value
; env is a mutable hash-table that is overwritten when passed a program
(define (interp-C0 env)
  (lambda (e)
    (match e
      [`(program ,vars ,assigns ,return)
       (define env (make-hash))
       (map (interp-C0 env) assigns)
       (interp-C0)]
      [`(,op ,v1 ,v2)
       (cond
         [(eq? op '+) (fx+ v1 v2)]
         [else (error 'interp-C0 "Binary operator not recognized")])]
      [`(,op ,v1)
       (cond [(eq? op '-) (fx- 0 v1)]
             [else "Unary operator not recognized"])]
      [`(let ([,x ,es]) ,body)
       (hash-set! env x ((interp-C0 env) es))
       ((interp-C0 env) body)]
      ['(read) (read)]
      [`(assign ,lhs ,rhs)
       (hash-set! env lhs ((interp-C0 env) rhs))]
      [`(return ,value)
       (cond
         [(and (symbol? value) (hash-has-key? value)) (hash-ref env value)]
         [else (error 'interp-C0 "Return value not recognized in environment")])]
      )))