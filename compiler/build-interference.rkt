#lang racket

(require "utilities.rkt"
         "flatten.rkt"
         "select-instr.rkt"
         "uniquify.rkt"       
         "uncover-live.rkt"
         "select-instr.rkt")

(define prog (read-program "tests/R1_10.rkt"))
(define prog_test (uncover-live (select-instr (flatten-prog ((uniquify '()) prog)))))

(define build-interference
  (lambda (e)
    (match e
      [`(program ,vars ,live-afters ,instrs)
       (let ([i-graph (make-graph '())])
         (begin
           (for* ([i live-afters]
                  [j (combinations i 2)])
             (add-edge i-graph (first j) (last j)))
           `(program ,vars ,i-graph ,instrs)))]
      [else (error 'build-interference "program not recognized")])))


(display "The live-afters:\n")
(define la (third prog_test))
(pretty-print (third prog_test))
(newline)
(build-interference prog_test)