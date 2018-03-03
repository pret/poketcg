; continuation of Bank0 Start
; supposed to be the main loop, but the game never returns from _GameLoop anyway
GameLoop: ; 4000 (1:4000)
	di
	ld sp, $e000
	call ResetSerial
	call EnableInt_VBlank
	call EnableInt_Timer
	call EnableSRAM
	ld a, [sa006]
	ld [wTextSpeed], a
	ld a, [sa009]
	ld [wccf2], a
	call DisableSRAM
	ld a, $1
	ld [wUppercaseFlag], a
	ei
	farcall CommentedOut_1a6cc
	ldh a, [hButtonsHeld]
	cp A_BUTTON | B_BUTTON
	jr z, .ask_erase_backup_ram
	farcall _GameLoop
	jr GameLoop
.ask_erase_backup_ram
	call Func_405a
	call EmptyScreen
	ldtx hl, ResetBackUpRamText
	call YesOrNoMenuWithText
	jr c, .reset_game
; erase sram
	call EnableSRAM
	xor a
	ld [sa000], a
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
	call LoadDuelHUDTiles
	call Func_5aeb
	ld de, $387f
	call Func_2275
	ret
; 0x406e

CommentedOut_406e: ; 406e (1:406e)
	ret
; 0x406f

; try to resume a saved duel from the main menu
TryContinueDuel: ; 406f (1:406f)
	call Func_420b
	call $66e9
	ldtx hl, BackUpIsBrokenText
	jr c, FailedToContinueDuel
;	fallthrough

ContinueDuel: ; 407a (1:407a)
	ld hl, sp+$00
	ld a, l
	ld [wDuelReturnAddress], a
	ld a, h
	ld [wDuelReturnAddress + 1], a
	call ClearJoypad
	ld a, [wDuelTheme]
	call PlaySong
	xor a
	ld [wDuelFinished], a
	call DuelMainInterface
	jp StartDuel.begin_turn
; 0x4097

FailedToContinueDuel: ; 4097 (1:4097)
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
	ld [wOpponentDeckID], a
	call LoadPlayerDeck
	call SwapTurn
	call LoadOpponentDeck
	call SwapTurn
	jr .continue

	ld a, MUSIC_DUEL_THEME_1
	ld [wDuelTheme], a
	ld hl, wOpponentName
	xor a
	ld [hli], a
	ld [hl], a
	ld [wIsPracticeDuel], a

.continue
	ld hl, sp+$0
	ld a, l
	ld [wDuelReturnAddress], a
	ld a, h
	ld [wDuelReturnAddress + 1], a
	xor a
	ld [wCurrentDuelMenuItem], a
	call Func_420b
	ld a, [wcc18]
	ld [wDuelInitialPrizes], a
	call $70aa
	ld a, [wDuelTheme]
	call PlaySong
	call Func_4b60
	ret c

; the loop returns here after every turn switch
.main_duel_loop ; 40ee (1:40ee)
	xor a
	ld [wCurrentDuelMenuItem], a
	call UpdateSubstatusConditions_StartOfTurn
	call $54c8
	call HandleTurn

.begin_turn
	call Func_0f58
	ld a, [wDuelFinished]
	or a
	jr nz, .duel_finished
	call UpdateSubstatusConditions_EndOfTurn
	call $6baf
	call Func_3b31
	call Func_0f58
	ld a, [wDuelFinished]
	or a
	jr nz, .duel_finished
	ld hl, wDuelTurns
	inc [hl]
	ld a, [wDuelType]
	cp DUELTYPE_PRACTICE
	jr z, .practice_duel

.next_turn
	call SwapTurn
	jr .main_duel_loop

.practice_duel
	ld a, [wIsPracticeDuel]
	or a
	jr z, .next_turn
	ld a, [hl]
	cp 15 ; the practice duel lasts 15 turns
	jr c, .next_turn
	xor a ; DUEL_WIN
	ld [wDuelResult], a
	ret

.duel_finished
	call ZeroObjectPositionsAndToggleOAMCopy
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
	call Func_4a97
	call Func_4ad6
	pop af
	ldh [hWhoseTurn], a
	call Func_3b21
	ld a, [wDuelFinished]
	cp TURN_PLAYER_WON
	jr z, .active_duelist_won_battle
	cp TURN_PLAYER_LOST
	jr z, .active_duelist_lost_batte
	ld a, $5f
	ld c, MUSIC_DARK_DIDDLY
	ldtx hl, DuelWasADrawText
	jr .handle_duel_finished

.active_duelist_won_battle
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .opponent_won_battle
.player_won_battle
	xor a ; DUEL_WIN
	ld [wDuelResult], a
	ld a, $5d
	ld c, MUSIC_MATCH_VICTORY
	ldtx hl, WonDuelText
	jr .handle_duel_finished

.active_duelist_lost_batte
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .player_won_battle
.opponent_won_battle
	ld a, DUEL_LOSS
	ld [wDuelResult], a
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
.wait_song
	call DoFrame
	call AssertSongFinished
	or a
	jr nz, .wait_song
	ld a, [wDuelFinished]
	cp TURN_PLAYER_TIED
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
	ld a, 1
	ld [wDuelInitialPrizes], a
	call $70aa
	ld a, [wDuelType]
	cp DUELTYPE_LINK
	jr z, .link_duel
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call Func_4b60
	jp .main_duel_loop

.link_duel
	call Func_0f58
	ld h, PLAYER_TURN
	ld a, [wSerialOp]
	cp $29
	jr z, .got_turn
	ld h, OPPONENT_TURN

.got_turn
	ld a, h
	ldh [hWhoseTurn], a
	call Func_4b60
	jp nc, .main_duel_loop
	ret
; 0x420b

Func_420b: ; 420b (1:420b)
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelHUDTiles
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
	jr c, .skip_let_evolve ; jump if it's the turn holder's first turn
	call SetAllPlayAreaPokemonCanEvolve

.skip_let_evolve
	call Func_70e6
	call Func_4933
	call DrawCardFromDeck
	jr nc, .deck_not_empty
	ld a, TURN_PLAYER_LOST
	ld [wDuelFinished], a
	ret

.deck_not_empty
	ldh [hTempCardIndex_ff98], a
	call AddCardToHand
	ld a, [wDuelistType]
	cp DUELIST_TYPE_PLAYER
	jr z, Func_4262
	call SwapTurn
	call IsClairvoyanceActive
	call SwapTurn
	call c, Func_4b2c
	jr DuelMainInterface

Func_4262:
	call Func_4b2c
	call Func_100b
;	fallthrough

Func_4268:
	ld a, $06
	call $51e7
;	fallthrough

