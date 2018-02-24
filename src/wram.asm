INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "vram.asm"

SECTION "WRAM0", WRAM0

wTempCardCollection:: ; c000
	ds $100

	ds $100

SECTION "WRAM Duels 1", WRAM0

; In order to be identified during a duel, the 60 cards of each duelist are given an index between 0 and 59.
; These indexes are assigned following the order of the card list in wPlayerDeck or wOpponentDeck,
; which, in turn, follows the internal order of the cards.
; This temporary index of a card identifies the card within the duelist's deck during an ongoing duel.

; Terminology used in labels and comments:
; - The deck index, or the index within the deck of a card refers to the identifier mentioned just above,
;   that is, its temporary position in the wPlayerDeck or wOpponentDeck card list during the current duel.
; - The card ID is its actual internal identifier, that is, its number from card_constants.asm.

wPlayerDuelVariables:: ; c200

; 60-byte array that indicates where each of the 60 cards is.
;	$00 - deck
;	$01 - hand
;	$02 - discard pile
;	$08 - prize
;	$10 - arena (active pokemon or a card attached to it)
;	$1X - bench (where X is bench position from 1 to 5)
wPlayerCardLocations:: ; c200
	ds DECK_SIZE

	ds $6

; Which cards are in player's hand, as numbers 0 to 59
wPlayerHand:: ; c242
	ds DECK_SIZE

; 60-byte array that maps each card to its position in the deck or anywhere else
; This array is initialized to 00, 01, 02, ..., 59, until deck is shuffled.
; Cards in the discard pile go first, cards still in the deck go last, and others go in-between.
wPlayerDeckCards:: ; c27e
	ds DECK_SIZE

; Stores x = (60 - deck remaining cards).
; The first x cards in the wPlayerDeckCards array are no longer in the drawable deck this duel.
; The top card of the player's deck is at wPlayerDeckCards + [wPlayerNumberOfCardsNotInDeck].
wPlayerNumberOfCardsNotInDeck:: ; c2ba
	ds $1

; Which card is in player's side of the field, as number 0 to 59
; -1 indicates no pokemon
wPlayerArenaCard:: ; c2bb
	ds $1

; Which cards are in player's bench, as numbers 0 to 59, plus an $ff (-1) terminator
; -1 indicates no pokemon
wPlayerBench:: ; c2bc
	ds MAX_BENCH_POKEMON + 1

	ds $6

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

wPlayerArenaCardStage:: ; c2ce
	ds $1
wPlayerBench1CardStage:: ; c2cf
	ds $1
wPlayerBench2CardStage:: ; c2d0
	ds $1
wPlayerBench3CardStage:: ; c2d1
	ds $1
wPlayerBench4CardStage:: ; c2d2
	ds $1
wPlayerBench5CardStage:: ; c2d3
	ds $1

; changed type from Venomoth's Shift Pokemon Power
; if bit 7 == 1, then bits 0-3 override the Pokemon's actual type
wPlayerArenaCardChangedType:: ; c2d4
	ds $1
wPlayerBench1CardChangedType:: ; c2d5
	ds $1
wPlayerBench2CardChangedType:: ; c2d6
	ds $1
wPlayerBench3CardChangedType:: ; c2d7
	ds $1
wPlayerBench4CardChangedType:: ; c2d8
	ds $1
wPlayerBench5CardChangedType:: ; c2d9
	ds $1

	ds $d

wPlayerArenaCardSubstatus1:: ; c2e7
	ds $1

wPlayerArenaCardSubstatus2:: ; c2e8
	ds $1

; changed weakness from Conversion 1
wPlayerArenaCardChangedWeakness:: ; c2e9
	ds $1

; changed resistance from Conversion 2
wPlayerArenaCardChangedResistance:: ; c2ea
	ds $1

wPlayerArenaCardSubstatus3:: ; c2eb
	ds $1

; Each bit represents a prize (1 = not taken ; 0 = taken)
wPlayerPrizes:: ; c2ec
	ds $1

wPlayerNumberOfCardsInDiscardPile:: ; c2ed
	ds $1

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

; if under the effects of amnesia, which move (0 or 1) can't be used
wPlayerArenaCardDisabledMoveIndex:: ; c2f2
	ds $1

	ds $d

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
	ds MAX_BENCH_POKEMON + 1

	ds $6

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

