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
	ldh a, [hButtonsHeld]
	cp $3
	jr z, .asm_4035
	farcall Func_126d1
	jr Func_4000
.asm_4035
	call Func_405a
	call Func_04a2
	text_hl ResetBackUpRam
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
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ld a, $0
	ld [wPlayerDuelistType], a
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
	ld [wCurrentDuelMenuItem], a
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
	ld [wCurrentDuelMenuItem], a
	call Func_35e6
	call $54c8
	call Func_4225
	call Func_0f58
	ld a, [wDuelFinished]
	or a
	jr nz, .duelIsOver
	call Func_35fa
	call $6baf
	call Func_3b31
	call Func_0f58
	ld a, [wDuelFinished]
	or a
	jr nz, .duelIsOver
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

.duelIsOver
	call $5990
	call Func_04a2
	ld a, $3
	call Func_2167
	text_hl Decision
	call DrawWideTextBox_WaitForInput
	call Func_04a2
	ldh a, [hWhoseTurn]
	push af
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call $4a97
	call $4ad6
	pop af
	ldh [hWhoseTurn], a
	call Func_3b21
	ld a, [wDuelFinished]
	cp DUEL_WON
	jr z, .activeDuelistWonBattle
	cp DUEL_LOST
	jr z, .activeDuelistLostBattle
	ld a, $5f
	ld c, $1a
	text_hl DuelWasDraw
	jr .asm_4196

.activeDuelistWonBattle
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .opponentWonBattle
.playerWonBattle
	xor a
	ld [$d0c3], a
	ld a, $5d
	ld c, $18
	text_hl WonDuel
	jr .asm_4196

.activeDuelistLostBattle
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .playerWonBattle

.opponentWonBattle
	ld a, $1
	ld [$d0c3], a
	ld a, $5e
	ld c, $19
	text_hl LostDuel

.asm_4196
	call Func_3b6a
	ld a, c
	call PlaySong
	ld a, OPPONENT_TURN
	ldh [hWhoseTurn], a
	call DrawWideTextBox_PrintText
	call EnableLCD
.asm_41a7
	call DoFrame
	call Func_378a
	or a
	jr nz, .asm_41a7
	ld a, [wDuelFinished]
	cp DUEL_DRAW
	jr z, .tiedBattle
	call Func_39fc
	call WaitForWideTextBoxInput
	call Func_3b31
	call ResetSerial
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ret

.tiedBattle
	call WaitForWideTextBoxInput
	call Func_3b31
	ld a, [wDuelTheme]
	call PlaySong
	text_hl StartSuddenDeathMatch
	call DrawWideTextBox_WaitForInput
	ld a, $1
	ld [$cc08], a
	call $70aa
	ld a, [$cc09]
	cp $1
	jr z, .asm_41f3
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call $4b60
	jp $40ee

.asm_41f3
	call Func_0f58
	ld h, PLAYER_TURN
	ld a, [wSerialOp]
	cp $29
	jr z, .asm_4201
	ld h, OPPONENT_TURN

.asm_4201
	ld a, h
	ldh [hWhoseTurn], a
	call $4b60
	jp nc, $40ee
	ret
; 0x420b

INCBIN "baserom.gbc",$420b,$4225 - $420b

Func_4225: ; 4225 (1:4225)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld [$cc0d], a
	ld a, [$cc06]
	cp a, $02
	jr c, .asm_4237
	call $70f6

.asm_4237
	call $70e6
	call $4933
	call DrawCardFromDeck
	jr nc, .asm_4248
	ld a, DUEL_LOST
	ld [wDuelFinished], a
	ret

.asm_4248
	ldh [$ff98], a
	call AddCardToHand
	ld a, [$cc0d]
	cp $00
	jr z, Func_4262
	call GetOpposingTurnDuelistVariable_SwapTurn
	call Func_34e2
	call GetOpposingTurnDuelistVariable_SwapTurn
	call c, $4b2c
	jr Func_426d

Func_4262:
	call $4b2c
	call Func_100b

Func_4268:
	ld a, $06
	call $51e7

Func_426d:
	call $4f9d
	ld a, [$cc0d]
	cp a, $00
	jr z, Func_4295
	cp a, $01
	jp z, $6911
	xor a
	ld [wVBlankCtr], a
	ld [$cbf9], a
	text_hl DuelistIsThinking
	call Func_2a36
	call Func_2bbf
	ld a, $ff
	ld [$cc11], a
	ld [$cc10], a
	ret

Func_4295:
	call DrawWideTextBox
	ld hl, $54e9
	call Func_2c08
	call $669d
	ld a, [wDuelFinished]
	or a
	ret nz
	ld a, [wCurrentDuelMenuItem]
	call Func_2710

