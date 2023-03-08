.data
    nr: .long 0
    x: .space 4
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d\n"



.text
apel:
    pushl %ebp
    movl %esp, %ebp
    pushl %edi
    pushl %ebx
    movl 8(%ebp),%edi

    xorl %ecx,%ecx

cont:
    xorl %edx,%edx
    cmp $1,%edi
    je apel_exit

    movl %edi,%eax
    movl $2,%ebx
    divl %ebx

    cmp $1,%edx
    je impar

    jmp par

par:

    incl %ecx
    movl %edi,%eax
    movl $2,%ebx
    divl %ebx

    movl %eax,%edi

    jmp cont


impar:
    incl %ecx
    movl %edi,%eax
    movl $3,%ebx
    mull %ebx
    incl %eax
    movl %eax,%edi

    jmp cont


apel_exit:
    movl %ecx,nr
    popl %ebx
    popl %edi
    popl %ebp
    ret


.global main



main:

    pushl $x
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

    pushl x
    call apel
    popl %ebx


    pushl nr
    pushl $formatPrintf
	call printf 
	popl %ebx
    popl %ebx

exit:
    movl $1,%eax
    xorl %ebx,%ebx
    int $0x80
