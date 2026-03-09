ORG 0       ; This tells NASM where in memory our program will run

BITS 16     ; We're writing 16-bit code

start:
    cli                 ; Disable maskable interrupts temporarily
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    sti                 ; Re-enable interrupts
    mov si, message     ; Address of 'message' move into the SI register
    call print          ; call our print function
    jmp $               ; Infinite loop, GOTO THIS instruction

print:
    mov bx, 0       ; Clear BX register to use it as a counter

.loop:
    lodsb           ; Lead the byte at address [DS:SI] into AL and increment SI (if direction flag is clear)

    cmp al, 0       ; Compare the value in AL to 0 (end of string)
    je .done        ; If AL is 0, then we're at the end of string and we're done
    call print_char ; Otherwise, print the character in AL
    jmp .loop       ; Loop to the next character

.done:
    ret             ; Return from the print function

print_char:
    mov ah, 0eh     ; Move 0eh = 0x0E into AH, this is the BIOS service number for printing a character
    int 0x10        ; Call BIOS interrup 0x10, which handles screen operations
    ret             ; Returns from print_char function

message: db 'Hello, World!', 0  ; Our null-terminated string to be printed

; A boot sector is exactly 512 bytes = 510 + last 2 bytes
times 510-($ - $$) db 0         ; Fill the rest of the sector with zeros upto 510 bytes

dw 0xAA55           ; The boot sector signature