wOpponentArenaCardStage:: ; c3ce
	ds $1
wOpponentBench1CardStage:: ; c3cf
	ds $1
wOpponentBench2CardStage:: ; c3d0
	ds $1
wOpponentBench3CardStage:: ; c3d1
	ds $1
wOpponentBench4CardStage:: ; c3d2
	ds $1
wOpponentBench5CardStage:: ; c3d3
	ds $1

wOpponentArenaCardChangedType:: ; c2d4
	ds $1
wOpponentBench1CardChangedType:: ; c2d5
	ds $1
wOpponentBench2CardChangedType:: ; c2d6
	ds $1
wOpponentBench3CardChangedType:: ; c2d7
	ds $1
wOpponentBench4CardChangedType:: ; c2d8
	ds $1
wOpponentBench5CardChangedType:: ; c2d9
	ds $1

	ds $d

wOpponentArenaCardSubstatus1:: ; c3e7
	ds $1

wOpponentArenaCardSubstatus2:: ; c3e8
	ds $1

wOpponentArenaCardChangedWeakness:: ; c3e9
	ds $1

wOpponentArenaCardChangedResistance:: ; c3ea
	ds $1

wOpponentArenaCardSubstatus3:: ; c3eb
	ds $1

wOpponentPrizes:: ; c3ec
	ds $1

wOpponentNumberOfCardsInDiscardPile:: ; c3ed
	ds $1

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

wOpponentArenaCardDisabledMoveIndex:: ; c3f2
	ds $1

	ds $d

UNION

wBoosterCardsDrawn:: ; c400
wBoosterTempNonEnergiesDrawn:: ; c400
	ds $b
wBoosterTempEnergiesDrawn:: ; c40b
	ds $b
wBoosterCardsDrawnEnd::
	ds $6a

NEXTU

wPlayerDeck:: ; c400
	ds $80

ENDU

wOpponentDeck:: ; c480
	ds $80

wc500:: ; c500
	ds $10

; this holds an $ff-terminated list of card deck indexes (e.g. cards in hand or in bench)
; or (less often) the attack list of a Pokemon card
wDuelTempList:: ; c510
	ds $80

; this is kept updated with some default text that is used
; when the text printing functions are called with text id $0000
wDefaultText:: ; c590
	ds $70

SECTION "WRAM Text Engine", WRAM0

wc600:: ; c600
	ds $100

wc700:: ; c700
	ds $100

wc800:: ; c800
	ds $100

wc900:: ; c900
	ds $100

SECTION "WRAM Engine 1", WRAM0

wBufOAM:: ; ca00
	ds $a0

wcaa0:: ; caa0
	ds $10

wcab0:: ; cab0
	ds $1

wcab1:: ; cab1
	ds $1

wcab2:: ; cab2
	ds $1

; initial value of the A register--used to tell the console when reset
wInitialA:: ; cab3
	ds $1

; what console we are playing on, either 0 (DMG), 1 (SGB) or 2 (CGB)
; use constants CONSOLE_DMG, CONSOLE_SGB and CONSOLE_CGB for checks
wConsole:: ; cab4
	ds $1

wcab5:: ; cab5
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

wcac1:: ; cac1
	ds $1

wcac2:: ; cac2
	ds $1

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

wDoFrameFunction:: ; cad3
	ds $1

wcad4:: ; cad4
	ds $1

wcad5:: ; cad5
	ds $1

	ds $8

wcade:: ; cade
	ds $4

wcae2:: ; cae2
	ds $e

; temporal CGB palette data buffer to eventually save into BGPD or OBPD registers.
wBackgroundPalettesCGB:: ; caf0
	ds 8 * CGB_PAL_SIZE

wObjectPalettesCGB:: ; cb30
	ds 8 * CGB_PAL_SIZE

	ds $4

SECTION "WRAM Serial Transfer", WRAM0

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

wcb80:: ; cb80
	ds $1

wSerialSendBuf:: ; cb81
	ds $20

wSerialLastReadCA:: ; cba1
	ds $1

wSerialRecvCounter:: ; cba2
	ds $1

wcba3:: ; cba3
	ds $1

wSerialRecvIndex:: ; cba4
	ds $1

wSerialRecvBuf:: ; cba5 - cbc4
	ds $20

	ds $1

SECTION "WRAM Duels 2", WRAM0

