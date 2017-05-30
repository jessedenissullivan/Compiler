#lang racket

(require "../compiler/utilities.rkt"
         racket/fixnum)
(provide interp-R2)

(define primitives (set '+ '- 'eq? '< '<= '> '>= 'not 'read))

(define (interp-op op)
  (match op
    ['+ fx+]
    ['- (lambda (n) (fx- 0 n))]
    ['not (lambda (v)
            (match v
              [#t #f]
              [#f #t]))]
    ['read read-fixnum]
    ['eq? (lambda (v1 v2)
            (cond [(or (and (fixnum? v1) (fixnum? v2))
                       (and (boolean? v1) (boolean? v2))
                       (and (vector? v1) (vector? v2)))
                   (eq? v1 v2)]))]
    ['< (lambda (v1 v2)
          (cond [(and (fixnum? v1)
                      (fixnum? v2))
                 (< v1 v2)]))]
    ['<= (lambda (v1 v2)
           (cond [(and (fixnum? v1)
                       (fixnum? v2))
                  (<= v1 v2)]))]
    ['> (lambda (v1 v2)
          (cond [(and (fixnum? v1)
                      (fixnum? v2))
                 (> v1 v2)]))]
    ['>= (lambda (v1 v2)
           (cond [(and (fixnum? v1)
                       (fixnum? v2))
                  (>= v1 v2)]))]
    [else (error 'interp-op "unknown␣operator")]))

(define (interp-R2 env)
  (lambda (e)
    (define recur (interp-R2 env))
    (match e
      [(? boolean?) e]
      [(? fixnum?) e]
      [`(if ,cnd ,thn ,els)
       (match (recur cnd)
         [#t (recur thn)]
         [#f (recur els)])]
      [`(not ,(app recur v))
       (match v
         [#t #f]
         [#f #t])]
      [`(and ,(app recur v1) ,e2)
       (match v1
         [#t (match (recur e2)
               [#t #t]
               [#f #f])]
         [#f #f])]
      [`(,op ,(app recur args) ...)
       #:when (set-member? primitives op) (apply (interp-op op) args)]
      [(? symbol?) (lookup e env)]
      [`(let ([,x ,(app recur v)]) ,body)
       (define new-env (cons (cons x v) env))
       ((interp-R2 new-env) body)]
      [`(program ,e)
       ((interp-R2 '()) e)]
      )))

((interp-R2 '()) (read-program "../compiler/tests/R2_5.rkt"))