; print the main interface during a duel, including background, Pokemon, HUDs and a text box.
; the bottom text box changes depending on whether the turn belongs to the player (show the duel menu),
; an AI opponent (print "Waiting..." and a reduced menu) or a link opponent (print "<Duelist> is thinking").
DuelMainInterface: ; 426d (1:426d)
	call DrawDuelMainScene
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

PrintDuelMenu: ; 4295 (1:4295)
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
;	fallthrough

HandleDuelMenuInputAndShortcuts:
	call DoFrame
	ldh a, [hButtonsHeld]
	and B_BUTTON
	jr z, .b_not_held
	ldh a, [hButtonsPressed]
	bit D_UP_F, a
	jr nz, DuelMenuShortcut_OpponentPlayArea
	bit D_DOWN_F, a
	jr nz, DuelMenuShortcut_PlayerPlayArea
	bit D_LEFT_F, a
	jr nz, DuelMenuShortcut_PlayerDiscardPile
	bit D_RIGHT_F, a
	jr nz, DuelMenuShortcut_OpponentDiscardPile
	bit START_F, a
	jp nz, DuelMenuShortcut_OpponentActivePokemon

.b_not_held
	ldh a, [hButtonsPressed]
	and START
	jp nz, DuelMenuShortcut_PlayerActivePokemon
	ldh a, [hButtonsPressed]
	bit SELECT_F, a
	jp nz, DuelMenuShortcut_BothActivePokemon
	ld a, [wcbe7]
	or a
	jr nz, HandleDuelMenuInputAndShortcuts
	call HandleDuelMenuInput
	ld a, e
	ld [wCurrentDuelMenuItem], a
	jr nc, HandleDuelMenuInputAndShortcuts
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

; triggered by pressing B + UP in the duel menu
DuelMenuShortcut_OpponentPlayArea: ; 430b (1:430b)
	call OpenOpponentPlayAreaScreen
	jp DuelMainInterface

; triggered by pressing B + DOWN in the duel menu
DuelMenuShortcut_PlayerPlayArea: ; 4311 (1:4311)
	call OpenPlayAreaScreen
	jp DuelMainInterface

; triggered by pressing B + LEFT in the duel menu
DuelMenuShortcut_OpponentDiscardPile: ; 4317 (1:4317)
	call OpenOpponentDiscardPileScreen
	jp c, PrintDuelMenu
	jp DuelMainInterface

; triggered by pressing B + RIGHT in the duel menu
DuelMenuShortcut_PlayerDiscardPile: ; 4320 (1:4320)
	call OpenPlayerDiscardPileScreen
	jp c, PrintDuelMenu
	jp DuelMainInterface

; draw the opponent's play area screen
OpenOpponentPlayAreaScreen: ; 4329 (1:4329)
	call SwapTurn
	call OpenPlayAreaScreen
	call SwapTurn
	ret

; draw the turn holder's play area screen
OpenPlayAreaScreen: ; 4333 (1:4333)
	call HasAlivePokemonInPlayArea
	jp OpenPlayAreaScreenForViewing

; draw the opponent's discard pile screen
OpenOpponentDiscardPileScreen: ; 4339 (1:4339)
	call SwapTurn
	call OpenDiscardPileScreen
	jp SwapTurn

; draw the player's discard pile screen
OpenPlayerDiscardPileScreen: ; 4342 (1:4342)
	jp OpenDiscardPileScreen

Func_4345: ; 4345 (1:4345)
	call SwapTurn
	call Func_434e
	jp SwapTurn
; 0x434e

Func_434e: ; 434e (1:434e)
	call CreateHandCardList
	jr c, .no_cards_in_hand
	call DrawCardListScreenLayout
	ld a, START + A_BUTTON
	ld [wcbd6], a
	jp Func_55f0
.no_cards_in_hand
	ldtx hl, NoCardsInHandText
	jp DrawWideTextBox_WaitForInput
; 0x4364

; triggered by pressing B + START in the duel menu
DuelMenuShortcut_OpponentActivePokemon: ; 4364 (1:4364)
	call SwapTurn
	call OpenActivePokemonScreen
	call SwapTurn
	jp DuelMainInterface
; 0x4370

; triggered by pressing START in the duel menu
DuelMenuShortcut_PlayerActivePokemon: ; 4370 (1:4370)
	call OpenActivePokemonScreen
	jp DuelMainInterface
; 0x4376

; draw the turn holder's active Pokemon screen if it exists
OpenActivePokemonScreen: ; 4376 (1:4376)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	ret z
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	ld hl, wcbc9
	xor a
	ld [hli], a
	ld [hl], a
	call Func_576a
	ret
; 0x438e

DuelMenu_PkmnPower: ; 438e (1:438e)
	call $6431
	jp c, DuelMainInterface
	call Func_1730
	jp DuelMainInterface

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
	and CNF_SLP_PRZ
	cp CONFUSED
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
	call OpenPlayAreaScreenForSelection
	jr c, Func_441c
	ld [wBenchSelectedPokemon], a
	ld a, [wBenchSelectedPokemon]
	ldh [hTempPlayAreaLocationOffset_ffa1], a
	ld a, $04
	call SetDuelAIAction
	call $657a
	jr nc, Func_441c
	call DrawDuelMainScene

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
	call OpenPlayAreaScreenForSelection
	ld [wBenchSelectedPokemon], a
	ldh [hTempPlayAreaLocationOffset_ffa1], a
	push af
	call $6564
	pop af
	jp c, DuelMainInterface
	ld a, $04
	call SetDuelAIAction
	call $657a

Func_441c: ; 441c (1:441c)
	jp DuelMainInterface

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
	call CreateHandCardList
	call DrawCardListScreenLayout
	ldtx hl, PleaseSelectHandText
	call SetCardListInfoBoxText
	ld a, $1
	ld [wcbde], a
.asm_4447
	call Func_55f0
	push af
	ld a, [wcbdf]
	or a
	call nz, SortHandCardsByID
	pop af
	jp c, DuelMainInterface
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	ld c, a
	bit TYPE_TRAINER_F, c
	jr nz, .asm_446f
	bit TYPE_ENERGY_F, c
	jr nz, UseEnergyCard
	call $44db
	jr c, UseEnergyCard.asm_44d2
	jp DuelMainInterface
.asm_446f
	call UseTrainerCard
	jr c, UseEnergyCard.asm_44d2
	jp DuelMainInterface

; c contains the type of energy card being played
UseEnergyCard: ; 4477 (1:4477)
	ld a, c
	cp TYPE_ENERGY_WATER
	jr nz, .not_water_energy
	call IsRainDanceActive
	jr c, .rain_dance_active

.not_water_energy
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .already_played_energy
	call HasAlivePokemonInPlayArea
	call OpenPlayAreaScreenForSelection ; choose card to play energy card on
	jp c, DuelMainInterface ; exit if no card was chosen
