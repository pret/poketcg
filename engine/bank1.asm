Func_4000: ; 4000 (1:4000)
	di
	ld sp, $e000
	call Func_0ea6
	call Func_02e4
	call Func_02dd
	call Func_07b6
	ld a, [$a006]
	ld [$ce47], a
	ld a, [$a009]
	ld [$ccf2], a
	call Func_07be
	ld a, $1
	ld [$cd0d], a
	ei
	farcall Func_1a6cc
	ld a, [$ff90]
	cp $3
	jr z, .asm_4035
	farcall Func_126d1
	jr Func_4000
.asm_4035
	call Func_405a
	call Func_04a2
	ld hl, $00a2
	call Func_2af0
	jr c, .asm_404d
	call Func_07b6
	xor a
	ld [$a000], a
	call Func_07be
.asm_404d
	jp Func_051b

Func_4050: ; 4050 (1:4050)
	farcall Func_1996e
	ld a, $1
	ld [$cd0d], a
	ret

Func_405a: ; 405a (1:405a)
INCBIN "baserom.gbc",$405a,$6785 - $405a

Func_6785: ; 6785 (1:6785)
INCBIN "baserom.gbc",$6785,$7571 - $6785

Func_7571: ; 7571 (1:7571)
INCBIN "baserom.gbc",$7571,$8000 - $7571