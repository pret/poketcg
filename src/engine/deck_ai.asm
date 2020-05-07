; AI card retreat score bonus
; when the AI retreat routine runs through the Bench to choose
; a Pokemon to switch to, it looks up in this list and if
; a card ID matches, applies a retreat score bonus to this card.
; positive (negative) means more (less) likely to switch to this card.
ai_retreat: MACRO
	db \1       ; card ID
	db $80 + \2 ; retreat score (ranges between -128 and 127)
ENDM

; AI card energy attach score bonus
; when the AI energy attachment routine runs through the Play Area to choose
; a Pokemon to attach an energy card, it looks up in this list and if
; a card ID matches, skips this card if the maximum number of energy
; cards attached has been reached. If it hasn't been reached, additionally
; applies a positive (or negative) AI score to attach energy to this card. 
ai_energy: MACRO
	db \1       ; card ID
	db \2       ; maximum number of attached cards
	db $80 + \3 ; energy score (ranges between -128 and 127)
ENDM

; stores in WRAM pointer to data in argument
; e.g. store_list_pointer wSomeListPointer, SomeData
store_list_pointer: MACRO
	ld hl, \1
	ld de, \2
	ld [hl], e
	inc hl
	ld [hl], d
ENDM

AIActionTable_GeneralNoRetreat: ; 148dc (5:48dc)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 148e8 (5:48e8)
	call AIDoTurn_GeneralNoRetreat
	ret
; 0x148ec

.start_duel ; 148ec (5:48ec)
	call InitAIDuelVars
	call AIPlayInitialBasicCards
	ret
; 0x148f3

.forced_switch ; 148f3 (5:48f3)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x148f7

.ko_switch ; 148f7 (5:48f7)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x148fb

.take_prize ; 148fb (5:48fb)
	call AIPickPrizeCards
	ret
; 0x148ff

AIDoTurn_GeneralNoRetreat: ; 148ff (5:48ff)
; initialize variables
	call InitAITurnVars
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	farcall HandleAIAntiMewtwoDeckStrategy
	jp nc, .try_attack
; handle Pkmn Powers
	farcall HandleAIGoGoRainDanceEnergy
	farcall HandleAIDamageSwap
	farcall HandleAIPkmnPowers
	ret c ; return if turn ended
	farcall HandleAICowardice
; process Trainer cards
; phase 2 through 4.
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_03
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_04
	call AIProcessHandTrainerCards
; play Pokemon from hand
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
; process Trainer cards
; phase 5 through 12.
	ld a, AI_TRAINER_CARD_PHASE_05
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_06
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_07
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_08
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_11
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_12
	call AIProcessHandTrainerCards
; play Energy card if possible
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_energy_attach_1
	call AIProcessAndTryToPlayEnergy
.skip_energy_attach_1
; play Pokemon from hand again
	call AIDecidePlayPokemonCard
; handle Pkmn Powers again
	farcall HandleAIDamageSwap
	farcall HandleAIPkmnPowers
	ret c ; return if turn ended
	farcall HandleAIGoGoRainDanceEnergy
	ld a, AI_ENERGY_TRANS_ATTACK
	farcall HandleAIEnergyTrans
; process Trainer cards phases 13 and 15
	ld a, AI_TRAINER_CARD_PHASE_13
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_15
	call AIProcessHandTrainerCards
; if used Professor Oak, process new hand
; if not, then proceed to attack.
	ld a, [wPreviousAIFlags]
	and AI_FLAG_USED_PROFESSOR_OAK
	jr z, .try_attack
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_03
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_04
	call AIProcessHandTrainerCards
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	ld a, AI_TRAINER_CARD_PHASE_05
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_06
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_07
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_08
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_11
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_12
	call AIProcessHandTrainerCards
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_energy_attach_2
	call AIProcessAndTryToPlayEnergy
.skip_energy_attach_2
	call AIDecidePlayPokemonCard
	farcall HandleAIDamageSwap
	farcall HandleAIPkmnPowers
	ret c ; return if turn ended
	farcall HandleAIGoGoRainDanceEnergy
	ld a, AI_TRAINER_CARD_PHASE_13
	call AIProcessHandTrainerCards
	; skip AI_TRAINER_CARD_PHASE_15
.try_attack
; attack if possible, if not,
; finish turn without attacking.
	call AIProcessAndTryToUseAttack
	ret c ; return if turn ended
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret
; 0x149e8

AIActionTable_LegendaryMoltres: ; 149e8 (05:49e8)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 149f4 (5:49f4)
	call AIDoTurn_LegendaryMoltres
	ret
; 0x149f8

.start_duel ; 149f8 (5:49f8)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc ; Play Area set up was successful
	call AIPlayInitialBasicCards
	ret
; 0x14a09

.forced_switch ; 14a09 (5:4a09)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14a0d

.ko_switch ; 14a0d (5:4a0d)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14a11

.take_prize ; 14a11 (5:4a11)
	call AIPickPrizeCards
	ret
; 0x14a15

