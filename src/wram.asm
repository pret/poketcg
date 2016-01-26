INCLUDE "constants.asm"

;----------------------------------------------------------
;--- Bank 0: $Cxxx ----------------------------------------
;----------------------------------------------------------

SECTION "WRAM0", WRAM0
	ds $200
	
;--- Duels 1 ----------------------------------------------

wPlayerDuelVariables:: ; c200

; 60-byte array that indicates where each of the 60 cards is.
;	$00 - deck
;	$01 - hand
;	$02 - discard pile
;	$08 - prize
;	$10 - hand
;	$1X - bench (where X is bench position from 1 to 5)
wPlayerCardLocations:: ; c200
	ds DECK_SIZE
	ds $6

; Which cards are in player's hand, as numbers 0 to 59
wPlayerHand:: ; c242	
	ds DECK_SIZE

; 60-byte array that maps each card to its position in the deck.
; During a duel, each card of the deck is assigned a number between 0 and 59, following the index number order.
; This array is initialized to 00, 01, 02, ..., 59, until deck is shuffled.
; The earlier a card appears in the array, the closer to the top of the deck it is.
wPlayerDeckCards:: ; c27e
	ds DECK_SIZE

; stores x = (60 - deck remaining cards)
; the first x cards in the wPlayerDeckCards array are ignored (e.g. when drawing a card)
wPlayerNumberOfCardsNotInDeck:: ; c2ba
	ds $1

; Which card is in player's side of the field, as number 0 to 59
wPlayerArenaCard:: ; c2bb
	ds $1

; Which cards are in player's bench, as numbers 0 to 59
wPlayerBench:: ; c2bc	
	ds BENCH_SIZE
	ds $7
	
wPlayerArenaCardHP:: ; c2c8
	ds $1
wPlayerBench1CardHP:: ; c2c9
	ds $1
wPlayerBench2CardHP:: ; c2ca
	ds $1
wPlayerBench3CardHP:: ; c2cb
	ds $1
wPlayerBench4CardHP:: ; c2cc
	ds $1
wPlayerBench5CardHP:: ; c2cd
	ds $1
	ds $20
	
wPlayerNumberOfCardsInHand:: ; c2ee
	ds $1

; Pokemon cards in arena + bench
wPlayerNumberOfPokemonInPlay:: ; c2ef
	ds $1

wPlayerArenaCardStatus:: ; c2f0
	ds $1

; $00   - player
; $01   - link
; other - AI controlled
wPlayerDuelistType:: ; c2f1
	ds $1
	ds $e

wOpponentDuelVariables:: ; c300

wOpponentCardLocations:: ; c300
	ds DECK_SIZE
	ds $6
	
wOpponentHand:: ; c342
	ds DECK_SIZE
	
wOpponentDeckCards:: ; c37e
	ds DECK_SIZE
	
wOpponentNumberOfCardsNotInDeck:: ; c3ba	
	ds $1
	
wOpponentArenaCard:: ; c3bb
	ds $1

wOpponentBench:: ; c3bc	
	ds BENCH_SIZE
	ds $7
	
wOpponentArenaCardHP:: ; c3c8
	ds $1
wOpponentBench1CardHP:: ; c3c9
	ds $1
wOpponentBench2CardHP:: ; c3ca
	ds $1
wOpponentBench3CardHP:: ; c3cb
	ds $1
wOpponentBench4CardHP:: ; c3cc
	ds $1
wOpponentBench5CardHP:: ; c3cd
	ds $1
	ds $20
	
wOpponentNumberOfCardsInHand:: ; c3ee
	ds $1
		
wOpponentNumberOfPokemonInPlay:: ; c3ef
	ds $1

wOpponentArenaCardStatus:: ; c3f0
	ds $1

; $00   - player
; $01   - link
; other - AI controlled
wOpponentDuelistType:: ; c3f1
	ds $1
	ds $e
	
wPlayerDeck:: ; c400
	ds $80

wOpponentDeck:: ; c480
	ds $80
	ds $500
	
;--- Engine	-----------------------------------------------

wBufOAM:: ; ca00
	ds $a0
	ds $13

; initial value of the A register--used to tell the console when reset
wInitialA:: ; cab3
	ds $1

; what console we are playing on, either 0 (DMG), 1 (SGB) or 2 (CGB)
; use constants CONSOLE_DMG, CONSOLE_SGB and CONSOLE_CGB for checks
wConsole:: ; cab4
	ds $1
	ds $1

wTileMapFill:: ; cab6
	ds $1

wIE:: ; cab7
	ds $1

wVBlankCtr:: ; cab8
	ds $1
	ds $1

; bit0: is in vblank interrupt?
; bit1: is in timer interrupt?
wReentrancyFlag:: ; caba
	ds $1

wLCDC:: ; cabb
	ds $1

wBGP:: ; cabc
	ds $1

wOBP0:: ; cabd
	ds $1

wOBP1:: ; cabe
	ds $1

wFlushPaletteFlags:: ; cabf
	ds $1

wVBlankOAMCopyToggle:: ; cac0
	ds $1
	ds $2

wCounterCtr:: ; cac3
	ds $1

wPlayTimeCounterEnable:: ; cac4
	ds $1

