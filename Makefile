.PHONY: all compare clean

.SUFFIXES:
.SUFFIXES: .asm .o .gbc .png .2bpp .1bpp .pal
.SECONDEXPANSION:

OBJS = src/main.o src/gfx.o src/text.o src/audio.o src/wram.o src/hram.o

$(foreach obj, $(OBJS), \
	$(eval $(obj:.o=)_dep = $(shell python extras/scan_includes.py $(obj:.o=.asm))) \
)

all: tcg.gbc compare

compare: baserom.gbc tcg.gbc
	cmp baserom.gbc tcg.gbc

$(OBJS): $$*.asm $$($$*_dep)
	@python extras/gfx.py 2bpp $(2bppq)
	@python extras/gfx.py 1bpp $(1bppq)
	rgbasm -i src/ -o $@ $<

tcg.gbc: $(OBJS)
	rgblink -n $*.sym -m $*.map -o $@ $(OBJS)
	rgbfix -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03 -t POKECARD -i AXQE $@

clean:
	rm -f tcg.gbc $(OBJS) *.sym *.map
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -exec rm {} +

%.2bpp: %.png
	$(eval 2bppq += $<)
	@rm -f $@

%.1bpp: %.png
	$(eval 1bppq += $<)
	@rm -f $@
