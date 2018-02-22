; continuation of Bank0 Start
Start_Cont: ; 4000 (1:4000)
	di
	ld sp, $e000
	call ResetSerial
	call EnableInt_VBlank
	call EnableInt_Timer
	call EnableSRAM
	ld a, [$a006]
	ld [wTextSpeed], a
	ld a, [$a009]
	ld [wccf2], a
	call DisableSRAM
	ld a, $1
	ld [wUppercaseFlag], a
	ei
	farcall Func_1a6cc
	ldh a, [hButtonsHeld]
	cp A_BUTTON | B_BUTTON
	jr z, .ask_erase_backup_ram
	farcall Func_126d1
	jr Start_Cont
.ask_erase_backup_ram
	call Func_405a
	call EmptyScreen
	ldtx hl, ResetBackUpRamText
	call YesOrNoMenuWithText
	jr c, .reset_game
; erase sram
	call EnableSRAM
	xor a
	ld [$a000], a
	call DisableSRAM
.reset_game
	jp Reset

Func_4050: ; 4050 (1:4050)
	farcall Func_1996e
	ld a, $1
	ld [wUppercaseFlag], a
	ret

Func_405a: ; 405a (1:405a)
	xor a
	ld [wTileMapFill], a
	call DisableLCD
	call Func_2119
	call Func_5aeb
	ld de, $387f
	call Func_2275
	ret
; 0x406e

CommentedOut_406e: ; 406e (1:406e)
	ret
; 0x406f

Func_406f: ; 406f (1:406f)
	call Func_420b
	call $66e9
	ldtx hl, BackUpIsBrokenText
	jr c, .asm_4097
	ld hl, sp+$00
	ld a, l
	ld [wcbe5], a
	ld a, h
	ld [wcbe6], a
	call ClearJoypad
	ld a, [wDuelTheme]
	call PlaySong
	xor a
	ld [wDuelFinished], a
	call DuelMainScene
	jp StartDuel.asm_40fb
.asm_4097
	call DrawWideTextBox_WaitForInput
	call ResetSerial
	scf
	ret
; 0x409f

; this function begins the duel after the opponent's
; graphics, name and deck have been introduced
StartDuel: ; 409f (1:409f)
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ld a, DUELIST_TYPE_PLAYER
	ld [wPlayerDuelistType], a
	ld a, [wcc19]
	ld [wOpponentDeckId], a
	call LoadPlayerDeck
	call SwapTurn
	call LoadOpponentDeck
	call SwapTurn
	jr .asm_40ca

	ld a, MUSIC_DUEL_THEME_1
	ld [wDuelTheme], a
	ld hl, wOpponentName
	xor a
	ld [hli], a
	ld [hl], a
	ld [wIsPracticeDuel], a

.asm_40ca
	ld hl, sp+$0
	ld a, l
	ld [wcbe5], a
	ld a, h
	ld [wcbe6], a
	xor a
	ld [wCurrentDuelMenuItem], a
	call Func_420b
	ld a, [wcc18]
	ld [wcc08], a
	call $70aa
	ld a, [wDuelTheme]
	call PlaySong
	call Func_4b60
	ret c

; the loop returns here after every turn switch
.main_duel_loop ; 40ee (1:40ee)
	xor a
	ld [wCurrentDuelMenuItem], a
	call HandleSwordsDanceOrFocusEnergySubstatus
	call $54c8
	call HandleTurn

.asm_40fb
	call Func_0f58
	ld a, [wDuelFinished]
	or a
	jr nz, .duel_finished
	call UpdateSubstatusConditions
	call $6baf
	call Func_3b31
	call Func_0f58
	ld a, [wDuelFinished]
	or a
	jr nz, .duel_finished
	ld hl, wDuelTurns
	inc [hl]
	ld a, [wcc09]
	cp $80
	jr z, .asm_4126

.next_turn
	call SwapTurn
	jr .main_duel_loop

.asm_4126
	ld a, [wIsPracticeDuel]
	or a
	jr z, .next_turn
	ld a, [hl]
	cp $f
	jr c, .next_turn
	xor a
	ld [wd0c3], a
	ret

