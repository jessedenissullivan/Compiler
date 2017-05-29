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
         "uncover-live.rkt"
         "build-interference.rkt"
         "allocate-registers.rkt"
         "../interpreters/interp-R1.rkt")

(provide compile
         compile-C0
         compiler
         prog
         )



(define passes
  (list (list "Uniquify" (uniquify (make-hash)) (interp-R1 '()))
        (list "Flatten" flatten-prog (interp-R1 '()))
        (list "Select-instructions" select-instr (interp-R1 '()))
        (list "Uncover-live" uncover-live (interp-R1 '()))
        (list "Build-interference" build-interference (interp-R1 '()))
        (list "Allocate-registers" allocate-registers (interp-R1 '()))
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

(define test-reg-alloc
  (lambda (prog)
    (select-instr
     (compile-C0 prog))))

(define prog (read-program "tests/R1_13.rkt"))
(define p (compile-C0 prog))
;prog
;p
;(select-instr p)
;(uncover-live (select-instr p))
;(build-interference (uncover-live (select-instr p)))
(allocate-registers (build-interference (uncover-live (select-instr p))))
(patch-instr (allocate-registers (build-interference (uncover-live (select-instr p)))))

;(compiler-tests "compiler" typecheck-R1 passes "R1" '(1 2 3 4 5 6 7 8 9 10 11 12 13))