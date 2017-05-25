#lang racket

(require "compiler.rkt")

(define test-comp
  (compiler-tests
   "Compiler"
   typecheck-R1
   '(("Uniquify" uniquify interp-R1))
   "R0"
   '(1 2 3)))
