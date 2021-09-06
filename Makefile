


#CC = sdcc.exe
CC = CC5X
#CFLAGS = -mmcs51 -I.
CFLAGS = -dc

FLASHER = pk2cmd

PROC = PIC16F628A

CSRC = main.c

HEADER = $(CSRC:.c=.h)

TARGET = $(CSRC:.c=.hex)


.PHONY: all clean install


all: $(TARGET)


$(TARGET): $(CSRC) $(HEADER)
	$(CC) $(CFLAGS) $(CSRC)



clean:
	del /q -P *.hex *.occ


install:
	$(FLASHER) -P$(PROC) -M -F$(TARGET) -R -K -I -YP
#	#$(FLASHER) -P$(PROC) -M -F$(TARGET) -R -K -I -YP -H9

