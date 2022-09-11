; Author: Dylan Turner
; Description:
; - First stage bootloader; simply load 2nd stage from disk and jump to it
; - Initial bootloader is exactly 512 bytes, so to do more set up, we need to exit

[org 0x7C00]

[bits 16]
    mov     [boot_disk], dl
    call    read_disk

    jmp     pgrm_space

%include "print16.asm"
%include "disk_read.asm"

times 510 - ($ - $$) db 0
dw 0xAA55
