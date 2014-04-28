INCLUDE "constants.asm"
INCLUDE "macros.asm"
INCLUDE "wram.asm"

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

SECTION "bank8",ROMX,BANK[$8]
INCBIN "baserom.gbc",$20000,$4000

SECTION "bank9",ROMX,BANK[$9]
	emptybank

SECTION "bankA",ROMX,BANK[$A]
	emptybank

SECTION "bankB",ROMX,BANK[$B]
INCBIN "baserom.gbc",$2C000,$4000

SECTION "bankC",ROMX,BANK[$C]
Unknown_30000: ; 30000 (c:4000)
INCBIN "baserom.gbc",$30000,$4000

SECTION "bankD",ROMX,BANK[$D]
TextOffsets: ; 34000 (d:4000)
INCBIN "baserom.gbc",$34000,$3630a - $34000
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

SECTION "bank1C",ROMX,BANK[$1C]
INCLUDE "engine/bank1c.asm"

SECTION "bank1D",ROMX,BANK[$1D]
INCBIN "baserom.gbc",$74000,$76668 - $74000
Unknown_76668: ; 76668 (1d:6668)
INCBIN "baserom.gbc",$76668,$78000 - $76668

SECTION "bank1E",ROMX,BANK[$1E]
INCBIN "baserom.gbc",$78000,$4000

SECTION "bank1F",ROMX,BANK[$1F]
	emptybank

SECTION "bank20",ROMX,BANK[$20]
INCLUDE "engine/bank20.asm"

SECTION "bank21",ROMX,BANK[$21]
INCBIN "baserom.gbc",$84000,$4000

SECTION "bank22",ROMX,BANK[$22]
INCBIN "baserom.gbc",$88000,$4000

SECTION "bank23",ROMX,BANK[$23]
INCBIN "baserom.gbc",$8C000,$4000

SECTION "bank24",ROMX,BANK[$24]
INCBIN "baserom.gbc",$90000,$4000

SECTION "bank25",ROMX,BANK[$25]
INCBIN "baserom.gbc",$94000,$4000

SECTION "bank26",ROMX,BANK[$26]
INCBIN "baserom.gbc",$98000,$4000

SECTION "bank27",ROMX,BANK[$27]
INCBIN "baserom.gbc",$9C000,$4000

SECTION "bank28",ROMX,BANK[$28]
INCBIN "baserom.gbc",$A0000,$4000

SECTION "bank29",ROMX,BANK[$29]
INCBIN "baserom.gbc",$A4000,$4000

SECTION "bank2A",ROMX,BANK[$2A]
INCBIN "baserom.gbc",$A8000,$4000

SECTION "bank2B",ROMX,BANK[$2B]
INCBIN "baserom.gbc",$AC000,$4000

SECTION "bank2C",ROMX,BANK[$2C]
INCBIN "baserom.gbc",$B0000,$4000

SECTION "bank2D",ROMX,BANK[$2D]
INCBIN "baserom.gbc",$B4000,$4000

SECTION "bank2E",ROMX,BANK[$2E]
INCBIN "baserom.gbc",$B8000,$4000

SECTION "bank2F",ROMX,BANK[$2F]
	emptybank

SECTION "bank30",ROMX,BANK[$30]
	emptybank

SECTION "bank31",ROMX,BANK[$31]
INCBIN "baserom.gbc",$C4000,$4000

SECTION "bank32",ROMX,BANK[$32]
INCBIN "baserom.gbc",$C8000,$4000

SECTION "bank33",ROMX,BANK[$33]
INCBIN "baserom.gbc",$CC000,$4000

SECTION "bank34",ROMX,BANK[$34]
INCBIN "baserom.gbc",$D0000,$4000

SECTION "bank35",ROMX,BANK[$35]
INCBIN "baserom.gbc",$D4000,$4000

SECTION "bank36",ROMX,BANK[$36]
INCBIN "baserom.gbc",$D8000,$4000

SECTION "bank37",ROMX,BANK[$37]
INCBIN "baserom.gbc",$DC000,$4000

SECTION "bank38",ROMX,BANK[$38]
INCBIN "baserom.gbc",$E0000,$4000

SECTION "bank39",ROMX,BANK[$39]
INCBIN "baserom.gbc",$E4000,$4000

SECTION "bank3A",ROMX,BANK[$3A]
INCBIN "baserom.gbc",$E8000,$4000

SECTION "bank3B",ROMX,BANK[$3B]
INCBIN "baserom.gbc",$EC000,$4000

SECTION "bank3C",ROMX,BANK[$3C]
	emptybank

SECTION "bank3D",ROMX,BANK[$3D]
INCLUDE "engine/music1.asm"

SECTION "bank3E",ROMX,BANK[$3E]
INCLUDE "engine/music2.asm"

SECTION "bank3F",ROMX,BANK[$3F]
INCLUDE "engine/sfx.asm"