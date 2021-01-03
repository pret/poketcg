INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "vram.asm"

SECTION "WRAM0", WRAM0

UNION

wTempCardCollection:: ; c000
	ds $100

NEXTU

wc000:: ; c000
	ds $100

ENDU

	ds $100

SECTION "WRAM0 Duels 1", WRAM0

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

; deck indexes of the up to 6 cards placed as prizes
wPlayerPrizeCards:: ; c23c
	ds $6

; Deck indexes of the cards that are in the player's hand
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

; Deck index of the card that is in player's side of the field
; -1 indicates no pokemon
wPlayerArenaCard:: ; c2bb
	ds $1

; Deck indexes of the cards that are in player's bench, plus an $ff (-1) terminator
; -1 indicates no pokemon
wPlayerBench:: ; c2bc
	ds MAX_BENCH_POKEMON + 1

wPlayerArenaCardFlags:: ; c2c2
	ds $1

	ds $5

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
; if bit 7 == 1, then bits 0-3 override the Pokemon's actual color
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

wPlayerArenaCardAttachedDefender:: ; c2da
	ds $1
wPlayerBench1CardAttachedDefender:: ; c2db
	ds $1
wPlayerBench2CardAttachedDefender:: ; c2dc
	ds $1
wPlayerBench3CardAttachedDefender:: ; c2dd
	ds $1
wPlayerBench4CardAttachedDefender:: ; c2de
	ds $1
wPlayerBench5CardAttachedDefender:: ; c2df
	ds $1

wPlayerArenaCardAttachedPluspower:: ; c2e0
	ds $1
wPlayerBench1CardAttachedPluspower:: ; c2e1
	ds $1
wPlayerBench2CardAttachedPluspower:: ; c2e2
	ds $1
wPlayerBench3CardAttachedPluspower:: ; c2e3
	ds $1
wPlayerBench4CardAttachedPluspower:: ; c2e4
	ds $1
wPlayerBench5CardAttachedPluspower:: ; c2e5
	ds $1

	ds $1

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

; each bit represents a prize that this duelist can draw (1 = not drawn ; 0 = drawn)
wPlayerPrizes:: ; c2ec
	ds $1

wPlayerNumberOfCardsInDiscardPile:: ; c2ed
	ds $1

wPlayerNumberOfCardsInHand:: ; c2ee
	ds $1

; Pokemon cards in arena + bench
wPlayerNumberOfPokemonInPlayArea:: ; c2ef
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

; damage taken the last time the opponent attacked (0 if no damage)
wPlayerArenaCardLastTurnDamage:: ; c2f3
	ds $2

; status condition received the last time the opponent attacked (0 if none)
wPlayerArenaCardLastTurnStatus:: ; c2f5
	ds $1

; substatus2 that the opponent card got last turn
wPlayerArenaCardLastTurnSubstatus2:: ; c2f6
	ds $1

; indicates color of weakness that was changed
; for this card last turn
wPlayerArenaCardLastTurnChangeWeak:: ; c2f7
	ds $1

; stores an effect that was used on the Arena card last turn.
; see LAST_TURN_EFFECT_* constants.
wPlayerArenaCardLastTurnEffect:: ; c2f8
	ds $1

	ds $7

wOpponentDuelVariables:: ; c300

wOpponentCardLocations:: ; c300
	ds DECK_SIZE

wOpponentPrizeCards:: ; c33c
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

wOpponentArenaCardFlags:: ; c3c2
	ds $1

	ds $5

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

wOpponentArenaCardChangedType:: ; c3d4
	ds $1
wOpponentBench1CardChangedType:: ; c3d5
	ds $1
wOpponentBench2CardChangedType:: ; c3d6
	ds $1
wOpponentBench3CardChangedType:: ; c3d7
	ds $1
wOpponentBench4CardChangedType:: ; c3d8
	ds $1
wOpponentBench5CardChangedType:: ; c3d9
	ds $1

wOpponentArenaCardAttachedDefender:: ; c3da
	ds $1
wOpponentBench1CardAttachedDefender:: ; c3db
	ds $1
wOpponentBench2CardAttachedDefender:: ; c3dc
	ds $1
wOpponentBench3CardAttachedDefender:: ; c3dd
	ds $1
wOpponentBench4CardAttachedDefender:: ; c3de
	ds $1
wOpponentBench5CardAttachedDefender:: ; c3df
	ds $1

wOpponentArenaCardAttachedPluspower:: ; c3e0
	ds $1
wOpponentBench1CardAttachedPluspower:: ; c3e1
	ds $1
wOpponentBench2CardAttachedPluspower:: ; c3e2
	ds $1
wOpponentBench3CardAttachedPluspower:: ; c3e3
	ds $1
wOpponentBench4CardAttachedPluspower:: ; c3e4
	ds $1
wOpponentBench5CardAttachedPluspower:: ; c3e5
	ds $1

	ds $1

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

wOpponentNumberOfPokemonInPlayArea:: ; c3ef
	ds $1

wOpponentArenaCardStatus:: ; c3f0
	ds $1

; $00   - player
; $01   - link
; other - AI controlled
; this is equal to wDuelType
wOpponentDuelistType:: ; c3f1
	ds $1

wOpponentArenaCardDisabledMoveIndex:: ; c3f2
	ds $1

wOpponentArenaCardLastTurnDamage:: ; c3f3
	ds $2

wOpponentArenaCardLastTurnStatus:: ; c3f5
	ds $1

; substatus2 that the player card got last turn
wOpponentArenaCardLastTurnSubstatus2:: ; c3f6
	ds $1

; indicates color of weakness that was changed
; for this card last turn
wOpponentArenaCardLastTurnChangeWeak:: ; c3f7
	ds $1

; whether any attached energy card was discarded last turn (0 if not)
wOpponentArenaCardLastTurnEffect:: ; c3f8
	ds $1

	ds $7

UNION

; temporary list of the cards drawn from a booster pack
wBoosterCardsDrawn:: ; c400
wBoosterTempNonEnergiesDrawn:: ; c400
	ds $b
wBoosterTempEnergiesDrawn:: ; c40b
	ds $b
wBoosterCardsDrawnEnd:: ; c416
	ds $6a

NEXTU

wPlayerDeck:: ; c400
	ds $80

ENDU

wOpponentDeck:: ; c480
	ds $80

; this holds names like player's or opponent's.
wNameBuffer:: ; c500
	ds NAME_BUFFER_LENGTH

; this holds an $ff-terminated list of card deck indexes (e.g. cards in hand or in bench)
; or (less often) the attack list of a Pokemon card
wDuelTempList:: ; c510
	ds $80

; this is kept updated with some default text that is used
; when the text printing functions are called with text id $0000
wDefaultText:: ; c590
	ds $70

SECTION "WRAM0 Text Engine", WRAM0

wc600:: ; c600
	ds $100

wc700:: ; c700
	ds $100

wc800:: ; c800
	ds $100

wc900:: ; c900
	ds $100

SECTION "WRAM0 1", WRAM0

wOAM:: ; ca00
	ds $a0

; 16-byte buffer to store text, usually a name or a number
; used by TX_RAM1 but not exclusively
wStringBuffer:: ; caa0
	ds $10

wcab0:: ; cab0
	ds $1

wcab1:: ; cab1
	ds $1

