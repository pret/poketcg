SECTION "SRAM", SRAM

sa000:: ds $3 ; a000

sa003:: ds $1 ; a003
sa004:: ds $1 ; a004
sa005:: ds $1 ; a005
sa006:: ds $1 ; a006
sa007:: ds $1 ; a007
sa008:: ds $1 ; a008
sa009:: ds $1 ; a009
sa00a:: ds $1 ; a00a

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

sa350:: ds DECK_NAME_SIZE + DECK_SIZE ; a350
sa3a4:: ds DECK_NAME_SIZE + DECK_SIZE ; a3a4
sa3f8:: ds DECK_NAME_SIZE + DECK_SIZE ; a3f8
