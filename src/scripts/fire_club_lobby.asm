FireClubLobbyAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_JESSICA
	db NPC_JESSICA
	dw Script_BeatJessicaInFireClubLobby
	dw Script_LostToJessicaInFireClubLobby
	db $00

FireClubPressedA:
	ld hl, SlowpokePaintingObjectTable
	call FindExtraInteractableObjects
	ret

SlowpokePaintingObjectTable:
	db 16, 2, NORTH
	dw Script_ee76
	db $00

; Given a table with data of the form:
;	X, Y, Dir, Script
; Searches to try to find a match, and starts a Script if possible
FindExtraInteractableObjects:
	ld de, 5
.loop
	ld a, [hl]
	or a
	ret z
	push hl
	ld a, [wPlayerXCoord]
	cp [hl]
	jr nz, .not_match
	inc hl
	ld a, [wPlayerYCoord]
	cp [hl]
	jr nz, .not_match
	inc hl
	ld a, [wPlayerDirection]
	cp [hl]
	jr z, .match
.not_match
	pop hl
	add hl, de
	jr .loop
.match
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	call SetNextScript
	scf
	ret

Preload_JessicaInFireClubLobby:
	get_event_value EVENT_PUPIL_JESSICA_STATE
	or a ; cp PUPIL_INACTIVE
	ret z
	cp PUPIL_DEFEATED
	ret

Script_Jessica:
	start_script
	jump_if_event_greater_or_equal EVENT_PUPIL_JESSICA_STATE, PUPIL_DEFEATED, Script_dead
	test_if_event_equal EVENT_PUPIL_JESSICA_STATE, PUPIL_ACTIVE
	print_variable_npc_text Text068d, Text068e
	set_event EVENT_PUPIL_JESSICA_STATE, PUPIL_TALKED
	ask_question_jump Text068f, .ows_edb2
	print_npc_text Text0690
	quit_script_fully

.ows_edb2
	print_npc_text Text0691
	start_duel PRIZES_4, LOVE_TO_BATTLE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJessicaInFireClubLobby:
	start_script
	set_event EVENT_PUPIL_JESSICA_STATE, PUPIL_DEFEATED
	print_npc_text Text0692
	give_booster_packs BOOSTER_COLOSSEUM_FIGHTING, BOOSTER_COLOSSEUM_FIGHTING, NO_BOOSTER
	print_npc_text Text0693
	close_text_box
	move_active_npc_by_direction NPCMovementTable_edd2
	unload_active_npc
	quit_script_fully

Script_LostToJessicaInFireClubLobby:
	start_script
	print_text_quit_fully Text0694

NPCMovementTable_edd2:
	dw NPCMovement_edda
	dw NPCMovement_ede4
	dw NPCMovement_edda
	dw NPCMovement_edda

NPCMovement_edda:
	db EAST
	db NORTH
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

NPCMovement_ede4:
	db NORTH
	db EAST
	db $fe, -11

Script_Chap3:
	start_script
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADES_COMPLETE, .ows_ee1f
	jump_if_event_true EVENT_ISHIHARA_MET, .ows_edfb
	max_out_event_value EVENT_ISHIHARA_MENTIONED
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0695

.ows_edfb
	jump_if_event_true EVENT_TEMP_TRADED_WITH_ISHIHARA, .ows_ee1c
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED, .ows_ee13
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED, .ows_ee0e
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0696

.ows_ee0e
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0697

.ows_ee13
	jump_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS, .ows_ee1c
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0698

.ows_ee1c
	print_text_quit_fully Text0699

.ows_ee1f
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_LEFT
	print_text_quit_fully Text069a

Preload_Lad2:
	get_event_value EVENT_LAD2_STATE
	cp LAD2_SLOWPOKE_AVAILABLE
	ret

Script_Lad2:
	start_script
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 3, .ows_ee36
	print_text_quit_fully Text069b

.ows_ee36
	print_npc_text Text069c
	ask_question_jump Text069d, .ows_ee4a
	print_npc_text Text069e
	set_event EVENT_LAD2_STATE, LAD2_SLOWPOKE_GONE
	close_text_box
	move_active_npc_by_direction NPCMovementTable_ee61
	unload_active_npc
	quit_script_fully

.ows_ee4a
	jump_if_any_energy_cards_in_collection .ows_ee51
	print_npc_text Text069f
	quit_script_fully

.ows_ee51
	remove_all_energy_cards_from_collection
	print_text Text06a0
	print_npc_text Text06a1
	set_event EVENT_LAD2_STATE, LAD2_SLOWPOKE_AVAILABLE
	close_text_box
	move_active_npc_by_direction NPCMovementTable_ee61
	unload_active_npc
	quit_script_fully

NPCMovementTable_ee61:
	dw NPCMovement_ee69
	dw NPCMovement_ee72
	dw NPCMovement_ee69
	dw NPCMovement_ee69

NPCMovement_ee69:
	db EAST
	db SOUTH
	db SOUTH
	db SOUTH
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

NPCMovement_ee72:
	db SOUTH
	db EAST
	db $fe, -10

Script_ee76:
	start_script
	jump_if_event_equal EVENT_LAD2_STATE, LAD2_SLOWPOKE_AVAILABLE, .ows_ee7d
	quit_script_fully

.ows_ee7d
	set_event EVENT_LAD2_STATE, LAD2_SLOWPOKE_GONE
	print_text FoundLv9SlowpokeText
	give_card SLOWPOKE_LV9
	show_card_received_screen SLOWPOKE_LV9
	quit_script_fully

Script_Mania:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text06a3, Text06a4
	quit_script_fully
