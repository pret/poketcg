SECTION "SRAM0", SRAM

s0a000:: ; a000
	ds $3

; what was the last option selected by the player
; for the printer contrast level (0 ~ 4)
sPrinterContrastLevel:: ; a003
	ds $1
s0a004:: ; a004
	ds $1

; keeps track of the number of times Card Pop!
; was done successfully within this save file
sTotalCardPopsDone:: ; a005
	ds $1

sTextSpeed:: ; a006
	ds $1

; store settings for animation enabled/disabled
; 0 means enabled, 1 means disabled
sAnimationsDisabled:: ; a007
	ds $1

s0a008:: ; a008
	ds $1
sSkipDelayAllowed:: ; a009
	ds $1
sReceivedLegendaryCards:: ; a00a
	ds $1
sUnusedSaveDataValidationByte:: ; a00b
	ds $1
s0a00c:: ; a00c
	ds $4

sPlayerName:: ; a010
	ds NAME_BUFFER_LENGTH

	ds $e0

sCardAndDeckSaveData::

; for each card, how many (0-127) the player owns
; CARD_NOT_OWNED ($80) indicates that the player has not yet seen the card
sCardCollection:: ; a100
	ds $100

sBuiltDecks::
sDeck1:: deck_struct sDeck1 ; a200
sDeck2:: deck_struct sDeck2 ; a254
sDeck3:: deck_struct sDeck3 ; a2a8
sDeck4:: deck_struct sDeck4 ; a2fc

sSavedDecks::
sSavedDeck1::  deck_struct sSavedDeck1  ; a350
sSavedDeck2::  deck_struct sSavedDeck2  ; a3a4
sSavedDeck3::  deck_struct sSavedDeck3  ; a3f8
sSavedDeck4::  deck_struct sSavedDeck4  ; a44c
sSavedDeck5::  deck_struct sSavedDeck5  ; a4a0
sSavedDeck6::  deck_struct sSavedDeck6  ; a4f4
sSavedDeck7::  deck_struct sSavedDeck7  ; a548
sSavedDeck8::  deck_struct sSavedDeck8  ; a59c
sSavedDeck9::  deck_struct sSavedDeck9  ; a5f0
sSavedDeck10:: deck_struct sSavedDeck10 ; a644
sSavedDeck11:: deck_struct sSavedDeck11 ; a698
sSavedDeck12:: deck_struct sSavedDeck12 ; a6ec
sSavedDeck13:: deck_struct sSavedDeck13 ; a740
sSavedDeck14:: deck_struct sSavedDeck14 ; a794
sSavedDeck15:: deck_struct sSavedDeck15 ; a7e8
sSavedDeck16:: deck_struct sSavedDeck16 ; a83c
sSavedDeck17:: deck_struct sSavedDeck17 ; a890
sSavedDeck18:: deck_struct sSavedDeck18 ; a8e4
sSavedDeck19:: deck_struct sSavedDeck19 ; a938
sSavedDeck20:: deck_struct sSavedDeck20 ; a98c
sSavedDeck21:: deck_struct sSavedDeck21 ; a9e0
sSavedDeck22:: deck_struct sSavedDeck22 ; aa34
sSavedDeck23:: deck_struct sSavedDeck23 ; aa88
sSavedDeck24:: deck_struct sSavedDeck24 ; aadc
sSavedDeck25:: deck_struct sSavedDeck25 ; ab30
sSavedDeck26:: deck_struct sSavedDeck26 ; ab84
sSavedDeck27:: deck_struct sSavedDeck27 ; abd8
sSavedDeck28:: deck_struct sSavedDeck28 ; ac2c
sSavedDeck29:: deck_struct sSavedDeck29 ; ac80
sSavedDeck30:: deck_struct sSavedDeck30 ; acd4
sSavedDeck31:: deck_struct sSavedDeck31 ; ad28
sSavedDeck32:: deck_struct sSavedDeck32 ; ad7c
sSavedDeck33:: deck_struct sSavedDeck33 ; add0
sSavedDeck34:: deck_struct sSavedDeck34 ; ae24
sSavedDeck35:: deck_struct sSavedDeck35 ; ae78
sSavedDeck36:: deck_struct sSavedDeck36 ; aecc
sSavedDeck37:: deck_struct sSavedDeck37 ; af20
sSavedDeck38:: deck_struct sSavedDeck38 ; af74
sSavedDeck39:: deck_struct sSavedDeck39 ; afc8
sSavedDeck40:: deck_struct sSavedDeck40 ; b01c
sSavedDeck41:: deck_struct sSavedDeck41 ; b070
sSavedDeck42:: deck_struct sSavedDeck42 ; b0c4
sSavedDeck43:: deck_struct sSavedDeck43 ; b118
sSavedDeck44:: deck_struct sSavedDeck44 ; b16c
sSavedDeck45:: deck_struct sSavedDeck45 ; b1c0
sSavedDeck46:: deck_struct sSavedDeck46 ; b214
sSavedDeck47:: deck_struct sSavedDeck47 ; b268
sSavedDeck48:: deck_struct sSavedDeck48 ; b2bc
sSavedDeck49:: deck_struct sSavedDeck49 ; b310
sSavedDeck50:: deck_struct sSavedDeck50 ; b364
sSavedDeck51:: deck_struct sSavedDeck51 ; b3b8
sSavedDeck52:: deck_struct sSavedDeck52 ; b40c
sSavedDeck53:: deck_struct sSavedDeck53 ; b460
sSavedDeck54:: deck_struct sSavedDeck54 ; b4b4
sSavedDeck55:: deck_struct sSavedDeck55 ; b508
sSavedDeck56:: deck_struct sSavedDeck56 ; b55c
sSavedDeck57:: deck_struct sSavedDeck57 ; b5b0
sSavedDeck58:: deck_struct sSavedDeck58 ; b604
sSavedDeck59:: deck_struct sSavedDeck59 ; b658
sSavedDeck60:: deck_struct sSavedDeck60 ; b6ac

