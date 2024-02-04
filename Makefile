rom := poketcg.gbc

rom_obj := \
	src/main.o \
	src/home.o \
	src/gfx.o \
	src/text.o \
	src/audio.o \
	src/wram.o \
	src/hram.o


### Build tools

ifeq (,$(shell which sha1sum))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink


### Build targets

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: all tcg clean tidy compare tools

all: $(rom) compare
tcg: $(rom) compare

clean: tidy
	find src/gfx \
	     \( -iname '*.1bpp' \
	        -o -iname '*.2bpp' \
	        -o -iname '*.pal' \) \
	     -delete

	find src/data \
	     \( -iname '*.lz' \
	        -o -iname '*.bgmap' \) \
	     -delete

tidy:
	$(RM) $(rom) \
	      $(rom:.gbc=.sym) \
	      $(rom:.gbc=.map) \
	      $(rom_obj) \
	      src/rgbdscheck.o
	$(MAKE) clean -C tools/

compare: $(rom)
	@$(SHA1) -c rom.sha1

tools:
	$(MAKE) -C tools/


RGBASMFLAGS = -I src/ -Weverything
# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBASMFLAGS += -E
endif

src/rgbdscheck.o: src/rgbdscheck.asm
	$(RGBASM) -o $@ $<

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tidy tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
define DEP
$1: $2 $$(shell tools/scan_includes -s -I src/ $2) | src/rgbdscheck.o
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Dependencies for objects
$(foreach obj, $(rom_obj), $(eval $(call DEP,$(obj),$(obj:.o=.asm))))

endif


%.asm: ;


opts = -cjsv -k 01 -l 0x33 -m 0x1b -p 0xff -r 03 -t POKECARD -i AXQE

$(rom): $(rom_obj) src/layout.link
	$(RGBLINK) -p 0xff -m $(rom:.gbc=.map) -n $(rom:.gbc=.sym) -l src/layout.link -o $@ $(filter %.o,$^)
	$(RGBFIX) $(opts) $@


### Misc file-specific graphics rules

src/gfx/booster_packs/colosseum2.2bpp: rgbgfx += -x 10
src/gfx/booster_packs/evolution2.2bpp: rgbgfx += -x 10
src/gfx/booster_packs/laboratory2.2bpp: rgbgfx += -x 10
src/gfx/booster_packs/mystery2.2bpp: rgbgfx += -x 10

src/gfx/cards/%.2bpp: rgbgfx += -Z -P

src/gfx/duel/anims/result.2bpp: rgbgfx += -x 10
src/gfx/duel/dmg_sgb_symbols.2bpp: rgbgfx += -x 7
src/gfx/duel/other.2bpp: rgbgfx += -x 7

src/gfx/fonts/full_width/4.1bpp: rgbgfx += -x 3

src/gfx/link/card_pop_scene.2bpp: rgbgfx += -x 3
src/gfx/link/link_scene.2bpp: rgbgfx += -x 3
src/gfx/link/printer_scene.2bpp: rgbgfx += -x 3

src/gfx/overworld_map.2bpp: rgbgfx += -x 15

src/gfx/tilesets/challengehall.2bpp: rgbgfx += -x 3
src/gfx/tilesets/clubentrance.2bpp: rgbgfx += -x 15
src/gfx/tilesets/clublobby.2bpp: rgbgfx += -x 8
src/gfx/tilesets/fightingclub.2bpp: rgbgfx += -x 13
src/gfx/tilesets/fireclub.2bpp: rgbgfx += -x 9
src/gfx/tilesets/grassclub.2bpp: rgbgfx += -x 9
src/gfx/tilesets/hallofhonor.2bpp: rgbgfx += -x 7
src/gfx/tilesets/ishihara.2bpp: rgbgfx += -x 3
src/gfx/tilesets/lightningclub.2bpp: rgbgfx += -x 13
src/gfx/tilesets/masonlaboratory.2bpp: rgbgfx += -x 9
src/gfx/tilesets/pokemondome.2bpp: rgbgfx += -x 1
src/gfx/tilesets/pokemondomeentrance.2bpp: rgbgfx += -x 2
src/gfx/tilesets/psychicclub.2bpp: rgbgfx += -x 6
src/gfx/tilesets/rockclub.2bpp: rgbgfx += -x 4
src/gfx/tilesets/scienceclub.2bpp: rgbgfx += -x 14
src/gfx/tilesets/waterclub.2bpp: rgbgfx += -x 15

src/gfx/titlescreen/japanese_title_screen.2bpp: rgbgfx += -x 15
src/gfx/titlescreen/japanese_title_screen_cgb.2bpp: rgbgfx += -x 15
src/gfx/titlescreen/japanese_title_screen_2.2bpp: rgbgfx += -x 12
src/gfx/titlescreen/japanese_title_screen_2_cgb.2bpp: rgbgfx += -x 5
src/gfx/titlescreen/title_screen.2bpp: rgbgfx += -x 4
src/gfx/titlescreen/title_screen_cgb.2bpp: rgbgfx += -x 12


### Catch-all graphics rules

%.png: ;

%.pal: ;

%.2bpp: %.png
	$(RGBGFX) $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)

%.1bpp: %.png
	$(RGBGFX) $(rgbgfx) -d1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)

%.bgmap: %.bin ../dimensions/%.dimensions
	tools/bgmap $(tools/bgmap) $^ $@

# remove -m if you don't care for matching
%.lz: %
	tools/compressor -m $(tools/compressor) $< $@
