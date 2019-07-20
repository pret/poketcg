PointerTable_14000: ; 14000 (05:4000)
	dw $47bd ; SAMS_PRACTICE_DECK
	dw PointerTable_14668 ; PRACTICE_PLAYER_DECK
	dw PointerTable_14668 ; SAMS_NORMAL_DECK
	dw PointerTable_14668 ; CHARMANDER_AND_FRIENDS_DECK
	dw PointerTable_14668 ; CHARMANDER_EXTRA_DECK
	dw PointerTable_14668 ; SQUIRTLE_AND_FRIENDS_DECK
	dw PointerTable_14668 ; SQUIRTLE_EXTRA_DECK
	dw PointerTable_14668 ; BULBASAUR_AND_FRIENDS_DECK
	dw PointerTable_14668 ; BULBASAUR_EXTRA_DECK
	dw PointerTable_14668 ; LIGHTNING_AND_FIRE_DECK
	dw PointerTable_14668 ; WATER_AND_FIGHTING_DECK
	dw PointerTable_14668 ; GRASS_AND_PSYCHIC_DECK
	dw $49e8 ; LEGENDARY_MOLTRES_DECK
	dw $4b0f ; LEGENDARY_ZAPDOS_DECK
	dw $4c0b ; LEGENDARY_ARTICUNO_DECK
	dw $4d60 ; LEGENDARY_DRAGONITE_DECK
	dw $4e89 ; FIRST_STRIKE_DECK
	dw $4f0e ; ROCK_CRUSHER_DECK
	dw $4f8f ; GO_GO_RAIN_DANCE_DECK
	dw $5019 ; ZAPPING_SELFDESTRUCT_DECK
	dw $509b ; FLOWER_POWER_DECK
	dw $5122 ; STRANGE_PSYSHOCK_DECK
	dw $51ad ; WONDERS_OF_SCIENCE_DECK
	dw $5232 ; FIRE_CHARGE_DECK
	dw $52bd ; IM_RONALD_DECK
	dw $534b ; POWERFUL_RONALD_DECK
	dw $53e8 ; INVINCIBLE_RONALD_DECK
	dw $546f ; LEGENDARY_RONALD_DECK
	dw $48dc ; MUSCLES_FOR_BRAINS_DECK
	dw PointerTable_14668 ; HEATED_BATTLE_DECK
	dw PointerTable_14668 ; LOVE_TO_BATTLE_DECK
	dw PointerTable_14668 ; EXCAVATION_DECK
	dw PointerTable_14668 ; BLISTERING_POKEMON_DECK
	dw PointerTable_14668 ; HARD_POKEMON_DECK
	dw PointerTable_14668 ; WATERFRONT_POKEMON_DECK
	dw PointerTable_14668 ; LONELY_FRIENDS_DECK
	dw PointerTable_14668 ; SOUND_OF_THE_WAVES_DECK
	dw PointerTable_14668 ; PIKACHU_DECK
	dw PointerTable_14668 ; BOOM_BOOM_SELFDESTRUCT_DECK
	dw PointerTable_14668 ; POWER_GENERATOR_DECK
	dw PointerTable_14668 ; ETCETERA_DECK
	dw PointerTable_14668 ; FLOWER_GARDEN_DECK
	dw PointerTable_14668 ; KALEIDOSCOPE_DECK
	dw PointerTable_14668 ; GHOST_DECK
	dw PointerTable_14668 ; NAP_TIME_DECK
	dw PointerTable_14668 ; STRANGE_POWER_DECK
	dw PointerTable_14668 ; FLYIN_POKEMON_DECK
	dw PointerTable_14668 ; LOVELY_NIDORAN_DECK
	dw PointerTable_14668 ; POISON_DECK
	dw PointerTable_14668 ; ANGER_DECK
	dw PointerTable_14668 ; FLAMETHROWER_DECK
	dw PointerTable_14668 ; RESHUFFLE_DECK
	dw $48dc ; IMAKUNI_DECK
; 1406a

PointerTable_1406a: ; 1406a (5:406a)
	dw $406c
	dw Func_14078
	dw Func_14078
	dw $409e
	dw $40a2
	dw $40a6
	dw $40aa

