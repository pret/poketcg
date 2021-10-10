PsychicClubAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_DANIEL
	db NPC_DANIEL
	dw Script_BeatDaniel
	dw Script_LostToDaniel

	db NPC_STEPHANIE
	db NPC_STEPHANIE
	dw Script_BeatStephanie
	dw Script_LostToStephanie

	db NPC_MURRAY1
	db NPC_MURRAY1
	dw Script_BeatMurray
	dw Script_LostToMurray
	db $00

Script_Daniel:
	start_script
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 4, .ows_ea7e
	jump_if_event_true EVENT_DANIEL_TALKED, .ows_ea70
	max_out_event_value EVENT_DANIEL_TALKED
	print_npc_text Text0669
.ows_ea70
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 1, .ows_ea78
	print_text_quit_fully Text066a

.ows_ea78
	print_npc_text Text066b
	script_jump .ows_ea81

.ows_ea7e
	print_npc_text Text066c
.ows_ea81
	ask_question_jump Text066d, .ows_ea8a
	print_npc_text Text066e
	quit_script_fully

.ows_ea8a
	print_npc_text Text066f
	start_duel PRIZES_4, NAP_TIME_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatDaniel:
	start_script
	print_npc_text Text0670
	give_booster_packs BOOSTER_EVOLUTION_PSYCHIC, BOOSTER_EVOLUTION_PSYCHIC, NO_BOOSTER
	print_npc_text Text0671
	quit_script_fully

Script_LostToDaniel:
	start_script
	print_text_quit_fully Text0672

Script_Stephanie:
	start_script
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 2, .ows_eaac
	print_text_quit_fully Text0673

.ows_eaac
	print_npc_text Text0674
	ask_question_jump Text0675, .ows_eab8
	print_npc_text Text0676
	quit_script_fully

.ows_eab8
	print_npc_text Text0677
	start_duel PRIZES_4, STRANGE_POWER_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatStephanie:
	start_script
	print_npc_text Text0678
	give_booster_packs BOOSTER_LABORATORY_PSYCHIC, BOOSTER_LABORATORY_PSYCHIC, NO_BOOSTER
	print_npc_text Text0679
	quit_script_fully

Script_LostToStephanie:
	start_script
	print_text_quit_fully Text067a

Preload_Murray2:
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	cp 4
	ret

Preload_Murray1:
	call Preload_Murray2
	ccf
	ret

Script_Murray:
	start_script
	try_give_pc_pack $07
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 4, .ows_eaef
	print_npc_text Text067b
	print_text Text067c
	quit_script_fully

.ows_eaef
	jump_if_event_true EVENT_BEAT_MURRAY, Script_LostToMurray.ows_eb31
	test_if_event_false EVENT_MURRAY_TALKED
	print_variable_npc_text Text067d, Text067e
	max_out_event_value EVENT_MURRAY_TALKED
	ask_question_jump Text067f, .ows_eb07
	print_npc_text Text0680
	quit_script_fully

.ows_eb07
	print_npc_text Text0681
	start_duel PRIZES_6, STRANGE_PSYSHOCK_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatMurray:
	start_script
	jump_if_event_true EVENT_BEAT_MURRAY, Script_LostToMurray.ows_eb45
	print_npc_text Text0682
	max_out_event_value EVENT_BEAT_MURRAY
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_MURRAY
	record_master_win $06
	print_npc_text Text0683
	give_booster_packs BOOSTER_LABORATORY_PSYCHIC, BOOSTER_LABORATORY_PSYCHIC, NO_BOOSTER
	print_npc_text Text0684
	quit_script_fully

Script_LostToMurray:
	start_script
	jump_if_event_true EVENT_BEAT_MURRAY, .ows_eb50
	print_text_quit_fully Text0685

.ows_eb31
	print_npc_text Text0686
	ask_question_jump Text067f, .ows_eb3d
	print_npc_text Text0687
	quit_script_fully

.ows_eb3d
	print_npc_text Text0688
	start_duel PRIZES_6, STRANGE_PSYSHOCK_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_eb45
	print_npc_text Text0689
	give_booster_packs BOOSTER_LABORATORY_PSYCHIC, BOOSTER_LABORATORY_PSYCHIC, NO_BOOSTER
	print_npc_text Text068a
	quit_script_fully

.ows_eb50
	print_text_quit_fully Text068b
