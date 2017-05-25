	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	$2, -16(%rbp)
	negq	-16(%rbp)
	movq	$1, -8(%rbp)
	movq	-16(%rbp), %rax
	addq	-8(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$32, %rsp
	popq	%rbp
	retq
