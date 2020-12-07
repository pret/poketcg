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

.start_duel ; 1547f (5:547f)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 15490 (5:5490)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 15494 (5:5494)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 15498 (5:5498)
	call AIPickPrizeCards
	ret

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
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_play_hand
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret

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