Func_14078: ; 14078 (5:4078)
	call Func_15eae
	call Func_158b2
	jr nc, .asm_14091
	call Func_15b72
	call Func_15d4f
	call Func_158b2
	jr nc, .asm_14091
	call Func_15b72
	call Func_15d4f
.asm_14091
	call Func_164e8
	call Func_169f8
	ret c
	ld a, $05
	bank1call AIMakeDecision
	ret
; 0x1409e

	INCROM $1409e, $140ae

Func_140ae: ; 140ae (5:40ae)
	xor a
	call Func_140b5
	ret c
	ld a, $01

Func_140b5: ; 140b5 (5:40b5)
	call Func_143e5
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	ret c
	ret nz
	scf
	ret
; 0x140c5

	INCROM $140c5, $140fe

Func_140fe: ; 140fe (5:40fe)
	INCROM $140fe, $1410a

Func_1410a: ; 1410a (5:410a)
	INCROM $1410a, $14226

Func_14226: ; 14226 (5:4226)
	call CreateHandCardList
	ld hl, wDuelTempList
.check_for_next_pokemon
	ld a, [hli]
	ldh [hTempCardIndex_ff98], a
	cp $ff
	ret z
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .check_for_next_pokemon
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .check_for_next_pokemon
	push hl
	ldh a, [hTempCardIndex_ff98]
	call PutHandPokemonCardInPlayArea
	pop hl
	jr .check_for_next_pokemon
; 0x1424b

Func_1424b: ; 1424b (5:424b)
	INCROM $1424b, $1433d

Func_1433d: ; 1433d (5:433d)
	INCROM $1433d, $143e5

Func_143e5: ; 143e5 (5:43e5)
	ld [wSelectedMoveIndex], a
	ld e, a
	ldh a, [hTempPlayAreaLocation_ff9d]
	add $bb
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, [wLoadedMoveCategory]
	cp $04
	jr nz, .asm_1440a
	ld hl, wDamage
	xor a
	ld [hli], a
	ld [hl], a
	ld [wccbb], a
	ld [wccbc], a
	ld e, a
	ld d, a
	ret
.asm_1440a
	ld a, [wDamage]
	ld [wccbb], a
	ld [wccbc], a
	ld a, $09
	call TryExecuteEffectCommandFunction
	ld a, [wccbb]
	ld hl, wccbc
	or [hl]
	jr nz, .asm_1442a
	ld a, [wDamage]
	ld [wccbb], a
	ld [wccbc], a
.asm_1442a
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr z, .asm_14453
	ld a, $e7
	call GetTurnDuelistVariable
	push af
	push hl
	ld [hl], $00
	ld l, $e8
	ld a, [hl]
	push af
	push hl
	ld [hl], $00
	ld l, $ea
	ld a, [hl]
	push af
	push hl
	ld [hl], $00
	call .asm_14453
	pop hl
	pop af
	ld [hl], a
	pop hl
	pop af
	ld [hl], a
	pop hl
	pop af
	ld [hl], a
	ret
.asm_14453
	ld hl, wccbb
	call .asm_14462
	ld hl, wccbc
	call .asm_14462
	ld hl, wDamage
.asm_14462
	ld e, [hl]
	ld d, $00
	push hl
	ldh a, [hTempPlayAreaLocation_ff9d]
	add $bb
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2ID]
	ld [wTempTurnDuelistCardID], a
	call SwapTurn
	ld a, $bb
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2ID]
	ld [wTempNonTurnDuelistCardID], a
	call SwapTurn
	push de
	call HandleNoDamageOrEffectSubstatus
	pop de
	jr nc, .asm_14496
	ld de, $0
	jr .asm_14502
.asm_14496
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	call z, HandleDoubleDamageSubstatus
	bit 7, d
	res 7, d
	jr nz, .asm_144cd
	ldh a, [hTempPlayAreaLocation_ff9d]
	call GetPlayAreaCardColor
	call TranslateColorToWR
	ld b, a
	call SwapTurn
	call GetArenaCardWeakness
	call SwapTurn
	and b
	jr z, .asm_144bb
	sla e
	rl d
.asm_144bb
	call SwapTurn
	call GetArenaCardResistance
	call SwapTurn
	and b
	jr z, .asm_144cd
	ld hl, $ffe2
	add hl, de
	ld e, l
	ld d, h
