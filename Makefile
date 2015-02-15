.PHONY: all compare clean

.SUFFIXES:
.SUFFIXES: .asm .o .gbc .png .2bpp .1bpp
.SECONDEXPANSION:

ROMS := tcg.gbc
OBJS := main.o gfx.o text.o audio.o

$(foreach obj, $(OBJS), \
	$(eval $(obj:.o=)_dep := $(shell python extras/scan_includes.py $(obj:.o=.asm))) \
)

all: $(ROMS) compare
compare: baserom.gbc $(ROMS)
	cmp $^

$(OBJS): $$*.asm $$($$*_dep)
	@python extras/gfx.py 2bpp $(2bppq)
	@python extras/gfx.py 1bpp $(1bppq)
	rgbasm -o $@ $<

tcg.gbc: $(OBJS)
	rgblink -n $(ROMS:.gbc=.sym) -o $@ $^
	rgbfix -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03 -t POKECARD -i AXQE $@

clean:
	rm -f $(ROMS) $(OBJS) $(ROMS:.gbc=.sym)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -exec rm {} +

%.2bpp: %.png
	$(eval 2bppq += $<)
	@rm -f $@

%.1bpp: %.png
	$(eval 1bppq += $<)
	@rm -f $@