; byte0: 1/60ths of a second
; byte1: seconds
; byte2: minutes
; byte3: hours (lower byte)
; byte4: hours (upper byte)
wPlayTimeCounter:: ; cac5
	ds $5
	
wRNG1:: ; caca
	ds $1

wRNG2:: ; cacb
	ds $1
	
wCounter:: ; cacc
	ds $1

; the LCDC status interrupt is always disabled and this always reads as jp $0000
wLCDCFunctiontrampoline:: ; cacd
	ds $3

wVBlankFunctionTrampoline:: ; cad0
	ds $3
	ds $1d

wBufPalette:: ; caf0 - cab7f
	ds $80
	ds $4

;--- Serial transfer bytes (cb74-cbc4) --------------------

wSerialOp:: ; cb74
	ds $1

wSerialFlags:: ; cb75
	ds $1

wSerialCounter:: ; cb76
	ds $1

wSerialCounter2:: ; cb77
	ds $1

wSerialTimeoutCounter:: ; cb78
	ds $1
	ds $4

wSerialSendSave:: ; cb7d
	ds $1

wSerialSendBufToggle:: ; cb7e
	ds $1

wSerialSendBufIndex:: ; cb7f
	ds $1
	ds $1

wSerialSendBuf:: ; cb81
	ds $20

wSerialLastReadCA:: ; cba1
	ds $1

wSerialRecvCounter:: ; cba2
	ds $1
	ds $1

wSerialRecvIndex:: ; cba4
	ds $1

wSerialRecvBuf:: ; $cba5 - $cbc4
	ds $20
	ds $49

;--- Duels 2 ----------------------------------------------

; this seems to hold the current opponent's deck id - 2,
; perhaps to account for the two unused pointers at the
; beginning of DeckPointers
wOpponentDeckId:: ; cc0e
	ds $1
	ds $4

wIsPracticeDuel:: ; cc13
	ds $1
	ds $6

wDuelTheme:: ; cc1a
	ds $1
	ds $9

; wCardBuffer1 and wCardBuffer2 hold the data of a player's or opponent's card.
; Can be data from a card on either side of the field or hand, or from a card in the bench, depending on the duel state.
; Sometimes the two buffers even hold the same card's data.
wCardBuffer1:: ; cc24
	ds CARD_DATA_LENGTH

wCardBuffer2:: ; cc65
	ds CARD_DATA_LENGTH
	
	ds $c
	
wCurrentMoveOrCardEffect:: ; ccb2
	ds $1
	ds $40

;--- Overworld --------------------------------------------	
	
; color/pattern of the text box border. Values between 0-7?. Interpreted differently depending on console type
; Note that this doesn't appear to be a selectable option, just changes with the situation.
; For example the value 4 seems to be used a lot during duels.
wFrameType:: ; ccf3
	ds $1
	ds $19

wUppercaseFlag:: ; cd0d
	ds $1
	ds $1

; Handles timing of (horizontal or vertical) arrow blinking while waiting for user input.
wCursorBlinkCounter:: ; cd0f
	ds $1
	
wCurMenuItem:: ; cd10
	ds $1

wCursorXPosition:: ; cd11
	ds $1

wCursorYPosition:: ; cd12
	ds $1
	
wYDisplacementBetweenMenuItems:: ; cd13
	ds $1
	
wNumMenuItems:: ; cd14
	ds $1
	
wCursorTileNumber:: ; cd15
	ds $1
	
wTileBehindCursor:: ; cd16
	ds $1
	ds $10b

; During a duel, this is always $b after the first attack.
; $b is the bank where the functions associated to card or effect commands are.
; Its only purpose seems to be store this value to be read by TryExecuteEffectCommandFunction.
wce22:: ; ce22

;----------------------------------------------------------
;--- Bank 1: $Dxxx ----------------------------------------
;----------------------------------------------------------

SECTION "WRAM1", WRAMX, BANK[1]
	ds $113
	
;--- Music ------------------------------------------------		

wMatchStartTheme:: ; d113
	ds $1
	ds $21b

wCurMap:: ; d32f
	ds $1

wPlayerXCoord:: ; d330
	ds $1

wPlayerYCoord:: ; d331
	ds $1
	ds $a52

wMusicDC:: ; dd84
	ds $2

wMusicDuty:: ; dd86
	ds $4

wMusicWave:: ; dd8a
	ds $1

wMusicWaveChange:: ; dd8b
	ds $2

wMusicIsPlaying:: ; dd8d
	ds $4

wMusicTie:: ; dd91
	ds $c

wMusicMainLoop:: ; dd9d
	ds $12

wMusicOctave:: ; ddaf
	ds $10

wMusicE8:: ; ddbf
	ds $8

wMusicE9:: ; ddc7
	ds $4

wMusicEC:: ; ddcb
	ds $4

wMusicSpeed:: ; ddcf
	ds $4

wMusicVibratoType:: ; ddd3
	ds $4

wMusicVibratoType2:: ; ddd7
	ds $8

wMusicVibratoDelay:: ; dddf
	ds $8

wMusicVolume:: ; dde7
	ds $3

wMusicE4:: ; ddea
	ds $9

wMusicReturnAddress:: ; ddf3
	ds $8