.play_energy_set_played
	ld a, $1
	ld [wAlreadyPlayedEnergy], a
.play_energy
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	ldh [hTempPlayAreaLocationOffset_ffa1], a
	ld e, a
	ldh a, [hTempCardIndex_ff98]
	ldh [hffa0], a
	call PutHandCardInPlayArea
	call $61b8
	ld a, $3
	call SetDuelAIAction
	call $68e4
	jp DuelMainInterface

.rain_dance_active
	call HasAlivePokemonInPlayArea
	call OpenPlayAreaScreenForSelection ; choose card to play energy card on
	jp c, DuelMainInterface ; exit if no card was chosen
	call CheckRainDanceScenario
	jr c, .play_energy
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr z, .play_energy_set_played
	ldtx hl, MayOnlyAttachOneEnergyCardText
	call DrawWideTextBox_WaitForInput
	jp Func_4436

.already_played_energy
	ldtx hl, MayOnlyAttachOneEnergyCardText
	call DrawWideTextBox_WaitForInput

.asm_44d2
	call CreateHandCardList
	call DrawCardListScreenLayout.draw
	jp Func_4436.asm_4447
; 0x44db

	INCROM $44db,  $4585

DuelMenu_Check: ; 4585 (1:4585)
	call Func_3b31
	call Func_3096
	jp DuelMainInterface

; triggered by pressing SELECT in the duel menu
DuelMenuShortcut_BothActivePokemon:: ; 458e (1:458e)
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
	call LoadPokemonMovesToDuelTempList
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
	call LoadCardDataToBuffer1_FromDeckIndex

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
	ld hl, wDuelTempList
	add hl, de
	ld d, [hl] ; card index within the deck (0 to 59)
	inc hl
	ld e, [hl] ; attack index (0 or 1)
	call CopyMoveDataAndDamage_FromDeckIndex
	call HandleAmnesiaSubstatus
	jr c, .cannot_use_due_to_amnesia
	ld a, $07
	call $51e7
	jp c, Func_4268
	call Func_1730
	jp c, DuelMainInterface
	ret

.cannot_use_due_to_amnesia
	call DrawWideTextBox_WaitForInput
	jr .try_open_attack_menu

.display_selected_move_info
	call Func_478b
	call DrawDuelMainScene
	jp .try_open_attack_menu

Func_478b: ; 478b (1:478b)
	ld a, CARDPAGE_POKEMON_OVERVIEW
	ld [wCardPageNumber], a
	xor a
	ld [wcbc9], a
	call EmptyScreen
	call Func_3b31
	ld de, v0Tiles1 + $20 tiles
	call LoadLoaded1CardGfx
	call SetOBP1OrSGB3ToCardPalette
	call SetBGP6OrSGB3ToCardPalette
	call FlushAllPalettesOrSendPal23Packet
	lb de, $38, $30 ; X Position and Y Position of top-left corner
	call PlaceCardImageOAM
	lb de, 6, 4
	call ApplyBGP6OrSGB3ToCardImage
	ldh a, [hCurrentMenuItem]
	ld [wSelectedDuelSubMenuItem], a
	add a
	ld e, a
	ld d, $00
	ld hl, wDuelTempList + 1
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
	dw $0000 ; function pointer if non-0

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
	ld hl, wLoadedCard1Move1Description + 2
	ld a, [hli]
	or [hl]
	ret z
	call $5d27
	jr Func_481b

Func_480d: ; $480d (1:480d)
	call $5d2f
	jr Func_481b

Func_4812: ; $4812 (1:4812)
	ld hl, wLoadedCard1Move2Description + 2
	ld a, [hli]
	or [hl]
	ret z
	call $5d37

Func_481b: ; $481b (1:481b)
	ld hl, wcc04
	ld a, $01
	xor [hl]
	ld [hl], a
	ret

; copies the following to the wDuelTempList buffer:
;   if pokemon's second moveslot is empty: <card_no>, 0
;   else: <card_no>, 0, <card_no>, 1
LoadPokemonMovesToDuelTempList: ; 4823 (1:4823)
	call DrawWideTextBox
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardIndex_ff98], a
	call LoadCardDataToBuffer1_FromDeckIndex
	ld c, $00
	ld b, $0d
	ld hl, wDuelTempList
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

; given de = wLoadedCard*Move*Name, return carry if the move is a
; Pkmn Power or the moveslot is empty.
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
	call GetPlayAreaCardAttachedEnergies
	call HandleEnergyBurn
	ldh a, [hCurrentMenuItem]
	add a
	ld e, a
	ld d, $0
	ld hl, wDuelTempList
	add hl, de
	ld d, [hl] ; card index within the deck (0 to 59)
	inc hl
	ld e, [hl] ; attack index (0 or 1)
	call _CheckIfEnoughEnergies
	pop bc
	pop hl
	ret
; 0x48ac

; check if a pokemon card has enough energy attached to it in order to use a move
; input:
;   d = card index within the deck (0 to 59)
;   e = attack index (0 or 1)
;   wAttachedEnergies and wTotalAttachedEnergies
; returns: carry if not enough energy, nc if enough energy.
_CheckIfEnoughEnergies: ; 48ac (1:48ac)
	push de
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
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
	jr z, .not_usable_or_not_enough_energies
	ld hl, CARD_DATA_MOVE1_CATEGORY - CARD_DATA_MOVE1_ENERGY
	add hl, de
	ld a, [hl]
	cp POKEMON_POWER
	jr z, .not_usable_or_not_enough_energies
	xor a
	ld [wAttachedEnergiesAccum], a
	ld hl, wAttachedEnergies
	ld c, (NUM_COLORED_TYPES) / 2

.next_energy_type_pair
	ld a, [de]
	swap a
	call CheckIfEnoughEnergiesOfType
	jr c, .not_usable_or_not_enough_energies
	ld a, [de]
	call CheckIfEnoughEnergiesOfType
	jr c, .not_usable_or_not_enough_energies
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
	jr c, .not_usable_or_not_enough_energies
	or a
.done
	pop de
	ret

.not_usable_or_not_enough_energies
	scf
	jr .done
; 0x4900

; given the amount of energies of a specific type required for an attack in the
; lower nybble of register a, test if the pokemon card has enough energies of that type
; to use the move. Return carry if not enough energy, nc if enough energy.
CheckIfEnoughEnergiesOfType: ; 4900 (1:4900)
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

; return carry and the corresponding text in hl if the turn holder's
; arena Pokemon card is paralyzed or asleep.
CheckIfActiveCardParalyzedOrAsleep: ; 4918 (1:4918)
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
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

; this handles drawing a card at the beginning of the turn among other things
Func_4933: ; 4933 (1:4933)
	ld a, $01
	push hl
	push de
	push bc
	ld [wcbe8], a
	xor a
	ld [wcbe9], a
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE
	sub [hl]
	ld hl, wcbe8
	cp [hl]
	jr nc, .has_cards_left
	ld [hl], a
