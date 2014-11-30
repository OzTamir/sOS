; String Operations
;---------------------

string_length:
    ; Return the length of the string (from si) in ax
    ; ---------
    xor ax, ax
    xor cx, cx
    
    .loop:
        lodsb
        cmp al, 0
        je .done
        inc cx
        jmp .loop
    
    .done:
        mov ax, cx
        ret

%macro strlen 1
    ; Macro wrapper for string_length
    ; ---------
    push si
    push cx
    mov si, %1
    call string_length
    pop cx
    pop si
%endmacro
    

string_cmp:
    ; Compare two strings and set the carry flag per the result
    ; ---------
    .cmp_loop:
        ; Grab the next chars from both SI and DI
        mov al, [si]
        mov bl, [di]
        ; Compare - if they are not equal, then the strings are different
        cmp al, bl
        jne .not_equal
        
        ; If we got a null, it means that they are equal (if we're here, all the previous chars were equal)
        cmp al, 0
        je .equal
        
        ; Increase the pointers
        inc si
        inc di
        jmp .cmp_loop
    .not_equal:
        ; Not equal, clear the carry flag
        clc
        ret
    .equal:
        ; Equal, set the carry flag
        stc
        ret

%macro strcmp 2
    ; Macro wrapper for string_cmp
    ; ---------
    ; Save the values of ax, bx, si and di to the stack
    push ax
    push bx
    push si
    push di
    ; Move the args to si and di and compare
    mov si, %1
    mov di, %2
    call string_cmp
    ; Restore the values
    pop di
    pop si
    pop bx
    pop ax
%endmacro

; -------------

string_parse:
    ; Parse a string from SI into the general-purpose registers
    ; Example: si = 'foo bar baz' -> ax = 'foo', bx = 'bar', cx = 'baz'
    ; Obviously only handle up to 4 args
    ; ---------
    mov ax, si
    xor bx, bx
    xor cx, cx
    xor dx, dx
    push ax
    .firstloop:
        lodsb
        cmp al, 0
        je .done
        cmp al, ' '
        jne .firstloop
        ; If we've reached a space, place a zero-terminator at this char
        dec si
        mov byte [si], 0
        ; Move SI to the next char and move the parsed string to bx
        inc si
        mov bx, si
    ; Do the same with cx and dx
    .secloop:
        lodsb
        cmp al, 0
        je .done
        cmp al, ' '
        jne .secloop
        
        dec si
        mov byte [si], 0
        
        inc si
        mov cx, si

    .thirdloop:
        lodsb
        cmp al, 0
        je .done
        cmp al, ' '
        jne .thirdloop
        
        dec si
        mov byte [si], 0
        
        inc si
        mov dx, si
    .done:
        pop ax
        ret

%macro str_parse 1
    ; Macro wrapper for string_parse
    ; ---------
    push si
    mov si, %1
    call string_parse
    pop si
%endmacro
        
