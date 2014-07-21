Func_4000: ; 4000 (1:4000)
	di
	ld sp, $e000
	call Func_0ea6
	call EnableInt_VBlank
	call EnableInt_Timer
	call EnableExtRAM
	ld a, [$a006]
	ld [$ce47], a
	ld a, [$a009]
	ld [$ccf2], a
	call DisableExtRAM
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
	call EnableExtRAM
	xor a
	ld [$a000], a
	call DisableExtRAM
.asm_404d
	jp Func_051b

Func_4050: ; 4050 (1:4050)
	farcall Func_1996e
	ld a, $1
	ld [$cd0d], a
	ret

Func_405a: ; 405a (1:405a)
INCBIN "baserom.gbc",$405a,$406f - $405a

Func_406f: ; 406f (1:406f)
INCBIN "baserom.gbc",$406f,$409f - $406f

Func_409f: ; 409f (1:409f)
INCBIN "baserom.gbc",$409f,$5aeb - $409f

Func_5aeb: ; 5aeb (1:5aeb)
INCBIN "baserom.gbc",$5aeb,$6785 - $5aeb

Func_6785: ; 6785 (1:6785)
INCBIN "baserom.gbc",$6785,$7354 - $6785

BuildVersion: ; 7354 (1:7354)
	db "VER 12/20 09:36",TX_END

INCBIN "baserom.gbc",$7364,$7571 - $7364

Func_7571: ; 7571 (1:7571)
INCBIN "baserom.gbc",$7571,$758f - $7571

Func_758f: ; 758f (1:758f)
INCBIN "baserom.gbc",$758f,$8000 - $758f
