#lang racket

(require "utilities.rkt"
         "flatten.rkt"
         "uniquify.rkt"
         "select-instr.rkt"
         "uncover-live.rkt"
         "build-interference.rkt")

(provide allocate-registers
         color-graph)

; takes a graph and returns the coloring of it's verticies s.t. no
; 2 adjacent nodes share a color
(define (color-graph i-graph)
  (let ([W (sort
            (hash-map i-graph (lambda (k v) `(,k ,(set-count v))))
            #:key last >)]
        [color (make-hash)]
        [satr (make-hash)]
        [max_c 0])
    (for ([i W])
      (letrec ([all_c (range max_c)]
               [poss_c (set->list
                        (set-subtract
                         (list->set all_c)
                         (hash-ref satr (car i) (set))))]
               [c (if (empty? poss_c) max_c (car poss_c))])
        (if (empty? poss_c) (set! max_c (+ max_c 1)) (void))
        (hash-set! color (car i) c)
        (for ([j (hash-ref i-graph (car i))]) 
          (hash-set! satr j (set-add (hash-ref satr j (set)) c)))))
    color))

; takes a program with a list of vars, interference graph of vars,
; and list of instructions and returns program that allocates regs
; s.t. program evals to same val.
(define allocate-registers
  (lambda (e)
    (match e
      [`(program ,vars ,i-graph ,instrs)
       (define var-coloring (color-graph vars i-graph))
       `(program ,vars ,i-graph ,instrs)]
      [else (error 'allocate-registers "Program not recognized")])))

(define prog (read-program "tests/R1_10.rkt"))
