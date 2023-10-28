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
	print_npc_text Man1FirstRequestCardText
	max_out_event_value EVENT_MAN1_WAITING_FOR_CARD
	script_jump .ows_dca5

.ows_dc91
	jump_if_event_false EVENT_MAN1_WAITING_FOR_CARD, .ows_dc9d
	load_man1_requested_card_into_txram_slot 0
	print_npc_text Man1WaitingForCardText
	script_jump .ows_dca5

.ows_dc9d
	pick_next_man1_requested_card
	load_man1_requested_card_into_txram_slot 0
	print_npc_text Man1NewRequestCardText
	max_out_event_value EVENT_MAN1_WAITING_FOR_CARD
.ows_dca5
	load_man1_requested_card_into_txram_slot 0
	ask_question_jump Man1GiveAwayCardText, .ows_dcaf
	print_text_quit_fully Man1DeclineText

.ows_dcaf
	jump_if_man1_requested_card_owned .ows_dcb9
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_text_quit_fully Man1DontHaveText

.ows_dcb9
	jump_if_man1_requested_card_in_collection .ows_dcc3
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_text_quit_fully Man1CardInDeckText

.ows_dcc3
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_npc_text Man1GiveCardText
	remove_man1_requested_card_from_collection
	max_out_event_value EVENT_TEMP_GIFTED_TO_MAN1
	zero_out_event_value EVENT_MAN1_WAITING_FOR_CARD
	increment_event_value EVENT_MAN1_GIFT_SEQUENCE_STATE
	jump_if_event_equal EVENT_MAN1_GIFT_SEQUENCE_STATE, 5, .ows_dcd7
	quit_script_fully

.ows_dcd7
	print_npc_text Man1PlayerReceivePikachuAltLv16Text
	give_card PIKACHU_ALT_LV16
	show_card_received_screen PIKACHU_ALT_LV16
	print_npc_text Man1ThankYouText
	set_event EVENT_MAN1_GIFT_SEQUENCE_STATE, MAN1_GIFT_SEQUENCE_COMPLETE
	quit_script_fully

.ows_dce5
	print_text_quit_fully Man1GaveCardText

.ows_dce8
	print_text_quit_fully Man1GaveAllCardsText

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
	print_variable_npc_text ImakuniWouldLikeToDuelInitialText, ImakuniWouldLikeToDuelRepeatText
	max_out_event_value EVENT_TEMP_TALKED_TO_IMAKUNI
	ask_question_jump ImakuniWouldYouLikeToDuelText, .start_duel
	print_npc_text ImakuniDeclinedDuelText
	quit_script_fully

.start_duel
	print_npc_text ImakuniDuelStartText
	start_duel PRIZES_6, IMAKUNI_DECK_ID, MUSIC_IMAKUNI
	quit_script_fully

Script_BeatImakuni:
	start_script
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 7, .give_boosters
	increment_event_value EVENT_IMAKUNI_WIN_COUNT
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 3, .three_wins
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 6, .six_wins
.give_boosters
	print_npc_text ImakuniPlayerWonNormalText
	give_one_of_each_trainer_booster
	script_jump .done

.three_wins
	print_npc_text ImakuniPlayerWonThreeWinsText
	script_jump .give_imakuni_card

.six_wins
	print_npc_text ImakuniPlayerWonSixWinsText
.give_imakuni_card
	print_npc_text ImakuniGivesImakuniText
	give_card IMAKUNI_CARD
	show_card_received_screen IMAKUNI_CARD
.done
	print_npc_text ImakuniPlayerWonEndText
	script_jump Script_LostToImakuni.imakuni_common

Script_LostToImakuni:
	start_script
	print_npc_text ImakuniPlayerLostText
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
	print_variable_npc_text Specs1NormalText, Specs1PlayerIsChampionText
	quit_script_fully

Script_Butch:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text ButchNormalText, ButchPlayerIsChampionText
	quit_script_fully

Preload_Granny1:
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ret

Script_Granny1:
	start_script
	print_text_quit_fully Granny1Text
