.data
fmt_int: .asciz "%d "
fmt_nl:  .asciz "\n"

.text
.global main
#a0=argc
#a1=argv.  where argv[0]=program name all other are string ka numbers
#using call atoi u can chnage string into a number
#n=argc-1
#s0 = arr base
#s1 = n
#s2 = result base
#s3 = stack base
#s4 = saved argc
#s5 = saved argv
#s6 = top
#s7=index

main:
    addi sp,sp,-16;
    sd x1,8(sp);

    addi s4,a0,0;
    addi s5,a1,0;
    addi s1,s4,-1;

    slli x10,s1,2;
    call malloc; #arr
    addi s0,x10,0;

    slli x10,s1,2;
    call malloc; #result
    addi s2,x10,0;

    slli x10,s1,2;
    call malloc; #stack 
    addi s3,x10,0;

    call read_arr;
    call initialize_result;
    addi s6,x0,-1; #set top to -1

    j main_loop;
    

read_arr:
    addi sp,sp,-16;
    sd x1,8(sp);

    addi s7,x0,0;

properarrloop:
    bge s7,s1,reading_done;

    slli t0,s7,3;
    add t1,s5,t0;
    ld x10,8(t1);
    call atoi;

    slli t2,s7,2;
    add t3,s0,t2;
    sw x10,0(t3);

    addi s7,s7,1;
    j properarrloop;

reading_done:
    ld x1,8(sp);
    addi sp,sp,16;
    ret;


initialize_result:
    addi s7,x0,0;
    addi t0,x0,-1;

loop1:
    bge s7,s1,ini_done;
    slli t1,s7,2;
    add t2,s2,t1;
    sw t0,0(t2);
    addi s7,s7,1;
    j loop1;

ini_done:
    ret;


main_loop:
    addi s7,s1,-1;

outer_loop:
    blt s7,x0,after_main_loop;

    slli t0,s7,2;
    add t1,s0,t0;
    lw t2,0(t1);

while_loop:
    addi t3,x0,-1;
    beq s6,t3,while_done;

    slli t0,s6,2;
    add t1,s3,t0;
    lw t4,0(t1);

    slli t0,t4,2;
    add t1,s0,t0;
    lw t5,0(t1);

    bgt t5,t2,while_done;

    addi s6,s6,-1;
    j while_loop;

while_done:
    addi t3,x0,-1;
    beq s6,t3,skip_store;

    slli t0,s6,2;
    add t1,s3,t0;
    lw t4,0(t1);

    slli t0,s7,2;
    add t1,s2,t0;
    sw t4,0(t1);

skip_store:
    addi s6,s6,1;
    slli t0,s6,2;
    add t1,s3,t0;
    sw s7,0(t1);

    addi s7,s7,-1;
    j outer_loop;


after_main_loop:
    addi s7,x0,0;

print_loop:
    bge s7,s1,print_done;

    slli t0,s7,2;
    add t1,s2,t0;
    lw t2,0(t1);

    la a0,fmt_int;
    addi a1,t2,0;
    call printf;

    addi s7,s7,1;
    j print_loop;

print_done:
    la a0,fmt_nl;
    call printf;

done:
    ld x1,8(sp);
    addi sp,sp,16;
    ret;