.list_arena ; 14a15 (5:4a15)
	db MAGMAR2
	db GROWLITHE
	db VULPIX
	db MAGMAR1
	db MOLTRES1
	db MOLTRES2
	db $00

.list_bench ; 14a1c (5:4a1c)
	db MOLTRES1
	db VULPIX
	db GROWLITHE
	db MAGMAR2
	db MAGMAR1
	db $00

.list_play_hand ; 14a22 (5:4a22)
	db MOLTRES2
	db MOLTRES1
	db VULPIX
	db GROWLITHE
	db MAGMAR2
	db MAGMAR1
	db $00

.list_retreat ; 14a29 (5:4a29)
	ai_retreat GROWLITHE, -5
	ai_retreat VULPIX,    -5
	db $00

.list_energy ; 14a2e (5:4a2e)
	ai_energy VULPIX,     3, +0
	ai_energy NINETAILS2, 3, +1
	ai_energy GROWLITHE,  3, +1
	ai_energy ARCANINE2,  4, +1
	ai_energy MAGMAR1,    4, -1
	ai_energy MAGMAR2,    1, -1
	ai_energy MOLTRES2,   3, +2
	ai_energy MOLTRES1,   4, +2
	db $00

.list_prize ; 14a47 (5:4a47)
	db ENERGY_REMOVAL
	db MOLTRES2
	db $00

.store_list_pointers ; 14a4a (5:4a4a)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_play_hand
	store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x14a81

AIDoTurn_LegendaryMoltres: ; 14a81 (5:4a81)
; initialize variables
	call InitAITurnVars
	farcall HandleAIAntiMewtwoDeckStrategy
	jp nc, .try_attack
; process Trainer cards
; phase 2 through 4.
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_04
	call AIProcessHandTrainerCards

; check if AI can play Moltres2
; from hand and if so, play it.
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
; play Pokemon from hand
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
; process Trainer cards
	ld a, AI_TRAINER_CARD_PHASE_05
	call AIProcessHandTrainerCards
	call AIProcessRetreat
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_11
	call AIProcessHandTrainerCards
; play Energy card if possible
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
; play Energy card if possible
	call AIProcessAndTryToPlayEnergy
.skip_attach_energy
; try playing Pokemon cards from hand again
	call AIDecidePlayPokemonCard
	ld a, AI_TRAINER_CARD_PHASE_13
	call AIProcessHandTrainerCards

.try_attack
; attack if possible, if not,
; finish turn without attacking.
	call AIProcessAndTryToUseAttack
	ret c
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret
; 0x14b0f

AIActionTable_LegendaryZapdos: ; 14b0f (05:4b0f)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14b1b (5:4b1b)
	call AIDoTurn_LegendaryZapdos
	ret
; 0x14b1f

.start_duel ; 14b1f (5:4b1f)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14b30

.forced_switch ; 14b30 (5:4b30)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14b34

.ko_switch ; 14b34 (5:4b34)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14b38

.take_prize ; 14b38 (5:4b38)
	call AIPickPrizeCards
	ret
; 0x14b3c

.list_arena ; 14b3c (5:4b3c)
	db ELECTABUZZ2
	db VOLTORB
	db EEVEE
	db ZAPDOS1
	db ZAPDOS2
	db ZAPDOS3
	db $00

.list_bench ; 14b43 (5:4b43)
	db ZAPDOS2
	db ZAPDOS1
	db EEVEE
	db VOLTORB
	db ELECTABUZZ2
	db $00

.list_retreat ; 14b49 (5:4b49)
	ai_retreat EEVEE,       -5
	ai_retreat VOLTORB,     -5
	ai_retreat ELECTABUZZ2, -5
	db $00

.list_energy ; 14b50 (5:4b50)
	ai_energy VOLTORB,     1, -1
	ai_energy ELECTRODE1,  3, +0
	ai_energy ELECTABUZZ2, 2, -1
	ai_energy JOLTEON2,    3, +1
	ai_energy ZAPDOS1,     4, +2
	ai_energy ZAPDOS2,     4, +2
	ai_energy ZAPDOS3,     3, +1
	ai_energy EEVEE,       3, +0
	db $00

.list_prize ; 14b69 (5:4b69)
	db GAMBLER
	db ZAPDOS3
	db $00

.store_list_pointers ; 14b6c (5:4b6c)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x14b9a

AIDoTurn_LegendaryZapdos: ; 14b9a (5:4b9a)
; initialize variables
	call InitAITurnVars
	farcall HandleAIAntiMewtwoDeckStrategy
	jp nc, .try_attack
; process Trainer cards
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_04
	call AIProcessHandTrainerCards
; play Pokemon from hand
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	ld a, AI_TRAINER_CARD_PHASE_07
	call AIProcessHandTrainerCards
	call AIProcessRetreat
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
; play Energy card if possible.
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_energy_attach

; if Arena card is Voltorb and there's Electrode1 in hand,
; or if it's Electabuzz, try attaching Energy card
; to the Arena card if it doesn't have any energy attached.
; Otherwise if Energy card is not needed,
; go through normal AI energy attach routine.
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, VOLTORB
	cp e
	jr nz, .check_electabuzz
	ld a, ELECTRODE1
	call LookForCardIDInHandList_Bank5
	jr nc, .attach_normally
	jr .voltorb_or_electabuzz
