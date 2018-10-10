; Inndata Programmet leser inn to sifre skilt med ett eller flere mellomrom
; Utdata Programmet skriver ut summen av de to sifrene,
; forutsatt at summen er mindre enn 10.

; Konstanter
cr equ 13 ; Vognretur
lf equ 10 ; Linjeskift
SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1
STDERR equ 2

; Datasegment
section .bss
	siffer resb 4

; Datasegment
section .data
	meld db "Skriv to ensifrede tall skilt med mellomrom.",cr,lf
		 db "Summen av tallene maa vaere mindre enn 10.",cr,lf
	meldlen equ $ - meld
	feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
	feillen equ $ - feilmeld
	crlf db cr,lf
	crlflen equ $ - crlf

; Kodesegment med program
section .text

global _start
_start:
	mov edx,meldlen
	mov ecx,meld
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h

	; Les tall, innlest tall returneres i ecx
	; Vellykket retur dersom edx=0
	call lessiffer
	cmp edx,0 ; Test om vellykket innlesning
	jne Slutt ; Hopp tilavslutning ved feil i innlesing
	mov eax,ecx ; Første tall/siffer lagres i reg eax

	call lessiffer
	; Les andre tall/siffer
	; vellykket: edx=0, tall i ecx
	cmp edx,0 ;Test om vellykket innlesning
	jne Slutt
	mov ebx,ecx ; andre tall/siffer lagres i reg ebx
	call nylinje
	add eax,ebx
	mov ecx,eax
	call skrivsiffer ; Skriv ut verdi i ecx som ensifret tall
	call nylinje

Slutt:
	mov eax,SYS_EXIT
	mov ebx,0
	int 80h

; ---------------------------------------------------------
skrivsiffer:
	; Skriver ut sifferet lagret i ecx, hvis tallet er større enn 10 vil den skrive det ut i deler.
	push eax
	push ebx
	push ecx
	push edx
	cmp ecx, 10         ; Sjekke om tallet er større enn 10
	jb skrivetsiffer    ; Er tallet mindre enn 10 trenger vi ikke å gjøre noe spesielt før vi skriver det ut
	mov eax, ecx        ; Flytt ecx til acx før divisjon
	mov ebx, 10         ; Flytt 10 til ebx før divisjon
	xor edx, edx        ; Passe på at edx = 0 før divisjon (et tall xor med seg selv gir 0)
	div ebx             ; eax / ebx, resultat lagres i eax og rest i edx
	mov ecx, eax        ; Flytt resultatet av divisjonen til ecx
	call skrivsiffer    ; Skriv ut resultatet av divisjonen med skrivsiffer
	mov ecx, edx		; Rest etter divisjon er lagret i edx, flytt dette til ecx før utskriving
	



	; Annen versjon av koden som ikke funker for tall høyere enn 19. Bruker ikke divisjon
	; push eax
	; push ebx
	; push ecx
	; push edx
	; cmp ecx, 10         ; Sjekke om tallet er større enn 10
	; jb skrivetsiffer
	; mov ebx, ecx
	; mov ecx, 1
	; call skrivsiffer    
	; sub ebx, 10
	;mov ecx, ebx
skrivetsiffer:   	
	add ecx,'0' 		; converter tall til ascii.
	mov [siffer],ecx
	mov ecx,siffer
	mov edx,1
	mov ebx,STDOUT
	mov eax,SYS_WRITE
	int 80h
	; Her var det feil i koden i oppgaven (var push isteden for pop)
	pop edx 
	pop ecx
	pop ebx
	pop eax
	ret

; ---------------------------------------------------------

lessiffer:
	; Leter forbi alle blanke til neste ikke-blank
	; Neste ikke-blank returneres i ecx
	push eax
push ebx
Lokke:
	; Leser et tegn fra tastaturet
	mov eax,SYS_READ
	mov ebx,STDIN
	mov ecx,siffer
	mov edx,1
	int 80h
	mov ecx,[siffer]
	cmp ecx,' '
	je Lokke
	cmp ecx,'0' ; Sjekk at tast er i område 0-9
	jb Feil
	cmp ecx,'9'
	ja Feil
	sub ecx,'0' ; Konverter ascii til tall.
	mov edx,0 ; signaliser vellykket innlesning
	pop ebx
	pop eax
ret ; Vellykket retur
Feil:
	mov edx,feillen
	mov ecx,feilmeld
	mov ebx,STDERR
	mov eax,SYS_WRITE
	int 80h
	mov edx,1 ; Signaliser mislykket innlesning av tall
	pop ebx
	pop eax
	ret

; Mislykket retur
; ---------------------------------------------------------
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