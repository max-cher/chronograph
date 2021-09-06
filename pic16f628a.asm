
; CC5X Version 3.7C, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  14. Aug 2020  11:55  *************

        processor  16F628A
        radix  DEC

        __config 0x3F02

INDF        EQU   0x00
STATUS      EQU   0x03
FSR         EQU   0x04
PORTA       EQU   0x05
TRISA       EQU   0x85
PORTB       EQU   0x06
TRISB       EQU   0x86
PCLATH      EQU   0x0A
INTCON      EQU   0x0B
Carry       EQU   0
Zero_       EQU   2
RP0         EQU   5
RP1         EQU   6
T0IF        EQU   2
T0IE        EQU   5
GIE         EQU   7
OPTION_REG  EQU   0x81
PIR1        EQU   0x0C
TMR1L       EQU   0x0E
TMR1H       EQU   0x0F
T1CON       EQU   0x10
T2CON       EQU   0x12
CCP1CON     EQU   0x17
CMCON       EQU   0x1F
PIE1        EQU   0x8C
EEDATA      EQU   0x9A
EEADR       EQU   0x9B
EECON1      EQU   0x9C
EECON2      EQU   0x9D
PEIE        EQU   6
TMR1IF      EQU   0
TMR2IF      EQU   1
TMR1ON      EQU   0
TMR2ON      EQU   2
TMR1IE      EQU   0
TMR2IE      EQU   1
w_tmp       EQU   0x70
st_tmp      EQU   0x71
pc_tmp      EQU   0x72
tmp8        EQU   0x73
tmp16       EQU   0x74
TMR1LL      EQU   0x76
TMR1HH      EQU   0x78
TMR2H       EQU   0x7A
PORTB_tmp   EQU   0x7B
char0       EQU   0x2E
char1       EQU   0x2F
char2       EQU   0x30
char3       EQU   0x31
d           EQU   0x32
shots       EQU   0x33
mass        EQU   0x34
v0          EQU   0x35
v1          EQU   0x36
v2          EQU   0x37
v3          EQU   0x38
e0          EQU   0x39
e1          EQU   0x3A
e2          EQU   0x3B
e3          EQU   0x3C
m0          EQU   0x3D
m1          EQU   0x3E
m2          EQU   0x3F
counter8    EQU   0x40
tmp32HH     EQU   0x41
tmp32HL     EQU   0x42
tmp32LH     EQU   0x43
tmp32LL     EQU   0x44
tmpHL       EQU   0x48
tmpLH       EQU   0x49
tmpLL       EQU   0x4A
result      EQU   0x4E
counter16   EQU   0x50
enrg_H      EQU   0x52
enrg_L      EQU   0x54
tmr1flag    EQU   0
V_nE        EQU   1
M           EQU   2
blink       EQU   3
c9          EQU   0x20
c8          EQU   0x21
c7          EQU   0x22
c6          EQU   0x23
c5          EQU   0x24
c4          EQU   0x25
c3          EQU   0x26
c2          EQU   0x27
c1          EQU   0x28
c0          EQU   0x29
dly_val     EQU   0x2A
dly_val0    EQU   0x2B
dly_val1    EQU   0x2C
tmp_delay   EQU   0x7F
result_tail EQU   0x2A
lh          EQU   0x2B
lm          EQU   0x2C
ll          EQU   0x2D
C1cnt       EQU   0x2A
C2tmp       EQU   0x2B
vhh         EQU   0x2A
vhl         EQU   0x2B
vlh         EQU   0x2C
vll         EQU   0x2D
vhh_2       EQU   0x2A
vhl_2       EQU   0x2B
vlh_2       EQU   0x2C
vll_2       EQU   0x2D
value       EQU   0x2A
value_2     EQU   0x2A

        GOTO main

  ; FILE pic16f628a.c
                        ;// no comments for you
                        ;// it was hard to write
                        ;// so it should be hard to read
                        ;
                        ;#include "D:\cc5x\16f628a.h"
                        ;#include "D:\cc5x\INLINE.H"
                        ;#include "main.h"
                        ;
                        ;#pragma origin 0x04
        ORG 0x0004
                        ;interrupt isr(void)
                        ;{
isr
                        ;//
                        ;	w_tmp = W;
        MOVWF w_tmp
                        ;	W = swap(STATUS);
        SWAPF STATUS,W
                        ;	st_tmp = W;
        MOVWF st_tmp
                        ;	pc_tmp = PCLATH;
        MOVF  PCLATH,W
        MOVWF pc_tmp
                        ;//#pragma update_RP 0
                        ;//
                        ;	STATUS = 0;
        CLRF  STATUS
                        ;	PCLATH = 0;
        CLRF  PCLATH
                        ;//
                        ;	
                        ;	if(T0IF && T0IE)	//TMR0 int
        BTFSS 0x0B,T0IF
        GOTO  m028
        BTFSS 0x0B,T0IE
        GOTO  m028
                        ;	{
                        ;		T0IF = 0;
        BCF   0x0B,T0IF
                        ;		
                        ;		if(M) // show mass
        BTFSS 0x56,M
        GOTO  m012
                        ;		{
                        ;			switch(d)
        MOVF  d,W
        BTFSC 0x03,Zero_
        GOTO  m001
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m004
        XORLW 3
        BTFSC 0x03,Zero_
        GOTO  m007
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m010
        GOTO  m011
                        ;			{
                        ;				case 0:
                        ;				{
                        ;					d = 1;
m001    MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;					PORTB = 0;
        CLRF  PORTB
                        ;					PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;					if(blink && counter8 == 0)
        BTFSS 0x56,blink
        GOTO  m002
        MOVF  counter8,1
        BTFSS 0x03,Zero_
        GOTO  m002
                        ;						PORTA |= 0x0a;
        MOVLW 10
        IORWF PORTA,1
                        ;					else
        GOTO  m003
                        ;						PORTA |= m0;
m002    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  m0,W
        IORWF PORTA,1
                        ;					PORTB |= 0b10000010; // dp
m003    MOVLW 130
        BCF   0x03,RP0
        BCF   0x03,RP1
        IORWF PORTB,1
                        ;					break;
        GOTO  m027
                        ;				}
                        ;				
                        ;				case 1:
                        ;				{
                        ;					d = 2;
m004    MOVLW 2
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;					PORTB = 0;
        CLRF  PORTB
                        ;					PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;					if(blink && counter8 == 1)
        BTFSS 0x56,blink
        GOTO  m005
        DECFSZ counter8,W
        GOTO  m005
                        ;						PORTA |= 0x0a;
        MOVLW 10
        IORWF PORTA,1
                        ;					else
        GOTO  m006
                        ;						PORTA |= m1;
m005    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  m1,W
        IORWF PORTA,1
                        ;					PORTB |= 0b00000100;
m006    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   PORTB,2
                        ;					break;
        GOTO  m027
                        ;				}
                        ;				
                        ;				case 2:
                        ;				{
                        ;					d = 3;
m007    MOVLW 3
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;					PORTB = 0;
        CLRF  PORTB
                        ;					PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;					if(blink && counter8 == 2)
        BTFSS 0x56,blink
        GOTO  m008
        MOVF  counter8,W
        XORLW 2
        BTFSS 0x03,Zero_
        GOTO  m008
                        ;						PORTA |= 0x0a;
        MOVLW 10
        IORWF PORTA,1
                        ;					else
        GOTO  m009
                        ;						PORTA |= m2;
m008    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  m2,W
        IORWF PORTA,1
                        ;					PORTB |= 0b00001000;
m009    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   PORTB,3
                        ;					break;
        GOTO  m027
                        ;				}
                        ;				
                        ;				case 3:
                        ;				{
                        ;					d = 0;
m010    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  d
                        ;					PORTB = 0;
        CLRF  PORTB
                        ;					PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;					PORTA |= 0x0a;
        MOVLW 10
        IORWF PORTA,1
                        ;					PORTB |= 0b00000001;
        BSF   PORTB,0
                        ;					break;
        GOTO  m027
                        ;				}
                        ;				
                        ;				default:
                        ;					d = 0;
m011    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  d
                        ;			}
                        ;		}
                        ;		else // show energy or speed
        GOTO  m027
                        ;		{
                        ;			if(V_nE) // show speed
m012    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x56,V_nE
        GOTO  m018
                        ;			{
                        ;				switch(d)
        MOVF  d,W
        BTFSC 0x03,Zero_
        GOTO  m013
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m014
        XORLW 3
        BTFSC 0x03,Zero_
        GOTO  m015
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m016
        GOTO  m017
                        ;				{
                        ;					case 0:
                        ;					{
                        ;						d = 1;
m013    MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;						PORTB = 0;
        CLRF  PORTB
                        ;						PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;						PORTA |= v1;
        MOVF  v1,W
        IORWF PORTA,1
                        ;						PORTB |= 0b00000010;
        BSF   PORTB,1
                        ;						break;
        GOTO  m027
                        ;					}
                        ;					
                        ;					case 1:
                        ;					{
                        ;						d = 2;
m014    MOVLW 2
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;						PORTB = 0;
        CLRF  PORTB
                        ;						PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;						PORTA |= v2;
        MOVF  v2,W
        IORWF PORTA,1
                        ;						PORTB |= 0b10000100; // dp
        MOVLW 132
        IORWF PORTB,1
                        ;						break;
        GOTO  m027
                        ;					}
                        ;					
                        ;					case 2:
                        ;					{
                        ;						d = 3;
m015    MOVLW 3
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;						PORTB = 0;
        CLRF  PORTB
                        ;						PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;						PORTA |= v3;
        MOVF  v3,W
        IORWF PORTA,1
                        ;						PORTB |= 0b00001000;
        BSF   PORTB,3
                        ;						break;
        GOTO  m027
                        ;					}
                        ;					
                        ;					case 3:
                        ;					{
                        ;						d = 0;
m016    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  d
                        ;						PORTB = 0;
        CLRF  PORTB
                        ;						PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;						PORTA |= v0;
        MOVF  v0,W
        IORWF PORTA,1
                        ;						PORTB |= 0b00000001;
        BSF   PORTB,0
                        ;						break;
        GOTO  m027
                        ;					}
                        ;					
                        ;					default:
                        ;						d = 0;
m017    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  d
                        ;				}
                        ;			}
                        ;			else 		// show energy
        GOTO  m027
                        ;			{
                        ;				switch(d)
m018    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  d,W
        BTFSC 0x03,Zero_
        GOTO  m019
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m021
        XORLW 3
        BTFSC 0x03,Zero_
        GOTO  m023
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m024
        GOTO  m026
                        ;				{
                        ;					case 0:
                        ;					{
                        ;						d = 1;
m019    MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;						PORTB = 0;
        CLRF  PORTB
                        ;						PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;						PORTA |= e1;
        MOVF  e1,W
        IORWF PORTA,1
                        ;						if(e1.7)
        BTFSS e1,7
        GOTO  m020
                        ;							PORTB |= 0b10000010; // dp
        MOVLW 130
        IORWF PORTB,1
                        ;						else
        GOTO  m027
                        ;							PORTB |= 0b00000010;
m020    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   PORTB,1
                        ;						break;
        GOTO  m027
                        ;					}
                        ;					
                        ;					case 1:
                        ;					{
                        ;						d = 2;
m021    MOVLW 2
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;						PORTB = 0;
        CLRF  PORTB
                        ;						PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;						PORTA |= e2;
        MOVF  e2,W
        IORWF PORTA,1
                        ;						if(e2.7)
        BTFSS e2,7
        GOTO  m022
                        ;							PORTB |= 0b10000100;
        MOVLW 132
        IORWF PORTB,1
                        ;						else
        GOTO  m027
                        ;							PORTB |= 0b00000100;
m022    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   PORTB,2
                        ;						break;
        GOTO  m027
                        ;					}
                        ;					
                        ;					case 2:
                        ;					{
                        ;						d = 3;
m023    MOVLW 3
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF d
                        ;						PORTB = 0;
        CLRF  PORTB
                        ;						PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;						PORTA |= e3;
        MOVF  e3,W
        IORWF PORTA,1
                        ;						PORTB |= 0b10001000;	// dp
        MOVLW 136
        IORWF PORTB,1
                        ;						break;
        GOTO  m027
                        ;					}
                        ;					
                        ;					case 3:
                        ;					{
                        ;						d = 0;
m024    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  d
                        ;						PORTB = 0;
        CLRF  PORTB
                        ;						PORTA &= 0xf0;
        MOVLW 240
        ANDWF PORTA,1
                        ;						PORTA |= e0;
        MOVF  e0,W
        IORWF PORTA,1
                        ;						if(e0.7)
        BTFSS e0,7
        GOTO  m025
                        ;							PORTB |= 0b10000001;
        MOVLW 129
        IORWF PORTB,1
                        ;						else
        GOTO  m027
                        ;							PORTB |= 0b00000001;
m025    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   PORTB,0
                        ;						break;
        GOTO  m027
                        ;					}
                        ;					
                        ;					default:
                        ;						d = 0;
m026    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  d
                        ;				}
                        ;			}
                        ;		}
                        ;		
                        ;		T0IF = 0;
m027    BCF   0x0B,T0IF
                        ;	}
                        ;	
                        ;	if(TMR1IF && TMR1IE)	//TMR1 int
m028    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x0C,TMR1IF
        GOTO  m029
        BSF   0x03,RP0
        BTFSS 0x8C,TMR1IE
        GOTO  m029
                        ;	{
                        ;		TMR1IF = 0;
        BCF   0x03,RP0
        BCF   0x0C,TMR1IF
                        ;		TMR1HH++;
        INCF  TMR1HH,1
                        ;		if(TMR1HH == 0x32)
        MOVF  TMR1HH,W
        XORLW 50
        BTFSC 0x03,Zero_
                        ;			tmr1flag = 1;
        BSF   0x56,tmr1flag
                        ;	}
                        ;	
                        ;	if(TMR2IF && TMR2IE)	//TMR2 int
m029    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x0C,TMR2IF
        GOTO  m034
        BSF   0x03,RP0
        BTFSS 0x8C,TMR2IE
        GOTO  m034
                        ;	{
                        ;		TMR2IF = 0;
        BCF   0x03,RP0
        BCF   0x0C,TMR2IF
                        ;		
                        ;		TMR2H--;
        DECFSZ TMR2H,1
                        ;		if(TMR2H == 0)
        GOTO  m034
                        ;		{
                        ;			if(M)
        BTFSS 0x56,M
        GOTO  m032
                        ;			{
                        ;				if(blink)
        BTFSS 0x56,blink
        GOTO  m030
                        ;					blink = 0;
        BCF   0x56,blink
                        ;				else
        GOTO  m031
                        ;					blink = 1;
m030    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x56,blink
                        ;			TMR2H = 0x16;
m031    MOVLW 22
        MOVWF TMR2H
                        ;			}
                        ;			else
        GOTO  m034
                        ;			{
                        ;				TMR2H = 0;
m032    CLRF  TMR2H
                        ;				if(V_nE)
        BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x56,V_nE
        GOTO  m033
                        ;				{
                        ;					V_nE = 0;
        BCF   0x56,V_nE
                        ;					TMR2H = 0x48;
        MOVLW 72
        MOVWF TMR2H
                        ;				}
                        ;				else
        GOTO  m034
                        ;				{
                        ;					V_nE = 1;
m033    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x56,V_nE
                        ;					TMR2H = 0x48;
        MOVLW 72
        MOVWF TMR2H
                        ;				}
                        ;			}
                        ;		}
                        ;	}
                        ;//
                        ;//#pragma update_RP 1
                        ;	PCLATH = pc_tmp;
m034    MOVF  pc_tmp,W
        MOVWF PCLATH
                        ;	STATUS = swap(st_tmp);
        SWAPF st_tmp,W
        MOVWF STATUS
                        ;	w_tmp = swap(w_tmp);
        SWAPF w_tmp,1
                        ;	W = swap(w_tmp);
        SWAPF w_tmp,W
                        ;//
                        ;}
        RETFIE
                        ;
                        ;
                        ;void delay(u8 dly_val);
                        ;void delay_50u(void);
                        ;void calc_value8(u8 value);
                        ;void calc_value16(u16 value);
                        ;void calc_value32();
                        ;void calc_char(void);
                        ;void div_24_24(void);
                        ;void correct_mass(void);
                        ;void calc_enrg(void);
                        ;void mul_10(void);
                        ;
                        ;
                        ;void main(void)
                        ;{
main
                        ;	STATUS=0;
        CLRF  STATUS
                        ;	CMCON = 0b00000111;
        MOVLW 7
        MOVWF CMCON
                        ;	TRISA = 0b00000000;//
        BSF   0x03,RP0
        CLRF  TRISA
                        ;	TRISB = 0b01110000;//
        MOVLW 112
        MOVWF TRISB
                        ;	OPTION_REG = 0b11000100;//0x8c;
        MOVLW 196
        MOVWF OPTION_REG
                        ;	CCP1CON = 0x00;
        BCF   0x03,RP0
        CLRF  CCP1CON
                        ;	
                        ;	PIE1 = 0x00;
        BSF   0x03,RP0
        CLRF  PIE1
                        ;	PIR1 = 0x00;
        BCF   0x03,RP0
        CLRF  PIR1
                        ;	INTCON = 0x00;
        CLRF  INTCON
                        ;	T1CON = 0b00000000;
        CLRF  T1CON
                        ;	TMR1L = 0x00;
        CLRF  TMR1L
                        ;	TMR1H = 0x00;
        CLRF  TMR1H
                        ;	
                        ;	T2CON = 0b01111011;
        MOVLW 123
        MOVWF T2CON
                        ;	PEIE = 1;
        BSF   0x0B,PEIE
                        ;	T0IE = 1;
        BSF   0x0B,T0IE
                        ;	TMR1IE = 1;
        BSF   0x03,RP0
        BSF   0x8C,TMR1IE
                        ;	TMR2IE = 1;
        BSF   0x8C,TMR2IE
                        ;	GIE = 1;
        BSF   0x0B,GIE
                        ;	TMR2ON = 1;
        BCF   0x03,RP0
        BSF   0x12,TMR2ON
                        ;	
                        ;	char0 = 0;
        CLRF  char0
                        ;	char1 = 0;
        CLRF  char1
                        ;	char2 = 0;
        CLRF  char2
                        ;	char3 = 0;
        CLRF  char3
                        ;	
                        ;	v0 = 0;
        CLRF  v0
                        ;	v1 = 0;
        CLRF  v1
                        ;	v2 = 0;
        CLRF  v2
                        ;	v3 = 0;
        CLRF  v3
                        ;	
                        ;	e0 = 0;
        CLRF  e0
                        ;	e1 = 0;
        CLRF  e1
                        ;	e2 = 0;
        CLRF  e2
                        ;	e3 = 0;
        CLRF  e3
                        ;	
                        ;	m0 = 0;
        CLRF  m0
                        ;	m1 = 0;
        CLRF  m1
                        ;	m2 = 0;
        CLRF  m2
                        ;	
                        ;	d = 0;
        CLRF  d
                        ;	V_nE = 0;
        BCF   0x56,V_nE
                        ;	M = 1;
        BSF   0x56,M
                        ;	blink = 0;
        BCF   0x56,blink
                        ;	shots = 0;
        CLRF  shots
                        ;	
                        ;	///////////////////////////////////
                        ;	
                        ;	//e0 = 0x0a;
                        ;	
                        ;	EEADR = 0x00;
        BSF   0x03,RP0
        CLRF  EEADR
                        ;	EECON1.RD = 1;
        BSF   EECON1,0
                        ;	while(EECON1.RD) continue;
m035    BSF   0x03,RP0
        BCF   0x03,RP1
        BTFSC EECON1,0
        GOTO  m035
                        ;	mass = EEDATA;
        BSF   0x03,RP0
        BCF   0x03,RP1
        MOVF  EEDATA,W
        BCF   0x03,RP0
        MOVWF mass
                        ;	calc_value8(mass);
        MOVF  mass,W
        CALL  calc_value8
                        ;	m0 = c0;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c0,W
        MOVWF m0
                        ;	m1 = c1;
        MOVF  c1,W
        MOVWF m1
                        ;	m2 = c2;
        MOVF  c2,W
        MOVWF m2
                        ;	
                        ;	if(b0 || b1)
        BTFSC PORTB,6
        GOTO  m036
        BTFSC PORTA,5
                        ;	{
                        ;		correct_mass();
m036    CALL  correct_mass
                        ;	}
                        ;	
                        ;	calc_value8(mass);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  mass,W
        CALL  calc_value8
                        ;	m0 = c0;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c0,W
        MOVWF m0
                        ;	m1 = c1;
        MOVF  c1,W
        MOVWF m1
                        ;	m2 = c2;
        MOVF  c2,W
        MOVWF m2
                        ;			// 429 4967 295
                        ;	///////////////////////////////////
                        ;	
                        ;	
                        ;	while (1)
                        ;	{
                        ;		TMR1L = 0x00;
m037    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  TMR1L
                        ;		TMR1H = 0x00;
        CLRF  TMR1H
                        ;		TMR1HH = 0x0000;
        CLRF  TMR1HH
                        ;		TMR1LL = 0x0000;
        CLRF  TMR1LL
        CLRF  TMR1LL+1
                        ;		TMR1ON = 0;
        BCF   0x10,TMR1ON
                        ;		TMR1IF = 0;
        BCF   0x0C,TMR1IF
                        ;		tmr1flag = 0;
        BCF   0x56,tmr1flag
                        ;		PORTB_tmp = 0x00;
        CLRF  PORTB_tmp
                        ;		
                        ;		while(!PORTB_tmp.4 && !PORTB_tmp.5)	// waiting for start	| forward or backward
m038    BTFSC PORTB_tmp,4
        GOTO  m039
        BTFSC PORTB_tmp,5
        GOTO  m039
                        ;		{
                        ;			PORTB_tmp = PORTB;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  PORTB,W
        MOVWF PORTB_tmp
                        ;			if(b0 && b1)
        BTFSS PORTB,6
        GOTO  m038
        BTFSS PORTA,5
        GOTO  m038
                        ;			{
                        ;				correct_mass();
        CALL  correct_mass
                        ;			}
                        ;		}
        GOTO  m038
                        ;		
                        ;		TMR1ON = 1;
m039    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x10,TMR1ON
                        ;		T0IE = 0;
        BCF   0x0B,T0IE
                        ;		PORTB &= 0xf0;
        MOVLW 240
        ANDWF PORTB,1
                        ;		M = 0;
        BCF   0x56,M
                        ;		
                        ;		if(PORTB_tmp.5)
        BTFSS PORTB_tmp,5
        GOTO  m041
                        ;		{
                        ;			while(!PORTB_tmp.4 && !tmr1flag) PORTB_tmp = PORTB;	// waiting for stop | forward
m040    BTFSC PORTB_tmp,4
        GOTO  m042
        BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC 0x56,tmr1flag
        GOTO  m042
        MOVF  PORTB,W
        MOVWF PORTB_tmp
        GOTO  m040
                        ;		}
                        ;		else
                        ;		{
                        ;			while(!PORTB_tmp.5 && !tmr1flag) PORTB_tmp = PORTB;	// waiting for stop	| backward
m041    BTFSC PORTB_tmp,5
        GOTO  m042
        BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC 0x56,tmr1flag
        GOTO  m042
        MOVF  PORTB,W
        MOVWF PORTB_tmp
        GOTO  m041
                        ;		}
                        ;		
                        ;		TMR1ON = 1;
m042    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x10,TMR1ON
                        ;		T0IE = 1;
        BSF   0x0B,T0IE
                        ;		
                        ;		if(tmr1flag)		// timer counted?
        BTFSS 0x56,tmr1flag
        GOTO  m043
                        ;		{
                        ;			TMR2ON = 0;
        BCF   0x12,TMR2ON
                        ;			tmr1flag = 0;
        BCF   0x56,tmr1flag
                        ;			
                        ;			v0 = 0;
        CLRF  v0
                        ;			v1 = 0;
        CLRF  v1
                        ;			v2 = 0;
        CLRF  v2
                        ;			v3 = 0;
        CLRF  v3
                        ;			
                        ;			e0 = 0;
        CLRF  e0
                        ;			e1 = 0;
        CLRF  e1
                        ;			e2 = 0;
        CLRF  e2
                        ;			e3 = 0;
        CLRF  e3
                        ;			
                        ;			delay(1);
        MOVLW 1
        CALL  delay
                        ;			
                        ;			T0IE = 0;
        BCF   0x0B,T0IE
                        ;			PORTB &= 0xf0;
        MOVLW 240
        BCF   0x03,RP0
        BCF   0x03,RP1
        ANDWF PORTB,1
                        ;			delay(1);
        MOVLW 1
        CALL  delay
                        ;			T0IE = 1;
        BSF   0x0B,T0IE
                        ;			
                        ;			delay(1);
        MOVLW 1
        CALL  delay
                        ;			
                        ;			T0IE = 0;
        BCF   0x0B,T0IE
                        ;			PORTB &= 0xf0;
        MOVLW 240
        BCF   0x03,RP0
        BCF   0x03,RP1
        ANDWF PORTB,1
                        ;			delay(1);
        MOVLW 1
        CALL  delay
                        ;			T0IE = 1;
        BSF   0x0B,T0IE
                        ;		}
                        ;		else 				// 2nd sensor?
        GOTO  m058
                        ;		{
                        ;			shots++;
m043    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  shots,1
                        ;			
                        ;			div_24_24();
        CALL  div_24_24
                        ;			calc_value16(result);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  result,W
        MOVWF value
        MOVF  result+1,W
        MOVWF value+1
        CALL  calc_value16
                        ;			
                        ;			TMR2ON = 1;
        BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x12,TMR2ON
                        ;			if(c1)
        MOVF  c1,1
        BTFSC 0x03,Zero_
        GOTO  m044
                        ;				v0 = c1;
        MOVF  c1,W
        MOVWF v0
                        ;			else
        GOTO  m045
                        ;				v0 = 0x0a;
m044    MOVLW 10
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF v0
                        ;			
                        ;			if(c2 || c1)
m045    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c2,1
        BTFSS 0x03,Zero_
        GOTO  m046
        MOVF  c1,1
        BTFSC 0x03,Zero_
        GOTO  m047
                        ;				v1 = c2;
m046    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c2,W
        MOVWF v1
                        ;			else
        GOTO  m048
                        ;				v1 = 0x0a;
m047    MOVLW 10
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF v1
                        ;			
                        ;			v2 = c3;
m048    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c3,W
        MOVWF v2
                        ;			
                        ;			v3 = c4;
        MOVF  c4,W
        MOVWF v3
                        ;			
                        ;			//result = 10;////
                        ;			
                        ;			calc_enrg();
        CALL  calc_enrg
                        ;		
                        ;			tmp32HH = enrg_H.high8;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  enrg_H+1,W
        MOVWF tmp32HH
                        ;			tmp32HL = enrg_H.low8;
        MOVF  enrg_H,W
        MOVWF tmp32HL
                        ;			tmp32LH = enrg_L.high8;
        MOVF  enrg_L+1,W
        MOVWF tmp32LH
                        ;			tmp32LL = enrg_L.low8;
        MOVF  enrg_L,W
        MOVWF tmp32LL
                        ;			
                        ;			calc_value32();
        CALL  calc_value32
                        ;			
                        ;			{				// magic
                        ;				if(c9 > 5)
        MOVLW 6
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF c9,W
        BTFSS 0x03,Carry
        GOTO  m049
                        ;				{
                        ;					c8++;
        INCF  c8,1
                        ;					if(c8 == 0x0a)
        MOVF  c8,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m049
                        ;					{
                        ;						c8 = 0;
        CLRF  c8
                        ;						c7++;
        INCF  c7,1
                        ;						if(c7 == 0x0a)
        MOVF  c7,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m049
                        ;						{
                        ;							c7 = 0;
        CLRF  c7
                        ;							c6++;
        INCF  c6,1
                        ;							if(c6 == 0x0a)
        MOVF  c6,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m049
                        ;							{
                        ;								c6 = 0;
        CLRF  c6
                        ;								c5++;
        INCF  c5,1
                        ;								if(c5 == 0x0a)
        MOVF  c5,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m049
                        ;								{
                        ;									c5 = 0;
        CLRF  c5
                        ;									c4++;
        INCF  c4,1
                        ;									if(c4 == 0x0a)
        MOVF  c4,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m049
                        ;									{
                        ;										c4 = 0;
        CLRF  c4
                        ;										c3++;
        INCF  c3,1
                        ;										if(c3 == 0x0a)
        MOVF  c3,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m049
                        ;										{
                        ;											c3 = 0;
        CLRF  c3
                        ;											c2++;
        INCF  c2,1
                        ;											if(c2 == 0x0a)
        MOVF  c2,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m049
                        ;											{
                        ;												c2 = 0;
        CLRF  c2
                        ;												c1++;
        INCF  c1,1
                        ;												if(c1 == 0x0a)
        MOVF  c1,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m049
                        ;												{
                        ;													c1 = 0;
        CLRF  c1
                        ;													c0++;
        INCF  c0,1
                        ;												}
                        ;											}
                        ;										}
                        ;									}
                        ;								}
                        ;							}
                        ;						}
                        ;					}
                        ;				}
                        ;				
                        ;				if(c8 > 5)
m049    MOVLW 6
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF c8,W
        BTFSS 0x03,Carry
        GOTO  m050
                        ;				{
                        ;					c7++;
        INCF  c7,1
                        ;					if(c7 == 0x0a)
        MOVF  c7,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m050
                        ;					{
                        ;						c7 = 0;
        CLRF  c7
                        ;						c6++;
        INCF  c6,1
                        ;						if(c6 == 0x0a)
        MOVF  c6,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m050
                        ;						{
                        ;							c6 = 0;
        CLRF  c6
                        ;							c5++;
        INCF  c5,1
                        ;							if(c5 == 0x0a)
        MOVF  c5,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m050
                        ;							{
                        ;								c5 = 0;
        CLRF  c5
                        ;								c4++;
        INCF  c4,1
                        ;								if(c4 == 0x0a)
        MOVF  c4,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m050
                        ;								{
                        ;									c4 = 0;
        CLRF  c4
                        ;									c3++;
        INCF  c3,1
                        ;									if(c3 == 0x0a)
        MOVF  c3,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m050
                        ;									{
                        ;										c3 = 0;
        CLRF  c3
                        ;										c2++;
        INCF  c2,1
                        ;										if(c2 == 0x0a)
        MOVF  c2,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m050
                        ;										{
                        ;											c2 = 0;
        CLRF  c2
                        ;											c1++;
        INCF  c1,1
                        ;											if(c1 == 0x0a)
        MOVF  c1,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m050
                        ;											{
                        ;												c1 = 0;
        CLRF  c1
                        ;												c0++;
        INCF  c0,1
                        ;											}
                        ;										}
                        ;									}
                        ;								}
                        ;							}
                        ;						}
                        ;					}
                        ;				}
                        ;				
                        ;				if(c7 > 5)
m050    MOVLW 6
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF c7,W
        BTFSS 0x03,Carry
        GOTO  m051
                        ;				{
                        ;					c6++;
        INCF  c6,1
                        ;					if(c6 == 0x0a)
        MOVF  c6,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m051
                        ;					{
                        ;						c6 = 0;
        CLRF  c6
                        ;						c5++;
        INCF  c5,1
                        ;						if(c5 == 0x0a)
        MOVF  c5,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m051
                        ;						{
                        ;							c5 = 0;
        CLRF  c5
                        ;							c4++;
        INCF  c4,1
                        ;							if(c4 == 0x0a)
        MOVF  c4,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m051
                        ;							{
                        ;								c4 = 0;
        CLRF  c4
                        ;								c3++;
        INCF  c3,1
                        ;								if(c3 == 0x0a)
        MOVF  c3,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m051
                        ;								{
                        ;									c3 = 0;
        CLRF  c3
                        ;									c2++;
        INCF  c2,1
                        ;									if(c2 == 0x0a)
        MOVF  c2,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m051
                        ;									{
                        ;										c2 = 0;
        CLRF  c2
                        ;										c1++;
        INCF  c1,1
                        ;										if(c1 == 0x0a)
        MOVF  c1,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m051
                        ;										{
                        ;											c1 = 0;
        CLRF  c1
                        ;											c0++;
        INCF  c0,1
                        ;										}
                        ;									}
                        ;								}
                        ;							}
                        ;						}
                        ;					}
                        ;				}
                        ;				
                        ;				if(c6 > 5)
m051    MOVLW 6
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF c6,W
        BTFSS 0x03,Carry
        GOTO  m052
                        ;				{
                        ;					c5++;
        INCF  c5,1
                        ;					if(c5 == 0x0a)
        MOVF  c5,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m052
                        ;					{
                        ;						c5 = 0;
        CLRF  c5
                        ;						c4++;
        INCF  c4,1
                        ;						if(c4 == 0x0a)
        MOVF  c4,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m052
                        ;						{
                        ;							c4 = 0;
        CLRF  c4
                        ;							c3++;
        INCF  c3,1
                        ;							if(c3 == 0x0a)
        MOVF  c3,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m052
                        ;							{
                        ;								c3 = 0;
        CLRF  c3
                        ;								c2++;
        INCF  c2,1
                        ;								if(c2 == 0x0a)
        MOVF  c2,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m052
                        ;								{
                        ;									c2 = 0;
        CLRF  c2
                        ;									c1++;
        INCF  c1,1
                        ;									if(c1 == 0x0a)
        MOVF  c1,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m052
                        ;									{
                        ;										c1 = 0;
        CLRF  c1
                        ;										c0++;
        INCF  c0,1
                        ;									}
                        ;								}
                        ;							}
                        ;						}
                        ;					}
                        ;				}
                        ;				////////////////////////////////////
                        ;				/*
                        ;				if(c5 > 5)
                        ;				{
                        ;					c4++;
                        ;					if(c4 == 0x0a)
                        ;					{
                        ;						c3++;
                        ;						if(c2 == 0x0a)
                        ;						{
                        ;							c1++;
                        ;							if(c1 == 0x0a)
                        ;								c0++;
                        ;						}
                        ;					}
                        ;				}
                        ;				
                        ;				if(c4 > 5)
                        ;				{
                        ;					c3++;
                        ;					if(c2 == 0x0a)
                        ;					{
                        ;						c1++;
                        ;						if(c1 == 0x0a)
                        ;							c0++;
                        ;					}
                        ;				}
                        ;				
                        ;				if(c2 > 5)
                        ;				{
                        ;					c1++;
                        ;					if(c1 == 0x0a)
                        ;						c0++;
                        ;				}
                        ;				
                        ;				if(c1 > 5)
                        ;					c0++;
                        ;				//*/
                        ;				///////////////////////////////////////
                        ;			}
                        ;			
                        ;			if(c0)
m052    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c0,1
        BTFSC 0x03,Zero_
        GOTO  m055
                        ;			{
                        ;				if(c5 > 5)
        MOVLW 6
        SUBWF c5,W
        BTFSS 0x03,Carry
        GOTO  m053
                        ;				{
                        ;					c4++;
        INCF  c4,1
                        ;					if(c4 == 0x0a)
        MOVF  c4,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m053
                        ;					{
                        ;						c4 = 0;
        CLRF  c4
                        ;						c3++;
        INCF  c3,1
                        ;						if(c3 == 0x0a)
        MOVF  c3,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m053
                        ;						{
                        ;							c3 = 0;
        CLRF  c3
                        ;							c2++;
        INCF  c2,1
                        ;							if(c2 == 0x0a)
        MOVF  c2,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m053
                        ;							{
                        ;								c2 = 0;
        CLRF  c2
                        ;								c1++;
        INCF  c1,1
                        ;								if(c1 == 0x0a)
        MOVF  c1,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m053
                        ;								{
                        ;									c1 = 0;
        CLRF  c1
                        ;									c0++;
        INCF  c0,1
                        ;								}
                        ;							}
                        ;						}
                        ;					}
                        ;				}
                        ;				
                        ;				if(c4 > 5)
m053    MOVLW 6
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF c4,W
        BTFSS 0x03,Carry
        GOTO  m054
                        ;				{
                        ;					c3++;
        INCF  c3,1
                        ;					if(c3 == 0x0a)
        MOVF  c3,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m054
                        ;					{
                        ;						c3 = 0;
        CLRF  c3
                        ;						c2++;
        INCF  c2,1
                        ;						if(c2 == 0x0a)
        MOVF  c2,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m054
                        ;						{
                        ;							c2 = 0;
        CLRF  c2
                        ;							c1++;
        INCF  c1,1
                        ;							if(c1 == 0x0a)
        MOVF  c1,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m054
                        ;							{
                        ;								c1 = 0;
        CLRF  c1
                        ;								c0++;
        INCF  c0,1
                        ;							}
                        ;						}
                        ;					}
                        ;				}
                        ;				
                        ;				e0 = c0;
m054    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c0,W
        MOVWF e0
                        ;				e1 = c1;// + dp;
        MOVF  c1,W
        MOVWF e1
                        ;				e2 = c2;
        MOVF  c2,W
        MOVWF e2
                        ;				e3 = c3;
        MOVF  c3,W
        MOVWF e3
                        ;				e2.7 = 1;
        BSF   e2,7
                        ;			}
                        ;			else
        GOTO  m058
                        ;			{
                        ;				if(c1)
m055    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c1,1
        BTFSC 0x03,Zero_
        GOTO  m057
                        ;				{
                        ;					if(c5 > 5)
        MOVLW 6
        SUBWF c5,W
        BTFSS 0x03,Carry
        GOTO  m056
                        ;					{
                        ;						c4++;
        INCF  c4,1
                        ;						if(c4 == 0x0a)
        MOVF  c4,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m056
                        ;						{
                        ;							c4 = 0;
        CLRF  c4
                        ;							c3++;
        INCF  c3,1
                        ;							if(c3 == 0x0a)
        MOVF  c3,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m056
                        ;							{
                        ;								c3 = 0;
        CLRF  c3
                        ;								c2++;
        INCF  c2,1
                        ;								if(c2 == 0x0a)
        MOVF  c2,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m056
                        ;								{
                        ;									c2 = 0;
        CLRF  c2
                        ;									c1++;
        INCF  c1,1
                        ;									if(c1 == 0x0a)
        MOVF  c1,W
        XORLW 10
        BTFSS 0x03,Zero_
        GOTO  m056
                        ;									{
                        ;										c1 = 0;
        CLRF  c1
                        ;										c0++;
        INCF  c0,1
                        ;									}
                        ;								}
                        ;							}
                        ;						}
                        ;					}
                        ;					
                        ;					e0 = c1;
m056    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c1,W
        MOVWF e0
                        ;					e1 = c2;// + dp;
        MOVF  c2,W
        MOVWF e1
                        ;					e2 = c3;
        MOVF  c3,W
        MOVWF e2
                        ;					e3 = c4;
        MOVF  c4,W
        MOVWF e3
                        ;					e1.7 = 1;
        BSF   e1,7
                        ;				}
                        ;				else
        GOTO  m058
                        ;				{
                        ;					e0 = c2;// + dp;
m057    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c2,W
        MOVWF e0
                        ;					e1 = c3;
        MOVF  c3,W
        MOVWF e1
                        ;					e2 = c4;
        MOVF  c4,W
        MOVWF e2
                        ;					e3 = c5;
        MOVF  c5,W
        MOVWF e3
                        ;					e0.7 = 1;
        BSF   e0,7
                        ;				}
                        ;			}
                        ;			
                        ;		}
                        ;		
                        ;		while(PORTB.4 || PORTB.5) continue;	// waiting for end of arrow
m058    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC PORTB,4
        GOTO  m058
        BTFSC PORTB,5
        GOTO  m058
                        ;		
                        ;		delay(1);
        MOVLW 1
        CALL  delay
                        ;	}
        GOTO  m037
                        ;}
                        ;
                        ;
                        ;void delay(u8 dly_val)
                        ;{
delay
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF dly_val
                        ;	while(dly_val > 0)
m059    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  dly_val,1
        BTFSC 0x03,Zero_
        GOTO  m062
                        ;	{
                        ;		dly_val--;
        DECF  dly_val,1
                        ;		u8 dly_val0 = 0xff;
        MOVLW 255
        MOVWF dly_val0
                        ;		while(dly_val0 > 0)
m060    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  dly_val0,1
        BTFSC 0x03,Zero_
        GOTO  m059
                        ;		{
                        ;			dly_val0--;
        DECF  dly_val0,1
                        ;			u8 dly_val1 = 0xff;
        MOVLW 255
        MOVWF dly_val1
                        ;			while(dly_val1 > 0)
m061    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  dly_val1,1
        BTFSC 0x03,Zero_
        GOTO  m060
                        ;			{
                        ;				dly_val1--;
        DECF  dly_val1,1
                        ;				nop();
        NOP  
                        ;				nop();
        NOP  
                        ;				nop();
        NOP  
                        ;			}
        GOTO  m061
                        ;		}
                        ;	}
                        ;}
