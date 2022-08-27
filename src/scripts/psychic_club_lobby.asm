PsychicClubLobbyAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_ROBERT
	db NPC_ROBERT
	dw Script_BeatRobert
	dw Script_LostToRobert
	db $00

PsychicClubLobbyLoadMap:
	ld a, NPC_RONALD1
	ld [wTempNPC], a
	call FindLoadedNPC
	ret c
	ld bc, Script_ea02
	jp SetNextNPCAndScript

Script_Robert:
	start_script
	print_npc_text Text0654
	ask_question_jump Text0655, .ows_e98d
	print_npc_text Text0656
	quit_script_fully

.ows_e98d
	print_npc_text Text0657
	start_duel PRIZES_4, GHOST_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatRobert:
	start_script
	print_npc_text Text0658
	give_booster_packs BOOSTER_EVOLUTION_PSYCHIC, BOOSTER_EVOLUTION_PSYCHIC, NO_BOOSTER
	print_npc_text Text0659
	quit_script_fully

Script_LostToRobert:
	start_script
	print_text_quit_fully Text065a

Script_Pappy1:
	start_script
	jump_if_event_equal EVENT_PAPPY1_STATE, PAPPY1_CHALLENGE_COMPLETE, .ows_e9de
	jump_if_event_true EVENT_BEAT_MURRAY, .ows_e9cb
	jump_if_event_equal EVENT_PAPPY1_STATE, PAPPY1_CHALLENGE_ACCEPTED, .ows_e9c8
	set_event EVENT_PAPPY1_STATE, PAPPY1_TALKED
	print_npc_text Text065b
	ask_question_jump_default_yes Text065c, .ows_e9c2
	print_text_quit_fully Text065d

.ows_e9c2
	set_event EVENT_PAPPY1_STATE, PAPPY1_CHALLENGE_ACCEPTED
	print_text_quit_fully Text065e

.ows_e9c8
	print_text_quit_fully Text065f

.ows_e9cb
	test_if_event_zero EVENT_PAPPY1_STATE
	print_variable_npc_text Text0660, Text0661
	give_card MEWTWO_ALT_LV60
	show_card_received_screen MEWTWO_ALT_LV60
	set_event EVENT_PAPPY1_STATE, PAPPY1_CHALLENGE_COMPLETE
	print_text_quit_fully Text0662

.ows_e9de
	print_text_quit_fully Text0663

_Preload_Ronald1InPsychicClubLobby:
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	cp 4
	jr nz, .dont_load
	get_event_value EVENT_RONALD_PSYCHIC_CLUB_LOBBY_ENCOUNTER
	or a
	jr nz, .dont_load
	scf
	ret
.dont_load
	or a
	ret

Preload_Ronald1InPsychicClubLobby:
	call _Preload_Ronald1InPsychicClubLobby
	ret nc
	ld a, [wPlayerYCoord]
	ld [wLoadNPCYPos], a
	ret

Script_ea02:
	start_script
	move_active_npc_by_direction NPCMovementTable_ea1a
	max_out_event_value EVENT_RONALD_PSYCHIC_CLUB_LOBBY_ENCOUNTER
	print_npc_text Text0664
	close_text_box
	set_player_direction SOUTH
	move_player NORTH, 4
	move_player NORTH, 1
	move_active_npc_by_direction NPCMovementTable_ea22
	unload_active_npc
	play_default_song
	quit_script_fully

NPCMovementTable_ea1a:
	dw NPCMovement_ea2a
	dw NPCMovement_ea2a
	dw NPCMovement_ea2a
	dw NPCMovement_ea2a

NPCMovementTable_ea22:
	dw NPCMovement_ea2c
	dw NPCMovement_ea2c
	dw NPCMovement_ea2c
	dw NPCMovement_ea2c

NPCMovement_ea2a:
	db EAST
	db EAST
NPCMovement_ea2c:
	db EAST
	db EAST
	db EAST
	db $ff

Script_Gal3:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0665, Text0666
	quit_script_fully

Script_Chap4:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0667, Text0668
	quit_script_fully
