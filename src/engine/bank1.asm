Func_4000: ; 4000 (1:4000)
	di
	ld sp, $e000
	call ResetSerial
	call EnableInt_VBlank
	call EnableInt_Timer
	call EnableExtRAM
	ld a, [$a006]
	ld [$ce47], a
	ld a, [$a009]
	ld [$ccf2], a
	call DisableExtRAM
	ld a, $1
	ld [wUppercaseFlag], a
	ei
	farcall Func_1a6cc
	ld a, [hButtonsHeld]
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
	jp Reset

Func_4050: ; 4050 (1:4050)
	farcall Func_1996e
	ld a, $1
	ld [wUppercaseFlag], a
	ret

Func_405a: ; 405a (1:405a)
INCBIN "baserom.gbc",$405a,$406f - $405a

Func_406f: ; 406f (1:406f)
INCBIN "baserom.gbc",$406f,$409f - $406f

; this function begins the duel after the opponent's
; graphics, name and deck have been introduced
StartDuel: ; 409f (1:409f)
	ld a, $c2
	ld [hWhoseTurn], a
	ld a, $0
	ld [$c2f1], a
	ld a, [$cc19]
	ld [wOpponentDeckId], a
	call LoadPlayerDeck
	call GetOpposingTurnDuelistVariable_SwapTurn
	call LoadOpponentDeck
	call GetOpposingTurnDuelistVariable_SwapTurn
	jr .asm_40ca

	ld a, MUSIC_DUELTHEME1
	ld [wDuelTheme], a
	ld hl, $cc16
	xor a
	ld [hli], a
	ld [hl], a
	ld [wIsPracticeDuel], a

.asm_40ca
	ld hl, [sp+$0]
	ld a, l
	ld [$cbe5], a
	ld a, h
	ld [$cbe6], a
	xor a
	ld [$cbc6], a
	call $420b
	ld a, [$cc18]
	ld [$cc08], a
	call $70aa
	ld a, [wDuelTheme]
	call PlaySong
	call $4b60
	ret c

; the loop returns here after every turn switch
.mainDuelLoop
	xor a
	ld [$cbc6], a
	call $35e6
	call $54c8
	call $4225
	call $0f58
	ld a, [$cc07]
	or a
	jr nz, .asm_4136
	call $35fa
	call $6baf
	call $3b31
	call $0f58
	ld a, [$cc07]
	or a
	jr nz, .asm_4136
	ld hl, $cc06
	inc [hl]
	ld a, [$cc09]
	cp $80
	jr z, .asm_4126
.asm_4121
	call GetOpposingTurnDuelistVariable_SwapTurn
	jr .mainDuelLoop

.asm_4126
	ld a, [wIsPracticeDuel]
	or a
	jr z, .asm_4121
	ld a, [hl]
	cp $f
	jr c, .asm_4121
	xor a
	ld [$d0c3], a
	ret

.asm_4136
	call $5990
	call Func_04a2
	ld a, $3
	call $2167
	ld hl, $0076
	call DrawWideTextBox_WaitForInput
	call Func_04a2
	ld a, [hWhoseTurn]
	push af
	ld a, $c2
	ld [hWhoseTurn], a
	call $4a97
	call $4ad6
	pop af
	ld [hWhoseTurn], a
	call $3b21
	ld a, [$cc07]
	cp $1
	jr z, .asm_4171
	cp $2
	jr z, .asm_4184
	ld a, $5f
	ld c, $1a
	ld hl, $0077
	jr .asm_4196

.asm_4171
	ld a, [hWhoseTurn]
	cp $c2
	jr nz, .asm_418a
.asm_4177
	xor a
	ld [$d0c3], a
	ld a, $5d
	ld c, $18
	ld hl, $0078
	jr .asm_4196

.asm_4184
	ld a, [hWhoseTurn]
	cp $c2
	jr nz, .asm_4177

.asm_418a
	ld a, $1
	ld [$d0c3], a
	ld a, $5e
	ld c, $19
	ld hl, $0079

