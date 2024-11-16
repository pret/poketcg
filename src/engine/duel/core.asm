; try to resume a saved duel from the main menu
TryContinueDuel::
	call SetupDuel
	call LoadAndValidateDuelSaveData
	ldtx hl, BackUpIsBrokenText
	jr c, HandleFailedToContinueDuel
;	fallthrough

_ContinueDuel::
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
	jp MainDuelLoop.between_turns

HandleFailedToContinueDuel:
	call DrawWideTextBox_WaitForInput
	call ResetSerial
	scf
	ret

; this function begins the duel after the opponent's graphics, name and deck have been introduced
; loads both player's decks and sets up the variables and resources required to begin a duel.
StartDuel_VSAIOpp::
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ld a, DUELIST_TYPE_PLAYER
	ld [wPlayerDuelistType], a
	ld a, [wNPCDuelDeckID]
	ld [wOpponentDeckID], a
	call LoadPlayerDeck
	call SwapTurn
	call LoadOpponentDeck
	call SwapTurn
	jr StartDuel

StartDuel_VSLinkOpp:
	ld a, MUSIC_DUEL_THEME_1
	ld [wDuelTheme], a
	ld hl, wOpponentName
	xor a
	ld [hli], a
	ld [hl], a
	ld [wIsPracticeDuel], a
;	fallthrough

StartDuel:
	ld hl, sp+$0
	ld a, l
	ld [wDuelReturnAddress], a
	ld a, h
	ld [wDuelReturnAddress + 1], a
	xor a
	ld [wCurrentDuelMenuItem], a
	call SetupDuel
	ld a, [wNPCDuelPrizes]
	ld [wDuelInitialPrizes], a
	call InitVariablesToBeginDuel
	ld a, [wDuelTheme]
	call PlaySong
	call HandleDuelSetup
	ret c
;	fallthrough

; the loop returns here after every turn switch
MainDuelLoop:
	xor a
	ld [wCurrentDuelMenuItem], a
	call UpdateSubstatusConditions_StartOfTurn
	call DisplayDuelistTurnScreen
	call HandleTurn

.between_turns
	call ExchangeRNG
	ld a, [wDuelFinished]
	or a
	jr nz, .duel_finished
	call UpdateSubstatusConditions_EndOfTurn
	call HandleBetweenTurnsEvents
	call FinishQueuedAnimations
	call ExchangeRNG
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
	jr MainDuelLoop

.practice_duel
	ld a, [wIsPracticeDuel]
	or a
	jr z, .next_turn
	ld a, [hl]
	cp 15 ; the practice duel lasts 15 turns (8 player turns and 7 opponent turns)
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
	call DrawDuelistPortraitsAndNames
	call PrintDuelResultStats
	pop af
	ldh [hWhoseTurn], a

; animate the duel result screen
; load the correct music and animation depending on result
	call ResetAnimationQueue
	ld a, [wDuelFinished]
	cp TURN_PLAYER_WON
	jr z, .active_duelist_won_duel
	cp TURN_PLAYER_LOST
	jr z, .active_duelist_lost_duel
	ld a, DUEL_ANIM_DUEL_DRAW
	ld c, MUSIC_MATCH_DRAW
	ldtx hl, DuelWasADrawText
	jr .handle_duel_finished
.active_duelist_won_duel
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .opponent_won_duel
.player_won_duel
	xor a ; DUEL_WIN
	ld [wDuelResult], a
	ld a, DUEL_ANIM_DUEL_WIN
	ld c, MUSIC_MATCH_VICTORY
	ldtx hl, WonDuelText
	jr .handle_duel_finished
.active_duelist_lost_duel
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .player_won_duel
.opponent_won_duel
	ld a, DUEL_LOSS
	ld [wDuelResult], a
	ld a, DUEL_ANIM_DUEL_LOSS
	ld c, MUSIC_MATCH_LOSS
	ldtx hl, LostDuelText

.handle_duel_finished
	call PlayDuelAnimation
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
	jr z, .tied_duel
	call PlayDefaultSong
	call WaitForWideTextBoxInput
	call FinishQueuedAnimations
	call ResetSerial
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ret

.tied_duel
	call WaitForWideTextBoxInput
	call FinishQueuedAnimations
	ld a, [wDuelTheme]
	call PlaySong
	ldtx hl, StartSuddenDeathMatchText
	call DrawWideTextBox_WaitForInput
	ld a, 1
	ld [wDuelInitialPrizes], a
	call InitVariablesToBeginDuel
	ld a, [wDuelType]
	cp DUELTYPE_LINK
	jr z, .link_duel
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call HandleDuelSetup
	jp MainDuelLoop
.link_duel
	call ExchangeRNG
	ld h, PLAYER_TURN
	ld a, [wSerialOp]
	cp $29
	jr z, .got_turn
	ld h, OPPONENT_TURN
.got_turn
	ld a, h
	ldh [hWhoseTurn], a
	call HandleDuelSetup
	jp nc, MainDuelLoop
	ret

; empty the screen, and setup text and graphics for a duel
SetupDuel:
	xor a ; SYM_SPACE
	ld [wTileMapFill], a
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadSymbolsFont
	call SetDefaultConsolePalettes
	lb de, $38, $9f
	call SetupText
	call EnableLCD
	ret

; handle the turn of the duelist identified by hWhoseTurn.
; if player's turn, display the animation of the player drawing the card at
; hTempCardIndex_ff98, and save the duel state to SRAM.
HandleTurn:
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld [wDuelistType], a
	ld a, [wDuelTurns]
	cp 2
	jr c, .skip_let_evolve ; jump if it's the turn holder's first turn
	call SetAllPlayAreaPokemonCanEvolve
.skip_let_evolve
	call InitVariablesToBeginTurn
	call DisplayDrawOneCardScreen
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
	jr z, .player_turn

; opponent's turn
	call SwapTurn
	call IsClairvoyanceActive
	call SwapTurn
	call c, DisplayPlayerDrawCardScreen
	jr DuelMainInterface

; player's turn
.player_turn
	call DisplayPlayerDrawCardScreen
	call SaveDuelStateToSRAM
;	fallthrough

; when a practice duel turn needs to be restarted because the player did not
; follow the instructions correctly, the game loops back here
RestartPracticeDuelTurn:
	ld a, PRACTICEDUEL_PRINT_TURN_INSTRUCTIONS
	call DoPracticeDuelAction
;	fallthrough

; print the main interface during a duel, including background, Pokemon, HUDs and a text box.
; the bottom text box changes depending on whether the turn belongs to the player (show the duel menu),
; an AI opponent (print "Waiting..." and a reduced menu) or a link opponent (print "<Duelist> is thinking").
DuelMainInterface:
	call DrawDuelMainScene
	ld a, [wDuelistType]
	cp DUELIST_TYPE_PLAYER
	jr z, PrintDuelMenuAndHandleInput
	cp DUELIST_TYPE_LINK_OPP
	jp z, DoLinkOpponentTurn
	; DUELIST_TYPE_AI_OPP
	xor a
	ld [wVBlankCounter], a
	ld [wSkipDuelistIsThinkingDelay], a
	ldtx hl, DuelistIsThinkingText
	call DrawWideTextBox_PrintTextNoDelay
	call AIDoAction_Turn
	ld a, $ff
	ld [wPlayerAttackingCardIndex], a
	ld [wPlayerAttackingAttackIndex], a
	ret

PrintDuelMenuAndHandleInput:
	call DrawWideTextBox
	ld hl, DuelMenuData
	call PlaceTextItems
.menu_items_printed
	call SaveDuelData
	ld a, [wDuelFinished]
	or a
	ret nz
	ld a, [wCurrentDuelMenuItem]
	call SetMenuItem

.handle_input
	call DoFrame
	ldh a, [hKeysHeld]
	and B_BUTTON
	jr z, .b_not_held
	ldh a, [hKeysPressed]
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
	ldh a, [hKeysPressed]
	and START
	jp nz, DuelMenuShortcut_PlayerActivePokemon
	ldh a, [hKeysPressed]
	bit SELECT_F, a
	jp nz, DuelMenuShortcut_BothActivePokemon
	ld a, [wDebugSkipDuelMenuInput]
	or a
	jr nz, .handle_input
	call HandleDuelMenuInput
	ld a, e
	ld [wCurrentDuelMenuItem], a
	jr nc, .handle_input
	ldh a, [hCurMenuItem]
	ld hl, DuelMenuFunctionTable
	jp JumpToFunctionInTable

DuelMenuFunctionTable:
	dw DuelMenu_Hand
	dw DuelMenu_Attack
	dw DuelMenu_Check
	dw DuelMenu_PkmnPower
	dw DuelMenu_Retreat
	dw DuelMenu_Done

; unreferenced
UnreferencedDrawCardFromDeckToHand:
	call DrawCardFromDeck
	call nc, AddCardToHand
	ld a, OPPACTION_DRAW_CARD
	call SetOppAction_SerialSendDuelData
	jp PrintDuelMenuAndHandleInput.menu_items_printed

; triggered by pressing B + UP in the duel menu
DuelMenuShortcut_OpponentPlayArea:
	call OpenNonTurnHolderPlayAreaScreen
	jp DuelMainInterface

; triggered by pressing B + DOWN in the duel menu
DuelMenuShortcut_PlayerPlayArea:
	call OpenTurnHolderPlayAreaScreen
	jp DuelMainInterface

; triggered by pressing B + RIGHT in the duel menu
DuelMenuShortcut_OpponentDiscardPile:
	call OpenNonTurnHolderDiscardPileScreen
	jp c, PrintDuelMenuAndHandleInput
	jp DuelMainInterface

; triggered by pressing B + LEFT in the duel menu
DuelMenuShortcut_PlayerDiscardPile:
	call OpenTurnHolderDiscardPileScreen
	jp c, PrintDuelMenuAndHandleInput
	jp DuelMainInterface

; draw the non-turn holder's play area screen
OpenNonTurnHolderPlayAreaScreen:
	call SwapTurn
	call OpenTurnHolderPlayAreaScreen
	call SwapTurn
	ret

; draw the turn holder's play area screen
OpenTurnHolderPlayAreaScreen:
	call HasAlivePokemonInPlayArea
	jp OpenPlayAreaScreenForViewing

; draw the non-turn holder's discard pile screen
OpenNonTurnHolderDiscardPileScreen:
	call SwapTurn
	call OpenDiscardPileScreen
	jp SwapTurn

; draw the turn holder's discard pile screen
OpenTurnHolderDiscardPileScreen:
	jp OpenDiscardPileScreen

; draw the non-turn holder's hand screen. simpler version of OpenPlayerHandScreen
; used only for checking the cards rather than for playing them.
OpenNonTurnHolderHandScreen_Simple:
	call SwapTurn
	call OpenTurnHolderHandScreen_Simple
	jp SwapTurn

; draw the turn holder's hand screen. simpler version of OpenPlayerHandScreen
; used only for checking the cards rather than for playing them.
; used for example in the "Your Play Area" screen of the Check menu
OpenTurnHolderHandScreen_Simple:
	call CreateHandCardList
	jr c, .no_cards_in_hand
	call InitAndDrawCardListScreenLayout
	ld a, START + A_BUTTON
	ld [wNoItemSelectionMenuKeys], a
	jp DisplayCardList
.no_cards_in_hand
	ldtx hl, NoCardsInHandText
	jp DrawWideTextBox_WaitForInput

; triggered by pressing B + START in the duel menu
DuelMenuShortcut_OpponentActivePokemon:
	call SwapTurn
	call OpenActivePokemonScreen
	call SwapTurn
	jp DuelMainInterface

; triggered by pressing START in the duel menu
DuelMenuShortcut_PlayerActivePokemon:
	call OpenActivePokemonScreen
	jp DuelMainInterface

; draw the turn holder's active Pokemon screen if it exists
OpenActivePokemonScreen:
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	ret z
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	ld hl, wCurPlayAreaSlot
	xor a
	ld [hli], a
	ld [hl], a ; wCurPlayAreaY
	call OpenCardPage_FromCheckPlayArea
	ret

; triggered by selecting the "Pkmn Power" item in the duel menu
DuelMenu_PkmnPower:
	call DisplayPlayAreaScreenToUsePkmnPower
	jp c, DuelMainInterface
	call UseAttackOrPokemonPower
	jp DuelMainInterface

; triggered by selecting the "Done" item in the duel menu
DuelMenu_Done:
	ld a, PRACTICEDUEL_REPEAT_INSTRUCTIONS
	call DoPracticeDuelAction
	; always jumps on practice duel (no action requires player to select Done)
	jp c, RestartPracticeDuelTurn
	ld a, OPPACTION_FINISH_NO_ATTACK
	call SetOppAction_SerialSendDuelData
	call ClearNonTurnTemporaryDuelvars
	ret

; triggered by selecting the "Retreat" item in the duel menu
DuelMenu_Retreat:
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp CONFUSED
	ldh [hTemp_ffa0], a
	jr nz, .not_confused
	ld a, [wConfusionRetreatCheckWasUnsuccessful]
	or a
	jr nz, .unable_due_to_confusion
	call CheckAbleToRetreat
	jr c, .unable_to_retreat
	call DisplayRetreatScreen
	jr c, .done
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	call OpenPlayAreaScreenForSelection
	jr c, .done
	ld [wBenchSelectedPokemon], a
	ld a, [wBenchSelectedPokemon] ; unnecessary
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, OPPACTION_ATTEMPT_RETREAT
	call SetOppAction_SerialSendDuelData
	call AttemptRetreat
	jr nc, .done
	call DrawDuelMainScene

.unable_due_to_confusion
	ldtx hl, UnableToRetreatText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenuAndHandleInput

.not_confused
	; note that the energy cards are discarded (DiscardRetreatCostCards), then returned
	; (ReturnRetreatCostCardsToArena), then discarded again for good (AttemptRetreat).
	; It's done this way so that the retreating Pokemon is listed with its energies updated
	; when the Play Area screen is shown to select the Pokemon to switch to. The reason why
	; AttemptRetreat is responsible for discarding the energy cards is because, if the
	; Pokemon is confused, it may not be able to retreat, so they cannot be discarded earlier.
	call CheckAbleToRetreat
	jr c, .unable_to_retreat
	call DisplayRetreatScreen
	jr c, .done
	call DiscardRetreatCostCards
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	call OpenPlayAreaScreenForSelection
	ld [wBenchSelectedPokemon], a
	ldh [hTempPlayAreaLocation_ffa1], a
	push af
	call ReturnRetreatCostCardsToArena
	pop af
	jp c, DuelMainInterface
	ld a, OPPACTION_ATTEMPT_RETREAT
	call SetOppAction_SerialSendDuelData
	call AttemptRetreat

.done
	jp DuelMainInterface

.unable_to_retreat
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenuAndHandleInput

; triggered by selecting the "Hand" item in the duel menu
DuelMenu_Hand:
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	or a
	jr nz, OpenPlayerHandScreen
	ldtx hl, NoCardsInHandText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenuAndHandleInput

; draw the screen for the player's hand and handle user input to for example check
; a card or attempt to use a card, playing the card if possible in that case.
OpenPlayerHandScreen:
	call CreateHandCardList
	call InitAndDrawCardListScreenLayout
	ldtx hl, PleaseSelectHandText
	call SetCardListInfoBoxText
	ld a, PLAY_CHECK
	ld [wCardListItemSelectionMenuType], a
.handle_input
	call DisplayCardList
	push af
	ld a, [wSortCardListByID]
	or a
	call nz, SortHandCardsByID
	pop af
	jp c, DuelMainInterface
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	ld c, a
	bit TYPE_TRAINER_F, c
	jr nz, .trainer_card
	bit TYPE_ENERGY_F, c
	jr nz, PlayEnergyCard
	call PlayPokemonCard
	jr c, ReloadCardListScreen ; jump if card not played
	jp DuelMainInterface
.trainer_card
	call PlayTrainerCard
	jr c, ReloadCardListScreen ; jump if card not played
	jp DuelMainInterface

; play the energy card with deck index at hTempCardIndex_ff98
; c contains the type of energy card being played
PlayEnergyCard:
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
	ld a, TRUE
	ld [wAlreadyPlayedEnergy], a
.play_energy
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld e, a
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	call PutHandCardInPlayArea
	call PrintPlayAreaCardList_EnableLCD
	ld a, OPPACTION_PLAY_ENERGY
	call SetOppAction_SerialSendDuelData
	call PrintAttachedEnergyToPokemon
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
	jp OpenPlayerHandScreen

.already_played_energy
	ldtx hl, MayOnlyAttachOneEnergyCardText
	call DrawWideTextBox_WaitForInput
;	fallthrough

; reload the card list screen after the card trying to play couldn't be played
ReloadCardListScreen:
	call CreateHandCardList
	; skip doing the things that have already been done when initially opened
	call DrawCardListScreenLayout
	jp OpenPlayerHandScreen.handle_input

; place a basic Pokemon card on the arena or bench, or place an stage 1 or 2
; Pokemon card over a Pokemon card already in play to evolve it.
; the card to use is loaded in wLoadedCard1 and its deck index is at hTempCardIndex_ff98.
; return nc if the card was played, carry if it wasn't.
PlayPokemonCard:
	ld a, [wLoadedCard1Stage]
	or a ; BASIC
	jr nz, .try_evolve ; jump if the card being played is a Stage 1 or 2 Pokemon
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .no_space
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	call PutHandPokemonCardInPlayArea
	ldh [hTempPlayAreaLocation_ff9d], a
	add DUELVARS_ARENA_CARD_STAGE
	call GetTurnDuelistVariable
	ld [hl], BASIC
	ld a, OPPACTION_PLAY_BASIC_PKMN
	call SetOppAction_SerialSendDuelData
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, 20
	call CopyCardNameAndLevel
	ld [hl], $00
	ld hl, $0000
	call LoadTxRam2
	ldtx hl, PlacedOnTheBenchText
	call DrawWideTextBox_WaitForInput
	call ProcessPlayedPokemonCard
	or a
	ret

.no_space
	ldtx hl, NoSpaceOnTheBenchText
	call DrawWideTextBox_WaitForInput
	scf
	ret

.try_evolve
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ldh a, [hTempCardIndex_ff98]
	ld d, a
	ld e, PLAY_AREA_ARENA
	push de
	push bc
.next_play_area_pkmn
	push de
	call CheckIfCanEvolveInto
	pop de
	jr nc, .can_evolve
	inc e
	dec c
	jr nz, .next_play_area_pkmn
	pop bc
	pop de
.find_cant_evolve_reason_loop
	push de
	call CheckIfCanEvolveInto
	pop de
	ldtx hl, CantEvolvePokemonInSameTurnItsPlacedText
	jr nz, .cant_same_turn
	inc e
	dec c
	jr nz, .find_cant_evolve_reason_loop
	ldtx hl, NoPokemonCapableOfEvolvingText
.cant_same_turn
	; don't bother opening the selection screen if there are no pokemon capable of evolving
	call DrawWideTextBox_WaitForInput
	scf
	ret

.can_evolve
	pop bc
	pop de
	call IsPrehistoricPowerActive
	jr c, .prehistoric_power
	call HasAlivePokemonInPlayArea
.try_evolve_loop
	call OpenPlayAreaScreenForSelection
	jr c, .done
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTempPlayAreaLocation_ffa1], a
	call EvolvePokemonCardIfPossible
	jr c, .try_evolve_loop ; jump if evolution wasn't successful somehow
	ld a, OPPACTION_EVOLVE_PKMN
	call SetOppAction_SerialSendDuelData
	call PrintPlayAreaCardList_EnableLCD
	call PrintPokemonEvolvedIntoPokemon
	call ProcessPlayedPokemonCard
.done
	or a
	ret

.prehistoric_power
	call DrawWideTextBox_WaitForInput
	scf
	ret

; triggered by selecting the "Check" item in the duel menu
DuelMenu_Check:
	call FinishQueuedAnimations
	call OpenDuelCheckMenu
	jp DuelMainInterface

; triggered by pressing SELECT in the duel menu
DuelMenuShortcut_BothActivePokemon:
	call FinishQueuedAnimations
	call OpenVariousPlayAreaScreens_FromSelectPresses
	jp DuelMainInterface

OpenVariousPlayAreaScreens_FromSelectPresses:
	call OpenInPlayAreaScreen_FromSelectButton
	ret c
	call .Func_45a9
	ret c
	call SwapTurn
	call .Func_45a9
	call SwapTurn
	ret

.Func_45a9
	call HasAlivePokemonInPlayArea
	ld a, $02
	ld [wPlayAreaSelectAction], a
	call OpenPlayAreaScreenForViewing
	ldh a, [hKeysPressed]
	and B_BUTTON
	ret z
	scf
	ret

; check if the turn holder's arena Pokemon is unable to retreat due to
; some status condition or due the bench containing no alive Pokemon.
; return carry if unable, nc if able.
CheckAbleToRetreat:
	call CheckUnableToRetreatDueToEffect
	ret c
	call CheckIfActiveCardParalyzedOrAsleep
	ret c
	call HasAlivePokemonInBench
	jr c, .unable_to_retreat
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	ld a, [wLoadedCard1Type]
	cp TYPE_TRAINER
	jr z, .unable_to_retreat
	call CheckIfEnoughEnergiesToRetreat
	jr c, .not_enough_energies
	or a
	ret
.not_enough_energies
	ld a, [wEnergyCardsRequiredToRetreat]
	ld l, a
	ld h, $00
	call LoadTxRam3
	ldtx hl, EnergyCardsRequiredToRetreatText
	jr .done
.unable_to_retreat
	ldtx hl, UnableToRetreatText
.done
	scf
	ret

; check if the turn holder's arena Pokemon has enough energies attached to it
; in order to retreat. Return carry if it doesn't.
; load amount of energies required to wEnergyCardsRequiredToRetreat.
CheckIfEnoughEnergiesToRetreat:
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call GetPlayAreaCardRetreatCost
	ld [wEnergyCardsRequiredToRetreat], a
	ld c, a
	ld a, [wTotalAttachedEnergies]
	cp c
	ret c
	ld [wNumRetreatEnergiesSelected], a
	ld a, c
	ld [wEnergyCardsRequiredToRetreat], a
	or a
	ret

; display the screen that prompts the player to select energy cards to discard
; in order to retreat a Pokemon card. also handle input in order to display
; the amount of energy cards already selected, and return whenever enough
; energy cards have been selected or if the player declines to retreat.
DisplayRetreatScreen:
	ld a, $ff
	ldh [hTempRetreatCostCards], a
	ld a, [wEnergyCardsRequiredToRetreat]
	or a
	ret z ; return if no energy cards are required at all
	xor a
	ld [wNumRetreatEnergiesSelected], a
	call CreateArenaOrBenchEnergyCardList
	call SortCardsInDuelTempListByID
	ld a, LOW(hTempRetreatCostCards)
	ld [wTempRetreatCostCardsPos], a
	xor a ; PLAY_AREA_ARENA
	call DisplayEnergyDiscardScreen
	ld a, [wEnergyCardsRequiredToRetreat]
	ld [wEnergyDiscardMenuDenominator], a
.select_energies_loop
	ld a, [wNumRetreatEnergiesSelected]
	ld [wEnergyDiscardMenuNumerator], a
	call HandleEnergyDiscardMenuInput
	ret c
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer2_FromDeckIndex
	; append selected energy card to hTempRetreatCostCards
	ld hl, wTempRetreatCostCardsPos
	ld c, [hl]
	inc [hl]
	ldh a, [hTempCardIndex_ff98]
	ld [$ff00+c], a
	; accumulate selected energy card
	ld c, 1
	ld a, [wLoadedCard2Type]
	cp TYPE_ENERGY_DOUBLE_COLORLESS
	jr nz, .not_double
	inc c
.not_double
	ld hl, wNumRetreatEnergiesSelected
	ld a, [hl]
	add c
	ld [hl], a
	ld hl, wEnergyCardsRequiredToRetreat
	cp [hl]
	jr nc, .enough
	; not enough energies selected yet
	ldh a, [hTempCardIndex_ff98]
	call RemoveCardFromDuelTempList
	call DisplayEnergyDiscardMenu
	jr .select_energies_loop
.enough
	; terminate hTempRetreatCostCards array with $ff
	ld a, [wTempRetreatCostCardsPos]
	ld c, a
	ld a, $ff
	ld [$ff00+c], a
	or a
	ret

; display the screen that prompts the player to select energy cards to discard
; in order to retreat a Pokemon card or use an attack like Ember. includes the
; card's information and a menu to select the attached energy cards to discard.
; input: a = PLAY_AREA_* of the Pokemon trying to discard energies from.
DisplayEnergyDiscardScreen:
	ld [wEnergyDiscardPlayAreaLocation], a
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	call LoadDuelFaceDownCardTiles
	ld a, [wEnergyDiscardPlayAreaLocation]
	ld hl, wCurPlayAreaSlot
	ld [hli], a
	ld [hl], 0 ; wCurPlayAreaY
	call PrintPlayAreaCardInformation
	xor a
	ld [wEnergyDiscardMenuNumerator], a
	inc a
	ld [wEnergyDiscardMenuDenominator], a
;	fallthrough

; display the menu that belongs to the energy discard screen that lets the player
; select energy cards attached to a Pokemon card in order to retreat it or use
; an attack like Ember, Flamethrower...
DisplayEnergyDiscardMenu:
	lb de, 0, 3
	lb bc, 20, 10
	call DrawRegularTextBox
	ldtx hl, ChooseEnergyCardToDiscardText
	call DrawWideTextBox_PrintTextNoDelay
	call EnableLCD
	call CountCardsInDuelTempList
	ld hl, EnergyDiscardCardListParameters
	lb de, 0, 0 ; initial page scroll offset, initial item (in the visible page)
	call PrintCardListItems
	ld a, 4
	ld [wCardListIndicatorYPosition], a
	ret

; if [wEnergyDiscardMenuDenominator] non-0:
   ; prints "[wEnergyDiscardMenuNumerator]/[wEnergyDiscardMenuDenominator]" at 16,16
   ; where [wEnergyDiscardMenuNumerator] is the number of energy cards already selected to discard
   ; and [wEnergyDiscardMenuDenominator] is the total number of energies that are required to discard.
; if [wEnergyDiscardMenuDenominator] == 0:
	; prints only "[wEnergyDiscardMenuNumerator]"
HandleEnergyDiscardMenuInput:
	lb bc, 16, 16
	ld a, [wEnergyDiscardMenuDenominator]
	or a
	jr z, .print_single_number
	ld a, [wEnergyDiscardMenuNumerator]
	add SYM_0
	call WriteByteToBGMap0
	inc b
	ld a, SYM_SLASH
	call WriteByteToBGMap0
	inc b
	ld a, [wEnergyDiscardMenuDenominator]
	add SYM_0
	call WriteByteToBGMap0
	jr .wait_input
.print_single_number
	ld a, [wEnergyDiscardMenuNumerator]
	inc b
	call WriteTwoDigitNumberInTxSymbolFormat
.wait_input
	call DoFrame
	call HandleCardListInput
	jr nc, .wait_input
	cp $ff ; B pressed?
	jr z, .return_carry
	call GetCardInDuelTempList_OnlyDeckIndex
	or a
	ret
.return_carry
	scf
	ret

EnergyDiscardCardListParameters:
	db 1, 5 ; cursor x, cursor y
	db 4 ; item x
	db 14 ; maximum length, in tiles, occupied by the name and level string of each card in the list
	db 4 ; number of items selectable without scrolling
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; triggered by selecting the "Attack" item in the duel menu
DuelMenu_Attack:
	call HandleCantAttackSubstatus
	jr c, .alert_cant_attack_and_cancel_menu
	call CheckIfActiveCardParalyzedOrAsleep
	jr nc, .can_attack
.alert_cant_attack_and_cancel_menu
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenuAndHandleInput

.can_attack
	xor a
	ld [wSelectedDuelSubMenuItem], a
.try_open_attack_menu
	call PrintAndLoadAttacksToDuelTempList
	or a
	jr nz, .open_attack_menu
	ldtx hl, NoSelectableAttackText
	call DrawWideTextBox_WaitForInput
	jp PrintDuelMenuAndHandleInput

.open_attack_menu
	push af
	ld a, [wSelectedDuelSubMenuItem]
	ld hl, AttackMenuParameters
	call InitializeMenuParameters
	pop af
	ld [wNumMenuItems], a
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_ARENA_CARD
	ld a, [hl]
	call LoadCardDataToBuffer1_FromDeckIndex

.wait_for_input
	call DoFrame
	ldh a, [hKeysPressed]
	and START
	jr nz, .display_selected_attack_info
	call HandleMenuInput
	jr nc, .wait_for_input
	cp -1 ; was B pressed?
	jp z, PrintDuelMenuAndHandleInput
	ld [wSelectedDuelSubMenuItem], a
	call CheckIfEnoughEnergiesToAttack
	jr nc, .enough_energy
	ldtx hl, NotEnoughEnergyCardsText
	call DrawWideTextBox_WaitForInput
	jr .try_open_attack_menu

.enough_energy
	ldh a, [hCurMenuItem]
	add a
	ld e, a
	ld d, $00
	ld hl, wDuelTempList
	add hl, de
	ld d, [hl] ; card's deck index (0 to 59)
	inc hl
	ld e, [hl] ; attack index (0 or 1)
	call CopyAttackDataAndDamage_FromDeckIndex
	call HandleAmnesiaSubstatus
	jr c, .cannot_use_due_to_amnesia
	ld a, PRACTICEDUEL_VERIFY_PLAYER_TURN_ACTIONS
	call DoPracticeDuelAction
	; if player did something wrong in the practice duel, jump in order to restart turn
	jp c, RestartPracticeDuelTurn
	call UseAttackOrPokemonPower
	jp c, DuelMainInterface
	ret

.cannot_use_due_to_amnesia
	call DrawWideTextBox_WaitForInput
	jr .try_open_attack_menu

.display_selected_attack_info
	call OpenAttackPage
	call DrawDuelMainScene
	jp .try_open_attack_menu

