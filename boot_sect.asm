[org 0x7c00]

mov bx, STR_HELLO
call print_string
call print_nl
mov dx, 0x7FFF
call print_hex
jmp end

print_string:
  pusha
start_ps:
  mov cx, [bx]
  cmp cl, 0
  je end_ps
  mov ax, [bx]
  call print_char
  inc bx
  jmp start_ps

end_ps:
  popa
  ret

print_char:
  pusha
  mov ah, 0x0e
  int 0x10
  popa
  ret

print_nl:
  pusha
  mov al, 0x0D
  call print_char
  mov al, 0x0A
  call print_char
  popa
  ret

; Reads the lowest four bits of bx and returns the hex char (0-F) in ax
get_hex_char:
  push bx
  mov ax, bx
  and ax, 0x000F
  cmp al, 0x0A
  jl case_get_hc_digit
  jmp case_get_hc_letter

case_get_hc_digit:
  add ax, '0'
  jmp end_get_hc

case_get_hc_letter:
  sub ax, 0x000A
  add ax, 'A'
  jmp end_get_hc
  
end_get_hc:
  pop bx
  ret

; Print the value at dx as hex
print_hex:
  pusha
  mov al, '0'
  call print_char
  mov al, 'x'
  call print_char
  
  mov bx, dx
  call get_hex_char
  push ax
  
  shr bx, 4
  call get_hex_char
  push ax
  
  shr bx, 4
  call get_hex_char
  push ax
  
  shr bx, 4
  call get_hex_char
  push ax
  
  pop ax
  call print_char
  pop ax
  call print_char
  pop ax
  call print_char
  pop ax
  call print_char
  popa
  ret

end:
  jmp $

; Globals
STR_HELLO: db "Hello, World!", 0
STR_HEX_OUT: db "0x0000", 0

times 510-($-$$) db 0

dw 0xaa55
