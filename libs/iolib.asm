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
    ; Loop
    jmp print_string

    .done:
        ret

print_int:
    ; Clear dx, cx
    xor dx, dx
    xor cx, cx

    .push_loop:
        ; Clear dx
        xor dx, dx
        ; ax / bx
        div bx
        ; Push the remainder to stack
        xor dh, dh
        push dx
        ; Increase the counter (counts number of digits)
        inc cx
        ; Check if we have something to divide
        cmp ax, 0
        ; Loop until nothing left in ax
        jne .push_loop
                                   
    .print_loop:
        ; Get the next number from the stack
        pop ax
        ; Convert to ASCII
        add al, 0x30
        ; Print it
        mov ah, 0x0e                            
        int 0x10
        ; Loop until cx is zero
        loop .print_loop
        ret

%macro printf 1-2 10
    ; Macro wrapper for print_int
    ; Second arg is the base
    ; ---------
    pusha
    mov ax, %1
    mov bx, %2
    call print_int
    popa
%endmacro

%macro print 1
    ; Macro wrapper for print_string
    ; ---------
    ; Store the current values of ax and si on the stack
    push ax
    push si
    ; Point SI to the string and call the print_string routine
    mov si, %1
    call print_string
    ; Restore ax and si
    pop si
    pop ax
%endmacro

%macro newline 0
    ; Print a newline
    ; ---------
    ; Store the value of ax on the stack
    push ax
    ; Print the newline
    mov ah, 0x0e
    mov al, 0x0d
    int 0x10
    mov al, 0x0a
    int 0x10
    pop ax
%endmacro

%macro backspace 0
        push ax
        ; 'Print' the backspace
        mov ah, 0x0e
        mov al, 0x08
        int 0x10
        
        ; Print over the deleted char to wipe it from the display
        mov al, ' '
        int 0x10
        
        ; Backspace once more
        mov al, 0x08
        int 0x10
        pop ax
%endmacro

;---------------------

read_string:
    ; Read a string with up to 64 chars into buffer in di
    ; ---------
    xor cl, cl
    .read_loop:
        ; Wait for keypress and store it in al when it happens
        mov ah, 0
        int 0x16
        
        ; Check if backspace was pressed
        cmp al, 0x08
        je .handle_backspace
        
        ; Check if the user pressed enter (finished the input)
        cmp al, 0x0d
        je .done
        
        ; If we filled our buffer, loop so that only enter/backspace are allowed
        ; Also, we can only store 63 chars since we need one byte for null (strings are null-terminaited)
        cmp cl, 0x3f
        je .read_loop
        
        ; Print the char
        mov ah, 0x0e
        int 0x10
        
        ; Store it in the buffer (pointed to by di)
        stosb
        inc cl
        jmp .read_loop
    .handle_backspace:
        ; If it's the first char typed, there's nothing to delete
        cmp cl, 0
        je .read_loop
        
        ; Remove the previous char from the buffer
        dec di
        mov byte [di], 0
        dec cl
        
        ; Remove the char from display ('unprint' it)
        backspace
        
        jmp .read_loop
    .done:
        ; Add null-terminator
        mov al, 0
        stosb
        
        ; Print a newline and return
        newline
        ret

%macro input 1
    ; Macro wrapper for read_string
    ;----------
    print prompt
    backspace
    push di
    mov di, %1
    call read_string
    pop di
%endmacro
        
        