wcab2:: ; cab2
	ds $1

; initial value of the A register. used to tell the console when reset
wInitialA:: ; cab3
	ds $1

; what console we are playing on, either 0 (DMG), 1 (SGB) or 2 (CGB)
; use constants CONSOLE_DMG, CONSOLE_SGB and CONSOLE_CGB for checks
wConsole:: ; cab4
	ds $1

; used to select a sprite or a starting sprite from wOAM
wOAMOffset:: ; cab5
	ds $1

; FillTileMap fills VRAM0 BG Maps with the tile stored here
wTileMapFill:: ; cab6
	ds $1

wIE:: ; cab7
	ds $1

; incremented whenever the vblank handler ends. used to wait for it to end,
; or to delay a specific amount of frames
wVBlankCounter:: ; cab8
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

; used to request palette(s) to be flushed by FlushPalettes from wBGP, wOBP0, wOBP1,
; wBackgroundPalettesCGB, and/or wBackgroundPalettesCGB to the corresponding hw registers
wFlushPaletteFlags:: ; cabf
	ds $1

; set to non-0 to request OAM copy during vblank
wVBlankOAMCopyToggle:: ; cac0
	ds $1

; used by HblankWriteByteToBGMap0
wTempByte:: ; cac1
	ds $1

; which screen or interface is currently displayed in the screen during a duel
; used to prevent loading graphics or drawing stuff more times than necessary
wDuelDisplayedScreen:: ; cac2
	ds $1

; used to increase the play time counter every four timer interrupts (60.24 Hz)
wTimerCounter:: ; cac3
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

wRNGCounter:: ; cacc
	ds $1

; the LCDC status interrupt is always disabled and this always reads as jp $0000
wLCDCFunctionTrampoline:: ; cacd
	ds $3

; a jp $nnnn instruction called by the vblank handler. calls a single ret by default
wVBlankFunctionTrampoline:: ; cad0
	ds $3

; pointer to a function to be called by DoFrame
wDoFrameFunction:: ; cad3
	ds $2

wcad5:: ; cad5
	ds $1

wcad6:: ; cad6
	ds $2

wcad8:: ; cad8
	ds $1

wcad9:: ; cad9
	ds $1

wcada:: ; cada
	ds $1

wcadb:: ; cadb
	ds $1

wcadc:: ; cadc
	ds $1

wcadd:: ; cadd
	ds $1

wcade:: ; cade
	ds $1

	ds $1

wTempSGBPacket:: ; cae0
	ds $10

; temporary CGB palette data buffer to eventually save into BGPD registers.
wBackgroundPalettesCGB:: ; caf0
	ds 8 palettes

; temporary CGB palette data buffer to eventually save into OBPD registers.
wObjectPalettesCGB:: ; cb30
	ds 8 palettes

	ds $2

; stores a pointer to a temporary list of elements (e.g. pointer to wDuelTempList)
; to be read or written sequentially
wListPointer:: ; cb72
	ds $2

SECTION "WRAM0 Serial Transfer", WRAM0

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

wcb79:: ; cb79
	ds $1

wcb7a:: ; cb7a
	ds $1

wcb7b:: ; cb7b
	ds $2

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

wSerialRecvBuf:: ; cba5
	ds $20

wSerialEnd:: ; cbc5

SECTION "WRAM0 Duels 2", WRAM0

	ds $1

; In a duel, the main menu current or last selected menu item
; From 0 to 5: Hand, Attack, Check, Pkmn Power, Retreat, Done
wCurrentDuelMenuItem:: ; cbc6
	ds $1

; When we're viewing a card's information, the page we are currently at.
; For Pokemon cards, values from $1 to $6 (two pages for move descriptions)
; For Energy cards, it's always $9
; For Trainer cards, $d or $e (two pages for trainer card descriptions)
; see CARDPAGE_* constants
wCardPageNumber:: ; cbc7
	ds $1

; how many selectable items are in a play area screen. used to set wNumMenuItems
; in order to navigate through a play area screen. this becomes the number of bench
; Pokemon cards if wExcludeArenaPokemon is 1, and that number plus 1 if it's 0.
wNumPlayAreaItems:: ; cbc8
	ds $1

; selects a PLAY_AREA_* slot in order to display information related to it. used by functions
; such as PrintPlayAreaCardLocation, PrintPlayAreaCardInformation and PrintPlayAreaCardHeader
wCurPlayAreaSlot:: ; cbc9

; X position to display the attached energies, HP bar, and Pluspower/Defender icons
; obviously different for player and opponent side. used by DrawDuelHUD.
wHUDEnergyAndHPBarsX:: ; cbc9
	ds $1

; current Y coordinate where some play area information is being printed at. used by functions
; such as PrintPlayAreaCardLocation, PrintPlayAreaCardInformation and PrintPlayAreaCardHeader
wCurPlayAreaY:: ; cbca

; Y position to display the attached energies, HP bar, and Pluspower/Defender icons
; obviously different for player and opponent side. used by DrawDuelHUD.
wHUDEnergyAndHPBarsY:: ; cbca

wcbca:: ; cbca
	ds $1

; selected bench slot (1-5, that is, a PLAY_AREA_BENCH_* constant)
wBenchSelectedPokemon:: ; cbcb
	ds $1

; used by CheckIfEnoughEnergiesToRetreat and DisplayRetreatScreen
wEnergyCardsRequiredToRetreat:: ; cbcc
	ds $1

wcbcd:: ; cbcd
	ds $1

; used in CheckIfEnoughEnergiesToMove for the calculation
wAttachedEnergiesAccum:: ; cbce
	ds $1

; when you're in a duel submenu like the cards in your hand and you press A,
; the following two addresses keep track of which item was selected by the cursor
wSelectedDuelSubMenuItem:: ; cbcf
	ds $1

wSelectedDuelSubMenuScrollOffset:: ; cbd0
	ds $1

; CARDPAGETYPE_PLAY_AREA or CARDPAGETYPE_NOT_PLAY_AREA
; some of the elements displayed in a card page change depending on which value
wCardPageType:: ; cbd1
	ds $1

; when processing or displaying the play area Pokemon cards of a duelist,
; whether to account for only the benched Pokemon ($01) or also the arena Pokemon ($00).
wExcludeArenaPokemon:: ; cbd2
	ds $1

wcbd3:: ; cbd3
	ds $1

wcbd4:: ; cbd4
	ds $1

wcbd5:: ; cbd5
	ds $1

; in a card list, which keys (among START and A_BUTTON) do not open the item selection
; menu when a card is selected, directly "submitting" the selected card instead.
wNoItemSelectionMenuKeys:: ; cbd6
	ds $1

; when viewing a card page, which keys (among B_BUTTON, D_UP, and D_DOWN) will exit the page,
; either to go back to the previous menu or list, or to load the card page of the card above/below it
wCardPageExitKeys:: ; cbd7
	ds $1

; used to store function pointer for printing card order
; in card list reordering screen.
wcbd8:: ; cbd8
	ds $2

; in the hand or discard pile card screen, id of the text printed in the bottom-left box
wCardListInfoBoxText:: ; cbda
	ds $2

; in the hand or discard pile card screen, id of the text printed as the header title
wCardListHeaderText:: ; cbdc
	ds $2