.check_electabuzz
	ld a, ELECTABUZZ2
	cp e
	jr nz, .attach_normally

.voltorb_or_electabuzz
	call CreateEnergyCardListFromHand
	jr c, .skip_energy_attach
	ld e, PLAY_AREA_ARENA
	call CountNumberOfEnergyCardsAttached
	or a
	jr nz, .attach_normally
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call AITryToPlayEnergyCard
	jr c, .skip_energy_attach

.attach_normally
	call AIProcessAndTryToPlayEnergy

.skip_energy_attach
; play Pokemon from hand again
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	ld a, AI_TRAINER_CARD_PHASE_13
	call AIProcessHandTrainerCards
.try_attack
; attack if possible, if not,
; finish turn without attacking.
	call AIProcessAndTryToUseAttack
	ret c ; return if turn ended
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret
; 0x14c0b

AIActionTable_LegendaryArticuno: ; 14c0b (5:4c0b)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14c17 (5:4c17)
	call AIDoTurn_LegendaryArticuno
	ret
; 0x14c1b

.start_duel ; 14c1b (5:4c1b)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14c2c

.forced_switch ; 14c2c (5:4c2c)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14c30

.ko_switch ; 14c30 (5:4c30)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14c34

.take_prize ; 14c34 (5:4c34)
	call AIPickPrizeCards
	ret
; 0x14c38

.list_arena ; 14c38 (5:4c38)
	db CHANSEY
	db LAPRAS
	db DITTO
	db SEEL
	db ARTICUNO1
	db ARTICUNO2
	db $00

.list_bench ; 14c3f (5:4c3f)
	db ARTICUNO1
	db SEEL
	db LAPRAS
	db CHANSEY
	db DITTO
	db $00

.list_retreat ; 14c45 (5:4c45)
	ai_retreat SEEL,  -3
	ai_retreat DITTO, -3
	db $00

.list_energy ; 14c4a (5:4c4a)
	ai_energy SEEL,      3, +1
	ai_energy DEWGONG,   4, +0
	ai_energy LAPRAS,    3, +0
	ai_energy ARTICUNO1, 4, +1
	ai_energy ARTICUNO2, 3, +0
	ai_energy CHANSEY,   0, -8
	ai_energy DITTO,     3, +0
	db $00

.list_prize ; 14c60 (5:4c60)
	db GAMBLER
	db ARTICUNO2
	db $00

.store_list_pointers ; 14c63 (5:4c63)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
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

AIDoTurn_LegendaryArticuno: ; 14cf7 (5:4cf7)
; initialize variables
	call InitAITurnVars
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	farcall HandleAIAntiMewtwoDeckStrategy
	jp nc, .try_attack
; process Trainer cards
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
; play Pokemon from hand
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	call AIProcessRetreat
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
; play Energy card if possible
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_energy_attach_1
	call AIProcessAndTryToPlayEnergy
.skip_energy_attach_1
; play Pokemon from hand again
	call AIDecidePlayPokemonCard
; process Trainer cards phases 13 and 15
	ld a, AI_TRAINER_CARD_PHASE_13
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_15
	call AIProcessHandTrainerCards
; if used Professor Oak, process new hand
	ld a, [wPreviousAIFlags]
	and AI_FLAG_USED_PROFESSOR_OAK
	jr z, .try_attack
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	call AIProcessRetreat
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_energy_attach_2
	call AIProcessAndTryToPlayEnergy
.skip_energy_attach_2
	call AIDecidePlayPokemonCard
.try_attack
; attack if possible, if not,
; finish turn without attacking.
	call AIProcessAndTryToUseAttack
	ret c ; return if turn ended
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret
; 0x14d60

AIActionTable_LegendaryDragonite: ; 14d60 (05:4d60)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14d6c (5:4d6c)
	call AIDoTurn_LegendaryDragonite
	ret
; 0x14d70

.start_duel ; 14d70 (5:4d70)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14d81

.forced_switch ; 14d81 (5:4d81)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14d85

.ko_switch ; 14d85 (5:4d85)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14d89

.take_prize ; 14d89 (5:4d89)
	call AIPickPrizeCards
	ret
; 0x14d8d

.list_arena ; 14d8d (5:4d8d)
	db KANGASKHAN
	db LAPRAS
	db CHARMANDER
	db DRATINI
	db MAGIKARP
	db $00

.list_bench ; 14d93 (5:4d93)
	db CHARMANDER
	db MAGIKARP
	db DRATINI
	db LAPRAS
	db KANGASKHAN
	db $00

.list_retreat ; 14d99 (5:4d99)
	ai_retreat CHARMANDER, -1
	ai_retreat MAGIKARP,   -5
	db $00

