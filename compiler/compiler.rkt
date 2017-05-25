#lang racket

(require "uniquify.rkt"
         "flatten.rkt"
         "select-instr.rkt"
         "assign-homes.rkt"
         "patch-instr.rkt"
         "print-x86.rkt"         
         "typecheck-R1.rkt"
         "typecheck-R2.rkt"
         "utilities.rkt"
         "../interpreters/interp-R1.rkt")

(provide compile
         compile-C0
         compiler)

(define passes
  (list (list "Uniquify" (uniquify (make-hash)) (interp-R1 '()))
        (list "Flatten" flatten-prog (interp-R1 '()))
        (list "Select-instructions" select-instr (interp-R1 '()))
        (list "Assign-homes" (assign-homes (list)) (interp-R1 '()))
        (list "Patch-instructions" patch-instr (interp-R1 '()))
        (list "Print-x86" print-x86 (interp-R1 '()))))

(define compiler (compile-file typecheck-R1 passes))

(define compile-C0
  (lambda (prog)
    (flatten-prog
     ((uniquify '())
      prog))))

(define compile
  (lambda (prog)
    (print-x86
     (patch-instr
      ((assign-homes (list))
       (select-instr
        (compile-C0 prog)))))))

(define prog (read-program "tests/R1_6.rkt"))
;(compile-C0 prog)
;(printf (compile prog))

(compiler-tests
 "compiler"
 typecheck-R1
 passes
 "R1"
 '(1 2 3 4 5 6 7 8 9))