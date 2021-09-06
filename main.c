// no comments for you
// it was hard to write
// so it should be hard to read

#include "D:\cc5x\16f628a.h"
#include "D:\cc5x\INLINE.H"
#include "main.h"

#pragma origin 0x04
interrupt isr(void) {
//
    w_tmp = W;
    W = swap(STATUS);
    st_tmp = W;
    pc_tmp = PCLATH;
//#pragma update_RP 0
//
    STATUS = 0;
    PCLATH = 0;
//
    
    if(T0IF && T0IE) {  //TMR0 int
        T0IF = 0;
        
        if(M) {         // show mass
            switch(d) {
                case 0: {
                    d = 1;
                    PORTB = 0;
                    PORTA &= 0xf0;
                    if(blink && counter8 == 0)
                        PORTA |= 0x0a;
                    else
                        PORTA |= m0;
                    PORTB |= 0b10000010; // dp
                    break;
                }
                
                case 1: {
                    d = 2;
                    PORTB = 0;
                    PORTA &= 0xf0;
                    if(blink && counter8 == 1)
                        PORTA |= 0x0a;
                    else
                        PORTA |= m1;
                    PORTB |= 0b00000100;
                    break;
                }
                
                case 2: {
                    d = 3;
                    PORTB = 0;
                    PORTA &= 0xf0;
                    if(blink && counter8 == 2)
                        PORTA |= 0x0a;
                    else
                        PORTA |= m2;
                    PORTB |= 0b00001000;
                    break;
                }
                
                case 3: {
                    d = 0;
                    PORTB = 0;
                    PORTA &= 0xf0;
                    PORTA |= 0x0a;
                    PORTB |= 0b00000001;
                    break;
                }
                
                default:
                    d = 0;
            }
        }
        else {              // show energy or speed
            if(V_nE) {      // show speed
                switch(d) {
                    case 0: {
                        d = 1;
                        PORTB = 0;
                        PORTA &= 0xf0;
                        PORTA |= v1;
                        PORTB |= 0b00000010;
                        break;
                    }
                    
                    case 1: {
                        d = 2;
                        PORTB = 0;
                        PORTA &= 0xf0;
                        PORTA |= v2;
                        PORTB |= 0b10000100; // dp
                        break;
                    }
                    
                    case 2: {
                        d = 3;
                        PORTB = 0;
                        PORTA &= 0xf0;
                        PORTA |= v3;
                        PORTB |= 0b00001000;
                        break;
                    }
                    
                    case 3: {
                        d = 0;
                        PORTB = 0;
                        PORTA &= 0xf0;
                        PORTA |= v0;
                        PORTB |= 0b00000001;
                        break;
                    }
                    
                    default:
                        d = 0;
                }
            }
            else {       // show energy
                switch(d) {
                    case 0: {
                        d = 1;
                        PORTB = 0;
                        PORTA &= 0xf0;
                        PORTA |= e1;
                        if(e1.7)
                            PORTB |= 0b10000010; // dp
                        else
                            PORTB |= 0b00000010;
                        break;
                    }
                    
                    case 1: {
                        d = 2;
                        PORTB = 0;
                        PORTA &= 0xf0;
                        PORTA |= e2;
                        if(e2.7)
                            PORTB |= 0b10000100;
                        else
                            PORTB |= 0b00000100;
                        break;
                    }
                    
                    case 2: {
                        d = 3;
                        PORTB = 0;
                        PORTA &= 0xf0;
                        PORTA |= e3;
                        PORTB |= 0b10001000;    // dp
                        break;
                    }
                    
                    case 3: {
                        d = 0;
                        PORTB = 0;
                        PORTA &= 0xf0;
                        PORTA |= e0;
                        if(e0.7)
                            PORTB |= 0b10000001;
                        else
                            PORTB |= 0b00000001;
                        break;
                    }
                    
                    default:
                        d = 0;
                }
            }
        }
        
        T0IF = 0;
    }
    
    if(TMR1IF && TMR1IE) {   //TMR1 int
        TMR1IF = 0;
        TMR1HH++;
        if(TMR1HH == 0x32)
            tmr1flag = 1;
    }
    
    if(TMR2IF && TMR2IE) {   //TMR2 int
        TMR2IF = 0;
        
        TMR2H--;
        if(TMR2H == 0) {
            if(M) {
                if(blink)
                    blink = 0;
                else
                    blink = 1;
            TMR2H = 0x16;
            }
            else {
                TMR2H = 0;
                if(V_nE) {
                    V_nE = 0;
                    TMR2H = 0x48;
                }
                else {
                    V_nE = 1;
                    TMR2H = 0x48;
                }
            }
        }
    }
//
//#pragma update_RP 1
    PCLATH = pc_tmp;
    STATUS = swap(st_tmp);
    w_tmp = swap(w_tmp);
    W = swap(w_tmp);
//
}


