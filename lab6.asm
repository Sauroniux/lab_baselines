;***************** Programa skaic�iams sumuoti *************
;**********************V. Pavarde************************
; Mikrovaldiklis PIC16F84A.
; Kvarcinio rezonatoriaus daznis 4 MHz
;******************************************************* 

;********************************************************
	LIST p=16F84 		;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iskviec�iama rinkmena,
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
						;dvejetaini skaic�iu,
						;pateikta tarp kabuc�iu
		movwf TRISB 	;perkelti W registro turini i
						;TRISB registra
		movlw b'00011' 	;irasyti i W registra
						;dvejetaini skaic�iu,
						;pateikta tarp kabuc�iu
		movwf TRISA 	;perkelti W registro turini i
						;TRISA registra
		bcf STATUS, 5 	;pereiti i 0 banka

Start
#define STAGE 0	
#if STAGE == 0
		movlw b'00001100' ;irasyti i W registra 

						;dvejetaini skaic�iu,
						;pateikta tarp kabuc�iu
		addlw b'11100001' ;sumuoti W registro ir pateikto
						;skaic�iaus turinius
#else #if STAGE == 1
		movlw b'00000010'						
		sublw b'00000101'
						
#endif
		movwf PORTB 	;perkelti W registro turini i
						;PORTB registra (skaic�iu suma
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
						;dvejetaini skaic�iu,
						;pateikta tarp kabuc�iu
		movwf TRISB 	;perkelti W registro turini i
						;TRISB registra
		movlw b'00011' 	;irasyti i W registra
						;dvejetaini skaic�iu,
						;pateikta tarp kabuc�iu
		movwf TRISA 	;perkelti W registro turini i
						;TRISA registra
		bcf STATUS, 5 	;pereiti i 0 banka
		
		Start movlw b�00010001� ;nustatyti Skai2 verte
		movwf Skai2 	;perkelti skaiciu i
						;Skai2 registra
		movlw b�01100010� ;nustatyti Skai1 verte
		movwf Skai1 	;perkelti skaiciu i
						;Skai1 registra
		movf Skai1,0 	;perkelti Skai1 turini
						;i W registra
		movwf PORTB 	;perkelti Skai1 turini
						;i PORTB registra
		btfss PORTA,0 	;patikrinti A prievado RA0
						;i�vado itampos lygi, jei jis
						;atitinka �1� itampa,
						;per�okti kita komanda
		call papr1 		;i�kviesti paprograme papr1
		btfss PORTA,1 	;patikrinti A prievado RA1
						;i�vado itampos lygi, jei jis
						;atitinka �1� itampa,
						;per�okti kita komanda
		call papr2 		;i�kviesti paprograme papr2
						;(apskaiciuoti Skai1 ir Skai2 suma)
		call Velinimas ;i�kviesti paprograme Velinimas

		goto Start 		;pereiti i programos eilute,
						;pa�ymeta �yme Start



;*****************1 paprograme***********************
	papr1
		movf Skai2,0 	;perkelti Skai2 turini i W registra
		movwf PORTB 	;perkelti W registro
						;turini i PORTB
		return 			;gri�ti i pagrindine programa
;*****************************************************

;****************2 paprograme**************************
	papr2
		movf Skai2,0 	;perkelti Skai2 turini i W registra
		addwf Skai1,0 	;sumuoti Skai1 ir Skai2 turinius,
						;suma ikelti i W registra
		movwf PORTB 	;perkelti W registro turini i PORTB
		return 			;gri�ti i pagrindine programa
;******************************************************

;*******************3 paprograme************************
	Velinimas
Ciklas decfsz Kint1,1 	;atimti vieneta i� kintamojo 
						;Kint1 ir, kai jis
						;bus lygus nuliui,
						;per�okti komanda goto Ciklas
		goto Ciklas 	;pereiti i programos eilute,
						;pa�ymeta �yme Ciklas
		return 			;gri�ti i pagrindine programa
;*******************************************************

#endif
