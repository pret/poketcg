.PHONY: all compare clean

.SUFFIXES:
.SUFFIXES: .asm .o .gbc .png .2bpp .1bpp .pal
.SECONDEXPANSION:

OBJS = src/main.o src/gfx.o src/text.o src/audio.o src/wram.o

$(foreach obj, $(OBJS), \
	$(eval $(obj:.o=)_dep = $(shell python extras/scan_includes.py $(obj:.o=.asm))) \
)

all: tcg.gbc compare

compare: baserom.gbc tcg.gbc
	cmp baserom.gbc tcg.gbc

$(OBJS): $$*.asm $$($$*_dep)
	rgbasm -i src/ -o $@ $<

tcg.gbc: $(OBJS)
	rgblink -n $*.sym -o $@ $(OBJS)
	rgbfix -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03 -t POKECARD -i AXQE $@

clean:
	rm -f tcg.gbc $(OBJS) *.sym
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pal' \) -exec rm {} +

.png.pal: ;	

.png.2bpp:
	@rgbgfx -o $@ $<

.png.1bpp:
	@rgbgfx -b -o $@ $<