Func_42ac:
	call DoFrame
	ldh a, [hButtonsHeld]
	and a, $02
	jr z, .asm_42cc
	ldh a, [hButtonsPressed]
	bit 6, a
	jr nz, Func_430b
	bit 7, a
	jr nz, Func_4311
	bit 5, a
	jr nz, Func_4320
	bit 4, a
	jr nz, Func_4317
	bit 3, a
	jp nz, $4364

.asm_42cc
	ldh a, [hButtonsPressed]
	and a, $08
	jp nz, $4370
	ldh a, [hButtonsPressed]
	bit 2, a
	jp nz, $458e
	ld a, [$cbe7]
	or a
	jr nz, Func_42ac
	call Func_271a
	ld a, e
	ld [wCurrentDuelMenuItem], a
	jr nc, Func_42ac
	ldh a, [hCurrentMenuItem]
	ld hl, BattleMenuFunctionTable
	jp JumpToFunctionInTable

BattleMenuFunctionTable: ; 42f1 (1:42f1)
	dw OpenHandMenu
	dw OpenBattleAttackMenu
	dw OpenBattleCheckMenu
	dw OpenPokemonPowerMenu
	dw PlayerRetreat
	dw PlayerEndTurn

INCBIN "baserom.gbc",$42fd, $430b - $42fd

Func_430b: ; 430b (1:430b)
	call Func_4329
	jp Func_426d

Func_4311: ; 4311 (1:4311)
	call Func_4333
	jp Func_426d

Func_4317: ; 4317 (1:4317)
	call Func_4339
	jp c, Func_4295
	jp Func_426d

Func_4320: ; 4320 (1:4320)
	call Func_4342
	jp c, Func_4295
	jp Func_426d

Func_4329: ; 4329 (1:4329)
	call GetOpposingTurnDuelistVariable_SwapTurn
	call Func_4333
	call GetOpposingTurnDuelistVariable_SwapTurn
	ret

Func_4333: ; 4333 (1:4333)
	call $5fdd
	jp $6008

Func_4339: ; 4339 (1:4339)
	call GetOpposingTurnDuelistVariable_SwapTurn
	call $5550
	jp GetOpposingTurnDuelistVariable_SwapTurn

Func_4342: ; 4342 (1:4342)
	jp $5550

INCBIN "baserom.gbc",$4345, $438e - $4345

OpenPokemonPowerMenu: ; 438e (1:438e)
	call $6431
	jp c, Func_426d
	call Func_1730
	jp Func_426d

PlayerEndTurn: ; 439a (1:439a)
	ld a, $08
	call $51e7
	jp c, Func_4268
	ld a, $05
	call Func_0f7f
	call $717a
	ret

PlayerRetreat: ; 43ab (1:43ab)
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and a,$0f
	cp a, $01
	ldh [$ffa0], a
	jr nz, Func_43f1
	ld a, [$cc0c]
	or a
	jr nz, Func_43e8
	call $45bb
	jr c, Func_441f
	call $4611
	jr c, Func_441c
	text_hl SelectMonOnBenchToSwitchWithActive
	call DrawWideTextBox_WaitForInput
	call $600c
	jr c, Func_441c
	ld [wBenchSelectedPokemon], a
	ld a, [wBenchSelectedPokemon]
	ldh [$ffa1], a
	ld a, $04
	call Func_0f7f
	call $657a
	jr nc, Func_441c
	call $4f9d

Func_43e8: ; 43e8
	text_hl UnableToRetreat
	call DrawWideTextBox_WaitForInput
	jp Func_4295

Func_43f1: ; 43f1 (1:43f1)
	call $45bb
	jr c, Func_441f
	call $4611
	jr c, Func_441c
	call $6558
	text_hl SelectMonOnBenchToSwitchWithActive
	call DrawWideTextBox_WaitForInput
	call $600c
	ld [wBenchSelectedPokemon], a
	ldh [$ffa1], a
	push af
	call $6564
	pop af
	jp c, Func_426d
	ld a, $04
	call Func_0f7f
	call $657a

Func_441c: ; 441c (1:441c)
	jp Func_426d

Func_441f: ; 441f (1:441f)
	call DrawWideTextBox_WaitForInput
	jp Func_4295

OpenHandMenu: ; 4425 (1:4425)
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	or a
	jr nz, Func_4436
	text_hl NoCardsInHand
	call DrawWideTextBox_WaitForInput
	jp Func_4295

Func_4436: ; 4436 (1:4436)
INCBIN "baserom.gbc",$4436, $4585 - $4436

