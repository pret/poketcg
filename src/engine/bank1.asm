Func_4000: ; 4000 (1:4000)
	di
	ld sp, $e000
	call ResetSerial
	call EnableInt_VBlank
	call EnableInt_Timer
	call EnableExtRAM
	ld a, [$a006]
	ld [wTextSpeed], a
	ld a, [$a009]
	ld [wccf2], a
	call DisableExtRAM
	ld a, $1
	ld [wUppercaseFlag], a
	ei
	farcall Func_1a6cc
	ldh a, [hButtonsHeld]
	cp A_BUTTON | B_BUTTON
	jr z, .asm_4035
	farcall Func_126d1
	jr Func_4000
.asm_4035
	call Func_405a
	call Func_04a2
	text_hl ResetBackUpRamText
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
	ld a, [wcc19]
	ld [wOpponentDeckId], a
	call LoadPlayerDeck
	call SwapTurn
	call LoadOpponentDeck
	call SwapTurn
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
	ld [wcbe5], a
	ld a, h
	ld [wcbe6], a
	xor a
	ld [wCurrentDuelMenuItem], a
	call $420b
	ld a, [wcc18]
	ld [wcc08], a
	call $70aa
	ld a, [wDuelTheme]
	call PlaySong
	call $4b60
	ret c

; the loop returns here after every turn switch
.mainDuelLoop ; 40ee (1:40ee)
	xor a
	ld [wCurrentDuelMenuItem], a
	call HandleSwordsDanceOrFocusEnergySubstatus
	call $54c8
	call DrawCardFromDeck
	call Func_0f58
	ld a, [wDuelFinished]
	or a
	jr nz, .duelFinished
	call UpdateSubstatusConditions
	call $6baf
	call Func_3b31
	call Func_0f58
	ld a, [wDuelFinished]
	or a
	jr nz, .duelFinished
	ld hl, $cc06
	inc [hl]
	ld a, [wcc09]
	cp $80
	jr z, .asm_4126

.nextTurn
	call SwapTurn
	jr .mainDuelLoop

.asm_4126
	ld a, [wIsPracticeDuel]
	or a
	jr z, .nextTurn
	ld a, [hl]
	cp $f
	jr c, .nextTurn
	xor a
	ld [wd0c3], a
	ret

.duelFinished
	call $5990
	call Func_04a2
	ld a, $3
	call Func_2167
	text_hl DecisionText
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
	ld c, MUSIC_DARKDIDDLY
	text_hl DuelWasDrawText
	jr .handleDuelFinished

.activeDuelistWonBattle
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .opponentWonBattle
.playerWonBattle
	xor a
	ld [wd0c3], a
	ld a, $5d
	ld c, MUSIC_MATCHVICTORY
	text_hl WonDuelText
	jr .handleDuelFinished

.activeDuelistLostBattle
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .playerWonBattle
.opponentWonBattle
	ld a, $1
	ld [wd0c3], a
	ld a, $5e
	ld c, MUSIC_MATCHLOSS
	text_hl LostDuelText

.handleDuelFinished
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
	text_hl StartSuddenDeathMatchText
	call DrawWideTextBox_WaitForInput
	ld a, $1
	ld [wcc08], a
	call $70aa
	ld a, [wcc09]
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

DrawCardFromDeck: ; 4225 (1:4225)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld [wcc0d], a
	ld a, [wcc06]
	cp a, $02
	jr c, .asm_4237
	call $70f6

.asm_4237
	call $70e6
	call $4933
	call _DrawCardFromDeck
	jr nc, .deckNotEmpty
	ld a, DUEL_LOST
	ld [wDuelFinished], a
	ret

.deckNotEmpty
	ldh [hTempCardNumber], a
	call AddCardToHand
	ld a, [wcc0d]
	cp $00
	jr z, Func_4262
	call SwapTurn
	call Func_34e2
	call SwapTurn
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
	ld a, [wcc0d]
	cp a, $00
	jr z, PrintDuelMenu
	cp a, $01
	jp z, $6911
	xor a
	ld [wVBlankCtr], a
	ld [wcbf9], a
	text_hl DuelistIsThinkingText
	call Func_2a36
	call Func_2bbf
	ld a, $ff
	ld [wcc11], a
	ld [wcc10], a
	ret