; In a duel, the main menu current or last selected menu item
; From 0 to 5: Hand, Attack, Check, Pkmn Power, Retreat, Done
wCurrentDuelMenuItem:: ; cbc6
	ds $1

; When we're viewing a card's information, the page we are currently at
; For Pokemon cards, values from $1 to $6 (two pages for move descriptions)
; For Energy cards, it's always $9
; For Trainer cards, $d or $e (two pages for trainer card descriptions)
wCardPageNumber:: ; cbc7
	ds $1

	ds $1

wcbc9:: ; cbc9
	ds $2

; selected bench slot (1-5, that is, a PLAY_AREA_BENCH_* constant)
wBenchSelectedPokemon:: ; cbcb
	ds $1

	ds $2

wAttachedEnergiesAccum:: ; cbce
	ds $1

; When you're in a duel submenu like the cards in your hand and you press A,
; the following two addresses keep track of which item was selected by the cursor
wSelectedDuelSubMenuItem:: ; cbcf
	ds $1

wSelectedDuelSubMenuScrollOffset:: ; cbd0
	ds $1

	ds $14

wcbe5:: ; cbe5
	ds $1

wcbe6:: ; cbe6
	ds $1

wcbe7:: ; cbe7
	ds $6

wcbed:: ; cbed
	ds $c

wcbf9:: ; cbf9
	ds $b

wcc04:: ; cc04
	ds $1

wcc05:: ; cc05
	ds $1

; number of turns taken by both players
wDuelTurns:: ; cc06
	ds $1

; 0 = no one has won duel yet
; 1 = player whose turn it is has won the duel
; 2 = player whose turn it is has lost the duel
; 3 = duel ended in a draw
wDuelFinished:: ; cc07
	ds $1

wcc08:: ; cc08
	ds $1

wcc09:: ; cc09
	ds $1

wcc0a:: ; cc0a
	ds $1

wAlreadyPlayedEnergy:: ; cc0b
	ds $1

wcc0c:: ; cc0c
	ds $1

; DUELIST_TYPE_* of the turn holder
wDuelistType:: ; cc0d
	ds $1

; this seems to hold the current opponent's deck id - 2,
; perhaps to account for the two unused pointers at the
; beginning of DeckPointers
wOpponentDeckID:: ; cc0e
	ds $1

	ds $1

wcc10:: ; cc10
	ds $1

wcc11:: ; cc11
	ds $1

wcc12:: ; cc12
	ds $1

wIsPracticeDuel:: ; cc13
	ds $1

	ds $1

wOpponentPortrait:: ; cc15
	ds $1

; text id of the opponent's name
wOpponentName:: ; cc16
	ds $2

wcc18:: ; cc18
	ds $1

wcc19:: ; cc19
	ds $1

wDuelTheme:: ; cc1a
	ds $1

; holds the energies attached to a given pokemon card. 1 byte for each of the
; 8 energy types (including the unused one that shares byte with the colorless energy)
wAttachedEnergies:: ; cc1b
	ds NUM_TYPES

; holds the total amount of energies attached to a given pokemon card
wTotalAttachedEnergies:: ; cc23
	ds $1

; Used as temporary storage for a loaded card's data
wLoadedCard1:: ; cc24
	card_data_struct wLoadedCard1

wLoadedCard2:: ; cc65
	card_data_struct wLoadedCard2

wLoadedMove:: ; cca6
	move_data_struct wLoadedMove

; big-endian
wDamage:: ; ccb9
	ds $2

; wccbb and wccbc appear to be used for AI scoring
wccbb::
	ds $1

wccbc::
	ds $1

	ds $2

wccbf:: ; ccbf
	ds $2

wDamageEffectiveness:: ; ccc1
	ds $1

; used in damage related functions
wTempCardID_ccc2:: ; ccc2
	ds $1

wTempTurnDuelistCardID:: ; ccc3
	ds $1

wTempNonTurnDuelistCardID:: ; ccc4
	ds $1

	ds $1

; may contain 0 or 1 depending on which move was selected
wSelectedMoveIndex:: ; ccc6
	ds $1

; if affected by a no damage or effect substatus, this flag indicates what the cause was
wNoDamageOrEffect:: ; ccc7
	ds $2

wccc9:: ; ccc9
	ds $4

wcccd:: ; cccd
	ds $1

wccce:: ; ccce
	ds $18