.has_cards_left
	ld a, [wcac2]
	cp $07
	jr z, .asm_495f
	cp $09
	jr z, .asm_495f
	call EmptyScreen
	call Func_4a97
.asm_495f
	ld a, $07
	ld [wcac2], a
	call Func_49ca
	ld a, [wcbe8]
	or a
	jr nz, .can_draw
	ldtx hl, NoCardsInDeckCannotDraw
	call DrawWideTextBox_WaitForInput
	jr .done
.can_draw
	ld l, a
	ld h, 0
	call LoadTxRam3
	ldtx hl, DrawCardsFromTheDeck
	call DrawWideTextBox_PrintText
	call EnableLCD
.asm_4984
	call Func_49a8
	ld hl, wcbe9
	inc [hl]
	call Func_49ed
	ld a, [wcbe9]
	ld hl, wcbe8
	cp [hl]
	jr c, .asm_4984
	ld c, 30
.asm_4999
	call DoFrame
	call Func_67b2
	jr c, .done
	dec c
	jr nz, .asm_4999
.done
	pop bc
	pop de
	pop hl
	ret
; 0x49a8

Func_49a8: ; 49a8 (1:49a8)
	call Func_3b21
	ld e, $56
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .asm_49b5
	ld e, $57
.asm_49b5
	ld a, e
	call Func_3b6a
.asm_49b9
	call DoFrame
	call Func_67b2
	jr c, .asm_49c6
	call Func_3b52
	jr c, .asm_49b9
.asm_49c6
	call Func_3b31
	ret
; 0x49ca

Func_49ca: ; 49ca (1:49ca)
	call LoadDuelDrawCardsScreenTiles
	ld hl, $4a35
	call Func_0695
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	call BankswitchVRAM1
	ld hl, $4a6e
	call Func_0695
	call BankswitchVRAM0
.not_cgb
	call Func_49ed.player_turn
	call Func_49ed.opponent_turn
	ret
; 0x49ed

Func_49ed: ; 49ed (1:49ed)
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .opponent_turn
.player_turn
	ld a, [wPlayerNumberOfCardsInHand]
	ld hl, wcbe9
	add [hl]
	ld d, a
	ld a, DECK_SIZE
	ld hl, wPlayerNumberOfCardsNotInDeck
	sub [hl]
	ld hl, wcbe9
	sub [hl]
	ld e, a
	ld a, d
	lb bc, 16, 10
	call $65b7
	ld a, e
	lb bc, 10, 10
	jp $65b7
.opponent_turn
	ld a, [wOpponentNumberOfCardsInHand]
	ld hl, wcbe9
	add [hl]
	ld d, a
	ld a, DECK_SIZE
	ld hl, wOpponentNumberOfCardsNotInDeck
	sub [hl]
	ld hl, wcbe9
	sub [hl]
	ld e, a
	ld a, d
	lb bc, 5, 3
	call $65b7
	ld a, e
	lb bc, 11, 3
	jp $65b7
; 0x4a35

	INCROM $4a35, $4a97

Func_4a97: ; 4a97 (1:4a97)
	call LoadDuelHUDTiles
	ld de, wDefaultText
	push de
	call CopyPlayerName
	ld de, $b
	call Func_22ae
	pop hl
	call Func_21c5
	ld bc, $5
	call Func_3e10
	ld de, wDefaultText
	push de
	call CopyOpponentName
	pop hl
	call Func_23c1
	push hl
	add $14
	ld d, a
	ld e, $00
	call Func_22ae
	pop hl
	call Func_21c5
	ld a, [wOpponentPortrait]
	ld bc, $d01
	call Func_3e2a
	call $516f
	ret
; 0x4ad6

Func_4ad6: ; 4ad6 (1:4ad6)
	lb de, 8, 8
	call Func_4ae9
	call SwapTurn
	lb de, 1, 1
	call Func_4ae9
	call SwapTurn
	ret
; 0x4ae9

Func_4ae9: ; 4ae9 (1:4ae9)
	call $5f4a
	ld hl, $7b
	call Func_2c1b
	call $5f50
	ld c, e
	ld a, d
	add $07
	ld b, a
	inc a
	inc a
	ld d, a
	call CountPrizes
	call .asm_4b22
	inc e
	inc c
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld hl, $7d
	or a
	jr nz, .pkmn_in_play_area
	ld hl, $7c
.pkmn_in_play_area
	dec d
	call Func_2c1b
	inc e
	inc d
	inc c
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE
	sub [hl]
.asm_4b22
	call $65b7
	ld hl, $7e
	call Func_2c1b
	ret
; 0x4b2c

Func_4b2c: ; 4b2c (1:4b2c)
	ldtx hl, YouDrewText
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	call $5e5f
	ret
; 0x4b38

Func_4b38: ; 4b38 (1:4b38)
	ld a, [wDuelTempList]
	cp $ff
	ret z
	call DrawCardListScreenLayout
	call CountCardsInDuelTempList
	ld hl, $5710
	ld de, $0
	call Func_2799
	ldtx hl, TheCardYouReceivedText
	lb de, 1, 1
	call Func_22ae
	call PrintTextNoDelay
	ldtx hl, YouReceivedTheseCardsText
	call DrawWideTextBox_WaitForInput
	ret
; 0x4b60

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
	ld a, [wDuelInitialPrizes]
	ld l, a
	ld h, 0
	call LoadTxRam3
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
	ld de, wDefaultText
	call CopyPlayerName
	ld hl, $0000
	call LoadTxRam2
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
	ld de, wDefaultText
	call CopyOpponentName
	ld hl, $0000
	call LoadTxRam2
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
	jp DuelTransmissionError

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
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, $2
	call $51e7
	jr c, .asm_4d28
	ldh a, [hTempCardIndex_ff98]
	call PutHandPokemonCardInPlayArea
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
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .asm_4d86
	ldh a, [hTempCardIndex_ff98]
	call PutHandPokemonCardInPlayArea
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

	INCROM $4d97,  $4f9d

; draw the main scene during a duel, except the contents of the bottom text box,
; which depend on the type of duelist holding the turn.
; includes the background, both arena Pokemon, and both HUDs.
DrawDuelMainScene: ; 4f9d (1:4f9d)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .draw
	ldh a, [hWhoseTurn]
	push af
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call .draw
	pop af
	ldh [hWhoseTurn], a
	ret
