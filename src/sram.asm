SECTION "SRAM", SRAM

	ds $100

sCardCollection:: ds $100 ; a100

sDeck1Name::  ds DECK_NAME_SIZE ; a200
sDeck1Cards:: ds DECK_SIZE      ; a218

sDeck2Name::  ds DECK_NAME_SIZE ; a254
sDeck2Cards:: ds DECK_SIZE      ; a26c

sDeck3Name::  ds DECK_NAME_SIZE ; a2a8
sDeck3Cards:: ds DECK_SIZE      ; a2c0

sDeck4Name::  ds DECK_NAME_SIZE ; a2fc
sDeck4Cards:: ds DECK_SIZE      ; a314