.duel_finished
	call $5990
	call EmptyScreen
	ld a, BOXMSG_DECISION
	call DrawDuelBoxMessage
	ldtx hl, DecisionText
	call DrawWideTextBox_WaitForInput
	call EmptyScreen
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
	jr z, .active_duelist_won_battle
	cp DUEL_LOST
	jr z, .active_duelist_lost_batte
	ld a, $5f
	ld c, MUSIC_DARK_DIDDLY
	ldtx hl, DuelWasDrawText
	jr .handle_duel_finished

.active_duelist_won_battle
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .opponent_won_battle
.player_won_battle
	xor a
	ld [wd0c3], a
	ld a, $5d
	ld c, MUSIC_MATCH_VICTORY
	ldtx hl, WonDuelText
	jr .handle_duel_finished

.active_duelist_lost_batte
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .player_won_battle
.opponent_won_battle
	ld a, $1
	ld [wd0c3], a
	ld a, $5e
	ld c, MUSIC_MATCH_LOSS
	ldtx hl, LostDuelText

.handle_duel_finished
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
	jr z, .tied_battle
	call Func_39fc
	call WaitForWideTextBoxInput
	call Func_3b31
	call ResetSerial
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ret

.tied_battle
	call WaitForWideTextBoxInput
	call Func_3b31
	ld a, [wDuelTheme]
	call PlaySong
	ldtx hl, StartSuddenDeathMatchText
	call DrawWideTextBox_WaitForInput
	ld a, $1
	ld [wcc08], a
	call $70aa
	ld a, [wcc09]
	cp $1
	jr z, .asm_41f3
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call Func_4b60
	jp .main_duel_loop

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
	call Func_4b60
	jp nc, .main_duel_loop
	ret
; 0x420b

Func_420b: ; 420b (1:420b)
	xor a
	ld [wTileMapFill], a
	call $5990
	call EmptyScreen
	call Func_2119
	call Func_5aeb
	ld de, $389f
	call Func_2275
	call EnableLCD
	ret
; 0x4225

HandleTurn: ; 4225 (1:4225)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld [wDuelistType], a
	ld a, [wDuelTurns]
	cp 2
	jr c, .asm_4237 ; jump if it's the turn holder's first turn
	call $70f6

.asm_4237
	call $70e6
	call $4933
	call DrawCardFromDeck
	jr nc, .deck_not_empty
	ld a, DUEL_LOST
	ld [wDuelFinished], a
	ret

.deck_not_empty
	ldh [hTempCardIndex_ff98], a
	call AddCardToHand
	ld a, [wDuelistType]
	cp DUELIST_TYPE_PLAYER
	jr z, Func_4262
	call SwapTurn
	call Func_34e2
	call SwapTurn
	call c, $4b2c
	jr DuelMainScene

Func_4262:
	call $4b2c
	call Func_100b

Func_4268:
	ld a, $06
	call $51e7

DuelMainScene:
	call $4f9d
	ld a, [wDuelistType]
	cp DUELIST_TYPE_PLAYER
	jr z, PrintDuelMenu
	cp DUELIST_TYPE_LINK_OPP
	jp z, $6911
	; DUELIST_TYPE_AI_OPP
	xor a
	ld [wVBlankCtr], a
	ld [wcbf9], a
	ldtx hl, DuelistIsThinkingText
	call DrawWideTextBox_PrintTextNoDelay
	call Func_2bbf
	ld a, $ff
	ld [wcc11], a
	ld [wcc10], a
	ret

PrintDuelMenu:
	call DrawWideTextBox
	ld hl, $54e9
	call Func_2c08
.asm_429e
	call $669d
	ld a, [wDuelFinished]
	or a
	ret nz
	ld a, [wCurrentDuelMenuItem]
	call SetMenuItem

HandleDuelMenuInput:
	call DoFrame
	ldh a, [hButtonsHeld]
	and B_BUTTON
	jr z, .b_not_held
	ldh a, [hButtonsPressed]
	bit D_UP_F, a
	jr nz, OpponentPlayAreaScreen
	bit D_DOWN_F, a
	jr nz, PlayerPlayAreaScreen
	bit D_LEFT_F, a
	jr nz, PlayerDiscardPileScreen
	bit D_RIGHT_F, a
	jr nz, OpponentDiscardPileScreen
	bit START_F, a
	jp nz, OpponentActivePokemonScreen

