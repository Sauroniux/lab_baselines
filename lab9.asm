;***************LCD indikatoriaus valdymas **************
;**********************V. Pavarde***********************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus dažnis 4 MHz
;****************************************************** 

;******************************************************
	LIST p=16F84 ;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;iškvieciama rinkmena,
						;aprašanti specifinius
						;MV kintamuosius
	__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF ;suteikiama reikiama konfiguracija MV
;***************************************************** 

;***********************Kintamieji ******************
Kint0 EQU 0Ch ;registra 0Ch pavadinti Kint0
Kint1 EQU 0Dh ;registra 0Dh pavadinti Kint1
Kint2 EQU 0Eh ;registra 0Eh pavadinti Kint2
Kint3 EQU 0Fh ;registra 0Fh pavadinti Kint3
Kint4 EQU 10h ;registra 10h pavadinti Kint4
Kint5 EQU 11h ;registra 11h pavadinti Kint5
Kint6 EQU 12h ;registra 12h pavadinti Kint6
;****************************************************** 

;********************* Pastoviosios **********************
E EQU 2 				;pastoviajai E priskirta verte 2
						;(indikatoriaus išvada E valdys A
						;prievado išvadas RA2)
RS EQU 3 				;pastoviajai RS priskirta verte 3
						;(indikatoriaus išvada RS valdys A
						;prievado išvadas RA3)
;******************************************************

		ORG 0x000 		;nurodomas pradinis programos adresas 

		clrf PORTA 		;išvalyti PORTA registra
		clrf PORTB 		;išvalyti PORTB registra
		clrf Kint1 		;išvalyti Kint1 registra
		clrf Kint3 		;išvalyti Kint3 registra
		clrf Kint5 		;išvalyti Kint5 registra

		bsf STATUS, 5 	;pereiti i 1 banka 

		movlw b'00000000' ;irašyti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf TRISB 	;perkelti W registro turini i TRISB
						;registra (nustatyti prievado
						;išvadus duomenims išvesti)
		movlw b'00000' 	;irašyti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf TRISA 	;perkelti W registro turini i TRISA
						;registra (nustatyti prievado
						;išvadus duomenims išvesti)
		bcf OPTION_REG,7 ;prijungti prie B prievado
						;išvadu vidinius rezistorius
		bcf STATUS, 5 	;pereiti i 0 banka

;*****************LCD darbo iniciacija*******************
		call Velin200ms ;sulaukti pereinamuju procesu pabaigos
		movlw b'00110000' ;irašyti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		call Komanda 	;iškviesti paprograme, vykdancia
						;komanda indikatoriui
		call Velin5ms 	;iškviesti 5 ms velinimo paprograme
		movlw b'00110000'
		call Komanda
		call Velin5ms
		movlw b'00110000'
		call Komanda
		call Velin5ms
		movlw b'00111000' ;bendravimas su MV 8 linijomis
		call Komanda 	;2 eiluciu LCD tašku skaicius ženkle 5x8
		call Velin5ms
		movlw b'00001000' ;išjungti indikatoriu
		call Komanda
		call Velin5ms
		movlw b'00000001' ;išvalyti indikatoriu
		call Komanda
		call Velin5ms
		movlw b'00000100'
		call Komanda
		call Velin5ms 

		movlw b'00001100' ;ijungti indikatoriu, žymekli ir
		call Komanda 	;atjungti žymeklio mirgejima
		call Velin5ms

;***********************Ženklu ivedimas****************
		movlw b'00000001' ;išvalyti indikatoriu
		call Komanda
		call Velin5ms
		movlw b'10000100' ;nurodomas DDRAM
						;adresas ženklo kodui irašyti
		call Komanda
		call Velin100mks
		movlw 'A' 		;nurodomas irašomo ženklo kodas
		call Duomenys 	;iškviesti paprograme, vykdancia
						;duomenu i indikatoriu ikelima
		call Velin100mks
		goto $ 			;amžinasis ciklas, apimantis
						;tik šia komanda

;**************Komandos paprograme************
Komanda
		bcf PORTA,RS 	;pereiti i komandu irašymo režima
		movwf PORTB 	;perduoti komanda i indikatoriu
		nop
		nop
		bsf PORTA,E 	;irašyti komanda
		nop
		nop
		nop
		bcf PORTA,E 	;ignoruoti signalus iš MV
		nop
		nop
		return 

;******Duomenu (rodomo ženklo kodo) ikelimo paprograme***
Duomenys
		bsf PORTA,RS 	;pereiti i duomenu irašymo režima
		movwf PORTB
		nop
		nop
		bsf PORTA,E 	;irašyti duomenis
		nop
		nop
		nop
		bcf PORTA,E 	;ignoruoti signalus iš MV
		nop
		nop
		return 

;***************Velinimo ciklu paprogrames*************
;********100 mks velinimas******
Velin100mks
		movlw d'33'
		movwf Kint0
ciklas0
		decfsz Kint0,1
		goto ciklas0
		return
;********5 ms velinimas**********
Velin5ms
		movlw d'7'
		movwf Kint2
ciklas2
		decfsz Kint1,1
		goto ciklas2
decfsz
		Kint2,1
		goto ciklas2
		return
;********200 ms velinimas*********
Velin200ms
ciklas3
		decfsz Kint1,1
		goto ciklas3
		decfsz Kint3,1 
		goto ciklas3
		return
;*******0,8–200 ms velinimas******
Velin1
		movlw d'19'
		movwf Kint4
ciklas4
		decfsz Kint1,1
		goto ciklas4
		decfsz Kint4,1
		goto ciklas4
		return
;********0,2–50 s velinimas**********
Velin2
		movlw d'5'
		movwf Kint6
ciklas5
		decfsz Kint1,1
		goto ciklas5
		decfsz Kint5,1
		goto ciklas5
		decfsz Kint6,1
		goto ciklas5
		return
;*************************************************

		END ;programos pabaiga 


#if 0
;21
		call Velin2 ;iškviesti velinimo paprograme
		movlw b'00011000' ;perstumti ženkla i kaire
		call Komanda
		call Velin5ms
		call Velin2
		goto Start 

#endif