; - Initialized data (.data) -
; System Messages
boot_msg db 'Welcome To Nops.', 0x0d, 0x0a, '------', 0x0d, 0x0a, 0
prompt db 'user> ', 0
shutdown_msg db 0x0d, 0x0a, '------', 0x0d, 0x0a, 'Nops> Shutting down...', 0x0d, 0x0a, 0

; Commands
; TODO: Create macro to handle the various cmds
exit_cmd db 'QUIT', 0
; - Empty data (.bss) -
buffer times 64 db 0