; draw the attack page of the card at wLoadedCard1 and of the attack selected in the Attack
; menu by hCurMenuItem, and listen for input in order to switch the page or to exit.
OpenAttackPage:
	ld a, CARDPAGE_POKEMON_OVERVIEW
	ld [wCardPageNumber], a
	xor a
	ld [wCurPlayAreaSlot], a
	call EmptyScreen
	call FinishQueuedAnimations
	ld de, v0Tiles1 + $20 tiles
	call LoadLoaded1CardGfx
	call SetOBP1OrSGB3ToCardPalette
	call SetBGP6OrSGB3ToCardPalette
	call FlushAllPalettesOrSendPal23Packet
	lb de, $38, $30 ; X Position and Y Position of top-left corner
	call PlaceCardImageOAM
	lb de, 6, 4
	call ApplyBGP6OrSGB3ToCardImage
	ldh a, [hCurMenuItem]
	ld [wSelectedDuelSubMenuItem], a
	add a
	ld e, a
	ld d, $00
	ld hl, wDuelTempList + 1
	add hl, de
	ld a, [hl]
	or a
	jr nz, .attack_2
	xor a ; ATTACKPAGE_ATTACK1_1
	jr .attack_1

.attack_2
	ld a, ATTACKPAGE_ATTACK2_1

.attack_1
	ld [wAttackPageNumber], a

.open_page
	call DisplayAttackPage
	call EnableLCD

.loop
	call DoFrame
	; switch page (see SwitchAttackPage) if Right or Left pressed
	ldh a, [hDPadHeld]
	and D_RIGHT | D_LEFT
	jr nz, .open_page
	; return to Attack menu if A or B pressed
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .loop
	ret

AttackMenuParameters:
	db 1, 13 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; display the card page with id at wAttackPageNumber of wLoadedCard1
DisplayAttackPage:
	ld a, [wAttackPageNumber]
	ld hl, AttackPageDisplayPointerTable
	jp JumpToFunctionInTable

AttackPageDisplayPointerTable:
	dw DisplayAttackPage_Attack1Page1 ; ATTACKPAGE_ATTACK1_1
	dw DisplayAttackPage_Attack1Page2 ; ATTACKPAGE_ATTACK1_2
	dw DisplayAttackPage_Attack2Page1 ; ATTACKPAGE_ATTACK2_1
	dw DisplayAttackPage_Attack2Page2 ; ATTACKPAGE_ATTACK2_2

; display ATTACKPAGE_ATTACK1_1
DisplayAttackPage_Attack1Page1:
	call DisplayCardPage_PokemonAttack1Page1
	jr SwitchAttackPage

; display ATTACKPAGE_ATTACK1_2 if it exists. otherwise return in order
; to switch back to ATTACKPAGE_ATTACK1_1 and display it instead.
DisplayAttackPage_Attack1Page2:
	ld hl, wLoadedCard1Atk1Description + 2
	ld a, [hli]
	or [hl]
	ret z
	call DisplayCardPage_PokemonAttack1Page2
	jr SwitchAttackPage

; display ATTACKPAGE_ATTACK2_1
DisplayAttackPage_Attack2Page1:
	call DisplayCardPage_PokemonAttack2Page1
	jr SwitchAttackPage

; display ATTACKPAGE_ATTACK2_2 if it exists. otherwise return in order
; to switch back to ATTACKPAGE_ATTACK2_1 and display it instead.
DisplayAttackPage_Attack2Page2:
	ld hl, wLoadedCard1Atk2Description + 2
	ld a, [hli]
	or [hl]
	ret z
	call DisplayCardPage_PokemonAttack2Page2
;	fallthrough

; switch to ATTACKPAGE_ATTACK*_2 if in ATTACKPAGE_ATTACK*_1 and vice versa.
; sets the next attack page to switch to if Right or Left are pressed.
SwitchAttackPage:
	ld hl, wAttackPageNumber
	ld a, $01
	xor [hl]
	ld [hl], a
	ret

; given the card at hTempCardIndex_ff98, for each non-empty, non-Pokemon Power attack slot,
; prints its information at lines 13 (first attack, if any), and 15 (second attack, if any)
; also, copies zero, one, or both of the following to wDuelTempList, $ff terminated:
;   if pokemon's first attack slot isn't empty or a Pokemon Power: <card_index>, 0
;   if pokemon's second attack slot isn't empty or a Pokemon Power: <card_index>, 1
; return the amount of non-empty, non-Pokemon Power attacks in a.
PrintAndLoadAttacksToDuelTempList:
	call DrawWideTextBox
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardIndex_ff98], a
	call LoadCardDataToBuffer1_FromDeckIndex
	ld c, 0
	ld b, 13
	ld hl, wDuelTempList
	xor a
	ld [wCardPageNumber], a
	ld de, wLoadedCard1Atk1Name
	call .CheckAttackSlotEmptyOrPokemonPower
	jr c, .check_second_atk_slot
	ldh a, [hTempCardIndex_ff98]
	ld [hli], a
	xor a
	ld [hli], a
	inc c
	push hl
	push bc
	ld e, b
	ld hl, wLoadedCard1Atk1Name
	call PrintAttackOrPkmnPowerInformation
	pop bc
	pop hl
	inc b
	inc b ; 15

.check_second_atk_slot
	ld de, wLoadedCard1Atk2Name
	call .CheckAttackSlotEmptyOrPokemonPower
	jr c, .done
	ldh a, [hTempCardIndex_ff98]
	ld [hli], a
	ld a, $01
	ld [hli], a
	inc c
	push hl
	push bc
	ld e, b
	ld hl, wLoadedCard1Atk2Name
	call PrintAttackOrPkmnPowerInformation
	pop bc
	pop hl

.done
	ld a, c
	ret

; given de = wLoadedCard*Atk*Name, return carry if the attack is a
; Pkmn Power or if the attack slot is empty.
.CheckAttackSlotEmptyOrPokemonPower:
	push hl
	push de
	push bc
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	or c
	jr z, .return_no_atk_found
	ld hl, CARD_DATA_ATTACK1_CATEGORY - (CARD_DATA_ATTACK1_NAME + 1)
	add hl, de
	ld a, [hl]
	and $ff ^ RESIDUAL
	cp POKEMON_POWER
	jr z, .return_no_atk_found
	or a
.return
	pop bc
	pop de
	pop hl
	ret
.return_no_atk_found
	scf
	jr .return

; check if the arena pokemon card has enough energy attached to it
; in order to use the selected attack.
; returns: carry if not enough energy, nc if enough energy.
CheckIfEnoughEnergiesToAttack:
	push hl
	push bc
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	call HandleEnergyBurn
	ldh a, [hCurMenuItem]
	add a
	ld e, a
	ld d, $0
	ld hl, wDuelTempList
	add hl, de
	ld d, [hl] ; card's deck index (0 to 59)
	inc hl
	ld e, [hl] ; attack index (0 or 1)
	call _CheckIfEnoughEnergiesToAttack
	pop bc
	pop hl
	ret

; check if a pokemon card has enough energy attached to it in order to use an attack
; input:
;   d = deck index of card (0 to 59)
;   e = attack index (0 or 1)
;   wAttachedEnergies and wTotalAttachedEnergies
; returns: carry if not enough energy, nc if enough energy.
_CheckIfEnoughEnergiesToAttack:
	push de
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	pop bc
	push bc
	ld de, wLoadedCard1Atk1EnergyCost
	ld a, c
	or a
	jr z, .got_atk
	ld de, wLoadedCard1Atk2EnergyCost

.got_atk
	ld hl, CARD_DATA_ATTACK1_NAME - CARD_DATA_ATTACK1_ENERGY_COST
	add hl, de
	ld a, [hli]
	or [hl]
	jr z, .not_usable_or_not_enough_energies
	ld hl, CARD_DATA_ATTACK1_CATEGORY - CARD_DATA_ATTACK1_ENERGY_COST
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

; given the amount of energies of a specific type required for an attack in the
; lower nybble of register a, test if the pokemon card has enough energies of that type
; to use the attack. Return carry if not enough energy, nc if enough energy.
CheckIfEnoughEnergiesOfType:
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

; return carry and the corresponding text in hl if the turn holder's
; arena Pokemon card is paralyzed or asleep.
CheckIfActiveCardParalyzedOrAsleep:
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

; display the animation of the turn duelist drawing one card at the beginning of the turn
; if there isn't any card left in the deck, let the player know with a text message
DisplayDrawOneCardScreen:
	ld a, 1
;	fallthrough

; display the animation of the turn duelist drawing number of cards that is in a.
; if there isn't any card left in the deck, let the player know with a text message.
; input:
;	- a = number of cards to draw
DisplayDrawNCardsScreen:
	push hl
	push de
	push bc
	ld [wNumCardsTryingToDraw], a
	xor a
	ld [wNumCardsBeingDrawn], a
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE
	sub [hl]
	ld hl, wNumCardsTryingToDraw
	cp [hl]
	jr nc, .has_cards_left
	; trying to draw more cards than there are left in the deck
	ld [hl], a ; 0
.has_cards_left
	ld a, [wDuelDisplayedScreen]
	cp DRAW_CARDS
	jr z, .portraits_drawn
	cp SHUFFLE_DECK
	jr z, .portraits_drawn
	call EmptyScreen
	call DrawDuelistPortraitsAndNames
.portraits_drawn
	ld a, DRAW_CARDS
	ld [wDuelDisplayedScreen], a
	call PrintDeckAndHandIconsAndNumberOfCards
	ld a, [wNumCardsTryingToDraw]
	or a
	jr nz, .can_draw
	; if wNumCardsTryingToDraw set to 0 before, it's because not enough cards in deck
	ldtx hl, CannotDrawCardBecauseNoCardsInDeckText
	call DrawWideTextBox_WaitForInput
	jr .done
.can_draw
	ld l, a
	ld h, 0
	call LoadTxRam3
	ldtx hl, DrawCardsFromTheDeckText
	call DrawWideTextBox_PrintText
	call EnableLCD
.anim_drawing_cards_loop
	call PlayTurnDuelistDrawAnimation
	ld hl, wNumCardsBeingDrawn
	inc [hl]
	call PrintNumberOfHandAndDeckCards
	ld a, [wNumCardsBeingDrawn]
	ld hl, wNumCardsTryingToDraw
	cp [hl]
	jr c, .anim_drawing_cards_loop
	ld c, 30
.wait_loop
	call DoFrame
	call CheckSkipDelayAllowed
	jr c, .done
	dec c
	jr nz, .wait_loop
.done
	pop bc
	pop de
	pop hl
	ret

; animates the screen for Turn Duelist drawing a card
PlayTurnDuelistDrawAnimation:
	call ResetAnimationQueue
	ld e, DUEL_ANIM_PLAYER_DRAW
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .got_duelist
	ld e, DUEL_ANIM_OPP_DRAW
.got_duelist
	ld a, e
	call PlayDuelAnimation

.loop_anim
	call DoFrame
	call CheckSkipDelayAllowed
	jr c, .done_anim
	call CheckAnyAnimationPlaying
	jr c, .loop_anim

.done_anim
	call FinishQueuedAnimations
	ret

; prints, for each duelist, the number of cards in the hand along with the
; hand icon, and the number of cards in the deck, along with the deck icon,
; according to each element's placement in the draw card(s) screen.
PrintDeckAndHandIconsAndNumberOfCards:
	call LoadDuelDrawCardsScreenTiles
	ld hl, DeckAndHandIconsTileData
	call WriteDataBlocksToBGMap0
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	call BankswitchVRAM1
	ld hl, DeckAndHandIconsCGBPalData
	call WriteDataBlocksToBGMap0
	call BankswitchVRAM0
.not_cgb
	call PrintPlayerNumberOfHandAndDeckCards
	call PrintOpponentNumberOfHandAndDeckCards
	ret

; prints, for each duelist, the number of cards in the hand, and the number
; of cards in the deck, according to their placement in the draw card(s) screen.
; input: wNumCardsBeingDrawn = number of cards being drawn (in order to add
; them to the hand cards and subtract them from the deck cards).
PrintNumberOfHandAndDeckCards:
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, PrintOpponentNumberOfHandAndDeckCards
;	fallthrough

PrintPlayerNumberOfHandAndDeckCards:
	ld a, [wPlayerNumberOfCardsInHand]
	ld hl, wNumCardsBeingDrawn
	add [hl]
	ld d, a
	ld a, DECK_SIZE
	ld hl, wPlayerNumberOfCardsNotInDeck
	sub [hl]
	ld hl, wNumCardsBeingDrawn
	sub [hl]
	ld e, a
	ld a, d
	lb bc, 16, 10
	call WriteTwoDigitNumberInTxSymbolFormat
	ld a, e
	lb bc, 10, 10
	jp WriteTwoDigitNumberInTxSymbolFormat

PrintOpponentNumberOfHandAndDeckCards:
	ld a, [wOpponentNumberOfCardsInHand]
	ld hl, wNumCardsBeingDrawn
	add [hl]
	ld d, a
	ld a, DECK_SIZE
	ld hl, wOpponentNumberOfCardsNotInDeck
	sub [hl]
	ld hl, wNumCardsBeingDrawn
	sub [hl]
	ld e, a
	ld a, d
	lb bc, 5, 3
	call WriteTwoDigitNumberInTxSymbolFormat
	ld a, e
	lb bc, 11, 3
	jp WriteTwoDigitNumberInTxSymbolFormat

DeckAndHandIconsTileData:
; x, y, tiles[], 0
	db  4,  3, SYM_CROSS, 0 ; x for opponent's hand
	db 10,  3, SYM_CROSS, 0 ; x for opponent's deck
	db  8,  2, $f4, $f5,  0 ; opponent's deck icon
	db  8,  3, $f6, $f7,  0 ; opponent's deck icon
	db  2,  2, $f8, $f9,  0 ; opponent's hand icon
	db  2,  3, $fa, $fb,  0 ; opponent's hand icon
	db  9, 10, SYM_CROSS, 0 ; x for player's deck
	db 15, 10, SYM_CROSS, 0 ; x for player's hand
	db  7,  9, $f4, $f5,  0 ; player's deck icon
	db  7, 10, $f6, $f7,  0 ; player's deck icon
	db 13,  9, $f8, $f9,  0 ; player's hand icon
	db 13, 10, $fa, $fb,  0 ; player's hand icon
	db $ff

DeckAndHandIconsCGBPalData:
; x, y, pals[], 0
	db  8,  2, $02, $02, 0
	db  8,  3, $02, $02, 0
	db  2,  2, $02, $02, 0
	db  2,  3, $02, $02, 0
	db  7,  9, $02, $02, 0
	db  7, 10, $02, $02, 0
	db 13,  9, $02, $02, 0
	db 13, 10, $02, $02, 0
	db $ff

; draw the portraits of the two duelists and print their names.
; also draw an horizontal line separating the two sides.
DrawDuelistPortraitsAndNames:
	call LoadSymbolsFont
	; player's name
	ld de, wDefaultText
	push de
	call CopyPlayerName
	lb de, 0, 11
	call InitTextPrinting
	pop hl
	call ProcessText
	; player's portrait
	lb bc, 0, 5
	call DrawPlayerPortrait
	; opponent's name (aligned to the right)
	ld de, wDefaultText
	push de
	call CopyOpponentName
	pop hl
	call GetTextLengthInTiles
	push hl
	add SCREEN_WIDTH
	ld d, a
	ld e, 0
	call InitTextPrinting
	pop hl
	call ProcessText
	; opponent's portrait
	ld a, [wOpponentPortrait]
	lb bc, 13, 1
	call DrawOpponentPortrait
	; middle line
	call DrawDuelHorizontalSeparator
	ret

; print the number of prizes left, of active Pokemon, and of cards left in the deck
; of both duelists. this is called when the duel ends.
PrintDuelResultStats:
	lb de, 8, 8
	call .PrintDuelistResultStats
	call SwapTurn
	lb de, 1, 1
	call .PrintDuelistResultStats
	call SwapTurn
	ret

; print, at d,e, the number of prizes left, of active Pokemon, and of cards left in
; the deck of the turn duelist. b,c are used throughout as input coords for
; WriteTwoDigitNumberInTxSymbolFormat, and d,e for InitTextPrinting_ProcessTextFromID.
.PrintDuelistResultStats:
	call SetNoLineSeparation
	ldtx hl, PrizesLeftActivePokemonCardsInDeckText
	call InitTextPrinting_ProcessTextFromID
	call SetOneLineSeparation
	ld c, e
	ld a, d
	add 7
	ld b, a
	inc a
	inc a
	ld d, a
	call CountPrizes
	call .print_x_cards
	inc e
	inc c
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ldtx hl, YesText
	or a
	jr nz, .pkmn_in_play_area
	ldtx hl, NoneText
.pkmn_in_play_area
	dec d
	call InitTextPrinting_ProcessTextFromID
	inc e
	inc d
	inc c
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE
	sub [hl]
.print_x_cards
	call WriteTwoDigitNumberInTxSymbolFormat
	ldtx hl, CardsText
	call InitTextPrinting_ProcessTextFromID
	ret

; display the animation of the player drawing the card at hTempCardIndex_ff98
DisplayPlayerDrawCardScreen:
	ldtx hl, YouDrewText
	ldh a, [hTempCardIndex_ff98]
;	fallthrough

; display card detail when a card is drawn or played
; hl is text to display
; a is the card's deck index
DisplayCardDetailScreen:
	call LoadCardDataToBuffer1_FromDeckIndex
	call _DisplayCardDetailScreen
	ret

DisplayCardListDetails:
	ld a, [wDuelTempList]
	cp $ff
	ret z
	call InitAndDrawCardListScreenLayout
	call CountCardsInDuelTempList ; list length
	ld hl, CardListParameters ; other list params
	lb de, 0, 0 ; initial page scroll offset, initial item (in the visible page)
	call PrintCardListItems
	ldtx hl, TheCardYouReceivedText
	lb de, 1, 1
	call InitTextPrinting
	call PrintTextNoDelay
	ldtx hl, YouReceivedTheseCardsText
	call DrawWideTextBox_WaitForInput
	ret

; handles the initial duel actions:
; - drawing starting hand and placing the Basic Pokemon cards
; - placing the appropriate number of prize cards
; - tossing coin to determine first player to go
HandleDuelSetup:
; init variables and shuffle cards
	call InitializeDuelVariables
	call SwapTurn
	call InitializeDuelVariables
	call SwapTurn
	call PlayShuffleAndDrawCardsAnimation_BothDuelists
	call ShuffleDeckAndDrawSevenCards
	ldh [hTemp_ffa0], a
	call SwapTurn
	call ShuffleDeckAndDrawSevenCards
	call SwapTurn
	ld c, a

; check if any Basic Pokémon cards were drawn
	ldh a, [hTemp_ffa0]
	ld b, a
	and c
	jr nz, .hand_cards_ok
	ld a, b
	or c
	jr z, .neither_drew_basic_pkmn
	ld a, b
	or a
	jr nz, .opp_drew_no_basic_pkmn

;.player_drew_no_basic_pkmn
.ensure_player_basic_pkmn_loop
	call DisplayNoBasicPokemonInHandScreenAndText
	call InitializeDuelVariables
	call PlayShuffleAndDrawCardsAnimation_TurnDuelist
	call ShuffleDeckAndDrawSevenCards
	jr c, .ensure_player_basic_pkmn_loop
	jr .hand_cards_ok

.opp_drew_no_basic_pkmn
	call SwapTurn
.ensure_opp_basic_pkmn_loop
	call DisplayNoBasicPokemonInHandScreenAndText
	call InitializeDuelVariables
	call PlayShuffleAndDrawCardsAnimation_TurnDuelist
	call ShuffleDeckAndDrawSevenCards
	jr c, .ensure_opp_basic_pkmn_loop
	call SwapTurn
	jr .hand_cards_ok

.neither_drew_basic_pkmn
	ldtx hl, NeitherPlayerHasBasicPkmnText
	call DrawWideTextBox_WaitForInput
	call DisplayNoBasicPokemonInHandScreen
	call InitializeDuelVariables
	call SwapTurn
	call DisplayNoBasicPokemonInHandScreen
	call InitializeDuelVariables
	call SwapTurn
	call PrintReturnCardsToDeckDrawAgain
	jp HandleDuelSetup

.hand_cards_ok
	ldh a, [hWhoseTurn]
	push af
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call ChooseInitialArenaAndBenchPokemon
	call SwapTurn
	call ChooseInitialArenaAndBenchPokemon
	call SwapTurn
	jp c, .error
	call DrawPlayAreaToPlacePrizeCards
	ldtx hl, PlacingThePrizesText
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG

	ld a, [wDuelInitialPrizes]
	ld l, a
	ld h, 0
	call LoadTxRam3
	ldtx hl, PleasePlacePrizesText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call .PlacePrizes
	call WaitForWideTextBoxInput
	pop af

	ldh [hWhoseTurn], a
	call InitTurnDuelistPrizes
	call SwapTurn
	call InitTurnDuelistPrizes
	call SwapTurn
	call EmptyScreen
	ld a, BOXMSG_COIN_TOSS
	call DrawDuelBoxMessage
	ldtx hl, CoinTossToDecideWhoPlaysFirstText
	call DrawWideTextBox_WaitForInput
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .opponent_turn

; player flips coin
	ld de, wDefaultText
	call CopyPlayerName
	ld hl, $0000
	call LoadTxRam2
	ldtx hl, YouPlayFirstText
	ldtx de, IfHeadsDuelistPlaysFirstText
	call TossCoin
	jr c, .play_first
	call SwapTurn
	ldtx hl, YouPlaySecondText
.play_first
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	or a
	ret

.opponent_turn
; opp flips coin
	ld de, wDefaultText
	call CopyOpponentName
	ld hl, $0000
	call LoadTxRam2
	ldtx hl, YouPlaySecondText
	ldtx de, IfHeadsDuelistPlaysFirstText
	call TossCoin
	jr c, .play_second
	call SwapTurn
	ldtx hl, YouPlayFirstText
.play_second
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	or a
	ret

.error
	pop af
	ldh [hWhoseTurn], a
	scf
	ret

; places the prize cards on both sides
; of the Play Area (player & opp)
.PlacePrizes
	ld hl, .PrizeCardCoordinates
	ld e, DECK_SIZE - 7 - 1 ; deck size - cards drawn - 1
	ld a, [wDuelInitialPrizes]
	ld d, a

.place_prize
	push de
	ld b, 20 ; frames to delay
.loop_delay
	call DoFrame
	call CheckSkipDelayAllowed
	jr c, .skip_delay
	dec b
	jr nz, .loop_delay
.skip_delay
	call .DrawPrizeTile
	call .DrawPrizeTile

	push hl
	ld a, SFX_PLACE_PRIZE
	call PlaySFX
	; print new deck card number
	lb bc, 3, 5
	ld a, e
	call WriteTwoDigitNumberInTxSymbolFormat
	lb bc, 18, 7
	ld a, e
	call WriteTwoDigitNumberInTxSymbolFormat
	pop hl
	pop de
	dec e ; decrease number of cards in deck
	dec d ; decrease number of prize cards left
	jr nz, .place_prize
	ret

.DrawPrizeTile
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld a, $ac ; prize card tile
	jp WriteByteToBGMap0

.PrizeCardCoordinates
; player x, player y, opp x, opp y
	db 5, 6, 14, 5 ; Prize 1
	db 6, 6, 13, 5 ; Prize 2
	db 5, 7, 14, 4 ; Prize 3
	db 6, 7, 13, 4 ; Prize 4
	db 5, 8, 14, 3 ; Prize 5
	db 6, 8, 13, 3 ; Prize 6

; have the turn duelist place, at the beginning of the duel, the active Pokemon
; and 0 more bench Pokemon, all of which must be basic Pokemon cards.
; also transmits the turn holder's duelvars to the other duelist in a link duel.
; called twice, once for each duelist.
ChooseInitialArenaAndBenchPokemon:
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .choose_arena
	cp DUELIST_TYPE_LINK_OPP
	jr z, .exchange_duelvars

; AI opponent's turn
	push af
	push hl
	call AIDoAction_StartDuel
	pop hl
	pop af
	ld [hl], a
	or a
	ret

; link opponent's turn
.exchange_duelvars
	ldtx hl, TransmittingDataText
	call DrawWideTextBox_PrintText
	call ExchangeRNG
	ld hl, wPlayerDuelVariables
	ld de, wOpponentDuelVariables
	ld c, (wOpponentDuelVariables - wPlayerDuelVariables) / 2
	call SerialExchangeBytes
	jr c, .error
	ld c, (wOpponentDuelVariables - wPlayerDuelVariables) / 2
	call SerialExchangeBytes
	jr c, .error
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld [hl], DUELIST_TYPE_LINK_OPP
	or a
	ret
.error
	jp DuelTransmissionError

; player's turn (either AI or link duel)
; prompt (force) the player to choose a basic Pokemon card to place in the arena
.choose_arena
	call EmptyScreen
	ld a, BOXMSG_ARENA_POKEMON
	call DrawDuelBoxMessage
	ldtx hl, ChooseBasicPkmnToPlaceInArenaText
	call DrawWideTextBox_WaitForInput
	ld a, PRACTICEDUEL_DRAW_SEVEN_CARDS
	call DoPracticeDuelAction
.choose_arena_loop
	xor a
	ldtx hl, PleaseChooseAnActivePokemonText
	call DisplayPlaceInitialPokemonCardsScreen
	jr c, .choose_arena_loop
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, PRACTICEDUEL_PLAY_GOLDEEN
	call DoPracticeDuelAction
	jr c, .choose_arena_loop
	ldh a, [hTempCardIndex_ff98]
	call PutHandPokemonCardInPlayArea
	ldh a, [hTempCardIndex_ff98]
	ldtx hl, PlacedInTheArenaText
	call DisplayCardDetailScreen
	jr .choose_bench

; after choosing the active Pokemon, let the player place 0 or more basic Pokemon
; cards in the bench. loop until the player decides to stop placing Pokemon cards.
.choose_bench
	call EmptyScreen
	ld a, BOXMSG_BENCH_POKEMON
	call DrawDuelBoxMessage
	ldtx hl, ChooseUpTo5BasicPkmnToPlaceOnBenchText
	call PrintScrollableText_NoTextBoxLabel
	ld a, PRACTICEDUEL_PUT_STARYU_IN_BENCH
	call DoPracticeDuelAction
.bench_loop
	ld a, TRUE
	ldtx hl, ChooseYourBenchPokemonText
	call DisplayPlaceInitialPokemonCardsScreen
	jr c, .bench_done
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .no_space
	ldh a, [hTempCardIndex_ff98]
	call PutHandPokemonCardInPlayArea
	ldh a, [hTempCardIndex_ff98]
	ldtx hl, PlacedOnTheBenchText
	call DisplayCardDetailScreen
	ld a, PRACTICEDUEL_DONE_PUTTING_ON_BENCH
	call DoPracticeDuelAction
	jr .bench_loop

.no_space
	ldtx hl, NoSpaceOnTheBenchText
	call DrawWideTextBox_WaitForInput
	jr .bench_loop

.bench_done
	ld a, PRACTICEDUEL_VERIFY_INITIAL_PLAY
	call DoPracticeDuelAction
	jr c, .bench_loop
	or a
	ret

; the turn duelist shuffles the deck unless it's a practice duel, then draws 7 cards
; returns $00 in a and carry if no basic Pokemon cards are drawn, and $01 in a otherwise
ShuffleDeckAndDrawSevenCards:
	call InitializeDuelVariables
	ld a, [wDuelType]
	cp DUELTYPE_PRACTICE
	jr z, .deck_ready
	call ShuffleDeck
	call ShuffleDeck
.deck_ready
	ld b, 7
.draw_loop
	call DrawCardFromDeck
	call AddCardToHand
	dec b
	jr nz, .draw_loop
	ld a, DUELVARS_HAND
	call GetTurnDuelistVariable
	ld b, $00
	ld c, 7
.cards_loop
	ld a, [hli]
	push hl
	push bc
	call LoadCardDataToBuffer1_FromDeckIndex
	call IsLoadedCard1BasicPokemon.skip_mysterious_fossil_clefairy_doll
	pop bc
	pop hl
	or b
	ld b, a
	dec c
	jr nz, .cards_loop
	ld a, b
	or a
	ret nz
	xor a
	scf
	ret

; return nc if the card at wLoadedCard1 is a basic Pokemon card
; MYSTERIOUS_FOSSIL and CLEFAIRY_DOLL do count as basic Pokemon cards
IsLoadedCard1BasicPokemon:
	ld a, [wLoadedCard1ID]
	cp MYSTERIOUS_FOSSIL
	jr z, .basic
	cp CLEFAIRY_DOLL
	jr z, .basic
;	fallthrough

; return nc if the card at wLoadedCard1 is a basic Pokemon card
; MYSTERIOUS_FOSSIL and CLEFAIRY_DOLL do NOT count unless already checked
.skip_mysterious_fossil_clefairy_doll
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .energy_trainer_nonbasic
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .energy_trainer_nonbasic

; basic
	ld a, $01
	ret ; z

.energy_trainer_nonbasic
	xor a
	scf
	ret

.basic ; MYSTERIOUS_FOSSIL or CLEFAIRY_DOLL
	ld a, $01
	or a
	ret ; nz

DisplayNoBasicPokemonInHandScreenAndText:
	ldtx hl, ThereAreNoBasicPokemonInHand
	call DrawWideTextBox_WaitForInput
	call DisplayNoBasicPokemonInHandScreen
;	fallthrough

; prints ReturnCardsToDeckAndDrawAgainText in a textbox and calls ExchangeRNG
PrintReturnCardsToDeckDrawAgain:
	ldtx hl, ReturnCardsToDeckAndDrawAgainText
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	ret

