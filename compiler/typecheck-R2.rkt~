#lang racket

(require racket/fixnum)
(provide typecheck-R2)

(define bool-primitives (set 'and 'or))
(define int-primitives (set '+ '- ))
(define int2bool-primitives (set '< '<= '> '>= ))

; taken from page 53 of textbook
(define (typecheck-R2 env)
  (lambda (e)
    (match e
      [(? fixnum?) 'Integer]
      [(? boolean?) 'Boolean]
      [(? symbol?) (lookup e env)]
      [`(read) 'Integer]
      [`(if ,c ,t ,e)
       (let ([c_t ((typecheck-R2 env) c)]
             [t_t ((typecheck-R2 env) t)]
             [e_t ((typecheck-R2 env) e)])
         (if (and (equal? c_t 'Boolean)
                  (equal? t_t e_t))
             t_t
             (error
              'typecheck-R2
              "two branches of if statement are not the same type or the condition is not a boolean"
              e)))]
      [`(let ([,x ,es]) ,body)
       (set! env (cons env (cons x ((typecheck-R2 env) es))))
       ((typecheck-R2 env) body)]
      [`(not ,(app (typecheck-R2 env) T))
       (match T
         ['Boolean 'Boolean]
         [else (error 'typecheck-R2 "’not’␣expects␣a␣Boolean" e)])]
      [`(eq? ,(app (typecheck-R2 env) T1) ,(app (typecheck-R2 env) T2))
       (if (equal? T1 T2)
           'Boolean
           (error 'typecheck-R2 "types are not equal" e))]
      [`(,op ,v1 ,v2)
       (cond [(set-member? bool-primitives op)
              (if (and (equal? ((typecheck-R2 env) v1)
                               ((typecheck-R2 env) v2))
                       (equal? 'Boolean
                               ((typecheck-R2 env) v1)))
                  'Boolean
                  (error 'typecheck-R2 "expected booleans" e))]
             [(set-member? int-primitives op)
              (if (and (equal? ((typecheck-R2 env) v1)
                               ((typecheck-R2 env) v2))
                       (equal? 'Integer
                               ((typecheck-R2 env) v1)))
                  'Integer
                  (error 'typecheck-R2 "expected integers" e))]
             [(set-member? int2bool-primitives op)
              (if (and (equal? ((typecheck-R2 env) v1)
                               ((typecheck-R2 env) v2))
                       (equal? 'Integer
                               ((typecheck-R2 env) v1)))
                  'Boolean
                  (error 'typecheck-R2 "expected integers" e))]
             [else (error 'typecheck-R2 "")])]
      [`(program ,body)
       ((typecheck-R2 env) body)]
      )))

(require "utilities.rkt")
((typecheck-R2 '()) (read-program "tests/R2_7.rkt"))