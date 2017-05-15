#lang racket

(require "uniquify.rkt"
         "flatten.rkt"
         "select-instr.rkt"
         "assign-homes.rkt"
         "patch-instr.rkt"
         "print-x86.rkt"
         "utilities.rkt"
         "typecheck-R1.rkt"
         "typecheck-R2.rkt"
         "../interpreters/interp-R1.rkt"
         "test_comp.rkt")

(provide compile
         compile-C0
         p)

(define compile-C0
  (lambda (prog)
    (flatten
     ((uniquify (make-hash))
     prog))))

(define compiler (compile-file typecheck-R1 passes))
(compiler "tests/R0_1.rkt")

(define compile
  (lambda (prog)
    (print-x86
     (patch-instr
      ((assign-homes (list))
       (select-instr
        (compile-C0 prog)))))))

(define p (read-program "./tests/R0_1.rkt"))
;(compile-C0 p)