_CopyCardNameAndLevel: ; 18000 (6:4000)
	push bc
	push de
	ld [wcd9b], a
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDefaultText
	push de
	call CopyText ; copy card name to wDefaultText
	pop hl
	ld a, [hli]
	cp TX_HALFWIDTH
	jp z, Func_18086
	ld a, [wcd9b]
	ld c, a
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .level_done ; jump if energy or trainer
	ld a, [wLoadedCard1Level]
	or a
	jr z, .level_done
	inc c
	inc c
	ld a, [wLoadedCard1Level]
	cp 10
	jr c, .level_done
	inc c ; second digit
.level_done
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDefaultText
	push de
	call CopyText
	pop hl
	push de
	ld e, c
	call GetTextSizeInTiles
	add e
	ld c, a
	pop hl
	push hl
.fill_loop
	ld a, $70
	ld [hli], a
	dec c
	jr nz, .fill_loop
	ld [hl], TX_END
	pop hl
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .done
	ld a, [wLoadedCard1Level]
	or a
	jr z, .done
	ld a, TX_SYMBOL
	ld [hli], a
	ld [hl], SYM_Lv
	inc hl
	ld a, [wLoadedCard1Level]
	cp 10
	jr c, .one_digit
	ld [hl], TX_SYMBOL
	inc hl
	ld b, SYM_0 - 1
.first_digit_loop
	inc b
	sub 10
	jr nc, .first_digit_loop
	add 10
	ld [hl], b ; first digit
	inc hl
.one_digit
	ld [hl], TX_SYMBOL
	inc hl
	add SYM_0
	ld [hl], a ; last (or only) digit
	inc hl
.done
	pop de
	pop bc
	ret
; 0x18086

Func_18086: ; 18086 (6:4086)
	ld a, [wcd9b]
	inc a
	add a
	ld b, a
	ld hl, wDefaultText
.find_end_text_loop
	dec b
	ld a, [hli]
	or a ; TX_END
	jr nz, .find_end_text_loop
	dec hl
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .level_done
	ld a, [wLoadedCard1Level]
	or a
	jr z, .level_done
	ld c, a
	ld a, " "
	ld [hli], a
	dec b
	ld a, "L"
	ld [hli], a
	dec b
	ld a, "v"
	ld [hli], a
	dec b
	ld a, c
	cp 10
	jr c, .got_level
	push bc
	ld b, "0" - 1
.first_digit_loop
	inc b
	sub 10
	jr nc, .first_digit_loop
	add 10
	ld [hl], b ; first digit
	inc hl
	pop bc
	ld c, a
	dec b
.got_level
	ld a, c
	add "0"
	ld [hli], a ; last (or only) digit
	dec b
.level_done
	push hl
	ld a, " "
.fill_spaces_loop
	ld [hli], a
	dec b
	jr nz, .fill_spaces_loop
	ld [hl], TX_END
	pop hl
	pop de
	pop bc
	ret
; 0x180d5

Func_180d5: ; 180d5 (6:40d5)
	INCROM $180d5, $186f7

INCLUDE "data/effect_commands.asm"

	INCROM $18f9c, $1996e

Func_1996e: ; 1996e (6:596e)
	call EnableSRAM
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ld hl, sCardCollection
	ld bc, $1607
.asm_1997b
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_1997b
	ld a, $5
	ld hl, s0a350
	call Func_199e0
	ld a, $7
	ld hl, s0a3a4
	call Func_199e0
	ld a, $9
	ld hl, s0a3f8
	call Func_199e0
	call EnableSRAM
	ld hl, sCardCollection
	ld a, CARD_NOT_OWNED
.asm_199a2
	ld [hl], a
	inc l
	jr nz, .asm_199a2
	ld hl, $bc00
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $bb00
	ld c, $10
.asm_199b2
	ld [hl], $0
	ld de, $0010
	add hl, de
	dec c
	jr nz, .asm_199b2
	ld a, $2
	ld [s0a003], a
	ld a, $2
	ld [s0a006], a
	ld [wTextSpeed], a
	xor a
	ld [s0a007], a
	ld [s0a009], a
	ld [s0a004], a
	ld [s0a005], a
	ld [s0a00a], a
	farcall Func_8cf9
	call DisableSRAM
	ret

Func_199e0: ; 199e0 (6:59e0)
	push de
	push bc
	push hl
	call LoadDeck
	jr c, .asm_19a0e
	call Func_19a12
	pop hl
	call EnableSRAM
	push hl
	ld de, wDefaultText
.asm_199f3
	ld a, [de]
	inc de
	ld [hli], a
	or a
	jr nz, .asm_199f3
	pop hl
	push hl
	ld de, $0018
	add hl, de
	ld de, wPlayerDeck
	ld c, $3c
.asm_19a04
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_19a04
	call DisableSRAM
	or a
.asm_19a0e
	pop hl
	pop bc
	pop de
	ret

Func_19a12: ; 19a12 (6:5a12)
	ld hl, wcce9
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDefaultText
	call CopyText
	ret
; 0x19a1f

	INCROM $19a1f, $1a61f

Func_1a61f: ; 1a61f (6:661f)
	push af
	lb de, $38, $9f
	call SetupText
	pop af
	or a
	jr nz, .asm_1a640
	ld a, $40
	call $663b
	ld a, $5f
	call $663b
	ld a, $76
	call $663b
	ld a, $c1
	ldtx hl, ReceivedLegendaryCardText
	jr .asm_1a660
.asm_1a640
	ldtx hl, ReceivedCardText
	cp $1e
	jr z, .asm_1a660
	cp $43
	jr z, .asm_1a660
	ldtx hl, ReceivedPromotionalFlyingPikachuText
	cp $64
	jr z, .asm_1a660
	ldtx hl, ReceivedPromotionalSurfingPikachuText
	cp $65
	jr z, .asm_1a660
	cp $66
	jr z, .asm_1a660
	ldtx hl, ReceivedPromotionalCardText
.asm_1a660
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
	bank1call $5e5f
.asm_1a680
	call AssertSongFinished
	or a
	jr nz, .asm_1a680

	call ResumeSong
	bank1call $5773
	ret
; 0x1a68d


    ld a, $c2
    ldh [$97], a
    ld h, a
    ld l, $00

jr_006_6694:
    xor a
    ld [hl+], a
    ld a, l
    cp $3c
    jr c, jr_006_6694

    xor a
    ld hl, $c400
    ld de, $c510
    ld c, $00

jr_006_66a4:
    ld a, [hl+]
    or a
    jr z, jr_006_66ae

    ld a, c
    ld [de], a
    inc de
    inc c
    jr jr_006_66a4

jr_006_66ae:
    ld a, $ff
    ld [de], a
    ld de, $389f
    call $2275
    rst $18
    sbc d
    ld d, l
    ld hl, $0056
    ld de, $0196
    rst $18
    add b
    ld d, l
    ld a, $09
    ld [$cbd6], a
    rst $18
    ldh a, [rHDMA5]
    ret

CommentedOut_1a6cc: ; 1a6cc (6:66cc)
    ret

    ldh a, [$81]
    or a
    ret nz

    push hl
    push de
    push bc
    ld hl, $a100
    ld bc, $0250
    ld a, [$a00b]
    ld e, a

jr_006_66de:
    ld a, [hl+]
    xor e
    ld e, a
    dec bc
    ld a, c
    or b
    jr nz, jr_006_66de

    ld a, e
    pop bc
    pop de
    pop hl
    or a
    ret z

    xor a
    ld [$cab6], a
    ld hl, $cad3
    ld [hl+], a
    ld [hl], a
    ldh [$92], a
    ldh [$93], a
    rst $18
    sub b
    ld e, c
    call $04a2
    call $2119
    rst $18
    db $eb
    ld e, d
    ld a, [$cab4]
    cp $01
    jr nz, jr_006_6719

    ld a, $e4
    ld [$cabd], a
    ld [$cabc], a
    ld a, $01
    ld [$cabf], a

jr_006_6719:
    ld de, $389f
    call $2275
    ld hl, $00a3
    rst $18
    rst $18
    ld d, a
    ld a, $0a
    ld [$0000], a
    xor a
    ldh [$81], a
    ld [$4000], a
    ld [$a000], a
    ld [$0000], a
    jp $051b


    ret


    ldh a, [$81]
    or a
    ret nz

    push hl
    push de
    push bc
    ld hl, $a100
    ld bc, $0250
    ld e, $00

jr_006_6749:
    ld a, [hl+]
    xor e
    ld e, a
    dec bc
    ld a, c
    or b
    jr nz, jr_006_6749

    ld a, $0a
    ld [$0000], a
    ld a, e
    ld [$a00b], a
    pop bc
    pop de
    pop hl
    ret


    ld bc, $1e01
    ld [bc], a
    rst $38
    ld [bc], a
    ld bc, $022b
    ld c, $01
    add hl, de
    ld [bc], a
    rst $38
    ld [bc], a
    ld bc, $022c
    ld c, $01
    add hl, de
    ld [bc], a
    rst $38
    ld [bc], a
    ld bc, $022d
    ld c, $01
    add hl, de
    ld [bc], a
    rst $38
    ld [bc], a
    ld bc, $022e
    ld c, $01
    add hl, de
    ld [bc], a
    rst $38

