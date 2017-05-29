	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	$1, %rdx
	movq	$46, %rbx
	addq	$7, %rdx
	movq	$4, %rcx
	addq	%rdx, %rcx
	addq	%rbx, %rdx
	movq	%rdx, %rbx
	movq	%rcx, %rdx
	negq	%rdx
	addq	%rdx, %rbx
	movq	%rbx, %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$80, %rsp
	popq	%rbp
	retq
