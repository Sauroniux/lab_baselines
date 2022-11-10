;*********Žemo dažnio impulsinio signalo generatorius ********
;**********************V. Pavardė************************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus dažnis 4 MHz
;********************************************************

;********************************************************
	LIST p=16F84 		;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iškviečiama rinkmena,
						;aprašanti specifinius MV
						;kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON &
	_CP_OFF 			;suteikiama reikiama
						;konfigūracija MV
;******************************************************** 


;******************** Kintamieji **********************
Kint1 EQU 0Dh ;registrą 0Dh pavadinti Kint1
Kint2 EQU 0Eh ;registrą 0Eh pavadinti Kint2
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
		bcf STATUS, 5 	;pereiti į 0 banką
Start	movlw b’11100000’ ;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf PORTB 	;perkelti W registro turinį į
						;PORTB registrą

		call Velinimas 	;iškviesti paprogramę Velinimas

		comf PORTB, 1 	;invertuoti PORTB registro turinį

		call Velinimas 	;iškviesti paprogramę Velinimas
		goto Start 		;pereiti į programos eilutę, pažymėtą
						;žyme Start

;*************************Paprogramė********************
	Velinimas
Ciklas	decfsz Kint1, 1 ;atimti vienetą iš kintamojo
						;Kint1 ir, kai jis bus
						;lygus nuliui, peršokti
						;komandą goto Ciklas
		goto Ciklas 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas
		decfsz Kint2, 1 ;atimti vienetą iš kintamojo
						;Kint2 ir, kai jis bus
						;lygus nuliui, peršokti
						;komandą goto Ciklas
		goto Ciklas 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas
		return 			;grįžti į pagrindinę programą
;******************************************************** 


END ;programos pabaiga 