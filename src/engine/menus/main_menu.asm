; usually, the game doesn't loop here at all, since as soon as a main menu option
; is selected, there is no need to come back to the menu.
; the only exception is after returning from Card Pop!
_GameLoop:
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	farcall SetIntroSGBBorder
	ld a, $ff
	ld [wLastSelectedStartMenuItem], a
.main_menu_loop
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	farcall Func_c1f8
	farcall HandleTitleScreen
	ld a, [wStartMenuChoice]
	ld hl, MainMenuFunctionTable
	call JumpToFunctionInTable
	jr c, .main_menu_loop ; return to main menu
	jr _GameLoop ; virtually restart game

; this is never reached
	scf
	ret

MainMenuFunctionTable:
	dw MainMenu_CardPop
	dw MainMenu_ContinueFromDiary
	dw MainMenu_NewGame
	dw MainMenu_ContinueDuel

MainMenu_NewGame:
	farcall Func_c1b1
	call DisplayPlayerNamingScreen
	farcall InitSaveData
	call EnableSRAM
	ld a, [sAnimationsDisabled]
	ld [wAnimationsDisabled], a
	ld a, [sTextSpeed]
	ld [wTextSpeed], a
	call DisableSRAM
	ld a, MUSIC_STOP
	call PlaySong
	farcall SetMainSGBBorder
	ld a, MUSIC_OVERWORLD
	ld [wDefaultSong], a
	call PlayDefaultSong
	farcall DrawPlayerPortraitAndPrintNewGameText
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

MainMenu_ContinueFromDiary:
	ld a, MUSIC_STOP
	call PlaySong
	call ValidateBackupGeneralSaveData
	jr nc, MainMenu_NewGame
	farcall Func_c1ed
	farcall SetMainSGBBorder
	call EnableSRAM
	xor a
	ld [sPlayerInChallengeMachine], a
	call DisableSRAM
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

MainMenu_CardPop:
	ld a, MUSIC_CARD_POP
	call PlaySong
	bank1call DoCardPop
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	ld a, MUSIC_STOP
	call PlaySong
	scf
	ret

MainMenu_ContinueDuel:
	ld a, MUSIC_STOP
	call PlaySong
	farcall ClearEvents
	farcall $04, LoadGeneralSaveData
	farcall SetMainSGBBorder
	ld a, GAME_EVENT_CONTINUE_DUEL
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret
