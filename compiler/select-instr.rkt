#lang racket

(provide select-instr)

; function for select instructions pass
; introduces x86 instructions
(define select-instr
  (lambda (e)
    (match e
      [`(program ,vars ,expr)  ; if program, map all expressions to appropriate asm instrs
       (let ([asm (append* (list) (map select-instr expr))])
         `(program ,vars (,@asm)))]
      [`(assign ,lhs (read)) `((callq read_int)
                               (movq (reg rax) (var ,lhs)))]
      [`(assign ,lhs ,rhs)   ; if assign statement
       (cond
         [(symbol? rhs) `((movq (var ,rhs) ,(select-instr lhs)))]
         [(number? rhs) `((movq (int ,rhs) ,(select-instr lhs)))]
         [(eq? 3 (length rhs))
          (let-values ([(op r_lhs r_rhs) (select-instr rhs)])
            `((movq ,(select-instr r_lhs) ,(select-instr lhs))
              (addq ,(select-instr r_rhs) ,(select-instr lhs))))]
         [(eq? 2 (length rhs))
          (let-values ([(op r_val) (select-instr rhs)])
            `((movq ,(select-instr r_val) ,(select-instr lhs))
              (negq ,(select-instr lhs))))])]
      [`(return ,ret_val) (let ([ret `((movq (var ,ret_val) (reg rax)))])
                            (append ret '((retq))))]
      [`(,op ,lhs ,rhs) (values op lhs rhs)]
      [`(,op ,val) (values op val)]
      [(? symbol?) `(var ,e)]
      [(? number?) `(int ,e)]
      )))