wcce6:: ; cce6
	ds $5

wcceb:: ; cceb
	ds $1

wccec:: ; ccec
	ds $1

wcced:: ; cced
	ds $2

wccef:: ; ccef
	ds $1

wccf0:: ; ccf0
	ds $1

wccf1:: ; ccf1
	ds $1

wccf2:: ; ccf2
	ds $1

SECTION "WRAM Engine 2", WRAM0

; color/pattern of the text box border. Values between 0-7?. Interpreted differently depending on console type
; Note that this doesn't appear to be a selectable option, just changes with the situation.
; For example the value 4 seems to be used a lot during duels.
wFrameType:: ; ccf3
	ds $1

	ds $10

wcd04:: ; cd04
	ds $1

wcd05:: ; cd05
	ds $1

wcd06:: ; cd06
	ds $1

wcd07:: ; cd07
	ds $1

wcd08:: ; cd08
	ds $1

wcd09:: ; cd09
	ds $1

wcd0a:: ; cd0a
	ds $1

wcd0b:: ; cd0b
	ds $2

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

wcd17:: ; cd17
	ds $2

	ds $7f

wLeftmostItemCursorX:: ; cd98
	ds $1

wRefreshMenuCursorSFX:: ; cd99
	ds $1

wcd9a:: ; cd9a
	ds $2

wcd9c:: ; cd9c
	ds $1

wcd9d:: ; cd9d
	ds $1

wcd9e:: ; cd9e
	ds $1

wcd9f:: ; cd9f
	ds $83

; During a duel, this is always $b after the first attack.
; $b is the bank where the functions associated to card or effect commands are.
; Its only purpose seems to be store this value to be read by TryExecuteEffectCommandFunction.
wce22:: ; ce22
	ds $1

	ds $8

wce2b:: ; ce2b
	ds $1

	ds $13

; text pointer for the first TX_RAM2 of a text
; prints from wDefaultText if $0000
wTxRam2:: ; cd3f
	ds $2

; text pointer for the second TX_RAM2 on a text
wTxRam2_b:: ; ce41
	ds $2

; a number between 0 and 65535 for TX_RAM3
wTxRam3:: ; ce43
	ds $2

	ds $2

; when printing text, number of frames to wait between each text tile
wTextSpeed:: ; ce47
	ds $1

wce48:: ; ce48
	ds $1

wce49:: ; ce49
	ds $1

wce4a:: ; ce4a
	ds $1

wce4b:: ; ce4b
	ds $3

wCoinTossScreenTextID:: ; ce4e
	ds $2

wce50:: ; ce50
	ds $1

wce51:: ; ce51
	ds $8

wce59:: ; ce59
	ds $7

wce60:: ; ce60
	ds $3

wce63:: ; ce63
	ds $9

wce6c:: ; ce6c
	ds $1

wce6d:: ; ce6d
	ds $1

wce6e:: ; ce6e
	ds $1

wce6f:: ; ce6f
	ds $d

; used in CountPokemonIDInPlayArea
wTempPokemonID_ce7e:: ; ce7c
	ds $1

	ds $26

wcea3:: ; cea3
	ds $c

wceaf:: ; ceaf
	ds $1

wceb0:: ; ceb0
	ds $1

wceb1:: ; ceb1
	ds $1

wceb2:: ; ceb2
	ds $1

wceb3:: ; ceb3
	ds $1

wceb4:: ; ceb4
	ds $1

wceb5:: ; ceb5
	ds $17

wcecc:: ; cecc
	ds $9c

wHandCardBuffer:: ; cf68
	ds $51

wcfb9:: ; cfb9
	ds $2a

wcfe3:: ; cfe3

SECTION "WRAM1", WRAMX
	ds $a9

wd0a9:: ; d0a9
	ds $b

wd0b4:: ; d0b4
	ds $1

wd0b5:: ; d0b5
	ds $1

wSCX:: ; d0b6
	ds $1

wSCY:: ; d0b7
	ds $1

wd0b8:: ; d0b8
	ds $1

wd0b9:: ; d0b9
	ds $1

wd0ba:: ; d0ba
	ds $1

wd0bb:: ; d0bb
	ds $1

wd0bc:: ; d0bc
	ds $1

wd0bd:: ; d0bd
	ds $1

wd0be:: ; d0be
	ds $1

