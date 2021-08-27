; Prints the last stored string in the bx registry
; character by character until the null terminating
; character is found ( 0 ). If the special new line
; character is found ( ` ) it calls PrintNewLine 

PrintText:    
	; Push register values onto the stack for later use
	pusha 

	IterateTextLoop:
		; Read a character from bx and increment by one
		mov al, [bx]
		inc bx
		
		; If the null terminating character is found, return
		cmp al, 0
		je IterateTextEnd

		; TODO: detect the new line character a call PrintNewLine when found

		; Else Print the character and repeat with the next character
		mov ah, 0x0e
		int 0x10
		jmp IterateTextLoop
	
	IterateTextEnd:
		; Pop the initial register values back from the stack an return
		popa
		ret


; Prints hex values by converting them to a string stored 
; in the HexString label and calling PrintText with the 
; converted value at the end

PrintHex:
  	; Push register values onto the stack for later use
	pusha            

  	; Set the character counter to 4 as 4 characters ( 16 bits ) need to be printed
	mov cx, 4

	IterateHexLoop: 
		; Decrement the character counter by one      
		dec cx            

		; Copy bx to ax for masking the last characters  
		mov ax, dx

		; Shift bx 4 bits to the right and mask ah to get the last 4 bits
		shr dx, 4          
		and ax, 0xf        

		; Set bx to the address of the HexString, skip the 0x and update the character counter
		mov bx, HexString   
		add bx, 2
		add bx, cx        

		; If the character is a number, set the letter, else add 0x27 before setting the letter
		cmp ax, 0xa        
		jl SetLetter     
		add al, 0x27      
  		jl SetLetter
		
		SetLetter:
			; Add 0x30 for ASCII numbers and add the byte to the character at bx
			add al, 0x30      
			mov byte [bx], al  

			; If the character counter is 0, return
			cmp cx, 0          
			je IterateHexEnd
			jmp IterateHexLoop    

	IterateHexEnd:
		; Print the HexString using PrintText
		mov bx, HexString   
		call PrintText

		; Pop the initial register values back from the stack an return
		popa              
		ret          


; Prints a new line when called or when the special new 
; line character is found ( ` ) inside a string

PrintNewLine:
	; Moves the 2 special codes for the newline in the al registry
	mov ah, 0x0e
	mov al, 0x0D
	int 0x10
	mov al, 0xA
	int 0x10
	ret