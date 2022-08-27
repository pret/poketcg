Preload_NikkiInIshiharasHouse:
	get_event_value EVENT_NIKKI_STATE
	cp NIKKI_IN_ISHIHARAS_HOUSE
	jr nz, .dont_load
	scf
	ret
.dont_load
	or a
	ret

Script_NikkiInIshiharasHouse:
	start_script
	print_npc_text Text0723
	set_event EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB
	close_text_box
	jump_if_npc_loaded NPC_ISHIHARA, .ows_dafb
	move_active_npc_by_direction NPCMovementTable_db24
	script_jump .ows_db0f

.ows_dafb
	move_active_npc_by_direction NPCMovementTable_db11
	print_npc_text Text0724
	set_dialog_npc NPC_ISHIHARA
	print_npc_text Text0725
	set_dialog_npc NPC_NIKKI
	print_npc_text Text0726
	close_text_box
	move_active_npc NPCMovement_db31
.ows_db0f
	unload_active_npc
	quit_script_fully

NPCMovementTable_db11:
	dw NPCMovement_db19
	dw NPCMovement_db20
	dw NPCMovement_db19
	dw NPCMovement_db19

NPCMovement_db19:
	db EAST
	db SOUTH
	db SOUTH
	db SOUTH
	db EAST
	db NORTH | NO_MOVE
	db $ff

NPCMovement_db20:
	db SOUTH
	db EAST
	db $fe, -8

NPCMovementTable_db24:
	dw NPCMovement_db2c
	dw NPCMovement_db39
	dw NPCMovement_db2c
	dw NPCMovement_db2c

NPCMovement_db2c:
	db EAST
	db SOUTH
	db SOUTH
	db SOUTH
	db EAST
NPCMovement_db31:
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

NPCMovement_db39:
	db SOUTH
	db EAST
	db $fe, -14

Preload_IshiharaInIshiharasHouse:
	get_event_value EVENT_ISHIHARA_MENTIONED
	or a
	ret z
	get_event_value EVENT_ISHIHARA_TRADE_STATE
	cp ISHIHARA_LEFT
	ret

Script_Ishihara:
	start_script
	max_out_event_value EVENT_ISHIHARA_MET
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_INTRODUCTION, .ows_db80
	jump_if_event_true EVENT_ISHIHARA_CONGRATULATED_PLAYER, .ows_db5a
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_dc3e
.ows_db5a
	jump_if_event_true EVENT_TEMP_TRADED_WITH_ISHIHARA, .ows_db90
	jump_if_event_false EVENT_ISHIHARA_WANTS_TO_TRADE, .ows_db90
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_RUMORED, .ows_db93
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_OFFERED, .ows_db93
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED, .ows_dbcc
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_OFFERED, .ows_dbcc
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED, .ows_dc05
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_OFFERED, .ows_dc05
.ows_db80
	max_out_event_value EVENT_TEMP_TRADED_WITH_ISHIHARA
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_RUMORED
	zero_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	jump_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS, .ows_db8d
	max_out_event_value EVENT_ISHIHARA_CONGRATULATED_PLAYER
.ows_db8d
	print_text_quit_fully Text0727

.ows_db90
	print_text_quit_fully Text0728

.ows_db93
	test_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_RUMORED
	print_variable_npc_text Text0729, Text072a
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_OFFERED
	ask_question_jump Text072b, .check_if_clefable_owned
	print_text_quit_fully Text072c

.check_if_clefable_owned
	jump_if_card_owned CLEFABLE, .check_if_clefable_in_collection
	print_text_quit_fully Text072d

.check_if_clefable_in_collection
	jump_if_card_in_collection CLEFABLE, .do_clefable_trade
	print_text_quit_fully Text072e

.do_clefable_trade
	max_out_event_value EVENT_TEMP_TRADED_WITH_ISHIHARA
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED
	zero_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_npc_text Text072f
	print_text Text0730
	take_card CLEFABLE
	give_card SURFING_PIKACHU_LV13
	show_card_received_screen SURFING_PIKACHU_LV13
	print_text_quit_fully Text0731

.ows_dbcc
	test_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED
	print_variable_npc_text Text0732, Text0733
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_OFFERED
	ask_question_jump Text072b, .check_if_ditto_owned
	print_text_quit_fully Text072c

.check_if_ditto_owned
	jump_if_card_owned DITTO, .check_if_ditto_in_collection
	print_text_quit_fully Text0734

.check_if_ditto_in_collection
	jump_if_card_in_collection DITTO, .do_ditto_trade
	print_text_quit_fully Text0735

.do_ditto_trade
	max_out_event_value EVENT_TEMP_TRADED_WITH_ISHIHARA
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED
	zero_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_npc_text Text072f
	print_text Text0736
	take_card DITTO
	give_card FLYING_PIKACHU
	show_card_received_screen FLYING_PIKACHU
	print_text_quit_fully Text0737

.ows_dc05
	test_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED
	print_variable_npc_text Text0738, Text0739
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_OFFERED
	ask_question_jump Text072b, .check_if_chansey_owned
	print_text_quit_fully Text072c

.check_if_chansey_owned
	jump_if_card_owned CHANSEY, .check_if_chansey_in_collection
	print_text_quit_fully Text073a

.check_if_chansey_in_collection
	jump_if_card_in_collection CHANSEY, .do_chansey_trade
	print_text_quit_fully Text073b

.do_chansey_trade
	max_out_event_value EVENT_TEMP_TRADED_WITH_ISHIHARA
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADES_COMPLETE
	zero_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_npc_text Text072f
	print_text Text073c
	take_card CHANSEY
	give_card SURFING_PIKACHU_ALT_LV13
	show_card_received_screen SURFING_PIKACHU_ALT_LV13
	print_text_quit_fully Text073d

.ows_dc3e
	max_out_event_value EVENT_ISHIHARA_CONGRATULATED_PLAYER
	print_text_quit_fully Text073e

Preload_Ronald1InIshiharasHouse:
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ccf
	ret

Script_Ronald:
	start_script
	jump_if_event_true EVENT_RONALD_TALKED, .ows_dc55
	max_out_event_value EVENT_RONALD_TALKED
	print_text_quit_fully Text073f

.ows_dc55
	print_npc_text Text0740
	ask_question_jump Text0741, .ows_dc60
	print_text_quit_fully Text0742

.ows_dc60
	print_text_quit_fully Text0743

	; could be a commented function, or could be placed by mistake from
	; someone thinking that the Ronald script ended with more code execution
	ret
