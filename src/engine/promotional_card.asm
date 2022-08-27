; shows screen with the promotional card and received text
; depending on input a
; if $0 = Legendary Molters, Articuno, Zapdos and Dragonite cards
; otherwise, a card ID
_ShowPromotionalCardScreen:
	push af
	lb de, $38, $9f
	call SetupText
	pop af
	or a
	jr nz, .else
	ld a, MOLTRES_LV37
	call .legendary_card_text
	ld a, ARTICUNO_LV37
	call .legendary_card_text
	ld a, ZAPDOS_LV68
	call .legendary_card_text
	ld a, DRAGONITE_LV41
.legendary_card_text
	ldtx hl, ReceivedLegendaryCardText
	jr .print_text
.else
	ldtx hl, ReceivedCardText
	cp VILEPLUME
	jr z, .print_text
	cp BLASTOISE
	jr z, .print_text
	ldtx hl, ReceivedPromotionalFlyingPikachuText
	cp FLYING_PIKACHU
	jr z, .print_text
	ldtx hl, ReceivedPromotionalSurfingPikachuText
	cp SURFING_PIKACHU_LV13
	jr z, .print_text
	cp SURFING_PIKACHU_ALT_LV13
	jr z, .print_text
	ldtx hl, ReceivedPromotionalCardText
.print_text
	push hl
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer1_FromCardID
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bank1call LoadTxRam2 ; switch to bank 1, but call a home func
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	pop hl
	bank1call _DisplayCardDetailScreen
.loop
	call AssertSongFinished
	or a
	jr nz, .loop

	call ResumeSong
	bank1call OpenCardPage_FromHand
	ret
