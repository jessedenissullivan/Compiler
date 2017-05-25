#lang racket

(provide patch-instr)

; function for patch-instructions pass of compiler
; patches instructions that moves data b/w 2 stack locations
(define patch-instr
  (lambda (e)
    (match e
      [`(program ,framesize ,exprs)
       (define asm (map patch-instr exprs))
       `(program ,framesize (,@(append* asm)))]
      [`(deref ,reg ,offset) 'deref]
      [`(var ,name) 'var]
      [`(reg ,reg) 'reg]
      [`(int ,val) 'int]
      [`(movq ,src ,dest)
       (let ([src_t (patch-instr src)]
             [dest_t (patch-instr dest)])
         (if (and (eq? src_t 'deref) (eq? dest_t 'deref))
             `((movq ,src (reg rax))
               (movq (reg rax) ,dest))
             `(,e)))]
      [`(addq ,src ,dest)
       (let ([src_t (patch-instr src)]
             [dest_t (patch-instr dest)])
         (if (and (eq? src_t 'deref) (eq? dest_t 'deref))
             `((movq ,src (reg rax))
               (addq ,dest (reg rax))
               (movq (reg rax) ,dest))
             `(,e)))]
      [else `(,e)]
      )))