.list_energy ; 14d9e (5:4d9e)
	ai_energy CHARMANDER, 3, +1
	ai_energy CHARMELEON, 4, +1
	ai_energy CHARIZARD,  5, +0
	ai_energy MAGIKARP,   3, +1
	ai_energy GYARADOS,   4, -1
	ai_energy DRATINI,    2, +0
	ai_energy DRAGONAIR,  4, +0
	ai_energy DRAGONITE1, 3, -1
	ai_energy KANGASKHAN, 2, -2
	ai_energy LAPRAS,     3, +0
	db $00

.list_prize ; 14dbd (5:4dbd)
	db GAMBLER
	db DRAGONITE1
	db KANGASKHAN
	db $00

.store_list_pointers ; 14dc1 (5:4dc1)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x14def

AIDoTurn_LegendaryDragonite: ; 14def (5:4def)
; initialize variables
	call InitAITurnVars
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	farcall HandleAIAntiMewtwoDeckStrategy
	jp nc, .try_attack
; process Trainer cards
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
; play Pokemon from hand
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	ld a, AI_TRAINER_CARD_PHASE_07
	call AIProcessHandTrainerCards
	call AIProcessRetreat
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_11
	call AIProcessHandTrainerCards
; play Energy card if possible
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_energy_attach_1

; if Arena card is Kangaskhan and doens't
; have Energy cards attached, try attaching from hand.
; otherwise run normal AI energy attach routine.
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, KANGASKHAN
	cp e
	jr nz, .attach_normally
	call CreateEnergyCardListFromHand
	jr c, .skip_energy_attach_1
	ld e, PLAY_AREA_ARENA
	call CountNumberOfEnergyCardsAttached
	or a
	jr nz, .attach_normally
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call AITryToPlayEnergyCard
	jr c, .skip_energy_attach_1
.attach_normally
	call AIProcessAndTryToPlayEnergy

.skip_energy_attach_1
; play Pokemon from hand again
	call AIDecidePlayPokemonCard
	ld a, AI_TRAINER_CARD_PHASE_15
	call AIProcessHandTrainerCards
; if used Professor Oak, process new hand
; if not, then proceed to attack.
	ld a, [wPreviousAIFlags]
	and AI_FLAG_USED_PROFESSOR_OAK
	jr z, .try_attack
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	ld a, AI_TRAINER_CARD_PHASE_07
	call AIProcessHandTrainerCards
	call AIProcessRetreat
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_11
	call AIProcessHandTrainerCards
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_energy_attach_2
	call AIProcessAndTryToPlayEnergy
.skip_energy_attach_2
	call AIDecidePlayPokemonCard
.try_attack
; attack if possible, if not,
; finish turn without attacking.
	call AIProcessAndTryToUseAttack
	ret c ; return if turn ended
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret
; 0x14e89

AIActionTable_FirstStrike: ; 14e89 (5:4e89)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14e95 (5:4e95)
	call AIMainTurnLogic
	ret
; 0x14e99

.start_duel ; 14e99 (5:4e99)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14eaa

.forced_switch ; 14eaa (5:4eaa)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14eae

.ko_switch ; 14eae (5:4eae)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14eb2

.take_prize ; 14eb2 (5:4eb2)
	call AIPickPrizeCards
	ret
; 0x14eb6

.list_arena ; 14eb6 (5:1eb6)
	db HITMONCHAN
	db MACHOP
	db HITMONLEE
	db MANKEY
	db $00

.list_bench ; 14ebb (5:1ebb)
	db MACHOP
	db HITMONLEE
	db HITMONCHAN
	db MANKEY
	db $00

.list_retreat ; 14ec0 (5:1ec0)
	ai_retreat MACHOP,  - 1
	ai_retreat MACHOKE, - 1
	ai_retreat MANKEY,  - 2
	db $00

.list_energy ; 14ec7 (5:1ec7)
	ai_energy MACHOP,     3, +0
	ai_energy MACHOKE,    4, +0
	ai_energy MACHAMP,    4, -1
	ai_energy HITMONCHAN, 3, +0
	ai_energy HITMONLEE,  3, +0
	ai_energy MANKEY,     2, -1
	ai_energy PRIMEAPE,   3, -1
	db $00

.list_prize ; 14edd (5:1edd)
	db HITMONLEE
	db HITMONCHAN
	db $00

.store_list_pointers ; 14ee0 (5:4ee0)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x14f0e

AIActionTable_RockCrusher: ; 14f0e (5:4f0e)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14f1a (5:4f1a)
	call AIMainTurnLogic
	ret
; 0x14f1e

.start_duel ; 14f1e (5:4f1e)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14f2f

.forced_switch ; 14f2f (5:4f2f)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14f33

.ko_switch ; 14f33 (5:4f33)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14f37

.take_prize ; 14f37 (5:4f37)
	call AIPickPrizeCards
	ret
; 0x14f3b

.list_arena ; 14f3b (5:4f3b)
	db RHYHORN
	db ONIX
	db GEODUDE
	db DIGLETT
	db $00

.list_bench ; 14f40 (5:4f40)
	db DIGLETT
	db GEODUDE
	db RHYHORN
	db ONIX
	db $00

.list_retreat ; 14f45 (5:4f45)
	ai_retreat DIGLETT, -1
	db $00

