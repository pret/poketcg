SECTION "HRAM", HRAM

hBankROM:: ; ff80
	ds $1

hBankSRAM:: ; ff81
	ds $1

hBankVRAM:: ; ff82
	ds $1

hDMAFunction:: ; ff83
	ds $a

; D-pad repeat counter. see HandleDPadRepeat
hDPadRepeat:: ; ff8d
	ds $1

; keys pressed in last frame but not in current frame
hKeysReleased:: ; ff8e
	ds $1

; used to quickly scroll through menus when a relevant D-pad key is held
; see HandleDPadRepeat
hDPadHeld:: ; ff8f
	ds $1

; keys pressed in last frame and in current frame
hKeysHeld:: ; ff90
	ds $1

; keys pressed in current frame but not in last frame
hKeysPressed:: ; ff91
	ds $1

hSCX:: ; ff92
	ds $1

hSCY:: ; ff93
	ds $1

hWX:: ; ff94
	ds $1

hWY:: ; ff95
	ds $1

hff96:: ; ff96
	ds $1

; $c2 = player ; $c3 = opponent
hWhoseTurn:: ; ff97
	ds $1

; deck index of a card (0-59)
hTempCardIndex_ff98:: ; ff98
	ds $1

; used in SortCardsInListByID
hTempListPtr_ff99:: ; ff99
	ds $2

; used in SortCardsInListByID
; this function supports 16-bit card IDs
hTempCardID_ff9b:: ; ff9b
	ds $2

; a PLAY_AREA_* constant (0: arena card, 1-5: bench card)
hTempPlayAreaLocation_ff9d:: ; ff9d
	ds $1

; index for AIActionTable
hOppActionTableIndex:: ; ff9e
	ds $1

; deck index of a card (0-59)
hTempCardIndex_ff9f:: ; ff9f
	ds $1

UNION

; multipurpose temp storage (card's deck index, selected move index, status condition...)
hTemp_ffa0:: ; ffa0
	ds $1

; a PLAY_AREA_* constant (0: arena card, 1-5: bench card)
hTempPlayAreaLocation_ffa1:: ; ffa1

; parameter to be used by the AI's Pkmn Power effect
hAIPkmnPowerEffectParam:: ; ffa1
	ds $1

UNION

; $ff-terminated list of cards to be discarded upon retreat
hTempRetreatCostCards:: ; ffa2
	ds $6

NEXTU

; parameters chosen by AI in Energy Trans routine.
; the deck index (0-59) of the energy card to transfer
; and the Play Area location (PLAY_AREA_*) of card to receive that energy card.
hAIEnergyTransEnergyCard:: ; ffa2

; PLAY_AREA_*  of target selected for some Pkmn Powers,
; (e.g. Curse, Damage Swap) and for trainer card effect.
hPlayAreaEffectTarget:: ; ffa2
	ds $1

hAIEnergyTransPlayAreaLocation:: ; ffa3
	ds $1

ENDU

NEXTU

; list of various items, such as
; cards selected for various effects,
; Play Area locations, etc.
hTempList:: ; ffa0
	ds $8

ENDU

; hffa8 through hffb0 belong to the text engine
hffa8:: ; ffa8
	ds $1

hffa9:: ; ffa9
	ds $1

; Address within v*BGMap0 where text is currently being written to
hTextBGMap0Address:: ; ffaa
	ds $2

; position within a line of text where text is currently being placed at
; ranges between 0 and [hTextLineLength]
hTextLineCurPos:: ; ffac
	ds $1

; used as an x coordinate offset when printing text, in order to align
; the text's starting position and/or adjust for the BG scroll registers
hTextHorizontalAlign:: ; ffad
	ds $1

; how many tiles can be fit per line in the current text area
; for example, 11 for a narrow text box and 19 for a wide text box
hTextLineLength:: ; ffae
	ds $1

; when printing text and no leading control character is specified, whether characters
; $10 to $60 map to the katakana.1bpp font graphics as characters $0 to $50
; (TX_KATAKANA mode), or map to the hiragana.1bpp font graphics (TX_HIRAGANA mode).
; the TX_HIRAGANA and TX_KATAKANA control characters are used to set this address to said
; value. only these two values are admitted, as any other is interpreted as TX_HIRAGANA.
hJapaneseSyllabary:: ; ffaf
	ds $1

hffb0:: ; ffb0
	ds $1

; unlike wCurMenuItem, this accounts for the scroll offset (wListScrollOffset)
hCurMenuItem:: ; ffb1
	ds $1

; stores the item number in the selection menu of various effects
hCurSelectionItem:: ; ffb2
	ds $1

	ds $2

hffb5:: ; ffb5
	ds $1

; used in DivideBCbyDE
hffb6:: ; ffb6
	ds $1