Call_006_6787:
    push af
    push bc
    push hl
    ld b, a
    xor a

jr_006_678c:
    ld [hl+], a
    dec b
    jr nz, jr_006_678c

    pop hl
    pop bc
    pop af
    ret


Call_006_6794:
    push af
    inc a
    jr z, jr_006_679c

    ld a, $02
    jr jr_006_679e

jr_006_679c:
    ld a, $03

jr_006_679e:
    call $3796
    pop af
    ret


    ld e, l
    ld d, h
    ld a, $0c
    ld hl, $675e
    ld bc, $0c01
    call Call_006_6846
    call Set_OBJ_8x8
    xor a
    ld [$cab6], a
    call EmptyScreen
    call ZeroObjectPositions
    ld a, $01
    ld [$cac0], a
    call LoadSymbolsFont
    ld de, $38bf
    call SetupText
    call Call_006_6a65
    ld a, $02
    ld [$d009], a
    call Call_006_6892
    xor a
    ld [$d006], a
    ld [$cea4], a
    ld a, $09
    ld [$d005], a
    ld a, $06
    ld [$cea9], a
    ld a, $0f
    ld [$ceaa], a
    ld a, $00
    ld [$ceab], a

jr_006_67f1:
    ld a, $01
    ld [$cac0], a
    call DoFrame
    call UpdateRNGSources
    ldh a, [$8f]
    and $08
    jr z, jr_006_6819

    ld a, $01
    call Call_006_6794
    call Call_006_6a07
    ld a, $06
    ld [$d006], a
    ld a, $05
    ld [$cea4], a
    call Call_006_6a23
    jr jr_006_67f1

jr_006_6819:
    call Call_006_6908
    jr nc, jr_006_67f1

    cp $ff
    jr z, jr_006_682b

    call Call_006_6a87
    jr nc, jr_006_67f1

    call Call_006_6880
    ret


jr_006_682b:
    ld a, [wNameLength]
    or a
    jr z, jr_006_67f1

    ld e, a
    ld d, $00
    ld hl, wNameBuffer
    add hl, de
    dec hl
    dec hl
    ld [hl], $00
    ld hl, wNameLength
    dec [hl]
    dec [hl]
    call Call_006_68cb
    jr jr_006_67f1

Call_006_6846:
    ld [$d004], a
    push hl
    ld hl, $d007
    ld [hl], b
    inc hl
    ld [hl], c
    pop hl
    ld b, h
    ld c, l
    ld hl, $d002
    ld [hl], c
    inc hl
    ld [hl], b
    ld hl, $d000
    ld [hl], e
    inc hl
    ld [hl], d
    ld a, $18
    ld hl, wNameBuffer
    call Call_006_6787
    ld hl, wNameBuffer
    ld a, [$d004]
    ld b, a
    inc b

jr_006_686f:
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, jr_006_686f

    ld hl, wNameBuffer
    call GetTextSizeInTiles
    ld a, c
    ld [wNameLength], a
    ret


Call_006_6880:
    ld hl, $d000
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld l, e
    ld h, d
    ld de, wNameBuffer
    ld a, [$d004]
    ld b, a
    inc b
    jr jr_006_686f

Call_006_6892:
    call Call_006_68c1
    call Call_006_68cb
    ld hl, $d002
    ld c, [hl]
    inc hl
    ld a, [hl]
    ld h, a
    or c
    jr z, jr_006_68a6

    ld l, c
    call PlaceTextItems

jr_006_68a6:
    ld hl, $68bc
    call PlaceTextItems
    ld hl, $0221
    ld de, $0204
    call InitTextPrinting
    call ProcessTextFromID
    call EnableLCD
    ret


    rrca
    db $10
    dec e
    ld [bc], a
    rst $38

Call_006_68c1:
    ld de, $0003
    ld bc, $140f
    call $1e7c
    ret


Call_006_68cb:
    ld hl, $d007
    ld d, [hl]
    inc hl
    ld e, [hl]
    push de
    call $22ae
    ld a, [$d004]
    ld e, a
    ld a, $14
    sub e
    inc a
    ld e, a
    ld d, $00
    ld hl, $68f2
    add hl, de
    call $21c5
    pop de
    call $22ae
    ld hl, wNameBuffer
    call $21c5
    ret


    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    inc bc
    ld d, [hl]
    nop

Call_006_6908:
Jump_006_6908:
    xor a
    ld [$cfe3], a
    ldh a, [$8f]
    or a
    jp z, Jump_006_69d9

    ld b, a
    ld a, [$cea9]
    ld c, a
    ld a, [$d006]
    ld h, a
    ld a, [$cea4]
    ld l, a
    bit 6, b
    jr z, jr_006_692c

    dec a
    bit 7, a
    jr z, jr_006_69a7

    ld a, c
    dec a
    jr jr_006_69a7

jr_006_692c:
    bit 7, b
    jr z, jr_006_6937

    inc a
    cp c
    jr c, jr_006_69a7

    xor a
    jr jr_006_69a7

jr_006_6937:
    ld a, [$d005]
    ld c, a
    ld a, h
    bit 5, b
    jr z, jr_006_6974

    ld d, a
    ld a, $06
    cp l
    ld a, d
    jr nz, jr_006_696b

    push hl
    push bc
    push af
    call Call_006_6b93
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    dec a
    ld d, a
    pop af
    pop bc
    pop hl
    sub d
    cp $ff
    jr nz, jr_006_6962

    ld a, c
    sub $02
    jr jr_006_69aa

jr_006_6962:
    cp $fe
    jr nz, jr_006_696b

    ld a, c
    sub $03
    jr jr_006_69aa

jr_006_696b:
    dec a
    bit 7, a
    jr z, jr_006_69aa

    ld a, c
    dec a
    jr jr_006_69aa

jr_006_6974:
    bit 4, b
    jr z, jr_006_69d9

    ld d, a
    ld a, $06
    cp l
    ld a, d
    jr nz, jr_006_6990

    push hl
    push bc
    push af
    call Call_006_6b93
    inc hl
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    dec a
    ld d, a
    pop af
    pop bc
    pop hl
    add d

jr_006_6990:
    inc a
    cp c
    jr c, jr_006_69aa

    inc c
    cp c
    jr c, jr_006_69a4

    inc c
    cp c
    jr c, jr_006_69a0

    ld a, $02
    jr jr_006_69aa

jr_006_69a0:
    ld a, $01
    jr jr_006_69aa

jr_006_69a4:
    xor a
    jr jr_006_69aa

jr_006_69a7:
    ld l, a
    jr jr_006_69ab

jr_006_69aa:
    ld h, a

jr_006_69ab:
    push hl
    call Call_006_6b93
    inc hl
    inc hl
    inc hl
    ld a, [$d009]
    cp $02
    jr nz, jr_006_69bb

    inc hl
    inc hl

jr_006_69bb:
    ld d, [hl]
    push de
    call Call_006_6a07
    pop de
    pop hl
    ld a, l
    ld [$cea4], a
    ld a, h
    ld [$d006], a
    xor a
    ld [$cea3], a
    ld a, $06
    cp d
    jp z, Jump_006_6908

    ld a, $01
    ld [$cfe3], a

Jump_006_69d9:
jr_006_69d9:
    ldh a, [$91]
    and $03
    jr z, jr_006_69ef

    and $01
    jr nz, jr_006_69e5

    ld a, $ff

jr_006_69e5:
    call Call_006_6794
    push af
    call Call_006_6a23
    pop af
    scf
    ret


jr_006_69ef:
    ld a, [$cfe3]
    or a
    jr z, jr_006_69f8

    call $3796

jr_006_69f8:
    ld hl, $cea3
    ld a, [hl]
    inc [hl]
    and $0f
    ret nz

    ld a, [$ceaa]
    bit 4, [hl]
    jr z, jr_006_6a0a

Call_006_6a07:
    ld a, [$ceab]

jr_006_6a0a:
    ld e, a
    ld a, [$d006]
    ld h, a
    ld a, [$cea4]
    ld l, a
    call Call_006_6b93
    ld a, [hl+]
    ld c, a
    ld b, [hl]
    dec b
    ld a, e
    call Call_006_6a28
    call $06c3
    or a
    ret


Call_006_6a23:
    ld a, [$ceaa]
    jr jr_006_6a0a

Call_006_6a28:
    push af
    push bc
    push de
    push hl
    push af
    call $099c
    pop af
    ld b, a
    ld a, [$ceab]
    cp b
    jr z, jr_006_6a60

    ld a, [wNameLength]
    srl a
    ld d, a
    ld a, [$d004]
    srl a
    ld e, a
    ld a, d
    cp e
    jr nz, jr_006_6a49

    dec a

jr_006_6a49:
    ld hl, $d007
    add [hl]
    ld d, a
    ld h, $08
    ld l, d
    call $0879
    ld a, l
    add $08
    ld d, a
    ld e, $18
    ld bc, $0000
    call $097f

jr_006_6a60:
    pop hl
    pop de
    pop bc
    pop af
    ret


Call_006_6a65:
    ld hl, $8000
    ld de, $6a77
    ld b, $00

jr_006_6a6d:
    ld a, $10
    cp b
    ret z

    inc b
    ld a, [de]
    inc de
    ld [hl+], a
    jr jr_006_6a6d

    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38

