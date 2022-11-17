;******************Tiesioginis laikmatis ******************
;********************V. Pavardė************************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus dažnis 4 MHz
;****************************************************** 

;******************************************************
	LIST p=16F84 		;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iškviečiama rinkmena,
						;aprašanti specifinius
						;MV kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF ;suteikiama reikiama
						;konfigūracija MV
;******************************************************

;********************* Kintamieji ***********************
Kint1 EQU 0Ch ;registrą 0Ch pavadinti Kint1
Kint2 EQU 0Dh ;registrą 0Dh pavadinti Kint2
Kint3 EQU 0Eh ;registrą 0Eh pavadinti Kint3
Kint4 EQU 0Fh ;registrą 0Fh pavadinti Kint4
Kint5 EQU 10h ;registrą 10h pavadinti Kint5
;******************************************************

		ORG 0x000 		;nurodomas pradinis programos adresas

		clrf PORTA 		;išvalyti PORTA registrą
		clrf PORTB 		;išvalyti PORTB registrą

		bsf STATUS, 5 	;pereiti į 1 banką

		movlw b’00000000’ ;įrašyti į W registrą dvejetainį
						;skaičių, pateiktą tarp kabučių
		movwf TRISB 	;perkelti W registro turinį į
						;TRISB (nustatyti B prievado
						;išvadus duomenims išvesti)
		movlw b'00001' 	;įrašyti į W registrą dvejetainį
						;skaičių, pateiktą tarp kabučių
		movwf TRISA 	;perkelti W registro turinį į TRISA
						;registrą (nustatyti A prievado
						;RA0 išvadą duomenims įvesti,
						;o RA1, RA2, RA3, RA4
						;išvadus – duomenims išvesti)
		bcf STATUS, 5 	;pereiti į 0 banką 


Start 	call Laikovienetas ;iškviesti paprogramę Laikovienetas
		incf PORTB,1 	;padidinti PORTB registro
						;turinį vienetu
		goto Start 		;pereiti į programos eilutę,
						;pažymėtą žyme Start


;************* Laiko vieneto paprogramė ***************
Laikovienetas
		movlw d‘5‘ 		;įrašyti į W registrą dešimtainį
						;skaičių, pateiktą tarp kabučių
		movwf Kint3 	;perkelti W registro turinį į Kint3
Ciklas1 decfsz Kint1,1 	;atimti 1 iš kintamojo Kint1 ir,
						;kai jis bus lygus nuliui,
						;peršokti komandą goto Ciklas1
		goto Ciklas1 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas1
		btfsc PORTA,0 	;nuskaityti signalą A prievado
						;RA0 išvade, jei jame yra „0“,
						;peršokti kitą komandą
		call Sustabdymas ;iškviesti paprogramę
						;Sustabdymas
		decfsz Kint2,1 	;atimti vienetą iš kintamojo
						;Kint2 ir, kai jis bus lygus nuliui,
						;peršokti komandą goto Ciklas1
		goto Ciklas1 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas1
		decfsz Kint3,1 	;atimti vienetą iš kintamojo
						;Kint3 ir, kai jis bus lygus nuliui,
						;peršokti komandą goto Ciklas1
		goto Ciklas1 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas1
		return 			;grįžti į pagrindinę programą
;******************************************************** 


;***************Sustabdymo paprogramė*****************
	Sustabdymas
Start1 	movlw b’01110’ 	;įrašyti į W registrą
						;dvejetainį skaičių,
						;pateiktą tarp kabučių
		movwf PORTA 	;perkelti W registro turinį į PORTA
Ciklas2 decfsz Kint4,1 	;atimti vienetą iš kintamojo
						;Kint4 ir, kai jis bus lygus nuliui,
						;peršokti komandą goto Ciklas2
		goto Ciklas2 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas2
		decfsz Kint5,1 	;atimti vienetą iš kintamojo
						;Kint5 ir, kai jis bus
						;lygus nuliui, peršokti
						;komandą goto Ciklas2
		goto Ciklas2 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas2
		movlw b’00000’ 	;įrašyti į W registrą dvejetainį
						;skaičių, pateiktą tarp kabučių
		movwf PORTA 	;perkelti W registro turinį į
						;PORTA registrą
Ciklas3 decfsz Kint4,1 	;atimti vienetą iš kintamojo
						;Kint4 ir, kai jis bus
						;lygus nuliui, peršokti
						; komandą goto Ciklas3
		goto Ciklas3 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas3
		decfsz Kint5,1 ;atimti vienetą iš kintamojo
						;Kint5 ir, kai jis bus
						;lygus nuliui, peršokti
						;komandą goto Ciklas3
		goto Ciklas3 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Ciklas3
		goto Start1 	;pereiti į paprogramės eilutę,
						;pažymėtą žyme Start1
		return 			;grįžti į pagrindinę programą
;****************************************************** 


		END ;programos pabaiga 
