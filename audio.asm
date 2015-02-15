INCLUDE "constants.asm"
INCLUDE "macros.asm"
INCLUDE "hram.asm"

SECTION "bank3D",ROMX,BANK[$3D]
INCLUDE "audio/music1.asm"

SECTION "bank3E",ROMX,BANK[$3E]
INCLUDE "audio/music2.asm"

SECTION "bank3F",ROMX,BANK[$3F]
INCLUDE "audio/sfx.asm"
