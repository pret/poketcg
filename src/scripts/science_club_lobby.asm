ScienceClubLobbyAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_IMAKUNI
	db NPC_IMAKUNI
	dw Script_BeatImakuni
	dw Script_LostToImakuni
	db $00

Preload_ImakuniInScienceClubLobby:
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_TALKED
	jr c, .dont_load
	get_event_value EVENT_TEMP_DUELED_IMAKUNI
	jr nz, .dont_load
	get_event_value EVENT_IMAKUNI_ROOM
	cp IMAKUNI_SCIENCE_CLUB
	jr z, .load_imakuni
.dont_load
	or a
	ret

.load_imakuni
	ld a, MUSIC_IMAKUNI
	ld [wDefaultSong], a
	scf
	ret

Script_Lad1:
	start_script
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADES_COMPLETE, .ows_ebbb
	jump_if_event_true EVENT_ISHIHARA_MET, .ows_eb97
	max_out_event_value EVENT_ISHIHARA_MENTIONED
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0745

.ows_eb97
	jump_if_event_true EVENT_TEMP_TRADED_WITH_ISHIHARA, .ows_ebb8
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED, .ows_ebaf
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED, .ows_ebaa
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0746

.ows_ebaa
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0747

.ows_ebaf
	jump_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS, .ows_ebb8
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0748

.ows_ebb8
	print_text_quit_fully Text0749

.ows_ebbb
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_LEFT
	print_text_quit_fully Text074a

Script_Man3:
	start_script
	print_text_quit_fully Text074b

Script_Specs2:
	call UpdateRNGSources
	and %11
	ld c, a
	ld b, 0
	ld hl, Data_ebe7
	add hl, bc
	ld e, [hl]
	ld d, 0
	call GetCardName
	ld hl, wTxRam2
	ld a, e
	ld [hli], a
	ld [hl], d

	start_script
	print_npc_text Text074c
	move_active_npc NPCMovement_ebeb
	print_text_quit_fully Text074d

Data_ebe7:
	db PORYGON
	db DITTO
	db MUK
	db WEEZING

NPCMovement_ebeb:
	db WEST | NO_MOVE
	db $ff

Script_Specs3:
	start_script
	print_text_quit_fully Text074e
