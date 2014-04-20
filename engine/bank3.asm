INCBIN "baserom.gbc",$c000,$c5d5 - $c000

Func_c5d5: ; c5d5 (3:45d5)
	push hl
	ld hl, Unknown_c5e5
	or a
	jr z, .asm_c5e2
.asm_c5dc
	rlca
	jr c, .asm_c5e2
	inc hl
	jr .asm_c5dc
.asm_c5e2
	ld a, [hl]
	pop hl
	ret

Unknown_c5e5: ; c5e5 (3:45e5)
	db $02,$00,$03,$01

Func_c5e9: ; c5e9 (3:45e9)
	push bc
	ld a, [$d336]
	ld [$d4cf], a
	ld a, [$d337]
	ld b, a
	ld a, [$d334]
	add b
	farcall Func_12ab5
	pop bc
	ret
; 0xc5fe

INCBIN "baserom.gbc",$c5fe,$ca6c - $c5fe

Func_ca6c: ; ca6c (3:4a6c)
	push hl
	push bc
	call Func_cb1d
	ld c, [hl]
	ld a, [$d3d1]
.asm_ca75
	bit 0, a
	jr nz, .asm_ca7f
	srl a
	srl c
	jr .asm_ca75
.asm_ca7f
	and c
	pop bc
	pop hl
	or a
	ret
; 0xca84

INCBIN "baserom.gbc",$ca84,$cb1d - $ca84

Func_cb1d: ; cb1d (3:4b1d)
	push bc
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, Unknown_cb37
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld [$d3d1], a
	ld b, $0
	ld hl, $d3d2
	add hl, bc
	pop bc
	ret

Unknown_cb37: ; cb37 (3:4b37)
INCBIN "baserom.gbc",$cb37,$cc42 - $cb37

RST20: ; cc42 (3:4c42)
	pop hl
	ld a, l
	ld [$d413], a
	ld a, h
	ld [$d414], a
	xor a
	ld [$d412], a
.asm_cc4f
	call Func_3aed
	ld a, [$d412]
	or a
	jr z, .asm_cc4f
	ld hl, $d413
	ld a, [hli]
	ld c, a
	ld b, [hl]
	push bc
	ret
; 0xcc60

INCBIN "baserom.gbc",$cc60,$10000 - $cc60