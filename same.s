
.data
MSG1:     .asciiz "civic"
MSG2:     .asciiz "wiliki"
MSG3:     .asciiz "aloha"
MSG_YES:  .asciiz "yes\n"
MSG_NO:   .asciiz "no\n"

.text   # This is for the program
.globl main             # This allows the label 'main' to be recognized

#----- display 'yes' or 'no' on console -----
# displays 'yes' if $a0=1, or 'no' otherwise
display_yes_or_no:
        li  $v0,4     # display 'yes'
	beq $a0,$0,display_no
        la  $a0,MSG_YES
        syscall
        jr  $ra
display_no:
        la  $a0,MSG_NO
        syscall
        jr   $ra

#----- msg_length(char msg[])-----
#  Returns the length of text message msg[] in register $v0
#  The base address of msg[] is passed through $a0, i.e., $a0->msg[]
msg_length:
        add  $v0,$0,$0     # length = 0
        move $t0,$a0       # $t0 -> beginning of msg
msg_length_loop:
        lbu  $t1,0($t0)
        beq  $t1,$0,msg_length_done
        addi $t0,$t0,1
        addi $v0,$v0,1
        j    msg_length_loop
msg_length_done:
        jr   $ra

#----- same(char msg1[], char msg2[]) -----
# This subroutine checks if msg1[] and msg2[] have the same length.
# It returns 1 in $v0 if they have the same length, and 0 otherwise
# The base addresses of msg1[] and msg2[] are passed through $a0 and $a1
#
# Rewrite this subroutine.  You may use the stack, and registers
# $t1,$t2,$t3,$s0,$s1

same:
	addi $sp,$sp,-4
	sw   $ra,0($sp)
	jal  msg_length
	move $t2,$v0
	move $a0,$a1
	jal msg_length
	move $t3,$v0
	lw   $ra,0($sp)
	addi $sp,$sp,4
	beq $t2,$t3,same_true
        li   $v0,0
	jr   $ra
same_true:
	li   $v0,1
        jr   $ra
#----- main() --------------------------------
main:
        la    $a0,MSG1
	la    $a1,MSG2
        jal   same
        move  $a0,$v0
	jal   display_yes_or_no

        la    $a0,MSG1
	la    $a1,MSG3
        jal   same
	move  $a0,$v0
	jal   display_yes_or_no

        li  $v0,10       # exit
        syscall
