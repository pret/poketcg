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

.start_duel ; 14b1f (5:4b1f)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 14b30 (5:4b30)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 14b34 (5:4b34)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 14b38 (5:4b38)
	call AIPickPrizeCards
	ret

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
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret

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