; display a bare list of seven hand cards of the turn duelist, and the duelist's name above
; used to let the player know that there are no basic Pokemon in the hand and need to redraw
DisplayNoBasicPokemonInHandScreen:
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	lb de, 0, 0
	lb bc, 20, 18
	call DrawRegularTextBox
	call CreateHandCardList
	call CountCardsInDuelTempList
	ld hl, NoBasicPokemonCardListParameters
	lb de, 0, 0
	call PrintCardListItems
	ldtx hl, DuelistHandText
	lb de, 1, 1
	call InitTextPrinting
	call PrintTextNoDelay
	call EnableLCD
	call WaitForWideTextBoxInput
	ret

NoBasicPokemonCardListParameters:
	db 1, 3 ; cursor x, cursor y
	db 4 ; item x
	db 14 ; maximum length, in tiles, occupied by the name and level string of each card in the list
	db 7 ; number of items selectable without scrolling
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; used only during the practice duel with Sam.
; displays the list with the player's cards in hand, and the player's name above the list.
DisplayPracticeDuelPlayerHandScreen:
	call CreateHandCardList
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	lb de, 0, 0
	lb bc, 20, 13
	call DrawRegularTextBox
	call CountCardsInDuelTempList ; list length
	ld hl, CardListParameters ; other list params
	lb de, 0, 0 ; initial page scroll offset, initial item (in the visible page)
	call PrintCardListItems
	ldtx hl, DuelistHandText
	lb de, 1, 1
	call InitTextPrinting
	call PrintTextNoDelay
	call EnableLCD
	ret

PlayShuffleAndDrawCardsAnimation_TurnDuelist:
	ld b, DUEL_ANIM_PLAYER_SHUFFLE
	ld c, DUEL_ANIM_PLAYER_DRAW
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .play_anim
	ld b, DUEL_ANIM_OPP_SHUFFLE
	ld c, DUEL_ANIM_OPP_DRAW
.play_anim
	ldtx hl, ShufflesTheDeckText
	ldtx de, Drew7CardsText
	jr PlayShuffleAndDrawCardsAnimation

PlayShuffleAndDrawCardsAnimation_BothDuelists:
	ld b, DUEL_ANIM_BOTH_SHUFFLE
	ld c, DUEL_ANIM_BOTH_DRAW
	ldtx hl, EachPlayerShuffleOpponentsDeckText
	ldtx de, EachPlayerDraw7CardsText
	ld a, [wDuelType]
	cp DUELTYPE_PRACTICE
	jr nz, PlayShuffleAndDrawCardsAnimation
	ldtx hl, ThisIsJustPracticeDoNotShuffleText
;	fallthrough

; animate the shuffle and drawing screen
; input:
;	b = shuffling animation index
;	c = drawing animation index
;	hl = text to print while shuffling
;	de = text to print while drawing
PlayShuffleAndDrawCardsAnimation:
	push bc
	push de
	push hl
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call DrawDuelistPortraitsAndNames
	call LoadDuelDrawCardsScreenTiles
	ld a, SHUFFLE_DECK
	ld [wDuelDisplayedScreen], a
	pop hl
	call DrawWideTextBox_PrintText
	call EnableLCD
	ld a, [wDuelType]
	cp DUELTYPE_PRACTICE
	jr nz, .not_practice
	call WaitForWideTextBoxInput
	jr .print_deck_info

.not_practice
; get the shuffling animation from input value of b
	call ResetAnimationQueue
	ld hl, sp+$03
	; play animation 3 times
	ld a, [hl]
	call PlayDuelAnimation
	ld a, [hl]
	call PlayDuelAnimation
	ld a, [hl]
	call PlayDuelAnimation

.loop_shuffle_anim
	call DoFrame
	call CheckSkipDelayAllowed
	jr c, .done_shuffle
	call CheckAnyAnimationPlaying
	jr c, .loop_shuffle_anim
.done_shuffle
	call FinishQueuedAnimations

.print_deck_info
	xor a
	ld [wNumCardsBeingDrawn], a
	call PrintDeckAndHandIconsAndNumberOfCards
	call ResetAnimationQueue
	pop hl
	call DrawWideTextBox_PrintText
.draw_card
; get the draw animation from input value of c
	ld hl, sp+$00
	ld a, [hl]
	call PlayDuelAnimation

.loop_drawing_anim
	call DoFrame
	call CheckSkipDelayAllowed
	jr c, .done
	call CheckAnyAnimationPlaying
	jr c, .loop_drawing_anim

	ld hl, wNumCardsBeingDrawn
	inc [hl]
	ld hl, sp+$00
	ld a, [hl]
	cp DUEL_ANIM_BOTH_DRAW
	jr nz, .one_duelist_shuffled
	; if both duelists shuffled
	call PrintDeckAndHandIconsAndNumberOfCards.not_cgb
	jr .check_num_cards
.one_duelist_shuffled
	call PrintNumberOfHandAndDeckCards

.check_num_cards
	ld a, [wNumCardsBeingDrawn]
	cp 7
	jr c, .draw_card

	ld c, 30
.wait_loop
	call DoFrame
	call CheckSkipDelayAllowed
	jr c, .done
	dec c
	jr nz, .wait_loop

.done
	call FinishQueuedAnimations
	pop bc
	ret

PlayDeckShuffleAnimation:
	ld a, [wDuelDisplayedScreen]
	cp SHUFFLE_DECK
	jr z, .skip_draw_scene
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call DrawDuelistPortraitsAndNames
.skip_draw_scene
	ld a, SHUFFLE_DECK
	ld [wDuelDisplayedScreen], a

; if duelist has only one card in deck,
; skip shuffling animation
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE
	sub [hl]
	cp 2
	jr c, .one_card_in_deck

	ldtx hl, ShufflesTheDeckText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call ResetAnimationQueue

; load correct animation depending on turn duelist
	ld e, DUEL_ANIM_PLAYER_SHUFFLE
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .load_anim
	ld e, DUEL_ANIM_OPP_SHUFFLE
.load_anim
; play animation 3 times
	ld a, e
	call PlayDuelAnimation
	ld a, e
	call PlayDuelAnimation
	ld a, e
	call PlayDuelAnimation

.loop_anim
	call DoFrame
	call CheckSkipDelayAllowed
	jr c, .done_anim
	call CheckAnyAnimationPlaying
	jr c, .loop_anim

.done_anim
	call FinishQueuedAnimations
	ld a, $01
	ret

.one_card_in_deck
; no animation, just print text and delay
	ld l, a
	ld h, $00
	call LoadTxRam3
	ldtx hl, DeckHasXCardsText
	call DrawWideTextBox_PrintText
	call EnableLCD
	ld a, 60
.loop_wait
	call DoFrame
	dec a
	jr nz, .loop_wait
	ld a, $01
	ret

; draw the main scene during a duel, except the contents of the bottom text box,
; which depend on the type of duelist holding the turn.
; includes the background, both arena Pokemon, and both HUDs.
DrawDuelMainScene::
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
	ld a, [wDuelDisplayedScreen]
	cp DUEL_MAIN_SCENE
	ret z
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadSymbolsFont
	ld a, DUEL_MAIN_SCENE
	ld [wDuelDisplayedScreen], a
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
	ld hl, DuelEAndHPTileData
	call WriteDataBlocksToBGMap0
	call DrawDuelHorizontalSeparator
	call DrawDuelHUDs
	call DrawWideTextBox
	call EnableLCD
	ret

; draws the main elements of the main duel interface, including HUDs, HPs, card names
; and color symbols, attached cards, and other information, of both duelists.
DrawDuelHUDs::
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .draw_hud
	ldh a, [hWhoseTurn]
	push af
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call .draw_hud
	pop af
	ldh [hWhoseTurn], a
	ret
.draw_hud
	lb de, 1, 11 ; coordinates for player's arena card name and info icons
	lb bc, 11, 8 ; coordinates for player's attached energies and HP bar
	call DrawDuelHUD
	lb bc, 8, 5
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	call CheckPrintCnfSlpPrz
	inc c
	call CheckPrintPoisoned
	inc c
	call CheckPrintDoublePoisoned ; if double poisoned, print a second poison icon
	call SwapTurn
	lb de, 7, 0 ; coordinates for opponent's arena card name and info icons
	lb bc, 3, 1 ; coordinates for opponent's attached energies and HP bar
	call GetNonTurnDuelistVariable
	call DrawDuelHUD
	lb bc, 11, 6
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	call CheckPrintCnfSlpPrz
	dec c
	call CheckPrintPoisoned
	dec c
	call CheckPrintDoublePoisoned ; if double poisoned, print a second poison icon
	call SwapTurn
	ret

DrawDuelHUD:
	ld hl, wHUDEnergyAndHPBarsX
	ld [hl], b
	inc hl
	ld [hl], c ; wHUDEnergyAndHPBarsY
	push de ; push coordinates for the arena card name
	ld d, 1 ; opponent's info icons start in the second tile to the right
	ld a, e
	or a
	jr z, .go
	ld d, 15 ; player's info icons start in the 15th tile to the right
.go
	push de
	pop bc

	; print the Pokemon icon along with the no. of play area Pokemon
	ld a, SYM_POKEMON
	call WriteByteToBGMap0
	inc b
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	add SYM_0 - 1
	call WriteByteToBGMap0
	inc b

	; print the Prize icon along with the no. of prizes yet to draw
	ld a, SYM_PRIZE
	call WriteByteToBGMap0
	inc b
	call CountPrizes
	add SYM_0
	call WriteByteToBGMap0

	; print the arena Pokemon card name and level text
	pop de
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	ret z
	call LoadCardDataToBuffer1_FromDeckIndex
	push de
	ld a, 32
	call CopyCardNameAndLevel
	ld [hl], TX_END

	; print the arena Pokemon card color symbol just before the name
	pop de
	ld a, e
	or a
	jr nz, .print_color_icon
	ld hl, wDefaultText
	call GetTextLengthInTiles
	add SCREEN_WIDTH
	ld d, a
.print_color_icon
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	push de
	pop bc
	call GetArenaCardColor
	inc a ; TX_SYMBOL color tiles start at 1
	dec b ; place the color symbol one tile to the left of the start of the card's name
	call JPWriteByteToBGMap0

	; print attached energies
	ld hl, wHUDEnergyAndHPBarsX
	ld b, [hl]
	inc hl
	ld c, [hl] ; wHUDEnergyAndHPBarsY
	lb de, 9, PLAY_AREA_ARENA
	call PrintPlayAreaCardAttachedEnergies

	; print HP bar
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1HP]
	ld d, a ; max HP
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld e, a ; cur HP
	call DrawHPBar
	ld hl, wHUDEnergyAndHPBarsX
	ld b, [hl]
	inc hl
	ld c, [hl] ; wHUDEnergyAndHPBarsY
	inc c ; [wHUDEnergyAndHPBarsY] + 1
	call BCCoordToBGMap0Address
	push de
	ld hl, wDefaultText
	ld b, HP_BAR_LENGTH / 2 ; first row of the HP bar
	call SafeCopyDataHLtoDE
	pop de
	ld hl, BG_MAP_WIDTH
	add hl, de
	ld e, l
	ld d, h
	ld hl, wDefaultText + HP_BAR_LENGTH / 2
	ld b, HP_BAR_LENGTH / 2 ; second row of the HP bar
	call SafeCopyDataHLtoDE

	; print number of attached Pluspower and Defender with respective icon, if any
	ld hl, wHUDEnergyAndHPBarsX
	ld a, [hli]
	add 6
	ld b, a
	ld c, [hl] ; wHUDEnergyAndHPBarsY
	inc c
	ld a, DUELVARS_ARENA_CARD_ATTACHED_PLUSPOWER
	call GetTurnDuelistVariable
	or a
	jr z, .check_defender
	ld a, SYM_PLUSPOWER
	call WriteByteToBGMap0
	inc b
	ld a, [hl] ; number of attached Pluspower
	add SYM_0
	call WriteByteToBGMap0
	dec b
.check_defender
	ld a, DUELVARS_ARENA_CARD_ATTACHED_DEFENDER
	call GetTurnDuelistVariable
	or a
	jr z, .done
	inc c
	ld a, SYM_DEFENDER
	call WriteByteToBGMap0
	inc b
	ld a, [hl] ; number of attached Defender
	add SYM_0
	call WriteByteToBGMap0
.done
	ret

; draws an horizontal line that separates the arena side of each duelist
; also colorizes the line on CGB
DrawDuelHorizontalSeparator:
	ld hl, DuelHorizontalSeparatorTileData
	call WriteDataBlocksToBGMap0
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret nz
	call BankswitchVRAM1
	ld hl, DuelHorizontalSeparatorCGBPalData
	call WriteDataBlocksToBGMap0
	call BankswitchVRAM0
	ret

DuelEAndHPTileData:
; x, y, tiles[], 0
	db 1, 1, SYM_E,  0
	db 1, 2, SYM_HP, 0
	db 9, 8, SYM_E,  0
	db 9, 9, SYM_HP, 0
	db $ff

DuelHorizontalSeparatorTileData:
; x, y, tiles[], 0
	db 0, 4, $37, $37, $37, $37, $37, $37, $37, $37, $37, $31, $32, 0
	db 9, 5, $33, $34, 0
	db 9, 6, $33, $34, 0
	db 9, 7, $35, $36, $37, $37, $37, $37, $37, $37, $37, $37, $37, 0
	db $ff

DuelHorizontalSeparatorCGBPalData:
; x, y, pals[], 0
	db 0, 4, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, 0
	db 9, 5, $02, $02, 0
	db 9, 6, $02, $02, 0
	db 9, 7, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, 0
	db $ff

; if this is a practice duel, execute the practice duel action at wPracticeDuelAction
; if not a practice duel, always return nc
; the practice duel functions below return carry when something's wrong
DoPracticeDuelAction:
	ld [wPracticeDuelAction], a
	ld a, [wIsPracticeDuel]
	or a
	ret z
	ld a, [wPracticeDuelAction]
	ld hl, PracticeDuelActionTable
	jp JumpToFunctionInTable

PracticeDuelActionTable:
	dw NULL
	dw PracticeDuel_DrawSevenCards
	dw PracticeDuel_PlayGoldeen
	dw PracticeDuel_PutStaryuInBench
	dw PracticeDuel_VerifyInitialPlay
	dw PracticeDuel_DonePuttingOnBench
	dw PracticeDuel_PrintTurnInstructions
	dw PracticeDuel_VerifyPlayerTurnActions
	dw PracticeDuel_RepeatInstructions
	dw PracticeDuel_PlayStaryuFromBench
	dw PracticeDuel_ReplaceKnockedOutPokemon

PracticeDuel_DrawSevenCards:
	call DisplayPracticeDuelPlayerHandScreen
	call EnableLCD
	ldtx hl, DrawSevenCardsPracticeDuelText
	jp PrintPracticeDuelDrMasonInstructions

PracticeDuel_PlayGoldeen:
	ld a, [wLoadedCard1ID]
	cp GOLDEEN
	ret z
	ldtx hl, ChooseGoldeenPracticeDuelText
	ldtx de, DrMasonText ; unnecessary
	scf
	jp PrintPracticeDuelDrMasonInstructions

PracticeDuel_PutStaryuInBench:
	call DisplayPracticeDuelPlayerHandScreen
	call EnableLCD
	ldtx hl, PutPokemonOnBenchPracticeDuelText
	jp PrintPracticeDuelDrMasonInstructions

PracticeDuel_VerifyInitialPlay:
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 2
	ret z
	ldtx hl, ChooseStaryuPracticeDuelText
	scf
	jp PrintPracticeDuelDrMasonInstructions

PracticeDuel_DonePuttingOnBench:
	call DisplayPracticeDuelPlayerHandScreen
	call EnableLCD
	ld a, $ff
	ld [wPracticeDuelTurn], a
	ldtx hl, PressBToFinishPracticeDuelText
	jp PrintPracticeDuelDrMasonInstructions

PracticeDuel_PrintTurnInstructions:
	call DrawPracticeDuelInstructionsTextBox
	call EnableLCD
	ld a, [wDuelTurns]
	ld hl, wPracticeDuelTurn
	cp [hl]
	ld [hl], a
	; calling PrintPracticeDuelInstructionsForCurrentTurn with a = 0 means that Dr. Mason's
	; instructions are also printed along with each of the point-by-point instructions
	ld a, 0
	jp nz, PrintPracticeDuelInstructionsForCurrentTurn
	; if we're here, the player followed the current turn actions wrong and has to
	; repeat them. ask the player whether to show detailed instructions again, in
	; order to call PrintPracticeDuelInstructionsForCurrentTurn with a = 0 or a = 1.
	ldtx de, DrMasonText
	ldtx hl, NeedPracticeAgainPracticeDuelText
	call PrintScrollableText_WithTextBoxLabel_NoWait
	call YesOrNoMenu
	jp PrintPracticeDuelInstructionsForCurrentTurn

PracticeDuel_VerifyPlayerTurnActions:
	ld a, [wDuelTurns]
	srl a
	ld hl, PracticeDuelTurnVerificationPointerTable
	call JumpToFunctionInTable
	; return nc if player followed instructions correctly
	ret nc
;	fallthrough

PracticeDuel_RepeatInstructions:
	ldtx hl, FollowMyGuidancePracticeDuelText
	call PrintPracticeDuelDrMasonInstructions
	; restart the turn from the saved data of the previous turn
	ld a, $02
	call BankswitchSRAM
	ld de, sCurrentDuel
	call LoadSavedDuelData
	xor a
	call BankswitchSRAM
	; return carry in order to repeat instructions
	scf
	ret

PracticeDuel_PlayStaryuFromBench:
	ld a, [wDuelTurns]
	cp 7
	jr z, .its_sam_turn_4
	or a
	ret
.its_sam_turn_4
	; ask player to choose Staryu from bench to replace knocked out Seaking
	call DrawPracticeDuelInstructionsTextBox
	call EnableLCD
	ld hl, PracticeDuelText_SamTurn4
	jp PrintPracticeDuelInstructions

PracticeDuel_ReplaceKnockedOutPokemon:
	ldh a, [hTempPlayAreaLocation_ff9d]
	cp PLAY_AREA_BENCH_1
	ret z
	; if player selected Drowzee instead (which is at PLAY_AREA_BENCH_2)
	call HasAlivePokemonInBench
	ldtx hl, SelectStaryuPracticeDuelText
	scf
;	fallthrough

; print a text box with given the text id at hl, labeled as 'Dr. Mason'
PrintPracticeDuelDrMasonInstructions:
	push af
	ldtx de, DrMasonText
	call PrintScrollableText_WithTextBoxLabel
	pop af
	ret

INCLUDE "data/duel/practice_text.asm"

; in a practice duel, draws the text box where the point-by-point
; instructions for the next player action will be written into
DrawPracticeDuelInstructionsTextBox:
	call EmptyScreen
	lb de, 0, 0
	lb bc, 20, 12
	call DrawRegularTextBox
;	fallthrough

; print "<Player>'s Turn [wDuelTurns]" (usually) as the textbox label
PrintPracticeDuelInstructionsTextBoxLabel:
	ld a, [wDuelTurns]
	cp 7
	jr z, .replace_due_to_knockout
	; load the player's turn number to TX_RAM3 in order to print it
	srl a
	inc a
	ld l, a
	ld h, $00
	call LoadTxRam3
	lb de, 1, 0
	call InitTextPrinting
	ldtx hl, PlayersTurnPracticeDuelText
	jp PrintText
.replace_due_to_knockout
	; when the player needs to replace a knocked out Pokemon, the label text is different
	; this happens at the end of Sam's fourth turn
	lb de, 1, 0
	ldtx hl, ReplaceDueToKnockoutPracticeDuelText
	jp InitTextPrinting_ProcessTextFromID

; print the instructions of the current practice duel turn, taken from
; one of the structs in PracticeDuelTextPointerTable.
; if a != 0, only the point-by-point instructions are printed, otherwise
; Dr. Mason instructions are also shown in a textbox at the bottom of the screen.
PrintPracticeDuelInstructionsForCurrentTurn:
	push af
	ld a, [wDuelTurns]
	and %11111110
	ld e, a
	ld d, $00
	ld hl, PracticeDuelTextPointerTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	or a
	jr nz, PrintPracticeDuelInstructions_Fast
;	fallthrough

; print practice duel instructions given hl = PracticeDuelText_*
; each practicetext entry (see above) contains a Dr. Mason text along with
; a numbered instruction text, that is later printed without text delay.
PrintPracticeDuelInstructions:
	xor a
	ld [wPracticeDuelTextY], a
	ld a, l
	ld [wPracticeDuelTextPointer], a
	ld a, h
	ld [wPracticeDuelTextPointer + 1], a
.print_instructions_loop
	call PrintNextPracticeDuelInstruction
	ld a, [hli]
	ld [wPracticeDuelTextY], a
	or a
	jr z, PrintPracticeDuelLetsPlayTheGame
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld l, e
	ld h, d
	ldtx de, DrMasonText
	call PrintScrollableText_WithTextBoxLabel
	pop hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	call SetNoLineSeparation
	ld l, e
	ld h, d
	ld a, [wPracticeDuelTextY]
	ld e, a
	ld d, 1
	call InitTextPrinting_ProcessTextFromID
	call SetOneLineSeparation
	pop hl
	jr .print_instructions_loop

; print the generic Dr. Mason's text that completes all his practice duel instructions
PrintPracticeDuelLetsPlayTheGame:
	ldtx hl, LetsPlayTheGamePracticeDuelText
	call PrintPracticeDuelDrMasonInstructions
	ret

; simplified version of PrintPracticeDuelInstructions that skips Dr. Mason's text
; and instead places the point-by-point instructions all at once.
PrintPracticeDuelInstructions_Fast:
	ld a, [hli]
	or a
	jr z, PrintPracticeDuelLetsPlayTheGame
	ld e, a ; y
	ld d, 1 ; x
	call PrintPracticeDuelNumberedInstruction
	jr PrintPracticeDuelInstructions_Fast

; print a practice duel point-by-point instruction at d,e, with text id at hl,
; that has been read from an entry of PracticeDuelText_*
PrintPracticeDuelNumberedInstruction:
	inc hl
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	push hl
	ld l, c
	ld h, b
	call SetNoLineSeparation
	call InitTextPrinting_ProcessTextFromID
	call SetOneLineSeparation
	pop hl
	ret

; print a single instruction bullet for the current turn
PrintNextPracticeDuelInstruction:
	ld a, $01
	ldh [hffb0], a
	push hl
	call PrintPracticeDuelInstructionsTextBoxLabel
	ld hl, wPracticeDuelTextPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
.next
	ld a, [wPracticeDuelTextY]
	cp [hl]
	jr c, .done
	ld a, [hli]
	or a
	jr z, .done
	ld e, a ; y
	ld d, 1 ; x
	call PrintPracticeDuelNumberedInstruction
	jr .next
.done
	pop hl
	xor a
	ldh [hffb0], a
	ret

PracticeDuelTurnVerificationPointerTable:
	dw PracticeDuelVerify_Turn1
	dw PracticeDuelVerify_Turn2
	dw PracticeDuelVerify_Turn3
	dw PracticeDuelVerify_Turn4
	dw PracticeDuelVerify_Turn5
	dw PracticeDuelVerify_Turn6
	dw PracticeDuelVerify_Turn7Or8
	dw PracticeDuelVerify_Turn7Or8

PracticeDuelVerify_Turn1:
	ld a, [wTempCardID_ccc2]
	cp GOLDEEN
	jp nz, ReturnWrongAction
	ret

PracticeDuelVerify_Turn2:
	ld a, [wTempCardID_ccc2]
	cp SEAKING
	jp nz, ReturnWrongAction
	ld a, [wSelectedAttack]
	cp SECOND_ATTACK
	jp nz, ReturnWrongAction
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + PSYCHIC]
	or a
	jr z, ReturnWrongAction
	ret

PracticeDuelVerify_Turn3:
	ld a, [wTempCardID_ccc2]
	cp SEAKING
	jr nz, ReturnWrongAction
	ld e, PLAY_AREA_BENCH_1
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + WATER]
	or a
	jr z, ReturnWrongAction
	ret

PracticeDuelVerify_Turn4:
	ld a, [wPlayerNumberOfPokemonInPlayArea]
	cp 3
	jr nz, ReturnWrongAction
	ld e, PLAY_AREA_BENCH_2
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + WATER]
	or a
	jr z, ReturnWrongAction
	ld a, [wTempCardID_ccc2]
	cp SEAKING
	jr nz, ReturnWrongAction
	ld a, [wSelectedAttack]
	cp SECOND_ATTACK
	jr nz, ReturnWrongAction
	ret

PracticeDuelVerify_Turn5:
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + WATER]
	cp 2
	jr nz, ReturnWrongAction
	ld a, [wTempCardID_ccc2]
	cp STARYU
	jr nz, ReturnWrongAction
	ret

PracticeDuelVerify_Turn6:
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + WATER]
	cp 3
	jr nz, ReturnWrongAction
	ld a, [wPlayerArenaCardHP]
	cp 40
	jr nz, ReturnWrongAction
	ld a, [wTempCardID_ccc2]
	cp STARYU
	jr nz, ReturnWrongAction
	ret

PracticeDuelVerify_Turn7Or8:
	ld a, [wTempCardID_ccc2]
	cp STARMIE
	jr nz, ReturnWrongAction
	ld a, [wSelectedAttack]
	cp SECOND_ATTACK
	jr nz, ReturnWrongAction
	ret

ReturnWrongAction:
	scf
	ret

; display BOXMSG_PLAYERS_TURN or BOXMSG_OPPONENTS_TURN and print
; DuelistTurnText in a textbox. also call ExchangeRNG.
DisplayDuelistTurnScreen:
	call EmptyScreen
	ld c, BOXMSG_PLAYERS_TURN
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .got_turn
	inc c ; BOXMSG_OPPONENTS_TURN
.got_turn
	ld a, c
	call DrawDuelBoxMessage
	ldtx hl, DuelistTurnText
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	ret

Unknown_54e2: ; unreferenced
	db $00, $0c, $06, $0f, $00, $00, $00

DuelMenuData:
	; x, y, text id
	textitem 3,  14, HandText
	textitem 9,  14, CheckText
	textitem 15, 14, RetreatText
	textitem 3,  16, AttackText
	textitem 9,  16, PKMNPowerText
	textitem 15, 16, DoneText
	db $ff

; display the screen that prompts the player to choose a Pokemon card to
; place in the arena or in the bench at the beginning of the duel.
; input:
   ; a = 0 -> prompted to place Pokemon card in arena
   ; a = 1 -> prompted to place Pokemon card in bench
; return carry if no card was placed (only allowed for bench)
DisplayPlaceInitialPokemonCardsScreen:
	ld [wPlacingInitialBenchPokemon], a
	push hl
	call CreateHandCardList
	call InitAndDrawCardListScreenLayout
	pop hl
	call SetCardListInfoBoxText
	ld a, PLAY_CHECK
	ld [wCardListItemSelectionMenuType], a
.display_card_list
	call DisplayCardList
	jr nc, .card_selected
	; attempted to exit screen
	ld a, [wPlacingInitialBenchPokemon]
	or a
	; player is forced to place a Pokemon card in the arena
	jr z, .display_card_list
	; in the bench, however, we can get away without placing anything
	; alternatively, the player doesn't want or can't place more bench Pokemon
	scf
	jr .done
.card_selected
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	call IsLoadedCard1BasicPokemon
	jr nc, .done
	; invalid card selected, tell the player and go back
	ldtx hl, YouCannotSelectThisCardText
	call DrawWideTextBox_WaitForInput
	call DrawCardListScreenLayout
	jr .display_card_list
.done
	; valid basic Pokemon card selected, or no card selected (bench only)
	push af
	ld a, [wSortCardListByID]
	or a
	call nz, SortHandCardsByID
	pop af
	ret

Func_5542:
	call CreateDiscardPileCardList
	ret c
	call InitAndDrawCardListScreenLayout
	call SetDiscardPileScreenTexts
	call DisplayCardList
	ret

; draw the turn holder's discard pile screen
OpenDiscardPileScreen:
	call CreateDiscardPileCardList
	jr c, .discard_pile_empty
	call InitAndDrawCardListScreenLayout
	call SetDiscardPileScreenTexts
	ld a, START + A_BUTTON
	ld [wNoItemSelectionMenuKeys], a
	call DisplayCardList
	or a
	ret
.discard_pile_empty
	ldtx hl, TheDiscardPileHasNoCardsText
	call DrawWideTextBox_WaitForInput
	scf
	ret

; set wCardListHeaderText and SetCardListInfoBoxText to the text
; that correspond to the Discard Pile screen
SetDiscardPileScreenTexts:
	ldtx de, YourDiscardPileText
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .got_header_text
	ldtx de, OpponentsDiscardPileText
.got_header_text
	ldtx hl, ChooseTheCardYouWishToExamineText
	call SetCardListHeaderText
	ret

SetCardListHeaderText:
	ld a, e
	ld [wCardListHeaderText], a
	ld a, d
	ld [wCardListHeaderText + 1], a
;	fallthrough

SetCardListInfoBoxText:
	ld a, l
	ld [wCardListInfoBoxText], a
	ld a, h
	ld [wCardListInfoBoxText + 1], a
	ret

InitAndDrawCardListScreenLayout_WithSelectCheckMenu:
	call InitAndDrawCardListScreenLayout
	ld a, SELECT_CHECK
	ld [wCardListItemSelectionMenuType], a
	ret

; draw the layout of the screen that displays the player's Hand card list or a
; Discard Pile card list, including a bottom-right image of the current card.
; since this loads the text for the Hand card list screen, SetDiscardPileScreenTexts
; is called after this if the screen corresponds to a Discard Pile list.
; the dimensions of text box where the card list is printed are 20x13, in order to accommodate
; another text box below it (wCardListInfoBoxText) as well as the image of the selected card.
InitAndDrawCardListScreenLayout:
	xor a
	ld hl, wSelectedDuelSubMenuItem
	ld [hli], a
	ld [hl], a
	ld [wSortCardListByID], a
	ld hl, wPrintSortNumberInCardListPtr
	ld [hli], a
	ld [hl], a
	ld [wCardListItemSelectionMenuType], a
	ld a, START
	ld [wNoItemSelectionMenuKeys], a
	ld hl, wCardListInfoBoxText
	ldtx [hl], PleaseSelectHandText, & $ff
	inc hl
	ldtx [hl], PleaseSelectHandText, >> 8
	inc hl ; wCardListHeaderText
	ldtx [hl], DuelistHandText, & $ff
	inc hl
	ldtx [hl], DuelistHandText, >> 8
