.data 
    n: .long 0
    m: .long 0
    a: .long 0
    nx3: .long 0
    contor: .long 0
    err: .long -1
    elem: .space 4
    chDelim: .asciz " "
    res: .space 100
    sir: .space 400
    v: .space 400
    fix: .space 400             
    frec: .space 400
    formatScanf: .asciz "%[^\n]s"
    formatPrintf: .asciz "%d "
    formatPrintfexit: .asciz "\n"
.text

vector_vid:
    pushl %ebp
    movl %esp, %ebp
    pushl %edi
    movl 8(%ebp),%edi
    movl 12(%ebp),%edx
    xorl %ecx,%ecx

et_for_vid:
    movl $0,(%edi,%ecx,4)
    incl %ecx
    cmp %ecx,%edx
    je vid_exit

    jmp et_for_vid

vid_exit:
    popl %edi
    popl %ebp
    ret
    
.global main

main:
    pushl $sir
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

et_strtok:
    pushl $chDelim
	pushl $sir
	call strtok 
	popl %ebx
	popl %ebx
	
	movl %eax, res

    pushl res
    call atoi
    popl %ebx

    movl %eax,n

et_for:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

	cmp $0, %eax
    je et_fix

    movl %eax, res
	
    pushl res
    call atoi
    popl %ebx

    cmp $0,m
    je et_m

    cmp $0,m
    jne et_elem

    jmp et_for	

 et_m:
    movl %eax,m
    jmp et_for

et_elem:
    movl $v,%edi
    movl contor,%ecx

    movl %eax,(%edi,%ecx,4)

    incl contor
    
    jmp et_for

et_fix:
    movl $3,%eax
    mull n
    movl %eax,nx3

    pushl nx3
    pushl $fix
    call vector_vid
    popl %ebx
    popl %ebx

    movl $v,%edi
    movl $fix,%esi
    movl nx3,%ecx

    xorl %eax,%eax

et_fix_cmp:
    cmp $0,(%edi,%eax,4)
    jne et_fixcont

    incl %eax

    cmp %ecx,%eax
    je et_0_1

    jmp et_fix_cmp

et_fixcont: 
    movl $1,(%esi,%eax,4)
    incl %eax

    cmp %ecx,%eax
    je et_0_1

    jmp et_fix_cmp

et_0_1:
    movl $v,%edi
    movl $0,%ecx

et_0_1_cont:
    cmp $0,(%edi,%ecx,4)
    je et_1

    cmp %ecx,nx3
    je et_backtrack

    incl %ecx
    jmp et_0_1_cont

et_1:
    movl $1,(%edi,%ecx,4)

    cmp %ecx,nx3
    je et_backtrack

    incl %ecx
    jmp et_0_1_cont

et_backtrack:
    movl nx3,%ebx
    decl %ebx
    movl $fix,%edi
    movl $v,%esi

et_cont:
    cmp $1,(%edi,%ebx,4)
    je et_contreset

    jmp bt_cont

et_contreset:
    decl %ebx
    jmp et_cont

bt_cont:
    cmp err,%ebx
    je et_err

    incl (%esi,%ebx,4)

    movl n,%edx
    cmp %edx,(%esi,%ebx,4)
    jg et_reset
    jmp verificare

et_reset:
    movl $1,(%esi,%ebx,4)
    decl %ebx
    jmp et_cont


verificare:

et_frec:
    movl n,%eax
    incl %eax

    pushl %eax
    pushl $frec
    call vector_vid
    popl %ebx
    popl %ebx

    movl $v,%edi
    movl $frec,%esi
    xorl %eax,%eax
    movl nx3,%ecx

et_frec_for:
    movl (%edi,%eax,4),%ebx
    incl (%esi,%ebx,4)
    incl %eax

    cmp %ecx,%eax
    je et_vf_frec

    jmp et_frec_for

et_vf_frec:
    xorl %ebx,%ebx

et_vf_frec_cont:
    incl %ebx
    cmp $3,(%esi,%ebx,4)
    jne et_backtrack

    cmp n,%ebx
    je et_vf_m

    jmp et_vf_frec_cont

et_vf_m:
    movl m,%ecx
    movl nx3,%edx
    xorl %ebx,%ebx     
                        //ebx=i
    movl $1,%eax
    jmp for_j

for_i:
    incl %ebx
    cmp %ebx,%edx
    je et_solutie
    movl %ebx,%eax      
                        //eax=j
    incl %eax
    movl m,%ecx
    addl %ebx,%ecx

for_j: 
    pushl %ecx
    pushl %edx

    movl (%edi,%eax,4),%ecx
    movl (%edi,%ebx,4),%edx
    cmp %edx,%ecx
    je et_et

    popl %edx
    popl %ecx

    cmp %ecx,%eax
    je for_i    

    cmp %edx,%eax
    je for_i 

    incl %eax

    jmp for_j

et_solutie:
    movl $0,contor

et_print:
    movl $v,%edi
    movl nx3,%edx
    movl contor,%ecx
    cmp %ecx,%edx
    je exit
    pushl (%edi,%ecx,4)
    pushl $formatPrintf
	call printf 
	popl %ebx
    popl %ebx
    incl contor
    jmp et_print

exit:
    pushl $formatPrintfexit
	call printf 
    popl %ebx

    movl $1,%eax
    xorl %ebx,%ebx
    int $0x80

et_et:
    popl %edx
    popl %ecx
    jmp et_backtrack

et_err:
    pushl err
    pushl $formatPrintf
	call printf 
	popl %ebx
    popl %ebx
    jmp exit
