INCLUDE "constants.asm"
INCLUDE "macros.asm"

INCLUDE "engine/home.asm"

SECTION "bank1",ROMX,BANK[$1]
INCLUDE "engine/bank1.asm"

SECTION "bank2",ROMX,BANK[$2]
INCLUDE "engine/bank2.asm"

SECTION "bank3",ROMX,BANK[$3]
INCLUDE "engine/bank3.asm"

SECTION "bank4",ROMX,BANK[$4]
INCLUDE "engine/bank4.asm"

SECTION "bank5",ROMX,BANK[$5]
INCBIN "baserom.gbc",$14000,$4000

SECTION "bank6",ROMX,BANK[$6]
INCLUDE "engine/bank6.asm"

SECTION "bank7",ROMX,BANK[$7]
INCLUDE "engine/bank7.asm"
INCLUDE "engine/boosters.asm"

SECTION "bank8",ROMX,BANK[$8]
INCBIN "baserom.gbc",$20000,$4000

SECTION "bank9",ROMX,BANK[$9]
	emptybank

SECTION "bankA",ROMX,BANK[$A]
	emptybank

SECTION "bankB",ROMX,BANK[$B]
INCLUDE "engine/effect_functions.asm"

SECTION "bankC",ROMX,BANK[$C]
INCLUDE "data/decks.asm"
INCLUDE "data/cards.asm"

SECTION "bank1C",ROMX,BANK[$1C]
INCLUDE "engine/bank1c.asm"

SECTION "bank20",ROMX,BANK[$20]
INCLUDE "engine/bank20.asm"
