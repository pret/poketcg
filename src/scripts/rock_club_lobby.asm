RockClubLobbyAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_CHRIS
	db NPC_CHRIS
	dw Script_BeatChrisInRockClubLobby
	dw Script_LostToChrisInRockClubLobby

	db NPC_MATTHEW
	db NPC_MATTHEW
	dw Script_BeatMatthew
	dw Script_LostToMatthew
	db $00

Preload_ChrisInRockClubLobby:
	get_event_value EVENT_PUPIL_CHRIS_STATE
	or a ; cp PUPIL_INACTIVE
	ret z
	cp PUPIL_DEFEATED
	ret

Script_Chris:
	start_script
	jump_if_event_greater_or_equal EVENT_PUPIL_CHRIS_STATE, PUPIL_DEFEATED, Script_de4b
	print_npc_text Text077a
	ask_question_jump Text077b, .ows_df04
	print_npc_text Text077c
	quit_script_fully

.ows_df04
	print_npc_text Text077d
	start_duel PRIZES_4, MUSCLES_FOR_BRAINS_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatChrisInRockClubLobby:
	start_script
	set_event EVENT_PUPIL_CHRIS_STATE, PUPIL_DEFEATED
	print_npc_text Text077e
	give_booster_packs BOOSTER_EVOLUTION_FIGHTING, BOOSTER_EVOLUTION_FIGHTING, NO_BOOSTER
	print_npc_text Text077f
	close_text_box
	move_active_npc_by_direction NPCMovementTable_df24
	unload_active_npc
	quit_script_fully

Script_LostToChrisInRockClubLobby:
	start_script
	print_text_quit_fully Text0780

NPCMovementTable_df24:
	dw NPCMovement_df2c
	dw NPCMovement_df2c
	dw NPCMovement_df34
	dw NPCMovement_df2c

NPCMovement_df2c:
	db SOUTH
	db SOUTH
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

NPCMovement_df34:
	db EAST
	db SOUTH
	db SOUTH
	db $fe, -9

Script_Matthew:
	start_script
	try_give_pc_pack $03
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_df4c
	test_if_event_zero EVENT_MATTHEW_STATE
	print_variable_npc_text Text0781, Text0782
	script_jump .ows_df4f

.ows_df4c
	print_npc_text Text0783
.ows_df4f
	set_event EVENT_MATTHEW_STATE, MATTHEW_TALKED
	ask_question_jump Text0784, .ows_df5b
	print_npc_text Text0785
	quit_script_fully

.ows_df5b
	print_npc_text Text0786
	start_duel PRIZES_4, HARD_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatMatthew:
	start_script
	set_event EVENT_MATTHEW_STATE, MATTHEW_DEFEATED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0787, Text0788
	give_booster_packs BOOSTER_MYSTERY_FIGHTING_COLORLESS, BOOSTER_MYSTERY_FIGHTING_COLORLESS, NO_BOOSTER
	print_npc_text Text0789
	quit_script_fully

Script_LostToMatthew:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text078a, Text078b
	quit_script_fully

Script_Woman1:
	start_script
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADES_COMPLETE, .ows_dfba
	jump_if_event_true EVENT_ISHIHARA_MET, .ows_df96
	max_out_event_value EVENT_ISHIHARA_MENTIONED
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text078c

.ows_df96
	jump_if_event_true EVENT_TEMP_TRADED_WITH_ISHIHARA, .ows_dfb7
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED, .ows_dfae
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED, .ows_dfa9
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text078d

.ows_dfa9
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text078e

.ows_dfae
	jump_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS, .ows_dfb7
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text078f

.ows_dfb7
	print_text_quit_fully Text0790

.ows_dfba
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_LEFT
	print_text_quit_fully Text0791

Script_Chap1:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0792, Text0793
	quit_script_fully

Preload_Lass3:
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ret

Script_Lass3:
	start_script
	print_text_quit_fully Text0794