; fallthrough

; same as InitAndDrawCardListScreenLayout, except that variables like wSelectedDuelSubMenuItem,
; wNoItemSelectionMenuKeys, wCardListInfoBoxText, wCardListHeaderText, etc already set by caller.
DrawCardListScreenLayout:
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadSymbolsFont
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
	call PrintSortNumberInCardList_CallFromPointer
	ld a, [wDuelTempList]
	cp $ff
	scf
	ret z
	or a
	ret

; displays a list of cards and handles input in order to navigate through the list,
; select a card, open a card page, etc.
; input:
   ; - text IDs at wCardListInfoBoxText and wCardListHeaderText
   ; - $ff-terminated list of cards to display at wDuelTempList
   ; - wSelectedDuelSubMenuItem (initial item) and wSelectedDuelSubMenuScrollOffset
   ;   (initial page scroll offset). Usually both 0 to begin with the first card.
; returns carry if B is pressed to exit the card list screen.
; otherwise returns the selected card at hTempCardIndex_ff98 and at a.
DisplayCardList:
	call DrawNarrowTextBox
	call PrintCardListHeaderAndInfoBoxTexts
.reload_list
	; get the list length
	call CountCardsInDuelTempList
	; get the position and scroll within the list
	ld hl, wSelectedDuelSubMenuItem
	ld e, [hl] ; initial item (in the visible page)
	inc hl
	ld d, [hl] ; initial page scroll offset
	ld hl, CardListParameters ; other list params
	call PrintCardListItems
	call LoadSelectedCardGfx
	call EnableLCD
.wait_button
	call DoFrame
	call .UpdateListOnDPadInput
	call HandleCardListInput
	jr nc, .wait_button
	; refresh the position of the last checked card of the list, so that
	; the cursor points to said card when the list is reloaded
	ld hl, wSelectedDuelSubMenuItem
	ld [hl], e
	inc hl
	ld [hl], d
	ldh a, [hKeysPressed]
	ld b, a
	bit SELECT_F, b
	jr nz, .select_pressed
	bit B_BUTTON_F, b
	jr nz, .b_pressed
	ld a, [wNoItemSelectionMenuKeys]
	and b
	jr nz, .open_card_page
	; display the item selection menu (PLAY|CHECK or SELECT|CHECK) for the selected card
	; open the card page if CHECK is selected
	ldh a, [hCurMenuItem]
	call GetCardInDuelTempList_OnlyDeckIndex
	call CardListItemSelectionMenu
	; jump back if B pressed to exit the item selection menu
	jr c, DisplayCardList
	ldh a, [hTempCardIndex_ff98]
	or a
	ret
.select_pressed
	; sort cards by ID if SELECT is pressed and return to the first item
	ld a, [wSortCardListByID]
	or a
	jr nz, .wait_button
	call SortCardsInDuelTempListByID
	xor a
	ld hl, wSelectedDuelSubMenuItem
	ld [hli], a
	ld [hl], a
	ld a, 1
	ld [wSortCardListByID], a
	call EraseCursor
	jr .reload_list
.open_card_page
	; open the card page directly, without an item selection menu
	; in this mode, D_UP and D_DOWN can be used to open the card page
	; of the card above and below the current card
	ldh a, [hCurMenuItem]
	call GetCardInDuelTempList
	call LoadCardDataToBuffer1_FromDeckIndex
	call OpenCardPage_FromCheckHandOrDiscardPile
	ldh a, [hDPadHeld]
	bit D_UP_F, a
	jr nz, .up_pressed
	bit D_DOWN_F, a
	jr nz, .down_pressed
	; if B pressed, exit card page and reload the card list
	call DrawCardListScreenLayout
	jp DisplayCardList
.up_pressed
	ldh a, [hCurMenuItem]
	or a
	jr z, .open_card_page ; if can't go up, reload card page of current card
	dec a
	jr .move_to_another_card
.down_pressed
	call CountCardsInDuelTempList
	ld b, a
	ldh a, [hCurMenuItem]
	inc a
	cp b
	jr nc, .open_card_page ; if can't go down, reload card page of current card
.move_to_another_card
	; update hCurMenuItem, and wSelectedDuelSubMenuScrollOffset.
	; this means that when navigating up/down through card pages, the page is
	; scrolled to reflect the movement, rather than the cursor going up/down.
	ldh [hCurMenuItem], a
	ld hl, wSelectedDuelSubMenuItem
	ld [hl], $00
	inc hl
	ld [hl], a
	jr .open_card_page
.b_pressed
	ldh a, [hCurMenuItem]
	scf
	ret

.UpdateListOnDPadInput:
	ldh a, [hDPadHeld]
	and D_PAD
	ret z
	ld a, $01
	ldh [hffb0], a
	call PrintCardListHeaderAndInfoBoxTexts
	xor a
	ldh [hffb0], a
	ret

; prints the text ID at wCardListHeaderText at 1,1
; and the text ID at wCardListInfoBoxText at 1,14
PrintCardListHeaderAndInfoBoxTexts:
	lb de, 1, 14
	call AdjustCoordinatesForBGScroll
	call InitTextPrinting
	ld hl, wCardListInfoBoxText
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintTextNoDelay
	ld hl, wCardListHeaderText
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lb de, 1, 1
	call InitTextPrinting
	call PrintTextNoDelay
	ret

; display the SELECT|CHECK or PLAY|CHECK menu when a card of a list is selected
; and handle input. return carry if b is pressed.
; input: wCardListItemSelectionMenuType
CardListItemSelectionMenu:
	ld a, [wCardListItemSelectionMenuType]
	or a
	ret z
	ldtx hl, SelectCheckText
	ld a, [wCardListItemSelectionMenuType]
	cp PLAY_CHECK
	jr nz, .got_text
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	ldtx hl, PlayCheck2Text ; identical to PlayCheck1Text
	ld a, [wLoadedCard1Type]
	cp TYPE_TRAINER
	jr nz, .got_text
	ldtx hl, PlayCheck1Text
.got_text
	call DrawNarrowTextBox_PrintTextNoDelay
	ld hl, ItemSelectionMenuParameters
	xor a
	call InitializeMenuParameters
.wait_a_or_b
	call DoFrame
	call HandleMenuInput
	jr nc, .wait_a_or_b
	cp -1
	jr z, .b_pressed
	; A pressed
	or a
	ret z
	; CHECK option selected: open the card page
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	call OpenCardPage_FromHand
	call DrawCardListScreenLayout
.b_pressed
	scf
	ret

ItemSelectionMenuParameters:
	db 1, 14 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

CardListParameters:
	db 1, 3 ; cursor x, cursor y
	db 4 ; item x
	db 14 ; maximum length, in tiles, occupied by the name and level string of each card in the list
	db 5 ; number of items selectable without scrolling
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw CardListFunction ; function pointer if non-0

; return carry if any of the buttons is pressed, and load the graphics
; of the card pointed to by the cursor whenever a d-pad key is released.
; also return $ff unto hCurMenuItem if B is pressed.
CardListFunction:
	ldh a, [hKeysPressed]
	bit B_BUTTON_F, a
	jr nz, .exit
	and A_BUTTON | SELECT | START
	jr nz, .action_button
	ldh a, [hKeysReleased]
	and D_PAD
	jr nz, .reload_card_image ; jump if the D_PAD key was released this frame
	ret
.exit
	ld a, $ff
	ldh [hCurMenuItem], a
.action_button
	scf
	ret
.reload_card_image
	call LoadSelectedCardGfx
	or a
	ret

PrintSortNumberInCardList_SetPointer:
	ld hl, wPrintSortNumberInCardListPtr
	ld de, PrintSortNumberInCardList
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, 1
	ld [wSortCardListByID], a
	ret

PrintSortNumberInCardList_CallFromPointer:
	ld hl, wPrintSortNumberInCardListPtr
	jp CallIndirect

; goes through list in wDuelTempList + 10
; and prints the number stored in each entry
; beside the corresponding card in screen.
; used in lists for reordering cards in the Deck.
PrintSortNumberInCardList:
	lb bc, 1, 2
	ld hl, wDuelTempList + 10
.next
	ld a, [hli]
	cp $ff
	jr z, .done
	or a ; SYM_SPACE
	jr z, .space
	add SYM_0 ; load number symbol
.space
	call WriteByteToBGMap0
	; move two lines down
	inc c
	inc c
	jr .next
.done
	ret

; draw the card page of the card at wLoadedCard1 and listen for input
; in order to switch the page or to exit.
; triggered by checking a hand card or a discard pile card in the Check menu.
; D_UP and D_DOWN exit the card page allowing the caller to load the card page
; of the card above or below in the list.
OpenCardPage_FromCheckHandOrDiscardPile:
	ld a, B_BUTTON | D_UP | D_DOWN
	ld [wCardPageExitKeys], a
	xor a ; CARDPAGETYPE_NOT_PLAY_AREA
	jr OpenCardPage

; draw the card page of the card at wLoadedCard1 and listen for input
; in order to switch the page or to exit.
; triggered by checking an arena card or a bench card in the Check menu.
OpenCardPage_FromCheckPlayArea:
	ld a, B_BUTTON
	ld [wCardPageExitKeys], a
	ld a, CARDPAGETYPE_PLAY_AREA
	jr OpenCardPage

; draw the card page of the card at wLoadedCard1 and listen for input
; in order to switch the page or to exit.
; triggered by checking a card in the Hand menu.
OpenCardPage_FromHand:
	ld a, B_BUTTON
	ld [wCardPageExitKeys], a
	xor a ; CARDPAGETYPE_NOT_PLAY_AREA
;	fallthrough

; draw the card page of the card at wLoadedCard1 and listen for input
; in order to switch the page or to exit.
OpenCardPage:
	ld [wCardPageType], a
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call FinishQueuedAnimations
	; load the graphics and display the card image of wLoadedCard1
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
	; display the initial card page for the card at wLoadedCard1
	xor a
	ld [wCardPageNumber], a
.load_next
	call DisplayFirstOrNextCardPage
	jr c, .done ; done if trying to advance past the last page with START or A_BUTTON
	call EnableLCD
.input_loop
	call DoFrame
	ldh a, [hDPadHeld]
	ld b, a
	ld a, [wCardPageExitKeys]
	and b
	jr nz, .done
	; START and A_BUTTON advance to the next valid card page, but close it
	; after trying to advance from the last page
	ldh a, [hKeysPressed]
	and START | A_BUTTON
	jr nz, .load_next
	; D_RIGHT and D_LEFT advance to the next and previous valid card page respectively.
	; however, unlike START and A_BUTTON, D_RIGHT past the last page goes back to the start.
	ldh a, [hKeysPressed]
	and D_RIGHT | D_LEFT
	jr z, .input_loop
	call DisplayCardPageOnLeftOrRightPressed
	jr .input_loop
.done
	ret

; display the previous valid card page of the card at wLoadedCard1 if bit D_LEFT_F
; of a is set, and the first or next valid card page otherwise.
; DisplayFirstOrNextCardPage and DisplayPreviousCardPage only call DisplayCardPage
; when GoToFirstOrNextCardPage and GoToPreviousCardPage respectively return nc
; so the "call c, DisplayCardPage" instructions makes sure the card page switched
; to is always displayed.
DisplayCardPageOnLeftOrRightPressed:
	bit D_LEFT_F, a
	jr nz, .left
;.right
	call DisplayFirstOrNextCardPage
	call c, DisplayCardPage
	ret
.left
	call DisplayPreviousCardPage
	call c, DisplayCardPage
	ret

; draws text box that covers the whole screen
; and prints the text ID in hl, then
; waits for Player input.
DrawWholeScreenTextBox:
	push hl
	call EmptyScreen
	lb de, 0, 0
	lb bc, 20, 18
	call DrawRegularTextBox
	ld a, 19
	lb de, 1, 1
	call InitTextPrintingInTextbox
	call SetNoLineSeparation
	pop hl
	call ProcessTextFromID
	call EnableLCD
	call SetOneLineSeparation
	call WaitForWideTextBoxInput
	ret

; has turn duelist take amount of prizes that are in wNumberPrizeCardsToTake
; returns carry if all prize cards were taken
TurnDuelistTakePrizes:
	call FinishQueuedAnimations
	ld a, [wNumberPrizeCardsToTake]
	ld l, a
	ld h, $00
	call LoadTxRam3
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr nz, .opponent

; player
	ldtx hl, WillDrawNPrizesText
	call DrawWideTextBox_WaitForInput
	ld a, [wNumberPrizeCardsToTake]
	call SelectPrizeCards
	ld hl, hTemp_ffa0
	ld d, [hl]
	inc hl
	ld e, [hl]
	call SerialSend8Bytes

.return_has_prizes
	call ExchangeRNG
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	or a
	ret nz
	scf
	ret

.opponent
	call .Func_588a
	ldtx hl, WillDrawNPrizesText
	call DrawWideTextBox_PrintText
	call CountPrizes
	ld [wTempNumRemainingPrizeCards], a
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_LINK_OPP
	jr z, .link_opponent
	call AIDoAction_TakePrize
	ld c, 60
.delay_loop
	call DoFrame
	dec c
	jr nz, .delay_loop
	jr .asm_586f

.link_opponent
	call SerialRecv8Bytes
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	ld [hl], d
	ld a, e
	cp $ff
	call nz, AddCardToHand

.asm_586f
	ld a, [wTempNumRemainingPrizeCards]
	ld hl, wNumberPrizeCardsToTake
	cp [hl]
	jr nc, .asm_587e
	ld l, a
	ld h, $00
	call LoadTxRam3
.asm_587e
	farcall Func_82b6
	ldtx hl, DrewNPrizesText
	call DrawWideTextBox_WaitForInput
	jr .return_has_prizes

.Func_588a:
	ld l, PLAYER_TURN
	ldh a, [hWhoseTurn]
	ld h, a
	jp DrawYourOrOppPlayAreaScreen_Bank0

; display the previous valid card page
DisplayPreviousCardPage:
	call GoToPreviousCardPage
	jr nc, DisplayCardPage
	ret

; display the next valid card page or load the first valid card page if [wCardPageNumber] == 0
DisplayFirstOrNextCardPage:
	call GoToFirstOrNextCardPage
	ret c
;	fallthrough

; display the card page with id at wCardPageNumber of wLoadedCard1
DisplayCardPage:
	ld a, [wCardPageNumber]
	ld hl, CardPageDisplayPointerTable
	call JumpToFunctionInTable
	call EnableLCD
	or a
	ret

; load the tiles and palette of the card selected in card list screen
LoadSelectedCardGfx:
	ldh a, [hCurMenuItem]
	call GetCardInDuelTempList
	call LoadCardDataToBuffer1_FromCardID
	ld de, v0Tiles1 + $20 tiles
	call LoadLoaded1CardGfx
	ld de, $c0c ; useless
	call SetBGP6OrSGB3ToCardPalette
	call FlushAllPalettesOrSendPal23Packet
	ret

CardPageDisplayPointerTable:
	dw DrawDuelMainScene
	dw DisplayCardPage_PokemonOverview    ; CARDPAGE_POKEMON_OVERVIEW
	dw DisplayCardPage_PokemonAttack1Page1  ; CARDPAGE_POKEMON_ATTACK1_1
	dw DisplayCardPage_PokemonAttack1Page2  ; CARDPAGE_POKEMON_ATTACK1_2
	dw DisplayCardPage_PokemonAttack2Page1  ; CARDPAGE_POKEMON_ATTACK2_1
	dw DisplayCardPage_PokemonAttack2Page2  ; CARDPAGE_POKEMON_ATTACK2_2
	dw DisplayCardPage_PokemonDescription ; CARDPAGE_POKEMON_DESCRIPTION
	dw DrawDuelMainScene
	dw DrawDuelMainScene
	dw DisplayCardPage_Energy ; CARDPAGE_ENERGY
	dw DisplayCardPage_Energy ; CARDPAGE_ENERGY + 1
	dw DrawDuelMainScene
	dw DrawDuelMainScene
	dw DisplayCardPage_TrainerPage1 ; CARDPAGE_TRAINER_1
	dw DisplayCardPage_TrainerPage2 ; CARDPAGE_TRAINER_2
	dw DrawDuelMainScene

; given the current card page at [wCardPageNumber], go to the next valid card page or load
; the first valid card page of the current card at wLoadedCard1 if [wCardPageNumber] == 0
GoToFirstOrNextCardPage:
	ld a, [wCardPageNumber]
	or a
	jr nz, .advance_page
	; load the first page for this type of card
	ld a, [wLoadedCard1Type]
	ld b, a
	ld a, CARDPAGE_ENERGY
	bit TYPE_ENERGY_F, b
	jr nz, .set_initial_page
	ld a, CARDPAGE_TRAINER_1
	bit TYPE_TRAINER_F, b
	jr nz, .set_initial_page
	ld a, CARDPAGE_POKEMON_OVERVIEW
.set_initial_page
	ld [wCardPageNumber], a
	or a
	ret
.advance_page
	ld hl, wCardPageNumber
	inc [hl]
	ld a, [hl]
	call SwitchCardPage
	jr c, .set_card_page
	; stay in this page if it exists, or skip to previous page if it doesn't
	or a
	ret nz
	; non-existent page: skip to next
	jr .advance_page
.set_card_page
	ld [wCardPageNumber], a
	ret

; given the current card page at [wCardPageNumber], go to the previous
; valid card page for the current card at wLoadedCard1
GoToPreviousCardPage:
	ld hl, wCardPageNumber
	dec [hl]
	ld a, [hl]
	call SwitchCardPage
	jr c, .set_card_page
	; stay in this page if it exists, or skip to previous page if it doesn't
	or a
	ret nz
	; non-existent page: skip to previous
	jr GoToPreviousCardPage
.set_card_page
	ld [wCardPageNumber], a
.previous_page_loop
	call SwitchCardPage
	or a
	jr nz, .stay
	ld hl, wCardPageNumber
	dec [hl]
	jr .previous_page_loop
.stay
	scf
	ret

; check if the card page trying to switch to is valid for the card at wLoadedCard1
; return with the equivalent to one of these three actions:
   ; stay in card page trying to switch to (nc, nz)
   ; change to card page returned in a if D_LEFT/D_RIGHT pressed, or exit if A_BUTTON/START pressed (c)
   ; non-existent page, so skip to next/previous (nc, z)
SwitchCardPage:
	ld hl, CardPageSwitchPointerTable
	jp JumpToFunctionInTable

CardPageSwitchPointerTable:
	dw CardPageSwitch_00
	dw CardPageSwitch_PokemonOverviewOrDescription ; CARDPAGE_POKEMON_OVERVIEW
	dw CardPageSwitch_PokemonAttack1Page1 ; CARDPAGE_POKEMON_ATTACK1_1
	dw CardPageSwitch_PokemonAttack1Page2 ; CARDPAGE_POKEMON_ATTACK1_2
	dw CardPageSwitch_PokemonAttack2Page1 ; CARDPAGE_POKEMON_ATTACK2_1
	dw CardPageSwitch_PokemonAttack2Page2 ; CARDPAGE_POKEMON_ATTACK2_2
	dw CardPageSwitch_PokemonOverviewOrDescription ; CARDPAGE_POKEMON_DESCRIPTION
	dw CardPageSwitch_PokemonEnd
	dw CardPageSwitch_08
	dw CardPageSwitch_EnergyOrTrainerPage1 ; CARDPAGE_ENERGY
	dw CardPageSwitch_TrainerPage2 ; CARDPAGE_ENERGY + 1
	dw CardPageSwitch_EnergyEnd
	dw CardPageSwitch_0c
	dw CardPageSwitch_EnergyOrTrainerPage1 ; CARDPAGE_TRAINER_1
	dw CardPageSwitch_TrainerPage2 ; CARDPAGE_TRAINER_2
	dw CardPageSwitch_TrainerEnd

; return with CARDPAGE_POKEMON_DESCRIPTION
CardPageSwitch_00:
	ld a, CARDPAGE_POKEMON_DESCRIPTION
	scf
	ret

; return with current page
CardPageSwitch_PokemonOverviewOrDescription:
	ld a, $1
	or a
	ret ; nz

; return with current page if [wLoadedCard1Atk1Name] non-0
; (if card has at least one attack)
CardPageSwitch_PokemonAttack1Page1:
	ld hl, wLoadedCard1Atk1Name
	jr CheckCardPageExists