.asm_4196
	call $3b6a
	ld a, c
	call PlaySong
	ld a, $c3
	ld [hWhoseTurn], a
	call DrawWideTextBox_PrintText
	call EnableLCD
.asm_41a7
	call DoFrame
	call Func_378a
	or a
	jr nz, .asm_41a7
	ld a, [$cc07]
	cp $3
	jr z, .asm_41c8
	call Func_39fc
	call WaitForWideTextBoxInput
	call $3b31
	call ResetSerial
	ld a, $c2
	ld [hWhoseTurn], a
	ret

.asm_41c8
	call WaitForWideTextBoxInput
	call $3b31
	ld a, [wDuelTheme]
	call PlaySong
	ld hl, $007a
	call DrawWideTextBox_WaitForInput
	ld a, $1
	ld [$cc08], a
	call $70aa
	ld a, [$cc09]
	cp $1
	jr z, .asm_41f3
	ld a, $c2
	ld [hWhoseTurn], a
	call $4b60
	jp $40ee

.asm_41f3
	call $0f58
	ld h, $c2
	ld a, [wSerialOp]
	cp $29
	jr z, .asm_4201
	ld h, $c3

.asm_4201
	ld a, h
	ld [hWhoseTurn], a
	call $4b60
	jp nc, $40ee
	ret
; 0x420b

INCBIN "baserom.gbc",$420b,$5aeb - $420b

Func_5aeb: ; 5aeb (1:5aeb)
INCBIN "baserom.gbc",$5aeb,$6785 - $5aeb

Func_6785: ; 6785 (1:6785)
INCBIN "baserom.gbc",$6785,$6793 - $6785

; loads player deck from SRAM to wPlayerDeck
LoadPlayerDeck: ; 6793 (1:6793)
	call EnableExtRAM
	ld a, [$b700]
	ld l, a
	ld h, $54
	call HtimesL
	ld de, $a218
	add hl, de
	ld de, wPlayerDeck
	ld c, DECK_SIZE
.nextCardLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .nextCardLoop
	call DisableExtRAM
	ret
; 0x67b2

INCBIN "baserom.gbc",$67b2,$7107 - $67b2

; initializes duel variables such as cards in deck and in hand, or Pokemon in play area
; player turn: [c200, c2ff]
; opponent turn: [c300, c3ff]
InitializeDuelVariables: ; 7107 (1:7107)
	ld a, [hWhoseTurn]
	ld h, a
	ld l, wPlayerDuelistType & $ff
	ld a, [hl]
	push hl
	push af
	xor a
	ld l, a
.zeroDuelVariablesLoop
	ld [hl], a
	inc l
	jr nz, .zeroDuelVariablesLoop
	pop af
	pop hl
	ld [hl], a
	ld bc, DECK_SIZE ; lb bc, wPlayerCardLocations & $ff, DECK_SIZE
	ld l, wPlayerDeckCards & $ff
.initDuelVariablesLoop
; zero card locations and cards in hand, and init order of cards in deck
	push hl
	ld [hl], b
	ld l, b
	ld [hl], $0
	pop hl
	inc l
	inc b
	dec c
	jr nz, .initDuelVariablesLoop
	ld l, wPlayerArenaCard & $ff
	ld c, 1 + BENCH_SIZE + 1
.initPlayArea
; initialize to $ff card in arena as well as cards in bench (plus a terminator?)
	ld [hl], $ff
	inc l
	dec c
	jr nz, .initPlayArea
	ret
; 0x7133

INCBIN "baserom.gbc",$7133,$7354 - $7133

BuildVersion: ; 7354 (1:7354)
	db "VER 12/20 09:36",TX_END

INCBIN "baserom.gbc",$7364,$7571 - $7364

Func_7571: ; 7571 (1:7571)
INCBIN "baserom.gbc",$7571,$758f - $7571

Func_758f: ; 758f (1:758f)
INCBIN "baserom.gbc",$758f,$8000 - $758f
