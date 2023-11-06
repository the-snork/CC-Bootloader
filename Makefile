#
# CC Debugger
# Fergus Noble (c) 2011
#

CC = sdcc
AS = sdas8051

CFLAGS = --model-small --opt-code-size

LDFLAGS_FLASH = \
	--out-fmt-ihx \
	--code-loc 0x0000 --code-size 0x1400 \
	--xram-loc 0xf000 --xram-size 0x300 \
	--iram-size 0x100

ASFLAGS = -plosgff

ifdef DEBUG
CFLAGS += --debug
endif

CHRONOS_FLAGS = -DRFCAT_CHRONOS
DONS_FLAGS = -DRFCAT_DONSDONGLE
YS1_FLAGS = -DRFCAT_YARDSTICKONE

SRC = \
	src/main.c \
	src/usb.c \
	src/flash.c \
	src/intel_hex.c \
	src/hal.c \
	src/usb_descriptors.c 

ASM_SRC = src/start.asm

CHRONOS_REL = $(SRC:.c=.c.chronos.rel)
DONS_REL = $(SRC:.c=.c.dons.rel)
YS1_REL = $(SRC:.c=.c.ys1.rel)

ASM_ADB = $(ASM_SRC:.asm=.adb)
ASM_LNK = $(ASM_SRC:.asm=.lnk)
ASM_LST = $(ASM_SRC:.asm=.lst)
ASM_REL = $(ASM_SRC:.asm=.rel)
ASM_RST = $(ASM_SRC:.asm=.rst)
ASM_SYM = $(ASM_SRC:.asm=.sym)

PROGS = CCBootloader-rfcat-chronosdongle.hex CCBootloader-rfcat-donsdongle.hex CCBootloader-rfcat-ys1.hex
PCDB = $(PROGS:.hex=.cdb)
PLNK = $(PROGS:.hex=.lnk)
PLK = $(PROGS:.hex=.lk)
PMAP = $(PROGS:.hex=.map)
PMEM = $(PROGS:.hex=.mem)
PAOM = $(PROGS:.hex=)

%.c.chronos.rel : %.c
	$(CC) -c $(CFLAGS) $(CHRONOS_FLAGS) -o$*.c.chronos.rel $<

%.c.dons.rel : %.c
	$(CC) -c $(CFLAGS) $(DONS_FLAGS) -o$*.c.dons.rel $<

%.c.ys1.rel : %.c
	$(CC) -c $(CFLAGS) $(YS1_FLAGS) -o$*.c.ys1.rel $<

%.rel : %.asm
	$(AS) -c $(ASFLAGS) $<

all: $(PROGS)

CCBootloader-rfcat-chronosdongle.hex: $(CHRONOS_REL) $(ASM_REL)
	$(CC) $(LDFLAGS_FLASH) $(CFLAGS) $(CHRONOS_FLAGS) -o CCBootloader-rfcat-chronosdongle.hex $(ASM_REL) $(CHRONOS_REL)

CCBootloader-rfcat-donsdongle.hex: $(DONS_REL) $(ASM_REL)
	$(CC) $(LDFLAGS_FLASH) $(CFLAGS) $(DONS_FLAGS) -o CCBootloader-rfcat-donsdongle.hex $(ASM_REL) $(DONS_REL)

CCBootloader-rfcat-ys1.hex: $(YS1_REL) $(ASM_REL)
	$(CC) $(LDFLAGS_FLASH) $(CFLAGS) $(YS1_FLAGS) -o CCBootloader-rfcat-ys1.hex $(ASM_REL) $(YS1_REL)

clean:
	rm -f src/*.c.*
	rm -f $(ASM_ADB) $(ASM_LNK) $(ASM_LST) $(ASM_REL) $(ASM_RST) $(ASM_SYM)
	rm -f $(PROGS) $(PCDB) $(PLNK) $(PLK) $(PMAP) $(PMEM) $(PAOM)

installchronosdongle: CCBootloader-rfcat-chronosdongle.hex
	goodfet.cc erase
	goodfet.cc flash CCBootloader-rfcat-chronosdongle.hex
	goodfet.cc verify CCBootloader-rfcat-chronosdongle.hex

installdonsdongle: CCBootloader-rfcat-donsdongle.hex
	goodfet.cc erase
	goodfet.cc flash CCBootloader-rfcat-donsdongle.hex
	goodfet.cc verify CCBootloader-rfcat-donsdongle.hex

installys1dongle: CCBootloader-rfcat-ys1.hex
	goodfet.cc erase
	goodfet.cc flash CCBootloader-rfcat-ys1.hex
	goodfet.cc verify CCBootloader-rfcat-ys1.hex

