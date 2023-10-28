WaterClubLobbyAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_IMAKUNI
	db NPC_IMAKUNI
	dw Script_BeatImakuni
	dw Script_LostToImakuni
	db $00

Preload_ImakuniInWaterClubLobby:
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_TALKED
	jr c, .dont_load
	get_event_value EVENT_TEMP_DUELED_IMAKUNI
	jr nz, .dont_load
	get_event_value EVENT_IMAKUNI_ROOM
	cp IMAKUNI_WATER_CLUB
	jr z, .load_imakuni
.dont_load
	or a
	ret

.load_imakuni
	ld a, MUSIC_IMAKUNI
	ld [wDefaultSong], a
	scf
	ret

Script_Gal1:
	start_script
	jump_if_event_equal EVENT_GAL1_TRADE_STATE, GAL1_TRADE_COMPLETED, .ows_e10e
	test_if_event_equal EVENT_GAL1_TRADE_STATE, GAL1_TRADE_NOT_OFFERED
	print_variable_npc_text Gal1WantToTrade1Text, Gal1WantToTrade2Text
	set_event EVENT_GAL1_TRADE_STATE, GAL1_TRADE_OFFERED
	ask_question_jump Gal1WouldYouLikeToTradeText, .ows_e0eb
	print_npc_text Gal1DeclinedTradeText
	quit_script_fully

.ows_e0eb
	jump_if_card_owned LAPRAS, .ows_e0f3
	print_npc_text Gal1DontOwnCardText
	quit_script_fully

.ows_e0f3
	jump_if_card_in_collection LAPRAS, .ows_e0fb
	print_npc_text Gal1CardInDeckText
	quit_script_fully

.ows_e0fb
	set_event EVENT_GAL1_TRADE_STATE, GAL1_TRADE_COMPLETED
	print_npc_text Gal1LetsTradeText
	print_text Gal1TradeCompleteText
	take_card LAPRAS
	give_card ARCANINE_LV34
	show_card_received_screen ARCANINE_LV34
	print_npc_text Gal1ThanksText
	quit_script_fully

.ows_e10e
	print_text_quit_fully Gal1AfterTradeText

Script_Lass1:
	start_script
	jump_if_event_equal EVENT_LASS1_MENTIONED_IMAKUNI, TRUE, .ows_e121
	print_npc_text Lass1NormalText
	set_event EVENT_LASS1_MENTIONED_IMAKUNI, TRUE
	set_event EVENT_IMAKUNI_STATE, IMAKUNI_MENTIONED
	quit_script_fully

.ows_e121
	jump_if_event_not_equal EVENT_IMAKUNI_ROOM, IMAKUNI_WATER_CLUB, .ows_e12d
	jump_if_event_true EVENT_TEMP_DUELED_IMAKUNI, .ows_e12d
	print_text_quit_fully Lass1ImakuniHereText

.ows_e12d
	print_text_quit_fully Lass1ImakuniLeftText

Preload_Man2:
	get_event_value EVENT_JOSHUA_STATE
	cp JOSHUA_DEFEATED
	ret

Script_Man2:
	start_script
	print_text_quit_fully Man2Text

Script_Pappy2:
	start_script
	print_text_quit_fully Pappy2Text
