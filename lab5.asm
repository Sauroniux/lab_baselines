;*********Zemo daznio impulsinio signalo generatorius ********
;**********************V. Pavarde************************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus daznis 4 MHz
;********************************************************

;********************************************************
	LIST p=16F84 		;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iskviecama rinkmena,
						;aprasanti specifinius MV
						;kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF 			;suteikiama reikiama
						;konfiguracija MV
;******************************************************** 


;******************** Kintamieji **********************
Kint1 EQU 0Dh ;registra 0Dh pavadinti Kint1
Kint2 EQU 0Eh ;registra 0Eh pavadinti Kint2
;********************************************************

		ORG 0x000 		;nurodomas pradinis programos adresas 

		clrf PORTA 		;isvalyti PORTA registra
		clrf PORTB 		;isvalyti PORTB registra

		bsf STATUS, 5 	;pereiti i 1 banka

		movlw b'00000000' ;irasyti i W registra
						;dvejetaini skaicu,
						;pateikta tarp kabucu
		movwf TRISB 	;perkelti W registro turini i
						;TRISB registra
		bcf STATUS, 5 	;pereiti i 0 banka
Start	movlw b'11100000' ;irasyti i W registra
						;dvejetaini skaicu,
						;pateikta tarp kabucu
		movwf PORTB 	;perkelti W registro turini i
						;PORTB registra

		call Velinimas 	;iskviesti paprograma Velinimas

		comf PORTB, 1 	;invertuoti PORTB registro turini

		call Velinimas 	;iskviesti paprograma Velinimas
		goto Start 		;pereiti i programos eiluta, pazymeta
						;zyme Start

;*************************Paprograme********************
Velinimas
Ciklas	decfsz Kint1, 1 ;atimti vieneta is kintamojo
						;Kint1 ir, kai jis bus
						;lygus nuliui, persokti
						;komanda goto Ciklas
		goto Ciklas 	;pereiti i paprogrames eiluta,
						;pazymeta zyme Ciklas
		decfsz Kint2, 1 ;atimti vieneta is kintamojo
						;Kint2 ir, kai jis bus
						;lygus nuliui, persokti
						;komanda goto Ciklas
		goto Ciklas 	;pereiti i paprogrames eiluta,
						;pazymeta zyme Ciklas
		return 			;grizti i pagrindina programa
;******************************************************** 


	END ;programos pabaiga 