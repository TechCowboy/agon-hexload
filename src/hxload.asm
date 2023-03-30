;
; Title:		AGON MOS - MOS hexload assembly code
; Author:		Jeroen Venema
; Created:		23/10/2022
; Last Updated:	22/03/2023
;
; Modinfo:
; 23/10/2022:	Initial assembly code
; 24/10/2022:	0x00 escape code now contained in keymods, resulting in faster upload baudrate
; 26/11/2022:   Adapted as loadable command
; 10/01/2023:	Major modifications, include new uart code
; 12/01/2023:	Release 1.0, cleanup
; 12/01/2023:	Removed getTransparentByte, created getkey to accomodate MOS API changes

	.include "mos_api.inc"

			.ASSUME	ADL = 1
			SEGMENT CODE
			
			XREF	__putch
			XDEF	_hxload_uart1
			XDEF	_hxload_vdp
			XDEF	_startaddress
			XDEF	_endaddress
			
LOAD_HLU_DEFAULT	.EQU	04h		; 0x040000 default load address

_hxload_uart1:
			PUSH	DE
			PUSH	HL
			PUSH	BC
			
			XOR		A,A
			LD		(hexload_error),A		; clear error counter
			LD		A, 1
			LD		(firstwrite),A			; firstwrite = true	

hxline:
			LD		A, mos_ugetc
			RST.LIL	08h
			JR		NC, uart1closed			; UART1 closed
			CP		':'
			JR		NZ, hxline				; ignore everything except ':' to start the line
			LD		E,0						; reset the checksum byte
			CALL	getbyte					; record length count - D
			LD		D,A
			CALL	getbyte					; relative load address - H
			LD		H,A
			CALL	getbyte					; relative load address - L
			LD		L,A
			CALL	getbyte					; record field type
			CP		0
			JR		Z, hexdata
			CP		1
			JR		Z, hexendfile
			CP		4
			JR		Z, hex_address
			JR		hxline					; ignore all other record types, find next line

hex_address:
			CALL	getbyte					; load and ignore address[31:24] / upper byte
			CALL	getbyte					; load address[23:16]
			LD		(hexload_address + 2),A	; store HLU
			XOR		A,A
			LD		(hexload_address + 1),A	; clear address[15:0] - this will be loaded from record type 0
			LD		(hexload_address),A
			LD		HL, hexload_address
			LD		HL,(HL)					; load assembled address from memory into HL as a pointer
			ld		A,(firstwrite)			; is this the first address we write to?
			CP		A,1
			JR		NZ, $F					; if not, skip storing the first address
			XOR		A,A						; firstwrite = false
			LD		(firstwrite),A
			LD		(_startaddress),HL		; store first address
$$:
			CALL	getbyte					; load checksum
			LD		A,E
			OR		A
			JR		NZ, hexckerr			; checksum error on this line
			JR		hxline
hexdata:
			CALL	getbyte
			LD		(HL),A
			INC		HL
			DEC		D
			JR		NZ, hexdata
			CALL	getbyte					; load checksum byte
			LD		A,E
			OR		A						; sum of all data incl checksum should be zero
			JR		NZ, hexckerr			; checksum error on this line
			LD		(_endaddress), HL		; store end address
			JR		hxline
hexckerr:
			LD		A,(hexload_error)
			INC		A
			LD		(hexload_error),A		; increment error counter
			JR		hxline
	
hexendfile:	
			LD		A,(hexload_error)		; return error counter to caller
			POP		BC
			POP		HL
			POP		DE
			RET

getbyte:
			CALL	getnibble
			RLCA
			RLCA
			RLCA
			RLCA
			LD		B,A
			CALL	getnibble
			OR		B						; combine two nibbles into one byte
			LD		B,A						; save byte to B
			ADD		A,E						; add to checksum
			LD		E,A						; save checksum
			LD		A,B
			RET

