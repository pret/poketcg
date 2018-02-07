INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "engine/home.asm"

SECTION "bank1", ROMX
INCLUDE "engine/bank1.asm"

SECTION "bank2", ROMX
INCLUDE "engine/bank2.asm"

SECTION "bank3", ROMX
INCLUDE "engine/bank3.asm"

SECTION "bank4", ROMX
INCLUDE "engine/bank4.asm"

SECTION "bank5", ROMX
INCLUDE "engine/bank5.asm"

SECTION "bank6", ROMX
INCLUDE "engine/bank6.asm"

SECTION "bank7", ROMX
INCLUDE "engine/bank7.asm"

SECTION "Booster Packs", ROMX
INCLUDE "engine/booster_packs.asm"

SECTION "bank8", ROMX
INCLUDE "engine/bank8.asm"

SECTION "bank9", ROMX
	emptybank

SECTION "bankA", ROMX
	emptybank

SECTION "Effect Functions", ROMX
INCLUDE "engine/effect_functions.asm"

SECTION "Decks", ROMX
INCLUDE "data/decks.asm"

SECTION "Cards", ROMX
INCLUDE "data/cards.asm"

SECTION "bank1C", ROMX
INCLUDE "engine/bank1c.asm"

SECTION "bank20", ROMX
INCLUDE "engine/bank20.asm"