OpenBattleCheckMenu: ; 4585 (1:4585)
	call Func_3b31
	call Func_3096
	jp Func_426d

INCBIN "baserom.gbc",$458e, $46fc - $458e

OpenBattleAttackMenu: ; 46fc (1:46fc)
	call CheckIfCantAttackDueToAttackEffect
	jr c, .alertCantAttackAndCancelMenu
	call CheckIfActiveCardParalyzedOrAsleep
	jr nc, .clearSubMenuSelection

.alertCantAttackAndCancelMenu
	call DrawWideTextBox_WaitForInput
	jp Func_4295

.clearSubMenuSelection
	xor a
	ld [wSelectedDuelSubMenuItem], a

.tryOpenAttackMenu
	call LoadPokemonAttacksToDuelPointerTable
	or a
	jr nz, .openAttackMenu
	text_hl NoSelectableAttack
	call DrawWideTextBox_WaitForInput
	jp Func_4295

.openAttackMenu
	push af
	ld a, [wSelectedDuelSubMenuItem]
	ld hl, AttackMenuCursorProperties
	call InitializeCursorParameters
	pop af
	ld [wNumMenuItems], a
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_ARENA_CARD
	ld a, [hl]
	call LoadDeckCardToBuffer1

.asm_4736
	call DoFrame
	ldh a, [hButtonsPressed]
	and $08
	jr nz, .displaySelectedMoveInfo
	call MenuCursorAcceptInput
	jr nc, .asm_4736
	cp $ff
	jp z, Func_4295
	ld [wSelectedDuelSubMenuItem], a
	call $488f
	jr nc, .asm_4759
	text_hl NotEnoughEnergyCards
	call DrawWideTextBox_WaitForInput
	jr .tryOpenAttackMenu

.asm_4759
	ldh a, [hCurrentMenuItem]
	add a
	ld e, a
	ld d, $00
	ld hl, DuelAttackPointerTable
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	call Func_16c0
	call Func_33e1
	jr c, .asm_477d
	ld a, $07
	call $51e7
	jp c, Func_4268
	call Func_1730
	jp c, Func_426d
	ret

.asm_477d ; 477d (1:477d)
	call DrawWideTextBox_WaitForInput
	jr .tryOpenAttackMenu

.displaySelectedMoveInfo ; 4782 (1:4782)
	call Func_478b
	call $4f9d
	jp .tryOpenAttackMenu

Func_478b: ; 478b (1:478b)
	ld a, $01
	ld [wCardPageNumber], a
	xor a
	ld [$cbc9], a
	call Func_04a2
	call Func_3b31
	ld de, $8a00
	call $59ca
	call $5a0e
	call $59f5
	call $5a34
	ld de, $3830
	call $5999
	ld de, $0604
	call $5a56
	ldh a, [hCurrentMenuItem]
	ld [wSelectedDuelSubMenuItem], a
	add a
	ld e, a
	ld d, $00
	ld hl, $c511
	add hl, de
	ld a, [hl]
	or a
	jr nz, .asm_47c9
	xor a
	jr .asm_47cb

.asm_47c9
	ld a, $02

.asm_47cb
	ld [$cc04], a

.asm_47ce
	call Func_47ec
	call EnableLCD

.asm_47d4
	call DoFrame
	ldh a, [hButtonsPressed2]
	and a, $30
	jr nz, .asm_47ce
	ldh a, [hButtonsPressed]
	and a, $03
	jr z, .asm_47d4
	ret

AttackMenuCursorProperties:
	db $01
	db $0d
	db $02
	db $02
	db $0f
	db $00
	db $00
	db $00

Func_47ec: ; $47ec (1:47ec)
	ld a, [$cc04]
	ld hl, $47f5
	jp JumpToFunctionInTable

PtrTable_47f5: ; $47f5 (1:47f5)
	dw Func_47fd
	dw Func_4802
	dw Func_480d
	dw Func_4812

Func_47fd: ; $47fd (1:47fd)
	call $5d1f
	jr Func_481b

Func_4802: ; $4802 (1:4802)
	ld hl, $cc38
	ld a, [hli]
	or [hl]
	ret z
	call $5d27
	jr Func_481b

Func_480d: ; $480d (1:480d)
	call $5d2f
	jr Func_481b

Func_4812: ; $4812 (1:4812)
	ld hl, $cc4b
	ld a, [hli]
	or [hl]
	ret z
	call $5d37

Func_481b: ; $481b (1:481b)
	ld hl, $cc04
	ld a, $01
	xor [hl]
	ld [hl], a
	ret

