; Practical Reverse Engineering: chapter 1, exercise 1
; Runs on 32-bit Linux only.
;
; To assemble and run:
;     nasm -felf ch1_ex1.asm 
;     ld ch1_ex1.o -o ch1_ex1
;     ./ch1_ex1

section .text
global _start

_exercise1:
; prologue
    push   ebp              ; save off base pointer
    mov    ebp, esp         ; move current stack pointer into base pointer

;exercise code
    mov    edi, [ebp+0x8]   ; move arg1 into edi
    mov    edx, edi         ; 
    xor    eax, eax         ; zero out eax
    or     ecx, 0xFFFFFFFF  ; or ecx with 0xFFFFFFFF, effectively sets ecx to -2147483647
    repne  scasb            ; repeat scan byte while byte != 0 (eax)
    add    ecx, 2
    neg    ecx
    mov    al, [ebp+0xC]
    mov    edi, edx
    rep    stosb
    mov    eax, edx

; epilogue
    mov    esp, ebp
    pop    ebp
    ret

_start:
    push   0x41              ; A
    push   msg               ; "Hello World" string
    call   _exercise1
    
    ; ssize_t write(int fd, const void *buf, size_t count);
    mov     edx, len         ; message len
    mov     ecx, msg         ; message
    mov     ebx, 1           ; stdout
    mov     eax, 4           ; sys_write
    int     0x80             ; call kernel

    ; exit(0)
    mov     eax, 1           ; sys_exit
    xor     edx, edx         ; exit code 0
    int     0x80             ; invoke operating system to exit

section .data
msg  db "Hello World", 0xA   ; string with newline
len  equ $ - msg             ; length of string
