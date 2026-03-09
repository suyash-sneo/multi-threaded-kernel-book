ORG 0

BITS 16

start:
    cli         ; Disable maskable interrupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    sti         ; Enable interrupts

    ; Setup our new interrupt handler
    mov ax, 0x7c0               ; Segment address of the code

    ; We use SS as segment because it's equal to 0
    ; The two bytes at 0x202 and 0x203 together make the ISR segment
    mov word[ss:0x202], ax      ; Store segment 0x7c0 in IVT

    lea ax, [print]             ; Offset of our 'print' function
    ; The two bytes at 0x200 and 0x201 together make the ISR offset
    mov word[ss:0x200], ax      ; Store the offset of our print routine in Interrupt Vector 0x80

    lea si, [message]           ; Move the address of message into SI register
    int 0x80                    ; Call our new interrupt
    jmp $

print:
    mov bx, 0                    ; Clear BX to use as counter

.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop

.done:
    iret                        ; This is IRET now as it returns from the print interrupt routine ISR

print_char:
    mov ah, 0eh
    int 0x10
    ret

message: db 'Hello World!', 0
isr_message: db 'Interrupt Happened!', 0

times 510 - ($-$$) db 0;
dw 0xAA55
