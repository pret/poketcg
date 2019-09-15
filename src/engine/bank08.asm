; unknown byte / card ID / function pointer 1 / function pointer 2
unknown_data_20000: MACRO
	db \1, \2
	dw \3
	dw \4
ENDM

Data_20000: ; 20000 (8:4000)
	unknown_data_20000 $07, POTION,                 $41d1, $41b5
	unknown_data_20000 $0a, POTION,                 $4204, $41b5
	unknown_data_20000 $08, SUPER_POTION,           $42cc, $42a8
	unknown_data_20000 $0b, SUPER_POTION,           $430f, $42a8
	unknown_data_20000 $0d, DEFENDER,               $4406, $43f8
	unknown_data_20000 $0e, DEFENDER,               $4486, $43f8
	unknown_data_20000 $0d, PLUSPOWER,              $4501, $44e8
	unknown_data_20000 $0e, PLUSPOWER,              $45a5, $44e8
	unknown_data_20000 $09, SWITCH,                 $462e, $4612
	unknown_data_20000 $07, GUST_OF_WIND,           $467e, $4666
	unknown_data_20000 $0a, GUST_OF_WIND,           $467e, $4666
	unknown_data_20000 $04, BILL,                   $4878, $486d
	unknown_data_20000 $05, ENERGY_REMOVAL,         $4895, $4880
	unknown_data_20000 $05, SUPER_ENERGY_REMOVAL,   $49bc, $4994
	unknown_data_20000 $07, POKEMON_BREEDER,        $4b1b, $4b06
	unknown_data_20000 $0f, PROFESSOR_OAK,          $4cc1, $4cae
	unknown_data_20000 $0a, ENERGY_RETRIEVAL,       $4e6e, $4e44
	unknown_data_20000 $0b, SUPER_ENERGY_RETRIEVAL, $4fc1, $4f80
	unknown_data_20000 $06, POKEMON_CENTER,         $50eb, $50e0
	unknown_data_20000 $07, IMPOSTER_PROFESSOR_OAK, $517b, $5170
	unknown_data_20000 $0c, ENERGY_SEARCH,          $51aa, $519a
	unknown_data_20000 $03, POKEDEX,                $52dc, $52b4
	unknown_data_20000 $07, FULL_HEAL,              $5428, $541d
	unknown_data_20000 $0a, MR_FUJI,                $54a7, $5497
	unknown_data_20000 $0a, SCOOP_UP,               $5506, $54f1
	unknown_data_20000 $02, MAINTENANCE,            $562c, $560f
	unknown_data_20000 $03, RECYCLE,                $56b8, $569a
	unknown_data_20000 $0d, LASS,                   $5768, $5755
	unknown_data_20000 $04, ITEM_FINDER,            $57b1, $578f
	unknown_data_20000 $01, IMAKUNI_CARD,           $581e, $5813
	unknown_data_20000 $01, GAMBLER,                $5875, $582d
	unknown_data_20000 $05, REVIVE,                 $58a9, $5899
	unknown_data_20000 $0d, POKEMON_FLUTE,          $58e8, $58d8
	unknown_data_20000 $05, CLEFAIRY_DOLL,          $5982, $5977
	unknown_data_20000 $05, MYSTERIOUS_FOSSIL,      $5982, $5977
	unknown_data_20000 $02, POKE_BALL,              $59c6, $59a6
	unknown_data_20000 $02, COMPUTER_SEARCH,        $5b34, $5b12
	unknown_data_20000 $02, POKEMON_TRADER,         $5d8f, $5d7a
	db $ff

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

.asm_20186 ; 20186 (8:4186)
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
