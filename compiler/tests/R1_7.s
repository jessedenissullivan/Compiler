	.globl _main
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	$10, -120(%rbp)
	movq	$20, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	%rax, -104(%rbp)
	addq	$12, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-120(%rbp), %rax
	addq	-96(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	callq	_write_int
	movq	$0, %rax
	addq	$128, %rsp
	popq	%rbp
	retq
