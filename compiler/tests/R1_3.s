	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	$1, -32(%rbp)
	addq	$2, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -24(%rbp)
	addq	$2, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$48, %rsp
	popq	%rbp
	retq