sCurrentlySelectedDeck:: ; b700
	ds $1

; keeps track of how many unnamed decks have been built
; this is the number that gets appended at the end of
; an unnamed deck (i.e. DECK XXX)
; max number is MAX_UNNAMED_DECK_NUM
sUnnamedDeckCounter:: ; b701
	ds $2

; whether player has had Promotional cards
; to decide whether to show the option
; in the Card Album PC menu
sHasPromotionalCards:: ; b703
	ds $1

; these are initialized to 1 when
; creating a new game but are never used
sb704:: ; b704
	ds $3
sCardAndDeckSaveDataEnd::

	ds $f9

sGeneralSaveData::
sb800:: ; b800
	ds $2

sGeneralSaveDataByteCount:: ; b802
	ds $2

sGeneralSaveDataCheckSum:: ; b804
	ds $2

	ds $2
sGeneralSaveDataHeaderEnd::

sMedalCount:: ; b808
	ds $1

sCurOverworldMap:: ; b809
	ds $1

sPlayTimeCounter:: ; b80a
	ds $5

sOverworldMapSelection:: ; b80f
	ds $1

sTempMap:: ; b810
	ds $1

sTempPlayerXCoord:: ; b811
	ds $1

sTempPlayerYCoord:: ; b812
	ds $1

sTempPlayerDirection:: ; b813
	ds $1

sActiveGameEvent:: ; b814
	ds $1

sDuelResult:: ; b815
	ds $1

sNPCDuelist:: ; b816
	ds $1

sChallengeHallNPC:: ; b817
	ds $1

sb818:: ; b818
	ds $4

sOWMapEvents:: ; b81c
	ds NUM_MAP_EVENTS

sb827:: ; b827
	ds $1

sSelectedPauseMenuItem:: ; b828
	ds $1

sSelectedPCMenuItem:: ; b829
	ds $1

sConfigCursorYPos:: ; b82a
	ds $1

sSelectedGiftCenterMenuItem:: ; b82b
	ds $1

sPCPackSelection:: ; b82c
	ds $1

