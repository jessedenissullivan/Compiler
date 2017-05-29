	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$1, %rcx
	addq	$2, %rcx
	movq	$1, %rbx
	addq	%rcx, %rbx
	movq	%rbx, %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$16, %rsp
	popq	%rbp
	retq