; bc = xy coordinate(by each tile) in the naming screen
; hl = the pointer to its character information(by 6bytes)
; info. structure: (1) / (1) / (1) / character code(2) / (1)
Call_006_6a87:
    ld a, [$d006]
    ld h, a
    ld a, [$cea4]
    ld l, a
    call Call_006_6b93
    inc hl
    inc hl
    ld e, [hl]
    inc hl
    ld a, [hl+]
    ld d, a
    cp $09
    jp z, Jump_006_6b5f

    cp $07
    jr nz, .jr_006_6ab8

    ld a, [$d009]
    or a
    jr nz, .jr_006_6aac

    ld a, $01
    jp .jr_006_6ace


.jr_006_6aac
    dec a
    jr nz, .jr_006_6ab4

    ld a, $02
    jp .jr_006_6ace


.jr_006_6ab4
    xor a
    jp .jr_006_6ace


.jr_006_6ab8
    cp $08
    jr nz, .jr_006_6ad6

    ld a, [$d009]
    or a
    jr nz, .jr_006_6ac6

    ld a, $02
    jr .jr_006_6ace

.jr_006_6ac6
    dec a
    jr nz, .jr_006_6acc

    xor a
    jr .jr_006_6ace

.jr_006_6acc
    ld a, $01

.jr_006_6ace
    ld [$d009], a
    call Call_006_6892
    or a
    ret


.jr_006_6ad6
    ld a, [$d009]
    cp $02
    jr z, .read_char

    ld bc, $0359
    ld a, d
    cp b
    jr nz, .jr_006_6af4

    ld a, e
    cp c
    jr nz, .jr_006_6af4

    push hl
    ld hl, $6cf9
    call Call_006_6b61
    pop hl
    jr c, jr_006_6b5d

    jr .jr_006_6b09

.jr_006_6af4
    ld bc, $035b
    ld a, d
    cp b
    jr nz, .jr_006_6b1d

    ld a, e
    cp c
    jr nz, .jr_006_6b1d

    push hl
    ld hl, $6d5f
    call Call_006_6b61
    pop hl
    jr c, jr_006_6b5d

.jr_006_6b09
    ld a, [wNameLength] ; cfff: current player name length(by byte).
    dec a
    dec a
    ld [wNameLength], a
    ld hl, wNameBuffer ; cfe7: temporary buffer for player name.
    push de
    ld d, $00
    ld e, a
    add hl, de
    pop de
    ld a, [hl]
    jr jr_006_6b37

.jr_006_6b1d
    ld a, d
    or a
    jr nz, jr_006_6b37

    ld a, [$d009]
    or a
    jr nz, .jr_006_6b2b

    ld a, $0e
    jr jr_006_6b37

.jr_006_6b2b
    ld a, $0f
    jr jr_006_6b37

; read character code from info. to register.
; [input]
; hl: pointer.
.read_char
    ld e, [hl]
    inc hl
    ld a, [hl] ; a: first byte of the code.
    or a
	; if 2byte code.
    jr nz, jr_006_6b37
	; if 1byte code(ascii)
	; set first byte to $0e.
    ld a, $0e

; on 2byte code.
jr_006_6b37:
    ld d, a ; de: character code.
    ld hl, wNameLength
    ld a, [hl]
    ld c, a
    push hl
    ld hl, $d004
    cp [hl]
    pop hl
    jr nz, jr_006_6b4c

	; if the buffer is full
	; just change the last character of it.
    ld hl, wNameBuffer
    dec hl
    dec hl
    jr jr_006_6b51

; increase name length before add the character.
jr_006_6b4c:
    inc [hl] ; hl: wNameLength => name length 
    inc [hl]
    ld hl, wNameBuffer

; write 2byte character codes from user input.
; de: 2byte character codes.
; hl: dest.
jr_006_6b51:
    ld b, $00
    add hl, bc

    ld [hl], d
    inc hl
    ld [hl], e
    inc hl
    ld [hl], $00 ; null terminator.

    call Call_006_68cb

jr_006_6b5d:
    or a
    ret


Jump_006_6b5f:
    scf
    ret


Call_006_6b61:
    ld a, [wNameLength]
    or a
    jr z, jr_006_6b91

    dec a
    dec a
    push hl
    ld hl, wNameBuffer
    ld d, $00
    ld e, a
    add hl, de
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, $0f
    cp e
    jr nz, jr_006_6b7a

    dec e

jr_006_6b7a:
    pop hl

jr_006_6b7b:
    ld a, [hl+]
    or a
    jr z, jr_006_6b91

    cp d
    jr nz, jr_006_6b8c

    ld a, [hl]
    cp e
    jr nz, jr_006_6b8c

    inc hl
    ld e, [hl]
    inc hl
    ld d, [hl]
    or a
    ret


jr_006_6b8c:
    inc hl
    inc hl
    inc hl
    jr jr_006_6b7b

jr_006_6b91:
    scf
    ret


Call_006_6b93:
    push de
    ld e, l
    ld d, h
    ld a, [$cea9]
    ld l, a
    call $0879
    ld a, l
    add e
    ld hl, $6baf
    pop de
    or a
    ret z

jr_006_6ba5:
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    dec a
    jr nz, jr_006_6ba5

    ret


    inc b
    ld [bc], a
    ld de, $3000
    inc bc
    ld b, $02
    ld [de], a
    nop
    add hl, sp
    inc bc
    ld [$1302], sp
    nop
    ld b, d
    inc bc
    ld a, [bc]
    ld [bc], a
    inc d
    nop
    ld l, a
    nop
    inc c
    ld [bc], a
    dec d
    nop
    ld h, h
    nop
    db $10
    rrca
    ld bc, $0009
    nop
    inc b
    inc b
    ld d, $00
    ld sp, $0603
    inc b
    rla
    nop
    ld a, [hl-]
    inc bc
    ld [$1804], sp
    nop
    ld b, e
    inc bc
    ld a, [bc]
    inc b
    add hl, de
    nop
    ld e, l
    inc bc
    inc c
    inc b
    ld a, [de]
    nop
    ld h, l
    nop
    db $10
    rrca
    ld bc, $0009
    nop
    inc b
    ld b, $1b
    nop
    ld [hl-], a
    inc bc
    ld b, $06
    inc e
    nop
    dec sp
    inc bc
    ld [$1d06], sp
    nop
    ld b, h
    inc bc
    ld a, [bc]
    ld b, $1e
    nop
    ld l, d
    nop
    inc c
    ld b, $1f
    nop
    ld h, [hl]
    nop
    db $10
    rrca
    ld bc, $0009
    nop
    inc b
    ld [$0020], sp
    inc sp
    inc bc
    ld b, $08
    ld hl, $3c00
    inc bc
    ld [$2208], sp
    nop
    ld b, l
    inc bc
    ld a, [bc]
    ld [$0023], sp
    ld l, e
    nop
    inc c
    ld [$0024], sp
    ld h, a
    nop
    db $10
    rrca
    ld bc, $0009
    nop
    inc b
    ld a, [bc]
    dec h
    nop
    inc [hl]
    inc bc
    ld b, $0a
    ld h, $00
    dec a
    inc bc
    ld [$270a], sp
    nop
    ld b, [hl]
    inc bc
    ld a, [bc]
    ld a, [bc]
    jr z, jr_006_6c55

jr_006_6c55:
    ld [hl], a
    nop
    inc c
    ld a, [bc]
    add hl, hl
    nop
    ld l, b
    nop
    db $10
    rrca
    ld bc, $0009
    nop
    inc b
    inc c
    ld a, [hl+]
    nop
    dec [hl]
    inc bc
    ld b, $0c
    dec hl
    nop
    ld a, $03
    ld [$2c0c], sp
    nop
    ld b, a
    inc bc
    ld a, [bc]
    inc c
    dec l
    nop
    ld h, b
    nop
    inc c
    inc c
    ld l, $00
    ld l, c
    nop
    db $10
    rrca
    ld bc, $0009
    nop
    inc b
    ld c, $2f
    nop
    ld [hl], $03
    ld b, $0e
    jr nc, jr_006_6c91

jr_006_6c91:
    ccf
    inc bc
    ld [$310e], sp
    nop
    ld c, b
    inc bc
    ld a, [bc]
    ld c, $32
    nop
    ld h, c
    nop
    inc c
    ld c, $33
    nop
    inc de
    dec b
    db $10
    rrca
    ld bc, $0009
    nop
    inc b
    db $10
    inc [hl]
    nop
    scf
    inc bc
    ld b, $10
    dec [hl]
    nop
    ld b, b
    inc bc
    ld [$3610], sp
    nop
    ld c, c
    inc bc
    ld a, [bc]
    db $10
    inc a
    nop
    ld h, d
    nop
    inc c
    db $10
    dec a
    nop
    ld de, $1005
    rrca
    ld bc, $0009
    nop
    inc b
    ld [de], a
    scf
    nop
    jr c, @+$05

    ld b, $12
    jr c, jr_006_6cd9

