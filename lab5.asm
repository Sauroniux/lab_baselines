;*********Zemo daznio impulsinio signalo generatorius ********
;**********************V. Pavarde************************
; Mikrovaldiklis PIC16F84A
; Kvarcinio rezonatoriaus daznis 4 MHz
;********************************************************

#define PUNKTAS 12

#define PUNKTAS_15 PUNKTAS == 15
#define PUNKTAS_18 PUNKTAS == 18
#define PUNKTAS_20 PUNKTAS == 20
#define PUNKTAS_22 PUNKTAS == 22
#define PUNKTAS_23 PUNKTAS == 23

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
		
#if !PUNKTAS_23
	Start	movlw b'11100000' ;irasyti i W registra
							;dvejetaini skaicu,
							;pateikta tarp kabucu
			movwf PORTB 	;perkelti W registro turini i
							;PORTB registra

			call Velinimas 	;iskviesti paprograma Velinimas

	#if PUNKTAS_15 != 0
			swapf PORTB, 1
	#else #if PUNKTAS_18 != 0
			movlw b'00111111' ;įrašyti į W registrą
							;dvejetainį skaičių,
							;pateiktą tarp kabučių
			andwf PORTB, 1 	;atlikti loginę IR operaciją tarp skaičių,
							;esančių W registre ir PORTB registre
	#else #if PUNKTAS_20
			andlw b‘10000000‘ ;atlikti loginę IR operaciją
							;tarp pateikto skaičiaus ir
							;skaičiaus, esančio W registre
			movwf PORTB 	;perkelti W registro turinį
							;į PORTB registrą
	#else #if PUNKTAS_22
			xorlw b'10010101'
			movwf PORTB
	#else
							;Pradine uzduotis
			comf PORTB, 1 	;invertuoti PORTB registro turini
	#endif

			call Velinimas 	;iskviesti paprograma Velinimas
			goto Start 		;pereiti i programos eiluta, pazymeta
							;zyme Start
#else
	Start 	movlw b'00000001' ;įrašyti į W registrą
							;dvejetainį skaičių,
							;pateiktą tarp kabučių
			movwf PORTB 	;perkelti W registro turinį į
							;PORTB registrą
			call Velinimas 	;iškviesti paprogramę
							;Velinimas
			rlf PORTB,1 	;atlikti skaičiaus, esančio
							;registre PORTB,
							;rotaciją į kairę
			call Velinimas
			rlf PORTB,1
			call Velinimas
			rlf PORTB,1
			call Velinimas
			rlf PORTB,1
			call Velinimas
			rlf PORTB,1
			call Velinimas
			rlf PORTB,1
			call Velinimas
			rlf PORTB,1
			call Velinimas
			goto Start 		;pereiti į programos eilutę,
							;pažymėtą žyme Start 
#endif

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