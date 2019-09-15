Data_20000: ; 20000 (8:4000)
	INCROM $20000, $200e5

; 0 - e4 is a big set of data, seems to be one entry for each card

Func_200e5: ; 200e5 (8:40e5)
	ld [wce18], a
; create hand list in wDuelTempList and wTempHandCardList.
	call CreateHandCardList
	ld hl, wDuelTempList
	ld de, wTempHandCardList
	call CopyBuffer
	ld hl, wTempHandCardList

.loop_hand
	ld a, [hli]
	ld [wce16], a
	cp $ff
	ret z

	push hl
	ld a, [wce18]
	ld d, a
	ld hl, Data_20000
.loop_data
	xor a
	ld [wce21], a
	ld a, [hli]
	cp $ff
	jp z, .pop_hl

; compare input to first byte in data and continue if equal.
	cp d
	jp nz, .inc_hl_by_5
	ld a, [hli]
	ld [wce17], a
	ld a, [wce16]
	call LoadCardDataToBuffer1_FromDeckIndex
	cp SWITCH
	jr nz, .skip_switch_check

	ld b, a
	ld a, [wce20]
	and $02
	jr nz, .inc_hl_by_4
	ld a, b

.skip_switch_check
; compare hand card to second byte in data and continue if equal.
	ld b, a
	ld a, [wce17]
	cp b
	jr nz, .inc_hl_by_4

	push hl
	push de
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	bank1call CheckCantUseTrainerDueToHeadache
	jp c, .next_in_data
	call LoadNonPokemonCardEffectCommands
	ld a, OPPACTION_PLAY_BASIC_PKMN
	call TryExecuteEffectCommandFunction
	jp c, .next_in_data
	farcall Func_1743b
	jr c, .next_in_data
	pop de
	pop hl
	push hl
	call CallIndirect
	pop hl
	jr nc, .inc_hl_by_4
	inc hl
	inc hl
	ld [wce19], a

	push de
	push hl
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, OPPACTION_PLAY_TRAINER
	bank1call AIMakeDecision
	pop hl
	pop de
	jr c, .inc_hl_by_2
	push hl
	call CallIndirect
	pop hl

	inc hl
	inc hl
	ld a, [wce20]
	ld b, a
	ld a, [wce21]
	or b
	ld [wce20], a
	pop hl
	and $08
	jp z, .loop_hand

	call CreateHandCardList
	ld hl, wDuelTempList
	ld de, wTempHandCardList
	call CopyBuffer
	ld hl, wTempHandCardList
	ld a, [wce20]
	and $f7
	ld [wce20], a
	jp .loop_hand

.inc_hl_by_5
	inc hl
.inc_hl_by_4
	inc hl
	inc hl
.inc_hl_by_2
	inc hl
	inc hl
	jp .loop_data

.next_in_data
	pop de
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	jp .loop_data

.pop_hl
	pop hl
	jp .loop_hand
; 0x201b5

Func_201b5: ; 201b5 (8:41b5)
	INCROM $201b5, $2297b

; copies $ff terminated buffer from hl to de
CopyBuffer: ; 2297b (8:697b)
	ld a, [hli]
	ld [de], a
	cp $ff
	ret z
	inc de
	jr CopyBuffer
; 0x22983

	INCROM $22983, $22990

; counts number of energy cards found in hand
; and outputs result in a
; sets carry if none are found
; output:
; 	a = number of energy cards found
CountEnergyCardsInHand: ; 22990 (8:6990)
	farcall CreateEnergyCardListFromHand
	ret c
	ld b, -1
	ld hl, wDuelTempList
.loop
	inc b
	ld a, [hli]
	cp $ff
	jr nz, .loop
	ld a, b
	or a
	ret
; 0x229a3

Func_229a3 ; 229a3 (8:69a3)
	INCROM $229a3, $24000
