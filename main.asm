[BITS 16]
[ORG 0x7c00]
jmp boot

includes:
    %include 'iolib.asm'
    %include 'string.asm'
    %include 'data.asm'
    %include 'hardware.asm'

boot:
    ; Print the welcome message and any other thing that should be done before the user recivec control
    print boot_msg
    jmp main

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
    call shutdown
    cli
    hlt
    times 510-($-$$) db 0 ; Pad the rest of the sector (with zeros)
    dw 0xaa55