jr_006_6cd9:
    ld b, c
    inc bc
    ld [$3912], sp
    nop
    ld l, [hl]
    nop
    ld a, [bc]
    ld [de], a
    ld a, [hl-]
    nop
    ld h, e
    nop
    inc c
    ld [de], a
    dec sp
    nop
    ld [hl], b
    nop
    db $10
    rrca
    ld bc, $0009
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld d, $0e
    ld a, $00
    rla
    ld c, $3f
    nop
    jr jr_006_6d11

    ld b, b
    nop
    add hl, de
    ld c, $41
    nop
    ld a, [de]
    ld c, $42
    nop
    dec de
    ld c, $43
    nop

jr_006_6d11:
    inc e
    ld c, $44
    nop
    dec e
    ld c, $45
    nop
    ld e, $0e
    ld b, [hl]
    nop
    rra
    ld c, $47
    nop
    jr nz, jr_006_6d31

    ld c, b
    nop
    ld hl, $490e
    nop
    ld [hl+], a
    ld c, $4a
    nop
    inc hl
    ld c, $4b
    nop

jr_006_6d31:
    inc h
    ld c, $4c
    nop
    ld a, [hl+]
    ld c, $4d
    nop
    dec hl
    ld c, $4e
    nop
    inc l
    ld c, $4f
    nop
    dec l
    ld c, $50
    nop
    ld l, $0e
    ld d, c
    nop
    ld d, d
    ld c, $4d
    nop
    ld d, e
    ld c, $4e
    nop
    ld d, h
    ld c, $4f
    nop
    ld d, l
    ld c, $50
    nop
    ld d, [hl]
    ld c, $51
    nop
    nop
    nop
    ld a, [hl+]
    ld c, $52
    nop
    dec hl
    ld c, $53
    nop
    inc l
    ld c, $54
    nop
    dec l
    ld c, $55
    nop
    ld l, $0e
    ld d, [hl]
    nop
    ld c, l
    ld c, $52
    nop
    ld c, [hl]
    ld c, $53
    nop
    ld c, a
    ld c, $54
    nop
    ld d, b
    ld c, $55
    nop
    ld d, c
    ld c, $56
    nop
    nop
    nop

Func_1ad89: ; 1ad89 (6:6d89)
    push af
    ld a, [de]
    or a
    jr nz, jr_006_6d91

    ld a, $06
    ld [de], a

jr_006_6d91:
    pop af
    inc a
    call Call_006_6846
    call $02b9
    xor a
    ld [$cab6], a
    call $04a2
    call $099c
    ld a, $01
    ld [$cac0], a
    call $2119
    ld de, $38bf
    call $2275
    call Call_006_6e37
    xor a
    ld [$d009], a
    call Call_006_6e99
    xor a
    ld [$d006], a
    ld [$cea4], a
    ld a, $09
    ld [$d005], a
    ld a, $07
    ld [$cea9], a
    ld a, $0f
    ld [$ceaa], a
    ld a, $00
    ld [$ceab], a

Jump_006_6dd6:
jr_006_6dd6:
    ld a, $01
    ld [$cac0], a
    call $053f
    call $089b
    ldh a, [$8f]
    and $08
    jr z, jr_006_6dfc

    ld a, $01
    call Call_006_6794
    call Call_006_6fa1
    ld a, $06
    ld [$d006], a
    ld [$cea4], a
    call Call_006_6fbd
    jr jr_006_6dd6

jr_006_6dfc:
    call Call_006_6efb
    jr nc, jr_006_6dd6

    cp $ff
    jr z, jr_006_6e1c

    call Call_006_6ec3
    jr nc, jr_006_6dd6

    call Call_006_6880
    ld hl, $d000
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_006_6e1b

    dec hl
    ld [hl], $00

jr_006_6e1b:
    ret


jr_006_6e1c:
    ld a, [wNameLength]
    cp $02
    jr c, jr_006_6dd6

    ld e, a
    ld d, $00
    ld hl, wNameBuffer
    add hl, de
    dec hl
    ld [hl], $00
    ld hl, wNameLength
    dec [hl]
    call Call_006_6e59
    jp Jump_006_6dd6


Call_006_6e37:
    ld hl, $8000
    ld de, $6e49
    ld b, $00

jr_006_6e3f:
    ld a, $10
    cp b
    ret z

    inc b
    ld a, [de]
    inc de
    ld [hl+], a
    jr jr_006_6e3f

    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]

Call_006_6e59:
    ld hl, $d007
    ld d, [hl]
    inc hl
    ld e, [hl]
    call $22ae
    ld hl, $6e83
    ld de, $c590

jr_006_6e68:
    ld a, [hl+]
    ld [de], a
    inc de
    or a
    jr nz, jr_006_6e68

    ld hl, wNameBuffer
    ld de, $c590

jr_006_6e74:
    ld a, [hl+]
    or a
    jr z, jr_006_6e7c

    ld [de], a
    inc de
    jr jr_006_6e74

jr_006_6e7c:
    ld hl, $c590
    call $21c5
    ret


    ld b, $5f
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    ld e, a
    nop

Call_006_6e99:
    call Call_006_68c1
    call Call_006_6e59
    ld hl, $d002
    ld c, [hl]
    inc hl
    ld a, [hl]
    ld h, a
    or c
    jr z, jr_006_6ead

    ld l, c
    call $2c08

jr_006_6ead:
    ld hl, $68bc
    call $2c08
    ld hl, $0222
    ld de, $0204
    call $22ae
    call $2c29
    call $0277
    ret


Call_006_6ec3:
    ld a, [$d006]
    ld h, a
    ld a, [$cea4]
    ld l, a
    call Call_006_7000
    inc hl
    inc hl
    ld a, [hl]
    cp $01
    jr nz, jr_006_6ed7

    scf
    ret


jr_006_6ed7:
    ld d, a
    ld hl, wNameLength
    ld a, [hl]
    ld c, a
    push hl
    ld hl, $d004
    cp [hl]
    pop hl
    jr nz, jr_006_6eeb

    ld hl, wNameBuffer
    dec hl
    jr jr_006_6eef

jr_006_6eeb:
    inc [hl]
    ld hl, wNameBuffer

jr_006_6eef:
    ld b, $00
    add hl, bc
    ld [hl], d
    inc hl
    ld [hl], $00
    call Call_006_6e59
    or a
    ret


Call_006_6efb:
Jump_006_6efb:
    xor a
    ld [$cfe3], a
    ldh a, [$8f]
    or a
    jp z, Jump_006_6f73

    ld b, a
    ld a, [$cea9]
    ld c, a
    ld a, [$d006]
    ld h, a
    ld a, [$cea4]
    ld l, a
    bit 6, b
    jr z, jr_006_6f1f

    dec a
    bit 7, a
    jr z, jr_006_6f4b

    ld a, c
    dec a
    jr jr_006_6f4b

jr_006_6f1f:
    bit 7, b
    jr z, jr_006_6f2a

    inc a
    cp c
    jr c, jr_006_6f4b

    xor a
    jr jr_006_6f4b

jr_006_6f2a:
    cp $06
    jr z, jr_006_6f73

    ld a, [$d005]
    ld c, a
    ld a, h
    bit 5, b
    jr z, jr_006_6f40

    dec a
    bit 7, a
    jr z, jr_006_6f4e

    ld a, c
    dec a
    jr jr_006_6f4e

jr_006_6f40:
    bit 4, b
    jr z, jr_006_6f73

    inc a
    cp c
    jr c, jr_006_6f4e

    xor a
    jr jr_006_6f4e

jr_006_6f4b:
    ld l, a
    jr jr_006_6f4f

jr_006_6f4e:
    ld h, a

jr_006_6f4f:
    push hl
    call Call_006_7000
    inc hl
    inc hl
    ld d, [hl]
    push de
    call Call_006_6fa1
    pop de
    pop hl
    ld a, l
    ld [$cea4], a
    ld a, h
    ld [$d006], a
    xor a
    ld [$cea3], a
    ld a, $02
    cp d
    jp z, Jump_006_6efb

    ld a, $01
    ld [$cfe3], a

Jump_006_6f73:
jr_006_6f73:
    ldh a, [$91]
    and $03
    jr z, jr_006_6f89

    and $01
    jr nz, jr_006_6f7f

    ld a, $ff

jr_006_6f7f:
    call Call_006_6794
    push af
    call Call_006_6fbd
    pop af
    scf
    ret


jr_006_6f89:
    ld a, [$cfe3]
    or a
    jr z, jr_006_6f92

    call $3796

jr_006_6f92:
    ld hl, $cea3
    ld a, [hl]
    inc [hl]
    and $0f
    ret nz

    ld a, [$ceaa]
    bit 4, [hl]
    jr z, jr_006_6fa4

Call_006_6fa1:
    ld a, [$ceab]

jr_006_6fa4:
    ld e, a
    ld a, [$d006]
    ld h, a
    ld a, [$cea4]
    ld l, a
    call Call_006_7000
    ld a, [hl+]
    ld c, a
    ld b, [hl]
    dec b
    ld a, e
    call Call_006_6fc2
    call $06c3
    or a
    ret


Call_006_6fbd:
    ld a, [$ceaa]
    jr jr_006_6fa4

Call_006_6fc2:
    push af
    push bc
    push de
    push hl
    push af
    call $099c
    pop af
    ld b, a
    ld a, [$ceab]
    cp b
    jr z, jr_006_6ffb

    ld a, [wNameLength]
    ld d, a
    ld a, [$d004]
    ld e, a
    ld a, d
    cp e
    jr nz, jr_006_6fdf

    dec a

