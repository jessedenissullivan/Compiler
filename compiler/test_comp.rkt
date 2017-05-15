#lang racket

(require "utilities.rkt"
         "typecheck-R1.rkt"
         "uniquify.rkt"
         "flatten.rkt"
         "select-instr.rkt"
         "assign-homes.rkt"
         "patch-instr.rkt"
         "print-x86.rkt"
         "../interpreters/interp-R1.rkt")

(provide passes)

(define passes
  (list (list "Uniquify" (uniquify (make-hash)) interp-R1)
        (list "Flatten" flatten interp-R1)
        (list"Select-instructions" select-instr interp-R1)
        (list "Assign-homes" (assign-homes (list)) interp-R1)
        (list "Patch-instructions" patch-instr interp-R1)
        (list "Print-x86" print-x86 interp-R1)))

(define test_compiler
  (compiler-tests
   "Compiler"
   typecheck-R1
   passes
   "R0"
   '(1 2 3)))