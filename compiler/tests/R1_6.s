	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$96, %rsp
	movq	$10, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, -80(%rbp)
	addq	$32, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$96, %rsp
	popq	%rbp
	retq