PrintDuelMenu:
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
	bit D_UP_F, a
	jr nz, Func_430b
	bit D_DOWN_F, a
	jr nz, Func_4311
	bit D_LEFT_F, a
	jr nz, Func_4320
	bit D_RIGHT_F, a
	jr nz, Func_4317
	bit START_F, a
	jp nz, $4364

.asm_42cc
	ldh a, [hButtonsPressed]
	and a, START
	jp nz, $4370
	ldh a, [hButtonsPressed]
	bit SELECT_F, a
	jp nz, $458e
	ld a, [wcbe7]
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
	jp c, PrintDuelMenu
	jp Func_426d

Func_4320: ; 4320 (1:4320)
	call Func_4342
	jp c, PrintDuelMenu
	jp Func_426d

Func_4329: ; 4329 (1:4329)
	call SwapTurn
	call Func_4333
	call SwapTurn
	ret

Func_4333: ; 4333 (1:4333)
	call $5fdd
	jp $6008

Func_4339: ; 4339 (1:4339)
	call SwapTurn
	call $5550
	jp SwapTurn

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
	and a,PASSIVE_STATUS_MASK
	cp a, $01
	ldh [$ffa0], a
	jr nz, Func_43f1
	ld a, [wcc0c]
	or a
	jr nz, Func_43e8
	call $45bb
	jr c, Func_441f
	call $4611
	jr c, Func_441c
	text_hl SelectMonOnBenchToSwitchWithActiveText
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
	text_hl UnableToRetreatText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

Func_43f1: ; 43f1 (1:43f1)
	call $45bb
	jr c, Func_441f
	call $4611
	jr c, Func_441c
	call $6558
	text_hl SelectMonOnBenchToSwitchWithActiveText
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
	jp PrintDuelMenu

OpenHandMenu: ; 4425 (1:4425)
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	or a
	jr nz, Func_4436
	text_hl NoCardsInHandText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

Func_4436: ; 4436 (1:4436)
INCBIN "baserom.gbc",$4436, $4477 - $4436

; c contains the energy card being played
PlayerUseEnergyCard: ; 4477 (1:4477)
	ld a, c
	cp WATER_ENERGY_CARD ; XXX why treat water energy card differently?
	jr nz, .notWaterEnergy
	call $3615
	jr c, .waterEnergy

.notWaterEnergy
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .alreadyPlayedEnergy
	call $5fdd
	call $600c ; choose card to play energy card on
	jp c, Func_426d ; exit if no card was chosen
.asm_4490
	ld a, $1
	ld [wAlreadyPlayedEnergy], a
.asm_4495
	ld a, [$ff9d]
	ld [$ffa1], a
	ld e, a
	ld a, [$ff98]
	ld [$ffa0], a
	call $14d2
	call $61b8
	ld a, $3
	call Func_0f7f
	call $68e4
	jp Func_426d

.waterEnergy
	call $5fdd
	call $600c ; choose card to play energy card on
	jp c, Func_426d ; exit if no card was chosen
	call $3622
	jr c, .asm_4495
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr z, .asm_4490
	text_hl OnlyOneEnergyCardText
	call DrawWideTextBox_WaitForInput
	jp Func_4436

.alreadyPlayedEnergy
	text_hl OnlyOneEnergyCardText
	call DrawWideTextBox_WaitForInput
	call $123b
	call $55be
	jp $4447
; 0x44db

INCBIN "baserom.gbc",$44db, $4585 - $44db

OpenBattleCheckMenu: ; 4585 (1:4585)
	call Func_3b31
	call Func_3096
	jp Func_426d

INCBIN "baserom.gbc",$458e, $46fc - $458e

OpenBattleAttackMenu: ; 46fc (1:46fc)
	call HandleCantAttackSubstatus
	jr c, .alertCantAttackAndCancelMenu
	call CheckIfActiveCardParalyzedOrAsleep
	jr nc, .clearSubMenuSelection

.alertCantAttackAndCancelMenu
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

.clearSubMenuSelection
	xor a
	ld [wSelectedDuelSubMenuItem], a

.tryOpenAttackMenu
	call LoadPokemonMovesToDuelCardOrAttackList
	or a
	jr nz, .openAttackMenu
	text_hl NoSelectableAttackText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

.openAttackMenu
	push af
	ld a, [wSelectedDuelSubMenuItem]
	ld hl, AttackMenuCursorData
	call InitializeCursorParameters
	pop af
	ld [wNumMenuItems], a
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_ARENA_CARD
	ld a, [hl]
	call LoadDeckCardToBuffer1

