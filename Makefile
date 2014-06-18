.PHONY: all compare clean

.SUFFIXES:
.SUFFIXES: .asm .o .gbc .png
.SECONDEXPANSION:

ROMS := tcg.gbc
OBJS := main.o

main_dep := $(shell python extras/scan_includes.py main.asm)

all: tcg.gbc compare
compare: baserom.gbc $(ROMS)
	cmp $^

$(OBJS): $$*.asm $$($$*_dep)
	@python extras/gfx.py 2bpp $(2bppq)
	@python extras/gfx.py 1bpp $(1bppq)
	rgbasm -o $@ $<

tcg.gbc: $(OBJS)
	rgblink -n tcg.sym -m tcg.map -o $@ $^
	rgbfix -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03 -t POKECARD -i AXQE $@

clean:
	rm -f $(ROMS)
	rm -f $(OBJS)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -exec rm {} +

%.2bpp: %.png
	$(eval 2bppq += $<)
	@rm -f $@

%.1bpp: %.png
	$(eval 1bppq += $<)
	@rm -f $@
