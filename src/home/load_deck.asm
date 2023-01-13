; loads the deck id in a from DeckPointers and copies it to wPlayerDeck or to
; wOpponentDeck, depending on whose turn it is.
; sets carry flag if an invalid deck id is used.
LoadDeck::
	push hl
	ld l, a
	ld h, $0
	ldh a, [hBankROM]
	push af
	ld a, BANK(DeckPointers)
	call BankswitchROM
	add hl, hl
	ld de, DeckPointers
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, d
	or e
	jr z, .null_pointer
	call CopyDeckData
	pop af
	call BankswitchROM
	pop hl
	or a
	ret
.null_pointer
	pop af
	call BankswitchROM
	pop hl
	scf
	ret
