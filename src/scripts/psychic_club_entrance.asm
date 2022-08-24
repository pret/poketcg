ClubEntranceAfterDuel:
	ld hl, .after_duel_table
	jp FindEndOfDuelScript

.after_duel_table
	db NPC_RONALD2
	db NPC_RONALD2
	dw Script_BeatFirstRonaldDuel
	dw Script_LostToFirstRonaldDuel

	db NPC_RONALD3
	db NPC_RONALD3
	dw Script_BeatSecondRonaldDuel
	dw Script_LostToSecondRonaldDuel
	db $00

; A Ronald is already loaded or not loaded depending on Pre-Load scripts
; in data/npc_map_data.asm. This just starts a script if possible.
LoadClubEntrance:
	call TryFirstRonaldDuel
	call TrySecondRonaldDuel
	call TryFirstRonaldEncounter
	ret

TryFirstRonaldEncounter:
	ld a, NPC_RONALD1
	ld [wTempNPC], a
	call FindLoadedNPC
	ret c
	ld bc, Script_FirstRonaldEncounter
	jp SetNextNPCAndScript

TryFirstRonaldDuel:
	ld a, NPC_RONALD2
	ld [wTempNPC], a
	call FindLoadedNPC
	ret c
	get_event_value EVENT_RONALD_FIRST_DUEL_STATE
	or a
	ret nz ; already dueled
	ld bc, Script_FirstRonaldDuel
	jp SetNextNPCAndScript

TrySecondRonaldDuel:
	ld a, NPC_RONALD3
	ld [wTempNPC], a
	call FindLoadedNPC
	ret c
	get_event_value EVENT_RONALD_SECOND_DUEL_STATE
	or a
	ret nz ; already dueled
	ld bc, Script_SecondRonaldDuel
	jp SetNextNPCAndScript

Script_Clerk6:
	start_script
	print_text_quit_fully Text0642

Script_Lad3:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0643, Text0644
	quit_script_fully

Preload_Ronald1InClubEntrance:
	get_event_value EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER
	cp TRUE
	ret

Script_FirstRonaldEncounter:
	start_script
	max_out_event_value EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER
	move_active_npc NPCMovement_e894
	load_current_map_name_into_txram_slot 0
	print_npc_text Text0645
	close_text_box
	move_player NORTH, 1
	move_player NORTH, 1
	print_npc_text Text0646
	ask_question_jump_default_yes NULL, .ows_e882
	print_npc_text Text0647
	script_jump .ows_e885

.ows_e882
	print_npc_text Text0648
.ows_e885
	print_npc_text Text0649
	close_text_box
	set_player_direction WEST
	move_player EAST, 4
	move_active_npc NPCMovement_e894
	unload_active_npc
	play_default_song
	quit_script_fully

NPCMovement_e894:
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

Preload_Ronald2InClubEntrance:
	get_event_value EVENT_RONALD_FIRST_DUEL_STATE
	ld e, 2 ; medal requirement for ronald duel
Func_e8a0:
	cp RONALD_DUEL_WON
	jr z, .asm_e8b4
	cp RONALD_DUEL_LOST
	jr nc, .asm_e8b2
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	cp e
	jr z, .asm_e8be
.asm_e8b2
	or a
	ret

.asm_e8b4
	ld a, $08
	ld [wLoadNPCXPos], a
	ld a, $08
	ld [wLoadNPCYPos], a
.asm_e8be
	scf
	ret

Script_FirstRonaldDuel:
	start_script
	move_active_npc NPCMovement_e905
	do_frames 60
	move_active_npc NPCMovement_e90d
	print_npc_text Text064a
	jump_if_player_coords_match 8, 2, .ows_e8d6
	set_player_direction WEST
	move_player WEST, 1
.ows_e8d6
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	print_npc_text Text064b
	set_event EVENT_RONALD_FIRST_DUEL_STATE, RONALD_DUEL_WON
	start_duel PRIZES_6, IM_RONALD_DECK_ID, MUSIC_RONALD
	quit_script_fully

Script_BeatFirstRonaldDuel:
	start_script
	print_npc_text Text064c
	give_card JIGGLYPUFF_LV12
	show_card_received_screen JIGGLYPUFF_LV12
	print_npc_text Text064d
	script_jump Script_LostToFirstRonaldDuel.ows_e8fb

Script_LostToFirstRonaldDuel:
	start_script
	print_npc_text Text064e
.ows_e8fb
	set_event EVENT_RONALD_FIRST_DUEL_STATE, RONALD_DUEL_LOST
	close_text_box
	move_active_npc NPCMovement_e90f
	unload_active_npc
	play_default_song
	quit_script_fully

NPCMovement_e905:
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db SOUTH
	db NORTH | NO_MOVE
	db $ff

NPCMovement_e90d:
	db NORTH
	db $ff

NPCMovement_e90f:
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

Preload_Ronald3InClubEntrance:
	get_event_value EVENT_RONALD_SECOND_DUEL_STATE
	ld e, 5 ; medal requirement for ronald duel
	jp Func_e8a0

Script_SecondRonaldDuel:
	start_script
	move_active_npc NPCMovement_e905
	do_frames 60
	move_active_npc NPCMovement_e90d
	print_npc_text Text064f
	jump_if_player_coords_match 8, 2, .ows_6934
	set_player_direction WEST
	move_player WEST, 1
.ows_6934
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	print_npc_text Text0650
	set_event EVENT_RONALD_SECOND_DUEL_STATE, RONALD_DUEL_WON
	start_duel PRIZES_6, POWERFUL_RONALD_DECK_ID, MUSIC_RONALD
	quit_script_fully

Script_BeatSecondRonaldDuel:
	start_script
	print_npc_text Text0651
	give_card SUPER_ENERGY_RETRIEVAL
	show_card_received_screen SUPER_ENERGY_RETRIEVAL
	print_npc_text Text0652
	script_jump Script_LostToSecondRonaldDuel.ows_e959

Script_LostToSecondRonaldDuel:
	start_script
	print_npc_text Text0653
.ows_e959
	set_event EVENT_RONALD_SECOND_DUEL_STATE, RONALD_DUEL_LOST
	close_text_box
	move_active_npc NPCMovement_e90f
	unload_active_npc
	play_default_song
	quit_script_fully
