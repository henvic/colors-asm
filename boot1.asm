; boot1.asm

bits 16

; Load by BIOS at this position
org 0x7c00

jmp 0000h:start

drive: db 0
msg: db 'Booting.', 13, 10, 0

start:
xor ax, ax ; zero-in ds
mov ds, ax

mov byte[drive], dl

mov ah, 0x00 ; video mode
mov al, 0x12 ; select video mode
int 0x10 ; 640x480 16bits

mov si, msg

mov ah, 0x0E ; add chars to registers to print them
mov bh, 0x00
mov bl, 0x07

nextChar:
lodsb ; load next byte into AL. Update SI.
cmp al, 0 ; is the last char?
je readDisk ; jump short, if it's equal
int 0x10 ; print to the screen
jmp nextChar

readDisk:
mov dl, [drive]
mov dh, 0 ; head
mov ch, 0 ; cylinder
mov cl, 2 ; sector
mov al, 1 ; sector
mov ah, 0x02 ; read

mov bx, 0
mov es, bx ; segment
mov bx, 0x7E0 ; offset

int 0x13 ; copy to memory at position ES:BX
jmp 0x0:0x7E0 ; jump to boot2 bootloader position
jmp $

; Zero-in all non-used space up to 512 bytes.
times 510 - ($-$$) db 0

; Boot signature
dw 0xAA55
