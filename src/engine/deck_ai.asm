; AI card retreat score bonus
; when the AI retreat routine runs through the Bench to choose
; a Pokemon to switch to, it looks up in this list and if
; a card ID matches, applies a retreat score bonus to this card.
; positive (negative) means more (less) likely to switch to this card.
airetreat: MACRO
	db \1       ; card ID
	db $80 + \2 ; retreat score (ranges between -128 and 127)
ENDM

; AI card energy attach score bonus
; when the AI energy attachment run through the Play Area to choose
; a Pokemon to attach an energy card, it looks up in this list and if
; a card ID matches, skips this card if the maximum number of energy
; cards attached has been reached. If it hasn't been reached, additionally
; applies a positive (or negative) AI score to attach energy to this card. 
aienergy: MACRO
	db \1       ; card ID
	db \2       ; maximum number of attached cards
	db $80 + \3 ; energy score (ranges between -128 and 127)
ENDM

PointerTable_148dc: ; 148dc (5:48dc)
	dw Func_148e8
	dw Func_148e8
	dw Func_148ec
	dw Func_148f3
	dw Func_148f7
	dw Func_148fb

Func_148e8: ; 148e8 (5:48e8)
	INCROM $148e8, $148ec

Func_148ec: ; 148ec (5:48ec)
	call InitAIDuelVars
	call AIPlayInitialBasicCards
	ret
; 0x148f3

Func_148f3: ; 148f3 (5:48f3)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x148f7

Func_148f7: ; 148f7 (5:48f7)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x148fb

Func_148fb: ; 148fb (5:48fb)
	call _AIPickPrizeCards
	ret
; 0x148ff

Func_148ff: ; 148ff (5:48ff)
	INCROM $148ff, $149e8

PointerTable_149e8: ; 149e8 (05:49e8)
	dw Func_149f4
	dw Func_149f4
	dw Func_149f8
	dw Func_14a09
	dw Func_14a0d
	dw Func_14a11

Func_149f4: ; 149f4 (5:49f4)
	call Func_14a81
	ret
; 0x149f8

Func_149f8: ; 149f8 (5:49f8)
	call InitAIDuelVars
	call Func_14a4a
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc ; Play Area set up was successful
	call AIPlayInitialBasicCards
	ret
; 0x14a09

Func_14a09: ; 14a09 (5:4a09)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14a0d

Func_14a0d: ; 14a0d (5:4a0d)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14a11

Func_14a11: ; 14a11 (5:4a11)
	call _AIPickPrizeCards
	ret
; 0x14a15

Data_14a15: ; 14a15 (5:4a15)
	db MAGMAR2
	db GROWLITHE
	db VULPIX
	db MAGMAR1
	db MOLTRES1
	db MOLTRES2
	db $00

Data_14a1c: ; 14a1c (5:4a1c)
	db MOLTRES1
	db VULPIX
	db GROWLITHE
	db MAGMAR2
	db MAGMAR1
	db $00

Data_14a22: ; 14a22 (5:4a22)
	db MOLTRES2
	db MOLTRES1
	db VULPIX
	db GROWLITHE
	db MAGMAR2
	db MAGMAR1
	db $00

Data_14a29: ; 14a29 (5:4a29)
	airetreat GROWLITHE, -5
	airetreat VULPIX,    -5
	db $00

Data_14a2e: ; 14a2e (5:4a2e)
	aienergy VULPIX,     3, +0
	aienergy NINETAILS2, 3, +1
	aienergy GROWLITHE,  3, +1
	aienergy ARCANINE2,  4, +1
	aienergy MAGMAR1,    4, -1
	aienergy MAGMAR2,    1, -1
	aienergy MOLTRES2,   3, +2
	aienergy MOLTRES1,   4, +2
	db $00

Data_14a47: ; 14a47 (5:4a47)
	db ENERGY_REMOVAL
	db MOLTRES2
	db $00

Func_14a4a: ; 14a4a (5:4a4a)
	ld hl, wcda8
	ld de, Data_14a47
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_14a15
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_14a1c
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_14a22
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdb0
	ld de, Data_14a29
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdb2
	ld de, Data_14a2e
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x14a81

Func_14a81: ; 14a81 (5:4a81)
	call InitAITurnVars
	farcall Func_227d3
	jp nc, .try_attack

	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_04
	call AIProcessHandTrainerCards

; check if AI can play Moltres2 from hand
; if so, play it.
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .skip_moltres ; skip if bench is full
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE - 9
	jr nc, .skip_moltres ; skip if cards in deck <= 9
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .skip_moltres ; skip if Muk in play
	ld a, MOLTRES2
	call LookForCardIDInHandList_Bank5
	jr nc, .skip_moltres ; skip if no Moltres2 in hand
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_PLAY_BASIC_PKMN
	bank1call AIMakeDecision