.waitForInput
	call DoFrame
	ldh a, [hButtonsPressed]
	and START
	jr nz, .displaySelectedMoveInfo
	call MenuCursorAcceptInput
	jr nc, .waitForInput
	cp $ff ; was B pressed?
	jp z, PrintDuelMenu
	ld [wSelectedDuelSubMenuItem], a
	call CheckIfEnoughEnergies
	jr nc, .enoughEnergy
	text_hl NotEnoughEnergyCardsText
	call DrawWideTextBox_WaitForInput
	jr .tryOpenAttackMenu

.enoughEnergy
	ldh a, [hCurrentMenuItem]
	add a
	ld e, a
	ld d, $00
	ld hl, wDuelCardOrAttackList
	add hl, de
	ld d, [hl] ; card number within the deck (0 to 59)
	inc hl
	ld e, [hl] ; attack index (0 or 1)
	call CopyMoveDataAndDamageToBuffer
	call HandleAmnesiaSubstatus
	jr c, .cannotUseDueToAmnesia
	ld a, $07
	call $51e7
	jp c, Func_4268
	call Func_1730
	jp c, Func_426d
	ret

.cannotUseDueToAmnesia ; 477d (1:477d)
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
	ld [wcbc9], a
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
	ld [wcc04], a

.asm_47ce
	call Func_47ec
	call EnableLCD

.asm_47d4
	call DoFrame
	ldh a, [hButtonsPressed2]
	and a, D_RIGHT | D_LEFT
	jr nz, .asm_47ce
	ldh a, [hButtonsPressed]
	and a, A_BUTTON | B_BUTTON
	jr z, .asm_47d4
	ret

AttackMenuCursorData:
	db $01
	db $0d
	db $02
	db $02
	db $0f
	db $00
	db $00
	db $00

Func_47ec: ; $47ec (1:47ec)
	ld a, [wcc04]
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

; copies the following to the c510 buffer:
;   if pokemon's second moveslot is empty: <card_no>, 0
;   else: <card_no>, 0, <card_no>, 1
LoadPokemonMovesToDuelCardOrAttackList: ; 4823 (1:4823)
	call DrawWideTextBox
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardNumber], a
	call LoadDeckCardToBuffer1
	ld c, $00
	ld b, $0d
	ld hl, wDuelCardOrAttackList
	xor a
	ld [wCardPageNumber], a
	ld de, wCardBuffer1Move1Name
	call CheckIfMoveExists
	jr c, .checkForSecondAttackSlot
	ldh a, [hTempCardNumber]
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
	ldh a, [hTempCardNumber]
	ld [hli], a
	ld a, $01
	ld [hli], a
	inc c
	push hl
	push bc
	ld e, b
	ld hl, wCardBuffer1Move2Name
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

; check if the arena pokemon card has enough energy attached to it
; in order to use the selected move.
; returns: carry if not enough energy, nc if enough energy.
CheckIfEnoughEnergies: ; 488f (1:488f)
	push hl
	push bc
	ld e, $0
	call GetAttachedEnergies
	call HandleEnergyBurn
	ldh a, [hCurrentMenuItem]
	add a
	ld e, a
	ld d, $0
	ld hl, wDuelCardOrAttackList
	add hl, de
	ld d, [hl] ; card number within the deck (0 to 59)
	inc hl
	ld e, [hl] ; attack index (0 or 1)
	call _CheckIfEnoughEnergies
	pop bc
	pop hl
	ret
; 0x48ac

; check if a pokemon card has enough energy attached to it in order to use a move
; input:
;   d = card number within the deck (0 to 59)
;   e = attack index (0 or 1)
;   wAttachedEnergies and wTotalAttachedEnergies
; returns: carry if not enough energy, nc if enough energy.
_CheckIfEnoughEnergies: ; 48ac (1:48ac)
	push de
	ld a, d
	call LoadDeckCardToBuffer1
	pop bc
	push bc
	ld de, wCardBuffer1Move1Energy
	ld a, c
	or a
	jr z, .gotMove
	ld de, wCardBuffer1Move2Energy

.gotMove
	ld hl, wCardBuffer1Move1Name - wCardBuffer1Move1Energy
	add hl, de
	ld a, [hli]
	or [hl]
	jr z, .notUsable
	ld hl, wCardBuffer1Move1Category - wCardBuffer1Move1Energy
	add hl, de
	ld a, [hl]
	cp POKEMON_POWER
	jr z, .notUsable
	xor a
	ld [wAttachedEnergiesAccum], a
	ld hl, wAttachedEnergies
	ld c, (COLORLESS - FIRE) / 2
.nextEnergyTypePair
	ld a, [de]
	swap a
	call _CheckIfEnoughEnergiesOfType
	jr c, .notEnoughEnergies
	ld a, [de]
	call _CheckIfEnoughEnergiesOfType
	jr c, .notEnoughEnergies
	inc de
	dec c
	jr nz, .nextEnergyTypePair
	ld a, [de] ; colorless energy
	swap a
	and $f
	ld b, a
	ld a, [wAttachedEnergiesAccum]
	ld c, a
	ld a, [wTotalAttachedEnergies]
	sub c
	cp b
	jr c, .notEnoughEnergies
	or a
.asm_48fb
	pop de
	ret

.notUsable
.notEnoughEnergies
	scf
	jr .asm_48fb
; 0x4900

; given the amount of energies of a specific type required for an attack in the
; lower nybble of register a, test if the pokemon card has enough energies of that type
; to use the move. Return carry if not enough energy, nc if enough energy.
_CheckIfEnoughEnergiesOfType: ; 4900 (1:4900)
	and $f
	push af
	push hl
	ld hl, wAttachedEnergiesAccum
	add [hl]
	ld [hl], a ; accumulate the amount of energies required
	pop hl
	pop af
	jr z, .enoughEnergies ; jump if no energies of this type are required
	cp [hl]
	; jump if the energies required of this type are not more than the amount attached
	jr z, .enoughEnergies
	jr c, .enoughEnergies
	inc hl
	scf
	ret

.enoughEnergies
	inc hl
	or a
	ret
; 0x4918

CheckIfActiveCardParalyzedOrAsleep: ; 4918 (1:4918)
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and PASSIVE_STATUS_MASK
	cp PARALYZED
	jr z, .paralyzed
	cp ASLEEP
	jr z, .asleep
	or a
	ret

.paralyzed
	text_hl UnableDueToParalysisText
	jr .returnWithStatusCondition

.asleep
	text_hl UnableDueToSleepText

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

INCBIN "baserom.gbc",$67b2,$67be - $67b2

; related to ai taking their turn in a duel
; called multiple times during one ai turn
AIMakeDecision: ; 67be (1:67be)
	ld [$ff9e], a
	ld hl, $cbf9
	ld a, [hl]
	ld [hl], $0
	or a
	jr nz, .skipDelay
.delayLoop
	call DoFrame
	ld a, [wVBlankCtr]
	cp $3c
	jr c, .delayLoop

.skipDelay
	ld a, [$ff9e]
	ld hl, $cbe1
	ld [hl], $0
	ld hl, AIMoveTable
	call JumpToFunctionInTable
	ld a, [wDuelFinished]
	ld hl, $cbe1
	or [hl]
	jr nz, .turnEnded
	ld a, [wcbf9]
	or a
	ret nz
	ld [wVBlankCtr], a
	ld hl, $0088
	call Func_2a36
	or a
	ret

.turnEnded
	scf
	ret
; 0x67fb

INCBIN "baserom.gbc",$67fb,$695e - $67fb

AIMoveTable: ; 695e (1:695e)
	dw Func_0f35
	dw $69e0
	dw $69c5
	dw AIUseEnergyCard
	dw $69ff
	dw $6993
	dw $6a23
	dw $6a35
	dw $6a4e
	dw $6a8c
	dw $6ab1
	dw $698c
	dw $6ad9
	dw $6b07
	dw $6aba
	dw $6b7d
	dw $6b7d
	dw $6b24
	dw $6b30
	dw $6b7d
	dw $6b3e
	dw $6b15
	dw $6b20

INCBIN "baserom.gbc",$698c,$69a5 - $698c

AIUseEnergyCard: ; 69a5 (1:69a5)
	ld a, [$ffa1]
	ld [$ff9d], a
	ld e, a
	ld a, [$ffa0]
	ld [$ff98], a
	call $14d2
	ld a, [$ffa0]
	call LoadDeckCardToBuffer1
	call $5e75
	call $68e4
	ld a, $1
	ld [wAlreadyPlayedEnergy], a
	call $4f9d
	ret
; 0x69c5

INCBIN "baserom.gbc",$69c5,$6d84 - $69c5

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
	lb bc, DUELVARS_CARD_LOCATIONS, DECK_SIZE
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

INCBIN "baserom.gbc",$7133,$71ad - $7133

