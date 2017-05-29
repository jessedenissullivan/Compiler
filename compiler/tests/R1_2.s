	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$2, %rbx
	negq	%rbx
	movq	$1, %rcx
	addq	%rbx, %rcx
	movq	%rcx, %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$16, %rsp
	popq	%rbp
	retq
