global bresenham
global matrix_multiplication_3x3
global vector_matrix_multiplication_4x4
global vector_matrix_multiplication_3x3
global fill_Mrx
global fill_Mry
global fill_Mrz
global fill_Projection
global screen_coords
global fpu_test

global canvas
global MViewPort
global MProjection
global MRotation

section .data
    align   16
    TRUE    equ 1
    FALSE   equ 0
    align   16

section .bss
    tmp_matrix: resb 64
    tmp_vector: resb 16
    tmp_vector2: resb 16
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

;void  vector_matrix_multiplication_4x4(float* R, float* M, float* V)
;credits: drizz @ masmforum.com
;         whoever taught INF5063 at University of Oslo in 2015
;         (probably Hakon Kvale Stensland)
;         thanks guys!
vector_matrix_multiplication_4x4:
    push    rbp                 ;function prologue
    mov     rbp, rsp
    push    rdx                 ;*V
    push    rsi                 ;*M
    push    rdi                 ;*R
    push    rcx
 
  
    movups  xmm4, [rsi]         ;first row
    movups  xmm5, [rsi + 0x10]  ;second
    movups  xmm6, [rsi + 0x20]  ;third
    movups  xmm7, [rsi + 0x30]  ;fourth
    
    movdqa      xmm0, xmm6		  ; 9 10 11 12
    movdqa      xmm1, xmm6	  	; 9 10 11 12
                             	  ; 13 14 15 16
    punpckldq   xmm0, xmm7	    ; 9 13 10 14
    punpckhdq   xmm1, xmm7		  ; 11 15 12 16
    movdqa      xmm6, xmm4		  ; 1 2 3 4
    punpckldq   xmm4, xmm5		  ; 1 5 2 6
    punpckhdq   xmm6, xmm5		  ; 3 7 4 8
    
    movdqa      xmm5, xmm4		  ; 1 5 2 6
    movdqa      xmm7, xmm6		  ; 9 13 10 14
    
    punpcklqdq  xmm4, xmm0	    ; 1 5 9 13
    punpckhqdq  xmm5, xmm0	    ; 2 6 10 14
    punpcklqdq  xmm6, xmm1	    ; 3 7 11 15
    punpckhqdq  xmm7, xmm1	    ; 4 8 12 16 

 

    movups  xmm0, [rdx]         ;load input vector
    xorps   xmm2, xmm2          ;zero the output vector
    
    movups  xmm1, xmm0          ;first row
    shufps  xmm1, xmm1, 0x00
    mulps   xmm1, xmm4
    addps   xmm2, xmm1

    
    movups  xmm1, xmm0          ;second row
    shufps  xmm1, xmm1, 0x55
    mulps   xmm1, xmm5
    addps   xmm2, xmm1
    

    movups  xmm1, xmm0          ;third row
    shufps  xmm1, xmm1, 0xAA
    mulps   xmm1, xmm6
    addps   xmm2, xmm1


    movups  xmm1, xmm0          ;fourth row
    shufps  xmm1, xmm1, 0xFF
    mulps   xmm1, xmm7
    addps   xmm2, xmm1

    movups  [rdi], xmm2         ;save to R
  
                                ;function epilogue
    pop     rcx
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rbp
    ret 


vector_matrix_multiplication_3x3:
    push    rbp                 ;function prologue
    mov     rbp, rsp
    push    rdx                 ;*V
    push    rsi                 ;*M
    push    rdi                 ;*R
    push    rcx

    movups  xmm0, [rsi]         ;first row
    movups  [tmp_matrix], xmm0
    movups  xmm0, [rsi+12]      ;second row
    movups  [tmp_matrix+16], xmm0
    movups  xmm0, [rsi+24]      ;third row
    movups  [tmp_matrix+32], xmm0
    xorps   xmm0, xmm0          ;zero xmm0
    movups  [tmp_matrix+48], xmm0

    movups  xmm0, [rdx]         ;tmp vector
    movups  [tmp_vector], xmm0
 
    

    ;lea     rdx, [rbp+64]       ;vector as arg
    mov     rsi, tmp_matrix 
    mov     rdx, tmp_vector      ;matrix as arg
    call    vector_matrix_multiplication_4x4 
  
    ;mov     rdi, tmp_vector
                                ;function epilogue
    pop     rcx
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rbp
    ret 