.list_energy ; 14f48 (5:4f48)
	ai_energy DIGLETT,  3, +1
	ai_energy DUGTRIO,  4, +0
	ai_energy GEODUDE,  2, +1
	ai_energy GRAVELER, 3, +0
	ai_energy GOLEM,    4, +0
	ai_energy ONIX,     2, -1
	ai_energy RHYHORN,  3, +0
	db $00

.list_prize ; 14f5e (5:4f5e)
	db ENERGY_REMOVAL
	db RHYHORN
	db $00

.store_list_pointers ; 14f61 (5:4f61)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x14f8f

AIActionTable_GoGoRainDance: ; 14f8f (5:4f8f)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14f9b (5:4f9b)
	call AIMainTurnLogic
	ret
; 0x14f9f

.start_duel ; 14f9f (5:4f9f)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x14fb0

.forced_switch ; 14fb0 (5:4fb0)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14fb4

.ko_switch ; 14fb4 (5:4fb4)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x14fb8

.take_prize ; 14fb8 (5:4fb8)
	call AIPickPrizeCards
	ret
; 0x14fbc

.list_arena ; 14fbc (5:4fbc)
	db LAPRAS
	db HORSEA
	db GOLDEEN
	db SQUIRTLE
	db $00

.list_bench ; 14fc1 (5:4fc1)
	db SQUIRTLE
	db HORSEA
	db GOLDEEN
	db LAPRAS
	db $00

.list_retreat ; 14fc6 (5:4fc6)
	ai_retreat SQUIRTLE,  -3
	ai_retreat WARTORTLE, -2
	ai_retreat HORSEA,    -1
	db $00

.list_energy ; 14fcd (5:4fcd)
	ai_energy SQUIRTLE,  2, +0
	ai_energy WARTORTLE, 3, +0
	ai_energy BLASTOISE, 5, +0
	ai_energy GOLDEEN,   1, +0
	ai_energy SEAKING,   2, +0
	ai_energy HORSEA,    2, +0
	ai_energy SEADRA,    3, +0
	ai_energy LAPRAS,    3, +0
	db $00

.list_prize ; 14fe6 (5:4fe6)
	db GAMBLER
	db ENERGY_RETRIEVAL
	db SUPER_ENERGY_RETRIEVAL
	db BLASTOISE
	db $00

.store_list_pointers ; 14feb (5:4feb)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x15019

AIActionTable_ZappingSelfdestruct: ; 15019 (5:5019)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 15025 (5:5025)
	call AIMainTurnLogic
	ret
; 0x15029

.start_duel ; 15029 (5:5029)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x1503a

.forced_switch ; 1503a (5:503a)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x1503e

.ko_switch ; 1503e (5:503e)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15042

.take_prize ; 15042 (5:5042)
	call AIPickPrizeCards
	ret
; 0x15046

.list_arena ; 15046 (5:5046)
	db KANGASKHAN
	db ELECTABUZZ2
	db TAUROS
	db MAGNEMITE1
	db VOLTORB
	db $00

.list_bench ; 1504c (5:504c)
	db MAGNEMITE1
	db VOLTORB
	db ELECTABUZZ2
	db TAUROS
	db KANGASKHAN
	db $00

.list_retreat ; 15052 (5:5052)
	ai_retreat VOLTORB, -1
	db $00

.list_energy ; 15055 (5:5055)
	ai_energy MAGNEMITE1,  3, +1
	ai_energy MAGNETON1,   4, +0
	ai_energy VOLTORB,     3, +1
	ai_energy ELECTRODE1,  3, +0
	ai_energy ELECTABUZZ2, 1, +0
	ai_energy KANGASKHAN,  2, -2
	ai_energy TAUROS,      3, +0
	db $00

.list_prize ; 1506b (5:506b)
	db KANGASKHAN
	db $00

.store_list_pointers ; 1506d (5:506d)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x1509b

AIActionTable_FlowerPower: ; 1509b (5:509b)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 150a7 (5:50a7)
	call AIMainTurnLogic
	ret
; 0x150ab

.start_duel ; 150ab (5:50ab)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x150bc

.forced_switch ; 150bc (5:50bc)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x150c0

.ko_switch ; 150c0 (5:50c0)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x150c4

.take_prize ; 150c4 (5:50c4)
	call AIPickPrizeCards
	ret
; 0x150c8

.list_arena ; 150c8 (5:50c8)
	db ODDISH
	db EXEGGCUTE
	db BULBASAUR
	db $00

.list_bench ; 150cc (5:50cc)
	db BULBASAUR
	db EXEGGCUTE
	db ODDISH
	db $00

.list_retreat ; 150cf (5:50cf)
	ai_retreat GLOOM,     -2
	ai_retreat VILEPLUME, -2
	ai_retreat BULBASAUR, -2
	ai_retreat IVYSAUR,   -2
	db $00

