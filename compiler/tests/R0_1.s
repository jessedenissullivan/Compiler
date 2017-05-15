	.globl _main
_main:
	movq	$32, %rax
	movq	%rax, -8(%rbp)
	movq	$10, %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, 0(%rbp)
	movq	-8(%rbp), %rax
	addq	0(%rbp), %rax
	movq	%rax, 0(%rbp)

