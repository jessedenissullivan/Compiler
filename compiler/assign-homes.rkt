#lang racket

(provide assign-homes)

; function for assign-homes pass of compiler
; assigns all variables to stack locations
; var_locs is a list of numbers corresponding to the location on the stack of a variable
(define (assign-homes var_locs)
  (lambda (e)
    (match e
      [`(program ,vars ,exprs)
       (set! var_locs (append var_locs vars))
       (let ([asm (map (assign-homes var_locs) exprs)])
         `(program (,vars) (,@asm)))]
      [`(negq ,val)
       (if (equal? (system-type 'os) 'macosx)
           (define framesize 16)
           (define framesize 8))
       (let-values ([(op expr) ((assign-homes var_locs) val)])
         `(negq (deref rbp ,(- (* framesize (index-of var_locs expr))))))]
      [`(,op ,src ,dest)
       (if (equal? (system-type 'os) 'macosx)
           (define framesize 16)
           (define framesize 8))
       (let-values ([(type_src sym_src) ((assign-homes var_locs) src)]
                    [(type_dest sym_dest) ((assign-homes var_locs) dest)])
         (cond
           [(and (eq? 'var type_src)
                 (eq? 'var type_dest))
            `(,op (deref rbp ,(- (* framesize (index-of var_locs sym_src)))) (deref rbp ,(- (* 8 (index-of var_locs sym_dest)))))]
           [(eq? 'var type_src)
            `(,op (deref rbp ,(- (* framesize (index-of var_locs sym_src)))) ,dest)]
           [(eq? 'var type_dest)
            `(,op ,src (deref rbp ,(- (* framesize (index-of var_locs sym_dest)))))]))]
      [`(,type ,sym)
       (values type sym)]
      [`(retq) e]
      )))
