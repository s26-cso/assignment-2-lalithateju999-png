    .text
    .globl make_node
    .globl insert
    .globl get
    .globl getAtMost

make_node:
    addi sp,sp,-16;
    sd x10,0(sp);
    sd x1, 8(sp);

    li x10,24;
    call malloc;

    ld x6,0(sp);
    ld x1,8(sp);
    addi sp ,sp,16;
    
    sw x6,0(x10);
    sd x0,8(x10);
    sd x0,16(x10);

    ret;


insert_go_left:

    addi sp,sp,-32;
    sd x1,16(sp);
    sd x10,8(sp);
    sd x11,0(sp);

    ld x6,8(x10);
    addi x10,x6,0;
    call insert;

    addi x7,x10,0;

    ld x11,0(sp);
    ld x10,8(sp);
    ld x1,16(sp);
    addi sp,sp,32;

    sd x7,8(x10);

    ret;



insert_go_right:

    addi sp,sp,-32;
    sd x1,16(sp);
    sd x10,8(sp);
    sd x11,0(sp);

    ld x6,16(x10);
    addi x10,x6,0;
    call insert;

    addi x7,x10,0;

    ld x11,0(sp);
    ld x10,8(sp);
    ld x1,16(sp);
    addi sp,sp,32;

    sd x7,16(x10);

    ret;



insert_found:
    addi sp,sp,-16;
    sd x1,8(sp);

    addi x10,x11,0;
    call make_node;

    ld x1,8(sp);
    addi sp,sp,16;

    ret;

insert:
    beq x10,x0,insert_found;
    lw x6,0(x10);

    blt x11,x6,insert_go_left;
    bgt x11,x6,insert_go_right;

    ret;


get_go_left:
    addi sp,sp,-16;
    sd x1,8(sp);
    ld x6,8(x10);
    addi x10,x6,0;

    call get;

    ld x1,8(sp);
    addi sp,sp,16;

    ret;



get_go_right:
    addi sp,sp,-16;
    sd x1,8(sp);

    ld x6,16(x10);
    addi x10,x6,0;

    call get;

    ld x1,8(sp);
    addi sp,sp,16;

    ret;


get_found_null:
    addi x10,x0,0; 
    ret;

get_found:
    ret;

get:
    beq x10,x0,get_found_null;
    lw x6,0(x10);
    beq x11,x6,get_found;
    
    blt x11,x6,get_go_left;
    bgt x11,x6,get_go_right;

    ret;


get_at_most_left:
    addi sp,sp,-16;
    sd x1,8(sp);

    ld x7,8(x10);
    addi x10,x7,0;

    call getAtMost_rec;

    ld x1,8(sp);
    addi sp,sp,16;

    ret;
get_at_most_right:
    addi sp,sp,-16;
    sd x1,8(sp);

    lw x6,0(x10);
    addi x12,x6,0;
    ld x7,16(x10);
    addi x10,x7,0;


    call getAtMost_rec;

    ld x1,8(sp);
    addi sp,sp,16;
    ret;

nullthing:

    addi x10,x0,-1;

    ret;


get_at_most_null:

    addi x7,x0,-1;
    beq x12,x7,nullthing;
    addi x10,x12,0;

    ret;


get_at_most_ans:

    addi x10,x11,0;

    ret;


getAtMost_rec:

    beq x10,x0,get_at_most_null;
    lw x6,0(x10);
    beq x6,x11,get_at_most_ans;

    bgt x6,x11,get_at_most_left;
    blt x6,x11,get_at_most_right;


getAtMost:
    addi sp,sp,-16;
    sd x1,8(sp);

    addi x12,x0,-1;
    addi x6,x10,0;
    addi x10,x11,0;
    addi x11,x6,0;

    call getAtMost_rec;

    ld x1,8(sp);
    addi sp,sp,16;

    ret;
