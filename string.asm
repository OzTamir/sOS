; String Operations
;---------------------

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
    
        