.b_not_held
	ldh a, [hButtonsPressed]
	and START
	jp nz, PlayerActivePokemonScreen
	ldh a, [hButtonsPressed]
	bit SELECT_F, a
	jp nz, $458e
	ld a, [wcbe7]
	or a
	jr nz, HandleDuelMenuInput
	call Func_271a
	ld a, e
	ld [wCurrentDuelMenuItem], a
	jr nc, HandleDuelMenuInput
	ldh a, [hCurrentMenuItem]
	ld hl, DuelMenuFunctionTable
	jp JumpToFunctionInTable

DuelMenuFunctionTable: ; 42f1 (1:42f1)
	dw DuelMenu_Hand
	dw DuelMenu_Attack
	dw DuelMenu_Check
	dw DuelMenu_PkmnPower
	dw DuelMenu_Retreat
	dw DuelMenu_Done

Func_42fd: ; 42fd (1:42fd)
	call DrawCardFromDeck
	call nc, AddCardToHand
	ld a, $0b
	call SetDuelAIAction
	jp PrintDuelMenu.asm_429e
; 0x430b

OpponentPlayAreaScreen: ; 430b (1:430b)
	call DrawOpponentPlayAreaScreen
	jp DuelMainScene

PlayerPlayAreaScreen: ; 4311 (1:4311)
	call DrawPlayerPlayAreaScreen
	jp DuelMainScene

OpponentDiscardPileScreen: ; 4317 (1:4317)
	call DrawOpponentDiscardPileScreen
	jp c, PrintDuelMenu
	jp DuelMainScene

PlayerDiscardPileScreen: ; 4320 (1:4320)
	call DrawPlayerDiscardPileScreen
	jp c, PrintDuelMenu
	jp DuelMainScene

DrawOpponentPlayAreaScreen: ; 4329 (1:4329)
	call SwapTurn
	call DrawPlayerPlayAreaScreen
	call SwapTurn
	ret

DrawPlayerPlayAreaScreen: ; 4333 (1:4333)
	call $5fdd
	jp $6008

DrawOpponentDiscardPileScreen: ; 4339 (1:4339)
	call SwapTurn
	call $5550
	jp SwapTurn

DrawPlayerDiscardPileScreen: ; 4342 (1:4342)
	jp $5550

Func_4345: ; 4345 (1:4345)
	call SwapTurn
	call Func_434e
	jp SwapTurn
; 0x434e

Func_434e: ; 434e (1:434e)
	call CreateHandCardList
	jr c, .no_cards_in_hand
	call $559a
	ld a, $09
	ld [$cbd6], a
	jp $55f0
.no_cards_in_hand
	ldtx hl, NoCardsInHandText
	jp DrawWideTextBox_WaitForInput
; 0x4364

OpponentActivePokemonScreen: ; 4364 (1:4364)
	call SwapTurn
	call Func_4376
	call SwapTurn
	jp DuelMainScene
; 0x4370

PlayerActivePokemonScreen: ; 4370 (1:4370)
	call Func_4376
	jp DuelMainScene
; 0x4376

Func_4376: ; 4376 (1:4376)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp $ff
	ret z
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1
	ld hl, wcbc9
	xor a
	ld [hli], a
	ld [hl], a
	call $576a
	ret
; 0x438e

DuelMenu_PkmnPower: ; 438e (1:438e)
	call $6431
	jp c, DuelMainScene
	call Func_1730
	jp DuelMainScene

DuelMenu_Done: ; 439a (1:439a)
	ld a, $08
	call $51e7
	jp c, Func_4268
	ld a, $05
	call SetDuelAIAction
	call $717a
	ret

DuelMenu_Retreat: ; 43ab (1:43ab)
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and PASSIVE_STATUS_MASK
	cp $01
	ldh [hffa0], a
	jr nz, Func_43f1
	ld a, [wcc0c]
	or a
	jr nz, Func_43e8
	call $45bb
	jr c, Func_441f
	call $4611
	jr c, Func_441c
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	call $600c
	jr c, Func_441c
	ld [wBenchSelectedPokemon], a
	ld a, [wBenchSelectedPokemon]
	ldh [hTempPlayAreaLocationOffset_ffa1], a
	ld a, $04
	call SetDuelAIAction
	call $657a
	jr nc, Func_441c
	call $4f9d

