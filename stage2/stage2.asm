; Author: Dylan Turner
; Description:
; - 2nd stage bootloader to load kernel
; - Because this is a 64-bit OS, paging MUST be enabled
;   thus, it makes sense to do some things in here like set up the GDT

[bits 16]

[global _start]

; When we link, we put the start of stage2 and kernel at 0x8000
; So this _start label is at 0x8000, where the stage1 kernel jumps to
_start:
    ; Immediately, we try to jump into 32 bit mode
    jmp     enter_protected_mode

; Include all of our helper functions
%include "print.asm"
%include "gdt.asm"
%include "cpuid.asm"
%include "simple_paging.asm"

[bits 16]

enter_protected_mode:
    call    enable_a20
    cli

    lgdt    [gdt_desc]
    mov     eax, cr0
    or      eax, 1
    mov     cr0, eax

    jmp     code_seg:start_protected_mode

enable_a20:
    in      al, 0x92
    or      al, 2
    out     0x92, al
    ret

[bits 32]

start_protected_mode:
    ; Point stack to correct new location
    mov     ax, data_seg
    mov     ds, ax
    mov     ss, ax
    mov     es, ax
    mov     fs, ax
    mov     gs, ax
    
    call    assert_cpuid
    call    assert_long_mode
    call    set_up_ident_paging
    call    edit_gdt

    jmp     code_seg:start_64_bit

[bits 64]

; kernel_start is a symbol in Rust
[extern kernel_start]

start_64_bit:
    ; Set a blue color for testing
    mov     edi, 0xB8000
    mov     rax, 0x1F201F201F201F20
    mov     ecx, 500
    rep     stosq

    call    activate_sse
    call    kernel_start

    jmp     $

; Enable floating point numbers
activate_sse:
    mov     rax, cr0
    and     ax, 0b11111101
    or      ax, 0b00000001
    mov     cr0, rax

    mov     rax, cr4
    or      ax, 0b1100000000
    mov     cr4, ax

    ret

start_msg:  db "Starting kernel.", 0
done_msg:   db "Done.", 0
