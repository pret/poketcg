FightingClubLobbyAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_IMAKUNI
	db NPC_IMAKUNI
	dw Script_BeatImakuni
	dw Script_LostToImakuni
	db $00

Script_Man1:
	start_script
	jump_if_event_equal EVENT_MAN1_GIFT_SEQUENCE_STATE, MAN1_GIFT_SEQUENCE_COMPLETE, .ows_dce8
	jump_if_event_true EVENT_TEMP_GIFTED_TO_MAN1, .ows_dce5
	jump_if_event_true EVENT_MAN1_TALKED, .ows_dc91
	max_out_event_value EVENT_MAN1_TALKED
	pick_next_man1_requested_card
	load_man1_requested_card_into_txram_slot 0
	print_npc_text Text045b
	max_out_event_value EVENT_MAN1_WAITING_FOR_CARD
	script_jump .ows_dca5

.ows_dc91
	jump_if_event_false EVENT_MAN1_WAITING_FOR_CARD, .ows_dc9d
	load_man1_requested_card_into_txram_slot 0
	print_npc_text Text045c
	script_jump .ows_dca5

.ows_dc9d
	pick_next_man1_requested_card
	load_man1_requested_card_into_txram_slot 0
	print_npc_text Text045d
	max_out_event_value EVENT_MAN1_WAITING_FOR_CARD
.ows_dca5
	load_man1_requested_card_into_txram_slot 0
	ask_question_jump Text045e, .ows_dcaf
	print_text_quit_fully Text045f

.ows_dcaf
	jump_if_man1_requested_card_owned .ows_dcb9
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_text_quit_fully Text0460

.ows_dcb9
	jump_if_man1_requested_card_in_collection .ows_dcc3
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_text_quit_fully Text0461

.ows_dcc3
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_npc_text Text0462
	remove_man1_requested_card_from_collection
	max_out_event_value EVENT_TEMP_GIFTED_TO_MAN1
	zero_out_event_value EVENT_MAN1_WAITING_FOR_CARD
	increment_event_value EVENT_MAN1_GIFT_SEQUENCE_STATE
	jump_if_event_equal EVENT_MAN1_GIFT_SEQUENCE_STATE, 5, .ows_dcd7
	quit_script_fully

.ows_dcd7
	print_npc_text Text0463
	give_card PIKACHU_ALT_LV16
	show_card_received_screen PIKACHU_ALT_LV16
	print_npc_text Text0464
	set_event EVENT_MAN1_GIFT_SEQUENCE_STATE, MAN1_GIFT_SEQUENCE_COMPLETE
	quit_script_fully

.ows_dce5
	print_text_quit_fully Text0465

.ows_dce8
	print_text_quit_fully Text0466

Preload_ImakuniInFightingClubLobby:
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_MENTIONED
	jr z, .load_imakuni
	or a ; cp IMAKUNI_NOT_MENTIONED
	jr z, .dont_load
	get_event_value EVENT_TEMP_DUELED_IMAKUNI
	jr nz, .dont_load
	get_event_value EVENT_IMAKUNI_ROOM
	cp IMAKUNI_FIGHTING_CLUB
	jr z, .load_imakuni
.dont_load
	or a
	ret

.load_imakuni
	ld a, MUSIC_IMAKUNI
	ld [wDefaultSong], a
	scf
	ret

Script_Imakuni:
	start_script
	set_event EVENT_IMAKUNI_STATE, IMAKUNI_TALKED
	test_if_event_false EVENT_TEMP_TALKED_TO_IMAKUNI
	print_variable_npc_text Text0467, Text0468
	max_out_event_value EVENT_TEMP_TALKED_TO_IMAKUNI
	ask_question_jump Text0469, .start_duel
	print_npc_text Text046a
	quit_script_fully

.start_duel
	print_npc_text Text046b
	start_duel PRIZES_6, IMAKUNI_DECK_ID, MUSIC_IMAKUNI
	quit_script_fully

Script_BeatImakuni:
	start_script
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 7, .give_boosters
	increment_event_value EVENT_IMAKUNI_WIN_COUNT
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 3, .three_wins
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 6, .six_wins
.give_boosters
	print_npc_text Text046c
	give_one_of_each_trainer_booster
	script_jump .done

.three_wins
	print_npc_text Text046d
	script_jump .give_imakuni_card

.six_wins
	print_npc_text Text046e
.give_imakuni_card
	print_npc_text Text046f
	give_card IMAKUNI_CARD
	show_card_received_screen IMAKUNI_CARD
.done
	print_npc_text Text0470
	script_jump Script_LostToImakuni.imakuni_common

Script_LostToImakuni:
	start_script
	print_npc_text Text0471
.imakuni_common
	close_text_box
	jump_if_player_coords_match 18, 4, .ows_dd69
	script_jump .ows_dd6e

.ows_dd69
	set_player_direction EAST
	move_player WEST, 1
.ows_dd6e
	move_active_npc NPCMovement_dd78
	unload_active_npc
	max_out_event_value EVENT_TEMP_DUELED_IMAKUNI
	set_default_song MUSIC_OVERWORLD
	play_default_song
	quit_script_fully

NPCMovement_dd78:
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

Script_Specs1:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0472, Text0473
	quit_script_fully

Script_Butch:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0474, Text0475
	quit_script_fully

Preload_Granny1:
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ret

Script_Granny1:
	start_script
	print_text_quit_fully Text0476