wd0bf:: ; d0bf
	ds $1

wd0c0:: ; d0c0
	ds $1

wd0c1:: ; d0c1
	ds $1

wd0c2:: ; d0c2
	ds $1

wd0c3:: ; d0c3
	ds $1

wd0c4:: ; d0c4
	ds $1

wd0c5:: ; d0c5
	ds $1

wd0c6:: ; d0c6
	ds $1

wd0c7:: ; d0c7
	ds $1

wd0c8:: ; d0c8
	ds $1

wd0c9:: ; d0c9
	ds $1

wd0ca:: ; d0ca
	ds $1

wd0cb:: ; d0cb
	ds $41

wd10c:: ; d10c
	ds $1

wd10d:: ; d10d
	ds $1

wd10e:: ; d10e
	ds $1

wd10f:: ; d10f
	ds $1

wd110:: ; d110
	ds $1

wd111:: ; d111
	ds $1

wd112:: ; d112
	ds $1

wMatchStartTheme:: ; d113
	ds $1

wd114:: ; d114
	ds $1

wd115:: ; d115
	ds $1

wd116:: ; d116
	ds $1

wd117:: ; d117
	ds $4

wd11b:: ; d11b
	ds $2

wPCPackSelection:: ; d11d
	ds $1

; 7th bit of each pack corresponds to whether or not it's been read
wPCPacks:: ; d11e
	ds $c

	ds $3

wPCLastDirectionPressed:: ; d12d
	ds $1

	ds $3

wd131:: ; d131
	ds $1

wd132:: ; d132
	ds $1

UNION

wBoosterViableCardList:: ; d133
	ds $100

NEXTU

; map of the current room with unpassable objects (walls, NPCs, etc). Might be a permission map
wFloorObjectMap::
	ds $100

ENDU

wd233:: ; d233
	ds $1

wd234:: ; d234
	ds $1

wSCXBuffer:: ; d235
	ds $1

wSCYBuffer:: ; d236
	ds $1

wd237:: ; d237
	ds $1

wd238:: ; d238
	ds $57

wd28f:: ; d28f
	ds $1

wd290:: ; d290
	ds $1

wd291:: ; d291
	ds $92

wd323:: ; d323
	ds $1

wd324:: ; d324
	ds $a

wd32e:: ; d32e
	ds $1

wCurMap:: ; d32f
	ds $1

wPlayerXCoord:: ; d330
	ds $1

wPlayerYCoord:: ; d331
	ds $1

wd332:: ; d332
	ds $1

wd333:: ; d333
	ds $1

wd334:: ; d334
	ds $1

wd335:: ; d335
	ds $1

wd336:: ; d336
	ds $1

wd337:: ; d337
	ds $1

wd338:: ; d338
	ds $3

wd33b:: ; d33b
	ds $1

wd33c:: ; d33c
	ds $1

wd33d:: ; d33d
	ds $1

wd33e:: ; d33e
	ds $1

wd33f:: ; d33f
	ds $1

wd340:: ; d340
	ds $1

wd341:: ; d341
	ds $2

wd343:: ; d343
	ds $1

wd344:: ; d344
	ds $1

wd345:: ; d345
	ds $1

wd346:: ; d346
	ds $1

wd347:: ; d347
	ds $1

wd348:: ; d348
	ds $62

wd3aa:: ; d3aa
	ds $1

wd3ab:: ; d3ab
	ds $4

wd3af:: ; d3af
	ds $1

wd3b0:: ; d3b0
	ds $1

wd3b1:: ; d3b1
	ds $1

wd3b2:: ; d3b2
	ds $4

wd3b6:: ; d3b6
	ds $2

wd3b8:: ; d3b8
	ds $18

wd3d0:: ; d3d0
	ds $1

wd3d1:: ; d3d1
	ds $1

wEventFlags::
	ds $3f

wd411:: ; d411
	ds $1

; 0 keeps looping, other values break the loop in RST20
wBreakOWScriptLoop:: ; d412
	ds $1

wOWScriptPointer:: ; d413
	ds $2

	ds $8

wd41d:: ; d41d
	ds $1

wd41e:: ; d41e
	ds $1

wd41f:: ; d41f
	ds $1

wd420:: ; d420
	ds $1

wd421:: ; d421
	ds $1

wd422:: ; d422
	ds $8

wd42a:: ; d42a
	ds $82

