; AI for Sam's practice duel, which handles his scripted actions.
; will act as a normal duelist AI after turn 7.
AIActionTable_SamPractice:
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn
	call IsAIPracticeScriptedTurn
	jr nc, .scripted_1
; not scripted, use AI main turn logic
	call AIMainTurnLogic
	ret
.scripted_1 ; use scripted actions instead
	call AIPerformScriptedTurn
	ret

.start_duel
	call SetSamsStartingPlayArea
	ret

.forced_switch
	call IsAIPracticeScriptedTurn
	jr nc, .scripted_2
	call AIDecideBenchPokemonToSwitchTo
	ret
.scripted_2
	call PickRandomBenchPokemon
	ret

.ko_switch:
	call IsAIPracticeScriptedTurn
	jr nc, .scripted_3
	call AIDecideBenchPokemonToSwitchTo
	ret
.scripted_3
	call GetPlayAreaLocationOfRaticateOrRattata
	ret

.take_prize:
	call AIPickPrizeCards
	ret

; returns carry if number of turns
; the AI has taken >= 7.
; used to know whether AI Sam is still
; doing scripted turns.
IsAIPracticeScriptedTurn:
	ld a, [wDuelTurns]
	srl a
	cp 7
	ccf
	ret

; places one Machop from the hand to the Play Area
; and sets the number of prizes to 2.
SetSamsStartingPlayArea:
	call CreateHandCardList
	ld hl, wDuelTempList
.loop_hand
	ld a, [hli]
	ldh [hTempCardIndex_ff98], a
	cp $ff
	ret z
	call LoadCardDataToBuffer1_FromDeckIndex
	cp MACHOP
	jr nz, .loop_hand
	ldh a, [hTempCardIndex_ff98]
	call PutHandPokemonCardInPlayArea
	ld a, 2
	ld [wDuelInitialPrizes], a
	ret

; outputs in a Play Area location of Raticate or Rattata
; in the Bench. If neither is found, just output PLAY_AREA_BENCH_1.
GetPlayAreaLocationOfRaticateOrRattata:
	ld a, RATICATE
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInPlayArea_Bank5
	cp $ff
	jr nz, .found
	ld a, RATTATA
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInPlayArea_Bank5
	cp $ff
	jr nz, .found
	ld a, PLAY_AREA_BENCH_1
.found
	ldh [hTempPlayAreaLocation_ff9d], a
	ret

; has AI execute some scripted actions depending on Duel turn.
AIPerformScriptedTurn:
	ld a, [wDuelTurns]
	srl a
	ld hl, .scripted_actions_list
	call JumpToFunctionInTable

; always attack with Arena card's first attack.
; if it's unusable end turn without attacking.
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a ; PLAY_AREA_ARENA
	ld [wSelectedAttack], a ; FIRST_ATTACK_OR_PKMN_POWER
	call CheckIfSelectedAttackIsUnusable
	jr c, .unusable
	call AITryUseAttack
	ret

.unusable
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret

.scripted_actions_list
	dw .turn_1
	dw .turn_2
	dw .turn_3
	dw .turn_4
	dw .turn_5
	dw .turn_6
	dw .turn_7

.turn_1
	ld d, MACHOP
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_2
	ld a, RATTATA
	call LookForCardIDInHandList_Bank5
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_PLAY_BASIC_PKMN
	bank1call AIMakeDecision
	ld d, RATTATA
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_3
	ld a, RATTATA
	ld b, PLAY_AREA_ARENA
	call LookForCardIDInPlayArea_Bank5
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, RATICATE
	call LookForCardIDInHandList_Bank5
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_EVOLVE_PKMN
	bank1call AIMakeDecision
	ld d, RATICATE
	ld e, LIGHTNING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_4
	ld d, RATICATE
	ld e, LIGHTNING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_5
	ld a, MACHOP
	call LookForCardIDInHandList_Bank5
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_PLAY_BASIC_PKMN
	bank1call AIMakeDecision
	ld d, MACHOP
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInBench

	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp MACHOP ; wrong
	ld a, PLAY_AREA_BENCH_1
	jr nz, .retreat
	inc a ; PLAY_AREA_BENCH_2

.retreat
	call AITryToRetreat
	ret

.turn_6
	ld d, MACHOP
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_7
	ld d, MACHOP
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret
