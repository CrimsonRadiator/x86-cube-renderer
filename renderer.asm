global bresenham
global matrix_multiplication_3x3
global canvas

section .data
    align   16
    TRUE    equ 1
    FALSE   equ 0
    align   16
zero:       dd 0

section .text

;void bresenham(int x0, int y0, int x1, int y1)
;fills canvas array with 1s where pixel should be white
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

    add     rsp, 48             ;function epilogue
    pop     r11
    pop     r10
    pop     rdi     
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbp
    ret 

;void matrix_multiplication_3x3(float* C, float* B, float*A)
;multiplies AxB and stores result in C
matrix_multiplication_3x3:
    push    rbp                 ;function prologue
    mov     rbp, rsp
    push    rdx                 ;*A
    push    rsi                 ;*B
    push    rdi                 ;*C
    push    rcx
    sub     rsp, 48             ; sum
                                ;copy registers
    mov     r8, rdx             ;A 
    mov     r9, rsi             ;B
    mov     r10, rdi            ;C

    
    mov     rcx, 0              ;rcx=0
    mov     rax, 0              ;row counter/offset
.row_loop:
    mov     rbx, 0              ;column counter/offset
   
    mov     r8, rdx
    add     r8, rax 
.column_loop:
    mov     r9, rsi
    add     r9, rbx
    finit                       ;initialize FPU    
    fldz                        ;load 0 to s(0)
    fld     dword  [r8]                ;load element from A
    fld     dword  [r9]                ;load element from B
    fmul    st1                 ;st0=st0*st1 (c=b*a)
    fld     dword  [r8+4]              ;load second element from A
    fld     dword  [r9+12]             ;load second element from B
    fmul    st1
    fadd    st2, st0
    fld     dword  [r8+8]              ;load third element from A
    fld     dword  [r9+24]             ;load third element from B
    fmul    st1
    fadd    st4, st0
    fxch    st4
    
    fst     dword  [r10+rcx]
    add     rcx, 4
    
    add     rbx, 4
    cmp     rbx, 12
    jne     .column_loop
    add     rax, 12
    cmp     rax, 36
    jne     .row_loop
 
    add     rsp, 48             ;function epilogue
    pop     rcx
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rbp
    ret 

    