jr_006_6fdf:
    dec a
    ld d, a
    ld hl, $d007
    ld a, [hl]
    sla a
    add d
    ld d, a
    ld h, $04
    ld l, d
    call $0879
    ld a, l
    add $08
    ld d, a
    ld e, $18
    ld bc, $0000
    call $097f

jr_006_6ffb:
    pop hl
    pop de
    pop bc
    pop af
    ret


Call_006_7000:
    push de
    ld e, l
    ld d, h
    ld a, [$cea9]
    ld l, a
    call $0879
    ld a, l
    add e
    ld hl, $7019
    pop de
    or a
    ret z

jr_006_7012:
    inc hl
    inc hl
    inc hl
    dec a
    jr nz, jr_006_7012

    ret


    inc b
    ld [bc], a
    ld b, c
    ld b, $02
    ld c, d
    ld [$5302], sp
    ld a, [bc]
    ld [bc], a
    ccf
    inc c
    ld [bc], a
    inc [hl]
    ld c, $02
    ld [bc], a
    db $10
    rrca
    ld bc, $0404
    ld b, d
    ld b, $04
    ld c, e
    ld [$5404], sp
    ld a, [bc]
    inc b
    ld h, $0c
    inc b
    dec [hl]
    ld c, $04
    ld [bc], a
    db $10
    rrca
    ld bc, $0604
    ld b, e
    ld b, $06
    ld c, h
    ld [$5506], sp
    ld a, [bc]
    ld b, $2b
    inc c
    ld b, $36
    ld c, $06
    ld [bc], a
    db $10
    rrca
    ld bc, $0804
    ld b, h
    ld b, $08
    ld c, l
    ld [$5608], sp
    ld a, [bc]
    ld [$0c2d], sp
    ld [$0e37], sp
    ld [$1002], sp
    rrca
    ld bc, $0a04
    ld b, l
    ld b, $0a
    ld c, [hl]
    ld [$570a], sp
    ld a, [bc]
    ld a, [bc]
    daa
    inc c
    ld a, [bc]
    jr c, jr_006_708b

    ld a, [bc]
    ld [bc], a
    db $10
    rrca
    ld bc, $0c04
    ld b, [hl]
    ld b, $0c
    ld c, a
    ld [$580c], sp

jr_006_708b:
    ld a, [bc]
    inc c
    jr nc, @+$0e

    inc c
    add hl, sp
    ld c, $0c
    ld [bc], a
    db $10
    rrca
    ld bc, $0e04
    ld b, a
    ld b, $0e
    ld d, b
    ld [$590e], sp
    ld a, [bc]
    ld c, $31
    inc c
    ld c, $20
    ld c, $0e
    ld [bc], a
    db $10
    rrca
    ld bc, $1004
    ld c, b
    ld b, $10
    ld d, c
    ld [$5a10], sp
    ld a, [bc]
    db $10
    ld [hl-], a
    inc c
    db $10
    jr nz, jr_006_70ca

    db $10
    ld [bc], a
    db $10
    rrca
    ld bc, $1204
    ld c, c
    ld b, $12
    ld d, d
    ld [$2112], sp

jr_006_70ca:
    ld a, [bc]
    ld [de], a
    inc sp
    inc c
    ld [de], a
    jr nz, @+$10

    ld [de], a
    ld [bc], a
    db $10
    rrca
    ld bc, $0000
    nop
    nop
    ld a, [de]
    dec b
    ld [bc], a
    ld [hl], a
    ld bc, $0278
    ld a, c
    ld bc, $027a
    ld a, e
    ld bc, $037c
    ld a, l
    ld [bc], a
    ld a, [hl]
    ld bc, $027f
    add b
    ld bc, $0181
    add d
    ld bc, $0283
    add h
    ld bc, $0185
    add a
    ld bc, $0288
    adc c
    ld bc, $018a
    jp $c502


    ld bc, $02d2
    db $dd
    nop
    inc c
    inc b
    ld c, $05
    inc b
    ld l, l
    ld [bc], a
    ld l, a
    ld [bc], a
    ld [hl], h
    inc b
    add a
    ld [bc], a
    adc b
    inc b
    or c
    ld bc, $02c3
    push bc
    ld bc, $02c6
    call $d202
    ld bc, $02d5
    ret c

    ld [bc], a
    reti


    ld bc, $01da
    db $db
    ld bc, $00e1
    jr jr_006_7139

    ld [bc], a
    rlca
    inc bc
    ld a, e
    inc b

jr_006_7139:
    ld a, l
    inc bc
    ld a, [hl]
    ld [bc], a
    add a
    ld [bc], a
    adc b
    inc bc
    or c
    ld [bc], a
    or e
    inc bc
    cp a
    ld [bc], a
    ret nz

    ld bc, $01c2
    jp $d803


    inc bc
    reti


    ld [bc], a
    db $dd
    nop
    ld [$0402], sp
    inc b
    rrca
    dec b
    inc b
    dec sp
    ld [bc], a
    ld [hl], c
    inc bc
    ld a, e
    ld [bc], a
    ld a, h
    inc bc
    add a
    inc bc
    adc b
    ld [bc], a
    cp c
    ld [bc], a
    rst $08
    ld [bc], a
    push de
    inc bc
    ret c

    ld [bc], a
    reti


    inc bc
    db $dd
    ld [bc], a
    rst $18
    nop
    add hl, de
    dec b
    inc b
    ld a, l
    inc bc
    ld a, [hl]
    ld [bc], a
    ld a, a
    ld [bc], a
    adc b
    inc b
    add a
    inc b
    ld a, e
    ld bc, $027c
    db $dd
    ld [bc], a
    reti


    ld [bc], a
    ret c

    ld [bc], a
    jp nc, $db03

    inc b
    push bc
    nop
    ld [$0f04], sp
    dec b
    ld [bc], a
    rlca
    ld [bc], a
    ld h, b
    ld [bc], a
    ld h, c
    ld bc, $0167
    ld l, b
    inc b
    ld [hl], a
    inc bc
    ld a, b
    inc b
    and a
    inc bc
    xor b
    ld bc, $02c3
    push bc
    ld bc, $02c9
    call $d601
    inc bc
    ret c

    ld [bc], a
    reti


    ld [bc], a
    db $dd
    ld bc, $00de
    add hl, de
    dec b
    inc b
    ld a, c
    inc bc
    ld a, d
    inc b
    add e
    inc bc
    adc c
    ld [bc], a
    adc d
    ld [bc], a
    cp c
    ld bc, $01ba
    cp [hl]
    ld bc, $02c3
    push bc
    ld [bc], a
    ret


    inc bc
    jp nc, $d904

    inc bc
    db $dd
    nop
    jr jr_006_71e0

    inc bc
    ld [hl], a
    ld [bc], a
    ld a, b
    inc bc

jr_006_71e0:
    add b
    ld [bc], a
    add c
    ld bc, $0482
    add e
    inc b
    add h
    ld bc, $0285
    add [hl]
    ld [bc], a
    adc c
    ld bc, $028a
    push bc
    ld bc, $02c6
    call nc, $d701
    inc bc
    reti


    ld [bc], a
    ld [c], a
    nop
    rrca
    dec b
    ld [$0303], sp
    ld c, l
    ld bc, $034e
    ld e, h
    ld [bc], a
    ld e, l
    inc b
    ld [hl], a
    ld [bc], a
    ld a, b
    inc bc
    add h
    ld bc, $0386
    adc b
    ld [bc], a
    adc e
    ld bc, $028c
    adc l
    ld [bc], a
    jp $c502


    ld [bc], a
    jp z, $cc04

    nop
    jr jr_006_722a

    ld [bc], a
    rlca
    inc b
    ld a, c
    ld [bc], a

jr_006_722a:
    ld a, d
    inc b
    add b
    inc bc
    add c
    ld [bc], a
    add d
    inc bc
    add e
    inc bc
    adc c
    ld [bc], a
    jp $ca01


    ld [bc], a
    ret nc

    ld [bc], a
    jp nc, $d601

    ld [bc], a
    reti


    ld bc, $02de
    db $dd
    nop
    add hl, de
    inc bc
    ld [bc], a
    ld b, h
    ld bc, $0245
    ld b, [hl]
    ld bc, $0147
    ld c, b
    ld [bc], a
    ld c, e
    ld bc, $024c
    ld c, l
    ld bc, $024e
    ld c, a
    ld bc, $0250
    ld d, c
    ld bc, $0152
    ld d, a
    ld bc, $0158
    ld e, c
    ld bc, $015c
    ld e, l
    ld bc, $015e
    jp $c502


    ld bc, $02c9
    call z, $cf01
    ld bc, $01d4
    db $dd
    ld bc, $00de
    db $10
    inc bc
    ld a, [bc]
    dec b
    ld [bc], a
    ld c, e
    ld bc, $034c
    ld c, l
    ld [bc], a
    ld c, [hl]
    inc bc
    ld c, a
    ld [bc], a
    ld d, b
    inc bc
    ld d, l
    ld [bc], a
    ld d, [hl]
    inc bc
    ld [hl], a
    ld [bc], a
    ld a, b
    ld [bc], a
    push bc
    ld [bc], a
    call $d002
    ld [bc], a
    db $db
    inc bc
    db $dd
    nop
    ld [$0e01], sp
    inc bc
    inc b
    rlca
    inc bc
    inc c
    ld [bc], a
    dec c
    inc bc
    ld b, c
    ld [bc], a
    ld b, d
    inc bc
    ld c, l
    ld [bc], a
    ld c, [hl]
    inc b
    ld d, l
    inc bc
    ld d, [hl]
    ld [bc], a
    jp $c502


    ld [bc], a
    ret c

    ld [bc], a
    reti


    inc b
    db $dd
    nop
    rrca
    inc bc
    ld [$0306], sp
    rlca
    inc bc
    ld b, h
    ld [bc], a
    ld b, l
    inc b
    ld b, [hl]
    inc bc
    ld b, a
    ld [bc], a
    ld c, b
    inc b
    sub l
    inc bc
    sub [hl]
    inc bc
    cp a
    ld [bc], a
    ret nz

    ld bc, $01c3
    push bc
    ld bc, $02c7
    rst $08
    ld [bc], a
    ret nc

    ld bc, $00d1
    jr jr_006_72ed

    inc b
    ld b, c
    inc bc