.asm_144cd
	ldh a, [hTempPlayAreaLocation_ff9d]
	add $10
	ld b, a
	call ApplyAttachedPluspower
	call SwapTurn
	ld b, $10
	call ApplyAttachedDefender
	call HandleDamageReduction
	bit 7, d
	jr z, .asm_144e7
	ld de, $0
.asm_144e7
	ld a, $f0
	call GetTurnDuelistVariable
	and $c0
	jr z, .asm_144ff
	ld c, $14
	and $40
	jr nz, .asm_144f8
	ld c, $0a
.asm_144f8
	ld a, c
	add e
	ld e, a
	ld a, $00
	adc d
	ld d, a
.asm_144ff
	call SwapTurn
.asm_14502
	pop hl
	ld [hl], e
	ld a, d
	or a
	ret z
	ld a, $ff
	ld [hl], a
	ret
; 0x1450b

Func_1450b ; 1450b (5:450b)
	INCROM $1450b, $14663

Func_14663: ; 14663 (5:4663)
	farcall Func_200e5
	ret

; GENERAL DECK POINTER LIST - Not sure on all of these.
; This is an example of an AI pointer table, there's one for each AI type.
PointerTable_14668: ; 14668 (05:4668)
	dw Func_14674 ; not used
	dw Func_14674 ; general AI for battles
	dw Func_14678 ; basic pokemon placement / cheater shuffling on better AI
	dw Func_1467f
	dw Func_14683
	dw Func_14687

; when battle AI gets called
Func_14674: ; 14674 (5:4674)
	call Func_1468b
	ret

Func_14678: ; 14678 (5:4678)
	call Func_15636
	call $4226
	ret

Func_1467f: ; 1467f (5:467f)
	call $5b72
	ret

Func_14683: ; 14683 (5:4683)
	call $5b72
	ret

Func_14687: ; 14687 (5:4687)
	call $41e5
	ret

; AI for general decks i think
Func_1468b: ; 1468b (5:468b)
	call Func_15649
	ld a, $1
	call Func_14663
	farcall $8, $67d3
	jp nc, $4776
	farcall $8, $6790
	farcall $8, $66a3
	farcall $8, $637f
	ret c
	farcall $8, $662d
	ld a, $2
	call Func_14663
	ld a, $3
	call Func_14663
	ld a, $4
	call Func_14663
	call $5eae
	ret c
	ld a, $5
	call Func_14663
	ld a, $6
	call Func_14663
	ld a, $7
	call Func_14663
	ld a, $8
	call Func_14663
	call $4786
	ld a, $a
	call Func_14663
	ld a, $b
	call Func_14663
	ld a, $c
	call Func_14663
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .asm_146ed
	call $64e8

.asm_146ed
	call $5eae
	farcall $8, $66a3
	farcall $8, $637f
	ret c
	farcall $8, $6790
	ld a, $d
	farcall $8, $619b
	ld a, $d
	call Func_14663
	ld a, $f
	call Func_14663
	ld a, [wce20]
	and $4
	jr z, .asm_14776
	ld a, $1
	call Func_14663
	ld a, $2
	call Func_14663
	ld a, $3
	call Func_14663
	ld a, $4
	call Func_14663
	call $5eae
	ret c
	ld a, $5
	call Func_14663
	ld a, $6
	call Func_14663
	ld a, $7
	call Func_14663
	ld a, $8
	call Func_14663
	call $4786
	ld a, $a
	call Func_14663
	ld a, $b
	call Func_14663
	ld a, $c
	call Func_14663
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .asm_1475b
	call $64e8

.asm_1475b
	call $5eae
	farcall $8, $66a3
	farcall $8, $637f
	ret c
	farcall $8, $6790
	ld a, $d
	farcall $8, $619b
	ld a, $d
	call Func_14663

.asm_14776
	ld a, $e
	farcall $8, $619b
	call $69f8
	ret c
	ld a, $5
	bank1call AIMakeDecision
	ret
; 0x14786

	INCROM $14786, $1514f

; these seem to be lists of card IDs
; for the AI to look up in their hand
Data_1514f: ; 1514f (5:514f)
	db KANGASKHAN
	db CHANSEY
	db SNORLAX
	db MR_MIME
	db ABRA
	db $00

	db ABRA
	db MR_MIME
	db KANGASKHAN
	db SNORLAX
	db CHANSEY
	db $00

	INCROM $1515b, $15636

