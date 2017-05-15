#lang racket

(provide flatten)

; function for flatten pass
; converts nested expressions into sequence of assignment statements

(define flatten
  (lambda (e)
    (match e
      [(? fixnum?) (values e '() '())]
      [(? symbol?) (values e '() `(,e))]
      [`(program ,es)
       (define-values (expr assigns vars) (flatten es))
       `(program ,vars ,assigns (return ,expr))]
      [`(let ([,x ,es]) ,b)
       (define-values (expr_es assigns_es vars_es) (flatten es))
       (define-values (expr_b assigns_b vars_b) (flatten b))
       (define expr (gensym 'temp))
       (define assigns (append assigns_es `((assign ,x ,expr_es)) assigns_b))
       (define vars (append vars_es vars_b))
       (values expr_b assigns vars)]
      [`(,op ,v1 ,v2)
       (define-values (expr_v1 assigns_v1 vars_v1) (flatten v1))
       (define-values (expr_v2 assigns_v2 vars_v2) (flatten v2))
       (define expr (gensym 'temp))
       (values expr
               (append assigns_v1 assigns_v2 `((assign ,expr (,op ,expr_v1 ,expr_v2))))
               (append (list expr) vars_v1 vars_v2))]
      [`(,op ,val)
       (define expr (gensym 'temp))
       (define vars (list expr))
       (define assigns `((assign ,expr ,e)))
       (values expr assigns vars)]
      [else (printf "~a\n" e)])))
