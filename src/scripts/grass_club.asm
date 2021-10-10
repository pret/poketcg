GrassClubAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_KRISTIN
	db NPC_KRISTIN
	dw Script_BeatKristin
	dw Script_LostToKristin

	db NPC_HEATHER
	db NPC_HEATHER
	dw Script_BeatHeather
	dw Script_LostToHeather

	db NPC_NIKKI
	db NPC_NIKKI
	dw Script_BeatNikki
	dw Script_LostToNikki
	db $00

Script_Kristin:
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	print_variable_npc_text Text0704, Text0705
	ask_question_jump Text0706, .ows_e714
	print_text_quit_fully Text0707

.ows_e714
	print_npc_text Text0708
	start_duel PRIZES_4, FLOWER_GARDEN_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatKristin:
	start_script
	try_give_pc_pack $06
	print_npc_text Text0709
	give_booster_packs BOOSTER_EVOLUTION_GRASS, BOOSTER_EVOLUTION_GRASS, NO_BOOSTER
	print_npc_text Text070a
	max_out_event_value EVENT_BEAT_KRISTIN
	jump_if_event_greater_or_equal EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB, .ows_e740
	jump_if_event_false EVENT_BEAT_BRITTANY, .ows_e740
	jump_if_event_false EVENT_BEAT_HEATHER, .ows_e740
	set_event EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	print_npc_text Text070b
.ows_e740
	quit_script_fully

Script_LostToKristin:
	start_script
	print_text_quit_fully Text070c

Script_Heather:
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	print_variable_npc_text Text070d, Text070e
	ask_question_jump Text070f, .ows_e758
	print_text_quit_fully Text0710

.ows_e758
	print_npc_text Text0711
	start_duel PRIZES_4, KALEIDOSCOPE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatHeather:
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB
	print_variable_npc_text Text0712, Text0713
	give_booster_packs BOOSTER_COLOSSEUM_GRASS, BOOSTER_COLOSSEUM_GRASS, NO_BOOSTER
	print_npc_text Text0714
	max_out_event_value EVENT_BEAT_HEATHER
	jump_if_event_greater_or_equal EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB, .ows_e789
	jump_if_event_false EVENT_BEAT_BRITTANY, .ows_e789
	jump_if_event_false EVENT_BEAT_KRISTIN, .ows_e789
	set_event EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	print_npc_text Text0715
.ows_e789
	quit_script_fully

Script_LostToHeather:
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB
	print_variable_npc_text Text0716, Text0717
	quit_script_fully

Preload_NikkiInGrassClub:
	get_event_value EVENT_NIKKI_STATE
	cp NIKKI_IN_GRASS_CLUB
	ccf
	ret

Script_Nikki:
	ld a, [wCurMap]
	cp ISHIHARAS_HOUSE
	jp z, Script_NikkiInIshiharasHouse

	start_script
	test_if_event_false EVENT_BEAT_NIKKI
	print_variable_npc_text Text0718, Text0719
	ask_question_jump Text071a, .ows_e7bf
	test_if_event_false EVENT_BEAT_NIKKI
	print_variable_npc_text Text071b, Text071c
	quit_script_fully

.ows_e7bf
	jump_if_event_true EVENT_BEAT_NIKKI, .ows_e7cb
	print_npc_text Text071d
	start_duel PRIZES_6, FLOWER_POWER_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_e7cb
	print_npc_text Text071e
	start_duel PRIZES_6, FLOWER_POWER_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatNikki:
	start_script
	test_if_event_false EVENT_BEAT_NIKKI
	print_variable_npc_text Text071f, Text0720
	jump_if_event_true EVENT_BEAT_NIKKI, .ows_e7eb
	max_out_event_value EVENT_BEAT_NIKKI
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_NIKKI
	record_master_win $05
	print_npc_text Text0721
.ows_e7eb
	give_booster_packs BOOSTER_LABORATORY_NEUTRAL, BOOSTER_LABORATORY_NEUTRAL, NO_BOOSTER
	script_jump Script_LostToNikki.ows_e7f3

Script_LostToNikki:
	start_script
.ows_e7f3
	print_text_quit_fully Text0722