.draw
; first, load the graphics and draw the background scene
	ld a, [wcac2]
	cp $01
	ret z
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelHUDTiles
	ld a, $01
	ld [wcac2], a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld de, v0Tiles1 + $50 tiles
	call LoadPlayAreaCardGfx
	call SetBGP7OrSGB2ToCardPalette
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld de, v0Tiles1 + $20 tiles
	call LoadPlayAreaCardGfx
	call SetBGP6OrSGB3ToCardPalette
	call FlushAllPalettesOrSendPal23Packet
	call SwapTurn
; next, draw the Pokemon in the arena
;.place_player_arena_pkmn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	jr z, .place_opponent_arena_pkmn
	ld a, $d0 ; v0Tiles1 + $50 tiles
	lb hl, 6, 1
	lb de, 0, 5
	lb bc, 8, 6
	call FillRectangle
	call ApplyBGP7OrSGB2ToCardImage
.place_opponent_arena_pkmn
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	jr z, .place_other_elements
	ld a, $a0 ; v0Tiles1 + $20 tiles
	lb hl, 6, 1
	lb de, 12, 1
	lb bc, 8, 6
	call FillRectangle
	call ApplyBGP6OrSGB3ToCardImage
.place_other_elements
	call SwapTurn
	ld hl, $5188
	call Func_0695
	call $516f ; draw the vertical separator
	call $503a ; draw the HUDs
	call DrawWideTextBox
	call EnableLCD
	ret
; 0x503a

	INCROM $503a,  $5550

; draw the turn holder's discard pile screen
OpenDiscardPileScreen: ; 5550 (1:5550)
	call CreateDiscardPileCardList
	jr c, .discard_pile_empty
	call DrawCardListScreenLayout
	call SetDiscardPileScreenTexts
	ld a, START + A_BUTTON
	ld [wcbd6], a
	call Func_55f0
	or a
	ret
.discard_pile_empty
	ldtx hl, TheDiscardPileHasNoCardsText
	call DrawWideTextBox_WaitForInput
	scf
	ret
; 0x556d

; set wCardListHeaderText and SetCardListInfoBoxText to the text
; that correspond to the Discard Pile screen
SetDiscardPileScreenTexts: ; 556d (1:556d)
	ldtx de, YourDiscardPileText
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .got_header_text
	ldtx de, OpponentsDiscardPileText
.got_header_text
	ldtx hl, ChooseTheCardYouWishToExamineText
	call SetCardListHeaderText
	ret
; 0x5580

SetCardListHeaderText: ; 5580 (1:5580)
	ld a, e
	ld [wCardListHeaderText], a
	ld a, d
	ld [wCardListHeaderText + 1], a
;	fallthrough

SetCardListInfoBoxText: ; 5588 (1:5588)
	ld a, l
	ld [wCardListInfoBoxText], a
	ld a, h
	ld [wCardListInfoBoxText + 1], a
	ret
; 0x5591

Func_5591: ; 5591 (1:5591)
	call DrawCardListScreenLayout
	ld a, $02
	ld [wcbde], a
	ret
; 0x559a

; draw the layout of the screen that displays the player's Hand card list or a
; Discard Pile card list, including a bottom-right image of the current card.
; since this loads the text for the Hand card list screen, SetDiscardPileScreenTexts
; is called after this if the screen corresponds to a Discard Pile list.
DrawCardListScreenLayout: ; 559a (1:559a)
	xor a
	ld hl, wSelectedDuelSubMenuItem
	ld [hli], a
	ld [hl], a
	ld [wcbdf], a
	ld hl, wcbd8
	ld [hli], a
	ld [hl], a
	ld [wcbde], a
	ld a, START
	ld [wcbd6], a
	ld hl, wCardListInfoBoxText
	ld [hl], LOW(PleaseSelectHandText_)
	inc hl
	ld [hl], HIGH(PleaseSelectHandText_)
	inc hl ; wCardListHeaderText
	ld [hl], LOW(DuelistsHandText_)
	inc hl
	ld [hl], HIGH(DuelistsHandText_)
.draw
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelHUDTiles
	call LoadDuelCardSymbolTiles
	; draw the surrounding box
	lb de, 0, 0
	lb bc, 20, 13
	call DrawRegularTextBox
	; draw the image of the selected card
	ld a, $a0
	lb hl, 6, 1
	lb de, 12, 12
	lb bc, 8, 6
	call FillRectangle
	call ApplyBGP6OrSGB3ToCardImage
	call Func_5744
	ld a, [wDuelTempList]
	cp $ff
	scf
	ret z
	or a
	ret
; 0x55f0

Func_55f0: ; 55f0 (1:55f0)
	call DrawNarrowTextBox
	call $56a0
.asm_55f6
	call CountCardsInDuelTempList
	ld hl, wSelectedDuelSubMenuItem
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $5710
	call Func_2799
	call Func_58aa
	call EnableLCD
.asm_560b
	call DoFrame
	call $5690
	call Func_2626
	jr nc, .asm_560b
	ld hl, wSelectedDuelSubMenuItem
	ld [hl], e
	inc hl
	ld [hl], d
	ldh a, [hButtonsPressed]
	ld b, a
	bit SELECT_F, b
	jr nz, .asm_563b
	bit B_BUTTON_F, b
	jr nz, .asm_568c
	ld a, [wcbd6]
	and b
	jr nz, .asm_5654
	ldh a, [hCurrentMenuItem]
	call GetCardInDuelTempList_OnlyDeckIndex
	call $56c2
	jr c, Func_55f0
	ldh a, [hTempCardIndex_ff98]
	or a
	ret
.asm_563b
	ld a, [wcbdf]
	or a
	jr nz, .asm_560b
	call SortCardsInDuelTempListByID
	xor a
	ld hl, wSelectedDuelSubMenuItem
	ld [hli], a
	ld [hl], a
	ld a, $01
	ld [wcbdf], a
	call EraseCursor
	jr .asm_55f6
.asm_5654
	ldh a, [hCurrentMenuItem]
	call GetCardInDuelTempList
	call LoadCardDataToBuffer1_FromDeckIndex
	call $5762
	ldh a, [hButtonsPressed2]
	bit D_UP_F, a
	jr nz, .asm_566f
	bit D_DOWN_F, a
	jr nz, .asm_5677
	call DrawCardListScreenLayout.draw
	jp Func_55f0
.asm_566f
	ldh a, [hCurrentMenuItem]
	or a
	jr z, .asm_5654
	dec a
	jr .asm_5681
.asm_5677
	call CountCardsInDuelTempList
	ld b, a
	ldh a, [hCurrentMenuItem]
	inc a
	cp b
	jr nc, .asm_5654
.asm_5681
	ldh [hCurrentMenuItem], a
	ld hl, wSelectedDuelSubMenuItem
	ld [hl], $00
	inc hl
	ld [hl], a
	jr .asm_5654
.asm_568c
	ldh a, [hCurrentMenuItem]
	scf
	ret
; 0x5690

	INCROM $5690,  $5744

