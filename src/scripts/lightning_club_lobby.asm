LightningClubLobbyAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_IMAKUNI
	db NPC_IMAKUNI
	dw Script_BeatImakuni
	dw Script_LostToImakuni
	db $00

Preload_ImakuniInLightningClubLobby:
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_TALKED
	jr c, .dont_load
	get_event_value EVENT_TEMP_DUELED_IMAKUNI
	jr nz, .dont_load
	get_event_value EVENT_IMAKUNI_ROOM
	cp IMAKUNI_LIGHTNING_CLUB
	jr z, .load_imakuni
.dont_load
	or a
	ret

.load_imakuni
	ld a, MUSIC_IMAKUNI
	ld [wDefaultSong], a
	scf
	ret

Script_Chap2:
	start_script
	jump_if_event_equal EVENT_CHAP2_TRADE_STATE, CHAP2_TRADE_COMPLETED, .ows_e3d6
	test_if_event_equal EVENT_CHAP2_TRADE_STATE, CHAP2_TRADE_NOT_OFFERED
	print_variable_npc_text Text060f, Text0610
	set_event EVENT_CHAP2_TRADE_STATE, CHAP2_TRADE_OFFERED
	ask_question_jump Text0611, .ows_e3b6
	print_npc_text Text0612
	quit_script_fully

.ows_e3b6
	jump_if_card_owned ELECTABUZZ_LV35, .ows_e3be
	print_npc_text Text0613
	quit_script_fully

.ows_e3be
	jump_if_card_in_collection ELECTABUZZ_LV35, .ows_e3c6
	print_npc_text Text0614
	quit_script_fully

.ows_e3c6
	set_event EVENT_CHAP2_TRADE_STATE, CHAP2_TRADE_COMPLETED
	print_npc_text Text0615
	take_card ELECTABUZZ_LV35
	give_card ELECTABUZZ_LV20
	show_card_received_screen ELECTABUZZ_LV20
	print_npc_text Text0616
	quit_script_fully

.ows_e3d6
	print_text_quit_fully Text0617

Script_Lass4:
	start_script
	print_text_quit_fully Text0618

Script_Hood1:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0619, Text061a
	quit_script_fully