.list_energy ; 150d9 (5:50d9)
	ai_energy BULBASAUR,  3, +0
	ai_energy IVYSAUR,    4, +0
	ai_energy VENUSAUR2,  4, +0
	ai_energy ODDISH,     2, +0
	ai_energy GLOOM,      3, -1
	ai_energy VILEPLUME,  3, -1
	ai_energy EXEGGCUTE,  3, +0
	ai_energy EXEGGUTOR, 22, +0
	db $00

.list_prize ; 150f2 (5:50f2)
	db VENUSAUR2
	db $00

.store_list_pointers ; 150f4 (5:50f4)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x15122

AIActionTable_StrangePsyshock: ; 15122 (5:5122)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 1512e (5:512e)
	call AIMainTurnLogic
	ret
; 0x15132

.start_duel ; 15132 (5:5132)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x15143

.forced_switch ; 15143 (5:5143)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15147

.ko_switch ; 15147 (5:5147)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x1514b

.take_prize ; 1514b (5:514b)
	call AIPickPrizeCards
	ret
; 0x1514f

.list_arena ; 1514f (5:514f)
	db KANGASKHAN
	db CHANSEY
	db SNORLAX
	db MR_MIME
	db ABRA
	db $00

.list_bench ; 15155 (5:5155)
	db ABRA
	db MR_MIME
	db KANGASKHAN
	db SNORLAX
	db CHANSEY
	db $00

.list_retreat ; 1515b (5:515b)
	ai_retreat ABRA,       -3
	ai_retreat SNORLAX,    -3
	ai_retreat KANGASKHAN, -1
	ai_retreat CHANSEY,    -1
	db $00

.list_energy ; 15164 (5:5164)
	ai_energy ABRA,       3, +1
	ai_energy KADABRA,    3, +0
	ai_energy ALAKAZAM,   3, +0
	ai_energy MR_MIME,    2, +0
	ai_energy CHANSEY,    2, -2
	ai_energy KANGASKHAN, 4, -2
	ai_energy SNORLAX,    0, -8
	db $00

.list_prize ; 1517a (5:517a)
	db GAMBLER
	db MR_MIME
	db ALAKAZAM
	db SWITCH
	db $00

.store_list_pointers ; 1517f (5:517f)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x151ad

AIActionTable_WondersOfScience: ; 151ad (5:51ad)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 151b9 (5:51b9)
	call AIMainTurnLogic
	ret
; 0x151bd

.start_duel ; 151bd (5:51bd)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x151ce

.forced_switch ; 151ce (5:51ce)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x151d2

.ko_switch ; 151d2 (5:51d2)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x151d6

.take_prize ; 151d6 (5:51d6)
	call AIPickPrizeCards
	ret
; 0x151da

.list_arena ; 151da (5:51da)
	db MEWTWO1
	db MEWTWO3
	db MEWTWO2
	db GRIMER
	db KOFFING
	db PORYGON
	db $00

.list_bench ; 151e1 (5:51e1)
	db GRIMER
	db KOFFING
	db MEWTWO3
	db MEWTWO2
	db MEWTWO1
	db PORYGON
	db $00

.list_retreat ; 151e8 (5:51e8)
	db $00

.list_energy ; 151e9 (5:51e9)
	ai_energy GRIMER,  3, +0
	ai_energy MUK,     4, +0
	ai_energy KOFFING, 2, +0
	ai_energy WEEZING, 3, +0
	ai_energy MEWTWO1, 2, -1
	ai_energy MEWTWO3, 2, -1
	ai_energy MEWTWO2, 2, -1
	ai_energy PORYGON, 2, -1
	db $00

.list_prize ; 15202 (5:5202)
	db MUK
	db $00

.store_list_pointers ; 15204 (5:5204)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x15232

AIActionTable_FireCharge: ; 15232 (5:5232)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 1523e (5:523e)
	call AIMainTurnLogic
	ret
; 0x15242

.start_duel ; 15242 (5:5242)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x15253

.forced_switch ; 15253 (5:5253)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15257

.ko_switch ; 15257 (5:5257)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x1525b

.take_prize ; 1525b (5:525b)
	call AIPickPrizeCards
	ret
; 0x1525f

.list_arena ; 1525f (5:525f)
	db JIGGLYPUFF3
	db CHANSEY
	db TAUROS
	db MAGMAR1
	db JIGGLYPUFF1
	db GROWLITHE
	db $00

.list_bench ; 15266 (5:5266)
	db JIGGLYPUFF3
	db CHANSEY
	db GROWLITHE
	db MAGMAR1
	db JIGGLYPUFF1
	db TAUROS
	db $00

.list_retreat ; 1526e (5:526e)
	ai_retreat JIGGLYPUFF1, -1
	ai_retreat CHANSEY,     -1
	ai_retreat GROWLITHE,   -1
	db $00

.list_energy ; 15274 (5:5274)
	ai_energy GROWLITHE,   3, +0
	ai_energy ARCANINE2,   4, +0
	ai_energy MAGMAR1,     3, +0
	ai_energy JIGGLYPUFF1, 3, +0
	ai_energy JIGGLYPUFF3, 2, +0
	ai_energy WIGGLYTUFF,  3, +0
	ai_energy CHANSEY,     4, +0
	ai_energy TAUROS,      3, +0
	db $00