jr_006_72ed:
    ld b, d
    ld [bc], a
    ld b, e
    inc b
    ld d, e
    inc bc
    ld d, h
    inc bc
    ld d, c
    ld [bc], a
    ld d, d
    ld [bc], a
    ld e, c
    ld [bc], a
    jp $ca01


    ld bc, $01cd
    adc $02
    ret nc

    ld bc, $02d1
    jp nc, $dd02

    ld bc, $00e3
    inc b
    ld [bc], a
    ld b, $03
    ld [$0204], sp
    rlca
    ld bc, $013e
    ld e, e
    ld bc, $0160
    ld h, c
    ld bc, $0162
    ld h, e
    ld bc, $0164
    ld h, l
    ld bc, $0166
    ld h, a
    ld bc, $0168
    ld [hl], e
    ld [bc], a
    xor e
    ld bc, $01ac
    xor l
    ld [bc], a
    xor [hl]
    ld bc, $02af
    or b
    inc b
    cp h
    ld [bc], a
    jp $c503


    ld [bc], a
    rlc d
    push de
    ld bc, $01d6
    ret c

    ld bc, $03d9
    db $dd
    nop
    add hl, bc
    inc bc
    inc c
    inc b
    ld [bc], a
    ld d, l
    ld [bc], a
    ld e, c
    inc bc
    ld h, b
    ld bc, $0267
    ld l, c
    inc bc
    ld [hl], c
    ld [bc], a
    and a
    ld bc, $02a8
    jp $c504


    inc bc
    ret nc

    ld bc, $03d6
    ret c

    ld [bc], a
    jp c, $db04

    inc b
    ld [c], a
    nop
    ld a, [de]
    inc b
    ld [bc], a
    ld h, b
    ld bc, $0161
    ld h, a
    ld bc, $0268
    ld l, c
    ld bc, $016a
    ld l, e
    ld bc, $036c
    ld l, l
    ld bc, $016e
    ld l, a
    ld bc, $0170
    ld [hl], c
    ld bc, $0172
    ld [hl], e
    ld bc, $0174
    ld [hl], l
    inc bc
    cp h
    ld bc, $02cd
    ret nc

    ld [bc], a
    call nc, $d802
    ld [bc], a
    reti


    ld bc, $00db
    jr jr_006_73aa

    ld bc, $0207
    ld h, c

jr_006_73aa:
    ld bc, $0162
    ld h, e
    ld [bc], a
    ld h, a
    ld [bc], a
    ld l, c
    ld [bc], a
    ld l, d
    ld [bc], a
    ld l, e
    inc b
    ld l, l
    inc bc
    ld l, a
    ld bc, $0375
    cp l
    ld [bc], a
    call $d802
    inc bc
    reti


    ld [bc], a
    jp c, $db03

    nop
    jr jr_006_73cf

    ld [bc], a
    rlca
    inc b
    ld l, c

jr_006_73cf:
    inc bc
    ld l, e
    inc b
    ld l, l
    ld [bc], a
    ld l, [hl]
    inc b
    ld [hl], c
    ld [bc], a
    cp c
    ld bc, $01ba
    jp $c502


    ld [bc], a
    jp nc, $d904

    ld bc, $04db
    db $dd
    nop
    jr jr_006_73eb

    inc bc

jr_006_73eb:
    inc c
    ld [bc], a
    dec c
    ld bc, $030e
    rrca
    ld [bc], a
    db $10
    ld bc, $0411
    rra
    inc bc
    jr nz, @+$04

    ld hl, $2201
    ld bc, $012e
    cpl
    ld [bc], a
    push bc
    ld [bc], a
    jp z, $d202

    ld [bc], a
    call nc, $d702
    ld [bc], a
    db $dd
    nop
    add hl, de
    ld bc, $0701
    ld [bc], a
    ld [de], a
    ld bc, $0213
    ld a, [de]
    ld bc, $021b
    inc e
    ld bc, $011d
    ld e, $02
    rra
    ld bc, $0220
    ld hl, $2201
    ld [bc], a
    inc hl
    ld bc, $0124
    dec h
    ld bc, $012f
    or a
    ld bc, $02b9
    push bc
    ld bc, $01d2
    call nc, $d802
    ld [bc], a
    reti


    ld [bc], a
    db $dd
    ld bc, $00df
    jr jr_006_7447

    ld [bc], a

jr_006_7447:
    rlca
    inc bc
    ld [$0902], sp
    ld [bc], a
    dec bc
    inc bc
    inc e
    ld [bc], a
    dec e
    ld [bc], a
    ld e, $02
    inc hl
    ld bc, $0124
    dec h
    ld [bc], a
    inc l
    ld bc, $022d
    or a
    ld [bc], a
    ret


    inc bc
    jp z, $cf01

    ld [bc], a
    jp nc, $dd02

    ld bc, $00df
    ld a, [bc]
    ld bc, $0204
    inc b
    inc bc
    inc b
    inc b
    inc bc
    rlca
    inc bc
    ld hl, $2202
    ld bc, $013d
    ld a, $01
    ld e, d
    ld bc, $015b
    ld [hl], d
    ld bc, $0473
    cp e
    inc b
    cp h
    inc b
    cp l
    ld [bc], a
    push bc
    ld [bc], a
    add $02
    rst $08
    inc b
    jp nc, $db02

    nop
    ld [de], a
    ld bc, $0604
    inc b
    ld [$0903], sp
    ld [bc], a
    dec bc
    inc b
    inc e
    inc bc
    dec e
    ld [bc], a
    ld e, $04
    jr z, @+$05

    add hl, hl
    ld [bc], a
    jp $c503


    ld [bc], a
    jp z, $cd02

    ld [bc], a
    jp nc, $dd02

    nop
    add hl, de
    ld b, $03
    adc [hl]
    ld [bc], a
    adc a
    ld bc, $0290
    sub d
    ld bc, $0193
    sub h
    ld [bc], a
    sub l
    ld bc, $0196
    sub a
    ld bc, $0298
    sbc c
    ld bc, $019a
    sbc e
    ld bc, $019c
    sbc l
    ld bc, $01a2
    xor e
    ld bc, $01ac
    cp [hl]
    ld [bc], a
    jp $c901


    ld bc, $02ca
    jp nc, $d301

    ld [bc], a
    ret c

    ld bc, $00dc
    rlca
    ld bc, $0611
    inc bc
    ld a, [de]
    ld [bc], a
    dec de
    inc b
    sub h
    ld bc, $0296
    sub a
    ld [bc], a
    sbc b
    inc bc
    sbc c
    ld [bc], a
    sbc d
    ld [bc], a
    xor a
    ld [bc], a
    or d
    ld [bc], a
    jp $c502


    ld [bc], a
    call $ce01
    ld [bc], a
    jp nc, $d601

    inc bc
    ldh [$FF00], a
    rla
    ld b, $04
    sub d
    inc bc
    sub e
    inc bc
    sbc h
    ld [bc], a
    sbc l
    ld [bc], a
    and d
    ld [bc], a
    xor [hl]
    ld [bc], a
    xor a
    ld [bc], a
    cp h
    ld [bc], a
    call $d003
    ld [bc], a
    ret c

    inc bc
    reti


    inc bc
    db $dd
    inc b
    db $e4
    nop
    add hl, de
    ld b, $01
    rlca
    inc bc
    sub c
    ld [bc], a
    sub e
    inc b
    sbc c
    inc bc
    sbc d
    ld [bc], a
    sbc e
    ld [bc], a
    sbc h
    ld bc, $02a0
    and d
    ld [bc], a
    or a
    ld bc, $02be
    ret


    ld [bc], a
    call $d002
    ld bc, $02d1
    ret c

    ld bc, $01da
    db $db
    ld bc, $00df
    ld d, $06
    inc b
    adc [hl]
    inc bc
    adc a
    ld [bc], a
    sub b
    ld [bc], a
    sbc e
    inc bc
    cp b
    inc bc
    cp c
    ld [bc], a
    cp [hl]
    ld [bc], a
    jp $d302


    inc bc
    ret nc

    inc bc
    db $db
    inc b
    push de
    inc b
    jp nc, $e301

    nop
    inc d
    ld bc, $1404
    inc bc
    dec d
    ld [bc], a
    ld d, $04
    rla
    inc b
    jr jr_006_758f

    add hl, de
    inc bc
    or a
    ld [bc], a

