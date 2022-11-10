;***************** Programa skaičiams sumuoti *************
;**********************V. Pavardė************************
; Mikrovaldiklis PIC16F84A.
; Kvarcinio rezonatoriaus dažnis 4 MHz
;******************************************************* 

;********************************************************
	LIST p=16F84 		;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iškviečiama rinkmena,
						;aprašanti specifinius
						;MV kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF
						;suteikiama reikiama
						;konfigūracija MV
;******************************************************** 

;********************* Kintamoji *************************
Kint1 EQU 0Eh 			;registrą 0Eh pavadinti Kint1
;******************************************************** 

		ORG 0x000 		;nurodomas pradinis programos adresas 

		clrf PORTA 		;išvalyti PORTA registrą
		clrf PORTB 		;išvalyti PORTB registrą

		bsf STATUS, 5 	;pereiti į 1 banką

		movlw b’00000000’ ;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf TRISB 	;perkelti W registro turinį į
						;TRISB registrą
		movlw b'00011' 	;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf TRISA 	;perkelti W registro turinį į
						;TRISA registrą
		bcf STATUS, 5 	;pereiti į 0 banką

Start	movlw b’00001100’ ;įrašyti į W registrą 

						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		addlw b’11100001’ ;sumuoti W registro ir pateikto
						;skaičiaus turinius
		movwf PORTB 	;perkelti W registro turinį į
						;PORTB registrą (skaičių suma
						;perkeliama į B prievadą)
		goto Start 		;pereiti į programos eilutę,
						;pažymėtą žyme Start 

END ;programos pabaiga