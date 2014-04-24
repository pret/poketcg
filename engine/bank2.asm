INCBIN "baserom.gbc",$8000,$8cf9 - $8000

Func_8cf9: ; 8cf9 (2:4cf9)
	call Func_07b6
	xor a
	ld hl, $b703
	ld [hli], a
	inc a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [$b701], a
	call Func_07be
	ld hl, Unknown_8d15
	ld de, $9380
	call Func_92ad
	ret

Unknown_8d15: ; 8d15 (2:4d15)
INCBIN "baserom.gbc",$8d15,$8db0 - $8d15

Func_8db0: ; 8db0 (2:4db0)
INCBIN "baserom.gbc",$8db0,$92ad - $8db0

Func_92ad: ; 92ad (2:52ad)
	ld a, [hli]
	ld [de], a
	or a
	ret z
	inc de
	jr Func_92ad
; 0x92b4

INCBIN "baserom.gbc",$92b4,$a288 - $92b4

Func_a288: ; a288 (2:6288)
INCBIN "baserom.gbc",$a288,$c000 - $a288