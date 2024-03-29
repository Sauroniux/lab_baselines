;*Žemo dažnio signalų generatoriaus programa su paprograme**
;*******************V. Pavardė***************************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus dažnis 4 MHz
;********************************************************

;********************************************************
	LIST p=16F84 		;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iškviečiama rinkmena,
						;aprašanti specifinius
						;MV kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF; ;suteikiama reikiama
;konfigūracija MV
;******************************************************** 


;**********************Kintamieji*******************
Kint1 EQU 0Ch 			;registrą 0Ch pavadinti Kint1
Kint2 EQU 0Dh 			;registrą 0Dh pavadinti Kint2
Kint3 EQU 0Eh 			;registrą 0Eh pavadinti Kint3
Kint4 EQU 0Fh 			;registrą 0Fh pavadinti Kint4
;********************************************************

		ORG 0x000 		;nurodomas pradinis programos adresas 

		clrf PORTA 		;išvalyti PORTA registrą
		clrf PORTB 		;išvalyti PORTB registrą

		bsf STATUS, 5 	;pereiti į 1 banką

		movlw b'00000000' ;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf TRISB 	;perkelti W registro turinį į
						;TRISB registrą
		movlw b'11111' 	;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf TRISA 	;perkelti W registro turinį į
						;TRISA registrą
		bcf STATUS, 5 	;pereiti į 0 banką
		
		
Start 	
		movlw b'11111111' 	
		btfsc PORTA,1 
		movlw b'10101010'

		movwf PORTB 	;perkelti W registro turinį į
						;PORTB registrą

		;btfss PORTA,0 
		movlw d'50' 	
		btfsc PORTA,0 
		movlw d'25'
		;įrašyti į W registrą
						;dešimtainį skaičių,
						;pateiktą tarp kabučių
		movwf Kint1 	;perkelti W registro turinį į
						;Kint1 registrą
Ciklas1	
			;nuskaityti įėjimo
						;signalą A prievado
						;išvade RA0, jei jame
						;yra „1“, vykdyti kitą
						;programos komandą,
						;jei „0“ – ją peršokti ir vykdyti
						;po jos einančią komandą
		call desimtms 	;iškviesti paprogramę desimtms
		decfsz Kint1,1 	;atimti vienetą iš kintamojo
						;Kint1 ir, kai jis bus
						;lygus nuliui, peršokti
						;komandą goto Ciklas1
		goto Ciklas1 	;pereiti į programos eilutę,
						;pažymėtą žyme Ciklas1
		
		movlw b'00000000' 	
		btfsc PORTA,1 
		movlw b'01010101'
		
		movwf PORTB 	;perkelti W registro turinį į
						;PORTB registrą
		;btfss PORTA,0 
		movlw d'50' 	
		btfsc PORTA,0 
		movlw d'25'
						;dešimtainį skaičių,
						;pateiktą tarp kabučių
		movwf Kint2 	;perkelti W registro turinį į
						;Kint2 registrą
Ciklas2
		;btfsc PORTA,0 	;nuskaityti įėjimo
						;signalą A prievado
						;išvade RA0, jei jame
						;yra „1“, vykdyti kitą
						;programos komandą,
						;jei „0“ – ją peršokti ir vykdyti
						;po jos einančią komandą
		call desimtms 	;iškviesti paprogramę desimtms
		decfsz Kint2,1 	;atimti vienetą iš kintamojo
						;Kint2 ir, kai jis bus
						;lygus nuliui, peršokti
						;komandą goto Ciklas2
		goto Ciklas2 	;pereiti į programos eilutę,
						;pažymėtą žyme Ciklas2
		goto Start 		;pereiti į programos eilutę,
						;pažymėtą žyme Start





;*******************10 ms velinimo paprograme**********
desimtms
		movlw d'13' ;irayti i W registra deimtaini
						;skaiciu, pateikta tarp kabuciu
		movwf Kint4 ;perkelti W registro turini i
						;Kint4 registra
Ciklas	decfsz Kint3,1 ;atimti vieneta i kintamojo
						;Kint3 ir, kai jis bus lygus nuliui,
						;perokti komanda goto Ciklas
		goto Ciklas ;pereiti i paprogrames eilute,
						;paymeta yme Ciklas
		decfsz Kint4,1 ;atimti vieneta i kintamojo
						;Kint4 ir, kai jis bus lygus nuliui,
						;perokti komanda goto Ciklas
		goto Ciklas ;pereiti i paprogrames eilute,
						;paymeta yme Ciklas
		return ;griti i programa
;******************************************************

END 					;programos pabaiga 