LoadPokemonAttacksToDuelPointerTable: ; 4823 (1:4823)
	call DrawWideTextBox
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [$ff98], a
	call LoadDeckCardToBuffer1
	ld c, $00
	ld b, $0d
	ld hl, DuelAttackPointerTable
	xor a
	ld [$cbc7], a
	ld de, wCardBuffer1Move1Name
	call CheckIfMoveExists
	jr c, .checkForSecondAttackSlot
	ldh a, [$ff98]
	ld [hli], a
	xor a
	ld [hli], a
	inc c
	push hl
	push bc
	ld e, b
	ld hl, wCardBuffer1Move1Name
	call $5c33
	pop bc
	pop hl
	inc b
	inc b

.checkForSecondAttackSlot
	ld de, wCardBuffer1Move2Name
	call CheckIfMoveExists
	jr c, .finishLoadingAttacks
	ldh a, [$ff98]
	ld [hli], a
	ld a, $01
	ld [hli], a
	inc c
	push hl
	push bc
	ld e, b
	ld hl, $cc47
	call $5c33
	pop bc
	pop hl

.finishLoadingAttacks
	ld a, c
	ret

CheckIfMoveExists: ; 4872 (1:4872)
	push hl
	push de
	push bc
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	or c
	jr z, .returnNoMoveFound
	ld hl, wCardBuffer1Move1Category - (wCardBuffer1Move1Name + 1)
	add hl, de
	ld a, [hl]
	and $ff - RESIDUAL
	cp POKEMON_POWER
	jr z, .returnNoMoveFound
	or a

.return
	pop bc
	pop de
	pop hl
	ret

.returnNoMoveFound
	scf
	jr .return

INCBIN "baserom.gbc",$488f, $4918 - $488f

CheckIfActiveCardParalyzedOrAsleep: ; 4918 (1:4918)
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and $0f
	cp CARD_PARALYZED
	jr z, .paralyzed
	cp CARD_ASLEEP
	jr z, .asleep
	or a
	ret

.paralyzed
	text_hl UnableDueToParalysis
	jr .returnWithStatusCondition

.asleep
	text_hl UnableDueToSleep

.returnWithStatusCondition:
	scf
	ret

INCBIN "baserom.gbc",$4933, $5aeb - $4933

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

INCBIN "baserom.gbc",$67b2,$6d84 - $67b2

;converts clefairy doll/mysterious fossil at specified wCardBuffer to pokemon card
ConvertTrainerCardToPokemon:
	ld c, a
	ld a, [hl]
	cp TRAINER_CARD
	ret nz
	push hl
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, c
	ld a, [hl]
	and TRAINER_CARD
	pop hl
	ret z
	ld a, e
	cp MYSTERIOUS_FOSSIL
	jr nz, .checkForClefairyDoll
	ld a, d
	cp $00
	jr z, .startRamDataOverwrite
	ret
.checkForClefairyDoll
	cp CLEFAIRY_DOLL
	ret nz
	ld a, d
	cp $00
	ret nz
.startRamDataOverwrite
	push de
	ld [hl], COLORLESS
	ld bc, wCardBuffer1HP - wCardBuffer1
	add hl, bc
	ld de, .dataToOverwrite
	ld c, wCardBuffer1Unknown2 - wCardBuffer1HP
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop de
	ret

.dataToOverwrite
    db 10                 ; hp
    ds $07                ; wCardBuffer1Move1Name - (wCardBuffer1HP + 1)
    tx DiscardName        ; move1 name
    tx DiscardDescription ; move1 description
    ds $03                ; wCardBuffer1Move1Category - (wCardBuffer1Move1Description + 2)
    db POKEMON_POWER      ; move1 category
    dw TrainerCardAsPokemonEffectCommands ; move1 effect commands
    ds $18                ; wCardBuffer1RetreatCost - (wCardBuffer1Move1EffectCommands + 2)
    db UNABLE_RETREAT     ; retreat cost
    ds $0d                ; PKMN_CARD_DATA_LENGTH - (wCardBuffer1RetreatCost + 1 - wCardBuffer1)

INCBIN "baserom.gbc",$6df1,$7107 - $6df1

; initializes duel variables such as cards in deck and in hand, or Pokemon in play area
; player turn: [c200, c2ff]
; opponent turn: [c300, c3ff]
InitializeDuelVariables: ; 7107 (1:7107)
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_DUELIST_TYPE
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
	ld bc, DECK_SIZE ; lb bc, DUELVARS_CARD_LOCATIONS, DECK_SIZE
	ld l, DUELVARS_DECK_CARDS
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
	ld l, DUELVARS_ARENA_CARD
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