wd4ac:: ; d4ac
	ds $12

wd4be:: ; d4be
	ds $4

wd4c2:: ; d4c2
	ds $1

wd4c3:: ; d4c3
	ds $1

wd4c4:: ; d4c4
	ds $1

wd4c5:: ; d4c5
	ds $1

wd4c6:: ; d4c6
	ds $1

wd4c7:: ; d4c7
	ds $1

wd4c8:: ; d4c8
	ds $2

wd4ca:: ; d4ca
	ds $1

wd4cb:: ; d4cb
	ds $4


; used as an index to manipulate a sprite from wSpriteAnimBuffer
wWhichSprite:: ; d4cf
	ds $1

; 16-byte data for up to 16 sprites
wSpriteAnimBuffer:: ; d4d0
	sprite_anim_struct wSprite1
	sprite_anim_struct wSprite2
	sprite_anim_struct wSprite3
	sprite_anim_struct wSprite4
	sprite_anim_struct wSprite5
	sprite_anim_struct wSprite6
	sprite_anim_struct wSprite7
	sprite_anim_struct wSprite8
	sprite_anim_struct wSprite9
	sprite_anim_struct wSprite10
	sprite_anim_struct wSprite11
	sprite_anim_struct wSprite12
	sprite_anim_struct wSprite13
	sprite_anim_struct wSprite14
	sprite_anim_struct wSprite15
	sprite_anim_struct wSprite16

	ds $3

wd5d3:: ; d5d3
	ds $4

wd5d7:: ; d5d7
	ds $41

wd618:: ; d618
	ds $3

wd61b:: ; d61b
	ds $3

wd61e:: ; d61e
	ds $6

wd624:: ; d624
	ds $2

wd626:: ; d626
	ds $1

wd627:: ; d627
	ds $1

wd628:: ; d628
	ds $b

wd633:: ; d633
	ds $2

wd635:: ; d635
	ds $34

wBoosterIndex:: ; d669
	ds $1

wBoosterTempCard:: ; d66a
	ds $1

wBoosterSelectedCardType:: ; d66b
	ds $1

wBoosterCurRarity:: ; d66c
	ds $1

wBoosterAveragedTypeChances:: ; d66d
	ds $1

wBoosterDataCommonAmount:: ; d66e
	ds $1

wBoosterDataUncommonAmount:: ; d66f
	ds $1

wBoosterDataRareAmount:: ; d670
	ds $1

wBoosterAmountOfCardTypeTable:: ; d671
	ds NUM_BOOSTER_CARD_TYPES

wBoosterTempTypeChanceTable:: ; d67a
	ds NUM_BOOSTER_CARD_TYPES

wBoosterCurrentCardType:: ; d683
	ds $1

wBoosterCurrentCardRarity:: ; d684
	ds $1

wBoosterCurrentCardSet:: ; d685
	ds $1

wBoosterDataSet:: ; d686
	ds $1

wBoosterDataEnergyFunctionPointer:: ; d687
	ds $2

wBoosterDataTypeChances:: ; d689
	ds NUM_BOOSTER_CARD_TYPES

	ds $6ee

SECTION "WRAM Music", WRAMX

; bit 7 is set once the song has been started
wCurSongID:: ; dd80
	ds $1

wCurSongBank:: ; dd81
	ds $1

; bit 7 is set once the sfx has been started
wCurSfxID:: ; dd82
	ds $1

wdd83:: ; dd83
	ds $1

wMusicDC:: ; dd84
	ds $1

wdd85:: ; dd85
	ds $1

wMusicDuty1:: ; dd86
	ds $1

wMusicDuty2:: ; dd87
	ds $3

wMusicWave:: ; dd8a
	ds $1

wMusicWaveChange:: ; dd8b
	ds $1

wdd8c:: ; dd8c
	ds $1

wMusicIsPlaying:: ; dd8d
	ds $4

wMusicTie:: ; dd91
	ds $4

; 4 pointers to the current music commands being executed
wMusicChannelPointers:: ; dd95
	ds $8

; 4 pointers to the addresses of the beginning of the main loop for each channel
wMusicMainLoopStart:: ; dd9d
	ds $8

wMusicCh1CurPitch:: ; dda5
	ds $1

wMusicCh1CurOctave:: ; dda6
	ds $1

