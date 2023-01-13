; function that executes one or more consecutive coin tosses during a duel (a = number of coin tosses),
; displaying each result ([O] or [X]) starting from the top left corner of the screen.
; text at de is printed in a text box during the coin toss.
; returns: the number of heads in a and in wCoinTossNumHeads, and carry if at least one heads
TossCoinATimes::
	push hl
	ld hl, wCoinTossScreenTextID
	ld [hl], e
	inc hl
	ld [hl], d
	bank1call _TossCoin
	pop hl
	ret

; function that executes a single coin toss during a duel.
; text at de is printed in a text box during the coin toss.
; returns: - carry, and 1 in a and in wCoinTossNumHeads if heads
;          - nc, and 0 in a and in wCoinTossNumHeads if tails
TossCoin::
	push hl
	ld hl, wCoinTossScreenTextID
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, 1
	bank1call _TossCoin
	ld hl, wDuelDisplayedScreen
	ld [hl], 0
	pop hl
	ret

; cp de, bc
CompareDEtoBC::
	ld a, d
	cp b
	ret nz
	ld a, e
	cp c
	ret
