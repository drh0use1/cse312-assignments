.data
program1:   .asciiz "asm-files/BinarySearch.asm"
program2:   .asciiz "asm-files/LinearSearch.asm"
program3:   .asciiz "asm-files/Collatz.asm"
msg4:       .asciiz "waiting for childs...\n"

.text

main:   li $t0, 10   # will be loaded 10 times.
        li $v0, 22
        syscall
        beqz $v0, p1 # $v0 == 0
        addi $v0, $v0, -1
        beqz $v0, p2 # $v0 == 1
        addi $v0, $v0, -1
        beqz $v0, p3 # v0 == 2

p1:     addi $t0, $t0, -1
        li $v0, 18
        syscall
        bnez $v0, cont1 # parent continues to forking.
        la $a0, program1
        li $v0, 20      # fork and execve #1
        syscall

cont1:  beqz $t0, loop
        j p1    # continue.

p2:     addi $t0, $t0, -1
        li $v0, 18
        syscall
        bnez $v0, cont2 # parent continues to forking.
        la $a0, program2
        li $v0, 20      # fork and execve #1
        syscall

cont2:  beqz $t0, loop
        j p2    # continue.

p3:     addi $t0, $t0, -1
        li $v0, 18
        syscall
        bnez $v0, cont3 # parent continues to forking.
        la $a0, program3
        li $v0, 20      # fork and execve #1
        syscall

cont3:  beqz $t0, loop
        j p3    # continue.

    # wait for all child process here.
loop:   li $v0, 4       # syscall 4 (print_str)
        la $a0, msg4     # argument: string
        syscall
        li $a0, 0      # wait for any childprocess.
        li $v0, 19
        syscall
        beqz $v0, loop  # $v0 == 0, child is still running.
        bgtz $v0, loop  # $v0> 0 one child has terminated, continue waiting.

exit:	li $v0, 21
    	syscall