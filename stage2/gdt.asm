; Author: Dylan Turner
; Description: Load the GDT for setting up protected mode

[bits 16]

; See https://wiki.osdev.org/GDT_Tutorial
; and https://wiki.osdev.org/Global_Descriptor_Table#Segment_Descriptor
; for reference

gdt_null_desc:
    dd 0
    dd 0

gdt_code_desc:
    dw 0xFFFF           ; Limit (we set it to max)
    dw 0x0000           ; Base (low) of code is just start of mem
    db 0x00             ; The upper part of 24-bit address
    db 0b10011010       ; Pres, Kernel Priv, Data or Code, Code, Readable
    db 0b11001111       ; Large mem, 32 bit, 0, limit extension
    db 0x00             ; Base pt 2 (high)

gdt_data_desc:
    dw 0xFFFF           ; Limit (we set it to max)
    dw 0x0000           ; Base (low) of code is just start of mem
    db 0x00             ; The upper part of 24-bit address
    db 0b10010010       ; Pres, Kernel Priv, Data or Code, Data, Readable
    db 0b11001111       ; Large mem, 32 bit, 0, limit extension
    db 0x00             ; Base pt 2 (high)

gdt_user_code_desc:
    dw 0xFFFF           ; Limit (we set it to max)
    dw 0x0000           ; Base (low) of code is just start of mem
    db 0x00             ; The upper part of 24-bit address
    db 0b11111010       ; Pres, Kernel Priv, Data or Code, Code, Readable
    db 0b11001111       ; Large mem, 32 bit, 0, limit extension
    db 0x00

gdt_user_data_desc:
    dw 0xFFFF           ; Limit (we set it to max)
    dw 0x0000           ; Base (low) of code is just start of mem
    db 0x00             ; The upper part of 24-bit address
    db 0b11110010       ; Pres, Kernel Priv, Data or Code, Data, Readable
    db 0b11001111       ; Large mem, 32 bit, 0, limit extension
    db 0x00             ; Base pt 2 (high)

gdt_end:

gdt_desc:
gdt_size:
    dw gdt_end - gdt_null_desc - 1
    dq gdt_null_desc

code_seg    equ gdt_code_desc - gdt_null_desc
data_seg    equ gdt_data_desc - gdt_null_desc

; Turn it into a 64-bit OS
[bits 32]

edit_gdt:
    ; Change the 0x0C flag to 0x0A for code segments to make them 64 bit
    mov     [gdt_code_desc + 6], byte 0b10101111
    mov     [gdt_user_code_desc + 6], byte 0b10101111
    ret
