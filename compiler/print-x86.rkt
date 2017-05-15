#lang racket

(provide print-x86)

; print out x86 instructions
(define print-x86
  (lambda (e)
    (match e
      [`(program ,vars ,exprs)
       (define label (format "\t.globl _main\n"))
       (if (equal? (system-type 'os) 'macosx)
           (set! label (string-append label "_main:"))
           (set! label (string-append label "main:")))
       (define prog (format "~a\n" label))
       (define instrs (map print-x86 exprs))
       (string-append* prog instrs)]
      [`(movq ,src ,dest)
       (format "\tmovq\t~a, ~a\n" (print-x86 src) (print-x86 dest))]
      [`(addq ,src ,dest)
       (format "\taddq\t~a, ~a\n" (print-x86 src) (print-x86 dest))]
      [`(negq ,reg)
       (format "\tnegq\t~a" (print-x86 reg))]
      [`(retq)
       (format "\tretq")]
      [`(int ,val)
       (format "$~a" val)]
      [`(reg ,r)
       (format "%~a" r)]
      [`(deref ,reg ,offset)
       (format "~a(~a)" offset (print-x86 `(reg ,reg)))]
      )))  
