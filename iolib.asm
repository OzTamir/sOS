; Those are macros used to handle Textual-IO from the user
;---------------------

print_string:
    ; Print the string pointed to by SI
    ; ---------
    ; Load the next byte from SI
    lodsb
    ; If al is 0 then we can return
    or al, al
    jz .done
    ; Load the teletype output code into ah and call the interrupt
    mov ah, 0x0e
    int 0x10

    jmp print_string

    .done:
        ret

%macro print 1
    ; Macro wrapper for print_string
    push ax
    push si
    mov si, %1
    call print_string
    pop si
    pop ax
%endmacro
