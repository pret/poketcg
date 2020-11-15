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

.start_duel ; 149f8 (5:49f8)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc ; Play Area set up was successful
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 14a09 (5:4a09)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 14a0d (5:4a0d)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 14a11 (5:4a11)
	call AIPickPrizeCards
	ret

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
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_play_hand
	store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret

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
