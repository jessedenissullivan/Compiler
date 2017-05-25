	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$176, %rsp
	movq	$3, -144(%rbp)
	addq	$6, -144(%rbp)
	movq	-144(%rbp), %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %rax
	movq	%rax, -152(%rbp)
	addq	$32, -152(%rbp)
	movq	-152(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$176, %rsp
	popq	%rbp
	retq
