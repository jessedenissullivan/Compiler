	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$432, %rsp
	movq	$10, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	addq	$12, %rbx
	movq	%rbx, %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$432, %rsp
	popq	%rbp
	retq