Func_43e8: ; 43e8
	ldtx hl, UnableToRetreatText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

Func_43f1: ; 43f1 (1:43f1)
	call $45bb
	jr c, Func_441f
	call $4611
	jr c, Func_441c
	call $6558
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	call $600c
	ld [wBenchSelectedPokemon], a
	ldh [hTempPlayAreaLocationOffset_ffa1], a
	push af
	call $6564
	pop af
	jp c, DuelMainScene
	ld a, $04
	call SetDuelAIAction
	call $657a

Func_441c: ; 441c (1:441c)
	jp DuelMainScene

Func_441f: ; 441f (1:441f)
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

DuelMenu_Hand: ; 4425 (1:4425)
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	or a
	jr nz, Func_4436
	ldtx hl, NoCardsInHandText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

Func_4436: ; 4436 (1:4436)
	INCROM $4436,  $4477

; c contains the type of energy card being played
PlayerUseEnergyCard: ; 4477 (1:4477)
	ld a, c
	cp TYPE_ENERGY_WATER ; XXX why treat water energy card differently?
	jr nz, .not_water_energy
	call $3615
	jr c, .water_energy

.not_water_energy
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .already_played_energy
	call $5fdd
	call $600c ; choose card to play energy card on
	jp c, DuelMainScene ; exit if no card was chosen
.asm_4490
	ld a, $1
	ld [wAlreadyPlayedEnergy], a
.asm_4495
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	ldh [hTempPlayAreaLocationOffset_ffa1], a
	ld e, a
	ldh a, [hTempCardIndex_ff98]
	ldh [hffa0], a
	call $14d2
	call $61b8
	ld a, $3
	call SetDuelAIAction
	call $68e4
	jp DuelMainScene

.water_energy
	call $5fdd
	call $600c ; choose card to play energy card on
	jp c, DuelMainScene ; exit if no card was chosen
	call $3622
	jr c, .asm_4495
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr z, .asm_4490
	ldtx hl, OnlyOneEnergyCardText
	call DrawWideTextBox_WaitForInput
	jp Func_4436

.already_played_energy
	ldtx hl, OnlyOneEnergyCardText
	call DrawWideTextBox_WaitForInput
	call CreateHandCardList
	call $55be
	jp $4447
; 0x44db

	INCROM $44db,  $4585

DuelMenu_Check: ; 4585 (1:4585)
	call Func_3b31
	call Func_3096
	jp DuelMainScene

	INCROM $458e,  $46fc

DuelMenu_Attack: ; 46fc (1:46fc)
	call HandleCantAttackSubstatus
	jr c, .alert_cant_attack_and_cancel_menu
	call CheckIfActiveCardParalyzedOrAsleep
	jr nc, .clear_sub_menu_selection

.alert_cant_attack_and_cancel_menu
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

.clear_sub_menu_selection
	xor a
	ld [wSelectedDuelSubMenuItem], a

.try_open_attack_menu
	call LoadPokemonMovesToDuelCardOrAttackList
	or a
	jr nz, .open_attack_menu
	ldtx hl, NoSelectableAttackText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenu

.open_attack_menu
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

.wait_for_input
	call DoFrame
	ldh a, [hButtonsPressed]
	and START
	jr nz, .display_selected_move_info
	call HandleMenuInput
	jr nc, .wait_for_input
	cp $ff ; was B pressed?
	jp z, PrintDuelMenu
	ld [wSelectedDuelSubMenuItem], a
	call CheckIfEnoughEnergies
	jr nc, .enough_energy
	ldtx hl, NotEnoughEnergyCardsText
	call DrawWideTextBox_WaitForInput
	jr .try_open_attack_menu

.enough_energy
	ldh a, [hCurrentMenuItem]
	add a
	ld e, a
	ld d, $00
	ld hl, wDuelCardOrAttackList
	add hl, de
	ld d, [hl] ; card number within the deck (0 to 59)
	inc hl
	ld e, [hl] ; attack index (0 or 1)
	call CopyMoveDataAndDamage
	call HandleAmnesiaSubstatus
	jr c, .cannot_use_due_to_amnesia
	ld a, $07
	call $51e7
	jp c, Func_4268
	call Func_1730
	jp c, DuelMainScene
	ret

