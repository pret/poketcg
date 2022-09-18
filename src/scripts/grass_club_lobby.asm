GrassClubLobbyAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_BRITTANY
	db NPC_BRITTANY
	dw Script_BeatBrittany
	dw Script_LostToBrittany
	db $00

Script_Brittany:
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	print_variable_npc_text Text06e0, Text06e1
	ask_question_jump Text06e2, .start_duel
	print_npc_text Text06e3
	quit_script_fully

.start_duel
	print_npc_text Text06e4
	start_duel PRIZES_4, ETCETERA_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatBrittany:
	start_script
	print_npc_text Text06e5
	give_booster_packs BOOSTER_MYSTERY_GRASS_COLORLESS, BOOSTER_MYSTERY_GRASS_COLORLESS, NO_BOOSTER
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB
	print_variable_npc_text Text06e6, Text06e7
	max_out_event_value EVENT_BEAT_BRITTANY
	jump_if_event_greater_or_equal EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB, .quit
	jump_if_event_false EVENT_BEAT_KRISTIN, .quit
	jump_if_event_false EVENT_BEAT_HEATHER, .quit
	set_event EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	print_npc_text Text06e8
.quit
	quit_script_fully

Script_LostToBrittany:
	start_script
	print_text_quit_fully Text06e9

Script_e61c:
	print_text_quit_fully Text06ea

Script_Lass2:
	start_script
	jump_if_event_true EVENT_TEMP_TRADED_WITH_LASS2, Script_e61c
	jump_if_event_greater_or_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADES_COMPLETE, Script_e61c
	jump_if_event_greater_or_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_3_AVAILABLE, .ows_e6a1
	jump_if_event_greater_or_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_2_AVAILABLE, .ows_e66a
	test_if_event_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_1_AVAILABLE
	print_variable_npc_text Text06eb, Text06ec
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_1_OFFERED
	ask_question_jump Text06ed, .ows_e648
	print_text_quit_fully Text06ee

.ows_e648
	jump_if_card_owned ODDISH, .ows_e64f
	print_text_quit_fully Text06ef

.ows_e64f
	jump_if_card_in_collection ODDISH, .ows_e656
	print_text_quit_fully Text06f0

.ows_e656
	max_out_event_value EVENT_TEMP_TRADED_WITH_LASS2
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_2_AVAILABLE
	print_npc_text Text06f1
	print_text Text06f2
	take_card ODDISH
	give_card VILEPLUME
	show_card_received_screen VILEPLUME
	print_text_quit_fully Text06f3

.ows_e66a
	test_if_event_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_2_AVAILABLE
	print_variable_npc_text Text06f4, Text06f5
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_2_OFFERED
	ask_question_jump Text06ed, .ows_e67f
	print_text_quit_fully Text06f6

.ows_e67f
	jump_if_card_owned CLEFAIRY, .ows_e686
	print_text_quit_fully Text06f7

.ows_e686
	jump_if_card_in_collection CLEFAIRY, .ows_e68d
	print_text_quit_fully Text06f8

.ows_e68d
	max_out_event_value EVENT_TEMP_TRADED_WITH_LASS2
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_3_AVAILABLE
	print_npc_text Text06f9
	print_text Text06fa
	take_card CLEFAIRY
	give_card PIKACHU_LV16
	show_card_received_screen PIKACHU_LV16
	print_text_quit_fully Text06f3

.ows_e6a1
	test_if_event_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_3_AVAILABLE
	print_variable_npc_text Text06fb, Text06fc
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_3_OFFERED
	ask_question_jump Text06ed, .ows_e6b6
	print_text_quit_fully Text06fd

.ows_e6b6
	jump_if_card_owned CHARIZARD, .ows_e6bd
	print_text_quit_fully Text06fe

.ows_e6bd
	jump_if_card_in_collection CHARIZARD, .ows_e6c4
	print_text_quit_fully Text06ff

.ows_e6c4
	max_out_event_value EVENT_TEMP_TRADED_WITH_LASS2
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADES_COMPLETE
	print_npc_text Text0700
	print_text Text0701
	take_card CHARIZARD
	give_card BLASTOISE
	show_card_received_screen BLASTOISE
	print_text_quit_fully Text06f3

Script_Granny2:
	start_script
	print_text_quit_fully Text0702

Preload_Gal2:
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ret

Script_Gal2:
	start_script
	print_text_quit_fully Text0703
