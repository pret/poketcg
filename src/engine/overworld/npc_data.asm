; loads a pointer into hl found on NPCHeaderPointers
GetNPCHeaderPointer:
	rlca
	add LOW(NPCHeaderPointers)
	ld l, a
	ld a, HIGH(NPCHeaderPointers)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

LoadNPCSpriteData:
	push hl
	push bc
	call GetNPCHeaderPointer
	ld a, [hli]
	ld [wTempNPC], a
	ld a, [hli]
	ld [wNPCSpriteID], a
	ld a, [hli]
	ld [wNPCAnim], a
	ld a, [hli]
	push af
	ld a, [hli]
	ld [wNPCAnimFlags], a
	pop bc
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld a, b
	ld [wNPCAnim], a
.not_cgb
	pop bc
	pop hl
	ret

; Loads Name into wCurrentNPCNameTx and gets Script ptr into bc
GetNPCNameAndScript:
	push hl
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_SCRIPT_PTR
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld [wCurrentNPCNameTx], a
	ld a, [hli]
	ld [wCurrentNPCNameTx + 1], a
	pop hl
	ret

; Sets Dialog Box title to the name of the npc in 'a'
SetNPCDialogName:
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_NAME_TEXT
	add hl, bc
	ld a, [hli]
	ld [wCurrentNPCNameTx], a
	ld a, [hli]
	ld [wCurrentNPCNameTx + 1], a
	pop bc
	pop hl
	ret

; set the opponent name and portrait for the NPC id in register a
SetNPCOpponentNameAndPortrait:
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_NAME_TEXT
	add hl, bc
	ld a, [hli]
	ld [wOpponentName], a
	ld a, [hli]
	ld [wOpponentName + 1], a
	ld a, [hli]
	ld [wOpponentPortrait], a
	pop bc
	pop hl
	ret

; set the deck id and duel theme for the NPC id in register a
SetNPCDeckIDAndDuelTheme:
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_DECK_ID
	add hl, bc
	ld a, [hli]
	ld [wNPCDuelDeckID], a
	ld a, [hli]
	ld [wDuelTheme], a
	pop bc
	pop hl
	ret

; set the start theme for the NPC id in register a
SetNPCMatchStartTheme:
	push hl
	push bc
	push af
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_MATCH_START_ID
	add hl, bc
	ld a, [hli]
	ld [wMatchStartTheme], a
	pop af
	cp NPC_RONALD1
	jr nz, .not_ronald_final_duel
	ld a, [wCurMap]
	cp POKEMON_DOME
	jr nz, .not_ronald_final_duel
	ld a, MUSIC_MATCH_START_3
	ld [wMatchStartTheme], a

.not_ronald_final_duel
	pop bc
	pop hl
	ret

INCLUDE "data/npcs.asm"

_GetNPCDuelConfigurations::
	push hl
	push bc
	push de
	ld a, [wNPCDuelDeckID]
	ld e, a
	ld bc, 9 ; size of struct - 1
	ld hl, DeckIDDuelConfigurations
.loop_deck_ids
	ld a, [hli]
	cp -1 ; end of list?
	jr z, .done
	cp e
	jr nz, .next_deck_id
	ld a, [hli]
	ld [wOpponentPortrait], a
	ld a, [hli]
	ld [wOpponentName], a
	ld a, [hli]
	ld [wOpponentName + 1], a
	ld a, [hl]
	ld [wNPCDuelPrizes], a
	scf
	jr .done
.next_deck_id
	add hl, bc
	jr .loop_deck_ids
.done
	pop de
	pop bc
	pop hl
	ret

_GetChallengeMachineDuelConfigurations:
	push bc
	push de
	ld a, [wNPCDuelDeckID]
	ld e, a
	ld bc, 9 ; size of struct - 1
	ld hl, DeckIDDuelConfigurations
.loop_deck_ids
	ld a, [hli]
	cp -1 ; end of list?
	jr z, .done
	cp e
	jr nz, .next_deck_id
	push hl
	ld a, [hli]
	ld [wOpponentPortrait], a
	ld a, [hli]
	ld [wOpponentName], a
	ld a, [hli]
	ld [wOpponentName + 1], a
	inc hl
	ld a, [hli]
	ld [wDuelTheme], a
	pop hl
	dec hl
	scf
	jr .done
.next_deck_id
	add hl, bc
	jr .loop_deck_ids
.done
	pop de
	pop bc
	ret
