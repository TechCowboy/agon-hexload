PORT			EQU	%D0			; UART1			
REG_RBR:		EQU	PORT+0		; Receive buffer
REG_THR:		EQU	PORT+0		; Transmitter holding
REG_DLL:		EQU	PORT+0		; Divisor latch low
REG_IER:		EQU	PORT+1		; Interrupt enable
REG_DLH:		EQU	PORT+1		; Divisor latch high
REG_IIR:		EQU	PORT+2		; Interrupt identification
REG_FCT			EQU	PORT+2;		; Flow control
REG_LCR:		EQU	PORT+3		; Line control
REG_MCR:		EQU	PORT+4		; Modem control
REG_LSR:		EQU	PORT+5		; Line status
REG_MSR:		EQU	PORT+6		; Modem status
REG_SCR:		EQU PORT+7		; Scratch

TX_WAIT			EQU	16384 		; Count before a TX times out

UART_LSR_ERR	EQU %80			; Error
UART_LSR_ETX	EQU %40			; Transmit empty
UART_LSR_ETH	EQU	%20			; Transmit holding register empty
UART_LSR_RDY	EQU	%01			; Data ready

			.ASSUME	ADL = 1
			SEGMENT CODE
			
			XDEF	_uart1_handler
			
_uart1_handler:		
			DI
			PUSH	AF
			IN0		A,(REG_LSR)			; Get the line status register
			AND		UART_LSR_RDY		; Check for characters in buffer
			JR		Z, $F				; Nothing received
			LD		A,1
			LD		(uart1_received),A
			IN0		A,(REG_RBR)			; Read the character from the UART receive buffer
			LD		(uart1_buffer),A
			POP		AF
			EI
			RETI.L
$$:			; No character received
			XOR 	A,A
			LD		(uart1_received),A			
			POP		AF
			EI
			RETI.L	
				
			SEGMENT DATA
			
uart1_buffer		DEFB	1	; 64 byte receive buffer
uart1_received		DEFB	1	; boolean