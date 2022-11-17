;***************** Programa skaicçiams sumuoti *************
;**********************V. Pavarde************************
; Mikrovaldiklis PIC16F84A.
; Kvarcinio rezonatoriaus daznis 4 MHz
;******************************************************* 

;********************************************************
	LIST p=16F84 		;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iskviecçiama rinkmena,
						;aprasanti specifinius
						;MV kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF
						;suteikiama reikiama
						;konfiguracija MV
;******************************************************** 

;********************* Kintamoji *************************
Kint1 EQU 0Eh 			;registra 0Eh pavadinti Kint1
;******************************************************** 

		ORG 0x000 		;nurodomas pradinis programos adresas 

		clrf PORTA 		;isvalyti PORTA registra
		clrf PORTB 		;isvalyti PORTB registra

		bsf STATUS, 5 	;pereiti i 1 banka

		movlw b'00000000' ;irasyti i W registra
						;dvejetaini skaicçiu,
						;pateikta tarp kabucçiu
		movwf TRISB 	;perkelti W registro turini i
						;TRISB registra
		movlw b'00011' 	;irasyti i W registra
						;dvejetaini skaicçiu,
						;pateikta tarp kabucçiu
		movwf TRISA 	;perkelti W registro turini i
						;TRISA registra
		bcf STATUS, 5 	;pereiti i 0 banka

Start
#define STAGE 0	
#if STAGE == 0
		movlw b'00001100' ;irasyti i W registra 

						;dvejetaini skaicçiu,
						;pateikta tarp kabucçiu
		addlw b'11100001' ;sumuoti W registro ir pateikto
						;skaicçiaus turinius
#else #if STAGE == 1
		movlw b'00000010'						
		sublw b'00000101'
						
#endif
		movwf PORTB 	;perkelti W registro turini i
						;PORTB registra (skaicçiu suma
						;perkeliama i B prievada)
		goto Start 		;pereiti i programos eilute,
						;pazymeta zyme Start 

END ;programos pabaiga

#ifdef ANTRA_DALIS

;***********************Kintamieji *********************
Skai1 EQU 0Ch ;registra 0Ch pavadinti Skai1
Skai2 EQU 0Dh ;registra 0Dh pavadinti Skai2
Kint1 EQU 0Eh ;registra 0Eh pavadinti Kint1
;******************************************************** 

		ORG 0x000 		;nurodomas pradinis programos adresas 

		clrf PORTA 		;isvalyti PORTA registra
		clrf PORTB 		;isvalyti PORTB registra

		bsf STATUS, 5 	;pereiti i 1 banka

		movlw b'00000000' ;irasyti i W registra
						;dvejetaini skaicçiu,
						;pateikta tarp kabucçiu
		movwf TRISB 	;perkelti W registro turini i
						;TRISB registra
		movlw b'00011' 	;irasyti i W registra
						;dvejetaini skaicçiu,
						;pateikta tarp kabucçiu
		movwf TRISA 	;perkelti W registro turini i
						;TRISA registra
		bcf STATUS, 5 	;pereiti i 0 banka
		
		Start movlw bí00010001í ;nustatyti Skai2 verte
		movwf Skai2 	;perkelti skaiciu i
						;Skai2 registra
		movlw bë01100010ë ;nustatyti Skai1 verte
		movwf Skai1 	;perkelti skaiciu i
						;Skai1 registra
		movf Skai1,0 	;perkelti Skai1 turini
						;i W registra
		movwf PORTB 	;perkelti Skai1 turini
						;i PORTB registra
		btfss PORTA,0 	;patikrinti A prievado RA0
						;iövado itampos lygi, jei jis
						;atitinka Ñ1ì itampa,
						;peröokti kita komanda
		call papr1 		;iökviesti paprograme papr1
		btfss PORTA,1 	;patikrinti A prievado RA1
						;iövado itampos lygi, jei jis
						;atitinka Ñ1ì itampa,
						;peröokti kita komanda
		call papr2 		;iökviesti paprograme papr2
						;(apskaiciuoti Skai1 ir Skai2 suma)
		call Velinimas ;iökviesti paprograme Velinimas

		goto Start 		;pereiti i programos eilute,
						;paûymeta ûyme Start



;*****************1 paprograme***********************
	papr1
		movf Skai2,0 	;perkelti Skai2 turini i W registra
		movwf PORTB 	;perkelti W registro
						;turini i PORTB
		return 			;griûti i pagrindine programa
;*****************************************************

;****************2 paprograme**************************
	papr2
		movf Skai2,0 	;perkelti Skai2 turini i W registra
		addwf Skai1,0 	;sumuoti Skai1 ir Skai2 turinius,
						;suma ikelti i W registra
		movwf PORTB 	;perkelti W registro turini i PORTB
		return 			;griûti i pagrindine programa
;******************************************************

;*******************3 paprograme************************
	Velinimas
Ciklas decfsz Kint1,1 	;atimti vieneta iö kintamojo 
						;Kint1 ir, kai jis
						;bus lygus nuliui,
						;peröokti komanda goto Ciklas
		goto Ciklas 	;pereiti i programos eilute,
						;paûymeta ûyme Ciklas
		return 			;griûti i pagrindine programa
;*******************************************************

#endif
