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

	INCROM $1409e, $140fe

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

	INCROM $1424b, $1433d

Func_1433d: ; 1433d (5:433d)
	INCROM $1433d, $14663

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

	INCROM $14786, $15636

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

Func_15ea6 ; 15ea6 (5:5ea6)
	INCROM $15ea6, $15eae

Func_15eae: ; 15eae (5:5eae)
	call CreateHandCardList
	call Func_1633f
	ld hl, wDuelTempList
	ld de, $ceda
	call Func_15ea6
	ld hl, $ceda
.asm_15ec0
	ld a, [hli]
	cp $ff
	jp z, Func_15f4c
	ld [$cdf3], a
	push hl
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp $08
	jr nc, .asm_15f46
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .asm_15f46
	ld a, $82
	ld [$cdbe], a
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
	ld a, [$cdf3]
	call Func_163c9
	call Func_1637b
	jr nc, .asm_15f14
	ld a, $14
	call Func_140fe
.asm_15f14
	ld a, [$cdf3]
	call Func_16422
	jr nc, .asm_15f21
	ld a, $14
	call Func_140fe
.asm_15f21
	ld a, [$cdf3]
	call Func_16451
	jr nc, .asm_15f2e
	ld a, $0a
	call Func_140fe
.asm_15f2e
	ld a, [$cdbe]
	cp $b4
	jr c, .asm_15f46
	ld a, [$cdf3]
	ldh [hTemp_ffa0], a
	call Func_1433d
	jr c, .asm_15f46
	ld a, $01
	bank1call AIMakeDecision
	jr c, .asm_15f4a
.asm_15f46
	pop hl
	jp .asm_15ec0
.asm_15f4a
	pop hl
	ret

Func_15f4c ; 15f4c (5:5f4c)
	INCROM $15f4c, $161d5

Func_161d5 ; 161d5 (5:61d5)
	INCROM $161d5, $1633f

Func_1633f ; 1633f (5:633f)
	INCROM $1633f, $1637b

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