wMusicCh2CurPitch:: ; dda7
	ds $1

wMusicCh2CurOctave:: ; dda8
	ds $1

wMusicCh3CurPitch:: ; dda9
	ds $1

wMusicCh3CurOctave:: ; ddaa
	ds $1

wddab:: ; ddab
	ds $1

wddac:: ; ddac
	ds $3

wMusicOctave:: ; ddaf
	ds $4

wddb3:: ; ddb3
	ds $4

wddb7:: ; ddb7
	ds $1

wddb8:: ; ddb8
	ds $1

wddb9:: ; ddb9
	ds $1

wddba:: ; ddba
	ds $1

wddbb:: ; ddbb
	ds $4

wMusicE8:: ; ddbf
	ds $4

wddc3:: ; ddc3
	ds $4

wMusicE9:: ; ddc7
	ds $4

wMusicEC:: ; ddcb
	ds $4

wMusicSpeed:: ; ddcf
	ds $4

wMusicVibratoType:: ; ddd3
	ds $4

wMusicVibratoType2:: ; ddd7
	ds $4

wdddb:: ; dddb
	ds $4

wMusicVibratoDelay:: ; dddf
	ds $4

wdde3:: ; dde3
	ds $4

wMusicVolume:: ; dde7
	ds $3

wMusicE4:: ; ddea
	ds $3

wdded:: ; dded
	ds $2

wddef:: ; ddef
	ds $1

wddf0:: ; ddf0
	ds $1

wMusicPanning:: ; ddf1
	ds $1

wddf2:: ; ddf2
	ds $1

; 4 pointers to the positions on the stack for each channel
wMusicChannelStackPointers:: ; ddf3
	ds $8

; these stacks contain the address of the command to return to at the end of a sub branch (2 bytes)
; and also contain the address of the command to return to at the end of a loop (2 bytes for address and
; 1 byte for loop count)
wMusicCh1Stack:: ; ddfb
	ds $c

wMusicCh2Stack:: ; de07
	ds $c

wMusicCh3Stack:: ; de13
	ds $c

wMusicCh4Stack:: ; de1f
	ds $c

SECTION "WRAM Sfx", WRAMX

wde2b:: ; de2b
	ds $3

wde2e:: ; de2e
	ds $1

wde2f:: ; de2f
	ds $3

wde32:: ; de32
	ds $1

wde33:: ; de33
	ds $4

wde37:: ; de37
	ds $6

wde3d:: ; de3d
	ds $2

wde3f:: ; de3f
	ds $4

wde43:: ; de43
	ds $8

wde4b:: ; de4b
	ds $8

wde53:: ; de53
	ds $1

wde54:: ; de54
	ds $1

wCurSongIDBackup:: ; de55
	ds $1

wCurSongBankBackup:: ; de56
	ds $1

wMusicDCBackup:: ; de57
	ds $1

wMusicDuty1Backup:: ; de58
	ds $4

wMusicWaveBackup:: ; de5c
	ds $1

wMusicWaveChangeBackup:: ; de5d
	ds $1

wMusicIsPlayingBackup:: ; de5e
	ds $4

wMusicTieBackup:: ; de62
	ds $4

wMusicChannelPointersBackup:: ; de66
	ds $8

wMusicMainLoopStartBackup:: ; de6e
	ds $8

wde76:: ; de76
	ds $1

wde77:: ; de77
	ds $1

wMusicOctaveBackup:: ; de78
	ds $4

wde7c:: ; de7c
	ds $4

wde80:: ; de80
	ds $4

wde84:: ; de84
	ds $4

wMusicE8Backup:: ; de88
	ds $4

wde8c:: ; de8c
	ds $4

wMusicE9Backup:: ; de90
	ds $4

wMusicECBackup:: ; de94
	ds $4

wMusicSpeedBackup:: ; de98
	ds $4

wMusicVibratoType2Backup:: ; de9c
	ds $4

wMusicVibratoDelayBackup:: ; dea0
	ds $4

wMusicVolumeBackup:: ; dea4
	ds $3

wMusicE4Backup:: ; dea7
	ds $3

wdeaa:: ; deaa
	ds $2

wdeac:: ; deac
	ds $1

wMusicChannelStackPointersBackup:: ; dead
	ds $8

wMusicCh1StackBackup:: ; deb5
	ds $c * 4

INCLUDE "sram.asm"
