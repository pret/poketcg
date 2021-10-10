INCLUDE "data/auto_deck_card_lists.asm"
INCLUDE "data/auto_deck_machines.asm"

; writes to sAutoDecks all the deck configurations
; from the Auto Deck Machine in wCurAutoDeckMachine
ReadAutoDeckConfiguration:
	call EnableSRAM
	ld a, [wCurAutoDeckMachine]
	ld l, a
	ld h, 6 * NUM_DECK_MACHINE_SLOTS
	call HtimesL
	ld bc, AutoDeckMachineEntries
	add hl, bc
	ld b, 0
.loop_decks
	call .GetPointerToSRAMAutoDeck
	call .ReadDeckConfiguration
	call .ReadDeckName

	; store deck description text ID
	push hl
	ld de, wAutoDeckMachineTextDescriptions
	ld h, b
	ld l, 2
	call HtimesL
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc b
	ld a, b
	cp NUM_DECK_MACHINE_SLOTS
	jr nz, .loop_decks
	call DisableSRAM
	ret

; outputs in de the saved deck with index b
.GetPointerToSRAMAutoDeck
	push hl
	ld l, b
	ld h, DECK_STRUCT_SIZE
	call HtimesL
	ld de, sAutoDecks
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ret

; writes the deck configuration in SRAM
; by reading the given deck card list
.ReadDeckConfiguration
	push hl
	push bc
	push de
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ld bc, DECK_NAME_SIZE
	add hl, bc
.loop_create_deck
	ld a, [de]
	inc de
	ld b, a ; card count
	or a
	jr z, .done_create_deck
	ld a, [de]
	inc de
	ld c, a ; card ID
.loop_card_count
	ld [hl], c
	inc hl
	dec b
	jr nz, .loop_card_count
	jr .loop_create_deck
.done_create_deck
	pop de
	pop bc
	pop hl
	inc hl
	inc hl
	ret

.ReadDeckName
	push hl
	push bc
	push de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDismantledDeckName
	call CopyText
	pop hl
	ld de, wDismantledDeckName
.loop_copy_name
	ld a, [de]
	ld [hli], a
	or a
	jr z, .done_copy_name
	inc de
	jr .loop_copy_name
.done_copy_name
	pop bc
	pop hl
	inc hl
	inc hl
	ret

; tries out all combinations of dismantling the player's decks
; in order to build the deck in wSelectedDeckMachineEntry
; if none of the combinations work, return carry set
; otherwise, return in a which deck flags should be dismantled
CheckWhichDecksToDismantleToBuildSavedDeck:
	xor a
	ld [wDecksToBeDismantled], a

; first check if it can be built by
; only dismantling a single deck
	ld a, DECK_1
.loop_single_built_decks
	call .CheckIfCanBuild
	ret nc
	sla a ; next deck
	cp (1 << NUM_DECKS)
	jr z, .two_deck_combinations
	jr .loop_single_built_decks

.two_deck_combinations
; next check all two deck combinations
	ld a, DECK_1 | DECK_2
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_1 | DECK_3
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_1 | DECK_4
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_2 | DECK_3
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_2 | DECK_4
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_3 | DECK_4
	call .CheckIfCanBuild
	ret nc

; all but one deck combinations
	ld a, $ff ^ DECK_4
.loop_three_deck_combinations
	call .CheckIfCanBuild
	ret nc
	sra a
	cp $ff
	jr z, .all_decks
	jr .loop_three_deck_combinations

.all_decks
; finally check if can be built by dismantling all decks
	call .CheckIfCanBuild
	ret nc

; none of the combinations work
	scf
	ret

; returns carry if wSelectedDeckMachineEntry cannot be built
; by dismantling the decks given by register a
; a = DECK_* flags
.CheckIfCanBuild
	push af
	ld hl, wSelectedDeckMachineEntry
	ld b, [hl]
	farcall CheckIfCanBuildSavedDeck
	jr c, .cannot_build
	pop af
	ld [wDecksToBeDismantled], a
	or a
	ret
.cannot_build
	pop af
	scf
	ret