fill_Mrx:
    push    rbp                 ;function prologue
    mov     rbp, rsp
    
    finit   
    fld     dword [rsi]               ;load rad
    fsin                        ;get sin
    fst     dword  [rdi+28]     ;store
    fchs                        ;negate
    fst     dword [rdi+20]      
    fld     dword [rsi] 
    fcos                        ;get cos
    fst     dword [rdi+16]      ;store
    fst     dword [rdi+32]      ;store

                                ;function epilogue
    pop     rbp
    ret 

fill_Mry:
    push    rbp                 ;function prologue
    mov     rbp, rsp
  
    finit   
    fld     dword [rsi]         ;load rad
    fsin                        ;get sin
    fst     dword  [rdi+8]      ;store
    fchs                        ;negate
    fst     dword [rdi+24]      
    fld     dword [rsi]
    fcos                        ;get cos
    fst     dword [rdi+0]       ;store
    fst     dword [rdi+32]      ;store

                                ;function epilogue
    pop     rbp
    ret 

fill_Mrz:
    push    rbp                 ;function prologue
    mov     rbp, rsp
  
    
    finit   
    fld     dword [rsi]                 ;load rad
    fsin                        ;get sin
    fst     dword [rdi+12]        ;store
    fchs                        ;negate
    fst     dword [rdi+4]      
    fld     dword [rsi]  
    fcos                        ;get cos
    fst     dword [rdi+0]       ;store
    fst     dword [rdi+16]      ;store

                                ;function epilogue
    pop     rbp
    ret 




;void screen_coords(float *V, int* coords);
screen_coords:
    push    rbp                 ;function prologue
    mov     rbp, rsp
    push    rdx
    push    rsi                 ;*coords
    push    rdi                 ;*V
    push    rcx
    push    rsi 
    extern MViewPort
    extern MProjection
    extern MRotation
   
    
    mov     rdx, rdi            ;*V
    mov     rsi, MRotation      ;*M
    mov     rdi, tmp_vector2    ;*R
    call vector_matrix_multiplication_3x3
                                ;move 1 in float format
    mov     [tmp_vector2+12], DWORD 0x3f800000   
    
    mov     rdx, tmp_vector2    ;*V
    mov     rsi, MProjection    ;*M
    mov     rdi, tmp_vector     ;*R
    call vector_matrix_multiplication_4x4
   
                              ;move 1 in float format 
    ;mov     [tmp_vector+12], DWORD  0x3f800000   
    mov     rdx, tmp_vector     ;*V
    mov     rsi, MViewPort      ;*M
    mov     rdi, tmp_vector2    ;*R 
    call vector_matrix_multiplication_4x4

    pop     rsi 
    ;movups  xmm0, [tmp_vector]
    movups  xmm0, [tmp_vector2] ;load vector
    movups  xmm1, xmm0          ;copy it
    shufps  xmm1, xmm1, 0xFF    ;fill copy with last value
    divps   xmm0, xmm1          ;divide
    cvttps2dq xmm0, xmm0        ;round to integer
    movups  [rsi], xmm0 
    
    pop     rcx
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rbp
    ret 

fill_Projection:
    push    rbp                 ;function prologue
    mov     rbp, rsp
    
    finit   
    fld     dword [rsi]         ;load X 
    fst     dword [rdi+12]
    fld     dword [rsi+4]       ;load y
    fst     dword [rdi+28]
    fld     dword [rsi+8]       ;load z
    fst     dword [rdi+60]
                                ;function epilogue
    pop     rbp
    ret 



 
fpu_test:
    push  rbp
    mov   rbp, rsp

    finit
    fld dword [rdi]
    fsin
    fst dword [rdi]
    fchs
    fst dword [rdi]

    pop   rbp
    ret 
