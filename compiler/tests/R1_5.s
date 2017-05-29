	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	$1, %rcx
	addq	$2, %rcx
	movq	$1, %rbx
	addq	$2, %rbx
	addq	%rbx, %rcx
	movq	%rcx, %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$32, %rsp
	popq	%rbp
	retq
