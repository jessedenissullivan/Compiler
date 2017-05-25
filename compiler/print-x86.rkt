#lang racket

(provide print-x86)

; print out x86 instructions
(define print-x86
  (lambda (e)
    (match e
      [`(program ,framesize ,exprs)
       (define label "")
       (define prefix
         (if (equal? (system-type 'os) 'macosx)
             "_"
             ""))
       (define global (format "\t.globl ~amain\n" prefix))
       (define main_label (format "~amain:\n" prefix))
       (define instrs (map print-x86 exprs))
       (define preamble (format "\tpushq\t%rbp\n\tmovq\t%rsp, %rbp\n\tsubq\t$~a, %rsp\n" framesize))
       (define postamble (format "\tmovq\t$0, %rax\n\taddq\t$~a, %rsp\n\tpopq\t%rbp\n\tretq" framesize))       
       (define output (string-append global main_label preamble))
       (set! output (string-append* output instrs))
       (string-append output postamble)]
      [`(movq ,src ,dest)
       (format "\tmovq\t~a, ~a\n" (print-x86 src) (print-x86 dest))]
      [`(addq ,src ,dest)
       (format "\taddq\t~a, ~a\n" (print-x86 src) (print-x86 dest))]
      [`(negq ,reg)
       (format "\tnegq\t~a\n" (print-x86 reg))]
      [`(retq)
       (let ([prefix (if (equal? (system-type 'os) 'macosx)
                         "_"
                         "")])
         (format "\tmovq\t%rax, %rdi\n\tcallq\t~awrite_int\n" prefix))]
      [`(callq ,fxn)
       (let ([prefix (if (equal? (system-type 'os) 'macosx)
                         "_"
                         "")])
         (format "\tcallq\t~a~a\n" prefix fxn))]
      [`(int ,val)
       (format "$~a" val)]
      [`(reg ,r)
       (format "%~a" r)]
      [`(deref ,reg ,offset)
       (format "~a(~a)" offset (print-x86 `(reg ,reg)))]
      )))  