getnibble:
			LD		A, mos_ugetc
			RST.LIL	08h
			SUB		'0'
			CP		10
			RET		C						; A<10
			SUB		7						; subtract 'A'-'0' (17) and add 10
			CP		16
			RET		C						; A<'G'
			AND		11011111b				; toUpper()
			RET								; leave any error character in input, checksum will catch it later

uart1closed:
			LD		A,(hexload_error)
			INC		A
			LD		(hexload_error),A		; increment error counter
			JR		hexendfile

; get pointer to sysvars in ixu
getSysvars:
	ld a, mos_sysvars		; MOS call for mos_sysvars
	rst.lil 08h				; returns pointer to sysvars in ixu
	ret

; hxload_vdp received records from the VDP
; each record has
; start - byte - X:Address/Data record, 0:end transmission
; HLU   - byte - high byte address
; H     - byte - medium byte address
; L     - byte - low byte address
; N     - byte - number of databytes to read
; 0     - N-1 - bytes of data
; 
; Last record sent has N == 0, but will send address bytes, no data bytes
_hxload_vdp:
	push	de
	push	bc
	push	ix						; safeguard main ixu
	ld		a, 1
	ld		(firstwrite),a			; firstwrite = true	
	call	getSysvars				; returns pointer to sysvars in ixu

blockloop:
	ld		d,0						; reset checksum
	call	getkey					; ask for start byte
	;push	af
	rst.lil 10h						; send ack
	;pop		af
	or		a
	jr		z, rbdone				; end of transmission received

	add		a,d
	ld		d,a
	call	getkey					; ask for byte HLU
	;push	af
	rst.lil 10h						; send ack
	;pop		af
	ld		(hexload_address+2),a	; store
	add		a,d
	ld		d,a
	call	getkey					; ask for byte H
	;push	af
	rst.lil 10h						; send ack
	;pop		af
	ld		(hexload_address+1),a	; store
	add		a,d
	ld		d,a
	call	getkey					; ask for byte L
	;push	af
	rst.lil 10h						; send ack
	;pop		af
	ld		(hexload_address),a		; store
	add		a,d
	ld		d,a
	
	call	getkey					; ask for number of bytes to receive
	;push	af
	rst.lil 10h						; send ack
	;pop		af
	ld		b,a						; loop counter
	add		a,d
	ld		d,a

	ld		hl, hexload_address		; load address of pointer
	ld		hl, (hl)				; load the (assembled) pointer from memory
	ld		a,(firstwrite)			; is this the first address we write to?
	cp		a,1
	jr		nz, $F					; if not, skip storing the first address
	xor		a,a						; firstwrite = false
	ld		(firstwrite),a
	ld		(_startaddress),hl		; store first address
$$:
	call	getkey		; receive each byte in a
	ld		(hl),a					; store byte in memory
	add		a,d
	ld		d,a
	inc		hl						; next address
	djnz	$B						; next byte
	ld		a,d
	neg								; compute 2s complement from the total checksum						
	rst.lil	10h 					; return to VDP
	ld		(_endaddress), hl		; store end address
	jp		blockloop
	
rbdone:
	pop ix
	pop bc
	pop de
	ret

; get a key from one of the sysvars
; IXU needs to have been set previously
getkey:		PUSH	HL
			PUSH	DE
			LD	HL, IX
			LD	DE, sysvar_vkeycount
			ADD HL, DE			; HL now holds pointer to sysvar_vkeycount
			LD	A, (HL)			; Wait for a change
$$:			CP	(HL)
			JR	Z, $B
			POP DE
			POP	HL 
			LD	A, (ix+sysvar_keyascii)		; Get the key code
			RET

			SEGMENT DATA
hexload_address		DS		3	; 24bit address
hexload_error		DS		1	; error counter
firstwrite			DS		1	; boolean
_startaddress		DS		3	; first address written to
_endaddress			DS		3	; last address written to