.cannot_use_due_to_amnesia ; 477d (1:477d)
	call DrawWideTextBox_WaitForInput
	jr .try_open_attack_menu

.display_selected_move_info ; 4782 (1:4782)
	call Func_478b
	call $4f9d
	jp .try_open_attack_menu

Func_478b: ; 478b (1:478b)
	ld a, $01
	ld [wCardPageNumber], a
	xor a
	ld [wcbc9], a
	call EmptyScreen
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
	and D_RIGHT | D_LEFT
	jr nz, .asm_47ce
	ldh a, [hButtonsPressed]
	and A_BUTTON | B_BUTTON
	jr z, .asm_47d4
	ret

AttackMenuCursorData:
	db 1, 13 ; x, y
	db 2 ; y displacement between items
	db 2 ; number of items
	db $0f ; cursor tile number
	db $00 ; tile behind cursor
	dw $0000 ; unknown function pointer if non-0

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

; copies the following to the wDuelCardOrAttackList buffer:
;   if pokemon's second moveslot is empty: <card_no>, 0
;   else: <card_no>, 0, <card_no>, 1
LoadPokemonMovesToDuelCardOrAttackList: ; 4823 (1:4823)
	call DrawWideTextBox
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardIndex_ff98], a
	call LoadDeckCardToBuffer1
	ld c, $00
	ld b, $0d
	ld hl, wDuelCardOrAttackList
	xor a
	ld [wCardPageNumber], a
	ld de, wLoadedCard1Move1Name
	call CheckIfMoveExists
	jr c, .check_for_second_attack_slot
	ldh a, [hTempCardIndex_ff98]
	ld [hli], a
	xor a
	ld [hli], a
	inc c
	push hl
	push bc
	ld e, b
	ld hl, wLoadedCard1Move1Name
	call $5c33
	pop bc
	pop hl
	inc b
	inc b

.check_for_second_attack_slot
	ld de, wLoadedCard1Move2Name
	call CheckIfMoveExists
	jr c, .finish_loading_attacks
	ldh a, [hTempCardIndex_ff98]
	ld [hli], a
	ld a, $01
	ld [hli], a
	inc c
	push hl
	push bc
	ld e, b
	ld hl, wLoadedCard1Move2Name
	call $5c33
	pop bc
	pop hl

.finish_loading_attacks
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
	jr z, .return_no_move_found
	ld hl, CARD_DATA_MOVE1_CATEGORY - (CARD_DATA_MOVE1_NAME + 1)
	add hl, de
	ld a, [hl]
	and $ff ^ RESIDUAL
	cp POKEMON_POWER
	jr z, .return_no_move_found
	or a

.return
	pop bc
	pop de
	pop hl
	ret

.return_no_move_found
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
	ld de, wLoadedCard1Move1Energy
	ld a, c
	or a
	jr z, .got_move
	ld de, wLoadedCard1Move2Energy

.got_move
	ld hl, CARD_DATA_MOVE1_NAME - CARD_DATA_MOVE1_ENERGY
	add hl, de
	ld a, [hli]
	or [hl]
	jr z, .not_usable
	ld hl, CARD_DATA_MOVE1_CATEGORY - CARD_DATA_MOVE1_ENERGY
	add hl, de
	ld a, [hl]
	cp POKEMON_POWER
	jr z, .not_usable
	xor a
	ld [wAttachedEnergiesAccum], a
	ld hl, wAttachedEnergies
	ld c, (NUM_COLORED_TYPES) / 2

.next_energy_type_pair
	ld a, [de]
	swap a
	call _CheckIfEnoughEnergiesOfType
	jr c, .not_enough_energies
	ld a, [de]
	call _CheckIfEnoughEnergiesOfType
	jr c, .not_enough_energies
	inc de
	dec c
	jr nz, .next_energy_type_pair
	ld a, [de] ; colorless energy
	swap a
	and $f
	ld b, a
	ld a, [wAttachedEnergiesAccum]
	ld c, a
	ld a, [wTotalAttachedEnergies]
	sub c
	cp b
	jr c, .not_enough_energies
	or a
.done
	pop de
	ret

