OpenGlossaryScreen:
	xor a
	ld [wGlossaryPageNo], a
	call .display_menu

	xor a
	ld [wInPlayAreaCurPosition], a
	ld de, OpenGlossaryScreen_TransitionTable ; this data is stored in bank 2.
	ld hl, wMenuInputTablePointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $ff
	ld [wDuelInitialPrizesUpperBitsSet], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
.next
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	ldh a, [hKeysPressed]
	and SELECT
	jr nz, .on_select

	farcall YourOrOppPlayAreaScreen_HandleInput
	jr nc, .next

	cp -1 ; b button
	jr nz, .check_button

	farcall ZeroObjectPositionsWithCopyToggleOn
	ret

.check_button
	push af
	farcall ZeroObjectPositionsWithCopyToggleOn
	pop af

	cp $09 ; $09: next page or prev page
	jr z, .change_page

	call .print_description
	call .display_menu
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	jr .next

.on_select
	ld a, $01
	farcall PlaySFXConfirmOrCancel
.change_page
	ld a, [wGlossaryPageNo]
	xor $01 ; swap page
	ld [wGlossaryPageNo], a
	call .print_menu
	jr .next

; display glossary menu.
.display_menu
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call EmptyScreen
	call Set_OBJ_8x8
	farcall LoadCursorTile

	lb de, 5, 0
	call InitTextPrinting
	ldtx hl, PokemonCardGlossaryText
	call ProcessTextFromID
	call .print_menu
	ldtx hl, ChooseWordAndPressAButtonText
	call DrawWideTextBox_PrintText
	ret

; print texts in glossary menu.
.print_menu
	ld hl, wDefaultText

	ld a, TX_SYMBOL
	ld [hli], a

	ld a, [wGlossaryPageNo]
	add SYM_1
	ld [hli], a

	ld a, TX_SYMBOL
	ld [hli], a

	ld a, SYM_SLASH
	ld [hli], a

	ld a, TX_SYMBOL
	ld [hli], a

	ld a, SYM_2
	ld [hli], a

	ld [hl], TX_END

	lb de, 16, 1
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText

	lb de, 1, 3
	call InitTextPrinting
	ld a, [wGlossaryPageNo]
	or a
	jr nz, .page_two

	ldtx hl, GlossaryMenuPage1Text
	jr .page_one

.page_two
	ldtx hl, GlossaryMenuPage2Text
.page_one
	call ProcessTextFromID
	ret

; display glossary description.
.print_description
	push af
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	lb de, 5, 0
	call InitTextPrinting
	ldtx hl, PokemonCardGlossaryText
	call ProcessTextFromID
	lb de, 0, 4
	lb bc, 20, 14
	call DrawRegularTextBox

	ld a, [wGlossaryPageNo]
	or a
	jr nz, .back_page

	ld hl, GlossaryData1
	jr .front_page

.back_page
	ld hl, GlossaryData2
.front_page
	pop af
	; hl += (a + (a << 2)).
	; that is,
	; hl += (5 * a).
	ld c, a
	ld b, 0
	add hl, bc
	sla a
	sla a
	ld c, a
	add hl, bc
	ld a, [hli]
	push hl
	ld d, a
	ld e, $02
	call InitTextPrinting
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	pop hl
	lb de, 1, 5
	call InitTextPrinting
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, SINGLE_SPACED
	ld [wLineSeparation], a
	call ProcessTextFromID
	xor a ; DOUBLE_SPACED
	ld [wLineSeparation], a
	call EnableLCD
.loop
	call DoFrame
	ldh a, [hKeysPressed]
	and B_BUTTON
	jr z, .loop

	ld a, -1
	farcall PlaySFXConfirmOrCancel
	ret

; unit: 5 bytes.
; [structure]
; horizontal align (1) / title text id (2) / desc. text id (2)
MACRO glossary_entry
	db \1
	tx \2
	tx \3
ENDM

GlossaryData1:
	glossary_entry 7, AboutTheDeckText, DeckDescriptionText
	glossary_entry 5, AboutTheDiscardPileText, DiscardPileDescriptionText
	glossary_entry 7, AboutTheHandText, HandDescriptionText
	glossary_entry 6, AboutTheArenaText, ArenaDescriptionText
	glossary_entry 6, AboutTheBenchText, BenchDescriptionText
	glossary_entry 4, AboutTheActivePokemonText, ActivePokemonDescriptionText
	glossary_entry 5, AboutBenchPokemonText, BenchPokemonDescriptionText
	glossary_entry 7, AboutPrizesText, PrizesDescriptionText
	glossary_entry 5, AboutDamageCountersText, DamageCountersDescriptionText

GlossaryData2:
	glossary_entry 5, AboutEnergyCardsText, EnergyCardsDescriptionText
	glossary_entry 5, AboutTrainerCardsText, TrainerCardsDescriptionText
	glossary_entry 5, AboutBasicPokemonText, BasicPokemonDescriptionText
	glossary_entry 5, AboutEvolutionCardsText, EvolutionCardsDescriptionText
	glossary_entry 6, AboutAttackingText, AttackingDescriptionText
	glossary_entry 5, AboutPokemonPowerText, PokemonPowerDescriptionText
	glossary_entry 6, AboutWeaknessText, WeaknessDescriptionText
	glossary_entry 6, AboutResistanceText, ResistanceDescriptionText
	glossary_entry 6, AboutRetreatingText, RetreatingDescriptionText
