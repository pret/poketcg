INCLUDE "constants.asm"
INCLUDE "macros.asm"

SECTION "bankD",ROMX,BANK[$D]
INCLUDE "text/text_offsets.asm"
INCLUDE "text/text1.asm"

SECTION "bankE",ROMX,BANK[$E]
INCLUDE "text/text2.asm"

SECTION "bankF",ROMX,BANK[$F]
INCLUDE "text/text3.asm"

SECTION "bank10",ROMX,BANK[$10]
INCLUDE "text/text4.asm"

SECTION "bank11",ROMX,BANK[$11]
INCLUDE "text/text5.asm"

SECTION "bank12",ROMX,BANK[$12]
INCLUDE "text/text6.asm"

SECTION "bank13",ROMX,BANK[$13]
INCLUDE "text/text7.asm"

SECTION "bank14",ROMX,BANK[$14]
INCLUDE "text/text8.asm"

SECTION "bank15",ROMX,BANK[$15]
INCLUDE "text/text9.asm"

SECTION "bank16",ROMX,BANK[$16]
INCLUDE "text/texta.asm"

SECTION "bank17",ROMX,BANK[$17]
INCLUDE "text/textb.asm"

SECTION "bank18",ROMX,BANK[$18]
INCLUDE "text/textc.asm"

SECTION "bank19",ROMX,BANK[$19]
INCLUDE "text/textd.asm"

SECTION "bank1A",ROMX,BANK[$1A]
	emptybank

SECTION "bank1B",ROMX,BANK[$1B]
	emptybank
