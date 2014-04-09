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
	rgbfix -v $@

clean:
	rm -f $(ROMS)
	rm -f $(OBJS)