; return with current page if [wLoadedCard1Atk1Description + 2] non-0
; (if card's first attack has a two-page description)
CardPageSwitch_PokemonAttack1Page2:
	ld hl, wLoadedCard1Atk1Description + 2
	jr CheckCardPageExists

; return with current page if [wLoadedCard1Atk2Name] non-0
; (if card has two attacks)
CardPageSwitch_PokemonAttack2Page1:
	ld hl, wLoadedCard1Atk2Name
	jr CheckCardPageExists

; return with current page if [wLoadedCard1Atk1Description + 2] non-0
; (if card's second attack has a two-page description)
CardPageSwitch_PokemonAttack2Page2:
	ld hl, wLoadedCard1Atk2Description + 2
;	fallthrough

CheckCardPageExists:
	ld a, [hli]
	or [hl]
	ret

; return with CARDPAGE_POKEMON_OVERVIEW
CardPageSwitch_PokemonEnd:
	ld a, CARDPAGE_POKEMON_OVERVIEW
	scf
	ret

; return with CARDPAGE_ENERGY + 1
CardPageSwitch_08:
	ld a, CARDPAGE_ENERGY + 1
	scf
	ret

; return with current page
CardPageSwitch_EnergyOrTrainerPage1:
	ld a, $1
	or a
	ret ; nz

; return with current page if [wLoadedCard1NonPokemonDescription + 2] non-0
; (if this trainer card has a two-page description)
CardPageSwitch_TrainerPage2:
	ld hl, wLoadedCard1NonPokemonDescription + 2
	jr CheckCardPageExists

; return with CARDPAGE_ENERGY
CardPageSwitch_EnergyEnd:
	ld a, CARDPAGE_ENERGY
	scf
	ret

; return with CARDPAGE_TRAINER_2
CardPageSwitch_0c:
	ld a, CARDPAGE_TRAINER_2
	scf
	ret

; return with CARDPAGE_TRAINER_1
CardPageSwitch_TrainerEnd:
	ld a, CARDPAGE_TRAINER_1
	scf
	ret

ZeroObjectPositionsAndToggleOAMCopy:
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret

; place OAM for a 8x6 image, using object size 8x16 and obj palette 1.
; d, e: X Position and Y Position of the top-left corner.
; starting tile number is $a0 (v0Tiles1 + $20 tiles).
; used to draw the image of a card in the check card screens.
PlaceCardImageOAM:
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

; given the deck index of a card in the play area (i.e. -1 indicates empty)
; load the graphics (tiles and palette) of the card to de
LoadPlayAreaCardGfx:
	cp -1
	ret z
	push de
	call LoadCardDataToBuffer1_FromDeckIndex
	pop de
;	fallthrough

; load the graphics (tiles and palette) of the card loaded in wLoadedCard1 to de
LoadLoaded1CardGfx:
	ld hl, wLoadedCard1Gfx
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lb bc, $30, TILE_SIZE
	call LoadCardGfx
	ret

SetBGP7OrSGB2ToCardPalette:
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

SetBGP6OrSGB3ToCardPalette:
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, SetSGB3ToCardPalette
	ld a, $06 ; CGB BG Palette 6
	call CopyCGBCardPalette
	ret

SetSGB3ToCardPalette:
	ld hl, wCardPalette + 2
	ld de, wTempSGBPacket + 9 ; Pal Packet color #4 (PAL23's SGB3)
	ld b, 6
	jr SetBGP7OrSGB2ToCardPalette.copy_pal_loop

SetOBP1OrSGB3ToCardPalette:
	ld a, %11100100
	ld [wOBP0], a
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, SetSGB3ToCardPalette
	ld a, $09 ; CGB Object Palette 1
;	fallthrough

CopyCGBCardPalette:
	add a
	add a
	add a ; a *= CGB_PAL_SIZE
	ld e, a
	ld d, $00
	ld hl, wBackgroundPalettesCGB ; wObjectPalettesCGB - 8 palettes
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

FlushAllPalettesOrSendPal23Packet:
	ld a, [wConsole]
	or a ; CONSOLE_DMG
	ret z
	cp CONSOLE_SGB
	jr z, .sgb
	call FlushAllPalettes
	ret
.sgb
; sgb PAL23, 1 ; sgb_command, length
; rgb 28, 28, 24
; colors 1-7 carried over
	ld a, PAL23 << 3 + 1
	ld hl, wTempSGBPacket
	ld [hli], a
	ld a, LOW(24 << 10 | 28 << 5 | 28)
	ld [hli], a
	ld a, HIGH(24 << 10 | 28 << 5 | 28)
	ld [hld], a
	dec hl
	xor a
	ld [wTempSGBPacket + $f], a
	call SendSGB
	ret

ApplyBGP6OrSGB3ToCardImage:
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

SendCardAttrBlkPacket:
	call CreateCardAttrBlkPacket
	call SendSGB
	ret

ApplyBGP7OrSGB2ToCardImage:
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

Func_5a81:
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

CreateCardAttrBlkPacket:
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

CreateCardAttrBlkPacket_DataSet:
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

; given the 8x6 card image with coordinates at de, fill its BGMap attributes with a
ApplyCardCGBAttributes:
	call BankswitchVRAM1
	lb hl, 0, 0
	lb bc, 8, 6
	call FillRectangle
	call BankswitchVRAM0
	ret

; set the default game palettes for all three systems
; BGP and OBP0 on DMG
; SGB0 and SGB1 on SGB
; BGP0 to BGP5 and OBP1 on CGB
SetDefaultConsolePalettes:
	ld a, [wConsole]
	cp CONSOLE_SGB
	jr z, .sgb
	cp CONSOLE_CGB
	jr z, .cgb
	ld a, %11100100
	ld [wOBP0], a
	ld [wBGP], a
	ld a, $01 ; equivalent to FLUSH_ONE_PAL
	ld [wFlushPaletteFlags], a
	ret
.cgb
	ld a, $04
	ld [wTextBoxFrameType], a
	ld de, CGBDefaultPalettes
	ld hl, wBackgroundPalettesCGB
	ld c, 5 palettes
	call .copy_de_to_hl
	ld de, CGBDefaultPalettes
	ld hl, wObjectPalettesCGB
	ld c, CGB_PAL_SIZE
	call .copy_de_to_hl
	call FlushAllPalettes
	ret
.sgb
	ld a, $04
	ld [wTextBoxFrameType], a
	ld a, PAL01 << 3 + 1
	ld hl, wTempSGBPacket
	push hl
	ld [hli], a
	ld de, Pal01Packet_Default
	ld c, $0e
	call .copy_de_to_hl
	ld [hl], c
	pop hl
	call SendSGB
	ret

.copy_de_to_hl
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copy_de_to_hl
	ret

CGBDefaultPalettes:
; BGP0 and OBP0
	rgb 28, 28, 24
	rgb 21, 21, 16
	rgb 10, 10, 8
	rgb 0, 0, 0
; BGP1
	rgb 28, 28, 24
	rgb 30, 29, 0
	rgb 30, 3, 0
	rgb 0, 0, 0
; BGP2
	rgb 28, 28, 24
	rgb 0, 18, 0
	rgb 12, 11, 20
	rgb 0, 0, 0
; BGP3
	rgb 28, 28, 24
	rgb 22, 0, 22
	rgb 27, 7, 3
	rgb 0, 0, 0
; BGP4
	rgb 28, 28, 24
	rgb 26, 10, 0
	rgb 28, 0, 0
	rgb 0, 0, 0

; first and last byte of the packet not contained here (see SetDefaultConsolePalettes.sgb)
Pal01Packet_Default:
; SGB0
	rgb 28, 28, 24
	rgb 21, 21, 16
	rgb 10, 10, 8
	rgb 0, 0, 0
; SGB1
	rgb 26, 10, 0
	rgb 28, 0, 0
	rgb 0, 0, 0

JPWriteByteToBGMap0:
	jp WriteByteToBGMap0

DisplayCardPage_PokemonOverview:
	ld a, [wCardPageType]
	or a ; CARDPAGETYPE_NOT_PLAY_AREA
	jr nz, .play_area_card_page

; CARDPAGETYPE_NOT_PLAY_AREA
	; print surrounding box, card name at 5,1, type, set 2, and rarity
	call PrintPokemonCardPageGenericInformation
	; print fixed text and draw the card symbol associated to its TYPE_*
	ld hl, CardPageRetreatWRTextData
	call PlaceTextItems
	ld hl, CardPageLvHPNoTextTileData
	call WriteDataBlocksToBGMap0
	lb de, 3, 2
	call DrawCardSymbol
	; print pre-evolution's name (if any)
	ld a, [wLoadedCard1Stage]
	or a
	jr z, .basic
	ld hl, wLoadedCard1PreEvoName
	lb de, 1, 3
	call InitTextPrinting_ProcessTextFromPointerToID
.basic
	; print card level and maximum HP
	lb bc, 12, 2
	ld a, [wLoadedCard1Level]
	call WriteTwoDigitNumberInTxSymbolFormat
	lb bc, 16, 2
	ld a, [wLoadedCard1HP]
	call WriteTwoByteNumberInTxSymbolFormat
	jr .print_numbers_and_energies

; CARDPAGETYPE_PLAY_AREA
.play_area_card_page
	; draw the surrounding box, and print fixed text
	call DrawCardPageSurroundingBox
	call LoadDuelCheckPokemonScreenTiles
	ld hl, CardPageRetreatWRTextData
	call PlaceTextItems
	ld hl, CardPageNoTextTileData
	call WriteDataBlocksToBGMap0
	ld a, 1
	ld [wCurPlayAreaY], a
	; print set 2 icon and rarity symbol at fixed positions
	call DrawCardPageSet2AndRarityIcons
	; print (Y coord at [wCurPlayAreaY]) card name, level, type, energies, HP, location...
	call PrintPlayAreaCardInformationAndLocation

; common for both card page types
.print_numbers_and_energies
	; print Pokedex number in the bottom right corner (16,16)
	lb bc, 16, 16
	ld a, [wLoadedCard1PokedexNumber]
	call WriteTwoByteNumberInTxSymbolFormat
	; print the name, damage, and energy cost of each attack and/or Pokemon power that exists
	; first attack at 5,10 and second at 5,12
	lb bc, 5, 10

.attacks
	ld e, c
	ld hl, wLoadedCard1Atk1Name
	call PrintAttackOrPkmnPowerInformation
	inc c
	inc c ; 12
	ld e, c
	ld hl, wLoadedCard1Atk2Name
	call PrintAttackOrPkmnPowerInformation
	; print the retreat cost (some amount of colorless energies) at 8,14
	inc c
	inc c ; 14
	ld b, 8
	ld a, [wLoadedCard1RetreatCost]
	ld e, a
	inc e
.retreat_cost_loop
	dec e
	jr z, .retreat_cost_done
	ld a, SYM_COLORLESS
	call JPWriteByteToBGMap0
	inc b
	jr .retreat_cost_loop
.retreat_cost_done
	; print the colors (energies) of the weakness(es) and resistance(s)
	inc c ; 15
	ld a, [wCardPageType]
	or a
	jr z, .wr_from_loaded_card
	ld a, [wCurPlayAreaSlot]
	or a
	jr nz, .wr_from_loaded_card
	call GetArenaCardWeakness
	ld d, a
	call GetArenaCardResistance
	ld e, a
	jr .got_wr
.wr_from_loaded_card
	ld a, [wLoadedCard1Weakness]
	ld d, a
	ld a, [wLoadedCard1Resistance]
	ld e, a
.got_wr
	ld a, d
	ld b, 8
	call PrintCardPageWeaknessesOrResistances
	inc c ; 16
	ld a, e
	call PrintCardPageWeaknessesOrResistances
	ret

; displays the name, damage, and energy cost of an attack or Pokemon power.
; used in the Attack menu and in the card page of a Pokemon.
; input:
   ; hl: pointer to attack 1 name in a atk_data_struct (which can be inside at card_data_struct)
   ; e: Y coordinate to start printing the data at
PrintAttackOrPkmnPowerInformation:
	ld a, [hli]
	or [hl]
	ret z
	push bc
	push hl
	dec hl
	; print text ID pointed to by hl at 7,e
	ld d, 7
	call InitTextPrinting_ProcessTextFromPointerToID
	pop hl
	inc hl
	inc hl
	ld a, [wCardPageNumber]
	or a
	jr nz, .print_damage
	dec hl
	ld a, [hli]
	or [hl]
	jr z, .print_damage
	; if in Attack menu and attack 1 description exists, print at 18,e:
	ld b, 18
	ld c, e
	ld a, SYM_ATK_DESCR
	call WriteByteToBGMap0
.print_damage
	inc hl
	inc hl
	inc hl
	push hl
	ld a, [hl]
	or a
	jr z, .print_category
	; print attack damage at 15,(e+1) if non-0
	ld b, 15 ; unless damage has three digits, this is effectively 16
	ld c, e
	inc c
	call WriteTwoByteNumberInTxSymbolFormat
.print_category
	pop hl
	inc hl
	ld a, [hl]
	and $ff ^ RESIDUAL
	jr z, .print_energy_cost
	cp POKEMON_POWER
	jr z, .print_pokemon_power
	; register a is DAMAGE_PLUS, DAMAGE_MINUS, or DAMAGE_X
	; print the damage modifier (+, -, x) at 18,(e+1) (after the damage value)
	add SYM_PLUS - DAMAGE_PLUS
	ld b, 18
	ld c, e
	inc c
	call WriteByteToBGMap0
	jr .print_energy_cost
.print_energy_cost
	ld bc, CARD_DATA_ATTACK1_ENERGY_COST - CARD_DATA_ATTACK1_CATEGORY
	add hl, bc
	ld c, e
	ld b, 2 ; bc = 2, e
	lb de, NUM_TYPES / 2, 0
.energy_loop
	ld a, [hl]
	swap a
	call PrintEnergiesOfColor
	ld a, [hli]
	call PrintEnergiesOfColor
	dec d
	jr nz, .energy_loop
	pop bc
	ret
.print_pokemon_power
	; print "PKMN PWR" at 2,e
	ld d, 2
	ldtx hl, PKMNPWRText
	call InitTextPrinting_ProcessTextFromID
	pop bc
	ret

; print the number of energies required of color (type) e, and return e ++ (next color).
; the requirement of the current color is provided as input in the lower nybble of a.
PrintEnergiesOfColor:
	inc e
	and $0f
	ret z
	push de
	ld d, a
.print_energies_loop
	ld a, e
	call JPWriteByteToBGMap0
	inc b
	dec d
	jr nz, .print_energies_loop
	pop de
	ret

; print the weaknesses or resistances of a Pokemon card, given in a, at b,c
PrintCardPageWeaknessesOrResistances:
	push bc
	push de
	ld d, a
	xor a ; FIRE
.loop
	; each WR_* constant is a different bit. rotate the value to find out
	; which bits are set and therefore which WR_* values are active.
	; a is kept updated with the equivalent TYPE_* constant.
	inc a
	cp 8
	jr nc, .done
	rl d
	jr nc, .loop
	push af
	call JPWriteByteToBGMap0
	inc b
	pop af
	jr .loop
.done
	pop de
	pop bc
	ret

; prints surrounding box, card name at 5,1, type, set 2, and rarity.
; used in all CARDPAGE_POKEMON_* and ATTACKPAGE_*, except in
; CARDPAGE_POKEMON_OVERVIEW when wCardPageType is CARDPAGETYPE_PLAY_AREA.
PrintPokemonCardPageGenericInformation:
	call DrawCardPageSurroundingBox
	lb de, 5, 1
	ld hl, wLoadedCard1Name
	call InitTextPrinting_ProcessTextFromPointerToID
	ld a, [wCardPageType]
	or a
	jr z, .from_loaded_card
	ld a, [wCurPlayAreaSlot]
	call GetPlayAreaCardColor
	jr .got_color
.from_loaded_card
	ld a, [wLoadedCard1Type]
.got_color
	lb bc, 18, 1
	inc a
	call JPWriteByteToBGMap0
	call DrawCardPageSet2AndRarityIcons
	ret

; draws the 20x18 surrounding box and also colorizes the card image
DrawCardPageSurroundingBox:
	ld hl, wTextBoxFrameType
	set 7, [hl] ; colorize textbox border also on SGB (with SGB1)
	push hl
	lb de, 0, 0
	lb bc, 20, 18
	call DrawRegularTextBox
	pop hl
	res 7, [hl]
	lb de, 6, 4
	call ApplyBGP6OrSGB3ToCardImage
	ret

CardPageRetreatWRTextData:
	textitem 1, 14, RetreatCostText
	textitem 1, 15, WeaknessText
	textitem 1, 16, ResistanceText
	db $ff

CardPageLvHPNoTextTileData:
	db 11,  2, SYM_Lv, 0
	db 15,  2, SYM_HP, 0
;	continues to CardPageNoTextTileData

CardPageNoTextTileData:
	db 15, 16, SYM_No, 0
	db $ff

DisplayCardPage_PokemonAttack1Page1:
	ld hl, wLoadedCard1Atk1Name
	ld de, wLoadedCard1Atk1Description
	jr DisplayPokemonAttackCardPage

DisplayCardPage_PokemonAttack1Page2:
	ld hl, wLoadedCard1Atk1Name
	ld de, wLoadedCard1Atk1Description + 2
	jr DisplayPokemonAttackCardPage

DisplayCardPage_PokemonAttack2Page1:
	ld hl, wLoadedCard1Atk2Name
	ld de, wLoadedCard1Atk2Description
	jr DisplayPokemonAttackCardPage

DisplayCardPage_PokemonAttack2Page2:
	ld hl, wLoadedCard1Atk2Name
	ld de, wLoadedCard1Atk2Description + 2
;	fallthrough

; input:
   ; hl = address of the attack's name (text id)
   ; de = address of the attack's description (either first or second text id)
DisplayPokemonAttackCardPage:
	push de
	push hl
	; print surrounding box, card name at 5,1, type, set 2, and rarity
	call PrintPokemonCardPageGenericInformation
	; print name, damage, and energy cost of attack or Pokemon power starting at line 2
	ld e, 2
	pop hl
	call PrintAttackOrPkmnPowerInformation
	pop hl
;	fallthrough

; print, if non-null, the description of the trainer card, energy card, attack,
; or Pokemon power, given as a pointer to text id in hl, starting from 1,11
PrintAttackOrNonPokemonCardDescription:
	ld a, [hli]
	or [hl]
	ret z
	dec hl
	lb de, 1, 11
	call PrintAttackOrCardDescription
	ret

DisplayCardPage_PokemonDescription:
	; print surrounding box, card name at 5,1, type, set 2, and rarity
	call PrintPokemonCardPageGenericInformation
	call LoadDuelCardSymbolTiles2
	; print "LENGTH", "WEIGHT", "Lv", and "HP" where it corresponds in the page
	ld hl, CardPageLengthWeightTextData
	call PlaceTextItems
	ld hl, CardPageLvHPTextTileData
	call WriteDataBlocksToBGMap0
	; draw the card symbol associated to its TYPE_* at 3,2
	lb de, 3, 2
	call DrawCardSymbol
	; print the Level and HP numbers at 12,2 and 16,2 respectively
	lb bc, 12, 2
	ld a, [wLoadedCard1Level]
	call WriteTwoDigitNumberInTxSymbolFormat
	lb bc, 16, 2
	ld a, [wLoadedCard1HP]
	call WriteTwoByteNumberInTxSymbolFormat
	; print the Pokemon's category at 1,10 (just above the length and weight texts)
	lb de, 1, 10
	ld hl, wLoadedCard1Category
	call InitTextPrinting_ProcessTextFromPointerToID
	ld a, TX_KATAKANA
	call ProcessSpecialTextCharacter
	ldtx hl, PokemonText
	call ProcessTextFromID
	; print the length and weight values at 5,11 and 5,12 respectively
	lb bc, 5, 11
	ld hl, wLoadedCard1Length
	ld a, [hli]
	ld l, [hl]
	ld h, a
	call PrintPokemonCardLength
	lb bc, 5, 12
	ld hl, wLoadedCard1Weight
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintPokemonCardWeight
	ldtx hl, LbsText
	call InitTextPrinting_ProcessTextFromID
	; print the card's description without line separation
	call SetNoLineSeparation
	ld hl, wLoadedCard1Description
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CountLinesOfTextFromID
	lb de, 1, 13
	cp 4
	jr nc, .print_description
	inc e ; move a line down, as the description is short enough to fit in three lines
.print_description
	ld a, 19 ; line length
	call InitTextPrintingInTextbox
	ld hl, wLoadedCard1Description
	call ProcessTextFromPointerToID
	call SetOneLineSeparation
	ret

; given a card rarity constant in a, and CardRarityTextIDs in hl,
; print the text character associated to it at d,e
PrintCardPageRarityIcon:
	inc a
	add a
	ld c, a
	ld b, $00
	add hl, bc
	call InitTextPrinting_ProcessTextFromPointerToID
	ret

; prints the card's set 2 icon and the full width text character of the card's rarity
DrawCardPageSet2AndRarityIcons:
	ld a, [wLoadedCard1Set]
	call LoadCardSet2Tiles
	jr c, .icon_done
	; draw the 2x2 set 2 icon of this card
	ld a, $fc
	lb hl, 1, 2
	lb bc, 2, 2
	lb de, 15, 8
	call FillRectangle
.icon_done
	lb de, 18, 9
	ld hl, CardRarityTextIDs
	ld a, [wLoadedCard1Rarity]
	cp PROMOSTAR
	call nz, PrintCardPageRarityIcon
	ret

CardPageLengthWeightTextData:
	textitem 1, 11, LengthText
	textitem 1, 12, WeightText
	db $ff

CardPageLvHPTextTileData:
	db 11, 2, SYM_Lv, 0
	db 15, 2, SYM_HP, 0
	db $ff

CardRarityTextIDs:
	tx PromostarRarityText ; PROMOSTAR (unused)
	tx CircleRarityText    ; CIRCLE
	tx DiamondRarityText   ; DIAMOND
	tx StarRarityText      ; STAR

DisplayCardPage_TrainerPage1:
	xor a ; HEADER_TRAINER
	ld hl, wLoadedCard1NonPokemonDescription
	jr DisplayEnergyOrTrainerCardPage

DisplayCardPage_TrainerPage2:
	xor a ; HEADER_TRAINER
	ld hl, wLoadedCard1NonPokemonDescription + 2
	jr DisplayEnergyOrTrainerCardPage

DisplayCardPage_Energy:
	ld a, HEADER_ENERGY
	ld hl, wLoadedCard1NonPokemonDescription
;	fallthrough

; input:
   ; a = HEADER_ENERGY or HEADER_TRAINER
   ; hl = address of the card's description (text id)
DisplayEnergyOrTrainerCardPage:
	push hl
	call LoadCardTypeHeaderTiles
	; draw surrounding box
	lb de, 0, 0
	lb bc, 20, 18
	call DrawRegularTextBox
	; print the card's name at 4,3
	lb de, 4, 3
	ld hl, wLoadedCard1Name
	call InitTextPrinting_ProcessTextFromPointerToID
	; colorize the card image
	lb de, 6, 4
	call ApplyBGP6OrSGB3ToCardImage
	; display the card type header
	ld a, $e0
	lb hl, 1, 8
	lb de, 6, 1
	lb bc, 8, 2
	call FillRectangle
	; print the set 2 icon and rarity symbol of the card
	call DrawCardPageSet2AndRarityIcons
	pop hl
	call PrintAttackOrNonPokemonCardDescription
	ret

; display the card details of the card in wLoadedCard1
; print the text at hl
_DisplayCardDetailScreen:
	push hl
	call DrawLargePictureOfCard
	ld a, 18
	call CopyCardNameAndLevel
	ld [hl], TX_END
	ld hl, 0
	call LoadTxRam2
	pop hl
	call DrawWideTextBox_WaitForInput
	ret

; draw a large picture of the card loaded in wLoadedCard1, including its image
; and a header indicating the type of card (TRAINER, ENERGY, PoKéMoN)
DrawLargePictureOfCard:
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadSymbolsFont
	call SetDefaultConsolePalettes
	ld a, LARGE_CARD_PICTURE
	ld [wDuelDisplayedScreen], a
	call LoadCardOrDuelMenuBorderTiles
	ld e, HEADER_TRAINER
	ld a, [wLoadedCard1Type]
	cp TYPE_TRAINER
	jr z, .draw
	ld e, HEADER_ENERGY
	and TYPE_ENERGY
	jr nz, .draw
	ld e, HEADER_POKEMON
.draw
	ld a, e
	call LoadCardTypeHeaderTiles
	ld de, v0Tiles1 + $20 tiles
	call LoadLoaded1CardGfx
	call SetBGP6OrSGB3ToCardPalette
	call FlushAllPalettesOrSendPal23Packet
	ld hl, LargeCardTileData
	call WriteDataBlocksToBGMap0
	lb de, 6, 3
	call ApplyBGP6OrSGB3ToCardImage
	ret

LargeCardTileData:
	db  5,  0, $d0, $d4, $d4, $d4, $d4, $d4, $d4, $d4, $d4, $d1, 0 ; top border
	db  5,  1, $d6, $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $d7, 0 ; header top
	db  5,  2, $d6, $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef, $d7, 0 ; header bottom
	db  5,  3, $d6, $a0, $a6, $ac, $b2, $b8, $be, $c4, $ca, $d7, 0 ; image
	db  5,  4, $d6, $a1, $a7, $ad, $b3, $b9, $bf, $c5, $cb, $d7, 0 ; image
	db  5,  5, $d6, $a2, $a8, $ae, $b4, $ba, $c0, $c6, $cc, $d7, 0 ; image
	db  5,  6, $d6, $a3, $a9, $af, $b5, $bb, $c1, $c7, $cd, $d7, 0 ; image
	db  5,  7, $d6, $a4, $aa, $b0, $b6, $bc, $c2, $c8, $ce, $d7, 0 ; image
	db  5,  8, $d6, $a5, $ab, $b1, $b7, $bd, $c3, $c9, $cf, $d7, 0 ; image
	db  5,  9, $d6, 0                                              ; empty line 1 (left)
	db 14,  9, $d7, 0                                              ; empty line 1 (right)
	db  5, 10, $d6, 0                                              ; empty line 2 (left)
	db 14, 10, $d7, 0                                              ; empty line 2 (right)
	db  5, 11, $d2, $d5, $d5, $d5, $d5, $d5, $d5, $d5, $d5, $d3, 0 ; bottom border
	db $ff

; print lines of text with no separation between them
SetNoLineSeparation:
	ld a, SINGLE_SPACED
;	fallthrough

SetLineSeparation:
	ld [wLineSeparation], a
	ret

; separate lines of text by an empty line
SetOneLineSeparation:
	xor a ; DOUBLE_SPACED
	jr SetLineSeparation

; given a number in hl, print it divided by 10 at b,c, with decimal part
; separated by a dot (unless it's 0). used to print a Pokemon card's weight.
PrintPokemonCardWeight:
	push bc
	ld de, -1
	ld bc, -10
.divide_by_10_loop
	inc de
	add hl, bc
	jr c, .divide_by_10_loop
	ld bc, 10
	add hl, bc
	pop bc
	push hl
	push bc
	ld l, e
	ld h, d
	call TwoByteNumberToTxSymbol_TrimLeadingZeros_Bank1
	pop bc
	pop hl
	ld a, l
	ld hl, wStringBuffer + 5
	or a
	jr z, .decimal_done
	ld [hl], SYM_DOT
	inc hl
	add SYM_0
	ld [hli], a
.decimal_done
	ld [hl], 0
	push bc
	call BCCoordToBGMap0Address
	ld hl, wStringBuffer
.find_first_digit_loop
	ld a, [hli]
	or a
	jr z, .find_first_digit_loop
	dec hl
	push hl
	ld b, -1
.get_number_length_loop
	inc b
	ld a, [hli]
	or a
	jr nz, .get_number_length_loop
	pop hl
	push bc
	call SafeCopyDataHLtoDE
	pop bc
	pop de
	ld a, b
	add d
	ld d, a
	ret

; given a number in h and another in l, print them formatted as <l>'<h>" at b,c.
; used to print the length (feet and inches) of a Pokemon card.
PrintPokemonCardLength:
	push hl
	ld l, h
	ld h, $00
	ldtx de, FeetText ; '
	call .print_feet_or_inches
	pop hl
	ld h, $00
	ldtx de, InchesText ; "
	call .print_feet_or_inches
	ret

.print_feet_or_inches
; keep track how many digits each number consists of in wPokemonLengthPrintOffset,
; in order to align the rest of the string. the text with id at de
; is printed after the number.
	push de
	push bc
	call TwoByteNumberToTxSymbol_TrimLeadingZeros_Bank1
	ld a, b
	inc a
	ld [wPokemonLengthPrintOffset], a
	pop bc
	push bc
	push hl
	call BCCoordToBGMap0Address
	ld a, [wPokemonLengthPrintOffset]
	ld b, a
	pop hl
	call SafeCopyDataHLtoDE
	pop bc
	ld a, [wPokemonLengthPrintOffset]
	add b
	ld b, a
	pop hl
	push bc
	ld e, c
	ld d, b
	call InitTextPrinting
	call ProcessTextFromID
	pop bc
	inc b
	ret

; return carry if the turn holder has any Pokemon with non-zero HP on the bench.
; return how many Pokemon with non-zero HP in b.
; does this by calculating how many Pokemon in play area minus one
HasAlivePokemonInBench:
	ld a, $01
	jr _HasAlivePokemonInPlayArea

; return carry if the turn holder has any Pokemon with non-zero HP in the play area.
; return how many Pokemon with non-zero HP in b.
HasAlivePokemonInPlayArea:
	xor a
;	fallthrough

_HasAlivePokemonInPlayArea:
	ld [wExcludeArenaPokemon], a
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
	ld [wPlayAreaScreenLoaded], a
	ld [wPlayAreaSelectAction], a
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

OpenPlayAreaScreenForViewing:
	ld a, START + A_BUTTON
	jr DisplayPlayAreaScreen

OpenPlayAreaScreenForSelection:
	ld a, START
;	fallthrough

DisplayPlayAreaScreen:
	ld [wNoItemSelectionMenuKeys], a
	ldh a, [hTempCardIndex_ff98]
	push af
	ld a, [wPlayAreaScreenLoaded]
	or a
	jr nz, .skip_ahead
	xor a
	ld [wSelectedDuelSubMenuItem], a
	inc a
	ld [wPlayAreaScreenLoaded], a
.asm_6022
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	call LoadDuelCheckPokemonScreenTiles
	call PrintPlayAreaCardList
	call EnableLCD
.skip_ahead
	ld hl, PlayAreaScreenMenuParameters_ActivePokemonIncluded
	ld a, [wExcludeArenaPokemon]
	or a
	jr z, .init_menu_params
	ld hl, PlayAreaScreenMenuParameters_ActivePokemonExcluded
.init_menu_params
	ld a, [wSelectedDuelSubMenuItem]
	call InitializeMenuParameters
	ld a, [wNumPlayAreaItems]
	ld [wNumMenuItems], a
.asm_604c
	call DoFrame
	call SelectingBenchPokemonMenu
	jr nc, .asm_6061
	cp $02
	jp z, .asm_60ac
	pop af
	ldh [hTempCardIndex_ff98], a
	ld a, [wPlayAreaSelectAction] ; useless
	jr OpenPlayAreaScreenForSelection
.asm_6061
	call HandleMenuInput
	jr nc, .asm_604c
	ld a, e
	ld [wSelectedDuelSubMenuItem], a
	ld a, [wExcludeArenaPokemon]
	add e
	ld [wCurPlayAreaSlot], a
	ld a, [wNoItemSelectionMenuKeys]
	ld b, a
	ldh a, [hKeysPressed]
	and b
	jr z, .asm_6091
	ld a, [wCurPlayAreaSlot]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	jr z, .asm_6022
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	call OpenCardPage_FromCheckPlayArea
	jr .asm_6022
.asm_6091
	ld a, [wExcludeArenaPokemon]
	ld c, a
	ldh a, [hCurMenuItem]
	add c
	ldh [hTempPlayAreaLocation_ff9d], a
	ldh a, [hCurMenuItem]
	cp $ff
	jr z, .asm_60b5
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	jr nz, .asm_60ac
	jr .skip_ahead
.asm_60ac
	pop af
	ldh [hTempCardIndex_ff98], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hCurMenuItem], a
	or a
	ret
.asm_60b5
	pop af
	ldh [hTempCardIndex_ff98], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hCurMenuItem], a
	scf
	ret

PlayAreaScreenMenuParameters_ActivePokemonIncluded:
	db 0, 0 ; cursor x, cursor y
	db 3 ; y displacement between items
	db 6 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw PlayAreaScreenMenuFunction ; function pointer if non-0

PlayAreaScreenMenuParameters_ActivePokemonExcluded:
	db 0, 3 ; cursor x, cursor y
	db 3 ; y displacement between items
	db 6 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw PlayAreaScreenMenuFunction ; function pointer if non-0

PlayAreaScreenMenuFunction:
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON | START
	ret z
	bit B_BUTTON_F, a
	jr z, .start_or_a
	ld a, $ff
	ldh [hCurMenuItem], a
.start_or_a
	scf
	ret

SelectingBenchPokemonMenu:
	ld a, [wPlayAreaSelectAction]
	or a
	ret z ; menu not allowed
	ldh a, [hKeysPressed]
	and SELECT
	ret z ; Select not pressed
	ld a, [wPlayAreaSelectAction]
	cp $02
	jr z, .return_carry
	xor a
	ld [wCurrentDuelMenuItem], a
.duel_main_scene
	call DrawDuelMainScene
	ldtx hl, SelectingBenchPokemonHandExamineBackText
	call DrawWideTextBox_PrintTextNoDelay
	call .InitMenu
.loop_input
	call DoFrame
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr nz, .a_pressed
	call .HandleInput
	call RefreshMenuCursor
	xor a
	call HandleSpecialDuelMainSceneHotkeys
	jr nc, .loop_input
	ldh a, [hKeysPressed]
	and SELECT
	jr z, .duel_main_scene
.back
	call HasAlivePokemonInBench
	ld a, $01
	ld [wPlayAreaSelectAction], a
.return_carry
	scf
	ret

.a_pressed
	ld a, [wCurrentDuelMenuItem]
	cp 2
	jr z, .back
	or a
	jr z, .check_hand
; examine
	call OpenDuelCheckMenu
	jr .duel_main_scene
.check_hand
	call OpenTurnHolderHandScreen_Simple
	jr .duel_main_scene

.HandleInput:
	ldh a, [hDPadHeld]
	bit B_BUTTON_F, a
	ret nz
	and D_RIGHT | D_LEFT
	ret z

	; right or left pressed
	ld b, a
	ld a, [wCurrentDuelMenuItem]
	bit D_LEFT_F, b
	jr z, .right_pressed
	dec a
	bit 7, a
	jr z, .got_menu_item
	ld a, 2
	jr .got_menu_item
.right_pressed
	inc a
	cp 3
	jr c, .got_menu_item
	xor a
.got_menu_item
	ld [wCurrentDuelMenuItem], a
	call EraseCursor
;	fallthrough

.InitMenu:
	ld a, [wCurrentDuelMenuItem]
	ld d, a
	add a
	add d
	add a
	add 2
	ld d, a
	ld e, 16
	lb bc, SYM_CURSOR_R, SYM_SPACE
	jp SetCursorParametersForTextBox

; unreferenced
Func_616e:
	ldh [hTempPlayAreaLocation_ff9d], a
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	call LoadDuelCheckPokemonScreenTiles
	xor a
	ld [wExcludeArenaPokemon], a
	call PrintPlayAreaCardList
	call EnableLCD
;	fallthrough

InitAndPrintPlayAreaCardInformationAndLocation:
	ld hl, wCurPlayAreaSlot
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld [hli], a
	ld c, a
	add a
	add c
	ld [hl], a
	call PrintPlayAreaCardInformationAndLocation
	ret

InitAndPrintPlayAreaCardInformationAndLocation_WithTextBox:
	call InitAndPrintPlayAreaCardInformationAndLocation
	ld a, [wCurPlayAreaY]
	ld e, a
	ld d, 0
	call SetCursorParametersForTextBox_Default
	ret

SetupPlayAreaScreen:
	xor a
	ld [wExcludeArenaPokemon], a
	ld a, [wDuelDisplayedScreen]
	cp PLAY_AREA_CARD_LIST
	ret z
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	call LoadDuelCheckPokemonScreenTiles
	ret

; for each turn holder's play area Pokemon card, print the name, level,
; face down stage card, color symbol, status symbol (if any), pluspower/defender
; symbols (if any), attached energies (if any), and HP bar.
; also print the play area locations (ACT/BPx indicators) for each of the six slots.
; return the value of wNumPlayAreaItems (as returned from PrintPlayAreaCardList) in a.
PrintPlayAreaCardList_EnableLCD:
	ld a, PLAY_AREA_CARD_LIST
	ld [wDuelDisplayedScreen], a
	call PrintPlayAreaCardList
	call EnableLCD
	ld a, [wNumPlayAreaItems]
	ret

; for each turn holder's play area Pokemon card, print the name, level,
; face down stage card, color symbol, status symbol (if any), pluspower/defender
; symbols (if any), attached energies (if any), and HP bar.
; also print the play area locations (ACT/BPx indicators) for each of the six slots.
PrintPlayAreaCardList:
	ld a, PLAY_AREA_CARD_LIST
	ld [wDuelDisplayedScreen], a
	ld de, wDuelTempList
	call SetListPointer
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld b, $00
.print_cards_info_loop
	; for each Pokemon card in play area, print its information (and location)
	push hl
	push bc
	ld a, b
	ld [wCurPlayAreaSlot], a
	ld a, b
	add a
	add b
	ld [wCurPlayAreaY], a
	ld a, b
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call SetNextElementOfList
	call PrintPlayAreaCardInformationAndLocation
	pop bc
	pop hl
	inc b
	dec c
	jr nz, .print_cards_info_loop
	push bc
.print_locations_loop
	; print all play area location indicators (even if there's no Pokemon card on it)
	ld a, b
	cp MAX_PLAY_AREA_POKEMON
	jr z, .locations_printed
	ld [wCurPlayAreaSlot], a
	add a
	add b
	ld [wCurPlayAreaY], a
	push bc
	call PrintPlayAreaCardLocation
	pop bc
	inc b
	jr .print_locations_loop
.locations_printed
	pop bc
	ld a, b
	ld [wNumPlayAreaItems], a
	ld a, [wExcludeArenaPokemon]
	or a
	ret z
	; if wExcludeArenaPokemon is set, decrement [wNumPlayAreaItems] and shift back wDuelTempList
	dec b
	ld a, b
	ld [wNumPlayAreaItems], a
	ld hl, wDuelTempList + 1
	ld de, wDuelTempList
.shift_back_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .shift_back_loop
	ret

; print a turn holder's play area Pokemon card's name, level, face down stage card,
; color symbol, status symbol (if any), pluspower/defender symbols (if any),
; attached energies (if any), HP bar, and the play area location (ACT/BPx indicator)
; input:
   ; wCurPlayAreaSlot: PLAY_AREA_* of the card to display the information of
   ; wCurPlayAreaY: Y coordinate of where to print the card's information
; total space occupied is a rectangle of 20x3 tiles
PrintPlayAreaCardInformationAndLocation:
	ld a, [wCurPlayAreaSlot]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	ret z
	call PrintPlayAreaCardInformation
;	fallthrough

;  print a turn holder's play area Pokemon card's location (ACT/BPx indicator)
PrintPlayAreaCardLocation:
	; print the ACT/BPx indicator
	ld a, [wCurPlayAreaSlot]
	add a
	add a
	ld e, a
	ld d, $00
	ld hl, PlayAreaLocationTileNumbers
	add hl, de
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .write_tiles
	; move forward to the opponent's side tile numbers
	; they have black letters and white background instead of the other way around
	ld d, $0a
.write_tiles
	ld a, [wCurPlayAreaY]
	ld b, 1
	ld c, a
	ld a, [hli]
	add d
	call WriteByteToBGMap0
	inc c
	ld a, [hli]
	add d
	call WriteByteToBGMap0
	inc c
	ld a, [hli]
	add d
	call WriteByteToBGMap0
	ret

PlayAreaLocationTileNumbers:
	db $e0, $e1, $e2, $00 ; ACT
	db $e3, $e4, $e5, $00 ; BP1
	db $e3, $e4, $e6, $00 ; BP2
	db $e3, $e4, $e7, $00 ; BP3
	db $e3, $e4, $e8, $00 ; BP4
	db $e3, $e4, $e9, $00 ; BP5

; print a turn holder's play area Pokemon card's name, level, face down stage card,
; color symbol, status symbol (if any), pluspower/defender symbols (if any),
; attached energies (if any), and HP bar.
; input:
   ; wCurPlayAreaSlot: PLAY_AREA_* of the card to display the information of
   ; wCurPlayAreaY: Y coordinate of where to print the card's information
; total space occupied is a rectangle of 20x3 tiles
PrintPlayAreaCardInformation:
	; print name, level, color, stage, status, pluspower/defender
	call PrintPlayAreaCardHeader
	; print the symbols of the attached energies
	ld a, [wCurPlayAreaSlot]
	ld e, a
	ld a, [wCurPlayAreaY]
	inc a
	ld c, a
	ld b, 7
	call PrintPlayAreaCardAttachedEnergies
	ld a, [wCurPlayAreaY]
	inc a
	ld c, a
	ld b, 5
	ld a, SYM_E
	call WriteByteToBGMap0
	; print the HP bar
	inc c
	ld a, SYM_HP
	call WriteByteToBGMap0
	ld a, [wCurPlayAreaSlot]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	jr z, .zero_hp
	ld e, a
	ld a, [wLoadedCard1HP]
	ld d, a
	call DrawHPBar
	ld a, [wCurPlayAreaY]
	inc a
	inc a
	ld c, a
	ld b, 7
	call BCCoordToBGMap0Address
	ld hl, wDefaultText
	ld b, 12
	call SafeCopyDataHLtoDE
	ret
.zero_hp
	; if fainted, print "Knock Out" in place of the HP bar
	ld a, [wCurPlayAreaY]
	inc a
	inc a
	ld e, a
	ld d, 7
	ldtx hl, KnockOutText
	call InitTextPrinting_ProcessTextFromID
	ret

; print a turn holder's play area Pokemon card's name, level, face down stage card,
; color symbol, status symbol (if any), and pluspower/defender symbols (if any).
; input:
   ; wCurPlayAreaSlot: PLAY_AREA_* of the card to display the information of
   ; wCurPlayAreaY: Y coordinate of where to print the card's information
PrintPlayAreaCardHeader:
	; start by printing the Pokemon's name
	ld a, [wCurPlayAreaSlot]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wCurPlayAreaY]
	ld e, a
	ld d, 4
	call InitTextPrinting
	; copy the name to wDefaultText (max. 10 characters)
	; then call ProcessText with hl = wDefaultText
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDefaultText
	push de
	ld a, 10 ; card name maximum length
	call CopyTextData_FromTextID
	pop hl
	call ProcessText

	; print the Pokemon's color and the level
	ld a, [wCurPlayAreaY]
	ld c, a
	ld b, 18
	ld a, [wCurPlayAreaSlot]
	call GetPlayAreaCardColor
	inc a
	call JPWriteByteToBGMap0
	ld b, 14
	ld a, SYM_Lv
	call WriteByteToBGMap0
	ld a, [wCurPlayAreaY]
	ld c, a
	ld b, 15
	ld a, [wLoadedCard1Level]
	call WriteTwoDigitNumberInTxSymbolFormat

	; print the 2x2 face down card image depending on the Pokemon's evolution stage
	ld a, [wCurPlayAreaSlot]
	add DUELVARS_ARENA_CARD_STAGE
	call GetTurnDuelistVariable
	add a
	ld e, a
	ld d, $00
	ld hl, FaceDownCardTileNumbers
	add hl, de
	ld a, [hli] ; starting tile to fill the 2x2 rectangle with
	push hl
	push af
	lb hl, 1, 2
	lb bc, 2, 2
	ld a, [wCurPlayAreaY]
	ld e, a
	ld d, 2
	pop af
	call FillRectangle
	pop hl
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	; in cgb, we have to take care of coloring it too
	ld a, [hl]
	lb hl, 0, 0
	lb bc, 2, 2
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0

.not_cgb
	; print the status condition symbol if any (only for the arena Pokemon card)
	ld hl, wCurPlayAreaSlot
	ld a, [hli]
	or a
	jr nz, .skip_status
	ld c, [hl]
	inc c
	inc c
	ld b, 2
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	call CheckPrintCnfSlpPrz
	inc b
	call CheckPrintPoisoned
	inc b
	call CheckPrintDoublePoisoned

.skip_status
	; finally check whether to print the Pluspower and/or Defender symbols
	ld a, [wCurPlayAreaSlot]
	add DUELVARS_ARENA_CARD_ATTACHED_PLUSPOWER
	call GetTurnDuelistVariable
	or a
	jr z, .not_pluspower
	ld a, [wCurPlayAreaY]
	inc a
	ld c, a
	ld b, 15
	ld a, SYM_PLUSPOWER
	call WriteByteToBGMap0
	inc b
	ld a, [hl]
	add SYM_0
	call WriteByteToBGMap0
.not_pluspower
	ld a, [wCurPlayAreaSlot]
	add DUELVARS_ARENA_CARD_ATTACHED_DEFENDER
	call GetTurnDuelistVariable
	or a
	jr z, .not_defender
	ld a, [wCurPlayAreaY]
	inc a
	ld c, a
	ld b, 17
	ld a, SYM_DEFENDER
	call WriteByteToBGMap0
	inc b
	ld a, [hl]
	add SYM_0
	call WriteByteToBGMap0
.not_defender
	ret

FaceDownCardTileNumbers:
; starting tile number, cgb palette (grey, yellow/red, green/blue, pink/orange)
	db $d0, $02 ; basic
	db $d4, $02 ; stage 1
	db $d8, $01 ; stage 2
	db $dc, $01 ; stage 2 special

; given a card's status in a, print the Poison symbol at bc if it's poisoned
CheckPrintPoisoned:
	push af
	and POISONED
	jr z, .print
.poison
	ld a, SYM_POISONED
.print
	call WriteByteToBGMap0
	pop af
	ret

; given a card's status in a, print the Poison symbol at bc if it's double poisoned
CheckPrintDoublePoisoned:
	push af
	and DOUBLE_POISONED & (POISONED ^ $ff)
	jr nz, CheckPrintPoisoned.poison ; double poisoned (print SYM_POISONED)
	jr CheckPrintPoisoned.print ; not double poisoned (print SYM_SPACE)

; given a card's status in a, print the Confusion, Sleep, or Paralysis symbol at bc
; for each of those status that is active
CheckPrintCnfSlpPrz:
	push af
	push hl
	push de
	and CNF_SLP_PRZ
	ld e, a
	ld d, $00
	ld hl, .status_symbols
	add hl, de
	ld a, [hl]
	call WriteByteToBGMap0
	pop de
	pop hl
	pop af
	ret

.status_symbols
	;  NO_STATUS, CONFUSED,     ASLEEP,     PARALYZED
	db SYM_SPACE, SYM_CONFUSED, SYM_ASLEEP, SYM_PARALYZED

; print the symbols of the attached energies of a turn holder's play area card
; input:
; - e: PLAY_AREA_*
; - b, c: where to print (x, y)
; - wAttachedEnergies and wTotalAttachedEnergies
PrintPlayAreaCardAttachedEnergies:
	push bc
	call GetPlayAreaCardAttachedEnergies
	ld hl, wDefaultText
	push hl
	ld c, NUM_TYPES
	xor a
.empty_loop
	ld [hli], a
	dec c
	jr nz, .empty_loop
	pop hl
	ld de, wAttachedEnergies
	lb bc, SYM_FIRE, NUM_TYPES - 1
.next_color
	ld a, [de] ; energy count of current color
	inc de
	inc a
	jr .check_amount
.has_energy
	ld [hl], b
	inc hl
.check_amount
	dec a
	jr nz, .has_energy
	inc b
	dec c
	jr nz, .next_color
	ld a, [wTotalAttachedEnergies]
	cp 9
	jr c, .place_tiles
	ld a, SYM_PLUS
	ld [wDefaultText + 7], a
.place_tiles
	pop bc
	call BCCoordToBGMap0Address
	ld hl, wDefaultText
	ld b, NUM_TYPES
	call SafeCopyDataHLtoDE
	ret

Func_6423:
	ld hl, wDefaultText
	ld e, $08
.asm_6428
	ld a, [hli]
	call JPWriteByteToBGMap0
	inc b
	dec e
	jr nz, .asm_6428
	ret

DisplayPlayAreaScreenToUsePkmnPower:
	xor a
	ld [wSelectedDuelSubMenuItem], a

.asm_6435
	call .DrawScreen
	ld hl, PlayAreaScreenMenuParameters_ActivePokemonIncluded
	ld a, [wSelectedDuelSubMenuItem]
	call InitializeMenuParameters
	ld a, [wNumPlayAreaItems]
	ld [wNumMenuItems], a
.asm_6447
	call DoFrame
	call HandleMenuInput
	ldh [hTempPlayAreaLocation_ff9d], a
	ld [wHUDEnergyAndHPBarsX], a
	jr nc, .asm_6447
	cp $ff
	jr z, .asm_649b
	ld [wSelectedDuelSubMenuItem], a
	ldh a, [hKeysPressed]
	and START
	jr nz, .asm_649d
	ldh a, [hCurMenuItem]
	add a
	ld e, a
	ld d, $00
	ld hl, wDuelTempList + 1
	add hl, de
	ld a, [hld]
	cp $04
	jr nz, .asm_6447
	ld a, [hl]
	ldh [hTempCardIndex_ff98], a
	ld d, a
	ld e, FIRST_ATTACK_OR_PKMN_POWER
	call CopyAttackDataAndDamage_FromDeckIndex
	call DisplayUsePokemonPowerScreen
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_1
	call TryExecuteEffectCommandFunction
	jr nc, .asm_648c
	ldtx hl, PokemonPowerSelectNotRequiredText
	call DrawWideTextBox_WaitForInput
	jp .asm_6435
.asm_648c
	ldtx hl, UseThisPokemonPowerText
	call YesOrNoMenuWithText
	jp c, .asm_6435
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	or a
	ret
.asm_649b
	scf
	ret
.asm_649d
	ldh a, [hCurMenuItem]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	call OpenCardPage_FromCheckPlayArea
	jp .asm_6435

.DrawScreen:
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	call LoadDuelCheckPokemonScreenTiles
	ld de, wDuelTempList
	call SetListPointer
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld b, $00
.asm_64ca
	push hl
	push bc
	ld a, b
	ld [wHUDEnergyAndHPBarsX], a
	ld a, b
	add a
	add b
	ld [wCurPlayAreaY], a
	ld a, b
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call SetNextElementOfList
	call PrintPlayAreaCardHeader
	call PrintPlayAreaCardLocation
	call .PrintCardNameIfHasPkmnPower
	ld a, [wLoadedCard1Atk1Category]
	call SetNextElementOfList
	pop bc
	pop hl
	inc b
	dec c
	jr nz, .asm_64ca
	ld a, b
	ld [wNumPlayAreaItems], a
	call EnableLCD
	ret

.PrintCardNameIfHasPkmnPower:
	ld a, [wLoadedCard1Atk1Category]
	cp POKEMON_POWER
	ret nz
	ld a, [wCurPlayAreaY]
	inc a
	ld e, a
	ld d, 4
	ld hl, wLoadedCard1Atk1Name
	call InitTextPrinting_ProcessTextFromPointerToID
	ret

; display the screen that prompts the player to use the selected card's
; Pokemon Power. Includes the card's information above, and the Pokemon Power's
; description below.
; input: hTempPlayAreaLocation_ff9d
DisplayUsePokemonPowerScreen::
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld [wCurPlayAreaSlot], a
	xor a
	ld [wCurPlayAreaY], a
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	call LoadDuelCheckPokemonScreenTiles
	call PrintPlayAreaCardInformationAndLocation
	lb de, 1, 4
	call InitTextPrinting
	ld hl, wLoadedCard1Atk1Name
	call InitTextPrinting_ProcessTextFromPointerToID
	lb de, 1, 6
	ld hl, wLoadedCard1Atk1Description
	call PrintAttackOrCardDescription
	ret

; print the description of an attack, a Pokemon power, or a trainer or energy card
; x,y coordinates of where to start printing the text are given at de
; don't separate lines of text
PrintAttackOrCardDescription:
	call SetNoLineSeparation
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CountLinesOfTextFromID
	cp 7
	jr c, .print
	dec e ; move one line up to fit (assumes it will be enough)
.print
	ld a, 19
	call InitTextPrintingInTextbox
	call ProcessTextFromID
	call SetOneLineSeparation
	ret

; moves the cards loaded by deck index at hTempRetreatCostCards to the discard pile
DiscardRetreatCostCards:
	ld hl, hTempRetreatCostCards
.discard_loop
	ld a, [hli]
	cp $ff
	ret z
	call PutCardInDiscardPile
	jr .discard_loop

; moves the discard pile cards that were loaded to hTempRetreatCostCards back to the active Pokemon.
; this exists because they will be discarded again during the call to AttemptRetreat, so
; it prevents the energy cards from being discarded twice.
ReturnRetreatCostCardsToArena:
	ld hl, hTempRetreatCostCards
.loop
	ld a, [hli]
	cp $ff
	ret z
	push hl
	call MoveDiscardPileCardToHand
	call AddCardToHand
	ld e, PLAY_AREA_ARENA
	call PutHandCardInPlayArea
	pop hl
	jr .loop

; discard retreat cost energy cards and attempt retreat of the arena card.
; return carry if unable to retreat this turn due to unsuccessful confusion check
; if successful, the retreated card is replaced with a bench Pokemon card
AttemptRetreat:
	call DiscardRetreatCostCards
	ldh a, [hTemp_ffa0]
	and CNF_SLP_PRZ
	cp CONFUSED
	jr nz, .success
	ldtx de, ConfusionCheckRetreatText
	call TossCoin
	jr c, .success
	ld a, TRUE
	ld [wConfusionRetreatCheckWasUnsuccessful], a
	scf
	ret
.success
	ldh a, [hTempPlayAreaLocation_ffa1]
	ld e, a
	call SwapArenaWithBenchPokemon
	xor a ; FALSE
	ld [wConfusionRetreatCheckWasUnsuccessful], a
	ret

; given a number between 0-255 in a, converts it to TX_SYMBOL format,
; and writes it to wStringBuffer + 2 and to the BGMap0 address at bc.
; leading zeros replaced with SYM_SPACE.
WriteTwoByteNumberInTxSymbolFormat:
	push de
	push bc
	ld l, a
	ld h, $00
	call TwoByteNumberToTxSymbol_TrimLeadingZeros_Bank1
	pop bc
	push bc
	call BCCoordToBGMap0Address
	ld hl, wStringBuffer + 2
	ld b, 3
	call SafeCopyDataHLtoDE
	pop bc
	pop de
	ret

; given a number between 0-99 in a, converts it to TX_SYMBOL format,
; and writes it to wStringBuffer + 3 and to the BGMap0 address at bc.
; if the number is between 0-9, the first digit is replaced with SYM_SPACE.
WriteTwoDigitNumberInTxSymbolFormat:
	push hl
	push de
	push bc
	ld l, a
	ld h, $00
	call TwoByteNumberToTxSymbol_TrimLeadingZeros_Bank1
	pop bc
	push bc
	call BCCoordToBGMap0Address
	ld hl, wStringBuffer + 3
	ld b, 2
	call SafeCopyDataHLtoDE
	pop bc
	pop de
	pop hl
	ret

; convert the number at hl to TX_SYMBOL text format and write it to wStringBuffer
; replace leading zeros with SYM_SPACE
TwoByteNumberToTxSymbol_TrimLeadingZeros_Bank1:
	ld de, wStringBuffer
	ld bc, -10000
	call .get_digit
	ld bc, -1000
	call .get_digit
	ld bc, -100
	call .get_digit
	ld bc, -10
	call .get_digit
	ld bc, -1
	call .get_digit
	xor a ; TX_END
	ld [de], a
	ld hl, wStringBuffer
	ld b, 4
.digit_loop
	ld a, [hl]
	cp SYM_0
	jr nz, .done ; jump if not zero
	ld [hl], SYM_SPACE ; trim leading zero
	inc hl
	dec b
	jr nz, .digit_loop
.done
	ret

.get_digit
	ld a, SYM_0 - 1
.subtract_loop
	inc a
	add hl, bc
	jr c, .subtract_loop
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret

; input d, e: max. HP, current HP
DrawHPBar:
	ld a, MAX_HP
	ld c, SYM_SPACE
	call .fill_hp_bar ; empty bar
	ld a, d
	ld c, SYM_HP_OK
	call .fill_hp_bar ; fill (max. HP) with HP counters
	ld a, d
	sub e
	ld c, SYM_HP_NOK
	; fill (max. HP - current HP) with damaged HP counters
.fill_hp_bar
	or a
	ret z
	ld hl, wDefaultText
	ld b, HP_BAR_LENGTH
.tile_loop
	ld [hl], c
	inc hl
	dec b
	ret z
	sub MAX_HP / HP_BAR_LENGTH
	jr nz, .tile_loop
	ret

; when an opponent's Pokemon card attacks, this displays a screen
; containing the description and information of the used attack
DisplayOpponentUsedAttackScreen:
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadDuelCardSymbolTiles
	call LoadDuelFaceDownCardTiles
	ld a, [wTempCardID_ccc2]
	ld e, a
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID
	ld a, CARDPAGE_POKEMON_OVERVIEW
	ld [wCardPageNumber], a
	ld hl, wLoadedCard1Atk1Name
	ld a, [wSelectedAttack]
	or a
	jr z, .first_atk
	ld hl, wLoadedCard1Atk2Name
.first_atk
	ld e, 1
	call PrintAttackOrPkmnPowerInformation
	lb de, 1, 4
	ld hl, wLoadedAttackDescription
	call PrintAttackOrCardDescription
	ret

; display card detail when a trainer card is used, and print "Used xxx"
; hTempCardIndex_ff9f contains the card's deck index
DisplayUsedTrainerCardDetailScreen::
	ldh a, [hTempCardIndex_ff9f]
	ldtx hl, UsedText
	call DisplayCardDetailScreen
	ret

; prints the name and description of a trainer card, along with the
; "Used xxx" text in a text box. this function is used to show the player
; the information of a trainer card being used by the opponent.
PrintUsedTrainerCardDescription:
	call EmptyScreen
	call SetNoLineSeparation
	lb de, 1, 1
	call InitTextPrinting
	ld hl, wLoadedCard1Name
	call ProcessTextFromPointerToID
	ld a, 19
	lb de, 1, 3
	call InitTextPrintingInTextbox
	ld hl, wLoadedCard1NonPokemonDescription
	call ProcessTextFromPointerToID
	call SetOneLineSeparation
	ldtx hl, UsedText
	call DrawWideTextBox_WaitForInput
	ret

; save data of the current duel to sCurrentDuel
; byte 0 is $01, bytes 1 and 2 are the checksum, byte 3 is [wDuelType]
; next $33a bytes come from DuelDataToSave
SaveDuelData::
	farcall StubbedUnusedSaveDataValidation
	ld de, sCurrentDuel
;	fallthrough

; save data of the current duel to de (in SRAM)
; byte 0 is $01, bytes 1 and 2 are the checksum, byte 3 is [wDuelType]
; next $33a bytes come from DuelDataToSave
SaveDuelDataToDE::
	call EnableSRAM
	push de
	inc de
	inc de
	inc de
	inc de
	ld hl, DuelDataToSave
	push de
.save_duel_data_loop
	; start copying data to de = sCurrentDuelData + $1
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, c
	or b
	jr z, .data_done
	push hl
	push bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	pop hl
	call CopyDataHLtoDE
	pop hl
	inc hl
	inc hl
	jr .save_duel_data_loop
.data_done
	pop hl
	; save a checksum to hl = sCurrentDuelData + $1
	lb de, $23, $45
	ld bc, $334 ; misses last 6 bytes to calculate checksum
.checksum_loop
	ld a, e
	sub [hl]
	ld e, a
	ld a, [hli]
	xor d
	ld d, a
	dec bc
	ld a, c
	or b
	jr nz, .checksum_loop
	pop hl
	ld a, $01
	ld [hli], a ; sCurrentDuel
	ld [hl], e ; sCurrentDuelChecksum
	inc hl
	ld [hl], d ; sCurrentDuelChecksum
	inc hl
	ld a, [wDuelType]
	ld [hl], a ; sCurrentDuelData
	call DisableSRAM
	ret

; loads current Duel data from SRAM and also general save data
; if the data is not valid, returns carry
LoadAndValidateDuelSaveData:
	ld hl, sCurrentDuel
	call ValidateSavedDuelData
	ret c
	ld de, sCurrentDuel
	call LoadSavedDuelData

	call ValidateGeneralSaveData
	ret nc
	call LoadGeneralSaveData
	or a
	ret

; load the data saved in sCurrentDuelData to WRAM according to the distribution
; of DuelDataToSave. assumes saved data exists and that the checksum is valid.
LoadSavedDuelData:
	call EnableSRAM
	inc de
	inc de
	inc de
	inc de
	ld hl, DuelDataToSave
.next_block
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, c
	or b
	jr z, .done
	push hl
	push bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	pop hl
.copy_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .copy_loop
	pop hl
	inc hl
	inc hl
	jr .next_block
.done
	call DisableSRAM
	ret

DuelDataToSave:
;	dw address, number of bytes to copy
	dw wPlayerDuelVariables,   wOpponentDuelVariables - wPlayerDuelVariables
	dw wOpponentDuelVariables, wPlayerDeck - wOpponentDuelVariables
	dw wPlayerDeck,            wDuelTempList - wPlayerDeck
	dw wWhoseTurn,             wDuelTheme + $1 - wWhoseTurn
	dw hWhoseTurn,             $1
	dw wRNG1,                  wRNGCounter + $1 - wRNG1
	dw wAIDuelVars,            wAIDuelVarsEnd - wAIDuelVars
	dw NULL

; return carry if there is no data saved at sCurrentDuel or if the checksum isn't correct,
; or if the value saved from wDuelType is DUELTYPE_LINK
ValidateSavedNonLinkDuelData:
	call EnableSRAM
	ld hl, sCurrentDuel
	ld a, [sCurrentDuelData]
	call DisableSRAM
	cp DUELTYPE_LINK
	jr nz, ValidateSavedDuelData
	; ignore any saved data of a link duel
	scf
	ret

; return carry if there is no data saved at sCurrentDuel or if the checksum isn't correct
; input: hl = sCurrentDuel
ValidateSavedDuelData:
	call EnableSRAM
	push de
	ld a, [hli]
	or a
	jr z, .no_saved_data
	lb de, $23, $45
	ld bc, $334
	ld a, [hl]
	sub e
	ld e, a
	inc hl
	ld a, [hl]
	xor d
	ld d, a
	inc hl
	inc hl
.loop
	ld a, [hl]
	add e
	ld e, a
	ld a, [hli]
	xor d
	ld d, a
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ld a, e
	or d
	jr z, .ok
.no_saved_data
	scf
.ok
	call DisableSRAM
	pop de
	ret

; discard data of a duel that was saved by SaveDuelData, by setting the first byte
; of sCurrentDuel to $00, and zeroing the checksum (next two bytes)
DiscardSavedDuelData:
	call EnableSRAM
	ld hl, sCurrentDuel
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	call DisableSRAM
	ret

; loads a player deck (sDeck*Cards) from SRAM to wPlayerDeck
; sCurrentlySelectedDeck determines which sDeck*Cards source (0-3)
LoadPlayerDeck:
	call EnableSRAM
	ld a, [sCurrentlySelectedDeck]
	ld l, a
	ld h, sDeck2Cards - sDeck1Cards
	call HtimesL
	ld de, sDeck1Cards
	add hl, de
	ld de, wPlayerDeck
	ld c, DECK_SIZE
.copy_cards_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_cards_loop
	call DisableSRAM
	ret

; returns carry if wSkipDelayAllowed is non-0 and B is being held in order to branch
; out of the caller's wait frames loop. probably only used for debugging.
CheckSkipDelayAllowed:
	ld a, [wSkipDelayAllowed]
	or a
	ret z
	ldh a, [hKeysHeld]
	and B_BUTTON
	ret z
	scf
	ret

; related to AI taking their turn in a duel
; called multiple times during one AI turn
; each call results in the execution of an OppActionTable function
AIMakeDecision:
	ldh [hOppActionTableIndex], a
	ld hl, wSkipDuelistIsThinkingDelay
	ld a, [hl]
	ld [hl], $0
	or a
	jr nz, .skip_delay
.delay_loop
	call DoFrame
	ld a, [wVBlankCounter]
	cp 60
	jr c, .delay_loop

.skip_delay
	ldh a, [hOppActionTableIndex]
	ld hl, wOpponentTurnEnded
	ld [hl], 0
	ld hl, OppActionTable
	call JumpToFunctionInTable
	ld a, [wDuelFinished]
	ld hl, wOpponentTurnEnded
	or [hl]
	jr nz, .turn_ended
	ld a, [wSkipDuelistIsThinkingDelay]
	or a
	ret nz
	ld [wVBlankCounter], a
	ldtx hl, DuelistIsThinkingText
	call DrawWideTextBox_PrintTextNoDelay
	or a
	ret

.turn_ended
	scf
	ret

; handles menu for when player is waiting for
; Link Opponent to make a decision, where it's
; possible to examine the hand or duel main scene
HandleWaitingLinkOpponentMenu:
	ld a, 10
.delay_loop
	call DoFrame
	dec a
	jr nz, .delay_loop
	ld [wCurrentDuelMenuItem], a ; 0
.loop_outer
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ldtx hl, WaitingHandExamineText
	call DrawWideTextBox_PrintTextNoDelay
	call .InitTextBoxMenu
.loop_inner
	call DoFrame
	call .HandleInput
	call RefreshMenuCursor
	ldh a, [hKeysPressed]
	bit A_BUTTON_F, a
	jr nz, .a_pressed
	ld a, $01
	call HandleSpecialDuelMainSceneHotkeys
	jr nc, .loop_inner
.duel_main_scene
	call DrawDuelMainScene
	jr .loop_outer
.a_pressed
	ld a, [wCurrentDuelMenuItem]
	or a
	jr z, .open_hand
; duel check
	call OpenDuelCheckMenu
	jr .duel_main_scene
.open_hand
	call OpenTurnHolderHandScreen_Simple
	jr .duel_main_scene

.HandleInput:
	ldh a, [hDPadHeld]
	bit B_BUTTON_F, a
	ret nz
	and D_LEFT | D_RIGHT
	ret z
	call EraseCursor
	ld hl, wCurrentDuelMenuItem
	ld a, [hl]
	xor $01
	ld [hl], a

.InitTextBoxMenu:
	ld d, 2
	ld a, [wCurrentDuelMenuItem]
	or a
	jr z, .set_cursor_params
	ld d, 8
.set_cursor_params
	ld e, 16
	lb bc, SYM_CURSOR_R, SYM_SPACE
	jp SetCursorParametersForTextBox

; handles the key shortcuts to access some duel functions
; while inside the Duel Main scene in some situations
; (while waiting for Link Opponent's turn & when
; selecting a bench Pokémon, and choosing 'Examine')
; hotkeys:
; - Start     = Arena's card page
; - Select    = if a == 0: In Play Area
;               otherwise: In Play Area then both Play Areas
; - B + down  = player's Play Area
; - B + left  = player's Discard Pile
; - B + up    = opponent's Play Area
; - B + right = opponent's Discard Pile
HandleSpecialDuelMainSceneHotkeys:
	ld [wDuelMainSceneSelectHotkeyAction], a
	ldh a, [hKeysPressed]
	bit START_F, a
	jr nz, .start_pressed
	bit SELECT_F, a
	jr nz, .select_pressed
	ldh a, [hKeysHeld]
	and B_BUTTON
	ret z ; exit if no B btn
	ldh a, [hKeysPressed]
	bit D_DOWN_F, a
	jr nz, .down_pressed
	bit D_LEFT_F, a
	jr nz, .left_pressed
	bit D_UP_F, a
	jr nz, .up_pressed
	bit D_RIGHT_F, a
	jr nz, .right_pressed
	or a
	ret
.start_pressed
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	jr z, .return_carry
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	ld hl, wCurPlayAreaSlot
	xor a
	ld [hli], a
	ld [hl], a ; wCurPlayAreaY
	call OpenCardPage_FromCheckPlayArea
.return_carry
	scf
	ret
.select_pressed
	ld a, [wDuelMainSceneSelectHotkeyAction]
	or a
	jr nz, .both_duelist_play_areas
	call OpenInPlayAreaScreen_FromSelectButton
	jr .return_carry
.both_duelist_play_areas
	call OpenVariousPlayAreaScreens_FromSelectPresses
	jr .return_carry
.down_pressed
	call OpenTurnHolderPlayAreaScreen
	jr .return_carry
.left_pressed
	call OpenTurnHolderDiscardPileScreen
	jr .return_carry
.up_pressed
	call OpenNonTurnHolderPlayAreaScreen
	jr .return_carry
.right_pressed
	call OpenNonTurnHolderDiscardPileScreen
	jr .return_carry

SetLinkDuelTransmissionFrameFunction:
	call FinishQueuedAnimations
	ld hl, sp+$00
	ld a, l
	ld [wLinkOpponentTurnReturnAddress], a
	ld a, h
	ld [wLinkOpponentTurnReturnAddress + 1], a
	ld de, LinkOpponentTurnFrameFunction
	ld hl, wDoFrameFunction
	ld [hl], e
	inc hl
	ld [hl], d
	ret

ResetDoFrameFunction_Bank1:
	xor a
	ld hl, wDoFrameFunction
	ld [hli], a
	ld [hl], a
	ret

; print the AttachedEnergyToPokemonText, given the energy card to attach in hTempCardIndex_ff98,
; and the PLAY_AREA_* of the turn holder's Pokemon to attach the energy to in hTempPlayAreaLocation_ff9d
PrintAttachedEnergyToPokemon:
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardNameToTxRam2_b
	ldh a, [hTempCardIndex_ff98]
	call LoadCardNameToTxRam2
	ldtx hl, AttachedEnergyToPokemonText
	call DrawWideTextBox_WaitForInput
	ret

; print the PokemonEvolvedIntoPokemonText, given the Pokemon card to evolve in wPreEvolutionPokemonCard,
; and the evolved Pokemon card in hTempCardIndex_ff98. also play a sound effect.
PrintPokemonEvolvedIntoPokemon:
	ld a, SFX_POKEMON_EVOLUTION
	call PlaySFX
	ld a, [wPreEvolutionPokemonCard]
	call LoadCardNameToTxRam2
	ldh a, [hTempCardIndex_ff98]
	call LoadCardNameToTxRam2_b
	ldtx hl, PokemonEvolvedIntoPokemonText
	call DrawWideTextBox_WaitForInput
	ret

; handle the opponent's turn in a link duel
; loop until either [wOpponentTurnEnded] or [wDuelFinished] is non-0
DoLinkOpponentTurn:
	xor a
	ld [wOpponentTurnEnded], a
	xor a
	ld [wSkipDuelistIsThinkingDelay], a
.link_opp_turn_loop
	ld a, [wSkipDuelistIsThinkingDelay]
	or a
	jr nz, .asm_6932
	call SetLinkDuelTransmissionFrameFunction
	call HandleWaitingLinkOpponentMenu
	ld a, [wDuelDisplayedScreen]
	cp CHECK_PLAY_AREA
	jr nz, .asm_6932
	lb de, $38, $9f
	call SetupText
.asm_6932
	call ResetDoFrameFunction_Bank1
	call SerialRecvDuelData
	ld a, OPPONENT_TURN
	ldh [hWhoseTurn], a
	ld a, [wSerialFlags]
	or a
	jp nz, DuelTransmissionError
	xor a
	ld [wSkipDuelistIsThinkingDelay], a
	ldh a, [hOppActionTableIndex]
	cp NUM_OPP_ACTIONS
	jp nc, DuelTransmissionError
	ld hl, OppActionTable
	call JumpToFunctionInTable
	ld hl, wOpponentTurnEnded
	ld a, [wDuelFinished]
	or [hl]
	jr z, .link_opp_turn_loop
	ret

; actions for the opponent's turn
; on a link duel, this is referenced by DoLinkOpponentTurn in a loop (on each opponent's HandleTurn)
; on a non-link duel (vs AI opponent), this is referenced by AIMakeDecision
OppActionTable:
	table_width 2, OppActionTable
	dw DuelTransmissionError
	dw OppAction_PlayBasicPokemonCard
	dw OppAction_EvolvePokemonCard
	dw OppAction_PlayEnergyCard
	dw OppAction_AttemptRetreat
	dw OppAction_FinishTurnWithoutAttacking
	dw OppAction_PlayTrainerCard
	dw OppAction_ExecuteTrainerCardEffectCommands
	dw OppAction_BeginUseAttack
	dw OppAction_UseAttack
	dw OppAction_PlayAttackAnimationDealAttackDamage
	dw OppAction_DrawCard
	dw OppAction_UsePokemonPower
	dw OppAction_ExecutePokemonPowerEffect
	dw OppAction_ForceSwitchActive
	dw OppAction_NoAction
	dw OppAction_NoAction
	dw OppAction_TossCoinATimes
	dw OppAction_6b30
	dw OppAction_NoAction
	dw OppAction_UseMetronomeAttack
	dw OppAction_6b15
	dw OppAction_DrawDuelMainScene
	assert_table_length NUM_OPP_ACTIONS

OppAction_DrawCard:
	call DrawCardFromDeck
	call nc, AddCardToHand
	ret

OppAction_FinishTurnWithoutAttacking:
	call DrawDuelMainScene
	call ClearNonTurnTemporaryDuelvars
	ldtx hl, FinishedTurnWithoutAttackingText
	call DrawWideTextBox_WaitForInput
	ld a, 1
	ld [wOpponentTurnEnded], a
	ret

; attach an energy card from hand to the arena or a benched Pokemon
OppAction_PlayEnergyCard:
	ldh a, [hTempPlayAreaLocation_ffa1]
	ldh [hTempPlayAreaLocation_ff9d], a
	ld e, a
	ldh a, [hTemp_ffa0]
	ldh [hTempCardIndex_ff98], a
	call PutHandCardInPlayArea
	ldh a, [hTemp_ffa0]
	call LoadCardDataToBuffer1_FromDeckIndex
	call DrawLargePictureOfCard
	call PrintAttachedEnergyToPokemon
	ld a, TRUE
	ld [wAlreadyPlayedEnergy], a
	call DrawDuelMainScene
	ret

; evolve a Pokemon card in the arena or in the bench
OppAction_EvolvePokemonCard:
	ldh a, [hTempPlayAreaLocation_ffa1]
	ldh [hTempPlayAreaLocation_ff9d], a
	ldh a, [hTemp_ffa0]
	ldh [hTempCardIndex_ff98], a
	call LoadCardDataToBuffer1_FromDeckIndex
	call DrawLargePictureOfCard
	call EvolvePokemonCardIfPossible
	call PrintPokemonEvolvedIntoPokemon
	call ProcessPlayedPokemonCard
	call DrawDuelMainScene
	ret

; place a basic Pokemon card from hand in the bench
OppAction_PlayBasicPokemonCard:
	ldh a, [hTemp_ffa0]
	ldh [hTempCardIndex_ff98], a
	call PutHandPokemonCardInPlayArea
	ldh [hTempPlayAreaLocation_ff9d], a
	add DUELVARS_ARENA_CARD_STAGE
	call GetTurnDuelistVariable
	ld [hl], 0
	ldh a, [hTemp_ffa0]
	ldtx hl, PlacedOnTheBenchText
	call DisplayCardDetailScreen
	call ProcessPlayedPokemonCard
	call DrawDuelMainScene
	ret

; attempt the retreat of the active Pokemon card
; if successful, discard the required energy cards for retreat and
; swap the retreated card with a Pokemon card from the bench
OppAction_AttemptRetreat:
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	push af
	call AttemptRetreat
	ldtx hl, RetreatWasUnsuccessfulText
	jr c, .failed
	xor a
	ld [wDuelDisplayedScreen], a
	ldtx hl, RetreatedToTheBenchText
.failed
	push hl
	call DrawDuelMainScene
	pop hl
	pop af
	push hl
	call LoadCardNameToTxRam2
	pop hl
	call DrawWideTextBox_WaitForInput_Bank1
	ret

; play trainer card from hand
OppAction_PlayTrainerCard:
	call LoadNonPokemonCardEffectCommands
	call DisplayUsedTrainerCardDetailScreen
	call PrintUsedTrainerCardDescription
	call ExchangeRNG
	ld a, $01
	ld [wSkipDuelistIsThinkingDelay], a
	ret

; execute the effect commands of the trainer card that is being played
; used only for Trainer cards, as a continuation of OppAction_PlayTrainerCard
OppAction_ExecuteTrainerCardEffectCommands:
	ld a, EFFECTCMDTYPE_DISCARD_ENERGY
	call TryExecuteEffectCommandFunction
	ld a, EFFECTCMDTYPE_BEFORE_DAMAGE
	call TryExecuteEffectCommandFunction
	call DrawDuelMainScene
	ldh a, [hTempCardIndex_ff9f]
	call MoveHandCardToDiscardPile
	call ExchangeRNG
	call DrawDuelMainScene
	ret

; begin the execution of an attack and handle the attack being
; possibly unsuccessful due to Sand Attack or Smokescreen
OppAction_BeginUseAttack:
	ldh a, [hTempCardIndex_ff9f]
	ld d, a
	ldh a, [hTemp_ffa0]
	ld e, a
	call CopyAttackDataAndDamage_FromDeckIndex
	call UpdateArenaCardIDsAndClearTwoTurnDuelVars
	ld a, $01
	ld [wSkipDuelistIsThinkingDelay], a
	call CheckSandAttackOrSmokescreenSubstatus
	jr c, .has_status
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp CONFUSED
	jr z, .has_status
	call ExchangeRNG
	ret

; we make it here is attacker is affected by
; Sand Attack, Smokescreen, or confusion
.has_status
	call DrawDuelMainScene
	call PrintPokemonsAttackText
	call WaitForWideTextBoxInput
	call ExchangeRNG
	call HandleSandAttackOrSmokescreenSubstatus
	ret nc ; return if attack is successful (won the coin toss)
	call ClearNonTurnTemporaryDuelvars
	; end the turn if the attack fails
	ld a, 1
	ld [wOpponentTurnEnded], a
	ret

; display the attack used by the opponent, and handle
; EFFECTCMDTYPE_DISCARD_ENERGY and confusion damage to self
OppAction_UseAttack:
	ld a, EFFECTCMDTYPE_DISCARD_ENERGY
	call TryExecuteEffectCommandFunction
	call CheckSelfConfusionDamage
	jr c, .confusion_damage
	call DisplayOpponentUsedAttackScreen
	call PrintPokemonsAttackText
	call WaitForWideTextBoxInput
	call ExchangeRNG
	ld a, $01
	ld [wSkipDuelistIsThinkingDelay], a
	ret
.confusion_damage
	call HandleConfusionDamageToSelf
	; end the turn if dealing damage to self due to confusion
	ld a, 1
	ld [wOpponentTurnEnded], a
	ret

OppAction_PlayAttackAnimationDealAttackDamage:
	call PlayAttackAnimation_DealAttackDamage
	ld a, 1
	ld [wOpponentTurnEnded], a
	ret

; force the player to switch the active Pokemon with a benched Pokemon
OppAction_ForceSwitchActive:
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	call SwapTurn
	call HasAlivePokemonInBench
	ld a, $01
	ld [wPlayAreaSelectAction], a
.force_selection
	call OpenPlayAreaScreenForSelection
	jr c, .force_selection
	call SwapTurn
	ldh a, [hTempPlayAreaLocation_ff9d]
	call SerialSendByte
	ret

OppAction_UsePokemonPower:
	ldh a, [hTempCardIndex_ff9f]
	ld d, a
	ld e, FIRST_ATTACK_OR_PKMN_POWER
	call CopyAttackDataAndDamage_FromDeckIndex
	ldh a, [hTemp_ffa0]
	ldh [hTempPlayAreaLocation_ff9d], a
	call DisplayUsePokemonPowerScreen
	ldh a, [hTempCardIndex_ff9f]
	call LoadCardNameToTxRam2
	ld hl, wLoadedAttackName
	ld a, [hli]
	ld [wTxRam2_b], a
	ld a, [hl]
	ld [wTxRam2_b + 1], a
	ldtx hl, WillUseThePokemonPowerText
	call DrawWideTextBox_WaitForInput_Bank1
	call ExchangeRNG
	ld a, $01
	ld [wSkipDuelistIsThinkingDelay], a
	ret

; execute the EFFECTCMDTYPE_BEFORE_DAMAGE command of the used Pokemon Power
OppAction_ExecutePokemonPowerEffect:
	call Func_7415
	ld a, EFFECTCMDTYPE_BEFORE_DAMAGE
	call TryExecuteEffectCommandFunction
	ld a, $01
	ld [wSkipDuelistIsThinkingDelay], a
	ret

; execute the EFFECTCMDTYPE_AFTER_DAMAGE command of the used Pokemon Power
OppAction_6b15:
	ld a, EFFECTCMDTYPE_AFTER_DAMAGE
	call TryExecuteEffectCommandFunction
	ld a, $01
	ld [wSkipDuelistIsThinkingDelay], a
	ret

OppAction_DrawDuelMainScene:
	call DrawDuelMainScene
	ret

OppAction_TossCoinATimes:
	call SerialRecv8Bytes
	call TossCoinATimes
	ld a, $01
	ld [wSkipDuelistIsThinkingDelay], a
	ret

OppAction_6b30:
	ldh a, [hWhoseTurn]
	push af
	ldh a, [hTemp_ffa0]
	ldh [hWhoseTurn], a
	call PlayDeckShuffleAnimation
	pop af
	ldh [hWhoseTurn], a
	ret

OppAction_UseMetronomeAttack:
	call DrawDuelMainScene
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp CONFUSED
	jr z, .asm_6b56
	call PrintPokemonsAttackText
	call .asm_6b56
	call WaitForWideTextBoxInput
	ret
.asm_6b56
	call SerialRecv8Bytes
	push bc
	call SwapTurn
	call CopyAttackDataAndDamage_FromDeckIndex
	call SwapTurn
	ldh a, [hTempCardIndex_ff9f]
	ld [wPlayerAttackingCardIndex], a
	ld a, [wSelectedAttack]
	ld [wPlayerAttackingAttackIndex], a
	ld a, [wTempCardID_ccc2]
	ld [wPlayerAttackingCardID], a
	call UpdateArenaCardIDsAndClearTwoTurnDuelVars
	pop bc
	ld a, c
	ld [wMetronomeEnergyCost], a
	ret

OppAction_NoAction:
	ret

; load the text ID of the card name with deck index given in a to TxRam2
; also loads the card to wLoadedCard1
LoadCardNameToTxRam2:
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Name]
	ld [wTxRam2], a
	ld a, [wLoadedCard1Name + 1]
	ld [wTxRam2 + 1], a
	ret

; load the text ID of the card name with deck index given in a to TxRam2_b
; also loads the card to wLoadedCard1
LoadCardNameToTxRam2_b:
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Name]
	ld [wTxRam2_b], a
	ld a, [wLoadedCard1Name + 1]
	ld [wTxRam2_b + 1], a
	ret