Func_5744: ; 5744 (1:5744)
	ld hl, wcbd8
	jp CallIndirect
; 0x574a

	INCROM $574a,  $576a

Func_576a: ; 576a (1:576a)
	ld a, B_BUTTON
	ld [wcbd7], a
	ld a, $01
	jr Func_5779

Func_5773: ; 5773 (1:5773)
	ld a, B_BUTTON
	ld [wcbd7], a
	xor a
;	fallthrough

Func_5779: ; 5779 (1:5779)
	ld [wcbd1], a
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call Func_3b31
	call LoadDuelCardSymbolTiles
	ld de, v0Tiles1 + $20 tiles
	call LoadLoaded1CardGfx
	call SetOBP1OrSGB3ToCardPalette
	call SetBGP6OrSGB3ToCardPalette
	call FlushAllPalettesOrSendPal23Packet
	lb de, $38, $30 ; X Position and Y Position of top-left corner
	call PlaceCardImageOAM
	lb de, 6, 4
	call ApplyBGP6OrSGB3ToCardImage
	xor a
	ld [wCardPageNumber], a
.asm_57a7
	call Func_5898
	jr c, .asm_57cc
	call EnableLCD
.asm_57af
	call DoFrame
	ldh a, [hButtonsPressed2]
	ld b, a
	ld a, [wcbd7]
	and b
	jr nz, .asm_57cc
	ldh a, [hButtonsPressed]
	and START + A_BUTTON
	jr nz, .asm_57a7
	ldh a, [hButtonsPressed]
	and D_RIGHT + D_LEFT
	jr z, .asm_57af
	call Func_57cd
	jr .asm_57af
.asm_57cc
	ret
; 0x57cd

Func_57cd: ; 57cd (1:57cd)
	bit D_LEFT_F, a
	jr nz, .left
;.right
	call Func_5898
	call c, Func_589c
	ret
.left
	call Func_5892
	call c, Func_589c
	ret
; 0x57df

	INCROM $57df,  $5892

Func_5892: ; 5892 (1:5892)
	call Func_5911
	jr nc, Func_589c
	ret

Func_5898: ; 5898 (1:5898)
	call Func_58e2
	ret c
;	fallthrough

Func_589c: ; 589c (1:589c)
	ld a, [wCardPageNumber]
	ld hl, CardPagePointerTable
	call JumpToFunctionInTable
	call EnableLCD
	or a
	ret
; 0x58aa

Func_58aa: ; 58aa (1:58aa)
	ldh a, [hCurrentMenuItem]
	call GetCardInDuelTempList
	call LoadCardDataToBuffer1_FromCardID
	ld de, v0Tiles1 + $20 tiles
	call LoadLoaded1CardGfx
	ld de, $c0c ; useless
	call SetBGP6OrSGB3ToCardPalette
	call FlushAllPalettesOrSendPal23Packet
	ret
; 0x58c2

CardPagePointerTable: ; 58c2 (1:58c2)
	dw DrawDuelMainScene
	dw $5b7d ; CARDPAGE_POKEMON_OVERVIEW
	dw $5d1f ; CARDPAGE_POKEMON_MOVE1_1
	dw $5d27 ; CARDPAGE_POKEMON_MOVE1_2
	dw $5d2f ; CARDPAGE_POKEMON_MOVE2_1
	dw $5d37 ; CARDPAGE_POKEMON_MOVE2_2
	dw $5d54 ; CARDPAGE_POKEMON_DESCRIPTION
	dw DrawDuelMainScene
	dw DrawDuelMainScene
	dw $5e28 ; CARDPAGE_ENERGY
	dw $5e28 ; CARDPAGE_ENERGY + 1
	dw DrawDuelMainScene
	dw DrawDuelMainScene
	dw $5e1c ; CARDPAGE_TRAINER_1
	dw $5e22 ; CARDPAGE_TRAINER_2
	dw DrawDuelMainScene
; 0x58e2

Func_58e2: ; 58e2 (1:58e2)
	ld a, [wCardPageNumber]
	or a
	jr nz, .asm_58ff
	ld a, [wLoadedCard1Type]
	ld b, a
	ld a, CARDPAGE_ENERGY
	bit TYPE_ENERGY_F, b
	jr nz, .set_card_page_nc
	ld a, CARDPAGE_TRAINER_1
	bit TYPE_TRAINER_F, b
	jr nz, .set_card_page_nc
	ld a, CARDPAGE_POKEMON_OVERVIEW
.set_card_page_nc
	ld [wCardPageNumber], a
	or a
	ret
.asm_58ff
	ld hl, wCardPageNumber
	inc [hl]
	ld a, [hl]
	call Func_5930
	jr c, .set_card_page_c
	or a
	ret nz
	jr .asm_58ff
.set_card_page_c
	ld [wCardPageNumber], a
	ret
; 0x5911

Func_5911: ; 5911 (1:5911)
	ld hl, wCardPageNumber
	dec [hl]
	ld a, [hl]
	call Func_5930
	jr c, .asm_591f
	or a
	ret nz
	jr Func_5911
.asm_591f
	ld [wCardPageNumber], a
.asm_5922
	call Func_5930
	or a
	jr nz, .asm_592e
	ld hl, wCardPageNumber
	dec [hl]
	jr .asm_5922
.asm_592e
	scf
	ret
; 0x5930

Func_5930: ; 5930 (1:5930)
	ld hl, CardPagePointerTable2
	jp JumpToFunctionInTable
; 0x5936

CardPagePointerTable2: ; 5936 (1:5936)
	dw $5956
	dw $595a ; CARDPAGE_POKEMON_OVERVIEW
	dw $595e ; CARDPAGE_POKEMON_MOVE1_1
	dw $5963 ; CARDPAGE_POKEMON_MOVE1_2
	dw $5968 ; CARDPAGE_POKEMON_MOVE2_1
	dw $596d ; CARDPAGE_POKEMON_MOVE2_2
	dw $595a ; CARDPAGE_POKEMON_DESCRIPTION
	dw $5973
	dw $5977
	dw $597b ; CARDPAGE_ENERGY
	dw $597f ; CARDPAGE_ENERGY + 1
	dw $5984
	dw $5988
	dw $597b ; CARDPAGE_TRAINER_1
	dw $597f ; CARDPAGE_TRAINER_2
	dw $598c
; 0x5956

	INCROM $5956,  $5990

ZeroObjectPositionsAndToggleOAMCopy: ; 5990 (1:5990)
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret
; 0x5999

; place OAM for a 8x6 image, using object size 8x16 and obj palette 1.
; d, e: X Position and Y Position of the top-left corner.
; starting tile number is $a0 (v0Tiles1 + $20 tiles).
; used to draw the image of a card in the check card screens.
PlaceCardImageOAM: ; 5999 (1:5999)
	call Set_OBJ_8x16
	ld l, $a0
	ld c, 8 ; number of rows
