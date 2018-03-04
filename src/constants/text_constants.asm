TX_END   EQU $00
TX_LARGE EQU $05
TX_START EQU $06
TX_RAM1  EQU $09
TX_LINE  EQU "\n" ; $0a
TX_RAM2  EQU $0B
TX_RAM3  EQU $0C

text EQUS "db TX_START, "
line EQUS "db TX_LINE, "
done EQUS "db TX_END"

; TX_LARGE symbols from v0Tiles2 (full tile length)
TX_FIRE      EQUS "$05, $01"
TX_GRASS     EQUS "$05, $02"
TX_LIGHTNING EQUS "$05, $03"
TX_WATER     EQUS "$05, $04"
TX_FIGHTING  EQUS "$05, $05"
TX_PSYCHIC   EQUS "$05, $06"
TX_COLORLESS EQUS "$05, $07"
TX_HP        EQUS "$05, $10"
TX_LVL       EQUS "$05, $11"
TX_No        EQUS "$05, $13"
