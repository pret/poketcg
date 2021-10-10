Func_fc2b:
	ld a, [wDuelResult]
	cp DUEL_LOSS + 1
	jr c, .win_or_loss
	ld a, 2 ; transmission error
.win_or_loss
	rlca
	ld c, a
	ld b, 0
	ld hl, PointerTable_fc4c
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, LOW(ClerkNPCName_)
	ld [wCurrentNPCNameTx], a
	ld a, HIGH(ClerkNPCName_)
	ld [wCurrentNPCNameTx + 1], a
	jp SetNextScript

PointerTable_fc4c:
	dw Script_fc64
	dw Script_fc68
	dw Script_fc60

Script_fc52:
	start_script
	print_npc_text Text06c8
	ask_question_jump_default_yes NULL, .ows_fc5e
	print_text_quit_fully Text06c9

.ows_fc5e
	battle_center
	quit_script_fully

Script_fc60:
	start_script
	print_text_quit_fully Text06ca

Script_fc64:
	start_script
	print_text_quit_fully Text06cb

Script_fc68:
	start_script
	print_text_quit_fully Text06cc
