;************DuomenÅ³ Ä¯raÅ¡ymas Ä¯ MV prievadus ***********
;**********************V. PavardÄ—***********************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus daÅ¾nis 4 MHz
;****************************************************** 


	list p=16F84A

	#include <p16F84a.inc>

	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF; 

		ORG 0x000
		clrf PORTA ;išvalyti PORTA registra
		clrf PORTB ;išvalyti PORTB registra
		
		bsf STATUS, 5 ;pereiti i 1 banka
		
		movlw b'00000000' ;irašyti i W registra
		 ;dvejetaini skaiciu,
		 ;pateikta tarp kabuciu
		movwf TRISB ;perkelti W registro
		 ;turini i B prievada
					
		movlw b'00011'
		movwf TRISA
					
		bcf STATUS, 5 ;pereiti i 0 banka 

		movlw b'01010101'
		movwf PORTB
		
		movlw b'00110'
		movwf PORTA
		

		;movlw b'11111111' ;irašyti i W registra
		;dvejetaini skaiciu,
		;pateikta tarp kabuciu
		;movwf PORTB ;perkelti W registro
		;turini i B prievada
		
		
		
		END ;programos pabaiga