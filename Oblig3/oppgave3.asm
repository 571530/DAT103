; Assembly kode laget utifra java kode under
; public static void main(String[] args) {
; 	int a = 0;
; 	for (int i = 0; i < 20; i++) {
;		if (i < 10) {
;			a++;
;		} else {
;			a--;
;		}
;	}

;	System.out.println(a);
;	System.exit(0);
;}


; Konstanter
cr equ 13 ; Vognretur
lf equ 10 ; Linjeskift
SYS_EXIT equ 1
SYS_READ equ 3
STDIN equ 0
STDOUT equ 1
STDERR equ 2

; Datasegment
section .bss
	a resb 1
	i resb 1

; Datasegment
section .data
	crlf db cr,lf
	crlflen equ $ - crlf

; Kodesegment med program
section .text

global _start
_start:
	mov [a], byte 0  	; Set a = 0
	mov [i], byte 0  	; Set i = 0
for:		
for_cond:
	cmp [i], byte 20 	; hvis i >= 20, stopp løkka
	jge for_end 

if_start:
	cmp [i], byte 10 	; If   
	jge else 		 	; Hopp til else, hvis ikke mindre enn 10
	inc byte [a]     	; a++
	jmp if_slutt     	; hopp til if_slutt så ikke koden i else blir utført
else:					; else
	dec byte [a] 	    ; a--
if_slutt:		

	
for_update:
	inc byte [i]    	 ; i++
	jmp for

for_end:
 	add byte [a], '0'	; Gjør om tall til ASCII
	mov ecx, a          
	mov edx, 1
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h

	call nylinje		
	
	mov eax,SYS_EXIT 
	mov ebx,0
	int 80h

; Flytt cursor helt til venstre på neste linje
nylinje:
	push eax
	push ebx
	push ecx
	push edx
	mov edx,crlflen
	mov ecx,crlf
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

; End _start