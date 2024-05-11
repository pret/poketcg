; Clerk looks away from you if you can't use infrared
; This is one of the preloads that does not change whether or not they appear
Preload_GiftCenterClerk:
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr z, .cgb
	ld a, NORTH
	ld [wLoadNPCDirection], a
.cgb
	scf
	ret

Func_fc7a:
	ld a, [wConsole]
	ld c, a
	set_event_value EVENT_CONSOLE

	start_script
	jump_if_event_not_equal EVENT_CONSOLE, CONSOLE_CGB, Func_fcad.ows_fcd5
	print_npc_text Text06cd
	gift_center 0
	jump_if_event_greater_or_equal EVENT_GIFT_CENTER_MENU_CHOICE, GIFT_CENTER_MENU_EXIT, .ows_fcaa
	print_npc_text Text06ce
	ask_question_jump_default_yes Text06cf, .ows_fca0
	print_npc_text Text06d0
	script_jump .ows_fcaa

.ows_fca0
	save_game 0
	play_sfx SFX_SAVE_GAME
	print_text Text06d1
	gift_center 1
	quit_script_fully

.ows_fcaa
	print_text_quit_fully Text06d2

Func_fcad:
	ld a, [wGiftCenterChoice]
	ld c, a
	set_event_value EVENT_GIFT_CENTER_MENU_CHOICE

	start_script
	play_sfx SFX_SAVE_GAME
	save_game 0
	jump_if_event_equal EVENT_GIFT_CENTER_MENU_CHOICE, GIFT_CENTER_MENU_SEND_CARD, .ows_fccc
	jump_if_event_equal EVENT_GIFT_CENTER_MENU_CHOICE, GIFT_CENTER_MENU_SEND_DECK, .ows_fccf
	jump_if_event_equal EVENT_GIFT_CENTER_MENU_CHOICE, GIFT_CENTER_MENU_RECEIVE_DECK, .ows_fcd2
; GIFT_CENTER_MENU_RECEIVE_CARD
	script_jump Func_fc7a.ows_fcaa

.ows_fccc
	print_text_quit_fully Text06d3

.ows_fccf
	print_text_quit_fully Text06d4

.ows_fcd2
	print_text_quit_fully Text06d5

.ows_fcd5
	move_npc NPC_GIFT_CENTER_CLERK, NPCMovement_fce1
	print_npc_text Text06d6
	move_npc NPC_GIFT_CENTER_CLERK, NPCMovement_fce3
	quit_script_fully

NPCMovement_fce1:
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_fce3:
	db NORTH | NO_MOVE
	db $ff
