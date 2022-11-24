;***************LCD indikatoriaus valdymas **************
;**********************V. Pavarde***********************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus da�nis 4 MHz
;****************************************************** 

;******************************************************
	LIST p=16F84 ;nustatomas MV tipas
	#INCLUDE <p16F84a.inc> ;i�kvieciama rinkmena,
						;apra�anti specifinius
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
						;(indikatoriaus i�vada E valdys A
						;prievado i�vadas RA2)
RS EQU 3 				;pastoviajai RS priskirta verte 3
						;(indikatoriaus i�vada RS valdys A
						;prievado i�vadas RA3)
;******************************************************

		ORG 0x000 		;nurodomas pradinis programos adresas 

		clrf PORTA 		;i�valyti PORTA registra
		clrf PORTB 		;i�valyti PORTB registra
		clrf Kint1 		;i�valyti Kint1 registra
		clrf Kint3 		;i�valyti Kint3 registra
		clrf Kint5 		;i�valyti Kint5 registra

		bsf STATUS, 5 	;pereiti i 1 banka 

		movlw b'00000000' ;ira�yti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf TRISB 	;perkelti W registro turini i TRISB
						;registra (nustatyti prievado
						;i�vadus duomenims i�vesti)
		movlw b'00000' 	;ira�yti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		movwf TRISA 	;perkelti W registro turini i TRISA
						;registra (nustatyti prievado
						;i�vadus duomenims i�vesti)
		bcf OPTION_REG,7 ;prijungti prie B prievado
						;i�vadu vidinius rezistorius
		bcf STATUS, 5 	;pereiti i 0 banka

;*****************LCD darbo iniciacija*******************
		call Velin200ms ;sulaukti pereinamuju procesu pabaigos
		movlw b'00110000' ;ira�yti i W registra dvejetaini
						;skaiciu, pateikta tarp kabuciu
		call Komanda 	;i�kviesti paprograme, vykdancia
						;komanda indikatoriui
		call Velin5ms 	;i�kviesti 5 ms velinimo paprograme
		movlw b'00110000'
		call Komanda
		call Velin5ms
		movlw b'00110000'
		call Komanda
		call Velin5ms
		movlw b'00111000' ;bendravimas su MV 8 linijomis
		call Komanda 	;2 eiluciu LCD ta�ku skaicius �enkle 5x8
		call Velin5ms
		movlw b'00001000' ;i�jungti indikatoriu
		call Komanda
		call Velin5ms
		movlw b'00000001' ;i�valyti indikatoriu
		call Komanda
		call Velin5ms
		movlw b'00000100'
		call Komanda
		call Velin5ms 

		movlw b'00001100' ;ijungti indikatoriu, �ymekli ir
		call Komanda 	;atjungti �ymeklio mirgejima
		call Velin5ms

;***********************�enklu ivedimas****************
		movlw b'00000001' ;i�valyti indikatoriu
		call Komanda
		call Velin5ms
		movlw b'10000100' ;nurodomas DDRAM
						;adresas �enklo kodui ira�yti
		call Komanda
		call Velin100mks
		movlw 'A' 		;nurodomas ira�omo �enklo kodas
		call Duomenys 	;i�kviesti paprograme, vykdancia
						;duomenu i indikatoriu ikelima
		call Velin100mks
		goto $ 			;am�inasis ciklas, apimantis
						;tik �ia komanda

;**************Komandos paprograme************
Komanda
		bcf PORTA,RS 	;pereiti i komandu ira�ymo re�ima
		movwf PORTB 	;perduoti komanda i indikatoriu
		nop
		nop
		bsf PORTA,E 	;ira�yti komanda
		nop
		nop
		nop
		bcf PORTA,E 	;ignoruoti signalus i� MV
		nop
		nop
		return 

;******Duomenu (rodomo �enklo kodo) ikelimo paprograme***
Duomenys
		bsf PORTA,RS 	;pereiti i duomenu ira�ymo re�ima
		movwf PORTB
		nop
		nop
		bsf PORTA,E 	;ira�yti duomenis
		nop
		nop
		nop
		bcf PORTA,E 	;ignoruoti signalus i� MV
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
;*******0,8�200 ms velinimas******
Velin1
		movlw d'19'
		movwf Kint4
ciklas4
		decfsz Kint1,1
		goto ciklas4
		decfsz Kint4,1
		goto ciklas4
		return
;********0,2�50 s velinimas**********
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
		call Velin2 ;i�kviesti velinimo paprograme
		movlw b'00011000' ;perstumti �enkla i kaire
		call Komanda
		call Velin5ms
		call Velin2
		goto Start 

#endif