m062    RETURN
                        ;
                        ;
                        ;void delay_50u(void)
                        ;{
delay_50u
                        ;	u8 tmp_delay=29;
        MOVLW 29
        MOVWF tmp_delay
                        ;	while(tmp_delay != 0)
m063    MOVF  tmp_delay,1
        BTFSC 0x03,Zero_
        GOTO  m064
                        ;	{
                        ;		tmp_delay--;
        DECF  tmp_delay,1
                        ;	}
        GOTO  m063
                        ;}
m064    RETURN
                        ;
                        ;
                        ;void div_24_24(void)
                        ;{
div_24_24
                        ;	u8 result_tail = 0;
        BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  result_tail
                        ;	
                        ;	//	LH | LM | LL
                        ;	//	______________
                        ;	//	TMRHH | TMRLL
                        ;	
                        ;	u8 lh = LH;
        MOVLW 6
        MOVWF lh
                        ;	u8 lm = LM;
        MOVLW 85
        MOVWF lm
                        ;	u8 ll = LL;
        MOVLW 24
        MOVWF ll
                        ;//	u16 lt = LT;
                        ;//	u16 tmp = 0;
                        ;	
                        ;	result = 0;
        CLRF  result
        CLRF  result+1
                        ;	result_tail = 0;
        CLRF  result_tail
                        ;	
                        ;	if(TMR1HH || TMR1H || TMR1L)
        MOVF  TMR1HH,1
        BTFSS 0x03,Zero_
        GOTO  m065
        MOVF  TMR1H,W
        BTFSS 0x03,Zero_
        GOTO  m065
        MOVF  TMR1L,W
        BTFSC 0x03,Zero_
        GOTO  m069
                        ;	{
                        ;		while(1)
                        ;		{
                        ;			ll -= TMR1L;
m065    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  TMR1L,W
        SUBWF ll,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m066
                        ;			{
                        ;				W = 1;
        MOVLW 1
                        ;				lm -= W;
        SUBWF lm,1
                        ;				if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m066
                        ;				{
                        ;					W = 1;
        MOVLW 1
                        ;					lh -= W;
        SUBWF lh,1
                        ;					if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m066
                        ;					{
                        ;						lh++;
        INCF  lh,1
                        ;						lm++;
        INCF  lm,1
                        ;						ll += TMR1L;
        MOVF  TMR1L,W
        ADDWF ll,1
                        ;						break;
        GOTO  m069
                        ;					}
                        ;				}
                        ;			}
                        ;			
                        ;			lm -= TMR1H;
m066    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  TMR1H,W
        SUBWF lm,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m067
                        ;			{
                        ;				W = 1;
        MOVLW 1
                        ;				lh -= W;
        SUBWF lh,1
                        ;				if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m067
                        ;				{
                        ;					lh++;
        INCF  lh,1
                        ;					lm += TMR1H;
        MOVF  TMR1H,W
        ADDWF lm,1
                        ;					ll += TMR1L;
        MOVF  TMR1L,W
        ADDWF ll,1
                        ;					break;
        GOTO  m069
                        ;				}
                        ;			}
                        ;			
                        ;			lh -= TMR1HH;
m067    MOVF  TMR1HH,W
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF lh,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m068
                        ;			{
                        ;				lh += TMR1HH;
        MOVF  TMR1HH,W
        ADDWF lh,1
                        ;				break;
        GOTO  m069
                        ;			}
                        ;			
                        ;			result++;
m068    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  result,1
        BTFSC 0x03,Zero_
        INCF  result+1,1
                        ;		}
        GOTO  m065
                        ;		
                        ;	}
                        ;	
                        ;	
                        ;	
                        ;	
                        ;	tmpLL = ll;
m069    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  ll,W
        MOVWF tmpLL
                        ;	tmpLH = lm;
        MOVF  lm,W
        MOVWF tmpLH
                        ;	tmpHL = lh;
        MOVF  lh,W
        MOVWF tmpHL
                        ;	
                        ;	
                        ;	STATUS.0 = 0;
        BCF   STATUS,0
                        ;	RLF(tmpLL, 1);	// x2
        RLF   tmpLL,1
                        ;	RLF(tmpLH, 1);
        RLF   tmpLH,1
                        ;	RLF(tmpHL, 1);
        RLF   tmpHL,1
                        ;	
                        ;	STATUS.0 = 0;
        BCF   STATUS,0
                        ;	RLF(tmpLL, 1);	// x4
        RLF   tmpLL,1
                        ;	RLF(tmpLH, 1);
        RLF   tmpLH,1
                        ;	RLF(tmpHL, 1);
        RLF   tmpHL,1
                        ;	
                        ;	STATUS.0 = 0;
        BCF   STATUS,0
                        ;	RLF(tmpLL, 1);	// x8
        RLF   tmpLL,1
                        ;	RLF(tmpLH, 1);
        RLF   tmpLH,1
                        ;	RLF(tmpHL, 1);
        RLF   tmpHL,1
                        ;	
                        ;	STATUS.0 = 0;
        BCF   STATUS,0
                        ;	RLF(ll, 1);		// x2
        RLF   ll,1
                        ;	RLF(lm, 1);
        RLF   lm,1
                        ;	RLF(lh, 1);
        RLF   lh,1
                        ;	
                        ;	ll += tmpLL;	// x2 + x8 = x10
        MOVF  tmpLL,W
        ADDWF ll,1
                        ;	if(Carry)
        BTFSS 0x03,Carry
        GOTO  m070
                        ;	{
                        ;		W = 1;
        MOVLW 1
                        ;		lm += W;
        ADDWF lm,1
                        ;		if(Carry)
        BTFSC 0x03,Carry
                        ;			lh++;
        INCF  lh,1
                        ;	}
                        ;	
                        ;	lm += tmpLH;
m070    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  tmpLH,W
        ADDWF lm,1
                        ;	if(Carry)
        BTFSC 0x03,Carry
                        ;		lh++;
        INCF  lh,1
                        ;	
                        ;	lh += tmpHL;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  tmpHL,W
        ADDWF lh,1
                        ;	
                        ;	
                        ;	
                        ;	while(1)
                        ;	{
                        ;		ll -= TMR1L;
m071    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  TMR1L,W
        SUBWF ll,1
                        ;		if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m072
                        ;		{
                        ;			W = 1;
        MOVLW 1
                        ;			lm -= W;
        SUBWF lm,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m072
                        ;			{
                        ;				W = 1;
        MOVLW 1
                        ;				lh -= W;
        SUBWF lh,1
                        ;				if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m072
                        ;				{
                        ;					lh++;
        INCF  lh,1
                        ;					lm++;
        INCF  lm,1
                        ;					ll += TMR1L;
        MOVF  TMR1L,W
        ADDWF ll,1
                        ;					break;
        GOTO  m075
                        ;				}
                        ;			}
                        ;		}
                        ;		
                        ;		lm -= TMR1H;
m072    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  TMR1H,W
        SUBWF lm,1
                        ;		if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m073
                        ;		{
                        ;			W = 1;
        MOVLW 1
                        ;			lh -= W;
        SUBWF lh,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m073
                        ;			{
                        ;				lh++;
        INCF  lh,1
                        ;				lm += TMR1H;
        MOVF  TMR1H,W
        ADDWF lm,1
                        ;				ll += TMR1L;
        MOVF  TMR1L,W
        ADDWF ll,1
                        ;				break;
        GOTO  m075
                        ;			}
                        ;		}
                        ;		
                        ;		lh -= TMR1HH;
m073    MOVF  TMR1HH,W
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF lh,1
                        ;		if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m074
                        ;		{
                        ;			lh += TMR1HH;
        MOVF  TMR1HH,W
        ADDWF lh,1
                        ;			break;
        GOTO  m075
                        ;		}
                        ;		result_tail++;
m074    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  result_tail,1
                        ;	}
        GOTO  m071
                        ;	
                        ;	
                        ;	// v*10
                        ;	
                        ;	tmp16 = result;
m075    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  result,W
        MOVWF tmp16
        MOVF  result+1,W
        MOVWF tmp16+1
                        ;	
                        ;	Carry = 0;
        BCF   0x03,Carry
                        ;	
                        ;	RLF(result.high8, 1);	// *2
        RLF   result+1,1
                        ;	RLF(result.low8, 1);
        RLF   result,1
                        ;	
                        ;	RLF(result.high8, 1);	// *4
        RLF   result+1,1
                        ;	RLF(result.low8, 1);
        RLF   result,1
                        ;	
                        ;	RLF(result.high8, 1);	// *8
        RLF   result+1,1
                        ;	RLF(result.low8, 1);
        RLF   result,1
                        ;
                        ;	result += tmp16;
        MOVF  tmp16+1,W
        ADDWF result+1,1
        MOVF  tmp16,W
        ADDWF result,1
        BTFSC 0x03,Carry
        INCF  result+1,1
                        ;	result += tmp16;
        MOVF  tmp16+1,W
        ADDWF result+1,1
        MOVF  tmp16,W
        ADDWF result,1
        BTFSC 0x03,Carry
        INCF  result+1,1
                        ;	
                        ;	result += result_tail;
        MOVF  result_tail,W
        ADDWF result,1
        BTFSC 0x03,Carry
        INCF  result+1,1
                        ;
                        ;	
                        ;}
        RETURN
                        ;
                        ;
                        ;void correct_mass(void)
                        ;{
correct_mass
                        ;	while(b0 || b1) continue;
m076    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC PORTB,6
        GOTO  m076
        BTFSC PORTA,5
        GOTO  m076
                        ;	
                        ;	calc_value8(mass);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  mass,W
        CALL  calc_value8
                        ;	m0 = c0;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  c0,W
        MOVWF m0
                        ;	m1 = c1;
        MOVF  c1,W
        MOVWF m1
                        ;	m2 = c2;
        MOVF  c2,W
        MOVWF m2
                        ;	
                        ;	TMR2H = 0x16;
        MOVLW 22
        MOVWF TMR2H
                        ;	M = 1;
        BSF   0x56,M
                        ;	counter8 = 0;
        CLRF  counter8
                        ;	while(counter8 < 3)
m077    MOVLW 3
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF counter8,W
        BTFSC 0x03,Carry
        GOTO  m087
                        ;	{
                        ;		if(b0)
        BTFSS PORTB,6
        GOTO  m084
                        ;		{
                        ;			switch(counter8)
        MOVF  counter8,W
        BTFSC 0x03,Zero_
        GOTO  m078
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m079
        XORLW 3
        BTFSC 0x03,Zero_
        GOTO  m081
        GOTO  m083
                        ;			{
                        ;				case 0:
                        ;				{
                        ;					m0 ++;
m078    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  m0,1
                        ;					if(m0 > 2)
        MOVLW 3
        SUBWF m0,W
        BTFSS 0x03,Carry
        GOTO  m083
                        ;						m0 = 0;
        CLRF  m0
                        ;					break;
        GOTO  m083
                        ;				}
                        ;				
                        ;				case 1:
                        ;				{
                        ;					m1++;
m079    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  m1,1
                        ;					if(m1 > 9 || (m0 == 2 && m1 > 5))
        MOVLW 10
        SUBWF m1,W
        BTFSC 0x03,Carry
        GOTO  m080
        MOVF  m0,W
        XORLW 2
        BTFSS 0x03,Zero_
        GOTO  m083
        MOVLW 6
        SUBWF m1,W
        BTFSS 0x03,Carry
        GOTO  m083
                        ;						m1 = 0;
m080    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  m1
                        ;					break;
        GOTO  m083
                        ;				}
                        ;				
                        ;				case 2:
                        ;				{
                        ;					m2++;
m081    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  m2,1
                        ;					if(m2 > 9 || (m0 == 2 && m1 == 5 && m2 > 5))
        MOVLW 10
        SUBWF m2,W
        BTFSC 0x03,Carry
        GOTO  m082
        MOVF  m0,W
        XORLW 2
        BTFSS 0x03,Zero_
        GOTO  m083
        MOVF  m1,W
        XORLW 5
        BTFSS 0x03,Zero_
        GOTO  m083
        MOVLW 6
        SUBWF m2,W
        BTFSS 0x03,Carry
        GOTO  m083
                        ;						m2 = 0;
m082    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  m2
                        ;					break;
                        ;				}
                        ;			}
                        ;			
                        ;			while(b0) continue;
m083    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC PORTB,6
        GOTO  m083
                        ;			delay(2);
        MOVLW 2
        CALL  delay
                        ;		}
                        ;		
                        ;		if(b1)
m084    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS PORTA,5
        GOTO  m077
                        ;		{
                        ;			counter8++;
        INCF  counter8,1
                        ;			if(counter8 == 1 && m0 == 2 && m1 > 5)
        DECFSZ counter8,W
        GOTO  m085
        MOVF  m0,W
        XORLW 2
        BTFSS 0x03,Zero_
        GOTO  m085
        MOVLW 6
        SUBWF m1,W
        BTFSS 0x03,Carry
        GOTO  m085
                        ;				m1 = 5;
        MOVLW 5
        MOVWF m1
                        ;			
                        ;			if(counter8 == 2 && m0 == 2 && m1 == 5 && m2 > 5)
m085    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  counter8,W
        XORLW 2
        BTFSS 0x03,Zero_
        GOTO  m086
        MOVF  m0,W
        XORLW 2
        BTFSS 0x03,Zero_
        GOTO  m086
        MOVF  m1,W
        XORLW 5
        BTFSS 0x03,Zero_
        GOTO  m086
        MOVLW 6
        SUBWF m2,W
        BTFSS 0x03,Carry
        GOTO  m086
                        ;				m2 = 5;
        MOVLW 5
        MOVWF m2
                        ;			
                        ;			while(b1) continue;
m086    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC PORTA,5
        GOTO  m086
                        ;			delay(2);
        MOVLW 2
        CALL  delay
                        ;		}
                        ;		
                        ;	}
        GOTO  m077
                        ;
                        ;	mass = m0;
m087    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  m0,W
        MOVWF mass
                        ;	mass = mass*100;
        MOVF  mass,W
        MOVWF C2tmp
        MOVLW 8
        MOVWF C1cnt
m088    BCF   0x03,Carry
        BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   mass,1
        RLF   C2tmp,1
        BTFSS 0x03,Carry
        GOTO  m089
        MOVLW 100
        ADDWF mass,1
m089    BCF   0x03,RP0
        BCF   0x03,RP1
        DECFSZ C1cnt,1
        GOTO  m088
                        ;	tmp8 = m1;
        MOVF  m1,W
        MOVWF tmp8
                        ;	tmp8 = tmp8*10;
        BCF   0x03,Carry
        RLF   tmp8,W
        ADDWF tmp8,1
        ADDWF tmp8,1
        BCF   0x03,Carry
        RLF   tmp8,1
                        ;	mass += tmp8;
        MOVF  tmp8,W
        ADDWF mass,1
                        ;	mass += m2;
        MOVF  m2,W
        ADDWF mass,1
                        ;	
                        ;	EEADR = 0x00;
        BSF   0x03,RP0
        CLRF  EEADR
                        ;	EECON1.RD = 1;
        BSF   EECON1,0
                        ;	while(EECON1.RD) continue;
m090    BSF   0x03,RP0
        BCF   0x03,RP1
        BTFSC EECON1,0
        GOTO  m090
                        ;	
                        ;	if(EEDATA != mass)
        BSF   0x03,RP0
        BCF   0x03,RP1
        MOVF  EEDATA,W
        BCF   0x03,RP0
        XORWF mass,W
        BTFSC 0x03,Zero_
        GOTO  m093
                        ;	{
                        ;		EEDATA = mass;
        MOVF  mass,W
        BSF   0x03,RP0
        MOVWF EEDATA
                        ;		EEADR = 0x00;
        CLRF  EEADR
                        ;		EECON1.WREN = 1;
        BSF   EECON1,2
                        ;		GIE = 0;
        BCF   0x0B,GIE
                        ;		while(GIE) GIE = 0;
m091    BTFSS 0x0B,GIE
        GOTO  m092
        BCF   0x0B,GIE
        GOTO  m091
                        ;		EECON2 = 0x55;
m092    MOVLW 85
        BSF   0x03,RP0
        BCF   0x03,RP1
        MOVWF EECON2
                        ;		EECON2 = 0xaa;
        MOVLW 170
        MOVWF EECON2
                        ;		EECON1.WR = 1;
        BSF   EECON1,1
                        ;		GIE = 1;
        BSF   0x0B,GIE
                        ;	}
                        ;	
                        ;	blink = 0;
m093    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x56,blink
                        ;	
                        ;	T0IE = 0;
        BCF   0x0B,T0IE
                        ;	PORTB &= 0xf0;
        MOVLW 240
        ANDWF PORTB,1
                        ;	delay(1);
        MOVLW 1
        CALL  delay
                        ;	
                        ;	T0IE = 1;
        BSF   0x0B,T0IE
                        ;	delay(1);
        MOVLW 1
        CALL  delay
                        ;	
                        ;	T0IE = 0;
        BCF   0x0B,T0IE
                        ;	PORTB &= 0xf0;
        MOVLW 240
        BCF   0x03,RP0
        BCF   0x03,RP1
        ANDWF PORTB,1
                        ;	delay(1);
        MOVLW 1
        CALL  delay
                        ;	
                        ;	T0IE = 1;
        BSF   0x0B,T0IE
                        ;	delay(1);
        MOVLW 1
        CALL  delay
                        ;	
                        ;	T0IE = 0;
        BCF   0x0B,T0IE
                        ;	PORTB &= 0xf0;
        MOVLW 240
        BCF   0x03,RP0
        BCF   0x03,RP1
        ANDWF PORTB,1
                        ;	delay(1);
        MOVLW 1
        CALL  delay
                        ;	
                        ;	T0IE = 1;
        BSF   0x0B,T0IE
                        ;	
                        ;}
        RETURN
                        ;
                        ;
                        ;void calc_enrg(void)
                        ;{
calc_enrg
                        ;	
                        ;	enrg_H = 0;
        BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  enrg_H
        CLRF  enrg_H+1
                        ;	enrg_L = 0;
        CLRF  enrg_L
        CLRF  enrg_L+1
                        ;	
                        ;	// sqr(v*10)
                        ;	
                        ;	counter16 = result;
        MOVF  result,W
        MOVWF counter16
        MOVF  result+1,W
        MOVWF counter16+1
                        ;	while(counter16)
m094    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  counter16,W
        IORWF counter16+1,W
        BTFSC 0x03,Zero_
        GOTO  m097
                        ;	{
                        ;		enrg_L.low8 += result.low8;
        MOVF  result,W
        ADDWF enrg_L,1
                        ;		if(Carry)
        BTFSS 0x03,Carry
        GOTO  m095
                        ;		{
                        ;			W = 1;
        MOVLW 1
                        ;			enrg_L.high8 += W;
        ADDWF enrg_L+1,1
                        ;			if(Carry)
        BTFSS 0x03,Carry
        GOTO  m095
                        ;			{
                        ;				W = 1;
        MOVLW 1
                        ;				enrg_H.low8 += W;
        ADDWF enrg_H,1
                        ;				if(Carry)
        BTFSC 0x03,Carry
                        ;					enrg_H.high8++;
        INCF  enrg_H+1,1
                        ;			}
                        ;		}
                        ;		
                        ;		enrg_L.high8 += result.high8;
m095    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  result+1,W
        ADDWF enrg_L+1,1
                        ;		if(Carry)
        BTFSS 0x03,Carry
        GOTO  m096
                        ;		{
                        ;			W = 1;
        MOVLW 1
                        ;			enrg_H.low8 += W;
        ADDWF enrg_H,1
                        ;			if(Carry)
        BTFSC 0x03,Carry
                        ;				enrg_H.high8++;
        INCF  enrg_H+1,1
                        ;		}
                        ;		counter16--;
m096    BCF   0x03,RP0
        BCF   0x03,RP1
        DECF  counter16,1
        INCF  counter16,W
        BTFSC 0x03,Zero_
        DECF  counter16+1,1
                        ;	}
        GOTO  m094
                        ;	
                        ;	
                        ;	// sqr(v*10)/2
                        ;	
                        ;	Carry = 0;
m097    BCF   0x03,Carry
                        ;	
                        ;	RRF(enrg_H, 1);
        BCF   0x03,RP0
        BCF   0x03,RP1
        RRF   enrg_H+1,1
        RRF   enrg_H,1
                        ;	RRF(enrg_L, 1);
        RRF   enrg_L+1,1
        RRF   enrg_L,1
                        ;	
                        ;	
                        ;	// (sqr(v*10)*mass*100000)/2
                        ;	
                        ;	
                        ;	u8 vhh = enrg_H.high8;
        MOVF  enrg_H+1,W
        MOVWF vhh
                        ;	u8 vhl = enrg_H.low8;
        MOVF  enrg_H,W
        MOVWF vhl
                        ;	u8 vlh = enrg_L.high8;
        MOVF  enrg_L+1,W
        MOVWF vlh
                        ;	u8 vll = enrg_L.low8;
        MOVF  enrg_L,W
        MOVWF vll
                        ;	
                        ;	enrg_H = 0;
        CLRF  enrg_H
        CLRF  enrg_H+1
                        ;	enrg_L = 0;
        CLRF  enrg_L
        CLRF  enrg_L+1
                        ;	
                        ;	
                        ;	counter8 = mass;
        MOVF  mass,W
        MOVWF counter8
                        ;	while(counter8)
m098    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  counter8,1
        BTFSC 0x03,Zero_
        GOTO  m101
                        ;	{
                        ;		enrg_L.low8 += vll;
        MOVF  vll,W
        ADDWF enrg_L,1
                        ;		if(Carry)
        BTFSS 0x03,Carry
        GOTO  m099
                        ;		{
                        ;			W = 1;
        MOVLW 1
                        ;			enrg_L.high8 += W;
        ADDWF enrg_L+1,1
                        ;			if(Carry)
        BTFSS 0x03,Carry
        GOTO  m099
                        ;			{
                        ;				W = 1;
        MOVLW 1
                        ;				enrg_H.low8 += W;
        ADDWF enrg_H,1
                        ;				if(Carry)
        BTFSC 0x03,Carry
                        ;				{
                        ;					enrg_H.high8++;
        INCF  enrg_H+1,1
                        ;				}
                        ;			}
                        ;		}
                        ;		
                        ;		enrg_L.high8 += vlh;
m099    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vlh,W
        ADDWF enrg_L+1,1
                        ;		if(Carry)
        BTFSS 0x03,Carry
        GOTO  m100
                        ;		{
                        ;			W = 1;
        MOVLW 1
                        ;			enrg_H.low8 += W;
        ADDWF enrg_H,1
                        ;			if(Carry)
        BTFSC 0x03,Carry
                        ;			{
                        ;				enrg_H.high8++;
        INCF  enrg_H+1,1
                        ;			}
                        ;		}
                        ;		
                        ;		
                        ;		enrg_H.low8 += vhl;
m100    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vhl,W
        ADDWF enrg_H,1
                        ;		if(Carry)
        BTFSC 0x03,Carry
                        ;		{
                        ;			enrg_H.high8++;
        INCF  enrg_H+1,1
                        ;		}
                        ;		
                        ;		enrg_H.high8 += vhh;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vhh,W
        ADDWF enrg_H+1,1
                        ;		
                        ;		counter8--;
        DECF  counter8,1
                        ;	}
        GOTO  m098
                        ;	
                        ;	
                        ;	
                        ;	
                        ;}
m101    RETURN
                        ;
                        ;
                        ;void calc_value32(void)
                        ;{
calc_value32
                        ;	// convert 0xff 0xff 0xff 0xff -> c0|c1|c2|c3|c4|c5|c6|c7|c8|c9
                        ;	c0 = 0;
        BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  c0
                        ;	c1 = 0;
        CLRF  c1
                        ;	c2 = 0;
        CLRF  c2
                        ;	c3 = 0;
        CLRF  c3
                        ;	c4 = 0;
        CLRF  c4
                        ;	c5 = 0;
        CLRF  c5
                        ;	c6 = 0;
        CLRF  c6
                        ;	c7 = 0;
        CLRF  c7
                        ;	c8 = 0;
        CLRF  c8
                        ;	c9 = 0;
        CLRF  c9
                        ;	
                        ;	// 0x3b 9a ca 00
                        ;	FSR = &c0;
        MOVLW 41
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	// 0x5 f5 e1 00
                        ;	FSR = &c1;
        MOVLW 40
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	// 0x98 96 80
                        ;	FSR = &c2;
        MOVLW 39
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	// 0xf 42 40
                        ;	FSR = &c3;
        MOVLW 38
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	// 0x1 86 a0
                        ;	FSR = &c4;
        MOVLW 37
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	FSR = &c5;
        MOVLW 36
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	FSR = &c6;
        MOVLW 35
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	FSR = &c7;
        MOVLW 34
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	FSR = &c8;
        MOVLW 33
        MOVWF FSR
                        ;	calc_char();
        CALL  calc_char
                        ;	
                        ;	c9 = tmp32LL;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  tmp32LL,W
        MOVWF c9
                        ;	
                        ;}
        RETURN
                        ;
                        ;
                        ;void calc_char(void)
                        ;{
calc_char
                        ;	// FSR = c0..c9
                        ;	
                        ;	u8 vhh;
                        ;	u8 vhl;
                        ;	u8 vlh;
                        ;	u8 vll;
                        ;	
                        ;	switch(FSR)
        MOVF  FSR,W
        XORLW 41
        BTFSC 0x03,Zero_
        GOTO  m102
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m103
        XORLW 15
        BTFSC 0x03,Zero_
        GOTO  m104
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m105
        XORLW 3
        BTFSC 0x03,Zero_
        GOTO  m106
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m107
        XORLW 7
        BTFSC 0x03,Zero_
        GOTO  m108
        XORLW 1
        BTFSC 0x03,Zero_
        GOTO  m109
        XORLW 3
        BTFSC 0x03,Zero_
        GOTO  m110
        GOTO  m111
                        ;	{
                        ;		// 0x3b 9a ca 00
                        ;		case (&c0):
                        ;		{
                        ;			vhh = 0x3b;
m102    MOVLW 59
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF vhh_2
                        ;			vhl = 0x9a;
        MOVLW 154
        MOVWF vhl_2
                        ;			vlh = 0xca;
        MOVLW 202
        MOVWF vlh_2
                        ;			vll = 0x00;
        CLRF  vll_2
                        ;			
                        ;			break;
        GOTO  m111
                        ;		}
                        ;		
                        ;		// 0x05 f5 e1 00
                        ;		case (&c1):
                        ;		{
                        ;			vhh = 0x05;
m103    MOVLW 5
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF vhh_2
                        ;			vhl = 0xf5;
        MOVLW 245
        MOVWF vhl_2
                        ;			vlh = 0xe1;
        MOVLW 225
        MOVWF vlh_2
                        ;			vll = 0x00;
        CLRF  vll_2
                        ;			
                        ;			break;
        GOTO  m111
                        ;		}
                        ;	
                        ;		// 0x00 98 96 80
                        ;		case (&c2):
                        ;		{
                        ;			vhh = 0x00;
m104    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  vhh_2
                        ;			vhl = 0x98; 
        MOVLW 152
        MOVWF vhl_2
                        ;			vlh = 0x96;
        MOVLW 150
        MOVWF vlh_2
                        ;			vll = 0x80;
        MOVLW 128
        MOVWF vll_2
                        ;			
                        ;			break;
        GOTO  m111
                        ;		}
                        ;	
                        ;		// 0x00 0f 42 40
                        ;		case (&c3):
                        ;		{
                        ;			vhh = 0x00; 
m105    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  vhh_2
                        ;			vhl = 0x0f;
        MOVLW 15
        MOVWF vhl_2
                        ;			vlh = 0x42;
        MOVLW 66
        MOVWF vlh_2
                        ;			vll = 0x40;
        MOVLW 64
        MOVWF vll_2
                        ;			
                        ;			break;
        GOTO  m111
                        ;		}
                        ;	
                        ;		// 0x1 86 a0
                        ;		case (&c4):
                        ;		{
                        ;			vhh = 0x00;
m106    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  vhh_2
                        ;			vhl = 0x01;
        MOVLW 1
        MOVWF vhl_2
                        ;			vlh = 0x86;
        MOVLW 134
        MOVWF vlh_2
                        ;			vll = 0xa0;
        MOVLW 160
        MOVWF vll_2
                        ;			
                        ;			break;
        GOTO  m111
                        ;		}
                        ;	
                        ;	// 0x00 00 0d10000;
                        ;		case (&c5):
                        ;		{
                        ;			vhh = 0x00;
m107    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  vhh_2
                        ;			vhl = 0x00;
        CLRF  vhl_2
                        ;			vlh = 0x27;
        MOVLW 39
        MOVWF vlh_2
                        ;			vll = 0x10;
        MOVLW 16
        MOVWF vll_2
                        ;			
                        ;			break;
        GOTO  m111
                        ;		}
                        ;	
                        ;		// 0x00 00 0d1000;
                        ;		case (&c6):
                        ;		{
                        ;			vhh = 0x00;
m108    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  vhh_2
                        ;			vhl = 0x00;
        CLRF  vhl_2
                        ;			vlh = 0x03;
        MOVLW 3
        MOVWF vlh_2
                        ;			vll = 0xe8;
        MOVLW 232
        MOVWF vll_2
                        ;			
                        ;			break;
        GOTO  m111
                        ;		}
                        ;	
                        ;		// 0x00 00, 0d100;
                        ;		case (&c7):
                        ;		{
                        ;			vhh = 0x00;
m109    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  vhh_2
                        ;			vhl = 0x00;
        CLRF  vhl_2
                        ;			vlh = 0x00;
        CLRF  vlh_2
                        ;			vll = 0x64;
        MOVLW 100
        MOVWF vll_2
                        ;			
                        ;			break;
        GOTO  m111
                        ;		}
                        ;	
                        ;		// 0x00 00, 0d10;
                        ;		case (&c8):
                        ;		{
                        ;			vhh = 0x00;
m110    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  vhh_2
                        ;			vhl = 0x00;
        CLRF  vhl_2
                        ;			vlh = 0x00;
        CLRF  vlh_2
                        ;			vll = 0x0a;
        MOVLW 10
        MOVWF vll_2
                        ;			
                        ;			break;
                        ;		}
                        ;	}
                        ;	
                        ;	
                        ;	while(1)
                        ;	{
                        ;		if(vhh)
m111    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vhh_2,1
        BTFSC 0x03,Zero_
        GOTO  m112
                        ;		{
                        ;			tmp32HH -= vhh;
        MOVF  vhh_2,W
        SUBWF tmp32HH,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m112
                        ;			{
                        ;				tmp32HH += vhh;
        MOVF  vhh_2,W
        ADDWF tmp32HH,1
                        ;				break;
        GOTO  m119
                        ;			}
                        ;		}
                        ;			
                        ;		if(vhl)
m112    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vhl_2,1
        BTFSC 0x03,Zero_
        GOTO  m114
                        ;		{
                        ;			tmp32HL -= vhl;
        MOVF  vhl_2,W
        SUBWF tmp32HL,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m114
                        ;			{
                        ;				tmp32HL += vhl;
        MOVF  vhl_2,W
        ADDWF tmp32HL,1
                        ;				W = 1;
        MOVLW 1
                        ;				tmp32HH -= W;
        SUBWF tmp32HH,1
                        ;				if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m113
                        ;				{
                        ;					tmp32HH++;
        INCF  tmp32HH,1
                        ;					tmp32HH += vhh;
        MOVF  vhh_2,W
        ADDWF tmp32HH,1
                        ;					break;
        GOTO  m119
                        ;				}
                        ;				
                        ;				tmp8 = 0x00;
m113    CLRF  tmp8
                        ;				tmp8 -= vhl;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vhl_2,W
        SUBWF tmp8,1
                        ;				tmp32HL += tmp8;
        MOVF  tmp8,W
        ADDWF tmp32HL,1
                        ;				
                        ;			}
                        ;		}
                        ;			
                        ;		if(vlh)
m114    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vlh_2,1
        BTFSC 0x03,Zero_
        GOTO  m116
                        ;		{
                        ;			tmp32LH -= vlh;
        MOVF  vlh_2,W
        SUBWF tmp32LH,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m116
                        ;			{
                        ;				tmp32LH += vlh;
        MOVF  vlh_2,W
        ADDWF tmp32LH,1
                        ;				W = 1;
        MOVLW 1
                        ;				tmp32HL -= W;
        SUBWF tmp32HL,1
                        ;				if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m115
                        ;				{
                        ;					W = 1;
        MOVLW 1
                        ;					tmp32HH -= W;
        SUBWF tmp32HH,1
                        ;					if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m115
                        ;					{
                        ;						tmp32HH++;
        INCF  tmp32HH,1
                        ;						tmp32HL++;
        INCF  tmp32HL,1
                        ;						tmp32HL += vhl;
        MOVF  vhl_2,W
        ADDWF tmp32HL,1
                        ;						tmp32HH += vhh;
        MOVF  vhh_2,W
        ADDWF tmp32HH,1
                        ;						break;
        GOTO  m119
                        ;					}
                        ;				}
                        ;				
                        ;				tmp8 = 0x00;
m115    CLRF  tmp8
                        ;				tmp8 -= vlh;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vlh_2,W
        SUBWF tmp8,1
                        ;				tmp32LH += tmp8;
        MOVF  tmp8,W
        ADDWF tmp32LH,1
                        ;			}
                        ;		}
                        ;			
                        ;		if(vll)	// ??
m116    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vll_2,1
        BTFSC 0x03,Zero_
        GOTO  m118
                        ;		{
                        ;			tmp32LL -= vll;
        MOVF  vll_2,W
        SUBWF tmp32LL,1
                        ;			if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m118
                        ;			{
                        ;				tmp32LL += vll;
        MOVF  vll_2,W
        ADDWF tmp32LL,1
                        ;				W = 1;
        MOVLW 1
                        ;				tmp32LH -= W;
        SUBWF tmp32LH,1
                        ;				if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m117
                        ;				{
                        ;					W = 1;
        MOVLW 1
                        ;					tmp32HL -= W;
        SUBWF tmp32HL,1
                        ;					if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m117
                        ;					{
                        ;						W = 1;
        MOVLW 1
                        ;						tmp32HH -= W;
        SUBWF tmp32HH,1
                        ;						if(!Carry)
        BTFSC 0x03,Carry
        GOTO  m117
                        ;						{
                        ;							tmp32HH++;
        INCF  tmp32HH,1
                        ;							tmp32HL++;
        INCF  tmp32HL,1
                        ;							tmp32LH++;
        INCF  tmp32LH,1
                        ;							
                        ;							tmp32LH += vlh;
        MOVF  vlh_2,W
        ADDWF tmp32LH,1
                        ;							tmp32HL += vhl;
        MOVF  vhl_2,W
        ADDWF tmp32HL,1
                        ;							tmp32HH += vhh;
        MOVF  vhh_2,W
        ADDWF tmp32HH,1
                        ;							break;
        GOTO  m119
                        ;						}
                        ;					}
                        ;				}
                        ;				
                        ;				tmp8 = 0x00;
m117    CLRF  tmp8
                        ;				tmp8 -= vll;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  vll_2,W
        SUBWF tmp8,1
                        ;				tmp32LL += tmp8;
        MOVF  tmp8,W
        ADDWF tmp32LL,1
                        ;			}
                        ;		}
                        ;		INDF++;
m118    INCF  INDF,1
                        ;	}
        GOTO  m111
                        ;}
m119    RETURN
                        ;
                        ;
                        ;void calc_value16(u16 value)
                        ;{
calc_value16
                        ;	// convert 0xffff -> c0|c1|c2|c3|c4
                        ;	c0 = 0;
        BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  c0
                        ;	c1 = 0;
        CLRF  c1
                        ;	c2 = 0;
        CLRF  c2
                        ;	c3 = 0;
        CLRF  c3
                        ;	c4 = 0;
        CLRF  c4
                        ;	
                        ;	if(value < 10000)
        MOVLW 39
        SUBWF value+1,W
        BTFSS 0x03,Carry
        GOTO  m120
        BTFSS 0x03,Zero_
        GOTO  m121
        MOVLW 16
        SUBWF value,W
        BTFSC 0x03,Carry
        GOTO  m121
                        ;		c0 = 0;
m120    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  c0
                        ;	else
        GOTO  m123
                        ;	{
                        ;		while(value >= 10000)
m121    MOVLW 39
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value+1,W
        BTFSS 0x03,Carry
        GOTO  m123
        BTFSS 0x03,Zero_
        GOTO  m122
        MOVLW 16
        SUBWF value,W
        BTFSS 0x03,Carry
        GOTO  m123
                        ;		{
                        ;			value -= 10000;
m122    MOVLW 39
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value+1,1
        MOVLW 16
        SUBWF value,1
        BTFSS 0x03,Carry
        DECF  value+1,1
                        ;			c0++;
        INCF  c0,1
                        ;		}
        GOTO  m121
                        ;	}
                        ;	
                        ;	if(value < 1000)
m123    MOVLW 3
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value+1,W
        BTFSS 0x03,Carry
        GOTO  m124
        BTFSS 0x03,Zero_
        GOTO  m125
        MOVLW 232
        SUBWF value,W
        BTFSC 0x03,Carry
        GOTO  m125
                        ;		c1 = 0;
m124    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  c1
                        ;	else
        GOTO  m127
                        ;	{
                        ;		while(value >= 1000)
m125    MOVLW 3
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value+1,W
        BTFSS 0x03,Carry
        GOTO  m127
        BTFSS 0x03,Zero_
        GOTO  m126
        MOVLW 232
        SUBWF value,W
        BTFSS 0x03,Carry
        GOTO  m127
                        ;		{
                        ;			value -= 1000;
m126    MOVLW 3
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value+1,1
        MOVLW 232
        SUBWF value,1
        BTFSS 0x03,Carry
        DECF  value+1,1
                        ;			c1++;
        INCF  c1,1
                        ;		}
        GOTO  m125
                        ;	}
                        ;	
                        ;	if(value < 100)
m127    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  value+1,W
        BTFSS 0x03,Zero_
        GOTO  m128
        MOVLW 100
        SUBWF value,W
        BTFSC 0x03,Carry
        GOTO  m128
                        ;		c2 = 0;
        CLRF  c2
                        ;	else
        GOTO  m130
                        ;	{
                        ;		while(value >= 100)
m128    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  value+1,W
        BTFSS 0x03,Zero_
        GOTO  m129
        MOVLW 100
        SUBWF value,W
        BTFSS 0x03,Carry
        GOTO  m130
                        ;		{
                        ;			value -= 100;
m129    MOVLW 100
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value,1
        BTFSS 0x03,Carry
        DECF  value+1,1
                        ;			c2++;
        INCF  c2,1
                        ;		}
        GOTO  m128
                        ;	}
                        ;	
                        ;	if(value < 10)
m130    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  value+1,W
        BTFSS 0x03,Zero_
        GOTO  m131
        MOVLW 10
        SUBWF value,W
        BTFSC 0x03,Carry
        GOTO  m131
                        ;		c3 = 0;
        CLRF  c3
                        ;	else
        GOTO  m133
                        ;	{
                        ;		while(value >= 10)
m131    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  value+1,W
        BTFSS 0x03,Zero_
        GOTO  m132
        MOVLW 10
        SUBWF value,W
        BTFSS 0x03,Carry
        GOTO  m133
                        ;		{
                        ;			value -= 10;
m132    MOVLW 10
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value,1
        BTFSS 0x03,Carry
        DECF  value+1,1
                        ;			c3++;
        INCF  c3,1
                        ;		}
        GOTO  m131
                        ;	}
                        ;	
                        ;	c4 = value;
m133    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  value,W
        MOVWF c4
                        ;	
                        ;}
        RETURN
                        ;
                        ;
                        ;void calc_value8(u8 value)
                        ;{
calc_value8
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF value_2
                        ;	// convert 0xffff -> c0|c1|c2|c3|c4
                        ;	c0 = 0;
        CLRF  c0
                        ;	c1 = 0;
        CLRF  c1
                        ;	c2 = 0;
        CLRF  c2
                        ;	
                        ;	if(value < 100)
        MOVLW 100
        SUBWF value_2,W
        BTFSC 0x03,Carry
        GOTO  m134
                        ;		c0 = 0;
        CLRF  c0
                        ;	else
        GOTO  m135
                        ;	{
                        ;		while(value >= 100)
m134    MOVLW 100
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value_2,W
        BTFSS 0x03,Carry
        GOTO  m135
                        ;		{
                        ;			value -= 100;
        MOVLW 100
        SUBWF value_2,1
                        ;			c0++;
        INCF  c0,1
                        ;		}
        GOTO  m134
                        ;	}
                        ;	
                        ;	if(value < 10)
m135    MOVLW 10
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value_2,W
        BTFSC 0x03,Carry
        GOTO  m136
                        ;		c1 = 0;
        CLRF  c1
                        ;	else
        GOTO  m137
                        ;	{
                        ;		while(value >= 10)
m136    MOVLW 10
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF value_2,W
        BTFSS 0x03,Carry
        GOTO  m137
                        ;		{
                        ;			value -= 10;
        MOVLW 10
        SUBWF value_2,1
                        ;			c1++;
        INCF  c1,1
                        ;		}
        GOTO  m136
                        ;	}
                        ;	
                        ;	c2 = value;
m137    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  value_2,W
        MOVWF c2
                        ;	
                        ;}
        RETURN

        END


; *** KEY INFO ***

; 0x0004  318 word(s) 15 % : isr
; 0x036E   30 word(s)  1 % : delay
; 0x038C    8 word(s)  0 % : delay_50u
; 0x0744   45 word(s)  2 % : calc_value8
; 0x06B6  142 word(s)  6 % : calc_value16
; 0x05A8   44 word(s)  2 % : calc_value32
; 0x05D4  226 word(s) 11 % : calc_char
; 0x0394  191 word(s)  9 % : div_24_24
; 0x0453  235 word(s) 11 % : correct_mass
; 0x053E  106 word(s)  5 % : calc_enrg
; 0x0142  556 word(s) 27 % : main

; RAM usage: 66 bytes (4 local), 158 bytes free
; Maximum call level: 2 (+1 for interrupt)
; Total of 1902 code words (92 %)