.next_column
	ld b, 3 ; number of columns
	push de
.next_row
	push bc
	ld c, l ; tile number
	ld b, 1 ; attributes (palette)
	call SetOneObjectAttributes
	pop bc
	inc l
	inc l ; next 8x16 tile
	ld a, 16
	add e ; Y Position += 16 (next 8x16 row)
	ld e, a
	dec b
	jr nz, .next_row
	pop de
	ld a, 8
	add d ; X Position += 8 (next 8x16 column)
	ld d, a
	dec c
	jr nz, .next_column
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret
; 0x59c2

; given the deck index of a card in the play area (i.e. -1 indicates empty)
; load the graphics (tiles and palette) of the card to de
LoadPlayAreaCardGfx: ; 59c2 (1:59c2)
	cp -1
	ret z
	push de
	call LoadCardDataToBuffer1_FromDeckIndex
	pop de
;	fallthrough

; load the graphics (tiles and palette) of the card loaded in wLoadedCard1 to de
LoadLoaded1CardGfx: ; 59ca (1:59ca)
	ld hl, wLoadedCard1Gfx
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lb bc, $30, TILE_SIZE
	call LoadCardGfx
	ret
; 0x59d7

SetBGP7OrSGB2ToCardPalette: ; 59d7 (1:59d7)
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, .sgb
	ld a, $07 ; CGB BG Palette 7
	call CopyCGBCardPalette
	ret
.sgb
	ld hl, wCardPalette
	ld de, wTempSGBPacket + 1 ; PAL Packet color #0 (PAL23's SGB2)
	ld b, CGB_PAL_SIZE
.copy_pal_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_pal_loop
	ret
; 0x59f5

SetBGP6OrSGB3ToCardPalette: ; 59f5 (1:59f5)
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, SetSGB3ToCardPalette
	ld a, $06 ; CGB BG Palette 6
	call CopyCGBCardPalette
	ret

SetSGB3ToCardPalette: ; 5a04 (1:5a04)
	ld hl, wCardPalette + 2
	ld de, wTempSGBPacket + 9 ; Pal Packet color #4 (PAL23's SGB3)
	ld b, 6
	jr SetBGP7OrSGB2ToCardPalette.copy_pal_loop
; 0x5a0e

SetOBP1OrSGB3ToCardPalette: ; 5a0e (1:5a0e)
	ld a, $e4
	ld [wOBP0], a
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, SetSGB3ToCardPalette
	ld a, $09 ; CGB Object Palette 1
;	fallthrough

CopyCGBCardPalette: ; 5a1e (1:5a1e)
	add a
	add a
	add a ; a *= CGB_PAL_SIZE
	ld e, a
	ld d, $00
	ld hl, wBackgroundPalettesCGB ; wObjectPalettesCGB - 8 * CGB_PAL_SIZE
	add hl, de
	ld de, wCardPalette
	ld b, CGB_PAL_SIZE
.copy_pal_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .copy_pal_loop
	ret
; 0x5a34

FlushAllPalettesOrSendPal23Packet: ; 5a34 (1:5a34)
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, .sgb
	call SetFlushAllPalettes
	ret
.sgb
; sgb PAL23, 1 ; sgb_command, length
; rgb 28, 28, 24
; colors 1-7 carried over
	ld a, PAL23 << 3 + 1
	ld hl, wTempSGBPacket
	ld [hli], a
	ld a, $9c
	ld [hli], a
	ld a, $63
	ld [hld], a
	dec hl
	xor a
	ld [wTempSGBPacket + $f], a
	call SendSGB
	ret
; 0x5a56

ApplyBGP6OrSGB3ToCardImage: ; 5a56 (1:5a56)
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, .sgb
	ld a, $06 ; CGB BG Palette 6
	call ApplyCardCGBAttributes
	ret
.sgb
	ld a, 3 << 0 + 3 << 2 ; Color Palette Designation
;	fallthrough

SendCardAttrBlkPacket: ; 5a67 (1:5a67)
	call CreateCardAttrBlkPacket
	call SendSGB
	ret
; 0x5a6e

ApplyBGP7OrSGB2ToCardImage: ; 5a6e (1:5a6e)
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, .sgb
	ld a, $07 ; CGB BG Palette 7
	call ApplyCardCGBAttributes
	ret
.sgb
	ld a, 2 << 0 + 2 << 2 ; Color Palette Designation
	jr SendCardAttrBlkPacket
; 0x5a81

Func_5a81: ; 5a81 (1:5a81)
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, .sgb
	lb de, 0, 5
	call ApplyBGP7OrSGB2ToCardImage
	lb de, 12, 1
	call ApplyBGP6OrSGB3ToCardImage
	ret
.sgb
	ld a, 2 << 0 + 2 << 2 ; Data Set #1: Color Palette Designation
	lb de, 0, 5 ; Data Set #1: X, Y
	call CreateCardAttrBlkPacket
	push hl
	ld a, 2
	ld [wTempSGBPacket + 1], a ; set number of data sets to 2
	ld hl, wTempSGBPacket + 8
	ld a, 3 << 0 + 3 << 2 ; Data Set #2: Color Palette Designation
	lb de, 12, 1 ; Data Set #2: X, Y
	call CreateCardAttrBlkPacket_DataSet
	pop hl
	call SendSGB
	ret
; 0x5ab5

CreateCardAttrBlkPacket: ; 5ab5 (1:5ab5)
; sgb ATTR_BLK, 1 ; sgb_command, length
; db 1 ; number of data sets
	ld hl, wTempSGBPacket
	push hl
	ld [hl], ATTR_BLK << 3 + 1
	inc hl
	ld [hl], 1
	inc hl
	call CreateCardAttrBlkPacket_DataSet
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	ret
; 0x5ac9

CreateCardAttrBlkPacket_DataSet: ; 5ac9 (1:5ac9)
; Control Code, Color Palette Designation, X1, Y1, X2, Y2
; db ATTR_BLK_CTRL_INSIDE + ATTR_BLK_CTRL_LINE, a, d, e, d+7, e+5 ; data set 1
	ld [hl], ATTR_BLK_CTRL_INSIDE + ATTR_BLK_CTRL_LINE
	inc hl
	ld [hl], a
	inc hl
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld a, 7
	add d
	ld [hli], a
	ld a, 5
	add e
	ld [hli], a
	ret
; 0x5adb

; given the 8x6 card image with coordinates at de, fill its BGMap attributes with a
ApplyCardCGBAttributes: ; 5adb (1:5adb)
	call BankswitchVRAM1
	lb hl, 0, 0
	lb bc, 8, 6
	call FillRectangle
	call BankswitchVRAM0
	ret