Func_15636: ; 15636 (5:5636)
	ld a, $10
	ld hl, wcda5
	call ZeroData
	ld a, $5
	ld [wcda6], a
	ld a, $ff
	ld [wcda5], a
	ret

Func_15649: ; 15649 (5:5649)
	ld a, [wcda6]
	inc a
	ld [wcda6], a
	xor a
	ld [wce20], a
	ld [wcddb], a
	ld [wcddc], a
	ld [wce03], a
	ld a, [wPlayerAttackingMoveIndex]
	cp $ff
	jr z, .asm_156b1
	or a
	jr z, .asm_156b1
	ld a, [wPlayerAttackingCardIndex]
	cp $ff
	jr z, .asm_156b1
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MEWTWO1 ; I believe this is a check for Mewtwo1's Barrier move
	jr nz, .asm_156b1
	ld a, [wcda7]
	bit 7, a
	jr nz, .asm_156aa
	inc a
	ld [wcda7], a
	cp $3
	jr c, .asm_156c2
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MEWTWO1
	jr nz, .asm_156a4
	farcall $8, $67a9
	jr nc, .asm_156aa

.asm_156a4
	xor a
	ld [wcda7], a
	jr .asm_156c2

.asm_156aa
	ld a, $80
	ld [wcda7], a
	jr .asm_156c2

.asm_156b1
	ld a, [wcda7]
	bit 7, a
	jr z, .asm_156be
	inc a
	ld [wcda7], a
	jr .asm_156c2

.asm_156be
	xor a
	ld [wcda7], a

.asm_156c2
	ret
; 0x156c3

	INCROM $156c3, $1575e

; zeroes a bytes starting at hl
ZeroData: ; 1575e (5:575e)
	push af
	push bc
	push hl
	ld b, a
	xor a
.clear_loop
	ld [hli], a
	dec b
	jr nz, .clear_loop
	pop hl
	pop bc
	pop af
	ret
; 0x1576b

	INCROM $1576b, $158b2

Func_158b2 ; 158b2 (5:58b2)
	INCROM $158b2, $15b72

Func_15b72 ; 15b72 (5:5b72)
	INCROM $15b72, $15d4f

Func_15d4f ; 15d4f (5:5d4f)
	INCROM $15d4f, $15ea6

; Copy cards from wDuelTempList to wHandTempList
CopyHandCardList: ; 15ea6 (5:5ea6)
	ld a, [hli]
	ld [de], a
	cp $ff
	ret z
	inc de
	jr CopyHandCardList

Func_15eae: ; 15eae (5:5eae)
	call CreateHandCardList
	call SortTempDeckByIdList
	ld hl, wDuelTempList
	ld de, wHandTempList
	call CopyHandCardList
	ld hl, wHandTempList

.next_card
	ld a, [hli]
	cp $ff
	jp z, Func_15f4c

	ld [wcdf3], a
	push hl
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .skip
	; skip non-pokemon cards

	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .skip
	; skip non-basic pokemon

	ld a, $82
	ld [wcdbe], a
	call Func_161d5
	ld a, $ef
	call GetTurnDuelistVariable
	cp $04
	jr c, .asm_15ef2
	ld a, $14
	call Func_1410a
	jr .asm_15ef7
.asm_15ef2
	ld a, $32
	call Func_140fe
.asm_15ef7
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call Func_173b1
	jr nc, .asm_15f04
	ld a, $14
	call Func_140fe
.asm_15f04
	ld a, [wcdf3]
	call Func_163c9
	call Func_1637b
	jr nc, .asm_15f14
	ld a, $14
	call Func_140fe
.asm_15f14
	ld a, [wcdf3]
	call Func_16422
	jr nc, .asm_15f21
	ld a, $14
	call Func_140fe
.asm_15f21
	ld a, [wcdf3]
	call Func_16451
	jr nc, .asm_15f2e
	ld a, $0a
	call Func_140fe
.asm_15f2e
	ld a, [wcdbe]
	cp $b4
	jr c, .skip
	ld a, [wcdf3]
	ldh [hTemp_ffa0], a
	call Func_1433d
	jr c, .skip
	ld a, $01
	bank1call AIMakeDecision
	jr c, .done
