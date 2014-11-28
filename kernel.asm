; kernel.asm

org 0x1000

jmp start

color: db 6

info: db 'Press any key to print background color.', 13, 10, 0

start:
xor ax, ax ; zero-in ds
mov ds, ax

mov si, info ; print info
mov bl, 0x02 ; set color
call print

read:
mov ah, 0x00

int 0x16 ; read keystroke from keyboard
mov [color], al

je fill

jmp read

print:
mov ah, 0x0E ; add char byte to register
mov bh, 0x00

nextChar:
lodsb ; load next byte into AL. Update SI.
cmp al, 0 ; is the last char?
je end ; jump short, if it's equal
int 0x10 ; print to the screen
jmp nextChar

end:
ret

fill:
mov ah, 0 ; set display mode function.
mov ax, 0013h ; mode 13h = 320x200 pixels, 256 colors.
int 10h ; set it!

mov cx, 10 ; col
mov dx, 10 ; row
mov ah, 0ch ; draw pixel

mov al, [color]

draw:
inc cx
int 10h
cmp cx, 150
jne draw

mov cx, 10 ; reset to start of col
inc dx ; next row
cmp dx, 150
jne draw

jmp read

; Zero-in all non-used space up to 1022 bytes.
times 1022 - ($-$$) db 0

; Boot signature
dw 0xAA55
