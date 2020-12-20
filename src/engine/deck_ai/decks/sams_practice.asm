; AI for Sam's practice duel, which handles his scripted actions.
; will act as a normal duelist AI after turn 7.
AIActionTable_SamPractice: ; 147bd (05:47bd)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 147c9 (5:47c9)
	call IsAIPracticeScriptedTurn
	jr nc, .scripted_1
; not scripted, use AI main turn logic
	call AIMainTurnLogic
	ret
.scripted_1 ; use scripted actions instead
	call AIPerformScriptedTurn
	ret

.start_duel ; 147d6 (5:47d6)
	call SetSamsStartingPlayArea
	ret

.forced_switch ; 147da (5:47da)
	call IsAIPracticeScriptedTurn
	jr nc, .scripted_2
	call AIDecideBenchPokemonToSwitchTo
	ret
.scripted_2
	call PickRandomBenchPokemon
	ret

.ko_switch: ; 147e7 (5:47e7)
	call IsAIPracticeScriptedTurn
	jr nc, .scripted_3
	call AIDecideBenchPokemonToSwitchTo
	ret
.scripted_3
	call GetPlayAreaLocationOfRaticateOrRattata
	ret

.take_prize: ; 147f4 (5:47f4)
	call AIPickPrizeCards
	ret

; returns carry if number of turns
; the AI has taken >= 7.
; used to know whether AI Sam is still
; doing scripted turns.
IsAIPracticeScriptedTurn: ; 147f8 (5:47f8)
	ld a, [wDuelTurns]
	srl a
	cp 7
	ccf
	ret

; places one Machop from the hand to the Play Area
; and sets the number of prizes to 2.
SetSamsStartingPlayArea: ; 14801 (5:4801)
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
GetPlayAreaLocationOfRaticateOrRattata: ; 1481f (5:481f)
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
AIPerformScriptedTurn: ; 1483a (5:483a)
	ld a, [wDuelTurns]
	srl a
	ld hl, .scripted_actions_list
	call JumpToFunctionInTable

; always attack with Arena card's first attack.
; if it's unusable end turn without attacking.
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	jr c, .unusable
	call AITryUseAttack
	ret

.unusable
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret

.scripted_actions_list ; 1485a (05:485a)
	dw .turn_1
	dw .turn_2
	dw .turn_3
	dw .turn_4
	dw .turn_5
	dw .turn_6
	dw .turn_7

.turn_1 ; 14868 (5:4868)
	ld d, MACHOP
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_2 ; 14870 (5:4870)
	ld a, RATTATA
	call LookForCardIDInHandList_Bank5
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_PLAY_BASIC_PKMN
	bank1call AIMakeDecision
	ld d, RATTATA
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_3 ; 14884 (5:4884)
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

.turn_4 ; 148a1 (5:48a1)
	ld d, RATICATE
	ld e, LIGHTNING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_5 ; 148a9 (5:48a9)
	ld a, MACHOP
	call LookForCardIDInHandList_Bank5
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_PLAY_BASIC_PKMN
	bank1call AIMakeDecision
	ld d, MACHOP
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInBench

; this is a bug, it's attempting to compare a card ID with a deck index.
; the intention was to change the card to switch to depending on whether
; the first Machop was KO'd at this point in the Duel or not.
; because of the buggy comparison, this will always jump the
; 'inc a' instruction and switch to PLAY_AREA_BENCH_1.
; in a normal Practice Duel following Dr. Mason's instructions,
; this will always lead to the AI correctly switching Raticate with Machop,
; but in case of a "Free" Duel where the first Machop is not KO'd,
; the intention was to switch to PLAY_AREA_BENCH_2 instead.
; but due to 'inc a' always being skipped, it will switch to Raticate.
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp MACHOP ; wrong
	ld a, PLAY_AREA_BENCH_1
	jr nz, .retreat
	inc a ; PLAY_AREA_BENCH_2

.retreat
	call AITryToRetreat
	ret

.turn_6 ; 148cc (5:48cc)
	ld d, MACHOP
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret

.turn_7 ; 148d4 (5:48d4)
	ld d, MACHOP
	ld e, FIGHTING_ENERGY
	call AIAttachEnergyInHandToCardInPlayArea
	ret
; 0x148dc