.not_usable
.not_enough_energies
	scf
	jr .done
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
	jr z, .enough_energies ; jump if no energies of this type are required
	cp [hl]
	; jump if the energies required of this type are not more than the amount attached
	jr z, .enough_energies
	jr c, .enough_energies
	inc hl
	scf
	ret

.enough_energies
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
	ldtx hl, UnableDueToParalysisText
	jr .return_with_status_condition

.asleep
	ldtx hl, UnableDueToSleepText

.return_with_status_condition
	scf
	ret

	INCROM $4933,  $4b60

Func_4b60: ; 4b60 (1:4b60)
	call $7107
	call SwapTurn
	call $7107
	call SwapTurn
	call $4e84
	call $4d97
	ldh [hffa0], a
	call SwapTurn
	call $4d97
	call SwapTurn
	ld c, a
	ldh a, [hffa0]
	ld b, a
	and c
	jr nz, .asm_4bd0
	ld a, b
	or c
	jr z, .asm_4bb2
	ld a, b
	or a
	jr nz, .asm_4b9c
.asm_4b8c
	call $4df3
	call $7107
	call $4e6e
	call $4d97
	jr c, .asm_4b8c
	jr .asm_4bd0

.asm_4b9c
	call SwapTurn
.asm_4b9f
	call $4df3
	call $7107
	call $4e6e
	call $4d97
	jr c, .asm_4b9f
	call SwapTurn
	jr .asm_4bd0

.asm_4bb2
	ldtx hl, NeitherPlayerHasBasicPkmnText
	call DrawWideTextBox_WaitForInput
	call $4e06
	call $7107
	call SwapTurn
	call $4e06
	call $7107
	call SwapTurn
	call $4dfc
	jp Func_4b60

.asm_4bd0
	ldh a, [hWhoseTurn]
	push af
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call Func_4cd5
	call SwapTurn
	call Func_4cd5
	call SwapTurn
	jp c, $4c77
	call Func_311d
	ldtx hl, PlacingThePrizesText
	call DrawWideTextBox_WaitForInput
	call Func_0f58
	ld a, [wcc08]
	ld l, a
	ld h, $0
	call Func_2ec4
	ldtx hl, PleasePlacePrizesText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call $4c7c
	call WaitForWideTextBoxInput
	pop af
	ldh [hWhoseTurn], a
	call $7133
	call SwapTurn
	call $7133
	call SwapTurn
	call EmptyScreen
	ld a, BOXMSG_COIN_TOSS
	call DrawDuelBoxMessage
	ldtx hl, CoinTossToDetermineWhoFirstText
	call DrawWideTextBox_WaitForInput
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .asm_4c52
	ld de, wc590
	call PrintPlayerName
	ld hl, $0000
	call Func_2ebb
	ldtx hl, YouPlayFirstText
	ldtx de, IfHeadPlayerPlaysFirstText
	call TossCoin
	jr c, .asm_4c4a
	call SwapTurn
	ldtx hl, YouPlaySecondText

.asm_4c4a
	call DrawWideTextBox_WaitForInput
	call Func_0f58
	or a
	ret

.asm_4c52
	ld de, wc590
	call PrintOpponentName
	ld hl, $0000
	call Func_2ebb
	ldtx hl, YouPlaySecondText
	ldtx de, IfHeadPlayerPlaysFirstText
	call TossCoin
	jr c, .asm_4c6f
	call SwapTurn
	ldtx hl, YouPlayFirstText

.asm_4c6f
	call DrawWideTextBox_WaitForInput
	call Func_0f58
	or a
	ret
; 0x4c77


	INCROM $4c77,  $4cd5

; Select Basic Pokemon From Hand
Func_4cd5: ; 4cd5 (1:4cd5)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .asm_4d15
	cp DUELIST_TYPE_LINK_OPP
	jr z, .asm_4cec
	push af
	push hl
	call Func_2bc3
	pop hl
	pop af
	ld [hl], a
	or a
	ret

.asm_4cec
	ldtx hl, TransmitingDataText
	call DrawWideTextBox_PrintText
	call Func_0f58
	ld hl, wPlayerCardLocations
	ld de, wOpponentCardLocations
	ld c, $80
	call Func_0e63
	jr c, .asm_4d12
	ld c, $80
	call Func_0e63
	jr c, .asm_4d12
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld [hl], DUELIST_TYPE_LINK_OPP
	or a
	ret

