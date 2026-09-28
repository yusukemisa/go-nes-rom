CA65 ?= ca65
LD65 ?= ld65

SRC := src/yusuke.s
CFG := src/nes.cfg
ROM := roms/yusuke.nes

.PHONY: all clean

all: $(ROM)

$(ROM): $(SRC) $(CFG)
	mkdir -p roms
	$(CA65) -o roms/yusuke.o $(SRC)
	$(LD65) -C $(CFG) -o $(ROM) roms/yusuke.o
	rm -f roms/yusuke.o

clean:
	rm -f roms/yusuke.o $(ROM)
