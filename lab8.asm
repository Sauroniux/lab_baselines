;***Laiko skaiciavimo programa su MV laikmaciu-skaitikliu ****
;**********************V. Pavarde***********************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus da�nis 4 MHz
;******************************************************* 

;******************************************************
	LIST p=16F84 ;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;i�kvieciama rinkmena,
						;apra�anti specifinius
						;MV kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF ;suteikiama reikiama
						;konfiguracija MV
;******************************************************

;**********************Kintamasis ***********************
Kint1 EQU 0Ch ;registra 0Ch pavadinti Kint1
;********************************************************

		ORG 0x000 		;nurodomas pradinis programos adresas 

		clrf PORTA 		;i�valyti PORTA registra
		clrf PORTB 		;i�valyti PORTB registra

		bsf STATUS, 5 	;pereiti i 1 banka

		movlw b'00000000' ;ira�yti i W registra
						;dvejetaini skaiciu,
						;pateikta tarp kabuciu
		movwf TRISB 	;perkelti W registro turini i
						;TRISB registra (nustatyti B
						;prievado i�vadus
						;duomenims i�vesti)
		movlw b'00000' 	;ira�yti i W registra
						;dvejetaini skaiciu,
						;pateikta tarp kabuciu
		movwf TRISA 	;perkelti W registro turini
						;i TRISA registra
						;(nustatyti prievado
						;i�vadus duomenims i�vesti)
		movlw b'00000111' ;ira�yti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf OPTION_REG ;perkelti W registro turini i
						;OPTION_REG registra
		bcf STATUS, 5 	;pereiti i 0 banka

		movlw d'16' 	;ira�yti i W registra
						;de�imtaini skaiciu,
						;pateikta tarp kabuciu
		movwf Kint1 	;perkelti W registro turini
						;i Kint1 registra
Start1 
		movlw d'11' 	;ira�yti i W registra
						;de�imtaini skaiciu,
						;pateikta tarp kabuciu
		movwf TMR0 		;perkelti W registro turini
						;i TMRO registra
Start2
		btfss INTCON,2 	;patikrinti INTCON
						;registro 2 skilti,
						;jei joje yra �1�, per�okti
						;komanda goto Start2
		goto Start2 	;pereiti i programos eilute, 
						;pa�ymeta �yme Start2
		bcf INTCON,2 	;ikelti �0� i INTCON
						;registro 2 skilti (i�valyti
						;T0IF bita kitam ciklui)
		decfsz Kint1,1 	;atimti vieneta i�
						;kintamojo Kint1 ir,
						;kai jis bus lygus nuliui,
						;per�okti komanda
						;goto Start1
		goto Start1 	;pereiti i programos eilute,
						;pa�ymeta �yme Start1
		incf PORTB 		;padidinti PORTB registro
						;turini vienetu
		movlw d'16' 	;ira�yti i W registra
						;de�imtaini skaiciu,
						;pateikta tarp kabuciu
		movwf Kint1 	;perkelti W registro
						;turini i Kint1 registra
		goto Start1 	;pereiti i programos
						;eilute, pa�ymeta
						;�yme Start1
		END ;programos pabaiga

#if 0

;17
;**********************Kintamieji ***********************
Wreg EQU 0Ch ; ;registra 0Ch pavadinti Wreg
Stat EQU 0Dh ;registra 0Dh pavadinti Stat
Kint1 EQU 0Eh ;registra 0Eh pavadinti Kint1
Kint2 EQU 0Fh ;registra 0Fh pavadinti Kint2
Kint3 EQU 10h ;registra 10h pavadinti Kint3
;********************************************************

;19
		goto Pagrindineprogr
