INCBIN "baserom.gbc",$1c000,$1c056 - $1c000

Func_1c056: ; 1c056 (7:4056)
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0005
	ld a, [wPlayerXCoord]
	ld d, a
	ld a, [wPlayerYCoord]
	ld e, a
.asm_1c072
	ld a, [hli]
	or [hl]
	jr z, .asm_1c095
	ld a, [hld]
	cp e
	jr nz, .asm_1c07e
	ld a, [hl]
	cp d
	jr z, .asm_1c081
.asm_1c07e
	add hl, bc
	jr .asm_1c072
.asm_1c081
	inc hl
	inc hl
	ld a, [hli]
	ld [$d0bb], a
	ld a, [hli]
	ld [$d0bc], a
	ld a, [hli]
	ld [$d0bd], a
	ld a, [$d334]
	ld [$d0be], a
.asm_1c095
	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/warp_data.asm"

Func_1c33b: ; 1c33b (7:433b)
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	add a
	add c
	ld c, a
	ld b, $0
	ld hl, MapSongs
	add hl, bc
	ld a, [hli]
	ld [$d131], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld [$d28f], a
	ld a, [hli]
	ld [$d132], a
	ld a, [hli]
	ld [$d290], a
	ld a, [hli]
	ld [$d111], a
	ld a, [$cab4]
	cp $2
	jr nz, .asm_1c370
	ld a, c
	or a
	jr z, .asm_1c370
	ld [$d131], a
.asm_1c370
	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/map_songs.asm"

Func_1c440: ; 1c440 (7:4440)
INCBIN "baserom.gbc",$1c440,$1c485 - $1c440

Func_1c485: ; 1c485 (7:4485)
INCBIN "baserom.gbc",$1c485,$1c58e - $1c485

Func_1c58e: ; 1c58e (7:458e)
INCBIN "baserom.gbc",$1c58e,$1c5e9 - $1c58e

Func_1c5e9: ; 1c5e9 (7:45e9)
INCBIN "baserom.gbc",$1c5e9,$1c610 - $1c5e9

Func_1c610: ; 1c610 (7:4610)
INCBIN "baserom.gbc",$1c610,$1c6f8 - $1c610

Func_1c6f8: ; 1c6f8 (7:46f8)
INCBIN "baserom.gbc",$1c6f8,$1c72e - $1c6f8

Func_1c72e: ; 1c72e (7:472e)
INCBIN "baserom.gbc",$1c72e,$1c768 - $1c72e

Func_1c768: ; 1c768 (7:4768)
INCBIN "baserom.gbc",$1c768,$1c82e - $1c768

Func_1c82e: ; 1c82e (7:482e)
INCBIN "baserom.gbc",$1c82e,$1d078 - $1c82e

Func_1d078: ; 1d078 (7:5078)
INCBIN "baserom.gbc",$1d078,$1d306 - $1d078

Func_1d306: ; 1d306 (7:5306)
INCBIN "baserom.gbc",$1d306,$1d6ad - $1d306

Func_1d6ad: ; 1d6ad (7:56ad)
INCBIN "baserom.gbc",$1d6ad,$20000 - $1d6ad
