	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$1, 0(%rbp)
	addq	$2, 0(%rbp)
	movq	0(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$16, %rsp
	popq	%rbp
	retq