; 0x5aeb

Func_5aeb: ; 5aeb (1:5aeb)
	INCROM $5aeb, $5fdd

; return carry if the turn holder has any Pokemon with non-zero HP in the play area.
; return how many Pokemon with non-zero HP in b.
HasAlivePokemonInPlayArea: ; 5fdd (1:5fdd)
	xor a
	ld [wcbd2], a
	ld b, a
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	sub b
	ld c, a
	ld a, DUELVARS_ARENA_CARD_HP
	add b
	call GetTurnDuelistVariable
	ld b, 0
	inc c
	xor a
	ld [wcbd3], a
	ld [wcbd4], a
	jr .next_pkmn
.loop
	ld a, [hli]
	or a
	jr z, .next_pkmn ; jump if this play area Pokemon has 0 HP
	inc b
.next_pkmn
	dec c
	jr nz, .loop
	ld a, b
	or a
	ret nz
	scf
	ret
; 0x6008

OpenPlayAreaScreenForViewing: ; 6008 (1:6008)
	ld a, START + A_BUTTON
	jr _OpenPlayAreaScreen

OpenPlayAreaScreenForSelection: ; 600c (1:600c)
	ld a, START
;	fallthrough

_OpenPlayAreaScreen: ; 600e (1:600e)
	ld [wcbd6], a
	ldh a, [hTempCardIndex_ff98]
	push af
	ld a, [wcbd3]
	or a
	jr nz, .asm_6034
	xor a
	ld [wSelectedDuelSubMenuItem], a
	inc a
	ld [wcbd3], a
.asm_6022
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	call LoadDuelCheckPokemonScreenTiles
	call $61c7
	call EnableLCD
.asm_6034
	ld hl, CursorData_60be
	ld a, [wcbd2]
	or a
	jr z, .asm_6040
	ld hl, CursorData_60c6
.asm_6040
	ld a, [wSelectedDuelSubMenuItem]
	call InitializeCursorParameters
	ld a, [wcbc8]
	ld [wNumMenuItems], a
.asm_604c
	call DoFrame
	call $60dd
	jr nc, .asm_6061
	cp $02
	jp z, $60ac
	pop af
	ldh [hTempCardIndex_ff98], a
	ld a, [wcbd4]
	jr OpenPlayAreaScreenForSelection
.asm_6061
	call HandleMenuInput
	jr nc, .asm_604c
	ld a, e
	ld [wSelectedDuelSubMenuItem], a
	ld a, [wcbd2]
	add e
	ld [wcbc9], a
	ld a, [wcbd6]
	ld b, a
	ldh a, [hButtonsPressed]
	and b
	jr z, .asm_6091
	ld a, [wcbc9]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	jr z, .asm_6022
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	call Func_576a
	jr .asm_6022
.asm_6091
	ld a, [wcbd2]
	ld c, a
	ldh a, [hCurrentMenuItem]
	add c
	ldh [hTempPlayAreaLocationOffset_ff9d], a
	ldh a, [hCurrentMenuItem]
	cp $ff
	jr z, .asm_60b5
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	jr nz, .asm_60ac
	jr .asm_6034
.asm_60ac
	pop af
	ldh [hTempCardIndex_ff98], a
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	ldh [hCurrentMenuItem], a
	or a
	ret
.asm_60b5
	pop af
	ldh [hTempCardIndex_ff98], a
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	ldh [hCurrentMenuItem], a
	scf
	ret
; 0x60be

CursorData_60be: ; 60be (1:60be)
	db 0, 0 ; x, y
	db 3 ; y displacement between items
	db 6 ; number of items
	db $0f ; cursor tile number
	db $00 ; tile behind cursor
	dw $60ce ; function pointer if non-0

CursorData_60c6: ; 60c6 (1:60c6)
	db 0, 3 ; x, y
	db 3 ; y displacement between items
	db 6 ; number of items
	db $0f ; cursor tile number
	db $00 ; tile behind cursor
	dw $60ce ; function pointer if non-0

	INCROM $60ce, $6785

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
	ld de, sDeck1Cards
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

Func_67b2: ; 67b2 (1:67b2)
	ld a, [wccf2]
	or a
	ret z
	ldh a, [hButtonsHeld]
	and B_BUTTON
	ret z
	scf
	ret
; 0x67be

; related to ai taking their turn in a duel
; called multiple times during one ai turn
AIMakeDecision: ; 67be (1:67be)
	ldh [hAIActionTableIndex], a
	ld hl, wcbf9
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
	ld hl, wcbe1
	ld [hl], $0
	ld hl, AIActionTable
	call JumpToFunctionInTable
	ld a, [wDuelFinished]
	ld hl, wcbe1
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
	dw DuelTransmissionError
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
	call PutHandCardInPlayArea
	ldh a, [hffa0]
	call LoadCardDataToBuffer1_FromDeckIndex
	call $5e75
	call $68e4
	ld a, $1
	ld [wAlreadyPlayedEnergy], a
	call DrawDuelMainScene
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

	INCROM $6df1, $70e6

Func_70e6: ; 70e6 (1:70e6)
	xor a
	ld [wAlreadyPlayedEnergy], a
	ld [wcc0c], a
	ld [wGotHeadsFromSandAttackOrSmokescreenCheck], a
	ldh a, [hWhoseTurn]
	ld [wcc05], a
	ret
; 0x70f6

SetAllPlayAreaPokemonCanEvolve: ; 70f6 (1:70f6)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld l, DUELVARS_ARENA_CARD_FLAGS_C2
.next_pkmn_loop
	res 5, [hl]
	set CAN_EVOLVE_THIS_TURN_F, [hl]
	inc l
	dec c
	jr nz, .next_pkmn_loop
	ret
; 0x7107

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
	ld c, 1 + MAX_BENCH_POKEMON + 1
.init_play_area
; initialize to $ff card in arena as well as cards in bench (plus a terminator)
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
	call LoadDuelCoinTossResultTiles

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
	ld hl, wCoinTossScreenTextID
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText

.asm_71ec
	ld hl, wCoinTossScreenTextID
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
	ld hl, wcd9d
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
	ld hl, wcd9f
	inc [hl]
	ld a, [wcd9e]
	or a
	jr z, .asm_72dc
	ld a, [hl]
	ld hl, wcd9c
	cp [hl]
	call z, WaitForWideTextBoxInput
	call $7324
	ld a, [wcd9c]
	ld hl, wcd9d
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
	ld hl, wcd9c
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
        farcall $6, $591f
        ret
; 0x757b

	INCROM $757b, $758f

Func_758f: ; 758f (1:758f)
	INCROM $758f, $7594

Func_7594: ; 7594 (1:7594)
	farcall $6, $661f
	ret
; 0x7599

	INCROM $7599, $8000