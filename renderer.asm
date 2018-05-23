global bresenham
global canvas

section .data
    align   16
    TRUE    equ 1
    FALSE   equ 0

section .text

bresenham:
    push    rbp                 ;function prologue
    mov     rbp, rsp
    push    rcx                 ;y1
    push    rdx                 ;x1
    push    rsi                 ;y0
    push    rdi                 ;x0 
    push    r10
    push    r11
    sub     rsp, 48             ;steep, derror2, error2, dx, dy
  
    extern  canvas
    mov     QWORD [rbp-8], FALSE  ;steep = false
    mov     rax, rdi
    sub     rax, rdx            ;x0 - x1
    cmp     rax, 0
    jge     .no_abs_2
    neg     rax                 ;abs(x0 - x1)
.no_abs_2:
    mov     rbx, rsi
    sub     rbx, rcx            ;y0 - y1
    cmp     rbx, 0
    jge     .no_abs_3
    neg     rbx                 ;abs(y0-y1)
.no_abs_3:
    cmp     rax, rbx
    jge     .no_swap_1
    xchg    rsi, rdi
    xchg    rcx, rdx
    mov     QWORD[rbp-8], TRUE   ;steep = true
.no_swap_1:
    cmp     rdi, rdx
    jle     .no_swap_2
    xchg    rdi, rdx
    xchg    rsi, rcx
.no_swap_2:
    mov     rax, rdx 
    sub     rax, rdi
    mov     [rbp-8*4], rax      ;dx = x1-x0
    mov     rax, rcx
    sub     rax, rsi
    mov     [rbp-8*5], rax      ;dy = y1-y0
    cmp     rax, 0              ;abs(dy)
    jge     .no_abs_1
    neg     rax
.no_abs_1:  
    shl      rax, 1             ;abs(dy)*2
    mov     [rbp-8*2], rax      ;derror2 = abs(dy)*2
    mov     QWORD [rbp-8*3], 0  ;error2 = 0
    mov     r11, rsi            ;y = y0
    mov     r10, rdi            ;x = x0
    .loop:
    mov     rax, FALSE
    cmp     rax, [rbp-8]
    je     .no_steep           ;if(steep)
    mov     rax, r11            ;y
    shl     rax, 8              ;y*256 (HARDCODED SIZE)
    add     rax, r10            ;y*256+x
    mov     [canvas+rax], BYTE 1
    jmp     .end_steep
.no_steep:
    mov    rax, r10             ;x
    shl    rax, 8               ;x*256 (HARDCODED SIZE)
    add    rax, r11             ;x*256+y
    mov    [canvas+rax], BYTE 1
.end_steep:
    mov     rax, [rbp-8*2]
    add     [rbp-8*3], rax      ;error2+=derror2
    mov     rax,  [rbp-8*3]
    cmp     rax, [rbp-8*4]      ;if(error2 > dx)
    jle     .next_loop
    cmp     rcx, rsi
    jle     .minus_y
    inc     r11                 ;y=y+1
    jmp     .modify_error2
.minus_y:
    dec     r11                 ;y=y-1
.modify_error2:
    mov     rax, [rbp-8*4]      ;dx
    shl     rax, 1              ;dx*2
    sub     [rbp-8*3], rax      ;error2-=dx*2
.next_loop:
    inc     r10                 ;x=x+1
    cmp     r10, rdx
    jle     .loop

  add     rsp, 48 ;function epilogue
;    mov     rsp, rbp
  pop     r11
  pop     r10
  pop     rdi     
  pop     rsi
  pop     rdx
  pop     rcx
  pop     rbp
  ret 
