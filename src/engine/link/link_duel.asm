; sets up to start a link duel
; decides which device will pick the number of prizes
; then exchanges names and duels between the players
; and starts the main duel routine
_SetUpAndStartLinkDuel:
	ld hl, sp+$00
	ld a, l
	ld [wDuelReturnAddress + 0], a
	ld a, h
	ld [wDuelReturnAddress + 1], a
	call SetSpriteAnimationsAsVBlankFunction

	ld a, SCENE_GAMEBOY_LINK_TRANSMITTING
	lb bc, 0, 0
	call LoadScene

	bank1call LoadPlayerDeck
	call SwitchToCGBNormalSpeed
	bank1call DecideLinkDuelVariables
	push af
	call RestoreVBlankFunction
	pop af
	jp c, .error

	ld a, DUELIST_TYPE_PLAYER
	ld [wPlayerDuelistType], a
	ld a, DUELIST_TYPE_LINK_OPP
	ld [wOpponentDuelistType], a
	ld a, DUELTYPE_LINK
	ld [wDuelType], a

	call EmptyScreen
	ld a, [wSerialOp]
	cp $29
	jr nz, .asm_1a540

	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call .ExchangeNamesAndDecks
	jr c, .error
	lb de, 6, 2
	lb bc, 8, 6
	call DrawRegularTextBox
	lb de, 7, 4
	call InitTextPrinting
	ldtx hl, PrizesCardsText
	call ProcessTextFromID
	ldtx hl, ChooseTheNumberOfPrizesText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call .PickNumberOfPrizeCards
	ld a, [wNPCDuelPrizes]
	call SerialSend8Bytes
	jr .prizes_decided

.asm_1a540
	ld a, OPPONENT_TURN
	ldh [hWhoseTurn], a
	call .ExchangeNamesAndDecks
	jr c, .error
	ldtx hl, PleaseWaitDecidingNumberOfPrizesText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call SerialRecv8Bytes
	ld [wNPCDuelPrizes], a

.prizes_decided
	call ExchangeRNG
	ld a, LINK_OPP_PIC
	ld [wOpponentPortrait], a
	ldh a, [hWhoseTurn]
	push af
	call EmptyScreen
	bank1call SetDefaultConsolePalettes
	ld a, SHUFFLE_DECK
	ld [wDuelDisplayedScreen], a
	bank1call DrawDuelistPortraitsAndNames
	ld a, OPPONENT_TURN
	ldh [hWhoseTurn], a
	ld a, [wNPCDuelPrizes]
	ld l, a
	ld h, $00
	call LoadTxRam3
	ldtx hl, BeginAPrizeDuelWithText
	call DrawWideTextBox_WaitForInput
	pop af
	ldh [hWhoseTurn], a
	call ExchangeRNG
	bank1call StartDuel_VSLinkOpp
	call SwitchToCGBDoubleSpeed
	ret

.error
	ld a, -1
	ld [wDuelResult], a
	call SetSpriteAnimationsAsVBlankFunction

	ld a, SCENE_GAMEBOY_LINK_NOT_CONNECTED
	lb bc, 0, 0
	call LoadScene

	ldtx hl, TransmissionErrorText
	call DrawWideTextBox_WaitForInput
	call RestoreVBlankFunction
	call ResetSerial
	ret

.ExchangeNamesAndDecks
	ld de, wDefaultText
	push de
	call CopyPlayerName
	pop hl
	ld de, wNameBuffer
	ld c, NAME_BUFFER_LENGTH
	call SerialExchangeBytes
	ret c
	xor a
	ld hl, wOpponentName
	ld [hli], a
	ld [hl], a
	ld hl, wPlayerDeck
	ld de, wOpponentDeck
	ld c, DECK_SIZE
	call SerialExchangeBytes
	ret

; handles player choice of number of prize cards
; pressing left/right makes it decrease/increase respectively
; selection is confirmed by pressing A button
.PickNumberOfPrizeCards
	ld a, PRIZES_4
	ld [wNPCDuelPrizes], a
	xor a
	ld [wPrizeCardSelectionFrameCounter], a
.loop_input
	call DoFrame
	ld a, [wNPCDuelPrizes]
	add SYM_0
	ld e, a
	; check frame counter so that it
	; either blinks or shows number
	ld hl, wPrizeCardSelectionFrameCounter
	ld a, [hl]
	inc [hl]
	and $10
	jr z, .no_blink
	ld e, SYM_SPACE
.no_blink
	ld a, e
	lb bc, 9, 6
	call WriteByteToBGMap0

	ldh a, [hDPadHeld]
	ld b, a
	ld a, [wNPCDuelPrizes]
	bit D_LEFT_F, b
	jr z, .check_d_right
	dec a
	cp PRIZES_2
	jr nc, .got_prize_count
	ld a, PRIZES_6 ; wrap around to 6
	jr .got_prize_count

.check_d_right
	bit D_RIGHT_F, b
	jr z, .check_a_btn
	inc a
	cp PRIZES_6 + 1
	jr c, .got_prize_count
	ld a, PRIZES_2
.got_prize_count
	ld [wNPCDuelPrizes], a
	xor a
	ld [wPrizeCardSelectionFrameCounter], a

.check_a_btn
	bit A_BUTTON_F, b
	jr z, .loop_input
	ret
