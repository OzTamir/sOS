start:
    ; Setup things
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    jmp boot

includes:
    %include 'iolib.asm'
    %include 'string.asm'
    %include 'data.asm'

boot:
    ; Print the welcome message and any other thing that should be done before the user recivec control
    print boot_msg

main:
    input buffer
    print buffer
    strcmp buffer, exit_cmd
    jc end
    newline
    jmp main

end:
    print shutdown_msg
    jmp fill_boot_sector

fill_boot_sector:
    jmp $
    times 510-($-$$) db 0 ; Pad the rest of the sector (with zeros)
    dw 0xaa55
