ScienceClubAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_JOSEPH
	db NPC_JOSEPH
	dw Script_BeatJoseph
	dw Script_LostToJoseph

	db NPC_DAVID
	db NPC_DAVID
	dw Script_BeatDavid
	dw Script_LostToDavid

	db NPC_ERIK
	db NPC_ERIK
	dw Script_BeatErik
	dw Script_LostToErik

	db NPC_RICK
	db NPC_RICK
	dw Script_BeatRick
	dw Script_LostToRick
	db $00

Script_David:
	start_script
	test_if_event_zero EVENT_DAVID_STATE
	print_variable_npc_text Text074f, Text0750
	set_event EVENT_DAVID_STATE, DAVID_TALKED
	ask_question_jump Text0751, .ows_ec27
	print_npc_text Text0752
	quit_script_fully

.ows_ec27
	print_npc_text Text0753
	start_duel PRIZES_4, LOVELY_NIDORAN_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatDavid:
	start_script
	set_event EVENT_DAVID_STATE, DAVID_DEFEATED
	print_npc_text Text0754
	give_booster_packs BOOSTER_MYSTERY_GRASS_COLORLESS, BOOSTER_MYSTERY_GRASS_COLORLESS, NO_BOOSTER
	print_npc_text Text0755
	quit_script_fully

Script_LostToDavid:
	start_script
	print_text_quit_fully Text0756

Script_Erik:
	start_script
	print_npc_text Text0757
	ask_question_jump Text0758, .ows_ec4f
	print_npc_text Text0759
	quit_script_fully

.ows_ec4f
	print_npc_text Text075a
	start_duel PRIZES_4, POISON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatErik:
	start_script
	print_npc_text Text075b
	give_booster_packs BOOSTER_EVOLUTION_GRASS, BOOSTER_EVOLUTION_GRASS, NO_BOOSTER
	print_npc_text Text075c
	quit_script_fully

Script_LostToErik:
	start_script
	print_text_quit_fully Text075d

Script_Rick:
	start_script
	jump_if_event_true EVENT_BEAT_RICK, Script_LostToRick.ows_eca2
	print_npc_text Text075e
	ask_question_jump Text075f, .ows_ec78
	print_npc_text Text0760
	quit_script_fully

.ows_ec78
	print_npc_text Text0761
	start_duel PRIZES_6, WONDERS_OF_SCIENCE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatRick:
	start_script
	jump_if_event_true EVENT_BEAT_RICK, Script_LostToRick.ows_ecb6
	print_npc_text Text0762
	max_out_event_value EVENT_BEAT_RICK
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_RICK
	record_master_win $07
	print_npc_text Text0763
	give_booster_packs BOOSTER_LABORATORY_GRASS, BOOSTER_LABORATORY_GRASS, NO_BOOSTER
	print_npc_text Text0764
	quit_script_fully

Script_LostToRick:
	start_script
	jump_if_event_true EVENT_BEAT_RICK, .ows_ecc1
	print_text_quit_fully Text0765

.ows_eca2
	print_npc_text Text0766
	ask_question_jump Text075f, .ows_ecae
	print_npc_text Text0767
	quit_script_fully

.ows_ecae
	print_npc_text Text0768
	start_duel PRIZES_6, WONDERS_OF_SCIENCE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_ecb6
	print_npc_text Text0769
	give_booster_packs BOOSTER_LABORATORY_GRASS, BOOSTER_LABORATORY_GRASS, NO_BOOSTER
	print_npc_text Text076a
	quit_script_fully

.ows_ecc1
	print_text_quit_fully Text076b

Preload_Joseph:
	ld a, EVENT_BEAT_JOSEPH
	call GetEventValue
	or a
	jr z, .not_defeated
	; move joseph to unblock the science master's room
	ld a, [wLoadNPCXPos]
	add 2
	ld [wLoadNPCXPos], a
	ld a, WEST
	ld [wLoadNPCDirection], a
.not_defeated
	scf
	ret

Script_Joseph:
	start_script
	try_give_pc_pack $08
	jump_if_event_true EVENT_BEAT_JOSEPH, Script_LostToJoseph.ows_ed24
	print_npc_text Text076c
	ask_question_jump Text076d, .ows_ecee
	print_npc_text Text076e
	quit_script_fully

.ows_ecee
	print_npc_text Text076f
	start_duel PRIZES_4, FLYIN_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJoseph:
	start_script
	jump_if_event_true EVENT_BEAT_JOSEPH, Script_LostToJoseph.ows_ed37
	print_npc_text Text0770
	close_text_box
	move_active_npc_by_direction NPCMovementTable_ed11
	set_active_npc_direction WEST
	max_out_event_value EVENT_BEAT_JOSEPH
	print_npc_text Text0771
	give_booster_packs BOOSTER_LABORATORY_GRASS, BOOSTER_LABORATORY_GRASS, NO_BOOSTER
	print_npc_text Text0772
	quit_script_fully

NPCMovementTable_ed11:
	dw NPCMovement_ed19
	dw NPCMovement_ed19
	dw NPCMovement_ed19
	dw NPCMovement_ed19

NPCMovement_ed19:
	db EAST
	db WEST | NO_MOVE
	db $ff

Script_LostToJoseph:
	start_script
	jump_if_event_true EVENT_BEAT_JOSEPH, .ows_ed42
	print_text_quit_fully Text0773

.ows_ed24
	print_npc_text Text0774
	ask_question_jump Text076d, .ows_ed2f
	print_text_quit_fully Text076e

.ows_ed2f
	print_npc_text Text0775
	start_duel PRIZES_4, FLYIN_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

.ows_ed37
	print_npc_text Text0776
	give_booster_packs BOOSTER_LABORATORY_GRASS, BOOSTER_LABORATORY_GRASS, NO_BOOSTER
	print_npc_text Text0777
	quit_script_fully

.ows_ed42
	print_text_quit_fully Text0778