sPCPacks:: ; b82d
	ds NUM_PC_PACKS

sDefaultSong:: ; b83c
	ds $1

sDebugPauseAllowed:: ; b83d
	ds $1

sRonaldIsInMap:: ; b83e
	ds $1

sMastersBeatenList:: ; b83f
	ds $a

sNPCDuelistDirection:: ; b849
	ds $1

sMultichoiceTextboxResult_ChooseDeckToDuelAgainst:: ; b84a
	ds $1

sGiftCenterChoice:: ; b84b
	ds $1

sb84c:: ; b84c
	ds $f

sb85b:: ; b85b
	ds $10

sb86b:: ; b86b
	ds $10

sEventVars:: ; b87b
	ds $40

	ds $45
sGeneralSaveDataEnd::

	ds $141

; 0: normal duel
; 1: skip
; unused?
sDebugDuelMode:: ; ba41
	ds $1

sChallengeMachineMagic:: ; ba42
	ds $2

sChallengeMachineStart:: ; ba44

sPlayerInChallengeMachine:: ; ba44
	ds $1

sTotalChallengeMachineWins:: ; ba45
	ds $2

sPresentConsecutiveWins:: ; ba47
	ds $2

sPresentConsecutiveWinsBackup:: ; ba49
	ds $2

sChallengeMachineOpponents:: ; ba4b
	ds NUM_CHALLENGE_MACHINE_OPPONENTS

; 0: not dueled
; 1: won
; 2: lost
sChallengeMachineDuelResults:: ; ba50
	ds NUM_CHALLENGE_MACHINE_OPPONENTS

; the current opponent number, 0-4
sChallengeMachineOpponentNumber:: ; ba55
	ds $1

sMaximumConsecutiveWins:: ; ba56
	ds $2

sChallengeMachineRecordHolderName:: ; ba58
	ds NAME_BUFFER_LENGTH

; TRUE if just set new consecutive win record
sConsecutiveWinRecordIncreased:: ; ba68
	ds $1

sChallengeMachineEnd:: ; ba69

	ds $97

; keeps track of last 16 player's names that
; this save file has done Card Pop! with
sCardPopNameList:: ; bb00
	ds CARDPOP_NAME_LIST_SIZE

SECTION "SRAM1", SRAM

UNION

; buffers used to temporary store gfx related data
; such as tiles or BG maps
sGfxBuffer0:: ; a000
	ds $400

sGfxBuffer1:: ; a400
	ds $400

sGfxBuffer2:: ; a800
	ds $400

sGfxBuffer3:: ; ac00
	ds $400

sGfxBuffer4:: ; b000
	ds $400

sGfxBuffer5:: ; b400
	ds $400

NEXTU

	ds $350

; buffer used to store the deck configuration
; from the Auto Deck Machines
; intentionally uses the same address as sSavedDecks
; since TryBuildDeckMachineDeck uses the same
; address in SRAM whether it's an auto deck or a saved deck
; the difference is whether SRAM0 or SRAM1 are loaded
sAutoDecks::
sAutoDeck1::  deck_struct sAutoDeck1  ; a350
sAutoDeck2::  deck_struct sAutoDeck2  ; a3a4
sAutoDeck3::  deck_struct sAutoDeck3  ; a3f8
sAutoDeck4::  deck_struct sAutoDeck4  ; a44c
sAutoDeck5::  deck_struct sAutoDeck5  ; a4a0

ENDU

SECTION "SRAM2", SRAM

	ds $1800

sBackupGeneralSaveData:: ; b800
	ds $bb

	ds $43

; byte 1 = total number of cards collected
; byte 2 = total number of cards to collect
;  (doesn't count Phantom cards unless they
;   have been collected already)
sAlbumProgress:: ; b8fe
	ds $2

	ds $300

; saved data of the current duel, including a two-byte checksum
; see SaveDuelDataToDE
sCurrentDuel:: ; bc00
	ds $1
sCurrentDuelChecksum:: ; bc01
	ds $2
sCurrentDuelData:: ; bc04
	ds $33b

SECTION "SRAM3", SRAM