void delay(u8 dly_val);
void delay_50u(void);
void calc_value8(u8 value);
void calc_value16(u16 value);
void calc_value32();
void calc_char(void);
void div_24_24(void);
void correct_mass(void);
void calc_enrg(void);
void mul_10(void);


void main(void) {
    STATUS=0;
    CMCON = 0b00000111;
    TRISA = 0b00000000;//
    TRISB = 0b01110000;//
    OPTION_REG = 0b11000100;//0x8c;
    CCP1CON = 0x00;
    
    PIE1 = 0x00;
    PIR1 = 0x00;
    INTCON = 0x00;
    T1CON = 0b00000000;
    TMR1L = 0x00;
    TMR1H = 0x00;
    
    T2CON = 0b01111011;
    PEIE = 1;
    T0IE = 1;
    TMR1IE = 1;
    TMR2IE = 1;
    GIE = 1;
    TMR2ON = 1;
    
    char0 = 0;
    char1 = 0;
    char2 = 0;
    char3 = 0;
    
    v0 = 0;
    v1 = 0;
    v2 = 0;
    v3 = 0;
    
    e0 = 0;
    e1 = 0;
    e2 = 0;
    e3 = 0;
    
    m0 = 0;
    m1 = 0;
    m2 = 0;
    
    d = 0;
    V_nE = 0;
    M = 1;
    blink = 0;
    shots = 0;
    
    ///////////////////////////////////
    
    //e0 = 0x0a;
    
    EEADR = 0x00;
    EECON1.RD = 1;
    while(EECON1.RD) continue;
    mass = EEDATA;
    calc_value8(mass);
    m0 = c0;
    m1 = c1;
    m2 = c2;
    
    if(b0 || b1) {
        correct_mass();
    }
    
    calc_value8(mass);
    m0 = c0;
    m1 = c1;
    m2 = c2;
            // 429 4967 295
    ///////////////////////////////////
    
    
    while (1) {
        TMR1L = 0x00;
        TMR1H = 0x00;
        TMR1HH = 0x0000;
        TMR1LL = 0x0000;
        TMR1ON = 0;
        TMR1IF = 0;
        tmr1flag = 0;
        PORTB_tmp = 0x00;
        
        while(!PORTB_tmp.4 && !PORTB_tmp.5) {     // waiting for start    | forward or backward
            PORTB_tmp = PORTB;
            if(b0 && b1) {
                correct_mass();
            }
        }
        
        TMR1ON = 1;
        T0IE = 0;
        PORTB &= 0xf0;
        M = 0;
        
        if(PORTB_tmp.5) {
            while(!PORTB_tmp.4 && !tmr1flag) PORTB_tmp = PORTB; // waiting for stop | forward
        }
        else {
            while(!PORTB_tmp.5 && !tmr1flag) PORTB_tmp = PORTB; // waiting for stop | backward
        }
        
        TMR1ON = 1;
        T0IE = 1;
        
        if(tmr1flag) {        // timer counted?
            TMR2ON = 0;
            tmr1flag = 0;
            
            v0 = 0;
            v1 = 0;
            v2 = 0;
            v3 = 0;
            
            e0 = 0;
            e1 = 0;
            e2 = 0;
            e3 = 0;
            
            delay(1);
            
            T0IE = 0;
            PORTB &= 0xf0;
            delay(1);
            T0IE = 1;
            
            delay(1);
            
            T0IE = 0;
            PORTB &= 0xf0;
            delay(1);
            T0IE = 1;
        }
        else {               // 2nd sensor?
            shots++;
            
            div_24_24();
            calc_value16(result);
            
            TMR2ON = 1;
            if(c1)
                v0 = c1;
            else
                v0 = 0x0a;
            
            if(c2 || c1)
                v1 = c2;
            else
                v1 = 0x0a;
            
            v2 = c3;
            
            v3 = c4;
            
            //result = 10;////
            
            calc_enrg();
        
            tmp32HH = enrg_H.high8;
            tmp32HL = enrg_H.low8;
            tmp32LH = enrg_L.high8;
            tmp32LL = enrg_L.low8;
            
            calc_value32();
            
            {               // magic
                if(c9 > 5) {
                    c8++;
                    if(c8 == 0x0a) {
                        c8 = 0;
                        c7++;
                        if(c7 == 0x0a) {
                            c7 = 0;
                            c6++;
                            if(c6 == 0x0a) {
                                c6 = 0;
                                c5++;
                                if(c5 == 0x0a) {
                                    c5 = 0;
                                    c4++;
                                    if(c4 == 0x0a) {
                                        c4 = 0;
                                        c3++;
                                        if(c3 == 0x0a) {
                                            c3 = 0;
                                            c2++;
                                            if(c2 == 0x0a) {
                                                c2 = 0;
                                                c1++;
                                                if(c1 == 0x0a) {
                                                    c1 = 0;
                                                    c0++;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if(c8 > 5) {
                    c7++;
                    if(c7 == 0x0a) {
                        c7 = 0;
                        c6++;
                        if(c6 == 0x0a) {
                            c6 = 0;
                            c5++;
                            if(c5 == 0x0a) {
                                c5 = 0;
                                c4++;
                                if(c4 == 0x0a) {
                                    c4 = 0;
                                    c3++;
                                    if(c3 == 0x0a) {
                                        c3 = 0;
                                        c2++;
                                        if(c2 == 0x0a) {
                                            c2 = 0;
                                            c1++;
                                            if(c1 == 0x0a) {
                                                c1 = 0;
                                                c0++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if(c7 > 5) {
                    c6++;
                    if(c6 == 0x0a) {
                        c6 = 0;
                        c5++;
                        if(c5 == 0x0a) {
                            c5 = 0;
                            c4++;
                            if(c4 == 0x0a) {
                                c4 = 0;
                                c3++;
                                if(c3 == 0x0a) {
                                    c3 = 0;
                                    c2++;
                                    if(c2 == 0x0a) {
                                        c2 = 0;
                                        c1++;
                                        if(c1 == 0x0a) {
                                            c1 = 0;
                                            c0++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if(c6 > 5) {
                    c5++;
                    if(c5 == 0x0a) {
                        c5 = 0;
                        c4++;
                        if(c4 == 0x0a) {
                            c4 = 0;
                            c3++;
                            if(c3 == 0x0a) {
                                c3 = 0;
                                c2++;
                                if(c2 == 0x0a) {
                                    c2 = 0;
                                    c1++;
                                    if(c1 == 0x0a) {
                                        c1 = 0;
                                        c0++;
                                    }
                                }
                            }
                        }
                    }
                }
                ////////////////////////////////////
                /*
                if(c5 > 5) {
                    c4++;
                    if(c4 == 0x0a) {
                        c3++;
                        if(c2 == 0x0a) {
                            c1++;
                            if(c1 == 0x0a)
                                c0++;
                        }
                    }
                }
                
                if(c4 > 5) {
                    c3++;
                    if(c2 == 0x0a) {
                        c1++;
                        if(c1 == 0x0a)
                            c0++;
                    }
                }
                
                if(c2 > 5) {
                    c1++;
                    if(c1 == 0x0a)
                        c0++;
                }
                
                if(c1 > 5)
                    c0++;
                //*/
                ///////////////////////////////////////
            }
            
            if(c0) {
                if(c5 > 5) {
                    c4++;
                    if(c4 == 0x0a) {
                        c4 = 0;
                        c3++;
                        if(c3 == 0x0a) {
                            c3 = 0;
                            c2++;
                            if(c2 == 0x0a) {
                                c2 = 0;
                                c1++;
                                if(c1 == 0x0a) {
                                    c1 = 0;
                                    c0++;
                                }
                            }
                        }
                    }
                }
                
                if(c4 > 5) {
                    c3++;
                    if(c3 == 0x0a) {
                        c3 = 0;
                        c2++;
                        if(c2 == 0x0a) {
                            c2 = 0;
                            c1++;
                            if(c1 == 0x0a) {
                                c1 = 0;
                                c0++;
                            }
                        }
                    }
                }
                
                e0 = c0;
                e1 = c1;// + dp;
                e2 = c2;
                e3 = c3;
                e2.7 = 1;
            }
            else {
                if(c1) {
                    if(c5 > 5) {
                        c4++;
                        if(c4 == 0x0a) {
                            c4 = 0;
                            c3++;
                            if(c3 == 0x0a) {
                                c3 = 0;
                                c2++;
                                if(c2 == 0x0a) {
                                    c2 = 0;
                                    c1++;
                                    if(c1 == 0x0a) {
                                        c1 = 0;
                                        c0++;
                                    }
                                }
                            }
                        }
                    }
                    
                    e0 = c1;
                    e1 = c2;// + dp;
                    e2 = c3;
                    e3 = c4;
                    e1.7 = 1;
                }
                else {
                    e0 = c2;// + dp;
                    e1 = c3;
                    e2 = c4;
                    e3 = c5;
                    e0.7 = 1;
                }
            }
            
        }
        
        while(PORTB.4 || PORTB.5) continue; // waiting for end of arrow
        
        delay(1);
    }
}


void delay(u8 dly_val) {
    while(dly_val > 0) {
        dly_val--;
        u8 dly_val0 = 0xff;
        while(dly_val0 > 0) {
            dly_val0--;
            u8 dly_val1 = 0xff;
            while(dly_val1 > 0) {
                dly_val1--;
                nop();
                nop();
                nop();
            }
        }
    }
}


void delay_50u(void) {
    u8 tmp_delay=29;
    while(tmp_delay != 0) {
        tmp_delay--;
    }
}


void div_24_24(void) {
    u8 result_tail = 0;
    
    //  LH | LM | LL
    //  ______________
    //  TMRHH | TMRLL
    
    u8 lh = LH;
    u8 lm = LM;
    u8 ll = LL;
//  u16 lt = LT;
//  u16 tmp = 0;
    
    result = 0;
    result_tail = 0;
    
    if(TMR1HH || TMR1H || TMR1L) {
        while(1) {
            ll -= TMR1L;
            if(!Carry) {
                W = 1;
                lm -= W;
                if(!Carry) {
                    W = 1;
                    lh -= W;
                    if(!Carry) {
                        lh++;
                        lm++;
                        ll += TMR1L;
                        break;
                    }
                }
            }
            
            lm -= TMR1H;
            if(!Carry) {
                W = 1;
                lh -= W;
                if(!Carry) {
                    lh++;
                    lm += TMR1H;
                    ll += TMR1L;
                    break;
                }
            }
            
            lh -= TMR1HH;
            if(!Carry) {
                lh += TMR1HH;
                break;
            }
            
            result++;
        }
        
    }
    
    
    
    
    tmpLL = ll;
    tmpLH = lm;
    tmpHL = lh;
    
    
    STATUS.0 = 0;
    RLF(tmpLL, 1);  // x2
    RLF(tmpLH, 1);
    RLF(tmpHL, 1);
    
    STATUS.0 = 0;
    RLF(tmpLL, 1);  // x4
    RLF(tmpLH, 1);
    RLF(tmpHL, 1);
    
    STATUS.0 = 0;
    RLF(tmpLL, 1);  // x8
    RLF(tmpLH, 1);
    RLF(tmpHL, 1);
    
    STATUS.0 = 0;
    RLF(ll, 1);     // x2
    RLF(lm, 1);
    RLF(lh, 1);
    
    ll += tmpLL;    // x2 + x8 = x10
    if(Carry) {
        W = 1;
        lm += W;
        if(Carry)
            lh++;
    }
    
    lm += tmpLH;
    if(Carry)
        lh++;
    
    lh += tmpHL;
    
    
    
    while(1) {
        ll -= TMR1L;
        if(!Carry) {
            W = 1;
            lm -= W;
            if(!Carry) {
                W = 1;
                lh -= W;
                if(!Carry) {
                    lh++;
                    lm++;
                    ll += TMR1L;
                    break;
                }
            }
        }
        
        lm -= TMR1H;
        if(!Carry) {
            W = 1;
            lh -= W;
            if(!Carry) {
                lh++;
                lm += TMR1H;
                ll += TMR1L;
                break;
            }
        }
        
        lh -= TMR1HH;
        if(!Carry) {
            lh += TMR1HH;
            break;
        }
        result_tail++;
    }
    
    
    // v*10
    
    tmp16 = result;
    
    Carry = 0;
    
    RLF(result.high8, 1);   // *2
    RLF(result.low8, 1);
    
    RLF(result.high8, 1);   // *4
    RLF(result.low8, 1);
    
    RLF(result.high8, 1);   // *8
    RLF(result.low8, 1);

    result += tmp16;
    result += tmp16;
    
    result += result_tail;

    
}


void correct_mass(void) {
    while(b0 || b1) continue;
    
    calc_value8(mass);
    m0 = c0;
    m1 = c1;
    m2 = c2;
    
    TMR2H = 0x16;
    M = 1;
    counter8 = 0;
    while(counter8 < 3) {
        if(b0) {
            switch(counter8) {
                case 0: {
                    m0 ++;
                    if(m0 > 2)
                        m0 = 0;
                    break;
                }
                
                case 1: {
                    m1++;
                    if(m1 > 9 || (m0 == 2 && m1 > 5))
                        m1 = 0;
                    break;
                }
                
                case 2: {
                    m2++;
                    if(m2 > 9 || (m0 == 2 && m1 == 5 && m2 > 5))
                        m2 = 0;
                    break;
                }
            }
            
            while(b0) continue;
            delay(2);
        }
        
        if(b1) {
            counter8++;
            if(counter8 == 1 && m0 == 2 && m1 > 5)
                m1 = 5;
            
            if(counter8 == 2 && m0 == 2 && m1 == 5 && m2 > 5)
                m2 = 5;
            
            while(b1) continue;
            delay(2);
        }
        
    }

    mass = m0;
    mass = mass*100;
    tmp8 = m1;
    tmp8 = tmp8*10;
    mass += tmp8;
    mass += m2;
    
    EEADR = 0x00;
    EECON1.RD = 1;
    while(EECON1.RD) continue;
    
    if(EEDATA != mass) {
        EEDATA = mass;
        EEADR = 0x00;
        EECON1.WREN = 1;
        GIE = 0;
        while(GIE) GIE = 0;
        EECON2 = 0x55;
        EECON2 = 0xaa;
        EECON1.WR = 1;
        GIE = 1;
    }
    
    blink = 0;
    
    T0IE = 0;
    PORTB &= 0xf0;
    delay(1);
    
    T0IE = 1;
    delay(1);
    
    T0IE = 0;
    PORTB &= 0xf0;
    delay(1);
    
    T0IE = 1;
    delay(1);
    
    T0IE = 0;
    PORTB &= 0xf0;
    delay(1);
    
    T0IE = 1;
    
}


void calc_enrg(void) {
    
    enrg_H = 0;
    enrg_L = 0;
    
    // sqr(v*10)
    
    counter16 = result;
    while(counter16) {
        enrg_L.low8 += result.low8;
        if(Carry) {
            W = 1;
            enrg_L.high8 += W;
            if(Carry) {
                W = 1;
                enrg_H.low8 += W;
                if(Carry)
                    enrg_H.high8++;
            }
        }
        
        enrg_L.high8 += result.high8;
        if(Carry) {
            W = 1;
            enrg_H.low8 += W;
            if(Carry)
                enrg_H.high8++;
        }
        counter16--;
    }
    
    
    // sqr(v*10)/2
    
    Carry = 0;
    
    RRF(enrg_H, 1);
    RRF(enrg_L, 1);
    
    
    // (sqr(v*10)*mass*100000)/2
    
    
    u8 vhh = enrg_H.high8;
    u8 vhl = enrg_H.low8;
    u8 vlh = enrg_L.high8;
    u8 vll = enrg_L.low8;
    
    enrg_H = 0;
    enrg_L = 0;
    
    
    counter8 = mass;
    while(counter8) {
        enrg_L.low8 += vll;
        if(Carry) {
            W = 1;
            enrg_L.high8 += W;
            if(Carry) {
                W = 1;
                enrg_H.low8 += W;
                if(Carry) {
                    enrg_H.high8++;
                }
            }
        }
        
        enrg_L.high8 += vlh;
        if(Carry) {
            W = 1;
            enrg_H.low8 += W;
            if(Carry) {
                enrg_H.high8++;
            }
        }
        
        
        enrg_H.low8 += vhl;
        if(Carry) {
            enrg_H.high8++;
        }
        
        enrg_H.high8 += vhh;
        
        counter8--;
    }
    
}


void calc_value32(void) {
    // convert 0xff 0xff 0xff 0xff -> c0|c1|c2|c3|c4|c5|c6|c7|c8|c9
    c0 = 0;
    c1 = 0;
    c2 = 0;
    c3 = 0;
    c4 = 0;
    c5 = 0;
    c6 = 0;
    c7 = 0;
    c8 = 0;
    c9 = 0;
    
    // 0x3b 9a ca 00
    FSR = &c0;
    calc_char();
    
    // 0x5 f5 e1 00
    FSR = &c1;
    calc_char();
    
    // 0x98 96 80
    FSR = &c2;
    calc_char();
    
    // 0xf 42 40
    FSR = &c3;
    calc_char();
    
    // 0x1 86 a0
    FSR = &c4;
    calc_char();
    
    FSR = &c5;
    calc_char();
    
    FSR = &c6;
    calc_char();
    
    FSR = &c7;
    calc_char();
    
    FSR = &c8;
    calc_char();
    
    c9 = tmp32LL;
    
}


void calc_char(void) {
    // FSR = c0..c9
    
    u8 vhh;
    u8 vhl;
    u8 vlh;
    u8 vll;
    
    switch(FSR) {
        // 0x3b 9a ca 00
        case (&c0): {
            vhh = 0x3b;
            vhl = 0x9a;
            vlh = 0xca;
            vll = 0x00;
            
            break;
        }
        
        // 0x05 f5 e1 00
        case (&c1): {
            vhh = 0x05;
            vhl = 0xf5;
            vlh = 0xe1;
            vll = 0x00;
            
            break;
        }
    
        // 0x00 98 96 80
        case (&c2): {
            vhh = 0x00;
            vhl = 0x98; 
            vlh = 0x96;
            vll = 0x80;
            
            break;
        }
    
        // 0x00 0f 42 40
        case (&c3): {
            vhh = 0x00; 
            vhl = 0x0f;
            vlh = 0x42;
            vll = 0x40;
            
            break;
        }
    
        // 0x1 86 a0
        case (&c4): {
            vhh = 0x00;
            vhl = 0x01;
            vlh = 0x86;
            vll = 0xa0;
            
            break;
        }
    
    // 0x00 00 0d10000;
        case (&c5): {
            vhh = 0x00;
            vhl = 0x00;
            vlh = 0x27;
            vll = 0x10;
            
            break;
        }
    
        // 0x00 00 0d1000;
        case (&c6): {
            vhh = 0x00;
            vhl = 0x00;
            vlh = 0x03;
            vll = 0xe8;
            
            break;
        }
    
        // 0x00 00, 0d100;
        case (&c7): {
            vhh = 0x00;
            vhl = 0x00;
            vlh = 0x00;
            vll = 0x64;
            
            break;
        }
    
        // 0x00 00, 0d10;
        case (&c8): {
            vhh = 0x00;
            vhl = 0x00;
            vlh = 0x00;
            vll = 0x0a;
            
            break;
        }
    }
    
    
    while(1) {
        if(vhh) {
            tmp32HH -= vhh;
            if(!Carry) {
                tmp32HH += vhh;
                break;
            }
        }
            
        if(vhl) {
            tmp32HL -= vhl;
            if(!Carry) {
                tmp32HL += vhl;
                W = 1;
                tmp32HH -= W;
                if(!Carry) {
                    tmp32HH++;
                    tmp32HH += vhh;
                    break;
                }
                
                tmp8 = 0x00;
                tmp8 -= vhl;
                tmp32HL += tmp8;
                
            }
        }
            
        if(vlh) {
            tmp32LH -= vlh;
            if(!Carry) {
                tmp32LH += vlh;
                W = 1;
                tmp32HL -= W;
                if(!Carry) {
                    W = 1;
                    tmp32HH -= W;
                    if(!Carry) {
                        tmp32HH++;
                        tmp32HL++;
                        tmp32HL += vhl;
                        tmp32HH += vhh;
                        break;
                    }
                }
                
                tmp8 = 0x00;
                tmp8 -= vlh;
                tmp32LH += tmp8;
            }
        }
            
        if(vll) { // ??
            tmp32LL -= vll;
            if(!Carry) {
                tmp32LL += vll;
                W = 1;
                tmp32LH -= W;
                if(!Carry) {
                    W = 1;
                    tmp32HL -= W;
                    if(!Carry) {
                        W = 1;
                        tmp32HH -= W;
                        if(!Carry) {
                            tmp32HH++;
                            tmp32HL++;
                            tmp32LH++;
                            
                            tmp32LH += vlh;
                            tmp32HL += vhl;
                            tmp32HH += vhh;
                            break;
                        }
                    }
                }
                
                tmp8 = 0x00;
                tmp8 -= vll;
                tmp32LL += tmp8;
            }
        }
        INDF++;
    }
}


void calc_value16(u16 value) {
    // convert 0xffff -> c0|c1|c2|c3|c4
    c0 = 0;
    c1 = 0;
    c2 = 0;
    c3 = 0;
    c4 = 0;
    
    if(value < 10000)
        c0 = 0;
    else {
        while(value >= 10000) {
            value -= 10000;
            c0++;
        }
    }
    
    if(value < 1000)
        c1 = 0;
    else {
        while(value >= 1000) {
            value -= 1000;
            c1++;
        }
    }
    
    if(value < 100)
        c2 = 0;
    else {
        while(value >= 100) {
            value -= 100;
            c2++;
        }
    }
    
    if(value < 10)
        c3 = 0;
    else {
        while(value >= 10) {
            value -= 10;
            c3++;
        }
    }
    
    c4 = value;
    
}


void calc_value8(u8 value) {
    // convert 0xffff -> c0|c1|c2|c3|c4
    c0 = 0;
    c1 = 0;
    c2 = 0;
    
    if(value < 100)
        c0 = 0;
    else {
        while(value >= 100) {
            value -= 100;
            c0++;
        }
    }
    
    if(value < 10)
        c1 = 0;
    else {
        while(value >= 10) {
            value -= 10;
            c1++;
        }
    }
    
    c2 = value;
    
}