.skip_moltres
	call AIDecidePlayPokemonCard
	ret c
	ld a, AI_TRAINER_CARD_PHASE_05
	call AIProcessHandTrainerCards
	call Func_14786
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_11
	call AIProcessHandTrainerCards

; handle attaching energy from hand
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_attach_energy

; if Magmar2 is the Arena card and has no energy attached,
; try attaching an energy card to it from the hand.
; otherwise, run normal AI energy attach routine.
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, MAGMAR2
	cp e
	jr nz, .attach_normally
	; Magmar2 is the Arena card
	call CreateEnergyCardListFromHand
	jr c, .skip_attach_energy
	ld e, PLAY_AREA_ARENA
	call CountNumberOfEnergyCardsAttached
	or a
	jr nz, .attach_normally
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call AITryToPlayEnergyCard
	jr c, .skip_attach_energy

.attach_normally
	call AIProcessAndTryToPlayEnergy

.skip_attach_energy
; try playing Pokemon cards from hand again
	call AIDecidePlayPokemonCard
	ld a, AI_TRAINER_CARD_PHASE_13
	call AIProcessHandTrainerCards

.try_attack
	call AIProcessAndTryToUseAttack
	ret c
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret
; 0x14b0f

PointerTable_14b0f: ; 14b0f (05:4b0f)
	dw Func_14b1b
	dw Func_14b1b
	dw Func_14b1f
	dw Func_14b30
	dw Func_14b34
	dw Func_14b38

Func_14b1b: ; 14b1b (5:4b1b)
	INCROM $14b1b, $14b1f

Func_14b1f: ; 14b1f (5:4b1f)
	call InitAIDuelVars
	call Func_14b6c
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14b30

Func_14b30: ; 14b30 (5:4b30)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14b34

Func_14b34: ; 14b34 (5:4b34)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14b38

Func_14b38: ; 14b38 (5:4b38)
	call _AIPickPrizeCards
	ret
; 0x14b3c

Data_14b3c: ; 14b3c (5:4b3c)
	db ELECTABUZZ2
	db VOLTORB
	db EEVEE
	db ZAPDOS1
	db ZAPDOS2
	db ZAPDOS3
	db $00

Data_14b43:  ; 14b43 (5:4b43)
	db ZAPDOS2
	db ZAPDOS1
	db EEVEE
	db VOLTORB
	db ELECTABUZZ2
	db $00

Data_14b49:  ; 14b49 (5:4b49)
	airetreat EEVEE,       -5
	airetreat VOLTORB,     -5
	airetreat ELECTABUZZ2, -5
	db $00

Data_14b50:  ; 14b50 (5:4b50)
	aienergy VOLTORB,     1, -1
	aienergy ELECTRODE1,  3, +0
	aienergy ELECTABUZZ2, 2, -1
	aienergy JOLTEON2,    3, +1
	aienergy ZAPDOS1,     4, +2
	aienergy ZAPDOS2,     4, +2
	aienergy ZAPDOS3,     3, +1
	aienergy EEVEE,       3, +0
	db $00

Data_14b69:  ; 14b69 (5:4b69)
	db GAMBLER
	db ZAPDOS3
	db $00

Func_14b6c: ; 14b6c (5:4b6c)
	ld hl, wcda8
	ld de, Data_14b69
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_14b3c
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_14b43
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_14b43
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_14b50
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x14b9a

Func_14b9a: ; 14b9a (5:4b9a)
	INCROM $14b9a, $14c0b

PointerTable_14c0b: ; 14c0b (5:4c0b)
	dw Func_14c17
	dw Func_14c17
	dw Func_14c1b
	dw Func_14c2c
	dw Func_14c30
	dw Func_14c34

Func_14c17: ; 14c17 (5:4c17)
	INCROM $14c17, $14c1b

Func_14c1b: ; 14c1b (5:4c1b)
	call InitAIDuelVars
	call Func_14c63
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14c2c

Func_14c2c: ; 14c2c (5:4c2c)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14c30

Func_14c30: ; 14c30 (5:4c30)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14c34

Func_14c34: ; 14c34 (5:4c34)
	call _AIPickPrizeCards
	ret
; 0x14c38

Data_14c38: ; 14c38 (5:4c38)
	db CHANSEY
	db LAPRAS
	db DITTO
	db SEEL
	db ARTICUNO1
	db ARTICUNO2
	db $00

Data_14c3f: ; 14c3f (5:4c3f)
	db ARTICUNO1
	db SEEL
	db LAPRAS
	db CHANSEY
	db DITTO
	db $00

Data_14c45: ; 14c45 (5:4c45)
	airetreat SEEL,  -3
	airetreat DITTO, -3
	db $00

Data_14c4a: ; 14c4a (5:4c4a)
	aienergy SEEL,      3, +1
	aienergy DEWGONG,   4, +0
	aienergy LAPRAS,    3, +0
	aienergy ARTICUNO1, 4, +1
	aienergy ARTICUNO2, 3, +0
	aienergy CHANSEY,   0, -8
	aienergy DITTO,     3, +0
	db $00

Data_14c60: ; 14c60 (5:4c60)
	db GAMBLER
	db ARTICUNO2
	db $00

Func_14c63: ; 14c63 (5:4c63)
	ld hl, wcda8
	ld de, Data_14c60
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_14c38
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_14c3f
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_14c3f
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_14c4a
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x14c91

; this routine handles how Legendary Articuno
; prioritises playing energy cards to each Pokémon.
; first, it makes sure that all Lapras have at least
; 3 energy cards before moving on to Articuno,
; and then to Dewgong and Seel
ScoreLegendaryArticunoCards: ; 14c91 (5:4c91)
	call SwapTurn
	call CountPrizes
	call SwapTurn
	cp 3
	ret c

; player prizes >= 3
; if Lapras has more than half HP and
; can use second move, check next for Articuno
; otherwise, check if Articuno or Dewgong
; have more than half HP and can use second move
; and if so, the next Pokémon to check is Lapras
	ld a, LAPRAS
	call CheckForBenchIDAtHalfHPAndCanUseSecondMove
	jr c, .articuno
	ld a, ARTICUNO1
	call CheckForBenchIDAtHalfHPAndCanUseSecondMove
	jr c, .lapras
	ld a, DEWGONG
	call CheckForBenchIDAtHalfHPAndCanUseSecondMove
	jr c, .lapras
	jr .articuno

; the following routines check for certain card IDs in bench
; and call RaiseAIScoreToAllMatchingIDsInBench if these are found.
; for Lapras, an additional check is made to its
; attached energy count, which skips calling the routine
; if this count is >= 3
.lapras
	ld a, LAPRAS
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInPlayArea_Bank5
	jr nc, .articuno
	ld e, a
	call CountNumberOfEnergyCardsAttached
	cp 3
	jr nc, .articuno
	ld a, LAPRAS
	call RaiseAIScoreToAllMatchingIDsInBench
	ret

.articuno
	ld a, ARTICUNO1
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInPlayArea_Bank5
	jr nc, .dewgong
	ld a, ARTICUNO1
	call RaiseAIScoreToAllMatchingIDsInBench
	ret

.dewgong
	ld a, DEWGONG
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInPlayArea_Bank5
	jr nc, .seel
	ld a, DEWGONG
	call RaiseAIScoreToAllMatchingIDsInBench
	ret

.seel
	ld a, SEEL
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInPlayArea_Bank5
	ret nc
	ld a, SEEL
	call RaiseAIScoreToAllMatchingIDsInBench
	ret
; 0x14cf7

Func_14cf7: ; 14cf7 (5:4cf7)
	INCROM $14cf7, $14d60

PointerTable_14d60: ; 14d60 (05:4d60)
	dw Func_14d6c
	dw Func_14d6c
	dw Func_14d70
	dw Func_14d81
	dw Func_14d85
	dw Func_14d89

Func_14d6c: ; 14d6c (5:4d6c)
	INCROM $14d6c, $14d70

Func_14d70: ; 14d70 (5:4d70)
	call InitAIDuelVars
	call Func_14dc1
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14d81

Func_14d81: ; 14d81 (5:4d81)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14d85

Func_14d85: ; 14d85 (5:4d85)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14d89

Func_14d89: ; 14d89 (5:4d89)
	call _AIPickPrizeCards
	ret
; 0x14d8d

Data_14d8d: ; 14d8d (5:4d8d)
	db KANGASKHAN
	db LAPRAS
	db CHARMANDER
	db DRATINI
	db MAGIKARP
	db $00

Data_14d93: ; 14d93 (5:4d93)
	db CHARMANDER
	db MAGIKARP
	db DRATINI
	db LAPRAS
	db KANGASKHAN
	db $00

Data_14d99: ; 14d99 (5:4d99)
	airetreat CHARMANDER, -1
	airetreat MAGIKARP,   -5
	db $00

Data_14d9e: ; 14d9e (5:4d9e)
	aienergy CHARMANDER, 3, +1
	aienergy CHARMELEON, 4, +1
	aienergy CHARIZARD,  5, +0
	aienergy MAGIKARP,   3, +1
	aienergy GYARADOS,   4, -1
	aienergy DRATINI,    2, +0
	aienergy DRAGONAIR,  4, +0
	aienergy DRAGONITE1, 3, -1
	aienergy KANGASKHAN, 2, -2
	aienergy LAPRAS,     3, +0
	db $00

Data_14dbd: ; 14dbd (5:4dbd)
	db GAMBLER
	db DRAGONITE1
	db KANGASKHAN
	db $00

Func_14dc1: ; 14dc1 (5:4dc1)
	ld hl, wcda8
	ld de, Data_14dbd
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_14d8d
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_14d93
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_14d93
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_14d9e
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x14def

Func_14def: ; 14def (5:4def)
	INCROM $14def, $14e89

PointerTable_14e89: ; 14e89 (5:4e89)
	dw Func_14e95
	dw Func_14e95
	dw Func_14e99
	dw Func_14eaa
	dw Func_14eae
	dw Func_14eb2

Func_14e95: ; 14e95 (5:4e95)
	INCROM $14e95, $14e99

Func_14e99: ; 14e99 (5:4e99)
	call InitAIDuelVars
	call Func_14ee0
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14eaa

Func_14eaa: ; 14eaa (5:4eaa)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14eae

Func_14eae: ; 14eae (5:4eae)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14eb2

Func_14eb2: ; 14eb2 (5:4eb2)
	call _AIPickPrizeCards
	ret
; 0x14eb6

Data_14eb6: ; 14eb6 (5:1eb6)
	db HITMONCHAN
	db MACHOP
	db HITMONLEE
	db MANKEY
	db $00

Data_14ebb: ; 14ebb (5:1ebb)
	db MACHOP
	db HITMONLEE
	db HITMONCHAN
	db MANKEY
	db $00

Data_14ec0: ; 14ec0 (5:1ec0)
	airetreat MACHOP,  - 1
	airetreat MACHOKE, - 1
	airetreat MANKEY,  - 2
	db $00

Data_14ec7: ; 14ec7 (5:1ec7)
	aienergy MACHOP,     3, +0
	aienergy MACHOKE,    4, +0
	aienergy MACHAMP,    4, -1
	aienergy HITMONCHAN, 3, +0
	aienergy HITMONLEE,  3, +0
	aienergy MANKEY,     2, -1
	aienergy PRIMEAPE,   3, -1
	db $00

Data_14edd: ; 14edd (5:1edd)
	db HITMONLEE
	db HITMONCHAN
	db $00

Func_14ee0: ; 14ee0 (5:4ee0)
	ld hl, wcda8
	ld de, Data_14edd
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_14eb6
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_14ebb
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_14ebb
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_14ec7
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x14f0e

PointerTable_14f0e: ; 14f0e (5:4f0e)
	dw Func_14f1a
	dw Func_14f1a
	dw Func_14f1e
	dw Func_14f2f
	dw Func_14f33
	dw Func_14f37

Func_14f1a: ; 14f1a (5:4f1a)
	INCROM $14f1a, $14f1e

Func_14f1e: ; 14f1e (5:4f1e)
	call InitAIDuelVars
	call Func_14f61
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14f2f

Func_14f2f: ; 14f2f (5:4f2f)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14f33

Func_14f33: ; 14f33 (5:4f33)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14f37

Func_14f37: ; 14f37 (5:4f37)
	call _AIPickPrizeCards
	ret
; 0x14f3b

Data_14f3b: ; 14f3b (5:4f3b)
	db RHYHORN
	db ONIX
	db GEODUDE
	db DIGLETT
	db $00

Data_14f40: ; 14f40 (5:4f40)
	db DIGLETT
	db GEODUDE
	db RHYHORN
	db ONIX
	db $00

Data_14f45: ; 14f45 (5:4f45)
	airetreat DIGLETT, -1
	db $00

Data_14f48: ; 14f48 (5:4f48)
	aienergy DIGLETT,  3, +1
	aienergy DUGTRIO,  4, +0
	aienergy GEODUDE,  2, +1
	aienergy GRAVELER, 3, +0
	aienergy GOLEM,    4, +0
	aienergy ONIX,     2, -1
	aienergy RHYHORN,  3, +0
	db $00

Data_14f5e: ; 14f5e (5:4f5e)
	db ENERGY_REMOVAL
	db RHYHORN
	db $00

Func_14f61: ; 14f61 (5:4f61)
	ld hl, wcda8
	ld de, Data_14f5e
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_14f3b
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_14f40
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_14f40
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_14f48
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x14f8f

PointerTable_14f8f: ; 14f8f (5:4f8f)
	dw Func_14f9b
	dw Func_14f9b
	dw Func_14f9f
	dw Func_14fb0
	dw Func_14fb4
	dw Func_14fb8

Func_14f9b: ; 14f9b (5:4f9b)
	INCROM $14f9b, $14f9f

Func_14f9f: ; 14f9f (5:4f9f)
	call InitAIDuelVars
	call Func_14feb
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14fb0

Func_14fb0: ; 14fb0 (5:4fb0)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14fb4

Func_14fb4: ; 14fb4 (5:4fb4)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14fb8

Func_14fb8: ; 14fb8 (5:4fb8)
	call _AIPickPrizeCards
	ret
; 0x14fbc

Data_14fbc: ; 14fbc (5:4fbc)
	db LAPRAS
	db HORSEA
	db GOLDEEN
	db SQUIRTLE
	db $00

