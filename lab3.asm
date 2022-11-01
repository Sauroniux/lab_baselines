;**************Aukšto dažnio signalų generatorius **********

;**********************A. Simkus***********************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus dažnis 4 MHz
;******************************************************

;******************************************************
	LIST p=16F84 			;nustatomas MV tipas
	#INCLUDE <p16F84a.inc>	;iškviečiama rinkmena,
						;aprašanti specifinius
						;MV kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON &
	_CP_OFF; 				;suteikiama reikiama
						;konfigūracija MV
;******************************************************

		ORG 0x000 		;nustatomas pradinis programos adresas 

		clrf PORTA 		;išvalyti PORTA registrą
		clrf PORTB 		;išvalyti PORTB registrą

		bsf STATUS, 5 	;pereiti į 1 banką

		movlw b’00000000’ ;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf TRISB 	;perkelti W registro turinį į
						;TRISB registrą
		movlw b’00000’ 	;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf TRISA 	;perkelti W
						;registro turinį į
						;TRISA registrą
		bcf STATUS, 5 	;pereiti į 0 banką
		movlw b’11111’ 	;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf PORTA 	;perkelti W registro turinį į
						;PORTA registrą
Start 	movlw b’11111111’ ;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf PORTB 	;perkelti W registro turinį į
						;PORTB registrą


		movlw b’00000000’ ;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf PORTB 	;perkelti W registro turinį į B
						;prievadą

		goto Start 		;pereiti į programos eilutę, pažymėtą žyme Start

END 					;programos pabaiga 