.asm_4d12
	jp Func_0f35

.asm_4d15
	call EmptyScreen
	ld a, BOXMSG_ARENA_POKEMON
	call DrawDuelBoxMessage
	ldtx hl, ChooseBasicPkmnToPlaceInArenaText
	call DrawWideTextBox_WaitForInput
	ld a, $1
	call $51e7
.asm_4d28
	xor a
	ld hl, $006e
	call $5502
	jr c, .asm_4d28
	ldh a, [hTempCardIndex_ff98]
	call LoadDeckCardToBuffer1
	ld a, $2
	call $51e7
	jr c, .asm_4d28
	ldh a, [hTempCardIndex_ff98]
	call Func_1485
	ldh a, [hTempCardIndex_ff98]
	ld hl, $0062
	call $4b31
	jr .asm_4d4c

.asm_4d4c
	call EmptyScreen
	ld a, BOXMSG_BENCH_POKEMON
	call DrawDuelBoxMessage
	ldtx hl, ChooseUpTo5BasicPkmnToPlaceOnBenchText
	call Func_2c73
	ld a, $3
	call $51e7
.asm_4d5f
	ld a, $1
	ld hl, $006f
	call $5502
	jr c, .asm_4d8e
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY
	call GetTurnDuelistVariable
	cp MAX_POKEMON_IN_PLAY
	jr nc, .asm_4d86
	ldh a, [hTempCardIndex_ff98]
	call Func_1485
	ldh a, [hTempCardIndex_ff98]
	ld hl, $0061
	call $4b31
	ld a, $5
	call $51e7
	jr .asm_4d5f

.asm_4d86
	ldtx hl, NoSpaceOnTheBenchText
	call DrawWideTextBox_WaitForInput
	jr .asm_4d5f

.asm_4d8e
	ld a, $4
	call $51e7
	jr c, .asm_4d5f
	or a
	ret
; 0x4d97


	INCROM $4d97,  $5aeb

Func_5aeb: ; 5aeb (1:5aeb)
	INCROM $5aeb, $6785

Func_6785: ; 6785 (1:6785)
	call EnableSRAM
	ld hl, $bc00
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	call DisableSRAM
	ret
; 0x6793

; loads player deck from SRAM to wPlayerDeck
LoadPlayerDeck: ; 6793 (1:6793)
	call EnableSRAM
	ld a, [$b700]
	ld l, a
	ld h, $54
	call HtimesL
	ld de, $a218
	add hl, de
	ld de, wPlayerDeck
	ld c, DECK_SIZE
.next_card_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .next_card_loop
	call DisableSRAM
	ret
; 0x67b2

	INCROM $67b2, $67be

; related to ai taking their turn in a duel
; called multiple times during one ai turn
AIMakeDecision: ; 67be (1:67be)
	ldh [hAIActionTableIndex], a
	ld hl, $cbf9
	ld a, [hl]
	ld [hl], $0
	or a
	jr nz, .skip_delay
.delay_loop
	call DoFrame
	ld a, [wVBlankCtr]
	cp $3c
	jr c, .delay_loop

.skip_delay
	ldh a, [hAIActionTableIndex]
	ld hl, $cbe1
	ld [hl], $0
	ld hl, AIActionTable
	call JumpToFunctionInTable
	ld a, [wDuelFinished]
	ld hl, $cbe1
	or [hl]
	jr nz, .turn_ended
	ld a, [wcbf9]
	or a
	ret nz
	ld [wVBlankCtr], a
	ldtx hl, DuelistIsThinkingText
	call DrawWideTextBox_PrintTextNoDelay
	or a
	ret

.turn_ended
	scf
	ret
; 0x67fb

	INCROM $67fb, $695e

AIActionTable: ; 695e (1:695e)
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

	INCROM $698c, $69a5

AIUseEnergyCard: ; 69a5 (1:69a5)
	ldh a, [hTempPlayAreaLocationOffset_ffa1]
	ldh [hTempPlayAreaLocationOffset_ff9d], a
	ld e, a
	ldh a, [hffa0]
	ldh [hTempCardIndex_ff98], a
	call $14d2
	ldh a, [hffa0]
	call LoadDeckCardToBuffer1
	call $5e75
	call $68e4
	ld a, $1
	ld [wAlreadyPlayedEnergy], a
	call $4f9d
	ret