.skip
	pop hl
	jp .next_card
.done
	pop hl
	ret

Func_15f4c ; 15f4c (5:5f4c)
	INCROM $15f4c, $161d5

Func_161d5: ; 161d5 (5:61d5)
; check if deck applies
	ld a, [wOpponentDeckID]
	cp LEGENDARY_ZAPDOS_DECK_ID
	jr z, .begin
	cp LEGENDARY_ARTICUNO_DECK_ID
	jr z, .begin
	cp LEGENDARY_RONALD_DECK_ID
	jr z, .begin
	ret

; check if card applies
.begin
	ld a, [wLoadedCard1ID]
	cp ARTICUNO2
	jr z, .articuno
	cp MOLTRES2
	jr z, .moltres
	cp ZAPDOS3
	jr z, .zapdos
	ret

.articuno
	; exit if not enough Pokemon in Play Area
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 2
	ret c

	call Func_1628f
	jr c, .asm_16258
	call Func_162a1
	jr nc, .asm_16258
	call Func_158b2
	jr c, .asm_16258
	
	; checks for player's active card status
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	and CNF_SLP_PRZ
	or a
	jr nz, .asm_16258

	; checks for player's Pokemon Power
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld e, $00
	call CopyMoveDataAndDamage_FromDeckIndex
	call SwapTurn
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr z, .check_muk_and_snorlax

	; return if no space on the bench
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_BENCH_POKEMON
	jr c, .check_muk_and_snorlax
	ret

.check_muk_and_snorlax
	; checks for Muk in both Play Areas
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .asm_16258
	; checks if player's active card is Snorlax
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp SNORLAX
	jr z, .asm_16258

	ld a, $46
	call Func_140fe
	ret
.asm_16258
	ld a, $64
	call Func_1410a
	ret

.moltres
	; checks if there's enough cards in deck
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp $38 ; max number of cards not in deck to activate
	jr nc, .asm_16258
	ret

.zapdos
	; checks for Muk in both Play Areas
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .asm_16258
	ret
; 0x16270

	INCROM $16270, $1628f

Func_1628f: ; 1628f (5:628f)
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call Func_140ae
	jr nc, .asm_1629f
	call Func_1424b
	jp c, .asm_1629f
	scf
	ret
.asm_1629f
	or a
	ret
; 0x162a1

Func_162a1 ; 162a1 (5:62a1)
	INCROM $162a1, $1633f

; Goes through $00 terminated list pointed 
; by wcdae and compares it to each card in hand.
; Sorts the hand in wDuelTempList so that the found card IDs
; are in the same order as the list pointed by de.
SortTempDeckByIdList: ; 1633f (5:633f)
	ld a, [wcdaf]
	or a
	ret z
	ld d, a
	ld a, [wcdae]
	ld e, a
	ld c, $00
.next_id
	ld a, [de]
	or a
	ret z
	inc de
	ld hl, wDuelTempList
	ld b, $00
	add hl, bc

	ld b, a
.next_card
	ld a, [hl]
	ldh [hTempCardIndex_ff98], a
	cp $ff
	jr z, .next_id
	push bc
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	pop bc
	cp b
	jr nz, .not_same

; found
	push bc
	push hl
	ld b, $00
	ld hl, wDuelTempList
	add hl, bc
	ld b, [hl]
	ldh a, [hTempCardIndex_ff98]
	ld [hl], a
	pop hl
	ld [hl], b
	pop bc
	inc c
.not_same
	inc hl
	jr .next_card
; 0x1637b

Func_1637b ; 1637b (5:637b)
	INCROM $1637b, $163c9

Func_163c9 ; 163c9 (5:63c9)
	INCROM $163c9, $16422

Func_16422 ; 16422 (5:6422)
	INCROM $16422, $16451

Func_16451 ; 16451 (5:6451)
	INCROM $16451, $164e8

Func_164e8 ; 164e8 (5:64e8)
	INCROM $164e8, $169f8

Func_169f8 ; 169f8 (5:69f8)
	INCROM $169f8, $173b1

Func_173b1 ; 173b1 (5:73b1)
	INCROM $173b1, $18000