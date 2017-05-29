#lang racket

(provide uncover-live)

; helper function that takes an instruction line
; and the sequence of live-after lists
; and returns the list of variables live before the current line
(define (get-live live-after)
  (lambda (line)
    (match line
      [`(movq (,lhs_t ,lhs) (,rhs_t ,rhs))
       (let ([la (list->set (car live-after))]
             [read (if (eq? 'var lhs_t) (set lhs) (set))]
             [write (if (eq? 'var rhs_t) (set rhs) (set))])
         (set->list (set-union (set-subtract la write) read)))]
      [`(addq (,lhs_t ,lhs) (,rhs_t ,rhs))
       (letrec ([la (list->set (car live-after))]
                [read_l (if (eq? 'var lhs_t) (set lhs) (set))]
                [read_r (if (eq? 'var rhs_t) (set rhs) (set))]
                [read (set-union read_l read_r)])
         (set->list (set-union la read)))]
      [`(,op (,hs_t ,hs))
       (let ([la (list->set (car live-after))])
         (set->list (set-add la hs)))]
      [else (car live-after)]
      )))

; conver which vars are live when
; takes program after select-instr pass and adds node b/w
; vars and instrs nodes

; nodes is a sequence of lists where each list contains
; all vars live at the corrensponding line of the
; instrs choosen by the select-instr pass
(define uncover-live
  (lambda (e)
    (let ([live-afters '(())])
      (match e
        [`(program ,vars ,instrs)
         (for ([i (reverse instrs)])
           (set! live-afters
                 (append
                  `(,((get-live live-afters) i))
                  live-afters)))
         `(program ,vars ,(cdr live-afters) ,instrs)]
        [else (error 'uncover-live "program not recognized")]
        ))))

(define p '(program
            (temp37980 v37975 temp37981 x37977 temp37982 x37977 w37976 temp37984 z37979 temp37983)
            ((movq (int 1) (var v37975))
             (movq (int 46) (var w37976))
             (movq (var v37975) (var temp37980))
             (addq (int 7) (var temp37980))
             (movq (var temp37980) (var x37977))
             (movq (int 4) (var temp37981))
             (addq (var x37977) (var temp37981))
             (movq (var temp37981) (var y37978))
             (movq (var x37977) (var temp37982))
             (addq (var w37976) (var temp37982))
             (movq (var temp37982) (var z37979))
             (movq (var y37978) (var temp37983))
             (negq (var temp37983))
             (movq (var z37979) (var temp37984))
             (addq (var temp37983) (var temp37984))
             (movq (var temp37984) (reg rax))
             (retq))))