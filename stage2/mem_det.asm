; Author: Dylan Turner
; Description: Detect how much memory the system has

[bits 16]

[global mem_reg_cnt]

; BIOS will tell us how big in a table form. So store the table
mem_reg_cnt:
    db 0

mem_det:
    ; Set arbitrary location for memory map via es:di
    mov     ax, 0
    mov     es, ax
    mov     di, 0x5000
    mov     edx, 0x534D4150     ; Stands for "SMAP" in Ascii
    xor     ebx, ebx

    ; Increment through each table listing and save to dest via BIOS interrupt
mem_det_rep:
    mov     eax, 0xE820
    mov     ecx, 24
    int     0x15                ; Note: sets ebx

    cmp     ebx, 0
    je      mem_det_finished

    add     di, 24
    inc     byte [mem_reg_cnt]  ; Added listing, increase number

    jmp mem_det_rep

mem_det_finished:
    ret
