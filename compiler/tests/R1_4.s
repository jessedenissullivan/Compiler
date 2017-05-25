	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	$1, -48(%rbp)
	addq	$2, -48(%rbp)
	movq	$1, -40(%rbp)
	movq	-48(%rbp), %rax
	addq	-40(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$64, %rsp
	popq	%rbp
	retq