.list_prize ; 1528d (5:528d)
	db GAMBLER
	db $00

.store_list_pointers ; 1528f (5:528f)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x152bd

AIActionTable_ImRonald: ; 152bd (5:52bd)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 152c9 (5:52c9)
	call AIMainTurnLogic
	ret
; 0x152cd

.start_duel ; 152cd (5:52cd)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x152de

.forced_switch ; 152de (5:52de)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x152e2

.ko_switch ; 152e2 (5:52e2)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x152e6

.take_prize ; 152e6 (5:52e6)
	call AIPickPrizeCards
	ret
; 0x152ea

.list_arena ; 152ea (5:52ea)
	db LAPRAS
	db SEEL
	db CHARMANDER
	db CUBONE
	db SQUIRTLE
	db GROWLITHE
	db $00

.list_bench ; 152f1 (5:52f1)
	db CHARMANDER
	db SQUIRTLE
	db SEEL
	db CUBONE
	db GROWLITHE
	db LAPRAS
	db $00

.list_retreat ; 152f8 (5:52f8)
	db $00

.list_energy ; 152f9 (5:52f9)
	ai_energy CHARMANDER, 3, +0
	ai_energy CHARMELEON, 5, +0
	ai_energy GROWLITHE,  2, +0
	ai_energy ARCANINE2,  4, +0
	ai_energy SQUIRTLE,   2, +0
	ai_energy WARTORTLE,  3, +0
	ai_energy SEEL,       3, +0
	ai_energy DEWGONG,    4, +0
	ai_energy LAPRAS,     3, +0
	ai_energy CUBONE,     3, +0
	ai_energy MAROWAK1,   3, +0
	db $00

.list_prize ; 1531b (5:531b)
	db LAPRAS
	db $00

.store_list_pointers ; 1531d (5:531d)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x1534b

AIActionTable_PowerfulRonald: ; 1534b (5:534b)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 15357 (5:5357)
	call AIMainTurnLogic
	ret
; 0x1535b

.start_duel ; 1535b (5:535b)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x1536c

.forced_switch ; 1536c (5:536c)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15370

.ko_switch ; 15370 (5:5370)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15374

.take_prize ; 15374 (5:5374)
	call AIPickPrizeCards
	ret
; 0x15378

.list_arena ; 15378 (5:5378)
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

.list_bench ; 15383 (5:5383)
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

.list_retreat ; 1538e (5:538e)
	ai_retreat KANGASKHAN, -1
	ai_retreat DODUO,      -1
	ai_retreat DODRIO,     -1
	db $00

.list_energy ; 15395 (5:5395)
	ai_energy ELECTABUZZ2, 2, +1
	ai_energy HITMONLEE,   3, +1
	ai_energy HITMONCHAN,  3, +1
	ai_energy MR_MIME,     2, +0
	ai_energy JYNX,        3, +0
	ai_energy MEWTWO1,     2, +0
	ai_energy DODUO,       3, -1
	ai_energy DODRIO,      3, -1
	ai_energy LICKITUNG,   2, +0
	ai_energy KANGASKHAN,  4, -1
	ai_energy TAUROS,      3, +0
	db $00

.list_prize ; 153b7 (5:53b7)
	db GAMBLER
	db ENERGY_REMOVAL
	db $00

.store_list_pointers ; 153ba (5:53ba)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x153e8

AIActionTable_InvincibleRonald: ; 153e8 (5:53e8)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 153f4 (5:53f4)
	call AIMainTurnLogic
	ret
; 0x153f8

.start_duel ; 153f8 (5:53f8)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x15409

.forced_switch ; 15409 (5:5409)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x1540d

.ko_switch ; 1540d (5:540d)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15411

.take_prize ; 15411 (5:5411)
	call AIPickPrizeCards
	ret
; 0x15415

.list_arena ; 15415 (5:5415)
	db KANGASKHAN
	db MAGMAR2
	db CHANSEY
	db GEODUDE
	db SCYTHER
	db GRIMER
	db $00

.list_bench ; 1541c (5:541c)
	db GRIMER
	db SCYTHER
	db GEODUDE
	db CHANSEY
	db MAGMAR2
	db KANGASKHAN
	db $00

.list_retreat ; 15423 (5:5423)
	ai_retreat GRIMER, -1
	db $00

.list_energy ; 15426 (5:5426)
	ai_energy GRIMER,     1, -1
	ai_energy MUK,        3, -1
	ai_energy SCYTHER,    4, +1
	ai_energy MAGMAR2,    2, +0
	ai_energy GEODUDE,    2, +0
	ai_energy GRAVELER,   3, +0
	ai_energy CHANSEY,    4, +0
	ai_energy KANGASKHAN, 4, -1
	db $00

.list_prize ; 1543f (5:543f)
	db GAMBLER
	db $00

.store_list_pointers ; 15441 (5:5441)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_bench
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x1546f

AIActionTable_LegendaryRonald: ; 1546f (5:546f)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 1547b (5:547b)
	call AIDoTurn_LegendaryRonald
	ret
