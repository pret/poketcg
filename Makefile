.PHONY: all compare clean

ROMS := tcg.gbc
OBJS := main.o

all: tcg.gbc compare
compare: baserom.gbc $(ROMS)
	cmp $^

%.o: %.asm
	rgbasm -o $@ $<

tcg.gbc: $(OBJS)
	rgblink -o $@ $^
	rgbfix -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03 -t POKECARD -i AXQE $@

clean:
	rm -f $(ROMS)
	rm -f $(OBJS)