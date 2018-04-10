INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "engine/home.asm"

SECTION "Bank 1", ROMX
INCLUDE "engine/bank01.asm"

SECTION "Bank 2", ROMX
INCLUDE "engine/bank02.asm"

SECTION "Bank 3", ROMX
INCLUDE "engine/bank03.asm"

SECTION "Bank 4", ROMX
INCLUDE "engine/bank04.asm"

SECTION "Bank 5", ROMX
INCLUDE "engine/bank05.asm"

SECTION "Bank 6", ROMX
INCLUDE "engine/bank06.asm"

SECTION "Bank 7", ROMX
INCLUDE "engine/bank07.asm"

SECTION "Booster Packs", ROMX
INCLUDE "engine/booster_packs.asm"

SECTION "Bank 8", ROMX
INCLUDE "engine/bank08.asm"

SECTION "Empty Bank 9", ROMX
	emptybank

SECTION "Empty Bank A", ROMX
	emptybank

SECTION "Effect Functions", ROMX
INCLUDE "engine/effect_functions.asm"

SECTION "Decks", ROMX
INCLUDE "data/decks.asm"

SECTION "Cards", ROMX
INCLUDE "data/cards.asm"

SECTION "Empty Bank 1A", ROMX
	emptybank

SECTION "Empty Bank 1B", ROMX
	emptybank

SECTION "Bank 1C", ROMX
INCLUDE "engine/bank1c.asm"

SECTION "Empty Bank 1F", ROMX
	emptybank

SECTION "Bank 20", ROMX
INCLUDE "engine/bank20.asm"

SECTION "Empty Bank 2F", ROMX
	emptybank

SECTION "Empty Bank 30", ROMX
	emptybank

SECTION "Empty Bank 3C", ROMX
	emptybank
