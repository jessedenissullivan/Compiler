#lang racket

(require "utilities.rkt")

(provide build-interference)

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