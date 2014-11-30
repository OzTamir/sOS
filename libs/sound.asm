; Functions that allow sound-things
;---------------------

speaker_tone:
    ; Generate a speaker tone, call speaker_off to turn off
    ; IN: note frequancy in ax; OUT: nothing
    ; ---------
    ; Store all the registers
    pusha
    
    ; Store the requested note in cx
    mov cx, ax

	mov al, 182
	out 43h, al
    ; Now set the frequency
	mov ax, cx
	out 42h, al
	mov al, ah
	out 42h, al
    ; Switch the speaker on
	in al, 61h
	or al, 03h
	out 61h, al
    ; Restore the registers's values
	popa
	ret


speaker_off:
    ; Turn off the speaker
    ; ---------
    pusha
    in al, 61h
	and al, 0FCh
	out 61h, al
    popa
    ret
