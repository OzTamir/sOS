start:
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    jmp main

includes:
    %include 'iolib.asm'
    %include 'data.asm'

main:
    print hello_string
    jmp end

end:
 jmp fill_boot_sector

fill_boot_sector:
jmp $
times 510-($-$$) db 0 ; Pad the rest of the sector (with zeros)
dw 0xaa55
