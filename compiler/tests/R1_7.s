	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	$10, %rbx
	movq	$20, %rcx
	addq	$12, %rcx
	addq	%rbx, %rcx
	movq	%rcx, %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$32, %rsp
	popq	%rbp
	retq
