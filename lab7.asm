;******************Tiesioginis laikmatis ******************
;********************V. Pavarde************************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus daznis 4 MHz
;****************************************************** 

;******************************************************
	LIST p=16F84 		;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iskvieciama rinkmena,
						;aprasanti specifinius
						;MV kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF ;suteikiama reikiama
						;konfiguracija MV
;******************************************************

;********************* Kintamieji ***********************
Kint1 EQU 0Ch ;registra 0Ch pavadinti Kint1
Kint2 EQU 0Dh ;registra 0Dh pavadinti Kint2
Kint3 EQU 0Eh ;registra 0Eh pavadinti Kint3
Kint4 EQU 0Fh ;registra 0Fh pavadinti Kint4
Kint5 EQU 10h ;registra 10h pavadinti Kint5
;******************************************************

		ORG 0x000 		;nurodomas pradinis programos adresas

		clrf PORTA 		;isvalyti PORTA registra
		clrf PORTB 		;isvalyti PORTB registra

		bsf STATUS, 5 	;pereiti i 1 banka

		movlw b'00000000' ;irasyti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf TRISB 	;perkelti W registro turini i
						;TRISB (nustatyti B prievado
						;isvadus duomenims isvesti)
		movlw b'00001' 	;irasyti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf TRISA 	;perkelti W registro turini i TRISA
						;registra (nustatyti A prievado
						;RA0 isvada duomenims ivesti,
						;o RA1, RA2, RA3, RA4
						;isvadus – duomenims isvesti)
		bcf STATUS, 5 	;pereiti i 0 banka 


		movlw d'15' 	;įrašyti į W registrą
						;dešimtainį skaičių,
						;pateiktą tarp kabučių
						;(nustatyti atgalinio
						;laikmačio pradinį laiką)
		movwf PORTB 	;perkelti W registro turinį į
						;PORTB registrą
Start
		call Laikovienetas ;iškviesti paprogramę
						;Laikovienetas
		
		;decf PORTB,1
		decfsz PORTB,1
		goto Start 		;jei PRTB != 0, sokti i Start

		movlw d'15'
		movwf PORTB
		goto Start

		call Sustabdymas ;sustabdom jei PORTB gavosi 0, nes persokom goto

						;pažymėtą žyme Start 

						;Sustabdymas 

;************* Laiko vieneto paprograme ***************
Laikovienetas
		movlw d'1'		;irasyti i W registra desimtaini
						;skaiciu, pateikta tarp kabuciu
		movwf Kint3 	;perkelti W registro turini i Kint3
Ciklas1 decfsz Kint1,1 	;atimti 1 is kintamojo Kint1 ir,
						;kai jis bus lygus nuliui,
						;persokti komanda goto Ciklas1
		goto Ciklas1 	;pereiti i paprogrames eilutę,
						;pazymeta zyme Ciklas1
		
		decfsz Kint2,1 	;atimti vieneta is kintamojo
						;Kint2 ir, kai jis bus lygus nuliui,
						;persokti komanda goto Ciklas1
		goto Ciklas1 	;pereiti i paprogrames eilutę,
						;pazymeta zyme Ciklas1
		decfsz Kint3,1 	;atimti vieneta is kintamojo
						;Kint3 ir, kai jis bus lygus nuliui,
						;persokti komanda goto Ciklas1
		goto Ciklas1 	;pereiti i paprogrames eilutę,
						;pazymeta zyme Ciklas1
						
		btfsc PORTA,0 	;nuskaityti signala A prievado
						;RA0 isvade, jei jame yra „0“,
						;persokti kita komanda
		call Sustabdymas ;iskviesti paprogramę
						;Sustabdymas
						
		return 			;grizti i pagrindinę programa
;******************************************************** 


;***************Sustabdymo paprograme*****************
	Sustabdymas
Start1 	movlw b'01110' 	;irasyti i W registra
						;dvejetaini skaiciu,
						;pateikta tarp kabuciu
		movwf PORTA 	;perkelti W registro turini i PORTA
Ciklas2 decfsz Kint4,1 	;atimti vieneta is kintamojo
						;Kint4 ir, kai jis bus lygus nuliui,
						;persokti komanda goto Ciklas2
		goto Ciklas2 	;pereiti i paprogrames eilutę,
						;pazymeta zyme Ciklas2
		decfsz Kint5,1 	;atimti vieneta is kintamojo
						;Kint5 ir, kai jis bus
						;lygus nuliui, persokti
						;komanda goto Ciklas2
		goto Ciklas2 	;pereiti i paprogrames eilutę,
						;pazymeta zyme Ciklas2
		movlw b'00000' 	;irasyti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf PORTA 	;perkelti W registro turini i
						;PORTA registra
Ciklas3 decfsz Kint4,1 	;atimti vieneta is kintamojo
						;Kint4 ir, kai jis bus
						;lygus nuliui, persokti
						; komanda goto Ciklas3
		goto Ciklas3 	;pereiti i paprogrames eilutę,
						;pazymeta zyme Ciklas3
		decfsz Kint5,1 ;atimti vieneta is kintamojo
						;Kint5 ir, kai jis bus
						;lygus nuliui, persokti
						;komanda goto Ciklas3
		goto Ciklas3 	;pereiti i paprogrames eilutę,
						;pazymeta zyme Ciklas3
		goto Start1 	;pereiti i paprogrames eilutę,
						;pazymeta zyme Start1
		return 			;grizti i pagrindinę programa
;****************************************************** 


		END ;programos pabaiga 
