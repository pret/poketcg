GrassClubEntranceAfterDuel:
	ld hl, GrassClubEntranceAfterDuelTable
	call FindEndOfDuelScript
	ret

FindEndOfDuelScript:
	ld c, 0
	ld a, [wDuelResult]
	or a ; cp DUEL_WIN
	jr z, .player_won
	ld c, 2

.player_won
	ld a, [wNPCDuelist]
	ld b, a
	ld de, 5
.check_enemy_byte_loop
	ld a, [hli]
	or a
	ret z
	cp b
	jr z, .found_enemy
	add hl, de
	jr .check_enemy_byte_loop

.found_enemy
	ld a, [hli]
	ld [wTempNPC], a
	ld b, 0
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	jp SetNextNPCAndScript

GrassClubEntranceAfterDuelTable:
	db NPC_MICHAEL
	db NPC_MICHAEL
	dw Script_BeatMichaelInGrassClubEntrance
	dw Script_LostToMichaelInGrassClubEntrance

	db NPC_RONALD2
	db NPC_RONALD2
	dw Script_BeatFirstRonaldDuel
	dw Script_LostToFirstRonaldDuel

	db NPC_RONALD3
	db NPC_RONALD3
	dw Script_BeatSecondRonaldDuel
	dw Script_LostToSecondRonaldDuel
	db $00

Script_Clerk5:
	start_script
	print_text_quit_fully Text06d7

Preload_MichaelInGrassClubEntrance:
	get_event_value EVENT_PUPIL_MICHAEL_STATE
	or a ; cp PUPIL_INACTIVE
	ret z
	cp PUPIL_DEFEATED
	ret

Script_Michael:
	start_script
	jump_if_event_greater_or_equal EVENT_PUPIL_MICHAEL_STATE, PUPIL_DEFEATED,  Script_MichaelRematch
	test_if_event_equal EVENT_PUPIL_MICHAEL_STATE, PUPIL_ACTIVE
	print_variable_npc_text Text06d8, Text06d9
	set_event EVENT_PUPIL_MICHAEL_STATE, PUPIL_TALKED
	ask_question_jump Text06da, .ows_e58f
	print_npc_text Text06db
	quit_script_fully

.ows_e58f
	print_npc_text Text06dc
	start_duel PRIZES_4, HEATED_BATTLE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatMichaelInGrassClubEntrance:
	start_script
	set_event EVENT_PUPIL_MICHAEL_STATE, PUPIL_DEFEATED
	print_npc_text Text06dd
	give_booster_packs BOOSTER_COLOSSEUM_FIGHTING, BOOSTER_COLOSSEUM_FIGHTING, NO_BOOSTER
	print_npc_text Text06de
	close_text_box
	move_active_npc_by_direction NPCMovementTable_e5af
	unload_active_npc
	quit_script_fully

Script_LostToMichaelInGrassClubEntrance:
	start_script
	print_text_quit_fully Text06df

NPCMovementTable_e5af:
	dw NPCMovement_e5b7
	dw NPCMovement_e5b7
	dw NPCMovement_e5b7
	dw NPCMovement_e5bf

NPCMovement_e5b7:
	db WEST
	db WEST
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

NPCMovement_e5bf:
	db SOUTH
	db WEST
	db WEST
	db $fe, -9
