	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	$3, %rbx
	addq	$6, %rbx
	addq	$32, %rbx
	movq	%rbx, %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$32, %rsp
	popq	%rbp
	retq