jr_006_758f:
    jp $c903


    inc bc
    jp z, $cd02

    inc bc
    jp nc, $d601

    ld [bc], a
    jp c, $1a00

    ld bc, $1202
    ld bc, $0213
    inc d
    ld bc, $0115
    ld d, $03
    rla
    ld [bc], a
    jr jr_006_75af

    add hl, de

jr_006_75af:
    ld [bc], a
    ld a, [de]
    ld bc, $021b
    ld h, $01
    daa
    ld [bc], a
    ld a, [hl+]
    ld bc, $022b
    or d
    ld bc, $01b3
    jp $c501


    ld bc, $01c9
    jp z, $dd01

    ld bc, $01df
    pop hl
    ld bc, $01e3
    db $e4
    nop
    dec c
    ld bc, $040a
    ld [bc], a
    rlca
    inc b
    ld a, [de]
    inc bc
    dec de
    ld [bc], a
    ld h, h
    inc b
    and e
    inc bc
    and h
    ld bc, $01a5
    and [hl]
    inc b
    xor c
    inc bc
    xor d
    ld [bc], a
    call nz, $c702
    ld [bc], a
    push bc
    inc b
    db $dd
    nop
    jr jr_006_75f6

    inc bc

jr_006_75f6:
    rrca
    ld [bc], a
    db $10
    ld bc, $0411
    ld [de], a
    inc bc
    inc de
    inc b
    rla
    inc bc
    jr jr_006_7606

    add hl, de
    inc bc

jr_006_7606:
    ld a, [hl+]
    ld [bc], a
    dec hl
    ld bc, $02c3
    call nz, $ca01
    ld [bc], a
    db $dd
    ld [bc], a
    rst $18
    ld bc, $00e3
    rrca
    ld bc, $0608
    inc b
    ld h, $03
    daa
    inc b
    ld a, [hl+]
    inc bc
    dec hl
    ld [bc], a
    sbc l
    ld bc, $019f
    sbc [hl]
    ld [bc], a
    cp l
    ld bc, $02c4
    jp $c502


    ld [bc], a
    rst $08
    ld [bc], a
    jp nc, $d602

    ld [bc], a
    rst $10
    ld [bc], a
    pop hl
    ld [bc], a
    rst $18
    nop
    jr jr_006_7641

    inc b
    inc sp

jr_006_7641:
    ld [bc], a
    inc [hl]
    ld bc, $0435
    ld [hl], $01
    scf
    ld bc, $0438
    and e
    inc bc
    and h
    ld bc, $01a5
    and [hl]
    inc bc
    or l
    ld [bc], a
    or [hl]
    ld [bc], a
    jp $c402


    ld [bc], a
    rst $00
    inc bc
    db $db
    nop
    inc c
    ld bc, $020a
    inc b
    ld [$0903], sp
    ld [bc], a
    dec bc
    inc b
    jr nc, jr_006_7670

    ld sp, $3202

jr_006_7670:
    inc bc
    dec a
    inc b
    cp h
    ld [bc], a
    push bc
    inc bc
    ret


    inc bc
    jp z, $cd02

    ld bc, $02d0
    db $dd
    nop
    ld a, [bc]
    ld [bc], a
    ld [$0803], sp
    inc b
    inc bc
    jr nc, @+$04

    ld sp, $3903
    ld [bc], a
    ld a, [hl-]
    ld [bc], a
    dec a
    ld [bc], a
    ld e, d
    ld [bc], a
    ld h, b
    inc bc
    ld l, l
    ld [bc], a
    ld l, a
    ld [bc], a
    ld [hl], d
    inc b
    cp h
    ld [bc], a
    rst $08
    ld [bc], a
    jp nc, $d803

    nop
    jr jr_006_76a8

    ld [bc], a
    rlca

jr_006_76a8:
    inc bc
    jr nc, @+$04

    ld sp, $3201
    inc bc
    inc sp
    ld bc, $0134
    dec [hl]
    ld [bc], a
    ld [hl], $01
    jr c, @+$04

    add hl, sp
    ld bc, $013a
    dec sp
    ld bc, $013c
    dec a
    ld bc, $013e
    ccf
    inc bc
    cp h
    ld bc, $02c3
    push bc
    ld bc, $01c9
    jp z, $cd01

    ld bc, $01ce
    jp nc, $db01

    nop
    dec d
    ld [bc], a
    inc b
    rlca
    inc b
    ld [hl], $03
    jr c, jr_006_76e4

    dec sp
    inc bc

jr_006_76e4:
    xor l
    ld bc, $01af
    or b
    ld [bc], a
    cp b
    ld [bc], a
    cp d
    ld bc, $02c3
    push bc
    ld [bc], a
    call $d401
    ld bc, $02d6
    reti


    inc bc
    db $dd
    ld bc, $03df
    db $e4
    ld bc, $00e3
    ld [$0a01], sp
    ld [bc], a
    ld b, $03
    ld [bc], a
    inc c
    ld bc, $020d
    inc d
    ld bc, $0117
    cpl
    ld [bc], a
    jr nc, @+$03

    ld sp, $3201
    ld [bc], a
    ld [hl], $01
    jr c, @+$04

    add hl, sp
    ld bc, $023b
    ld c, e
    ld bc, $024c
    ld d, e
    ld bc, $0254
    and a
    ld bc, $01a8
    or c
    ld bc, $02c3
    push bc
    ld bc, $01d2
    sub $01
    ret c

    ld [bc], a
    db $dd
    ld [bc], a
    rst $18
    nop
    ld [$0b02], sp
    inc bc
    ld b, $04
    ld [bc], a
    jr nc, @+$03

    ld sp, $3601
    ld bc, $0138
    dec sp
    ld [bc], a
    ld b, c
    ld bc, $0142
    ld b, e
    ld [bc], a
    ld c, e
    ld bc, $014C
    ld d, e
    ld bc, $0154
    ld d, l
    ld bc, $0156
    ld e, c
    ld [bc], a
    ld h, b
    ld bc, $0169
    ld l, e
    ld bc, $0271
    and a
    ld bc, $01a8
    or c
    ld bc, $01c3
    push bc
    ld bc, $01d2
    call nc, $d501
    ld bc, $01da
    db $dd
    ld bc, $00df
    add hl, bc
    ld bc, $0408
    ld b, $06
    ld [bc], a
    ld [$0901], sp
    ld bc, $020b
    inc d
    ld [bc], a
    rla
    ld bc, $0118
    dec l
    ld [bc], a
    ld h, b
    ld bc, $0167
    ld l, c
    ld bc, $0271
    adc [hl]
    ld bc, $028f
    sub h
    ld bc, $0197
    sbc h
    ld bc, $01af
    or c
    ld bc, $01b9
    jp $c501


    ld bc, $01d2
    call nc, $d802
    ld bc, $01d9
    db $db
    ld [bc], a
    db $dd
    ld [bc], a
    rst $18
    nop
    inc c
    dec b
    inc c
    ld b, $02
    ld a, c
    ld bc, $027a
    ld a, l
    ld bc, $017e
    ld a, a
    ld bc, $0183
    add a
    ld bc, $0288
    adc [hl]
    ld bc, $018f
    sub b
    ld [bc], a
    sub h
    ld bc, $0197
    sbc b
    ld bc, $019b
    sbc h
    ld bc, $02a2
    and e
    ld bc, $01a4
    and [hl]
    ld [bc], a
    and a
    ld bc, $01a8
    jp $c502


    ld bc, $01d2
    db $db
    ld [bc], a
    db $dd
    ld bc, $00df
    ld c, $01
    ld a, [bc]
    inc bc
    ld [bc], a
    rrca
    ld bc, $0110
    ld de, $1702
    ld bc, $0118
    add hl, de
    ld [bc], a
    inc hl
    ld bc, $0124
    dec h
    ld bc, $022e
    ld b, [hl]
    ld bc, $0147
    ld c, b
    ld [bc], a
    ld c, a
    ld bc, $0250
    ld d, a
    ld bc, $0158
    ld e, c
    ld bc, $015e
    or a
    ld bc, $01b9
    cp d
    ld bc, $02c3
    push bc
    ld bc, $01cd
    rst $08
    ld bc, $01d2
    ret c

    ld bc, $00df
    add hl, de
    ld [bc], a
    inc b
    inc sp
    inc bc
    dec [hl]
    inc b
    ld [hl], $02
    jr c, jr_006_7848

    dec sp
    ld [bc], a

