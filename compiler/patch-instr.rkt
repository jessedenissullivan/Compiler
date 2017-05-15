#lang racket

(provide patch-instr)

; function for patch-instructions pass of compiler
; patches instructions that moves data b/w 2 stack locations
(define patch-instr
  (lambda (e)
    (match e
      [`(program ,vars ,exprs)
       (let ([asm (map patch-instr exprs)])
         `(program ,vars (,@(append* (list) asm))))]
      [`(movq ,src ,dest)
       `((movq ,src (reg rax))
         (movq (reg rax) ,dest))]
      [`(addq ,src ,dest)
       `((movq ,src (reg rax))
         (addq ,dest (reg rax))
         (movq (reg rax) ,dest))]
      [else (list e)]
      )))
