#lang racket

(provide select-instr)

; function for select instructions pass
; introduces x86 instructions
(define select-instr
  (lambda (e)
    (match e
      [`(program ,vars ,expr ,ret)  ; if program, map all expressions to appropriate asm instrs
       (let ([asm (append* (list) (map select-instr expr))])
         `(program ,vars (,@asm)))]
      [(? symbol?) `(var ,e)]
      [(? number?) `(int ,e)]
      [`(assign ,lhs ,rhs)   ; if assign statement
       (cond
         [(and (symbol? lhs)
               (symbol? rhs))
          `((movq (var ,rhs) (var ,lhs)))]
         [(and (symbol? lhs)
               (number? rhs))
          `((movq (int ,rhs) (var ,lhs)))] ; if left is var and right is num, map movq instr
         [(and (symbol? lhs)
               (not (number? rhs)))  ; if left is symbol and right is expr
          (if (eq? 2 (length rhs))  ; if expr on right is unary op
              (let-values ([(op val) (select-instr rhs)])
                (let ([retr `((movq ,(select-instr val) (var ,lhs)))])
                  (cond
                    [(eq? op '-) (append retr `((negq (var ,lhs))))]
                    [(eq? op '+) (retr)]
                    )))
              (let-values ([(op lhs_expr rhs_expr) (select-instr rhs)])  ; else if expr on right is binary op, break up expr
                (let ([retr `((movq ,(select-instr lhs_expr) (var ,lhs)))])  ; move left of expr into var
                  (cond 
                    [(eq? op '+)           ; if +, addq remaining 
                     (append retr `((addq ,(select-instr rhs_expr) (var ,lhs))))]
                    [(eq? op '-)
                     (append retr `((subq ,(select-instr rhs_expr) (var ,lhs))))]
                    ))))]
         [else (printf "hi")])]
      [`(return ,ret_val) (let ([ret `((movq (var ,ret_val) (reg %rax)))])
                            (append ret '((retq))))]
      [`(,op ,lhs ,rhs) (values op lhs rhs)]
      [`(,op ,val) (values op val)])))