Data_14fc1: ; 14fc1 (5:4fc1)
	db SQUIRTLE
	db HORSEA
	db GOLDEEN
	db LAPRAS
	db $00

Data_14fc6: ; 14fc6 (5:4fc6)
	airetreat SQUIRTLE,  -3
	airetreat WARTORTLE, -2
	airetreat HORSEA,    -1
	db $00

Data_14fcd: ; 14fcd (5:4fcd)
	aienergy SQUIRTLE,  2, +0
	aienergy WARTORTLE, 3, +0
	aienergy BLASTOISE, 5, +0
	aienergy GOLDEEN,   1, +0
	aienergy SEAKING,   2, +0
	aienergy HORSEA,    2, +0
	aienergy SEADRA,    3, +0
	aienergy LAPRAS,    3, +0
	db $00

Data_14fe6: ; 14fe6 (5:4fe6)
	db GAMBLER
	db ENERGY_RETRIEVAL
	db SUPER_ENERGY_RETRIEVAL
	db BLASTOISE
	db $00

Func_14feb: ; 14feb (5:4feb)
	ld hl, wcda8
	ld de, Data_14fe6
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_14fbc
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_14fc1
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_14fc1
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_14fcd
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x15019

PointerTable_15019: ; 15019 (5:5019)
	dw Func_15025
	dw Func_15025
	dw Func_15029
	dw Func_1503a
	dw Func_1503e
	dw Func_15042

Func_15025: ; 15025 (5:5025)
	INCROM $15025, $15029

Func_15029: ; 15029 (5:5029)
	call InitAIDuelVars
	call Func_1506d
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x1503a

Func_1503a: ; 1503a (5:503a)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x1503e

Func_1503e: ; 1503e (5:503e)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15042

Func_15042: ; 15042 (5:5042)
	call _AIPickPrizeCards
	ret
; 0x15046

Data_15046: ; 15046 (5:5046)
	db KANGASKHAN
	db ELECTABUZZ2
	db TAUROS
	db MAGNEMITE1
	db VOLTORB
	db $00

Data_1504c: ; 1504c (5:504c)
	db MAGNEMITE1
	db VOLTORB
	db ELECTABUZZ2
	db TAUROS
	db KANGASKHAN
	db $00

Data_15052: ; 15052 (5:5052)
	airetreat VOLTORB, -1
	db $00

Data_15055: ; 15055 (5:5055)
	aienergy MAGNEMITE1,  3, +1
	aienergy MAGNETON1,   4, +0
	aienergy VOLTORB,     3, +1
	aienergy ELECTRODE1,  3, +0
	aienergy ELECTABUZZ2, 1, +0
	aienergy KANGASKHAN,  2, -2
	aienergy TAUROS,      3, +0
	db $00

Data_1506b: ; 1506b (5:506b)
	db KANGASKHAN
	db $00

Func_1506d: ; 1506d (5:506d)
	ld hl, wcda8
	ld de, Data_1506b
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_15046
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_1504c
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_1504c
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_15055
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x1509b

PointerTable_1509b: ; 1509b (5:509b)
	dw Func_150a7
	dw Func_150a7
	dw Func_150ab
	dw Func_150bc
	dw Func_150c0
	dw Func_150c4

Func_150a7: ; 150a7 (5:50a7)
	INCROM $150a7, $150ab

Func_150ab: ; 150ab (5:50ab)
	call InitAIDuelVars
	call Func_150f4
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x150bc

Func_150bc: ; 150bc (5:50bc)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x150c0

Func_150c0: ; 150c0 (5:50c0)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x150c4

Func_150c4: ; 150c4 (5:50c4)
	call _AIPickPrizeCards
	ret
; 0x150c8

Data_150c8 ; 150c8 (5:50c8)
	db ODDISH
	db EXEGGCUTE
	db BULBASAUR
	db $00

Data_150cc ; 150cc (5:50cc)
	db BULBASAUR
	db EXEGGCUTE
	db ODDISH
	db $00

Data_150cf ; 150cf (5:50cf)
	airetreat GLOOM,     -2
	airetreat VILEPLUME, -2
	airetreat BULBASAUR, -2
	airetreat IVYSAUR,   -2
	db $00

Data_150d9 ; 150d9 (5:50d9)
	aienergy BULBASAUR,  3, +0
	aienergy IVYSAUR,    4, +0
	aienergy VENUSAUR2,  4, +0
	aienergy ODDISH,     2, +0
	aienergy GLOOM,      3, -1
	aienergy VILEPLUME,  3, -1
	aienergy EXEGGCUTE,  3, +0
	aienergy EXEGGUTOR, 22, +0
	db $00

Data_150f2 ; 150f2 (5:50f2)
	db VENUSAUR2
	db $00

Func_150f4: ; 150f4 (5:50f4)
	ld hl, wcda8
	ld de, Data_150f2
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_150c8
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_150cc
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_150cc
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_150d9
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x15122

PointerTable_15122: ; 15122 (5:5122)
	dw Func_1512e
	dw Func_1512e
	dw Func_15132
	dw Func_15143
	dw Func_15147
	dw Func_1514b

Func_1512e: ; 1512e (5:512e)
	INCROM $1512e, $15132

Func_15132: ; 15132 (5:5132)
	call InitAIDuelVars
	call Func_1517f
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x15143

Func_15143: ; 15143 (5:5143)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15147

Func_15147: ; 15147 (5:5147)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x1514b

Func_1514b: ; 1514b (5:514b)
	call _AIPickPrizeCards
	ret
; 0x1514f

Data_1514f: ; 1514f (5:514f)
	db KANGASKHAN
	db CHANSEY
	db SNORLAX
	db MR_MIME
	db ABRA
	db $00

Data_15155: ; 15155 (5:5155)
	db ABRA
	db MR_MIME
	db KANGASKHAN
	db SNORLAX
	db CHANSEY
	db $00

Data_1515b: ; 1515b (5:515b)
	airetreat ABRA,       -3
	airetreat SNORLAX,    -3
	airetreat KANGASKHAN, -1
	airetreat CHANSEY,    -1
	db $00

Data_15164 ; 15164 (5:5164)
	aienergy ABRA,       3, +1
	aienergy KADABRA,    3, +0
	aienergy ALAKAZAM,   3, +0
	aienergy MR_MIME,    2, +0
	aienergy CHANSEY,    2, -2
	aienergy KANGASKHAN, 4, -2
	aienergy SNORLAX,    0, -8
	db $00

Data_1517a ; 1517a (5:517a)
	db GAMBLER
	db MR_MIME
	db ALAKAZAM
	db SWITCH
	db $00

Func_1517f: ; 1517f (5:517f)
	ld hl, wcda8
	ld de, Data_1517a
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_1514f
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_15155
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_15155
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_15164
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x151ad

PointerTable_151ad: ; 151ad (5:51ad)
	dw Func_151b9
	dw Func_151b9
	dw Func_151bd
	dw Func_151ce
	dw Func_151d2
	dw Func_151d6

Func_151b9: ; 151b9 (5:51b9)
	INCROM $151b9, $151bd

Func_151bd: ; 151bd (5:51bd)
	call InitAIDuelVars
	call Func_15204
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x151ce

Func_151ce: ; 151ce (5:51ce)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x151d2

Func_151d2: ; 151d2 (5:51d2)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x151d6

Func_151d6: ; 151d6 (5:51d6)
	call _AIPickPrizeCards
	ret
; 0x151da

Data_151da: ; 151da (5:51da)
	db MEWTWO1
	db MEWTWO3
	db MEWTWO2
	db GRIMER
	db KOFFING
	db PORYGON
	db $00

Data_151e1: ; 151e1 (5:51e1)
	db GRIMER
	db KOFFING
	db MEWTWO3
	db MEWTWO2
	db MEWTWO1
	db PORYGON
	db $00

Data_151e8: ; 151e8 (5:51e8)
	db $00

Data_151e9: ; 151e9 (5:51e9)
	aienergy GRIMER,  3, +0
	aienergy MUK,     4, +0
	aienergy KOFFING, 2, +0
	aienergy WEEZING, 3, +0
	aienergy MEWTWO1, 2, -1
	aienergy MEWTWO3, 2, -1
	aienergy MEWTWO2, 2, -1
	aienergy PORYGON, 2, -1
	db $00

Data_15202: ; 15202 (5:5202)
	db MUK
	db $00

Func_15204: ; 15204 (5:5204)
	ld hl, wcda8
	ld de, Data_15202
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_151da
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_151e1
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_151e1
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_151e9
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x15232

PointerTable_15232: ; 15232 (5:52PointerTable_12)
	dw Func_1523e
	dw Func_1523e
	dw Func_15242
	dw Func_15253
	dw Func_15257
	dw Func_1525b

Func_1523e: ; 1523e (5:523e)
	INCROM $1523e, $15242

Func_15242: ; 15242 (5:5242)
	call InitAIDuelVars
	call Func_1528f
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x15253

Func_15253: ; 15253 (5:5253)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15257

Func_15257: ; 15257 (5:5257)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x1525b

Func_1525b: ; 1525b (5:525b)
	call _AIPickPrizeCards
	ret
; 0x1525f

Data_1525f: ; 1525f (5:525f)
	db JIGGLYPUFF3
	db CHANSEY
	db TAUROS
	db MAGMAR1
	db JIGGLYPUFF1
	db GROWLITHE
	db $00

