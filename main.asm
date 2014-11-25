; Print 'Hey'

print:
mov ah, 0x0e ;0e -> scrolling teletype
mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'y'
int 0x10

end:
jmp $

fill_boot_sector:
times 510-($-$$) db 0 ; Pad the rest of the sector (with zeros)
dw 0xaa55
