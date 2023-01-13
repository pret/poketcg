OpenDuelCheckMenu::
	ldh a, [hBankROM]
	push af
	ld a, BANK(_OpenDuelCheckMenu)
	call BankswitchROM
	call _OpenDuelCheckMenu
	pop af
	call BankswitchROM
	ret

OpenInPlayAreaScreen_FromSelectButton::
	ldh a, [hBankROM]
	push af
	ld a, BANK(OpenInPlayAreaScreen)
	call BankswitchROM
	ld a, $1
	ld [wInPlayAreaFromSelectButton], a
	call OpenInPlayAreaScreen
	pop bc
	ld a, b
	call BankswitchROM
	ret

; loads tiles and icons to display Your Play Area / Opp. Play Area screen,
; and draws the screen according to the turn player
; input: h -> [wCheckMenuPlayAreaWhichDuelist] and l -> [wCheckMenuPlayAreaWhichLayout]
; similar to DrawYourOrOppPlayArea (bank 2) except it also draws a wide text box.
; this is because bank 2's DrawYourOrOppPlayArea is supposed to come from the Check Menu,
; so the text box is always already there.
DrawYourOrOppPlayAreaScreen_Bank0::
	ld a, h
	ld [wCheckMenuPlayAreaWhichDuelist], a
	ld a, l
	ld [wCheckMenuPlayAreaWhichLayout], a
	ldh a, [hBankROM]
	push af
	ld a, BANK(_DrawYourOrOppPlayAreaScreen)
	call BankswitchROM
	call _DrawYourOrOppPlayAreaScreen
	call DrawWideTextBox
	pop af
	call BankswitchROM
	ret

DrawPlayersPrizeAndBenchCards::
	ldh a, [hBankROM]
	push af
	ld a, BANK(_DrawPlayersPrizeAndBenchCards)
	call BankswitchROM
	call _DrawPlayersPrizeAndBenchCards
	pop af
	call BankswitchROM
	ret

HandlePeekSelection::
	ldh a, [hBankROM]
	push af
	ld a, BANK(_HandlePeekSelection)
	call BankswitchROM
	call _HandlePeekSelection
	ld b, a
	pop af
	call BankswitchROM
	ld a, b
	ret

DrawAIPeekScreen::
	ld b, a
	ldh a, [hBankROM]
	push af
	ld a, BANK(_DrawAIPeekScreen)
	call BankswitchROM
	call _DrawAIPeekScreen
	pop af
	call BankswitchROM
	ret

; a = number of prize cards for player to select to take
SelectPrizeCards::
	ld [wNumberOfPrizeCardsToSelect], a
	ldh a, [hBankROM]
	push af
	ld a, BANK(_SelectPrizeCards)
	call BankswitchROM
	call _SelectPrizeCards
	pop af
	call BankswitchROM
	ret

DrawPlayAreaToPlacePrizeCards::
	ldh a, [hBankROM]
	push af
	ld a, BANK(_DrawPlayAreaToPlacePrizeCards)
	call BankswitchROM
	call _DrawPlayAreaToPlacePrizeCards
	pop af
	call BankswitchROM
	ret