;********** *Pertraukties programa laikui skaiciuoti*********

		ORG 0x004 		;pertraukties programos
						;pradinis adresas
		movwf Wreg 		;i�saugoti W registro turini
		movf STATUS,0 	;perkelti STATUS registro turini i W
		movwf Stat 		;i�saugoti STATUS
						;registro turini
		bcf INTCON,2 	;i�valyti (ikelti �0� i) pertraukties
						;po�ymio bito T0IF skilti
		decfsz Kint1,1 	;atimti vieneta i� kintamojo Kint1 ir,
						;kai jis bus lygus nuliui,
						;per�okti komanda goto Ten
		goto Ten 		;pereiti i programos eilute,
						;pa�ymeta �yme Ten
		movlw d'16' 	;ira�yti i W registra de�imtaini
						;skaiciu, pateikta tarp kabuciu
		movwf Kint1 	;perkelti W registro turini
						;i Kint1 registra
		incf PORTB,1 	;padidinti PORTB registro
						;turini vienetu
Ten
		movlw d'12' 	;ira�yti i W registra de�imtaini
						;skaiciu, pateikta tarp kabuciu
		movwf TMR0 		;perkelti W registro turini
						;i TMR0 registra
		movf Stat,0 	;perkelti Stat registro
						;turini i W registra
		movwf STATUS 	;perkelti W registro turini
						;i STATUS (atkurti
						;STATUS registro turini)
		movf Wreg,0 	;atkurti W registro turini
		retfie 			;gri�ti i pagrindine programa
;*******************************************************
Pagrindineprogr

;20
		bcf STATUS,5 	;pereiti i 0 banka
		movlw d'12' 	;ira�yti i W registra
						;de�imtaini skaiciu,
						;pateikta tarp kabuciu
						;(TMRO pradine verte)
		movwf TMR0 		;perkelti W registro turini 
						;i TMR0 registra
		movlw d'16' 	;ira�yti i W registra
						;de�imtaini skaiciu,
						;pateikta tarp kabuciu
		movwf Kint1 	;perkelti W registro turini
						;i Kint1 registra
		clrf INTCON 	;i�valyti INTCON registra
		bsf STATUS, 5 	;pereiti i 1 banka
		movlw b'11000111' ;ira�yti i W registra
						;dvejetaini skaiciu,
						;pateikta tarp kabuciu
		movwf OPTION_REG ;perkelti W registro turini i
						;OPTION_REG registra
						;(suteikti konfiguracija
						;OPTION_REG registrui)
		bcf STATUS, 5 	;pereiti i 0 banka
		bsf INTCON, T0IE ;ikelti �1� i INTCON registro T0IE bito
						;skilti (leisti pertraukti,
						;persipild�ius TMR0 registrui)
		bsf INTCON, GIE ;leisti visas pertrauktis

;21
;**************�emo da�nio impulsu generatorius***********
Start
		movlw b'01110' 	;ira�yti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf PORTA 			;perkelti W registro turini
						;i PORTA registra
Ciklas1
		decfsz Kint2,1 	;atimti vieneta i� kintamojo
						;Kint2 ir, kai jis bus lygus nuliui,
						;per�okti komanda goto Ciklas1
		goto Ciklas1 	;pereiti i programos eilute,
						;pa�ymeta �yme Ciklas1
		decfsz Kint3,1 	;atimti vieneta i� kintamojo
						;Kint3 ir, kai jis bus lygus nuliui,
						;per�okti komanda goto Ciklas1
		goto Ciklas1 	;pereiti i programos eilute,
						;pa�ymeta �yme Ciklas1
		movlw b'00000' 	;ira�yti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf PORTA 	;perkelti W registro turini
						;i PORTA registra
Ciklas2
		decfsz Kint2,1 	;atimti vieneta i� kintamojo
						;Kint2 ir, kai jis bus
						;lygus nuliui, per�okti
						;komanda goto Ciklas2
		goto Ciklas2 	;pereiti i programos eilute,
						;pa�ymeta �yme Ciklas2
		decfsz Kint3,1 ;atimti vieneta i� kintamojo
						;Kint3 ir, kai jis bus
						;lygus nuliui, per�okti
						;komanda goto Ciklas2
		goto Ciklas2 	;pereiti i programos eilute,
						;pa�ymeta �yme Ciklas2
		goto Start 		;pereiti i programos eilute,
						;pa�ymeta �yme Start
		END 			;programos pabaiga

#endif