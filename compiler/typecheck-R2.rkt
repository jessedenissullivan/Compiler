#lang racket

(require racket/fixnum)
(provide typecheck-R2)

; taken from page 53 of textbook
(define (typecheck-R2 env)
  (lambda (e)
    (match e
      [(? fixnum?) 'Integer]
      [(? boolean?) 'Boolean]
      [(? symbol?) (hash-ref e env)]
      [`(let ([,x ,es]) ,body)
       (hash-set! env x ((typecheck-R2 env) es))
       ((typecheck-R2 env) body)]
      [`(not ,(app (typecheck-R2 env) T))
       (match T
         ['Boolean 'Boolean]
         [else (error 'typecheck-R2 "’not’␣expects␣a␣Boolean" e)])]
      [`(,op ,v1 ,v2)
       (cond [(eq? (hash-ref env v1)
                   (hash-ref env v2)
                   'Integer)
              (hash-ref env v1)]
             [else (error 'typecheck-R2 "")])]
      [`(program ,body)
       (define ty ((typecheck-R2 (hash)) body))
       `(program (type ,ty) ,body)]
      )))