DrawWideTextBox_WaitForInput_Bank1:
	call DrawWideTextBox_WaitForInput
	ret

Func_6ba2:
	call DrawWideTextBox_PrintText
	ld a, [wDuelistType]
	cp DUELIST_TYPE_LINK_OPP
	ret z
	call WaitForWideTextBoxInput
	ret

; apply and/or refresh status conditions and other events that trigger between turns
HandleBetweenTurnsEvents:
	call IsArenaPokemonAsleepOrPoisoned
	jr c, .something_to_handle
	cp PARALYZED
	jr z, .something_to_handle
	call SwapTurn
	call IsArenaPokemonAsleepOrPoisoned
	call SwapTurn
	jr c, .something_to_handle
	call DiscardAttachedPluspowers
	call SwapTurn
	call DiscardAttachedDefenders
	call SwapTurn
	ret

.something_to_handle
	; either:
	; 1. turn holder's arena Pokemon is paralyzed, asleep, poisoned or double poisoned
	; 2. non-turn holder's arena Pokemon is asleep, poisoned or double poisoned
	call ResetAnimationQueue
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	ld a, BOXMSG_BETWEEN_TURNS
	call DrawDuelBoxMessage
	ldtx hl, BetweenTurnsText
	call DrawWideTextBox_WaitForInput

	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	ld l, DUELVARS_ARENA_CARD_STATUS
	ld a, [hl]
	or a
	jr z, .discard_pluspower
	; has status condition
	call HandlePoisonDamage
	jr c, .discard_pluspower
	call HandleSleepCheck
	ld a, [hl]
	and CNF_SLP_PRZ
	cp PARALYZED
	jr nz, .discard_pluspower
	; heal paralysis
	ld a, DOUBLE_POISONED
	and [hl]
	ld [hl], a
	call RedrawTurnDuelistsMainSceneOrDuelHUD
	ldtx hl, IsCuredOfParalysisText
	call PrintCardNameFromCardIDInTextBox
	ld a, DUEL_ANIM_HEAL
	call PlayBetweenTurnsAnimation
	call WaitForWideTextBoxInput

