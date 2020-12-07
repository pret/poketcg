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

.start_duel ; 14d70 (5:4d70)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 14d81 (5:4d81)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 14d85 (5:4d85)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 14d89 (5:4d89)
	call AIPickPrizeCards
	ret

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
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret

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