jr_006_7848:
    inc a
    ld [bc], a
    ccf
    ld [bc], a
    ld b, b
    inc bc
    push bc
    ld [bc], a
    rst $00
    ld bc, $01c9
    call $ce01
    ld [bc], a
    ret nc

    ld [bc], a
    jp nc, $dd01

    ld bc, $00de
    add hl, de
    inc b
    inc b
    ld l, l
    inc bc
    ld l, [hl]
    inc b
    ld [hl], c
    ld [bc], a
    ld [hl], e
    ld bc, $0174
    ld [hl], l
    ld [bc], a
    db $76
    inc bc
    cp h
    inc b
    push bc
    ld [bc], a
    call $d202
    inc bc
    ret c

    inc bc
    db $dd
    ld bc, $00e3
    add hl, de
    inc bc
    inc b
    ld c, e
    inc bc
    ld c, h
    inc b
    ld e, c
    ld [bc], a
    ld e, a
    ld [bc], a
    ld e, [hl]
    inc bc
    cp b
    ld [bc], a
    cp e
    ld [bc], a
    jp $c902


    inc bc
    call $d203
    inc b
    push de
    ld bc, $00e3
    inc d
    inc bc
    inc b
    rlca
    inc bc
    jr nc, @+$04

    ld sp, $3202
    inc bc
    ld d, a
    ld [bc], a
    ld e, b
    ld [bc], a
    ld e, c
    ld [bc], a
    cp c
    inc b
    cp a
    inc bc
    ret nz

    ld [bc], a
    pop bc
    ld [bc], a
    jp $c902


    ld [bc], a
    jp z, $cd01

    ld bc, $02ce
    jp nc, $e301

    nop
    inc c
    ld bc, $060e
    inc b
    ld [$0903], sp
    ld [bc], a
    ld a, [bc]
    ld [bc], a
    ld l, $04
    adc [hl]
    inc bc
    adc a
    ld [bc], a
    sub b
    ld [bc], a
    sbc e
    ld bc, $02a0
    and c
    ld bc, $02c3
    push bc
    ld [bc], a
    jp z, $d001

    ld [bc], a
    jp nc, $d301

    nop
    jp c, $9270

    ld [bc], a
    call nz, $0b02
    ld [hl], c
    sub e
    ld [bc], a
    push bc
    ld [bc], a
    ld [hl-], a
    ld [hl], c
    sub h
    ld [bc], a
    add $02
    ld d, e
    ld [hl], c
    sub l
    ld [bc], a
    rst $00
    ld [bc], a
    ld [hl], h
    ld [hl], c
    sub [hl]
    ld [bc], a
    ret z

    ld [bc], a
    sub c
    ld [hl], c
    sub a
    ld [bc], a
    ret


    ld [bc], a
    cp d
    ld [hl], c
    sbc b
    ld [bc], a
    jp z, $d902

    ld [hl], c
    sbc c
    ld [bc], a
    rlc d
    cp $71
    sbc d
    ld [bc], a
    call z, $2302
    ld [hl], d
    sbc e
    ld [bc], a
    call $4602
    ld [hl], d
    sbc h
    ld [bc], a
    adc $02
    ld a, a
    ld [hl], d
    sbc l
    ld [bc], a
    rst $08
    ld [bc], a
    and d
    ld [hl], d
    sbc [hl]
    ld [bc], a
    ret nc

    ld [bc], a
    jp $9f72


    ld [bc], a
    pop de
    ld [bc], a
    add sp, $72
    and b
    ld [bc], a
    jp nc, $0d02

    ld [hl], e
    and c
    ld [bc], a
    db $d3
    ld [bc], a
    ld c, h
    ld [hl], e
    and d
    ld [bc], a
    call nc, $7102
    ld [hl], e
    and e
    ld [bc], a
    push de
    ld [bc], a
    and h
    ld [hl], e
    and h
    ld [bc], a
    sub $02
    ret


    ld [hl], e
    and l
    ld [bc], a
    rst $10
    ld [bc], a
    add sp, $73
    and [hl]
    ld [bc], a
    ret c

    ld [bc], a
    rrca
    ld [hl], h
    and a
    ld [bc], a
    reti


    ld [bc], a
    ld b, h
    ld [hl], h
    xor b
    ld [bc], a
    jp c, $6d02

    ld [hl], h
    xor c
    ld [bc], a
    db $db
    ld [bc], a
    sbc b
    ld [hl], h
    xor d
    ld [bc], a
    call c, $b902
    ld [hl], h
    xor e
    ld [bc], a
    db $dd
    ld [bc], a
    ldh a, [$74]
    xor h
    ld [bc], a
    sbc $02
    rla
    ld [hl], l
    xor l
    ld [bc], a
    rst $18
    ld [bc], a
    ld [hl], $75
    xor [hl]
    ld [bc], a
    ldh [rSC], a
    ld e, a
    ld [hl], l
    xor a
    ld [bc], a
    pop hl
    ld [bc], a
    ld a, [hl]
    ld [hl], l
    or b
    ld [bc], a
    ld [c], a
    ld [bc], a
    sbc l
    ld [hl], l
    or c
    ld [bc], a
    db $e3
    ld [bc], a
    jp nc, $b275

    ld [bc], a
    db $e4
    ld [bc], a
    di
    ld [hl], l
    or e
    ld [bc], a
    push hl
    ld [bc], a
    ld d, $76
    or h
    ld [bc], a
    and $02
    dec a
    db $76
    or l
    ld [bc], a
    rst $20
    ld [bc], a
    ld h, b
    db $76
    or [hl]
    ld [bc], a
    add sp, $02
    add c
    db $76
    or a
    ld [bc], a
    jp hl


    ld [bc], a
    and h
    db $76
    cp b
    ld [bc], a
    ld [$d902], a
    db $76
    cp c
    ld [bc], a
    db $eb
    ld [bc], a
    ld [bc], a
    ld [hl], a
    cp d
    ld [bc], a
    db $ec
    ld [bc], a
    dec a
    ld [hl], a
    cp e
    ld [bc], a
    db $ed
    ld [bc], a
    add b
    ld [hl], a
    cp h
    ld [bc], a
    xor $02
    cp a
    ld [hl], a
    cp l
    ld [bc], a
    rst $28
    ld [bc], a
    db $fc
    ld [hl], a
    cp [hl]
    ld [bc], a
    ldh a, [rSC]
    dec sp
    ld a, b
    cp a
    ld [bc], a
    pop af
    ld [bc], a
    ld h, b
    ld a, b
    ret nz

    ld [bc], a
    ld a, [c]
    ld [bc], a
    ld a, a
    ld a, b
    pop bc
    ld [bc], a
    di
    ld [bc], a
    sbc h
    ld a, b
    jp nz, $f402

    ld [bc], a
    jp $c378


    ld [bc], a
    push af
    ld [bc], a
    call $07b6
    ld a, [$d0a9]
    ld l, a
    ld h, $1e
    call $0879
    ld bc, $78e8
    add hl, bc
    ld b, $00

jr_006_7a26:
    call Call_006_7a4c
    call Call_006_7a5b
    call Call_006_7a7d
    push hl
    ld de, $d0aa
    ld h, b
    ld l, $02
    call $0879
    add hl, de
    ld d, h
    ld e, l
    pop hl
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc b
    ld a, b
    cp $05
    jr nz, jr_006_7a26

    call $07be
    ret


Call_006_7a4c:
    push hl
    ld l, b
    ld h, $54
    call $0879
    ld de, $a350
    add hl, de
    ld d, h
    ld e, l
    pop hl
    ret


Call_006_7a5b:
    push hl
    push bc
    push de
    push de
    ld e, [hl]
    inc hl
    ld d, [hl]
    pop hl
    ld bc, $0018
    add hl, bc

jr_006_7a67:
    ld a, [de]
    inc de
    ld b, a
    or a
    jr z, jr_006_7a77

    ld a, [de]
    inc de
    ld c, a

jr_006_7a70:
    ld [hl], c
    inc hl
    dec b
    jr nz, jr_006_7a70

    jr jr_006_7a67

jr_006_7a77:
    pop de
    pop bc
    pop hl
    inc hl
    inc hl
    ret


Call_006_7a7d:
    push hl
    push bc
    push de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $d089
    call $2e89
    pop hl
    ld de, $d089

jr_006_7a8d:
    ld a, [de]
    ld [hl+], a
    or a
    jr z, jr_006_7a95

    inc de
    jr jr_006_7a8d

jr_006_7a95:
    pop bc
    pop hl
    inc hl
    inc hl
    ret


    xor a
    ld [$d0a6], a
    ld a, $01

jr_006_7aa0:
    call Call_006_7ae4
    ret nc

    sla a
    cp $10
    jr z, jr_006_7aac

    jr jr_006_7aa0

jr_006_7aac:
    ld a, $03
    call Call_006_7ae4
    ret nc

    ld a, $05
    call Call_006_7ae4
    ret nc

    ld a, $09
    call Call_006_7ae4
    ret nc

    ld a, $06
    call Call_006_7ae4
    ret nc

    ld a, $0a
    call Call_006_7ae4
    ret nc

    ld a, $0c
    call Call_006_7ae4
    ret nc

    ld a, $f7

jr_006_7ad2:
    call Call_006_7ae4
    ret nc

    sra a
    cp $ff
    jr z, jr_006_7ade

    jr jr_006_7ad2

jr_006_7ade:
    call Call_006_7ae4
    ret nc

    scf
    ret


Call_006_7ae4:
    push af
    ld hl, $d088
    ld b, [hl]
    rst $28
    ld [bc], a
    dec h
    db $76
    jr c, jr_006_7af5

    pop af
    ld [$d0a6], a
    or a
    ret


jr_006_7af5:
    pop af
    scf
    ret

    INCROM $1baf8, $1c000