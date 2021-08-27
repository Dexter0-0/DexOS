; DexOS Boot Sector

[BITS 16]
[org 0x7c00]


DexOSLoader:
	call Init
	call Main
	call Exit
	jmp $


Init:
	call PrintNewLine
	mov bx, LoaderString
	call PrintText
	call PrintNewLine

	ret


Main:
	mov bx, DiskErrorString
	call PrintText
	call PrintNewLine

	mov dx, 0x1fb2
	call PrintHex
	call PrintNewLine

	ret:


Exit:
	ret


%include "Helpers/Print.asm"
%include "Helpers/Storage.asm"


LoaderString:
	db "DexOs: Loading...", 0

DiskErrorString:
	db "DexOS: ! Disk read Error !", 0

HexString: 
	db '0x0000', 0


times 510-($-$$) db 0
dw 0xaa55