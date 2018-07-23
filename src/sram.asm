SECTION "SRAM0", SRAM

s0a000:: ds $3 ; a000

s0a003:: ds $1 ; a003
s0a004:: ds $1 ; a004
s0a005:: ds $1 ; a005
s0a006:: ds $1 ; a006
s0a007:: ds $1 ; a007
s0a008:: ds $1 ; a008
s0a009:: ds $1 ; a009
s0a00a:: ds $1 ; a00a

	ds $5

sPlayerName:: ds $10 ; a010

	ds $e0

; for each card, how many (0-127) the player owns
; CARD_NOT_OWNED ($80) indicates that the player has not yet seen the card
sCardCollection:: ds $100 ; a100

sDeck1Name::  ds DECK_NAME_SIZE ; a200
sDeck1Cards:: ds DECK_SIZE      ; a218

sDeck2Name::  ds DECK_NAME_SIZE ; a254
sDeck2Cards:: ds DECK_SIZE      ; a26c

sDeck3Name::  ds DECK_NAME_SIZE ; a2a8
sDeck3Cards:: ds DECK_SIZE      ; a2c0

sDeck4Name::  ds DECK_NAME_SIZE ; a2fc
sDeck4Cards:: ds DECK_SIZE      ; a314

s0a350:: ds DECK_NAME_SIZE + DECK_SIZE ; a350
s0a3a4:: ds DECK_NAME_SIZE + DECK_SIZE ; a3a4
s0a3f8:: ds DECK_NAME_SIZE + DECK_SIZE ; a3f8

SECTION "SRAM1", SRAM

SECTION "SRAM2", SRAM

	ds $1c00

; saved data of the current duel, including a two-byte checksum
; see SaveDuelDataToDE
sCurrentDuelData:: ds $33e ; bc00

SECTION "SRAM3", SRAM
