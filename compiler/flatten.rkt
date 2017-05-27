#lang racket

(require "utilities.rkt")
(provide flatten-prog)

; function for flatten pass
; converts nested expressions into sequence of assignment statements

(define flatten-prog
  (lambda (e)
    (match e
      [(? fixnum?) (values e '() '())]
      [(? symbol?) (values e '() `(,e))]
      [`(read)
       (let ([store (gensym 'read)])
         (values  store `((assign ,store (read))) `(,store)))]
      [`(program ,es)
       (let-values ([(expr assigns vars) (flatten-prog es)])
         `(program ,(flatten vars) ,(append assigns `((return ,expr)))))]
      [`(let ([,x ,es]) ,b)
       (let-values ([(expr_es assigns_es vars_es) (flatten-prog es)]
                    [(expr_b assigns_b vars_b) (flatten-prog b)]
                    [(expr) (gensym 'temp)])
         (let ([assigns (append assigns_es `((assign ,x ,expr_es)) assigns_b)]
               [vars  (list vars_es vars_b)])
           (values expr_b assigns vars)))]
      [`(,op ,v1 ,v2)
       (let-values ([(expr_v1 assigns_v1 vars_v1) (flatten-prog v1)]
                    [(expr_v2 assigns_v2 vars_v2) (flatten-prog v2)]
                    [(expr) (gensym 'temp)])
         (values expr
                 (append assigns_v1 assigns_v2 `((assign ,expr (,op ,expr_v1 ,expr_v2))))
                 (append (list expr) vars_v1 vars_v2)))]
      [`(,op ,val)
       (letrec ([expr (gensym 'temp)]
                [vars (list expr)]
                [assigns `((assign ,expr ,e))])
         (values expr assigns vars))]
      [else (printf "~a\n" e)])))

(require "utilities.rkt"
         "uniquify.rkt")

(define prog (read-program "tests/R1_10.rkt"))

(flatten-prog ((uniquify '()) prog))