Data_15266: ; 15266 (5:5266)
	db JIGGLYPUFF3
	db CHANSEY
	db GROWLITHE
	db MAGMAR1
	db JIGGLYPUFF1
	db TAUROS
	db $00

Data_1526e: ; 1526e (5:526e)
	airetreat JIGGLYPUFF1, -1
	airetreat CHANSEY,     -1
	airetreat GROWLITHE,   -1
	db $00

Data_15274: ; 15274 (5:5274)
	aienergy GROWLITHE,   3, +0
	aienergy ARCANINE2,   4, +0
	aienergy MAGMAR1,     3, +0
	aienergy JIGGLYPUFF1, 3, +0
	aienergy JIGGLYPUFF3, 2, +0
	aienergy WIGGLYTUFF,  3, +0
	aienergy CHANSEY,     4, +0
	aienergy TAUROS,      3, +0
	db $00

Data_1528d: ; 1528d (5:528d)
	db GAMBLER
	db $00

Func_1528f: ; 1528f (5:528f)
	ld hl, wcda8
	ld de, Data_1528d
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_1525f
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_15266
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_15266
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_15274
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x152bd

PointerTable_152bd: ; 152bd (5:52bd)
	dw Func_152c9
	dw Func_152c9
	dw Func_152cd
	dw Func_152de
	dw Func_152e2
	dw Func_152e6

Func_152c9: ; 152c9 (5:52c9)
	INCROM $152c9, $152cd

Func_152cd: ; 152cd (5:52cd)
	call InitAIDuelVars
	call Func_1531d
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x152de

Func_152de: ; 152de (5:52de)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x152e2

Func_152e2: ; 152e2 (5:52e2)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x152e6

Func_152e6: ; 152e6 (5:52e6)
	call _AIPickPrizeCards
	ret
; 0x152ea

Data_152ea: ; 152ea (5:52ea)
	db LAPRAS
	db SEEL
	db CHARMANDER
	db CUBONE
	db SQUIRTLE
	db GROWLITHE
	db $00

Data_152f1: ; 152f1 (5:52f1)
	db CHARMANDER
	db SQUIRTLE
	db SEEL
	db CUBONE
	db GROWLITHE
	db LAPRAS
	db $00

Data_152f8: ; 152f8 (5:52f8)
	db $00

Data_152f9: ; 152f9 (5:52f9)
	aienergy CHARMANDER, 3, +0
	aienergy CHARMELEON, 5, +0
	aienergy GROWLITHE,  2, +0
	aienergy ARCANINE2,  4, +0
	aienergy SQUIRTLE,   2, +0
	aienergy WARTORTLE,  3, +0
	aienergy SEEL,       3, +0
	aienergy DEWGONG,    4, +0
	aienergy LAPRAS,     3, +0
	aienergy CUBONE,     3, +0
	aienergy MAROWAK1,   3, +0
	db $00

Data_1531b: ; 1531b (5:531b)
	db LAPRAS
	db $00

Func_1531d: ; 1531d (5:531d)
	ld hl, wcda8
	ld de, Data_1531b
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_152ea
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_152f1
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_152f1
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_152f9
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x1534b

PointerTable_1534b: ; 1534b (5:534b)
	dw Func_15357
	dw Func_15357
	dw Func_1535b
	dw Func_1536c
	dw Func_15370
	dw Func_15374

Func_15357: ; 15357 (5:5357)
	INCROM $15357, $1535b

Func_1535b: ; 1535b (5:535b)
	call InitAIDuelVars
	call Func_153ba
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x1536c

Func_1536c: ; 1536c (5:536c)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15370

Func_15370: ; 15370 (5:5370)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15374

Func_15374: ; 15374 (5:5374)
	call _AIPickPrizeCards
	ret
; 0x15378

Data_15378: ; 15378 (5:5378)
	db KANGASKHAN
	db ELECTABUZZ2
	db HITMONCHAN
	db MR_MIME
	db LICKITUNG
	db HITMONLEE
	db TAUROS
	db JYNX
	db MEWTWO1
	db DODUO
	db $00

Data_15383: ; 15383 (5:5383)
	db KANGASKHAN
	db HITMONLEE
	db HITMONCHAN
	db TAUROS
	db DODUO
	db JYNX
	db MEWTWO1
	db ELECTABUZZ2
	db MR_MIME
	db LICKITUNG
	db $00

Data_1538e: ; 1538e (5:538e)
	airetreat KANGASKHAN, -1
	airetreat DODUO,      -1
	airetreat DODRIO,     -1
	db $00

Data_15395: ; 15395 (5:5395)
	aienergy ELECTABUZZ2, 2, +1
	aienergy HITMONLEE,   3, +1
	aienergy HITMONCHAN,  3, +1
	aienergy MR_MIME,     2, +0
	aienergy JYNX,        3, +0
	aienergy MEWTWO1,     2, +0
	aienergy DODUO,       3, -1
	aienergy DODRIO,      3, -1
	aienergy LICKITUNG,   2, +0
	aienergy KANGASKHAN,  4, -1
	aienergy TAUROS,      3, +0
	db $00

