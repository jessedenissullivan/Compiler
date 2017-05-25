	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	$1, -64(%rbp)
	addq	$2, -64(%rbp)
	movq	$1, -72(%rbp)
	addq	$2, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-72(%rbp), %rax
	addq	-56(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$80, %rsp
	popq	%rbp
	retq
