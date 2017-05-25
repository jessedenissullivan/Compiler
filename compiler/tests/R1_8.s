	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	callq	_read_int
	movq	%rax, -136(%rbp)
	movq	$1, -128(%rbp)
	movq	-136(%rbp), %rax
	addq	-128(%rbp), %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$144, %rsp
	popq	%rbp
	retq