; 0x1547f

.start_duel ; 1547f (5:547f)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret
; 0x15490

.forced_switch ; 15490 (5:5490)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15494

.ko_switch ; 15494 (5:5494)
	call AIDecideBenchPokemonToSwitchTo
	ret
; 0x15498

.take_prize ; 15498 (5:5498)
	call AIPickPrizeCards
	ret
; 0x1549c

.list_arena ; 1549c (5:549c)
	db KANGASKHAN
	db DRATINI
	db EEVEE
	db ZAPDOS3
	db ARTICUNO2
	db MOLTRES2
	db $00

.list_bench ; 154a3 (5:54a3)
	db KANGASKHAN
	db DRATINI
	db EEVEE
	db $00

.list_play_hand ; 154a7 (5:54a7)
	db MOLTRES2
	db ZAPDOS3
	db KANGASKHAN
	db DRATINI
	db EEVEE
	db ARTICUNO2
	db $00

.list_retreat ; 154ae (5:54ae)
	ai_retreat EEVEE, -2
	db $00

.list_energy ; 154b1 (5:54b1)
	ai_energy FLAREON1,   3, +0
	ai_energy MOLTRES2,   3, +0
	ai_energy VAPOREON1,  3, +0
	ai_energy ARTICUNO2,  0, -8
	ai_energy JOLTEON1,   4, +0
	ai_energy ZAPDOS3,    0, -8
	ai_energy KANGASKHAN, 4, -1
	ai_energy EEVEE,      3, +0
	ai_energy DRATINI,    3, +0
	ai_energy DRAGONAIR,  4, +0
	ai_energy DRAGONITE1, 3, +0
	db $00

.list_prize ; 154d3 (5:54d3)
	db MOLTRES2
	db ARTICUNO2
	db ZAPDOS3
	db DRAGONITE1
	db GAMBLER
	db $00

.store_list_pointers ; 154d9 (5:54d9)
	store_list_pointer wcda8, .list_prize
	store_list_pointer wcdaa, .list_arena
	store_list_pointer wcdac, .list_bench
	store_list_pointer wcdae, .list_play_hand
	; missing store_list_pointer wcdb0, .list_retreat
	store_list_pointer wcdb2, .list_energy
	ret
; 0x15507

AIDoTurn_LegendaryRonald: ; 15507 (5:5507)
; initialize variables
	call InitAITurnVars
; process Trainer cards
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_04
	call AIProcessHandTrainerCards

; check if AI can play Moltres2
; from hand and if so, play it.
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .skip_moltres_1 ; skip if bench is full
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE - 9
	jr nc, .skip_moltres_1 ; skip if cards in deck <= 9
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .skip_moltres_1 ; skip if Muk in play
	ld a, MOLTRES2
	call LookForCardIDInHandList_Bank5
	jr nc, .skip_moltres_1 ; skip if no Moltres2 in hand
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_PLAY_BASIC_PKMN
	bank1call AIMakeDecision

.skip_moltres_1
; play Pokemon from hand
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
; process Trainer cards
	ld a, AI_TRAINER_CARD_PHASE_05
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_07
	call AIProcessHandTrainerCards
	call AIProcessRetreat
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
; play Energy card if possible
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_attach_energy_1
	call AIProcessAndTryToPlayEnergy
.skip_attach_energy_1
; try playing Pokemon cards from hand again
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	ld a, AI_TRAINER_CARD_PHASE_15
; if used Professor Oak, process new hand
; if not, then proceed to attack.
	call AIProcessHandTrainerCards
	ld a, [wPreviousAIFlags]
	and AI_FLAG_USED_PROFESSOR_OAK
	jr z, .try_attack
	ld a, AI_TRAINER_CARD_PHASE_01
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_02
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_04
	call AIProcessHandTrainerCards

; check if AI can play Moltres2
; from hand and if so, play it.
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .skip_moltres_2 ; skip if bench is full
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE - 9
	jr nc, .skip_moltres_2 ; skip if cards in deck <= 9
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .skip_moltres_2 ; skip if Muk in play
	ld a, MOLTRES2
	call LookForCardIDInHandList_Bank5
	jr nc, .skip_moltres_2 ; skip if no Moltres2 in hand
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_PLAY_BASIC_PKMN
	bank1call AIMakeDecision

.skip_moltres_2
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
	ld a, AI_TRAINER_CARD_PHASE_05
	call AIProcessHandTrainerCards
	ld a, AI_TRAINER_CARD_PHASE_07
	call AIProcessHandTrainerCards
	call AIProcessRetreat
	ld a, AI_TRAINER_CARD_PHASE_10
	call AIProcessHandTrainerCards
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .skip_attach_energy_2
	call AIProcessAndTryToPlayEnergy
.skip_attach_energy_2
	call AIDecidePlayPokemonCard
	ret c ; return if turn ended
.try_attack
; attack if possible, if not,
; finish turn without attacking.
	call AIProcessAndTryToUseAttack
	ret c ; return if turn ended
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret
; 0x155d2