; 0x69c5

	INCROM $69c5, $6d84

; converts clefairy doll/mysterious fossil at specified wLoadedCard to pokemon card
ConvertTrainerCardToPokemon:
	ld c, a
	ld a, [hl]
	cp TYPE_TRAINER
	ret nz
	push hl
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, c
	ld a, [hl]
	and TYPE_TRAINER
	pop hl
	ret z
	ld a, e
	cp MYSTERIOUS_FOSSIL
	jr nz, .check_for_clefairy_doll
	ld a, d
	cp $00
	jr z, .start_ram_data_overwrite
	ret
.check_for_clefairy_doll
	cp CLEFAIRY_DOLL
	ret nz
	ld a, d
	cp $00
	ret nz
.start_ram_data_overwrite
	push de
	ld [hl], COLORLESS
	ld bc, CARD_DATA_HP
	add hl, bc
	ld de, .data_to_overwrite
	ld c, CARD_DATA_UNKNOWN2 - CARD_DATA_HP
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop de
	ret

.data_to_overwrite
    db 10                 ; CARD_DATA_HP
    ds $07                ; CARD_DATA_MOVE1_NAME - (CARD_DATA_HP + 1)
    tx DiscardName        ; CARD_DATA_MOVE1_NAME
    tx DiscardDescription ; CARD_DATA_MOVE1_DESCRIPTION
    ds $03                ; CARD_DATA_MOVE1_CATEGORY - (CARD_DATA_MOVE1_DESCRIPTION + 2)
    db POKEMON_POWER      ; CARD_DATA_MOVE1_CATEGORY
    dw TrainerCardAsPokemonEffectCommands ; CARD_DATA_MOVE1_EFFECT_COMMANDS
    ds $18                ; CARD_DATA_RETREAT_COST - (CARD_DATA_MOVE1_EFFECT_COMMANDS + 2)
    db UNABLE_RETREAT     ; CARD_DATA_RETREAT_COST
    ds $0d                ; PKMN_CARD_DATA_LENGTH - (CARD_DATA_RETREAT_COST + 1)

	INCROM $6df1, $7107

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
.zero_duel_variables_loop
	ld [hl], a
	inc l
	jr nz, .zero_duel_variables_loop
	pop af
	pop hl
	ld [hl], a
	lb bc, DUELVARS_CARD_LOCATIONS, DECK_SIZE
	ld l, DUELVARS_DECK_CARDS
.init_duel_variables_loop
; zero card locations and cards in hand, and init order of cards in deck
	push hl
	ld [hl], b
	ld l, b
	ld [hl], $0
	pop hl
	inc l
	inc b
	dec c
	jr nz, .init_duel_variables_loop
	ld l, DUELVARS_ARENA_CARD
	ld c, 1 + BENCH_SIZE + 1
.init_play_area
; initialize to $ff card in arena as well as cards in bench (plus a terminator?)
	ld [hl], $ff
	inc l
	dec c
	jr nz, .init_play_area
	ret
; 0x7133

	INCROM $7133, $71ad

_TossCoin: ; 71ad (1:71ad)
	ld [wcd9c], a
	ld a, [wcac2]
	cp $6
	jr z, .asm_71c1
	xor a
	ld [wcd9f], a
	call EmptyScreen
	call Func_210f

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
	ld a, DUELVARS_DUELIST_TYPE
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
	call PlaySFX
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
	lb bc, 2, 2
	lb hl, 1, 2
	pop af
	call FillRectangle

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

	INCROM $72ff, $7354

BuildVersion: ; 7354 (1:7354)
	db "VER 12/20 09:36",TX_END

	INCROM $7364, $7571

Func_7571: ; 7571 (1:7571)
	INCROM $7571, $7576

Func_7576: ; 7576 (1:7576)
        farcallx $6, $591f
        ret
; 0x757b

	INCROM $757b, $758f

Func_758f: ; 758f (1:758f)
	INCROM $758f, $7594

Func_7594: ; 7594 (1:7594)
	farcallx $6, $661f
	ret
; 0x7599

	INCROM $7599, $8000