.discard_pluspower
	call DiscardAttachedPluspowers
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	ld l, DUELVARS_ARENA_CARD_STATUS
	ld a, [hl]
	or a
	jr z, .asm_6c3a
	call HandlePoisonDamage
	jr c, .asm_6c3a
	call HandleSleepCheck
.asm_6c3a
	call DiscardAttachedDefenders
	call SwapTurn
	call HandleBetweenTurnKnockOuts
	ret

; discard any PLUSPOWER attached to the turn holder's arena and/or bench Pokemon
DiscardAttachedPluspowers:
	ld a, DUELVARS_ARENA_CARD_ATTACHED_PLUSPOWER
	call GetTurnDuelistVariable
	ld e, MAX_PLAY_AREA_POKEMON
	xor a
.unattach_pluspower_loop
	ld [hli], a
	dec e
	jr nz, .unattach_pluspower_loop
	ld de, PLUSPOWER
	jp MoveCardToDiscardPileIfInPlayArea

; discard any DEFENDER attached to the turn holder's arena and/or bench Pokemon
DiscardAttachedDefenders:
	ld a, DUELVARS_ARENA_CARD_ATTACHED_DEFENDER
	call GetTurnDuelistVariable
	ld e, MAX_PLAY_AREA_POKEMON
	xor a
.unattach_defender_loop
	ld [hli], a
	dec e
	jr nz, .unattach_defender_loop
	ld de, DEFENDER
	jp MoveCardToDiscardPileIfInPlayArea

; return carry if the turn holder's arena Pokemon card is asleep, poisoned, or double poisoned.
; also, if confused, paralyzed, or asleep, return the status condition in a.
IsArenaPokemonAsleepOrPoisoned:
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	or a
	ret z
	; note that POISONED | DOUBLE_POISONED is the same as just DOUBLE_POISONED ($c0)
	; poison status masking is normally done with PSN_DBLPSN ($f0)
	and POISONED | DOUBLE_POISONED
	jr nz, .set_carry
	ld a, [hl]
	and CNF_SLP_PRZ
	cp ASLEEP
	jr z, .set_carry
	or a
	ret
.set_carry
	scf
	ret

RedrawTurnDuelistsMainSceneOrDuelHUD:
	ld a, [wDuelDisplayedScreen]
	cp DUEL_MAIN_SCENE
	jr z, RedrawTurnDuelistsDuelHUD
	ld hl, wWhoseTurn
	ldh a, [hWhoseTurn]
	cp [hl]
	jp z, DrawDuelMainScene
	call SwapTurn
	call DrawDuelMainScene
	call SwapTurn
	ret

RedrawTurnDuelistsDuelHUD:
	ld hl, wWhoseTurn
	ldh a, [hWhoseTurn]
	cp [hl]
	jp z, DrawDuelHUDs
	call SwapTurn
	call DrawDuelHUDs
	call SwapTurn
	ret

; input:
;	a = animation ID
PlayBetweenTurnsAnimation:
	push af
	ld a, [wDuelType]
	or a
	jr nz, .store_duelist_turn
	ld a, [wWhoseTurn]
	cp PLAYER_TURN
	jr z, .store_duelist_turn
	call SwapTurn
	ldh a, [hWhoseTurn]
	ld [wDuelAnimDuelistSide], a
	call SwapTurn
	jr .asm_6ccb

.store_duelist_turn
	ldh a, [hWhoseTurn]
	ld [wDuelAnimDuelistSide], a

.asm_6ccb
	xor a
	ld [wDuelAnimLocationParam], a
	ld a, DUEL_ANIM_SCREEN_MAIN_SCENE
	ld [wDuelAnimationScreen], a
	pop af

; play animation
	call PlayDuelAnimation
.loop_anim
	call DoFrame
	call CheckAnyAnimationPlaying
	jr c, .loop_anim
	call RedrawTurnDuelistsDuelHUD
	ret

; prints the name of the card at wTempNonTurnDuelistCardID in a text box
PrintCardNameFromCardIDInTextBox:
	push hl
	ld a, [wTempNonTurnDuelistCardID]
	ld e, a
	call LoadCardDataToBuffer1_FromCardID
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	pop hl
	call DrawWideTextBox_PrintText
	ret

; handles the sleep check for the NonTurn Duelist
; heals sleep status if coin is heads, else
; it plays sleeping animation
HandleSleepCheck:
	ld a, [hl]
	and CNF_SLP_PRZ
	cp ASLEEP
	ret nz ; quit if not asleep

	push hl
	ld a, [wTempNonTurnDuelistCardID]
	ld e, a
	call LoadCardDataToBuffer1_FromCardID
	ld a, 18
	call CopyCardNameAndLevel
	ld [hl], TX_END
	ld hl, wTxRam2
	xor a
	ld [hli], a
	ld [hl], a
	ldtx de, PokemonsSleepCheckText
	call TossCoin
	ld a, DUEL_ANIM_SLEEP
	ldtx hl, IsStillAsleepText
	jr nc, .tails

; coin toss was heads, cure sleep status
	pop hl
	push hl
	ld a, DOUBLE_POISONED
	and [hl]
	ld [hl], a
	ld a, DUEL_ANIM_HEAL
	ldtx hl, IsCuredOfSleepText

.tails
	push af
	push hl
	call RedrawTurnDuelistsMainSceneOrDuelHUD
	pop hl
	call PrintCardNameFromCardIDInTextBox
	pop af
	call PlayBetweenTurnsAnimation
	pop hl
	call WaitForWideTextBoxInput
	ret

HandlePoisonDamage:
	or a
	bit POISONED_F , [hl]
	ret z ; quit if not poisoned

; load damage and text according to normal/double poison
	push hl
	bit DOUBLE_POISONED_F, [hl]
	ld a, PSN_DAMAGE
	ldtx hl, Received10DamageDueToPoisonText
	jr z, .not_double_poisoned
	ld a, DBLPSN_DAMAGE
	ldtx hl, Received20DamageDueToPoisonText

.not_double_poisoned
	push af
	ld [wDuelAnimDamage + 0], a
	xor a
	ld [wDuelAnimDamage + 1], a

	push hl
	call RedrawTurnDuelistsMainSceneOrDuelHUD
	pop hl
	call PrintCardNameFromCardIDInTextBox

; play animation
	ld a, DUEL_ANIM_POISON
	call PlayBetweenTurnsAnimation
	pop af

; deal poison damage
	ld e, a
	ld d, $00
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	call SubtractHP
	push hl
	ld a, $8c
	call PlayBetweenTurnsAnimation
	pop hl

	call PrintKnockedOutIfHLZero
	push af
	call WaitForWideTextBoxInput
	pop af
	pop hl
	ret

; given the deck index of a turn holder's card in register a,
; and a pointer in hl to the wLoadedCard* buffer where the card data is loaded,
; check if the card is Clefairy Doll or Mysterious Fossil, and, if so, convert it
; to a Pokemon card in the wLoadedCard* buffer, using .trainer_to_pkmn_data.
ConvertSpecialTrainerCardToPokemon::
	ld c, a
	ld a, [hl]
	cp TYPE_TRAINER
	ret nz ; return if the card is not TRAINER type
	push hl
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, c
	ld a, [hl]
	and CARD_LOCATION_PLAY_AREA
	pop hl
	ret z ; return if the card is not in the arena or bench
	ld a, e
	cp MYSTERIOUS_FOSSIL
	jr nz, .check_for_clefairy_doll
	ld a, d
	cp $00 ; MYSTERIOUS_FOSSIL >> 8
	jr z, .start_ram_data_overwrite
	ret
.check_for_clefairy_doll
	cp CLEFAIRY_DOLL
	ret nz
	ld a, d
	cp $00 ; CLEFAIRY_DOLL >> 8
	ret nz
.start_ram_data_overwrite
	push de
	ld [hl], TYPE_PKMN_COLORLESS
	ld bc, CARD_DATA_HP
	add hl, bc
	ld de, .trainer_to_pkmn_data
	ld c, CARD_DATA_AI_INFO - CARD_DATA_HP
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop de
	ret

.trainer_to_pkmn_data
	db 10                 ; CARD_DATA_HP
	ds $07                ; CARD_DATA_ATTACK1_NAME - (CARD_DATA_HP + 1)
	tx DiscardName        ; CARD_DATA_ATTACK1_NAME
	tx DiscardDescription ; CARD_DATA_ATTACK1_DESCRIPTION
	ds $03                ; CARD_DATA_ATTACK1_CATEGORY - (CARD_DATA_ATTACK1_DESCRIPTION + 2)
	db POKEMON_POWER      ; CARD_DATA_ATTACK1_CATEGORY
	dw TrainerCardAsPokemonEffectCommands ; CARD_DATA_ATTACK1_EFFECT_COMMANDS
	ds $18                ; CARD_DATA_RETREAT_COST - (CARD_DATA_ATTACK1_EFFECT_COMMANDS + 2)
	db UNABLE_RETREAT     ; CARD_DATA_RETREAT_COST
	ds $0d                ; PKMN_CARD_DATA_LENGTH - (CARD_DATA_RETREAT_COST + 1)

; this function applies all status conditions in order
; that have been added to the wStatusConditionQueue
; return carry if any status conditions were applied
; and the defending Pokemon didn't have "No Damage or Effect" status
ApplyStatusConditionQueue::
	xor a
	ld [wPlayerArenaCardLastTurnStatus], a
	ld [wOpponentArenaCardLastTurnStatus], a
	ld hl, wStatusConditionQueueIndex
	ld a, [hl]
	or a
	ret z
	ld e, [hl]
	ld d, $00
	ld hl, wStatusConditionQueue
	add hl, de
	ld [hl], $00 ; terminator byte
	call CheckNoDamageOrEffect
	jr c, .no_damage_or_effect

; apply all status conditions unconditionally
	ld hl, wStatusConditionQueue
.apply_status_loop
	ld a, [hli]
	or a
	jr z, .done_apply_all
	ld d, a ; which duelist side
	call ApplyStatusConditionToArenaPokemon
	jr .apply_status_loop
.done_apply_all
	scf
	ret

.no_damage_or_effect
	ld a, l
	or h
	call nz, DrawWideTextBox_PrintText

; if no damage or effect to defending Pokemon,
; we will just apply the conditions to turn duelist's Pokemon
	ld hl, wStatusConditionQueue
.apply_own_status_loop
	ld a, [hli]
	or a
	jr z, .done_apply_own
	ld d, a
	ld a, [wWhoseTurn]
	cp d
	jr z, .apply_own_condition
	inc hl
	inc hl
	jr .apply_own_status_loop
.apply_own_condition
	call ApplyStatusConditionToArenaPokemon
	jr .apply_own_status_loop
.done_apply_own
	ret

; apply the status condition at hl+1 to the arena Pokemon
; discard the arena Pokemon's status conditions contained in the bitmask at hl
ApplyStatusConditionToArenaPokemon:
	ld e, DUELVARS_ARENA_CARD_STATUS
	ld a, [de]
	and [hl]
	inc hl
	or [hl]
	ld [de], a
	dec hl
	ld e, DUELVARS_ARENA_CARD_LAST_TURN_STATUS
	ld a, [de]
	and [hl]
	inc hl
	or [hl]
	inc hl
	ld [de], a
	ret

HandleDestinyBondAndBetweenTurnKnockOuts::
	call HandleDestinyBondSubstatus
	; fallthrough

HandleBetweenTurnKnockOuts:
	call .ClearDamageReductionSubstatus2OfKnockedOutPokemon
	xor a
	ld [wDuelFinishParam], a
	call SwapTurn
	call .Func_6ef6
	call SwapTurn
	ld a, [wDuelFinishParam]
	or a
	jr z, .asm_6e86
	call CheckIfTurnDuelistPlayAreaPokemonAreAllKnockedOut
	jr c, .asm_6e86
	call CountKnockedOutPokemon
	ld c, a
	call SwapTurn
	call CountPrizes
	call SwapTurn
	dec a
	cp c
	jr c, .asm_6e86
	ld a, c
	call SwapTurn
	call TakeAPrizes
	call SwapTurn
	ld a, TURN_PLAYER_WON
	jr .set_duel_finished
.asm_6e86
	call .Func_6ef6
	ld a, [wDuelFinishParam]
	cp TRUE
	jr nz, .asm_6e9f
	call SwapTurn
	call CheckIfTurnDuelistPlayAreaPokemonAreAllKnockedOut
	call SwapTurn
	jr c, .asm_6e9f
	ld a, TURN_PLAYER_LOST
	jr .set_duel_finished
.asm_6e9f
	call SwapTurn
	call .Func_6eff
	call SwapTurn
	call .Func_6eff
	ld a, [wDuelFinishParam]
	or a
	jr nz, .asm_6ec4
	xor a
.asm_6eb2
	push af
	call MoveAllTurnHolderKnockedOutPokemonToDiscardPile
	call SwapTurn
	call MoveAllTurnHolderKnockedOutPokemonToDiscardPile
	call SwapTurn
	call ShiftAllPokemonToFirstPlayAreaSlots
	pop af
	ret

.asm_6ec4
	ld e, a
	ld d, $00
	ld hl, .Data_6ed2
	add hl, de
	ld a, [hl]
.set_duel_finished
	ld [wDuelFinished], a
	scf
	jr .asm_6eb2

