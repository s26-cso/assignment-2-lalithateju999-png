.section .data
filename: .string "input.txt"
mode: .string "r"
is_palindrome: .string "Yes"
is_not_palindrome: .string "No"

.section .text
.globl main

main:       
    addi sp,sp,-48;
    
    sd ra,40(sp);
    sd s0,32(sp);
    sd s1,24(sp);
    sd s2,16(sp);
    sd s3,8(sp);
    sd s4,0(sp);

opening_file:
    la a0,filename ;    # load address of file name
    la a1,mode;        # load read mode
    jal ra,fopen;
    add s0,a0,zero;    # store file pointer in s0
    beq s0, zero, exit;

access_last_ch:

    add a0,s0,zero;    # pass file pointer
    li a1,0;            # offset = 0
    li a2,2;            # move relative to end (SEEK_END)
    jal ra,fseek;       # position pointer at file end

    add a0,s0,zero;
    jal ra,ftell;       # retrieve file size
    beq a0,zero,is_palin;   # empty file → palindrome
    addi s2,a0,-1;     # set right index = length - 1

    add a0,s0,zero;
    li a1,0;
    li a2,0;           # move relative to beginning (SEEK_SET)
    jal ra,fseek;       # reset pointer to start
    li s1,0;            # left index starts at 0

check_newline:

    add a0,s0,zero;
    add a1,s2,zero;
    li a2,0;
    jal ra,fseek;       # jump to last character position

    add a0,s0,zero;
    jal ra,fgetc;       # fetch character at end
    
    li t0,10;           # ASCII value of newline
    bne a0,t0,comparison_loop;  # if not newline, continue
    addi s2,s2,-1;     # if newline, ignore it by shifting left

comparison_loop:

    bgt s1,s2,is_palin; # pointers crossed → palindrome confirmed

    add a0,s0,zero;
    add a1,s1,zero;
    li a2,0;
    jal ra,fseek;       # move to left index

    add a0,s0,zero;
    jal ra,fgetc;
    add s3,a0,zero;    # store left character

    add a0,s0,zero;
    add a1,s2,zero;
    li a2,0;
    jal ra,fseek;       # move to right index

    add a0,s0,zero;
    jal ra,fgetc;
    add s4,a0,zero;   # store right character

    bne s3,s4,is_not_palin;  # mismatch → not palindrome

    addi s1,s1,1;      # move left index forward
    addi s2,s2,-1;     # move right index backward
    beq zero,zero,comparison_loop;

is_palin:
    la a0,is_palindrome;
    jal ra,puts;
    beq zero,zero,prog_end;

is_not_palin:
    la a0,is_not_palindrome;
    jal ra,puts;
    beq zero,zero,prog_end;

prog_end:
    add a0,s0,zero;
    jal ra,fclose;     # close the file

    ld s4,0(sp);
    ld s3,8(sp);
    ld s2,16(sp);
    ld s1,24(sp);
    ld s0,32(sp);
    ld ra,40(sp);

    addi sp,sp,48;

    li a0,0;
    ret;
    
exit:

    ld s4,0(sp);
    ld s3,8(sp);
    ld s2,16(sp);
    ld s1,24(sp);
    ld s0,32(sp);
    ld ra,40(sp);

    addi sp,sp,48;

    li a0,0;
    ret;
