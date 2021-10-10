FireClubAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_JOHN
	db NPC_JOHN
	dw Script_BeatJohn
	dw Script_LostToJohn

	db NPC_ADAM
	db NPC_ADAM
	dw Script_BeatAdam
	dw Script_LostToAdam

	db NPC_JONATHAN
	db NPC_JONATHAN
	dw Script_BeatJonathan
	dw Script_LostToJonathan

	db NPC_KEN
	db NPC_KEN
	dw Script_BeatKen
	dw Script_LostToKen
	db $00

Script_John:
	start_script
	print_npc_text Text06a5
	ask_question_jump Text06a6, .ows_eec0
	print_npc_text Text06a7
	quit_script_fully

.ows_eec0
	print_npc_text Text06a8
	start_duel PRIZES_4, ANGER_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJohn:
	start_script
	print_npc_text Text06a9
	give_booster_packs BOOSTER_EVOLUTION_FIRE, BOOSTER_EVOLUTION_FIRE, NO_BOOSTER
	print_npc_text Text06aa
	quit_script_fully

Script_LostToJohn:
	start_script
	print_text_quit_fully Text06ab

Script_Adam:
	start_script
	print_npc_text Text06ac
	ask_question_jump Text06ad, .ows_eee5
	print_npc_text Text06ae
	quit_script_fully

.ows_eee5
	print_npc_text Text06af
	start_duel PRIZES_4, FLAMETHROWER_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatAdam:
	start_script
	print_npc_text Text06b0
	give_booster_packs BOOSTER_COLOSSEUM_FIRE, BOOSTER_COLOSSEUM_FIRE, NO_BOOSTER
	print_npc_text Text06b1
	quit_script_fully

Script_LostToAdam:
	start_script
	print_text_quit_fully Text06b2

Script_Jonathan:
	start_script
	print_npc_text Text06b3
	ask_question_jump Text06b4, .ows_ef0a
	print_npc_text Text06b5
	quit_script_fully

.ows_ef0a
	print_npc_text Text06b6
	start_duel PRIZES_4, RESHUFFLE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJonathan:
	start_script
	print_npc_text Text06b7
	give_booster_packs BOOSTER_COLOSSEUM_FIRE, BOOSTER_COLOSSEUM_FIRE, NO_BOOSTER
	print_npc_text Text06b8
	quit_script_fully

Script_LostToJonathan:
	start_script
	print_text_quit_fully Text06b9

Script_Ken:
	start_script
	try_give_pc_pack $09
	jump_if_event_true EVENT_KEN_HAD_ENOUGH_CARDS, .have_300_cards
	jump_if_enough_cards_owned 300, .have_300_cards
	test_if_event_zero EVENT_KEN_TALKED
	print_variable_npc_text Text06ba, Text06bb
	set_event EVENT_KEN_TALKED, TRUE
	quit_script_fully

.have_300_cards
	max_out_event_value EVENT_KEN_HAD_ENOUGH_CARDS
	jump_if_event_true EVENT_BEAT_KEN, Script_Ken_AlreadyHaveMedal
	test_if_event_zero EVENT_KEN_TALKED
	print_variable_npc_text Text06bc, Text06bd
	set_event EVENT_KEN_TALKED, TRUE
	ask_question_jump Text06be, .start_duel
	print_npc_text Text06bf
	quit_script_fully

.start_duel
	print_npc_text Text06c0
	start_duel PRIZES_6, FIRE_CHARGE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatKen:
	start_script
	print_npc_text Text06c1
	jump_if_event_true EVENT_BEAT_KEN, .give_booster_packs
	max_out_event_value EVENT_BEAT_KEN
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_KEN
	record_master_win $08
	print_npc_text Text06c2
.give_booster_packs
	give_booster_packs BOOSTER_MYSTERY_NEUTRAL, BOOSTER_MYSTERY_NEUTRAL, NO_BOOSTER
	print_npc_text Text06c3
	quit_script_fully

Script_LostToKen:
	start_script
	test_if_event_false EVENT_BEAT_KEN
	print_variable_npc_text Text06c4, Text06c5
	quit_script_fully

Script_Ken_AlreadyHaveMedal:
	print_npc_text Text06c6
	ask_question_jump Text06be, .start_duel
	print_text_quit_fully Text06bf

.start_duel
	print_npc_text Text06c7
	start_duel PRIZES_6, FIRE_CHARGE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully
