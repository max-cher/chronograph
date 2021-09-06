

#pragma config FOSC=HS
#pragma config WDTE=OFF
#pragma config PWRTE=ON
#pragma config MCLRE=OFF
#pragma config BOREN=OFF
#pragma config LVP=OFF
#pragma config CPD=OFF
#pragma config CP=OFF

#define	u8	char
#define	u16	unsigned long
#define	s16	long

#define	b0	0x01
#define	b1	0x02
#define	b2	0x04
#define	b3	0x08
#define	b4	0x10
#define	b5	0x20
#define	b6	0x40
#define	b7	0x80

u8 w_tmp @ 0x70;
u8 st_tmp @ 0x71;
u8 pc_tmp @ 0x72;
u8 tmp8 @ 0x73;
u16 tmp16 @ 0x74;
u16 TMR1LL @ 0x76;
u8 TMR1HH @ 0x78;
u8 TMR2H @ 0x7a;
u8 PORTB_tmp @ 0x7b;

u8 char0, char1, char2, char3, d, shots, mass;//, result_tail;
u8 v0, v1, v2, v3, e0, e1, e2, e3, m0, m1, m2, counter8, tmp32HH, tmp32HL, tmp32LH, tmp32LL;//, tmp8_0;
u8 varHL, varLH, varLL,tmpHL, tmpLH, tmpLL, rezHL, rezLH, rezLL;
u16 result, counter16, enrg_H, enrg_L;//, tmp32H, tmp32L;//, tmp16_0, tmp16_1;
bit tmr1flag, V_nE, M, blink;

u8 c9 @ 0x20;
u8 c8 @ 0x21;
u8 c7 @ 0x22;
u8 c6 @ 0x23;
u8 c5 @ 0x24;
u8 c4 @ 0x25;
u8 c3 @ 0x26;
u8 c2 @ 0x27;
u8 c1 @ 0x28;
u8 c0 @ 0x29;


#define d0 PORTB.0;
#define d1 PORTB.1;
#define d2 PORTB.2;
#define d3 PORTB.3;

#define b0 PORTB.6
#define b1 PORTA.5

#define WRERR 3
#define WREN 2
#define WR 1
#define RD 0

#define dp 0b10000000

// Length = 0x65518
#define LL  0x18
#define LM  0x55
#define LH  0x06
#define LT  0x5518







