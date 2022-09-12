; Author: Dylan Turner
; Description: Define isrs and loading for IDT in assembly bc they break in Rust lol

[global idt_desc]
[global load_idt]
[extern IDT]

[bits 64]

idt_desc:
    dw 4095
    dq IDT

load_idt:
    lidt    [idt_desc]
    sti
    ret