_TossCoin: ; 71ad (1:71ad)
	ld [wcd9c], a
	ld a, [wcac2]
	cp $6
	jr z, .asm_71c1
	xor a
	ld [wcd9f], a
	call Func_04a2
	call $210f

.asm_71c1
	ld a, [wcd9f]
	or a
	jr nz, .asm_71ec
	ld a, $6
	ld [wcac2], a
	ld de, $000c
	ld bc, $1406
	ld hl, $0000
	call DrawLabeledTextBox
	call EnableLCD
	ld de, $010e
	ld a, $13
	call Func_22a6
	ld hl, wCoinTossScreenTextId
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText

.asm_71ec
	ld hl, wCoinTossScreenTextId
	xor a
	ld [hli], a
	ld [hl], a
	call EnableLCD
	ld a, $f1
	call GetTurnDuelistVariable
	ld [wcd9e], a
	call Func_0f58
	xor a
	ld [wcd9d], a

.asm_7204
	ld a, [wcd9c]
	cp $2
	jr c, .asm_7223
	ld bc, $0f0b
	ld a, [wcd9f]
	inc a
	call $65b7
	ld b, $11
	ld a, $2e
	call Func_06c3
	inc b
	ld a, [wcd9c]
	call $65b7

.asm_7223
	call Func_3b21
	ld a, $58
	call Func_3b6a
	ld a, [wcd9e]
	or a
	jr z, .asm_7236
	call $7324
	jr .asm_723c

.asm_7236
	call WaitForWideTextBoxInput
	call $72ff

.asm_723c
	call Func_3b21
	ld d, $5a
	ld e, $0
	call UpdateRNGSources
	rra
	jr c, .asm_724d
	ld d, $59
	ld e, $1

.asm_724d
	ld a, d
	call Func_3b6a
	ld a, [wcd9e]
	or a
	jr z, .asm_725e
	ld a, e
	call $7310
	ld e, a
	jr .asm_726c

.asm_725e
	push de
	call DoFrame
	call Func_3b52
	pop de
	jr c, .asm_725e
	ld a, e
	call $72ff

.asm_726c
	ld b, $5c
	ld c, $34
	ld a, e
	or a
	jr z, .asm_727c
	ld b, $5b
	ld c, $30
	ld hl, $cd9d
	inc [hl]

.asm_727c
	ld a, b
	call Func_3b6a
	ld a, [wcd9e]
	or a
	jr z, .asm_728a
	ld a, $1
	xor e
	ld e, a

.asm_728a
	ld d, $54
	ld a, e
	or a
	jr nz, .asm_7292
	ld d, $55

.asm_7292
	ld a, d
	call Func_3796
	ld a, [wcd9c]
	dec a
	jr z, .asm_72b9
	ld a, c
	push af
	ld e, $0
	ld a, [wcd9f]
.asm_72a3
	cp $a
	jr c, .asm_72ad
	inc e
	inc e
	sub $a
	jr .asm_72a3

.asm_72ad
	add a
	ld d, a
	ld bc, $0202
	ld hl, $0102
	pop af
	call Func_1f5f

.asm_72b9
	ld hl, $cd9f
	inc [hl]
	ld a, [wcd9e]
	or a
	jr z, .asm_72dc
	ld a, [hl]
	ld hl, $cd9c
	cp [hl]
	call z, WaitForWideTextBoxInput
	call $7324
	ld a, [wcd9c]
	ld hl, $cd9d
	or [hl]
	jr nz, .asm_72e2
	call z, WaitForWideTextBoxInput
	jr .asm_72e2

.asm_72dc
	call WaitForWideTextBoxInput
	call $72ff

.asm_72e2
	call Func_3b31
	ld a, [wcd9f]
	ld hl, $cd9c
	cp [hl]
	jp c, .asm_7204
	call Func_0f58
	call Func_3b31
	call Func_3b21
	ld a, [wcd9d]
	or a
	ret z
	scf
	ret
; 0x72ff

INCBIN "baserom.gbc",$72ff,$7354 - $72ff

BuildVersion: ; 7354 (1:7354)
	db "VER 12/20 09:36",TX_END

INCBIN "baserom.gbc",$7364,$7571 - $7364

Func_7571: ; 7571 (1:7571)
INCBIN "baserom.gbc",$7571,$758f - $7571

Func_758f: ; 758f (1:758f)
INCBIN "baserom.gbc",$758f,$8000 - $758f
