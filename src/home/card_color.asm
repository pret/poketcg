; return the turn holder's arena card's color in a, accounting for Venomoth's Shift Pokemon Power if active
GetArenaCardColor::
	xor a ; PLAY_AREA_ARENA
;	fallthrough

; input: a = play area location offset (PLAY_AREA_*) of the desired card
; return the turn holder's card's color in a, accounting for Venomoth's Shift Pokemon Power if active
GetPlayAreaCardColor::
	push hl
	push de
	ld e, a
	add DUELVARS_ARENA_CARD_CHANGED_TYPE
	call GetTurnDuelistVariable
	bit HAS_CHANGED_COLOR_F, a
	jr nz, .has_changed_color
.regular_color
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	call GetCardType
	cp TYPE_TRAINER
	jr nz, .got_type
	ld a, COLORLESS
.got_type
	pop de
	pop hl
	ret
.has_changed_color
	ld a, e
	call CheckIsIncapableOfUsingPkmnPower
	jr c, .regular_color ; jump if can't use Shift
	ld a, e
	add DUELVARS_ARENA_CARD_CHANGED_TYPE
	call GetTurnDuelistVariable
	pop de
	pop hl
	and $f
	ret

; return in a the weakness of the turn holder's arena or benchx Pokemon given the PLAY_AREA_* value in a
; if a == 0 and [DUELVARS_ARENA_CARD_CHANGED_WEAKNESS] != 0,
; return [DUELVARS_ARENA_CARD_CHANGED_WEAKNESS] instead
GetPlayAreaCardWeakness::
	or a
	jr z, GetArenaCardWeakness
	add DUELVARS_ARENA_CARD
	jr GetCardWeakness

; return in a the weakness of the turn holder's arena Pokemon
; if [DUELVARS_ARENA_CARD_CHANGED_WEAKNESS] != 0, return it instead
GetArenaCardWeakness::
	ld a, DUELVARS_ARENA_CARD_CHANGED_WEAKNESS
	call GetTurnDuelistVariable
	or a
	ret nz
	ld a, DUELVARS_ARENA_CARD
;	fallthrough

GetCardWeakness::
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Weakness]
	ret

; return in a the resistance of the turn holder's arena or benchx Pokemon given the PLAY_AREA_* value in a
; if a == 0 and [DUELVARS_ARENA_CARD_CHANGED_RESISTANCE] != 0,
; return [DUELVARS_ARENA_CARD_CHANGED_RESISTANCE] instead
GetPlayAreaCardResistance::
	or a
	jr z, GetArenaCardResistance
	add DUELVARS_ARENA_CARD
	jr GetCardResistance

; return in a the resistance of the arena Pokemon
; if [DUELVARS_ARENA_CARD_CHANGED_RESISTANCE] != 0, return it instead
GetArenaCardResistance::
	ld a, DUELVARS_ARENA_CARD_CHANGED_RESISTANCE
	call GetTurnDuelistVariable
	or a
	ret nz
	ld a, DUELVARS_ARENA_CARD
;	fallthrough

GetCardResistance::
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Resistance]
	ret

; this function checks if turn holder's CHARIZARD energy burn is active, and if so, turns
; all energies at wAttachedEnergies except double colorless energies into fire energies
HandleEnergyBurn::
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp CHARIZARD
	ret nz
	xor a ; PLAY_AREA_ARENA
	call CheckIsIncapableOfUsingPkmnPower
	ret c
	ld hl, wAttachedEnergies
	ld c, NUM_COLORED_TYPES
	xor a
.zero_next_energy
	ld [hli], a
	dec c
	jr nz, .zero_next_energy
	ld a, [wTotalAttachedEnergies]
	ld [wAttachedEnergies], a
	ret
