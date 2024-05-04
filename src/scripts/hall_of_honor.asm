HallOfHonorLoadMap:
	ld a, SFX_LEGENDARY_CARDS
	call PlaySFX
	ret

Script_fbe1:
	start_script
	print_text Text05b5
	ask_question_jump_default_yes Text05b6, .ows_fbee
	print_text Text05b7
	quit_script_fully

.ows_fbee
	open_deck_machine DECK_MACHINE_LEGENDARY
	quit_script_fully

Script_fbf1:
	start_script
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_fc10
	max_out_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	print_text Text05b8
	give_card ZAPDOS_LV68
	give_card MOLTRES_LV37
	give_card ARTICUNO_LV37
	give_card DRAGONITE_LV41
	show_card_received_screen $ff
.ows_fc05
	flash_screen 0
	print_text Text05b9
.ows_fc0a
	flash_screen 1
	save_game 1
	play_credits
	quit_script_fully

.ows_fc10
	jump_if_event_equal EVENT_LEGENDARY_CARDS_RECEIVED_FLAGS, %1111, .ows_fc20
	pick_legendary_card
	print_text Text05ba
	give_card VARIABLE_CARD
	show_card_received_screen VARIABLE_CARD
	script_jump .ows_fc05

.ows_fc20
	print_text Text05bb
	flash_screen 0
	print_text Text05bc
	script_jump .ows_fc0a
