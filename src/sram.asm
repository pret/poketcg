SECTION "SRAM0", SRAM

s0a000:: ; a000
	ds $3

s0a003:: ; a003
	ds $1
s0a004:: ; a004
	ds $1
s0a005:: ; a005
	ds $1
s0a006:: ; a006
	ds $1
s0a007:: ; a007
	ds $1
s0a008:: ; a008
	ds $1
s0a009:: ; a009
	ds $1
s0a00a:: ; a00a
	ds $1
s0a00b:: ; a00b
	ds $1
s0a00c:: ; a00c
	ds $4

sPlayerName:: ; a010
	ds NAME_BUFFER_LENGTH

	ds $e0

; for each card, how many (0-127) the player owns
; CARD_NOT_OWNED ($80) indicates that the player has not yet seen the card
sCardCollection:: ; a100
	ds $100

sDeck1Name:: ; a200
	ds DECK_NAME_SIZE
sDeck1Cards:: ; a218
	ds DECK_SIZE

sDeck2Name:: ; a254
	ds DECK_NAME_SIZE
sDeck2Cards:: ; a26c
	ds DECK_SIZE

sDeck3Name:: ; a2a8
	ds DECK_NAME_SIZE
sDeck3Cards:: ; a2c0
	ds DECK_SIZE

sDeck4Name:: ; a2fc
	ds DECK_NAME_SIZE
sDeck4Cards:: ; a314
	ds DECK_SIZE

s0a350:: ; a350
	ds DECK_NAME_SIZE + DECK_SIZE
s0a3a4:: ; a3a4
	ds DECK_NAME_SIZE + DECK_SIZE
s0a3f8:: ; a3f8
	ds DECK_NAME_SIZE + DECK_SIZE

	ds $12b4

sCurrentlySelectedDeck:: ; b700
	ds $1

SECTION "SRAM1", SRAM

SECTION "SRAM2", SRAM

	ds $1c00

; saved data of the current duel, including a two-byte checksum
; see SaveDuelDataToDE
sCurrentDuel:: ; bc00
	ds $1
sCurrentDuelChecksum:: ; bc01
	ds $2
sCurrentDuelData:: ; bc04
	ds $33b

SECTION "SRAM3", SRAM
