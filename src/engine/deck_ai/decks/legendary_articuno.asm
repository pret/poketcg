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

.start_duel ; 14c1b (5:4c1b)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 14c2c (5:4c2c)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 14c30 (5:4c30)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 14c34 (5:4c34)
	call AIPickPrizeCards
	ret

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
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret

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