; when selecting an item of a list of cards which type of menu shows up.
; PLAY_CHECK, SELECT_CHECK, or $00 for none.
wCardListItemSelectionMenuType:: ; cbde
	ds $1

; flag indicating whether a list of cards should be sorted by ID
wSortCardListByID:: ; cbdf
	ds $1

wcbe0:: ; cbe0
	ds $1

wOpponentTurnEnded:: ; cbe1
	ds $1

wOppRNG1:: ; cbe2
	ds $1

wOppRNG2:: ; cbe3
	ds $1

wOppRNGCounter:: ; cbe4
	ds $1

; sp is saved here when starting a duel, in order to save the return address
; however, it only seems to be read after a transmission error in a link duel
wDuelReturnAddress:: ; cbe5
	ds $2

wcbe7:: ; cbe7
	ds $1

wNumCardsTryingToDraw:: ; cbe8
	ds $1

; number of cards being drawn in order to animate the number of cards in
; the hand and in the deck in the draw card screen
wNumCardsBeingDrawn:: ; cbe9
	ds $1

	ds $3

; temporarily stores 8 bytes for serial send/recv.
; used by SerialSend8Bytes and SerialRecv8Bytes
wTempSerialBuf:: ; cbed
	ds $8

	ds $2

wcbf7:: ; cbf7
	ds $2

; when non-0, AIMakeDecision doesn't wait 60 frames and print DuelistIsThinkingText
wSkipDuelistIsThinkingDelay:: ; cbf9
	ds $1

wcbfa:: ; cbfa
	ds $1

wcbfb:: ; cbfb
	ds $1

; used by Func_5805 to store the remaining Prizes, so that if more than that
; amount would be taken, only the remaining amount is taken
wcbfc:: ; cbfc
	ds $1

wcbfd:: ; cbfd
	ds $1

; during a practice duel, identifies an entry of PracticeDuelActionTable
wPracticeDuelAction:: ; cbfe
	ds $1

wcbff:: ; cbff
	ds $1

wPracticeDuelTurn:: ; cc00
	ds $1

wcc01:: ; cc01
	ds $2

; used to print a Pokemon card's length in feet and inches
wPokemonLengthPrintOffset:: ; cc03
	ds $1

; used when opening the card page of a move when attacking, serving as an index for MovePageDisplayPointerTable.
; see MOVEPAGE_* constants
wMovePageNumber:: ; cc04
	ds $1

