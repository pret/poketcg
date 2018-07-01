TX_END    EQU $00
TX_SYMBOL EQU $05
TX_START  EQU $06
TX_RAM1   EQU $09
TX_LINE   EQU "\n" ; $0a
TX_RAM2   EQU $0B
TX_RAM3   EQU $0C

text EQUS "db TX_START, "
line EQUS "db TX_LINE, "
done EQUS "db TX_END"

	charmap "é", "`"
	charmap "♂", "$"
	charmap "♀", "%"
	charmap "”", "\""

; TX_SYMBOL (full-tile icons/symbols loaded at the beginning of v0Tiles2)
; TODO: Use symbols in menus (cursor tile number, tile behind cursor), draw text boxes, WriteByteToBGMap0, etc
;       If user-defined functions ever become a thing a symbol(*) syntax would probably be preferred over SYM_*

	charmap "<", TX_SYMBOL
	const_def
	txsymbol SPACE
	txsymbol FIRE
	txsymbol GRASS
	txsymbol LIGHTNING
	txsymbol WATER
	txsymbol FIGHTING
	txsymbol PSYCHIC
	txsymbol COLORLESS
	txsymbol POISONED
	txsymbol ASLEEP
	txsymbol CONFUSED
	txsymbol PARALYZED
	txsymbol CURSOR_U
	txsymbol POKEMON
	txsymbol UNKNOWN_0E
	txsymbol CURSOR_R
	txsymbol HP
	txsymbol Lv
	txsymbol E
	txsymbol No
	txsymbol PLUSPOWER
	txsymbol DEFENDER
	txsymbol HP_OK
	txsymbol HP_NOK
	txsymbol BOX_TOP_L
	txsymbol BOX_TOP_R
	txsymbol BOX_BTM_L
	txsymbol BOX_BTM_R
	txsymbol BOX_TOP
	txsymbol BOX_BOTTOM
	txsymbol BOX_LEFT
	txsymbol BOX_RIGHT
	txsymbol 0
	txsymbol 1
	txsymbol 2
	txsymbol 3
	txsymbol 4
	txsymbol 5
	txsymbol 6
	txsymbol 7
	txsymbol 8
	txsymbol 9
	txsymbol DOT
	txsymbol PLUS
	txsymbol MINUS
	txsymbol x
	txsymbol SLASH
	txsymbol CURSOR_D
	txsymbol PRIZE