.Data_6ed2:
	db DUEL_NOT_FINISHED, TURN_PLAYER_LOST, TURN_PLAYER_WON,  TURN_PLAYER_TIED
	db TURN_PLAYER_LOST,  TURN_PLAYER_LOST, TURN_PLAYER_TIED, TURN_PLAYER_LOST
	db TURN_PLAYER_WON,   TURN_PLAYER_TIED, TURN_PLAYER_WON,  TURN_PLAYER_WON
	db TURN_PLAYER_TIED,  TURN_PLAYER_LOST, TURN_PLAYER_WON,  TURN_PLAYER_TIED

; clears SUBSTATUS2_REDUCE_BY_20, SUBSTATUS2_POUNCE, SUBSTATUS2_GROWL,
; SUBSTATUS2_TAIL_WAG, and SUBSTATUS2_LEER for each arena Pokemon with 0 HP
.ClearDamageReductionSubstatus2OfKnockedOutPokemon:
	call SwapTurn
	call .clear
	call SwapTurn
.clear
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	or a
	ret nz
	call ClearDamageReductionSubstatus2
	ret

.Func_6ef6:
	call Func_6fa5
	ld hl, wDuelFinishParam
	rl [hl]
	ret

.Func_6eff:
	call ReplaceKnockedOutPokemon
	ld hl, wDuelFinishParam
	rl [hl]
	ret

; for each Pokemon in the turn holder's play area (arena and bench),
; move that card to the discard pile if its HP is 0
MoveAllTurnHolderKnockedOutPokemonToDiscardPile:
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld l, DUELVARS_ARENA_CARD_HP
	ld e, PLAY_AREA_ARENA
.loop
	ld a, [hl]
	or a
	jr nz, .next
	push hl
	push de
	call MovePlayAreaCardToDiscardPile
	pop de
	pop hl
.next
	inc hl
	inc e
	dec d
	jr nz, .loop
	ret

; have the turn holder replace the arena Pokemon card when it's been knocked out.
; if there are no Pokemon cards in the turn holder's bench, return carry.
ReplaceKnockedOutPokemon:
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	ret nz
	call ClearAllStatusConditions
	call HasAlivePokemonInBench
	jr nc, .can_replace_pokemon

; if we made it here, the duelist can't replace the knocked out Pokemon
	bank1call DrawDuelMainScene
	ldtx hl, ThereAreNoPokemonInPlayAreaText
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	scf
	ret

.can_replace_pokemon
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr nz, .opponent

; prompt the player to replace the knocked out Pokemon with one from bench
	bank1call DrawDuelMainScene
	ldtx hl, SelectPokemonToPlaceInTheArenaText
	call DrawWideTextBox_WaitForInput
	ld a, $01
	ld [wPlayAreaSelectAction], a
	ld a, PRACTICEDUEL_PLAY_STARYU_FROM_BENCH
	call DoPracticeDuelAction
.select_pokemon
	call OpenPlayAreaScreenForSelection
	jr c, .select_pokemon
	ldh a, [hTempPlayAreaLocation_ff9d]
	call SerialSend8Bytes

; replace the arena Pokemon with the one at location [hTempPlayAreaLocation_ff9d]
.replace_pokemon
	call FinishQueuedAnimations
	ld a, PRACTICEDUEL_REPLACE_KNOCKED_OUT_POKEMON
	call DoPracticeDuelAction
	jr c, .select_pokemon
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld d, a
	ld e, PLAY_AREA_ARENA
	call SwapPlayAreaPokemon
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldtx hl, DuelistPlacedACardText
	bank1call DisplayCardDetailScreen
	call ExchangeRNG
	or a
	ret

; the AI opponent replaces the knocked out Pokemon with one from bench
.opponent
	cp DUELIST_TYPE_LINK_OPP
	jr z, .link_opponent
	call AIDoAction_KOSwitch
	ldh a, [hTemp_ffa0]
	ldh [hTempPlayAreaLocation_ff9d], a
	jr .replace_pokemon

; wait for link opponent to replace the knocked out Pokemon with one from bench
.link_opponent
	bank1call DrawDuelMainScene
	ldtx hl, DuelistIsSelectingPokemonToPlaceInArenaText
	call DrawWideTextBox_PrintText
	call SerialRecv8Bytes
	ldh [hTempPlayAreaLocation_ff9d], a
	jr .replace_pokemon

Func_6fa5:
	call CountKnockedOutPokemon
	ret nc
	; at least one Pokemon knocked out
	call SwapTurn
	bank1call TurnDuelistTakePrizes
	call SwapTurn
	ret nc
	call SwapTurn
	bank1call DrawDuelMainScene
	ldtx hl, TookAllThePrizesText
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	call SwapTurn
	scf
	ret

; return in wNumberPrizeCardsToTake the amount of Pokemon in the turn holder's
; play area that are still there despite having 0 HP.
; that is, the number of Pokemon that have just been knocked out.
; Clefairy Doll and Mysterious Fossil don't count.
CountKnockedOutPokemon:
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld d, h
	ld e, DUELVARS_ARENA_CARD
	ld b, PLAY_AREA_ARENA
	ld c, MAX_PLAY_AREA_POKEMON
.loop
	ld a, [de]
	cp -1
	jr z, .next ; jump if no Pokemon in this location
	ld a, [hl]
	or a
	jr nz, .next ; jump if this Pokemon's HP isn't 0
	; this Pokemon's HP has just become 0
	ld a, [de]
	push de
	call GetCardIDFromDeckIndex
	call GetCardType
	pop de
	cp TYPE_TRAINER
	jr z, .next ; jump if this is a trainer card (Clefairy Doll or Mysterious Fossil)
	inc b
.next
	inc hl
	inc de
	dec c
	jr nz, .loop
	ld a, b
	ld [wNumberPrizeCardsToTake], a
	or a
	ret z
	scf
	ret

; returns carry if turn duelist has no Play Area Pokémon
; with non-zero HP, that is, all Pokémon are knocked out
CheckIfTurnDuelistPlayAreaPokemonAreAllKnockedOut:
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld l, DUELVARS_ARENA_CARD_HP
.loop
	ld a, [hli]
	or a
	jr nz, .non_zero_hp
	dec c
	jr nz, .loop
	scf
	ret
.non_zero_hp
	or a
	ret

; print one of the "There was no effect from" texts depending
; on the value at wNoEffectFromWhichStatus (NO_STATUS or a status condition constant)
PrintThereWasNoEffectFromStatusText::
	ld a, [wNoEffectFromWhichStatus]
	or a
	jr nz, .status
	ld hl, wLoadedAttackName
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, ThereWasNoEffectFromTxRam2Text
	ret
.status
	ld c, a
	ldtx hl, ThereWasNoEffectFromPoisonConfusionText
	cp POISONED | CONFUSED
	ret z
	and PSN_DBLPSN
	jr nz, .poison
	ld a, c
	and CNF_SLP_PRZ
	ldtx hl, ThereWasNoEffectFromParalysisText
	cp PARALYZED
	ret z
	ldtx hl, ThereWasNoEffectFromSleepText
	cp ASLEEP
	ret z
	ldtx hl, ThereWasNoEffectFromConfusionText
	ret
.poison
	ldtx hl, ThereWasNoEffectFromPoisonText
	cp POISONED
	ret z
	ldtx hl, ThereWasNoEffectFromToxicText
	ret

; returns carry if card at hTempPlayAreaLocation_ff9d
; is a basic card.
; otherwise, lists the card indices of all stages in
; that card location, and returns the card one
; stage below.
; input:
;	hTempPlayAreaLocation_ff9d = play area location to check;
; output:
;	a = card index in hTempPlayAreaLocation_ff9d;
;	d = card index of card one stage below;
;	carry set if card is a basic card.
GetCardOneStageBelow:
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Stage]
	or a
	jr nz, .not_basic
	scf
	ret

.not_basic
	ld hl, wAllStagesIndices
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

; loads deck indices of the stages present in hTempPlayAreaLocation_ff9d.
; the three stages are loaded consecutively in wAllStagesIndices.
	ldh a, [hTempPlayAreaLocation_ff9d]
	or CARD_LOCATION_PLAY_AREA
	ld c, a
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.loop
	ld a, [hl]
	cp c
	jr nz, .next
	ld a, l
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	cp TYPE_ENERGY
	jr nc, .next
	ld b, l
	push hl
	ld a, [wLoadedCard2Stage]
	ld e, a
	ld d, $00
	ld hl, wAllStagesIndices
	add hl, de
	ld [hl], b
	pop hl
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop

; if card at hTempPlayAreaLocation_ff9d is a stage 1, load d with basic card.
; otherwise if stage 2, load d with the stage 1 card.
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_STAGE
	call GetTurnDuelistVariable
	ld hl, wAllStagesIndices ; pointing to basic
	cp STAGE1
	jr z, .done
	; if stage1 was skipped, hl should point to Basic stage card
	cp STAGE2_WITHOUT_STAGE1
	jr z, .done
	inc hl ; pointing to stage 1
.done
	ld d, [hl]
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld e, a
	or a
	ret

; initializes variables when a duel begins, such as zeroing wDuelFinished or wDuelTurns,
; and setting wDuelType based on wPlayerDuelistType and wOpponentDuelistType
InitVariablesToBeginDuel:
	xor a
	ld [wDuelFinished], a
	ld [wDuelTurns], a
	ld [wcce7], a
	ld a, $ff
	ld [wcc0f], a
	ld [wPlayerAttackingCardIndex], a
	ld [wPlayerAttackingAttackIndex], a
	call EnableSRAM
	ld a, [sSkipDelayAllowed]
	ld [wSkipDelayAllowed], a
	call DisableSRAM
	ld a, [wPlayerDuelistType]
	cp DUELIST_TYPE_LINK_OPP
	jr z, .set_duel_type
	bit 7, a ; DUELIST_TYPE_AI_OPP
	jr nz, .set_duel_type
	ld a, [wOpponentDuelistType]
	cp DUELIST_TYPE_LINK_OPP
	jr z, .set_duel_type
	bit 7, a ; DUELIST_TYPE_AI_OPP
	jr nz, .set_duel_type
	xor a
.set_duel_type
	ld [wDuelType], a
	ret

; init variables that last a single player's turn
InitVariablesToBeginTurn:
	xor a
	ld [wAlreadyPlayedEnergy], a
	ld [wConfusionRetreatCheckWasUnsuccessful], a
	ld [wGotHeadsFromSandAttackOrSmokescreenCheck], a
	ldh a, [hWhoseTurn]
	ld [wWhoseTurn], a
	ret

; make all Pokemon in the turn holder's play area able to evolve. called from the
; player's second turn on, in order to allow evolution of all Pokemon already played.
SetAllPlayAreaPokemonCanEvolve:
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld l, DUELVARS_ARENA_CARD_FLAGS
.next_pkmn_loop
	res USED_PKMN_POWER_THIS_TURN_F, [hl]
	set CAN_EVOLVE_THIS_TURN_F, [hl]
	inc l
	dec c
	jr nz, .next_pkmn_loop
	ret

; initializes duel variables such as cards in deck and in hand, or Pokemon in play area
; player turn: [c200, c2ff]
; opponent turn: [c300, c3ff]
InitializeDuelVariables:
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
	ld c, MAX_PLAY_AREA_POKEMON + 1
.init_play_area
; initialize to $ff card in arena as well as cards in bench (plus a terminator)
	ld [hl], -1
	inc l
	dec c
	jr nz, .init_play_area
	ret

; draw [wDuelInitialPrizes] cards from the turn holder's deck and place them as prizes:
; write their deck indexes to DUELVARS_PRIZE_CARDS, set their location to
; CARD_LOCATION_PRIZE, and set [wDuelInitialPrizes] bits of DUELVARS_PRIZES.
InitTurnDuelistPrizes:
	ldh a, [hWhoseTurn]
	ld d, a
	ld e, DUELVARS_PRIZE_CARDS
	ld a, [wDuelInitialPrizes]
	ld c, a
	ld b, 0
.draw_prizes_loop
	call DrawCardFromDeck
	ld [de], a
	inc de
	ld h, d
	ld l, a
	ld [hl], CARD_LOCATION_PRIZE
	inc b
	ld a, b
	cp c
	jr nz, .draw_prizes_loop
	push hl
	ld e, c
	ld d, $00
	ld hl, PrizeBitmasks
	add hl, de
	ld a, [hl]
	pop hl
	ld l, DUELVARS_PRIZES
	ld [hl], a
	ret

PrizeBitmasks:
	db %0, %1, %11, %111, %1111, %11111, %111111

; update the turn holder's DUELVARS_PRIZES following that duelist
; drawing a number of prizes equal to register a
TakeAPrizes:
	or a
	ret z
	ld c, a
	call CountPrizes
	sub c
	jr nc, .no_underflow
	xor a
.no_underflow
	ld c, a
	ld b, $00
	ld hl, PrizeBitmasks
	add hl, bc
	ld b, [hl]
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	ld [hl], b
	ret

; clear the non-turn holder's duelvars starting at DUELVARS_ARENA_CARD_DISABLED_ATTACK_INDEX
; these duelvars only last a two-player turn at most.
ClearNonTurnTemporaryDuelvars::
	ld a, DUELVARS_ARENA_CARD_DISABLED_ATTACK_INDEX
	call GetNonTurnDuelistVariable
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

; same as ClearNonTurnTemporaryDuelvars, except the non-turn holder's arena
; Pokemon status condition is copied to wccc5
ClearNonTurnTemporaryDuelvars_CopyStatus::
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	ld [wccc5], a
	call ClearNonTurnTemporaryDuelvars
	ret

; update non-turn holder's DUELVARS_ARENA_CARD_LAST_TURN_DAMAGE
; if wDefendingWasForcedToSwitch == 0: set to [wDealtDamage]
; if wDefendingWasForcedToSwitch != 0: set to 0
UpdateArenaCardLastTurnDamage::
	ld a, DUELVARS_ARENA_CARD_LAST_TURN_DAMAGE
	call GetNonTurnDuelistVariable
	ld a, [wDefendingWasForcedToSwitch]
	or a
	jr nz, .zero
	ld a, [wDealtDamage]
	ld [hli], a
	ld a, [wDealtDamage + 1]
	ld [hl], a
	ret
.zero
	xor a
	ld [hli], a
	ld [hl], a
	ret

_TossCoin::
	ld [wCoinTossTotalNum], a
	ld a, [wDuelDisplayedScreen]
	cp COIN_TOSS
	jr z, .print_text
	xor a
	ld [wCoinTossNumTossed], a
	call EmptyScreen
	call LoadDuelCoinTossResultTiles

.print_text
; no need to print text if this is not the first coin toss
	ld a, [wCoinTossNumTossed]
	or a
	jr nz, .clear_text_pointer
	ld a, COIN_TOSS
	ld [wDuelDisplayedScreen], a
	lb de, 0, 12
	lb bc, 20, 6
	ld hl, $0000
	call DrawLabeledTextBox
	call EnableLCD
	lb de, 1, 14
	ld a, 19
	call InitTextPrintingInTextbox
	ld hl, wCoinTossScreenTextID
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText

.clear_text_pointer
	ld hl, wCoinTossScreenTextID
	xor a
	ld [hli], a
	ld [hl], a

; store duelist type and reset number of heads
	call EnableLCD
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld [wCoinTossDuelistType], a
	call ExchangeRNG
	xor a
	ld [wCoinTossNumHeads], a

.print_coin_tally
; skip printing text if it's only one coin toss
	ld a, [wCoinTossTotalNum]
	cp 2
	jr c, .asm_7223

; write "#coin/#total coins"
	lb bc, 15, 11
	ld a, [wCoinTossNumTossed]
	inc a ; current coin number is wCoinTossNumTossed + 1
	call WriteTwoDigitNumberInTxSymbolFormat
	ld b, 17
	ld a, SYM_SLASH
	call WriteByteToBGMap0
	inc b
	ld a, [wCoinTossTotalNum]
	call WriteTwoDigitNumberInTxSymbolFormat

.asm_7223
	call ResetAnimationQueue
	ld a, DUEL_ANIM_COIN_SPIN
	call PlayDuelAnimation

	ld a, [wCoinTossDuelistType]
	or a
	jr z, .asm_7236
	call Func_7324
	jr .asm_723c

.asm_7236
	call WaitForWideTextBoxInput
	call Func_72ff

.asm_723c
	call ResetAnimationQueue
	ld d, DUEL_ANIM_COIN_TOSS2
	ld e, $0 ; tails
	call UpdateRNGSources
	rra
	jr c, .got_result
	ld d, DUEL_ANIM_COIN_TOSS1
	ld e, $1 ; heads

.got_result
; already decided on coin toss result,
; load the correct tossing animation
; and wait for it to finish
	ld a, d
	call PlayDuelAnimation
	ld a, [wCoinTossDuelistType]
	or a
	jr z, .wait_anim
	ld a, e
	call Func_7310
	ld e, a
	jr .done_toss_anim
.wait_anim
	push de
	call DoFrame
	call CheckAnyAnimationPlaying
	pop de
	jr c, .wait_anim
	ld a, e
	call Func_72ff

.done_toss_anim
	ld b, DUEL_ANIM_COIN_HEADS
	ld c, $34 ; tile for cross
	ld a, e
	or a
	jr z, .show_result
	ld b, DUEL_ANIM_COIN_TAILS
	ld c, $30 ; tile for circle
	ld hl, wCoinTossNumHeads
	inc [hl]

.show_result
	ld a, b
	call PlayDuelAnimation

; load correct sound effect
; the sound of the coin toss result
; is dependant on whether it was the Player
; or the Opponent to get heads/tails
	ld a, [wCoinTossDuelistType]
	or a
	jr z, .check_sfx
	ld a, $1
	xor e ; invert result in case it's not Player
	ld e, a
.check_sfx
	ld d, SFX_COIN_TOSS_HEADS
	ld a, e
	or a
	jr nz, .got_sfx
	ld d, SFX_COIN_TOSS_TAILS
.got_sfx
	ld a, d
	call PlaySFX

; in case it's a multiple coin toss scenario,
; then the result needs to be registered on screen
; with a circle (o) or a cross (x)
	ld a, [wCoinTossTotalNum]
	dec a
	jr z, .incr_num_coin_tossed ; skip if not more than 1 coin toss
	ld a, c
	push af
	ld e, 0
	ld a, [wCoinTossNumTossed]
; calculate the offset to draw the circle/cross
.asm_72a3
	; if < 10, then the offset is simply calculated
	; from wCoinTossNumTossed * 2...
	cp 10
	jr c, .got_offset
	; ...else the y-offset is added for each multiple of 10
	inc e
	inc e
	sub 10
	jr .asm_72a3

.got_offset
	add a
	ld d, a
	lb bc, 2, 2
	lb hl, 1, 2
	pop af
	call FillRectangle

.incr_num_coin_tossed
	ld hl, wCoinTossNumTossed
	inc [hl]

	ld a, [wCoinTossDuelistType]
	or a
	jr z, .asm_72dc
	ld a, [hl]
	ld hl, wCoinTossTotalNum
	cp [hl]
	call z, WaitForWideTextBoxInput
	call Func_7324
	ld a, [wCoinTossTotalNum]
	ld hl, wCoinTossNumHeads
	or [hl]
	jr nz, .asm_72e2
	call z, WaitForWideTextBoxInput
	jr .asm_72e2

.asm_72dc
	call WaitForWideTextBoxInput
	call Func_72ff

.asm_72e2
	call FinishQueuedAnimations
	ld a, [wCoinTossNumTossed]
	ld hl, wCoinTossTotalNum
	cp [hl]
	jp c, .print_coin_tally
	call ExchangeRNG
	call FinishQueuedAnimations
	call ResetAnimationQueue

; return carry if at least 1 heads
	ld a, [wCoinTossNumHeads]
	or a
	ret z
	scf
	ret

Func_72ff:
	ldh [hff96], a
	ld a, [wDuelType]
	cp DUELTYPE_LINK
	ret nz
	ldh a, [hff96]
	call SerialSendByte
	call Func_7344
	ret

Func_7310:
	ldh [hff96], a
	ld a, [wDuelType]
	cp DUELTYPE_LINK
	jr z, Func_7338
.loop_anim
	call DoFrame
	call CheckAnyAnimationPlaying
	jr c, .loop_anim
	ldh a, [hff96]
	ret

Func_7324:
	ldh [hff96], a
	ld a, [wDuelType]
	cp DUELTYPE_LINK
	jr z, Func_7338

; delay coin flip for AI opponent
	ld a, 30
.asm_732f
	call DoFrame
	dec a
	jr nz, .asm_732f
	ldh a, [hff96]
	ret

Func_7338:
	call DoFrame
	call SerialRecvByte
	jr c, Func_7338
	call Func_7344
	ret

Func_7344:
	push af
	ld a, [wSerialFlags]
	or a
	jr nz, .asm_734d
	pop af
	ret
.asm_734d
	call FinishQueuedAnimations
	call DuelTransmissionError
	ret

BuildVersion:
	db "VER 12/20 09:36", TX_END

; possibly unreferenced, used for testing
; enters computer opponent selection screen
; handles input to select/cancel/scroll through deck IDs
; loads the NPC duel configurations if one was selected
; returns carry if selection was cancelled
Func_7364:
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadSymbolsFont
	lb de, $38, $9f
	call SetupText
	call DrawWideTextBox
	call EnableLCD

	xor a
	ld [wOpponentDeckID], a
	call DrawOpponentSelectionScreen
.wait_input
	call DoFrame
	ldh a, [hDPadHeld]
	or a
	jr z, .wait_input
	ld b, a

	; handle selection/cancellation buttons
	and A_BUTTON | START
	jr nz, .select_opp
	bit B_BUTTON_F, b
	jr nz, .cancel

; handle D-pad inputs
; check right
	ld a, [wOpponentDeckID]
	bit D_RIGHT_F, b
	jr z, .check_left
	inc a ; next deck ID
	cp NUM_DECK_IDS
	jr c, .check_left
	xor a ; wrap around to first deck ID

.check_left
	bit D_LEFT_F, b
	jr z, .check_up
	or a
	jr nz, .not_first_deck_id
	ld a, NUM_DECK_IDS - 1 ; wrap around to last deck ID
	jr .check_up
.not_first_deck_id
	dec a ; previous deck ID

.check_up
	bit D_UP_F, b
	jr z, .check_down
	add 10
	cp NUM_DECK_IDS
	jr c, .check_down
	xor a ; wrap around to first deck ID

.check_down
	bit D_DOWN_F, b
	jr z, .got_deck_id
	sub 10
	jr nc, .got_deck_id
	ld a, NUM_DECK_IDS - 1; wrap around to last deck ID

.got_deck_id
	ld [wOpponentDeckID], a
	call DrawOpponentSelectionScreen
	jr .wait_input

.cancel
	scf
	ret
.select_opp
	ld a, [wOpponentDeckID]
	ld [wNPCDuelDeckID], a
	call GetNPCDuelConfigurations
	or a
	ret

; draws the current opponent to be selected
; (his/her portrait and name)
; and prints text box for selection
DrawOpponentSelectionScreen:
	ld a, [wOpponentDeckID]
	ld [wNPCDuelDeckID], a
	call GetNPCDuelConfigurations
	jr c, .ok
	; duel configuration not found for the NPC
	; so load a default portrait and name
	xor a
	ld [wOpponentPortrait], a
	ld hl, wOpponentName
	ld [hli], a
	ld [hl], a
.ok
	ld hl, SelectComputerOpponentData
	call PlaceTextItems
	call DrawDuelistPortraitsAndNames
	ld a, [wOpponentDeckID]
	lb bc, 5, 16
	call WriteTwoByteNumberInTxSymbolFormat
	ld a, [wNPCDuelPrizes]
	lb bc, 15, 10
	call WriteTwoByteNumberInTxSymbolFormat
	ret

SelectComputerOpponentData:
	textitem 10,  0, ClearOpponentNameText
	textitem 10, 10, NumberOfPrizesText
	textitem  3, 14, SelectComputerOpponentText
	db $ff

Func_7415::
	xor a
	ld [wce7e], a
	ret

; plays all animations that are queued in wStatusConditionQueue
PlayStatusConditionQueueAnimations::
	ld hl, wStatusConditionQueueIndex
	ld a, [hl]
	or a
	ret z
	ld e, a
	ld d, $00
	ld hl, wStatusConditionQueue
	add hl, de
	ld [hl], $00
	ld hl, wStatusConditionQueue
.loop
	ld a, [hli]
	or a
	jr z, .done
	ld d, a
	inc hl
	ld a, [hli] ; which condition to inflict
	ld e, ATK_ANIM_SLEEP
	cp ASLEEP
	jr z, .got_anim
	ld e, ATK_ANIM_PARALYSIS
	cp PARALYZED
	jr z, .got_anim
	ld e, ATK_ANIM_POISON
	cp POISONED
	jr z, .got_anim
	ld e, ATK_ANIM_POISON
	cp DOUBLE_POISONED
	jr z, .got_anim
	ld e, ATK_ANIM_CONFUSION
	cp CONFUSED
	jr nz, .loop
	ldh a, [hWhoseTurn]
	cp d
	jr nz, .got_anim
	; if it's applied to the turn duelist
	; then load the own confusion animation instead
	ld e, ATK_ANIM_OWN_CONFUSION
.got_anim
	ld a, e
	ld [wLoadedAttackAnimation], a
	xor a
	ld [wDuelAnimLocationParam], a
	push hl
	farcall PlayAttackAnimationCommands
	pop hl
	jr .loop
.done
	ret

; this is a simple version of PlayAttackAnimation_DealAttackDamage that doesn't
; take into account status conditions, damage modifiers, etc, for damage calculation.
; used for confusion damage to self and for damage to benched Pokemon, for example
PlayAttackAnimation_DealAttackDamageSimple::
	push hl
	push de
	call PlayAttackAnimation
	call WaitAttackAnimation
	pop de
	pop hl
	call SubtractHP
	ld a, [wDuelDisplayedScreen]
	cp DUEL_MAIN_SCENE
	ret nz
	push hl
	push de
	call DrawDuelHUDs
	pop de
	pop hl
	ret

; if [wLoadedAttackAnimation] != 0, wait until the animation is over
WaitAttackAnimation::
	ld a, [wLoadedAttackAnimation]
	or a
	ret z
	push de
.anim_loop
	call DoFrame
	call CheckAnyAnimationPlaying
	jr c, .anim_loop
	pop de
	ret

; play attack animation
; input:
; - [wLoadedAttackAnimation]: animation to play
; - de: damage dealt by the attack (to display the animation with the number)
; - b: PLAY_AREA_* location, if applicable
; - c: a wDamageEffectiveness constant (to print WEAK or RESIST if necessary)
PlayAttackAnimation::
	ldh a, [hWhoseTurn]
	push af
	push hl
	push de
	push bc
	ld a, [wWhoseTurn]
	ldh [hWhoseTurn], a
	ld a, c
	ld [wDamageAnimEffectiveness], a
	ldh a, [hWhoseTurn]
	cp h
	jr z, .got_location
	set 7, b
.got_location
	ld a, b
	ld [wDamageAnimPlayAreaLocation], a
	ld a, [wWhoseTurn]
	ld [wDamageAnimPlayAreaSide], a
	ld a, [wTempNonTurnDuelistCardID]
	ld [wDamageAnimCardID], a
	ld hl, wDamageAnimAmount
	ld [hl], e
	inc hl
	ld [hl], d

; if damage >= 70, ATK_ANIM_HIT becomes ATK_ANIM_BIG_HIT
	ld a, [wLoadedAttackAnimation]
	cp ATK_ANIM_HIT
	jr nz, .got_anim
	ld a, e
	cp 70
	jr c, .got_anim
	ld a, ATK_ANIM_BIG_HIT
	ld [wLoadedAttackAnimation], a

.got_anim
	farcall PlayAttackAnimationCommands
	pop bc
	pop de
	pop hl
	pop af
	ldh [hWhoseTurn], a
	ret

Func_74dc:
	call EmptyScreen
	call EnableLCD
	ld a, GRASS_ENERGY
	ld [wPrizeCardSelectionFrameCounter], a
.wait_input
	call DoFrame
	ldh a, [hDPadHeld]
	ld b, a
	ld a, [wPrizeCardSelectionFrameCounter]
; left
	bit D_LEFT_F, b
	jr z, .right
	dec a ; previous card
.right
	bit D_RIGHT_F, b
	jr z, .up
	inc a ; next card
.up
	bit D_UP_F, b
	jr z, .down
	add 10
.down
	bit D_DOWN_F, b
	jr z, .got_card_id
	sub 10

.got_card_id
	ld [wPrizeCardSelectionFrameCounter], a
	lb bc, 5, 5
	bank1call WriteTwoByteNumberInTxSymbolFormat
	ldh a, [hKeysPressed]
	and START
	jr z, .wait_input
	ld a, [wPrizeCardSelectionFrameCounter]
	ld e, a
	ld d, $0
.card_loop
	call LoadCardDataToBuffer1_FromCardID
	ret c ; card not found
	push de
	ld a, e
	call RequestToPrintCard
	pop de
	inc de
	jr .card_loop

; seems to communicate with other device
; for starting a duel
; outputs in hl either wPlayerDuelVariables
; or wOpponentDuelVariables depending on wSerialOp
DecideLinkDuelVariables:
	call Func_0e8e
	ldtx hl, PressStartWhenReadyText
	call DrawWideTextBox_PrintText
	call EnableLCD
.input_loop
	call DoFrame
	ldh a, [hKeysPressed]
	bit B_BUTTON_F, a
	jr nz, .link_cancel
	and START
	call Func_0cc5
	jr nc, .input_loop
	ld hl, wPlayerDuelVariables
	ld a, [wSerialOp]
	cp $29
	jr z, .link_continue
	ld hl, wOpponentDuelVariables
	cp $12
	jr z, .link_continue
.link_cancel
	call ResetSerial
	scf
	ret
.link_continue
	or a
	ret

	ret ; stray ret