; the value of hWhoseTurn gets loaded here at the beginning of each duelist's turn.
; more reliable than hWhoseTurn, as hWhoseTurn may change temporarily in order to handle status
; conditions or other events of the non-turn duelist. used mostly between turns (to check which
; duelist's turn just finished), or to restore the value of hWhoseTurn at some point.
wWhoseTurn:: ; cc05
	ds $1

; number of turns taken by both players
wDuelTurns:: ; cc06
	ds $1

; used to signal that the current duel has finished, not to be mistaken with wDuelResult
; 0 = no one has won duel yet
; 1 = player whose turn it is has won the duel
; 2 = player whose turn it is has lost the duel
; 3 = duel ended in a draw (start sudden death match)
wDuelFinished:: ; cc07
	ds $1

; current duel is a [wDuelInitialPrizes]-prize match
wDuelInitialPrizes:: ; cc08
	ds $1

; a DUELTYPE_* constant. note that for a practice duel, wIsPracticeDuel must also be set to $1
wDuelType:: ; cc09
	ds $1

; set to 1 if the coin toss during the CheckSandAttackOrSmokescreenSubstatus check is heads
wGotHeadsFromSandAttackOrSmokescreenCheck:: ; cc0a
	ds $1

wAlreadyPlayedEnergy:: ; cc0b
	ds $1

; set to 1 if the confusion check coin toss in AttemptRetreat is heads
wGotHeadsFromConfusionCheckDuringRetreat:: ; cc0c
	ds $1

; DUELIST_TYPE_* of the turn holder
wDuelistType:: ; cc0d
	ds $1

; this holds the current opponent's deck minus 2 (that is, a *_DECK_ID constant),
; in order to account for the two unused pointers at the beginning of DeckPointers.
wOpponentDeckID:: ; cc0e
	ds $1

wcc0f:: ; cc0f
	ds $1

; index (0-1) of the move or Pokemon Power being used by the player's arena card
; set to $ff when the duel starts and at the end of the opponent's turn
wPlayerAttackingMoveIndex:: ; cc10
	ds $1

; deck index of the player's arena card that is attacking or using a Pokemon Power
; set to $ff when the duel starts and at the end of the opponent's turn
wPlayerAttackingCardIndex:: ; cc11
	ds $1

; ID of the player's arena card that is attacking or using a Pokemon Power
wPlayerAttackingCardID:: ; cc12
	ds $1

wIsPracticeDuel:: ; cc13
	ds $1

wcc14:: ; cc14
	ds $1

wOpponentPortrait:: ; cc15
	ds $1

; text id of the opponent's name
wOpponentName:: ; cc16
	ds $2

; an overworld script starting a duel sets this address to the value to be written into wDuelInitialPrizes
wcc18:: ; cc18
	ds $1

; an overworld script starting a duel sets this address to the value to be written into wOpponentDeckID
wcc19:: ; cc19
	ds $1

; song played during a duel
wDuelTheme:: ; cc1a
	ds $1

; holds the energies attached to a given pokemon card. 1 byte for each of the
; 8 energy types (includes the unused one that shares byte with the colorless energy)
wAttachedEnergies:: ; cc1b
	ds NUM_TYPES

; holds the total amount of energies attached to a given pokemon card
wTotalAttachedEnergies:: ; cc23
	ds $1

; Used as temporary storage for a card's data
wLoadedCard1:: ; cc24
	card_data_struct wLoadedCard1
wLoadedCard2:: ; cc65
	card_data_struct wLoadedCard2
wLoadedMove:: ; cca6
	move_data_struct wLoadedMove

; the damage field of an used move is loaded here
; doubles as "wAIAverageDamage" when complementing wAIMinDamage and wAIMaxDamage
; little-endian
; second byte may have UNAFFECTED_BY_WEAKNESS_RESISTANCE_F set/unset
wDamage:: ; ccb9
	ds $2

; wAIMinDamage and wAIMaxDamage appear to be used for AI scoring
; they are updated with the minimum (or floor) damage of the current move
; and with the maximum (or ceiling) damage of the current move
wAIMinDamage:: ; ccbb
	ds $1

wAIMaxDamage:: ; ccbc
	ds $1

wccbd:: ; ccbd
	ds $2

; damage dealt by an attack to a target
wDealtDamage:: ; ccbf
	ds $2

; WEAKNESS and RESISTANCE flags for a damaging attack
wDamageEffectiveness:: ; ccc1
	ds $1

; used in damage related functions
wTempCardID_ccc2:: ; ccc2
	ds $1

wTempTurnDuelistCardID:: ; ccc3
	ds $1

wTempNonTurnDuelistCardID:: ; ccc4
	ds $1

; the status condition of the defending Pokemon is loaded here after an attack
wccc5:: ; ccc5
	ds $1

; *_ATTACK constants for selected attack
; 0 for the first attack (or PKMN Power)
; 1 for the second attack
wSelectedAttack:: ; ccc6
	ds $1

; if affected by a no damage or effect substatus, this flag indicates what the cause was
wNoDamageOrEffect:: ; ccc7
	ds $1

; used by CountKnockedOutPokemon and Func_5805 to store the amount
; of prizes to take (equal to the number of Pokemon knocked out)
wNumberPrizeCardsToTake:: ; ccc8
	ds $1

; set to 1 if the coin toss in the confusion check is heads (CheckSelfConfusionDamage)
wGotHeadsFromConfusionCheck:: ; ccc9
	ds $1

; used to store card indices of all stages, in order, of a Play Area Pokémon
wAllStagesIndices:: ; ccca
	ds $3

wEffectFunctionsFeedbackIndex:: ; cccd
	ds $1

; some array used in effect functions with wEffectFunctionsFeedbackIndex
; as the index, used to return feedback. unknown length.
wEffectFunctionsFeedback:: ; ccce
	ds $18

; this is 1 (non-0) if dealing damage to self due to confusion
; or a self-destruct type attack
wIsDamageToSelf:: ; cce6
	ds $1

wcce7:: ; cce7
	ds $1

wcce8:: ; cce8
	ds $1

; used in CopyDeckData
wcce9:: ; cce9
	ds $2

; a PLAY_AREA_* constant (0: arena card, 1-5: bench card)
wTempPlayAreaLocation_cceb:: ; cceb
	ds $1

wccec:: ; ccec
	ds $1

; used by the effect functions to return the cause of an effect to fail
; in order print the appropriate text
wEffectFailed:: ; cced
	ds $1

wccee:: ; ccee
	ds $1

; flag to determine whether DUELVARS_ARENA_CARD_LAST_TURN_DAMAGE
; gets zeroed or gets updated with wDealtDamage
wccef:: ; ccef
	ds $1

; stores the energy cost of the Metronome attack being used.
; it's used to know how many attached Energy cards are being used
; to pay for the attack for damage calculation.
; if equal to 0, then the attack wasn't invoked by Metronome.
wMetronomeEnergyCost:: ; ccf0
	ds $1

; effect functions return a status condition constant here when it had no effect
; on the target, in order to print one of the ThereWasNoEffectFrom* texts
wNoEffectFromWhichStatus:: ; ccf1
	ds $1

; when non-0, allows the player to skip some delays during a duel by pressing B.
; value read from s0a009. probably only used for debugging.
wSkipDelayAllowed:: ; ccf2
	ds $1

SECTION "WRAM0 2", WRAM0

; on CGB, attributes of the text box borders. (values 0-7 seem to be used, which only affect palette)
; on SGB, colorize text box border with SGB1 if non-0
wTextBoxFrameType:: ; ccf3
	ds $1

; pixel data of a tile used for text
; either a combination of two half-width characters or a full-width character
wTextTileBuffer:: ; ccf4
	ds TILE_SIZE

wcd04:: ; cd04
	ds $1

; used by PlaceNextTextTile
wCurTextTile:: ; cd05
	ds $1

; VRAM tile patterns selector for text tiles
; if wTilePatternSelector == $80 and wTilePatternSelectorCorrection == $00 -> select tiles at $8000-$8FFF
; if wTilePatternSelector == $88 and wTilePatternSelectorCorrection == $80 -> select tiles at $8800-$97FF
wTilePatternSelector:: ; cd06
	ds $1

; complements wTilePatternSelector by correcting the VRAM tile order when $8800-$97FF is selected
; a value of $80 in wTilePatternSelectorCorrection reflects tiles $00-$7f being located after tiles $80-$ff
wTilePatternSelectorCorrection:: ; cd07
	ds $1

; if 0, text lines are separated by a blank line
wLineSeparation:: ; cd08
	ds $1

; line number in which text is being printed as an offset to
; the topmost line, including separator lines
wCurTextLine:: ; cd09
	ds $1

; how to process the current text tile
; 0: full-width font | non-0: half-width font
wFontWidth:: ; cd0a
	ds $1

; when printing half-width text, this variable alternates between 0 and the value
; of the first character. 0 signals that no text should be printed in the current
; iteration of Func_235e, while non-0 means to print the character pair
; made of [wHalfWidthPrintState] (first char) and register e (second char).
wHalfWidthPrintState:: ; cd0b
	ds $1

; used by CopyTextData
wTextMaxLength:: ; cd0c
	ds $1

; half-width font letters become uppercase if non-0, lowercase if 0
wUppercaseHalfWidthLetters:: ; cd0d
	ds $1

	ds $1

; handles timing of (horizontal or vertical) arrow blinking while waiting for user input.
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

wCursorTile:: ; cd15
	ds $1

wTileBehindCursor:: ; cd16
	ds $1

; if non-$0000, the function loaded here is called once per frame by HandleMenuInput
wMenuFunctionPointer:: ; cd17
	ds $2

wListScrollOffset:: ; cd19
	ds $1

wListItemXPosition:: ; cd1a
	ds $1

wNumListItems:: ; cd1b
	ds $1

wListItemNameMaxLength:: ; cd1c
	ds $1

; if non-$0000, the function loaded here is called once per frame by CardListMenuFunction,
; which is the function loaded to wMenuFunctionPointer for card lists
wListFunctionPointer:: ; cd1d
	ds $2

	ds $78

; in a card list, the Y position where the <sel_item>/<num_items> indicator is placed
; if wCardListIndicatorYPosition == $ff, no indicator is displayed
wCardListIndicatorYPosition:: ; cd97
	ds $1

; x coord of the leftmost item in a horizontal menu
wLeftmostItemCursorX:: ; cd98
	ds $1

; used in RefreshMenuCursor_CheckPlaySFX to play a sound during any frame when this address is non-0
wRefreshMenuCursorSFX:: ; cd99
	ds $1

; when printing a YES/NO menu, whether the cursor is
; initialized to the YES ($01) or to the NO ($00) item
wDefaultYesOrNo:: ; cd9a
	ds $1

; used in _CopyCardNameAndLevel to keep track of the remaining space to copy the text
wcd9b:: ; cd9b
	ds $1

wcd9c:: ; cd9c
	ds $1

; this stores the result from a coin toss (number of heads)
wCoinTossNumHeads:: ; cd9d
	ds $1

wcd9e:: ; cd9e
	ds $1

wcd9f:: ; cd9f
	ds $1

	ds $5

wcda5:: ; cda5
	ds $1

; this is used by AI in order to determine whether
; it should use Pokedex Trainer card.
; starts with 5 when Duel starts and counts up by 1 every turn.
; only when it's higher than 5 is AI allowed to use Pokedex,
; in which case it sets the counter to 0.
; this stops the AI from using Pokedex right after using another one
; while still drawing cards that were ordered.
wAIPokedexCounter:: ; cda6
	ds $1

; variable to keep track of Mewtwo1's Barrier usage during Player' turn.
; AI_MEWTWO_MILL set means Player is running Mewtwo1 mill deck.
; 	- when flag is not set, this counts how many turns in a row
;	  Player used Mewtwo1's Barrier attack;
;	- when flag is set, this counts how many turns in a row
;	  Player has NOT used Barrier attack.
wAIBarrierFlagCounter:: ; cda7
	ds $1

; pointer to $00-terminated list of card IDs
; to avoid being placed as prize cards
; when setting up AI duelist's cards at duel start.
; (see SetUpBossStartingHandAndDeck)
wAICardListAvoidPrize:: ; cda8
	ds $2

; pointer to $00-terminated list of card IDs
; sorted by priority of AI placing in the Arena
; at duel start (see TrySetUpBossStartingPlayArea)
wAICardListArenaPriority:: ; cdaa
	ds $2

; pointer to $00-terminated list of card IDs
; sorted by priority of AI placing in the Bench
; at duel start (see TrySetUpBossStartingPlayArea)
wAICardListBenchPriority:: ; cdac
	ds $2

; pointer to $00-terminated list of card IDs
; sorted by priority of AI playing it from Hand
; to the Bench (see AIDecidePlayPokemonCard)
wAICardListPlayFromHandPriority:: ; cdae
	ds $2

; pointer to $00-terminated list of card IDs and AI scores.
; these are for giving certain cards more or less
; likelihood of being picked by AI to switch to.
; (see AIDecideBenchPokemonToSwitchTo)
wAICardListRetreatBonus:: ; cdb0
	ds $2

; pointer to $00-terminated list of card IDs,
; number of energy cards and AI score.
; these are for giving certain cards more or less
; likelihood of being picked for AI to attach energy.
; also has the maximum number of energy cards that
; the AI is willing to provide for it.
; (see AIProcessEnergyCards)
wAICardListEnergyBonus:: ; cdb2
	ds $2

wcdb4:: ; cdb4
	ds $1

; information about various properties of
; loaded move for AI calculations
wTempLoadedMoveEnergyCost:: ; cdb5
	ds $1
wTempLoadedMoveEnergyNeededType:: ; cdb6
	ds $1
wTempLoadedMoveEnergyNeededAmount:: ; cdb7
	ds $1

; used for the AI to store various
; details about a given card
wTempCardRetreatCost:: ; cdb8
	ds $1
wTempCardID:: ; cdb9
	ds $1
wTempCardType:: ; cdba
	ds $1

	ds $3

; used for AI to score decisions for actions
wAIScore:: ; cdbe
	ds $1

UNION

; used for AI decisions that involve
; each card in the Play Area.
wPlayAreaAIScore:: ; cdbf
	ds MAX_PLAY_AREA_POKEMON

NEXTU

; stores the score determined by AI for first attack
wFirstAttackAIScore:: ; cdbf
	ds $1

ENDU

	ds $a

; information about the defending Pokémon and
; the prize card count on both sides for AI:
; player's active Pokémon color
wAIPlayerColor:: ; cdcf
	ds $1
; player's active Pokémon weakness
wAIPlayerWeakness:: ; cdd0
	ds $1
; player's active Pokémon resistance
wAIPlayerResistance:: ; cdd1
	ds $1
; player's prize count
wAIPlayerPrizeCount:: ; cdd2
	ds $1
; opponent's prize count
wAIOpponentPrizeCount:: ; cdd3
	ds $1

; AI stores the card ID to look for here
wTempCardIDToLook:: ; cdd4
	ds $1

; when AI decides which Bench Pokemon to switch to
; it stores it Play Area location here.
wAIPlayAreaCardToSwitch:: ; cdd5
	ds $1

; the index of attack chosen by AI
; to use with Pluspower.
wAIPluspowerAttack:: ; cdd6
	ds $1

; whether AI is allowed to play an energy card
; from the hand in order to retreat arena card
;	$00 = not allowed
;	$01 = allowed
wAIPlayEnergyCardForRetreat:: ; cdd7
	ds $1

; flags defined by AI_ENERGY_FLAG_* constants
; used as input for AIProcessEnergyCards
; to determine what to check in the routine.
wAIEnergyAttachLogicFlags:: ; cdd8
	ds $1

; used as input to AIProcessAttacks.
; if 0, execute the attack chosen by the AI.
; if not 0, return without executing attack.
wAIExecuteProcessedAttack:: ; cdd9
	ds $1

wcdda:: ; cdda
	ds $1

wcddb:: ; cddb
	ds $1

wcddc:: ; cddc
	ds $1

; used to temporarily backup wPlayAreaAIScore values.
wTempPlayAreaAIScore:: ; cddd
	ds MAX_PLAY_AREA_POKEMON

wTempAIScore:: ; cde3
	ds $1

; used for AI decisions that involve
; each card in the Play Area involving
; attaching Energy cards.
wPlayAreaEnergyAIScore:: ; cde4
	ds MAX_PLAY_AREA_POKEMON

wcdea:: ; cdea
	ds MAX_PLAY_AREA_POKEMON

; whether AI cannot inflict damage on player's active Pokémon
; (due to No Damage or Effect substatus).
;	$00 = can damage
;	$01 = can't damage
wAICannotDamage:: ; cdf0
	ds $1

; used by AI to store variable information
wTempAI:: ; cdf1
	ds $1

; used for AI to store whether this card can use any attack
; $00 = can't attack
; $01 = can attack
wCurCardCanAttack:: ; cdf2
	ds $1

; used to temporarily store the card deck index
; while AI is deciding whether to evolve Pokémon
; or deciding whether to play Pokémon card from hand
wTempAIPokemonCard:: ; cdf3
	ds $1

; used for AI to store whether this card can KO defending Pokémon
; $00 = can't KO
; $01 = can KO
wCurCardCanKO:: ; cdf4
	ds $1

	ds $4

wcdf9:: ; cdf9
	ds $1

wcdfa:: ; cdfa
	ds MAX_PLAY_AREA_POKEMON

wce00:: ; ce00
	ds $1
wce01:: ; ce01
	ds $1

; whether AI's move is a damaging move or not
; (move that only damages bench is treated as non-damaging)
; $00 = is a damaging move
; $01 = is a non damaging move
wAIMoveIsNonDamaging:: ; ce02
	ds $1

; whether AI already retreated this turn or not.
;	- $0 has not retreated;
;	- $1 has retreated.
wAIRetreatedThisTurn:: ; ce03
	ds $1

; used by AI to store information of Venusaur2
; while handling Energy Trans logic.
wAIVenusaur2DeckIndex:: ; ce04
	ds $1
wAIVenusaur2PlayAreaLocation:: ; ce05
	ds $1

wce06:: ; ce06
; number of cards to be transferred by AI using Energy Trans.
wAINumberOfEnergyTransCards:: ; ce06
; used for storing weakness of Player's Arena card
; in AI routine dealing with Shift Pkmn Power.
wAIDefendingPokemonWeakness:: ; ce06
	ds $1

wce07:: ; ce07
	ds $1

wce08:: ; ce08
	ds $7

wce0f:: ; ce0f
	ds $7

; stores the deck index (0-59) of the Trainer card
; the AI intends to play from hand.
wAITrainerCardToPlay:: ; ce16
	ds $1

wce17:: ; ce17
	ds $1

wce18:: ; ce18
	ds $1

; parameters output by AI Trainer card logic routines
; (e.g. what Pokemon in Play Area to use card on, etc)
wAITrainerCardParameter:: ; ce19
	ds $1

wce1a:: ; ce1a
	ds $1

wce1b:: ; ce1b
	ds $1

wce1c:: ; ce1c
	ds $1

wce1d:: ; ce1d
	ds $1

wce1e:: ; ce1e
	ds $1

wce1f:: ; ce1f
	ds $1

; used to store previous/current flags of AI actions
; see AI_FLAG_* constants
wPreviousAIFlags:: ; ce20
	ds $1
wCurrentAIFlags:: ; ce21
	ds $1

; During a duel, this is always $b after the first attack.
; $b is the bank where the functions associated to card or effect commands are.
; Its only purpose seems to be store this value to be read by TryExecuteEffectCommandFunction.
; possibly used in other contexts too
wce22:: ; ce22
	ds $1

; LoadCardGfx loads the card's palette here
wCardPalette:: ; ce23
	ds CGB_PAL_SIZE

; information about the text being currently processed, including font width,
; the rom bank, and the memory address of the next character to be printed.
; supports up to four nested texts (used with TX_RAM).
wTextHeader1:: ; ce2b
	text_header wTextHeader1
wTextHeader2:: ; ce30
	text_header wTextHeader2
wTextHeader3:: ; ce35
	text_header wTextHeader3
wTextHeader4:: ; ce3a
	text_header wTextHeader4

; text id for the first TX_RAM2 of a text
; prints from wDefaultText if $0000
wTxRam2:: ; cd3f
	ds $2

; text id for the second TX_RAM2 of a text
wTxRam2_b:: ; ce41
	ds $2

; text id for the first TX_RAM3 of a text
; a number between 0 and 65535
wTxRam3:: ; ce43
	ds $2

; text id for the second TX_RAM3 of a text
; a number between 0 and 65535
wTxRam3_b:: ; ce45
	ds $2

; when printing text, number of frames to wait between each text tile
wTextSpeed:: ; ce47
	ds $1

; a number between 0 and 3 to select a wTextHeader to use for the current text
wWhichTextHeader:: ; ce48
	ds $1

; selects wTxRam2 or wTxRam2_b
wWhichTxRam2:: ; ce49
	ds $1

; selects wTxRam3 or wTxRam3_b
wWhichTxRam3:: ; ce4a
	ds $1

wIsTextBoxLabeled:: ; ce4b
	ds $1

; text id of a text box's label
wTextBoxLabel:: ; ce4c
	ds $2

wCoinTossScreenTextID:: ; ce4e
	ds $2

; set to PLAYER_TURN in the "Your Play Area" screen
; set to OPPONENT_TURN in the "Opp Play Area" screen
; alternates when drawing the "In Play Area" screen
wCheckMenuPlayAreaWhichDuelist:: ; ce50
	ds $1

; apparently complements wCheckMenuPlayAreaWhichDuelist to be able to combine
; the usual player or opponent layout with the opposite duelist information
; appears not to be relevant in the "In Play Area" screen
wCheckMenuPlayAreaWhichLayout:: ; ce51
	ds $1

; the position of cursor in the "In Play Area" screen
wInPlayAreaCurPosition:: ; ce52

; holds the position of the cursor when selecting a prize card
wPrizeCardCursorPosition:: ; ce52
	ds $1

; pointer to the table which contains information for each key-press.
wInPlayAreaInputTablePointer:: ; ce53

wce53:: ; ce53
	ds $2

; same as wDuelInitialPrizes but with upper 2 bits set
wDuelInitialPrizesUpperBitsSet:: ; ce55
	ds $1

	ds $1

; it's used for restore the position of cursor
; when going into another view, and returning to
; the previous view.
wInPlayAreaPreservedPosition:: ; ce57
	ds $1

; it's used for checking if the player changed
; the cursor in the play area view.
wInPlayAreaTemporaryPosition:: ; ce58
	ds $1

wce59:: ; ce59
	ds $1

	ds $3

; stores whether there are Pokemon in play area
; player arena Pokemon sets bit 0
; opponent arena Pokemon sets bit 1
wArenaCardsInPlayArea:: ; ce5d
	ds $1

wce5e:: ; ce5e
	ds $1

; this is used to store last cursor position
; in the "Your Play Area" and the "Opp. Play Area" screens
wYourOrOppPlayAreaLastCursorPosition:: ; ce5f
	ds $1

; $00 when the "In Play Area" screen has been opened from the Check menu
; $01 when the "In Play Area" screen has been opened by pressing the select button
wInPlayAreaFromSelectButton:: ; ce60
	ds $1

; it's used only in one function,
; which means that it's a kind of local variable, but defined in wram.
wPrizeCardCursorTemporaryPosition:: ; ce61
	ds $1

wGlossaryPageNo:: ; ce62
	ds $1

wce63:: ; ce63
	ds $1

wce64:: ; ce64
	ds $1

wce65:: ; ce65
	ds $1

wce66:: ; ce66
	ds $1

wce67:: ; ce67
	ds $1

wce68:: ; ce68
	ds $1

wce69:: ; ce69
	ds $1

wce6a:: ; ce6a
	ds $1

wce6b:: ; ce6b
	ds $1

wce6c:: ; ce6c
	ds $1

wce6d:: ; ce6d
	ds $1

wce6e:: ; ce6e
	ds $1

wce6f:: ; ce6f
	ds $1

wce70:: ; ce70
	ds $1

wce71:: ; ce71
	ds $1

wce72:: ; ce72
	ds $1

; card index and its attack index chosen
; to be used by Metronome.
wMetronomeSelectedAttack:: ; ce73
	ds $2

; stores the amount of cards that are being ordered.
wNumberOfCardsToOrder:: ; ce75
	ds $1

wce76:: ; ce76
	ds MAX_PLAY_AREA_POKEMON

; used in CountPokemonIDInPlayArea
wTempPokemonID_ce7c:: ; ce7c
	ds $1

	ds $1

wce7e:: ; ce7e
	ds $1

wce7f:: ; ce7f
	ds $2

wce81:: ; ce81
	ds $1

wce82:: ; ce82
	ds $1

wce83:: ; ce83
	ds $1

wce84:: ; ce84
	ds $1

	ds $1c

wcea1:: ; cea1
	ds $1

	ds $1

; it's used when the player enters check menu, and its sub-menus.
; increases from 0x00 to 0xff. the game makes its blinking cursor by this.
; note that the check menu also contains the pokemon glossary.
wCheckMenuCursorBlinkCounter:: ; cea3
	ds $1

wNamingScreenCursorY:: ; cea4
	ds $1

wcea5:: ; cea5
	ds $4

wNamingScreenKeyboardHeight:: ; cea9
	ds $1

wceaa:: ; ceaa
	ds $1

wceab:: ; ceab
	ds $4

wCheckMenuCursorXPosition:: ; ceaf
	ds $1

wCheckMenuCursorYPosition:: ; ceb0
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
	ds $1

; used to store the tens digit and
; ones digit of a value for printing
; the ones digit is added $20
; ceb6 = ones digit (+ $20)
; ceb7 = tens digit
wOnesAndTensPlace:: ; ceb6
	ds $2

	ds $3

wcebb:: ; cebb
	ds $1

	ds $10

wcecc:: ; cecc
	ds $1

	ds $1

wcece:: ; cece
	ds $2

	ds $a

; pointer to memory to store AI temporary hand card list
wHandTempList:: ; ceda
	ds $2

	ds $3b

; used in bank2, probably related to wTempHandCardList (another temp list?)
wcf17:: ; cf17
	ds DECK_SIZE

	ds $15

; used by _AIProcessHandTrainerCards, AI related
wTempHandCardList:: ; cf68
	ds DECK_SIZE

	ds $15

wcfb9:: ; cfb9
	ds $1

	ds $17

wcfd1:: ; cfd1
	ds $1

	ds $8

wcfda:: ; cfda
	ds $2

	ds $7

; a flag indicating whether sfx should be played.
wPlaysSfx:: ; cfe3
	ds $1

wcfe4:: ; cfe4
	ds $3

; a name buffer in the naming screen.
wNamingScreenBuffer:: ; cfe7
	ds NAMING_SCREEN_BUFFER_LENGTH

; current name length in the naming screen.
wNamingScreenBufferLength:: ; cfff
	ds $1

SECTION "WRAM1", WRAMX
wNamingScreenDestPointer:: ; d000
	ds $2

wNamingScreenQuestionPointer:: ; d002
	ds $2

; max length of name buffer.
; it's given for limiting the player's input.
wNamingScreenBufferMaxLength:: ; d004
	ds $1

wd005:: ; d005
	ds $1

wNamingScreenCursorX:: ; d006
	ds $1

; the position to display the input on.
wNamingScreenNamePosition:: ; d007
	ds $2

wd009:: ; d009
	ds $4

wd00d:: ; d00d
	ds $1

	ds $78

wd086:: ; d086
	ds $1

wd087:: ; d087
	ds $1

wd088:: ; d088
	ds $1

wd089:: ; d089
	ds $1

wd08a:: ; d08a
	ds $18

wd0a2:: ; d0a2
	ds $2

wd0a4:: ; d0a4
	ds $1

wd0a5:: ; d0a5
	ds $1

wd0a6:: ; d0a6
	ds $1

dw0a7:: ; d0a7
	ds $2

wd0a9:: ; d0a9
	ds $1

wd0aa:: ; d0aa
	ds $1

	ds $9

wd0b4:: ; d0b4
	ds $1

; a GAME_EVENT_* constant corresponding to an entry in GameEventPointerTable
; overworld, duel, credits...
wGameEvent:: ; d0b5
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

wTempMap:: ; d0bb
	ds $1

wTempPlayerXCoord:: ; d0bc
	ds $1

wTempPlayerYCoord:: ; d0bd
	ds $1

wTempPlayerDirection:: ; d0be
	ds $1

; See constants/misc_constants.asm for OWMODE's
wOverworldMode:: ; d0bf
	ds $1

wd0c0:: ; d0c0
	ds $1

wd0c1:: ; d0c1
	ds $1

wd0c2:: ; d0c2
	ds $1

; stores the player's result in a duel (0: loss, 1: win, 2: ???, -1: transmission error?)
; to be read by the overworld caller
wDuelResult:: ; d0c3
	ds $1

wd0c4:: ; d0c4
	ds $1

wd0c5:: ; d0c5
	ds $1

; used to store the location of an overworld script, which is jumped to later
wNextScript:: ; d0c6
	ds $2

wCurrentNPCNameTx:: ; d0c8
	ds $2

wDefaultObjectText:: ; d0ca
	ds $2

wd0cc:: ; d0cc
	ds 8 palettes

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
	ds $1

	ds $3

wd11b:: ; d11b
	ds $1

	ds $1

wPCPackSelection:: ; d11d
	ds $1

; 7th bit of each pack corresponds to whether or not it's been read
wPCPacks:: ; d11e
	ds $f

wPCLastDirectionPressed:: ; d12d
	ds $1

	ds $1

wd12f:: ; d12f
	ds $1

wd130:: ; d130
	ds $1

wd131:: ; d131
	ds $1

wd132:: ; d132
	ds $1

UNION

; when opening a booster pack, list of cards available in the booster pack of a specific rarity
wBoosterViableCardList:: ; d133
	ds $100

NEXTU

; permission map of the current room with impassable objects (walls, NPCs, etc).
; $00: passable (floor)
; $40: impassable and talkable (NPC or talkable wall)
; $80: impassable and untalkable (wall)
wPermissionMap:: ; d133
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
	ds $1

	ds $1

wd23a:: ; d23a
	ds $1

wd23b:: ; d23b
	ds $1

wd23c:: ; d23c
	ds $1

wd23d:: ; d23d
	ds $1

wd23e:: ; d23e
	ds $1

	ds $50

wd28f:: ; d28f
	ds $1

wd290:: ; d290
	ds $1

wd291:: ; d291
	ds $1

wd292:: ; d292
	ds $1

	ds $90

wd323:: ; d323
	ds $1

wd324:: ; d324
	ds $1

	ds $9

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

wPlayerDirection:: ; d334
	ds $1

; seems to be 1 if moving 0 otherwise
wPlayerCurrentlyMoving:: ; d335
	ds $1

wPlayerSpriteIndex:: ; d336
	ds $1

wd337:: ; d337
	ds $1

wd338:: ; d338
	ds $1

wd339:: ; d339
	ds $1

wd33a:: ; d33a
	ds $1

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
	ds $1

	ds $1

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
	ds $1

wd349:: ; d349
	ds $1

wLoadedNPCs:: ; d34a
	loaded_npc_struct wLoadedNPC1
	loaded_npc_struct wLoadedNPC2
	loaded_npc_struct wLoadedNPC3
	loaded_npc_struct wLoadedNPC4
	loaded_npc_struct wLoadedNPC5
	loaded_npc_struct wLoadedNPC6
	loaded_npc_struct wLoadedNPC7
	loaded_npc_struct wLoadedNPC8

wLoadedNPCTempIndex:: ; d3aa
	ds $1

wTempNPC:: ; d3ab
	ds $1

wLoadNPCXPos:: ; d3ac
	ds $1

wLoadNPCYPos:: ; d3ad
	ds $1

wLoadNPCDirection:: ; d3ae
	ds $1

wLoadNPCFunction:: ; d3af
	ds $2

wd3b1:: ; d3b1
	ds $1

wd3b2:: ; d3b2
	ds $1

wd3b3:: ; d3b3
	ds $1

	ds $2

; ID of the NPC being interacted with in Script
wScriptNPC:: ; d3b6
	ds $1

wc3b7:: ; d3b7
	ds $1

wd3b8:: ; d3b8
	ds $1

wd3b9:: ; d3b9
	ds $2

wd3bb:: ; d3bb
	ds $1

	ds $14

wd3d0:: ; d3d0
	ds $1

; the bits relevant to the currently worked on flag, obtained from EventFlagMods
wLoadedFlagBits:: ; d3d1
	ds $1

wEventFlags:: ; d3d2
	ds $40

; 0 keeps looping, other values break the loop in RST20
wBreakScriptLoop:: ; d412
	ds $1

wScriptPointer:: ; d413
	ds $2

; generally set to ff when a flag check passes, 0 otherwise
wScriptControlByte:: ; d415
	ds $1

wd416:: ; d416
	ds $1

wd417:: ; d417
	ds $1

	ds $5

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

; holds an animation to play
wTempAnimation:: ; d422
	ds $1

; holds a list of animations to play
; as long as any of the slot isn't $ff, there's something to play
; it may actually not be a queue
wAnimationQueue:: ; d423
	ds ANIMATION_QUEUE_LENGTH

wd42a:: ; d42a
	ds $1

wd42b:: ; d42b
	ds $1

	ds $80

wd4ac:: ; d4ac
	ds $1

wd4ad:: ; d4ad
	ds $1

wd4ae:: ; d4ae
	ds $1

wd4af:: ; d4af
	ds $1

wd4b0:: ; d4b0
	ds $1

wd4b1:: ; d4b1
	ds $1

wd4b2:: ; d4b2
	ds $1

wd4b3:: ; d4b3
	ds $1

	ds $5

wd4b9:: ; d4b9
	ds $1

	ds $4

wd4be:: ; d4be
	ds $1

wd4bf:: ; d4bf
	ds $1

wd4c0:: ; d4c0
	ds $1

	ds $1

wd4c2:: ; d4c2
	ds $1

wd4c3:: ; d4c3
	ds $1

; these next 3 seem to be an address (bank @ end) for copying bg data
wTempPointer:: ; d4c4
	ds $2

wTempPointerBank:: ; d4c6
	ds $1

wd4c7:: ; d4c7
	ds $1

wd4c8:: ; d4c8
	ds $1

	ds $1

wd4ca:: ; d4ca
	ds $1

wd4cb:: ; d4cb
	ds $1

	ds $3

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

wCurrSpriteAttributes:: ; d5d0
	ds $1

wCurrSpriteXPos:: ; d5d1
	ds $1

wCurrSpriteYPos:: ; d5d2
	ds $1

wCurrSpriteTileID:: ; d5d3
	ds $1

wCurrSpriteRightEdgeCheck:: ; d5d4
	ds $1

wCurrSpriteBottomEdgeCheck:: ; d5d5
	ds $1

wd5d6:: ; d5d6
	ds $1

wd5d7:: ; d5d7
	ds $1

wd5d8:: ; d5d8
	ds $40

; seems to be the amount of entries in wd5d8
wd618:: ; d618
	ds $1

	ds $2

wd61b:: ; d61b
	ds $1

	ds $2

wd61e:: ; d61e
	ds $1

	ds $5

wd624:: ; d624
	ds $1

	ds $1

wd626:: ; d626
	ds $1

wd627:: ; d627
	ds $1

wd628:: ; d628
	ds $1

	ds $a

wd633:: ; d633
	ds $1

	ds $1

wd635:: ; d635
	ds $1

wd636:: ; d635
	ds $1

	ds $14

; wd64b to wd665 used by Func_3e44
wd64b:: ; d64b
	ds $6

wd651:: ; d651
	ds $6

wd657:: ; d657
	ds $1

wd658:: ; d658
	ds $1

wd659:: ; d659
	ds $6

wd65f:: ; d65f
	ds $6

wd665:: ; d665
	ds $1

; used by GetNextBackgroundScroll
wBGScrollMod:: ; d666
	ds $1

; used by ApplyBackgroundScroll
wApplyBGScroll:: ; d667
	ds $1

; used by ApplyBackgroundScroll
wNextScrollLY:: ; d668
	ds $1

; which BoosterPack_* corresponds to the booster pack that the player is opening
wBoosterPackID:: ; d669
	ds $1

; card being currently processed by the booster pack engine functions
wBoosterCurrentCard:: ; d66a
	ds $1

; BOOSTER_CARD_TYPE_* of the card that has just been drawn from the pack
wBoosterJustDrawnCardType:: ; d66b
	ds $1

; rarity of the cards being currently generated (non-energy cards are generated ordered by rarity)
wBoosterCurrentRarity:: ; d66c
	ds $1

; the averaged value of all values in wBoosterData_TypeChances
; used to recalculate the chances of a booster card type when a card of said type is drawn from the pack
wBoosterAveragedTypeChances:: ; d66d
	ds $1

; data of the booster pack copied from the corresponding BoosterSetRarityAmountsTable entry
wBoosterData_CommonAmount:: ; d66e
	ds $1
wBoosterData_UncommonAmount:: ; d66f
	ds $1
wBoosterData_RareAmount:: ; d670
	ds $1

; how many cards of each type are available of a certain rarity in the booster pack's set
wBoosterAmountOfCardTypeTable:: ; d671
	ds NUM_BOOSTER_CARD_TYPES

; holds information similar to wBoosterData_TypeChances, except that it contains 00 on any type
; of which there are no cards remaining in the set for the current rarity
wBoosterTempTypeChancesTable:: ; d67a
	ds NUM_BOOSTER_CARD_TYPES

; properties of the card being currently processed by the booster pack engine functions
wBoosterCurrentCardType:: ; d683
	ds $1
wBoosterCurrentCardRarity:: ; d684
	ds $1
wBoosterCurrentCardSet:: ; d685
	ds $1

; data of the booster pack copied from the corresponding BoosterPack_* structure.
; wBoosterData_TypeChances is updated after each card is drawn, to re-balance the type chances.
wBoosterData_Set:: ; d686
	ds $1
wBoosterData_EnergyFunctionPointer:: ; d687
	ds $2
wBoosterData_TypeChances:: ; d689
	ds NUM_BOOSTER_CARD_TYPES

	ds $1

wd693:: ; d693
	ds $1

wMultichoiceTextboxResult_Sam:: ; d694
	ds $1
	
UNION

wMultichoiceTextboxResult_ChooseDeckToDuelAgainst:: ; d695
	ds $1

NEXTU

wd695:: ; d695
	ds $1

ENDU



wd696:: ; d696
	ds $1

wd697:: ; d697
	ds $1

	ds $6e8

SECTION "WRAM1 Audio", WRAMX

; bit 7 is set once the song has been started
wCurSongID:: ; dd80
	ds $1

wCurSongBank:: ; dd81
	ds $1

; bit 7 is set once the sfx has been started
wCurSfxID:: ; dd82
	ds $1

; priority value of current sfx (0 if nothing is playing)
wSfxPriority:: ; dd83
	ds $1

; 8-bit output enable mask for left/right output for each channel
wMusicStereoPanning:: ; dd84
	ds $1

wdd85:: ; dd85
	ds $1

wMusicDuty1:: ; dd86
	ds $1

wMusicDuty2:: ; dd87
	ds $1

	ds $2

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
	ds $1

	ds $2

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

; the delay (1-8) before a note is cut off early (0 is disabled)
wMusicCutoff:: ; ddbf
	ds $4

wddc3:: ; ddc3
	ds $4

; the volume to apply after a cutoff
wMusicEcho:: ; ddc7
	ds $4

; the pitch offset to apply to each note (see Music1_Pitches)
wMusicPitchOffset:: ; ddcb
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

; the frequency offset to apply to each note
wMusicFrequencyOffset:: ; ddea
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

wMusicStereoPanningBackup:: ; de57
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

wMusicCutoffBackup:: ; de88
	ds $4

wde8c:: ; de8c
	ds $4

wMusicEchoBackup:: ; de90
	ds $4

wMusicPitchOffsetBackup:: ; de94
	ds $4

wMusicSpeedBackup:: ; de98
	ds $4

wMusicVibratoType2Backup:: ; de9c
	ds $4

wMusicVibratoDelayBackup:: ; dea0
	ds $4

wMusicVolumeBackup:: ; dea4
	ds $3

wMusicFrequencyOffsetBackup:: ; dea7
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