Data_153b7: ; 153b7 (5:53b7)
	db GAMBLER
	db ENERGY_REMOVAL
	db $00

Func_153ba: ; 153ba (5:53ba)
	ld hl, wcda8
	ld de, Data_153b7
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_15378
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_15383
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_15383
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_15395
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x153e8

PointerTable_153e8: ; 153e8 (5:53e8)
	dw Func_153f4
	dw Func_153f4
	dw Func_153f8
	dw Func_15409
	dw Func_1540d
	dw Func_15411

Func_153f4: ; 153f4 (5:53f4)
	INCROM $153f4, $153f8

Func_153f8: ; 153f8 (5:53f8)
	call InitAIDuelVars
	call Func_15441
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x15409

Func_15409: ; 15409 (5:5409)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x1540d

Func_1540d: ; 1540d (5:540d)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15411

Func_15411: ; 15411 (5:5411)
	call _AIPickPrizeCards
	ret
; 0x15415

Data_15415: ; 15415 (5:5415)
	db KANGASKHAN
	db MAGMAR2
	db CHANSEY
	db GEODUDE
	db SCYTHER
	db GRIMER
	db $00

Data_1541c: ; 1541c (5:541c)
	db GRIMER
	db SCYTHER
	db GEODUDE
	db CHANSEY
	db MAGMAR2
	db KANGASKHAN
	db $00

Data_15423: ; 15423 (5:5423)
	airetreat GRIMER, -1
	db $00

Data_15426: ; 15426 (5:5426)
	aienergy GRIMER,     1, -1
	aienergy MUK,        3, -1
	aienergy SCYTHER,    4, +1
	aienergy MAGMAR2,    2, +0
	aienergy GEODUDE,    2, +0
	aienergy GRAVELER,   3, +0
	aienergy CHANSEY,    4, +0
	aienergy KANGASKHAN, 4, -1
	db $00

Data_1543f: ; 1543f (5:543f)
	db GAMBLER
	db $00

Func_15441: ; 15441 (5:5441)
	ld hl, wcda8
	ld de, Data_1543f
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_15415
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_1541c
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_1541c
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_15426
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x1546f

PointerTable_1546f: ; 1546f (5:546f)
	dw Func_1547b
	dw Func_1547b
	dw Func_1547f
	dw Func_15490
	dw Func_15494
	dw Func_15498

Func_1547b: ; 1547b (5:547b)
	INCROM $1547b, $1547f

Func_1547f: ; 1547f (5:547f)
	call InitAIDuelVars
	call Func_154d9
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x15490

Func_15490: ; 15490 (5:5490)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15494

Func_15494: ; 15494 (5:5494)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15498

Func_15498: ; 15498 (5:5498)
	call _AIPickPrizeCards
	ret
; 0x1549c

Data_1549c: ; 1549c (5:549c)
	db KANGASKHAN
	db DRATINI
	db EEVEE
	db ZAPDOS3
	db ARTICUNO2
	db MOLTRES2
	db $00

Data_154a3: ; 154a3 (5:54a3)
	db KANGASKHAN
	db DRATINI
	db EEVEE
	db $00

Data_154a7: ; 154a7 (5:54a7)
	db MOLTRES2
	db ZAPDOS3
	db KANGASKHAN
	db DRATINI
	db EEVEE
	db ARTICUNO2
	db $00

Data_154ae: ; 154ae (5:54ae)
	airetreat EEVEE, -2
	db $00

Data_154b1: ; 154b1 (5:54b1)
	aienergy FLAREON1,   3, +0
	aienergy MOLTRES2,   3, +0
	aienergy VAPOREON1,  3, +0
	aienergy ARTICUNO2,  0, -8
	aienergy JOLTEON1,   4, +0
	aienergy ZAPDOS3,    0, -8
	aienergy KANGASKHAN, 4, -1
	aienergy EEVEE,      3, +0
	aienergy DRATINI,    3, +0
	aienergy DRAGONAIR,  4, +0
	aienergy DRAGONITE1, 3, +0
	db $00

Data_154d3: ; 154d3 (5:54d3)
	db MOLTRES2
	db ARTICUNO2
	db ZAPDOS3
	db DRAGONITE1
	db GAMBLER
	db $00

Func_154d9: ; 154d9 (5:54d9)
	ld hl, wcda8
	ld de, Data_154d3
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdaa
	ld de, Data_1549c
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdac
	ld de, Data_154a3
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wcdae
	ld de, Data_154a7
	ld [hl], e
	inc hl
	ld [hl], d

; missing wcdb0

	ld hl, wcdb2
	ld de, Data_154b1
	ld [hl], e
	inc hl
	ld [hl], d

	ret
; 0x15507
