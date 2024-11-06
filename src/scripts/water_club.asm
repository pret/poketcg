WaterClubMovePlayer:
	ld a, [wPlayerYCoord]
	cp $8
	ret nz
	get_event_value EVENT_JOSHUA_STATE
	cp JOSHUA_DEFEATED
	ret nc
	ld a, NPC_JOSHUA
	ld [wTempNPC], a
	ld bc, Script_NotReadyToSeeAmy
	jp SetNextNPCAndScript

WaterClubAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_SARA
	db NPC_SARA
	dw Script_BeatSara
	dw Script_LostToSara

	db NPC_AMANDA
	db NPC_AMANDA
	dw Script_BeatAmanda
	dw Script_LostToAmanda

	db NPC_JOSHUA
	db NPC_JOSHUA
	dw Script_BeatJoshua
	dw Script_LostToJoshua

	db NPC_AMY
	db NPC_AMY
	dw Script_BeatAmy
	dw Script_LostToAmy
	db $00

Script_Sara:
	start_script
	print_npc_text SaraWantsToDuelText
	ask_question_jump SaraWouldYouLikeToDuelText, .start_duel
	print_npc_text SaraDeclinedDuelText
	quit_script_fully

.start_duel
	print_npc_text SaraStartDuelText
	start_duel PRIZES_2, WATERFRONT_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatSara:
	start_script
	max_out_event_value EVENT_BEAT_SARA
	print_npc_text SaraPlayerWon1Text
	give_booster_packs BOOSTER_COLOSSEUM_WATER, BOOSTER_COLOSSEUM_WATER, NO_BOOSTER
	print_npc_text SaraPlayerWon2Text
	quit_script_fully

Script_LostToSara:
	start_script
	print_text_quit_fully SaraPlayerLostText

Script_Amanda:
	start_script
	print_npc_text AmandaWantsToDuelText
	ask_question_jump AmandaWouldYouLikeToDuelText, .start_duel
	print_npc_text AmandaDeclinedDuelText
	quit_script_fully

.start_duel
	print_npc_text AmandaDuelStartText
	start_duel PRIZES_3, LONELY_FRIENDS_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatAmanda:
	start_script
	max_out_event_value EVENT_BEAT_AMANDA
	print_npc_text AmandaPlayerWon1Text
	give_booster_packs BOOSTER_MYSTERY_LIGHTNING_COLORLESS, BOOSTER_MYSTERY_LIGHTNING_COLORLESS, NO_BOOSTER
	print_npc_text AmandaPlayerWon2Text
	quit_script_fully

Script_LostToAmanda:
	start_script
	print_text_quit_fully AmandaPlayerLostText

Script_NotReadyToSeeAmy:
	start_script
	jump_if_player_coords_match 18, 8, .ows_e1ec
	jump_if_player_coords_match 20, 8, .ows_e1f2
	jump_if_player_coords_match 24, 8, .ows_e1f8
.ows_e1d5
	move_player SOUTH, 4
	move_active_npc NPCMovement_e213
	print_npc_text JoshuaAmyIsRestingText
	jump_if_player_coords_match 18, 10, .ows_e1fe
	jump_if_player_coords_match 20, 10, .ows_e202
	move_active_npc NPCMovement_e215
	quit_script_fully

.ows_e1ec
	move_active_npc NPCMovement_e206
	script_jump .ows_e1d5

.ows_e1f2
	move_active_npc NPCMovement_e20b
	script_jump .ows_e1d5

.ows_e1f8
	move_active_npc NPCMovement_e20f
	script_jump .ows_e1d5

.ows_e1fe
	move_active_npc NPCMovement_e218
	quit_script_fully

.ows_e202
	move_active_npc NPCMovement_e219
	quit_script_fully

NPCMovement_e206:
	db NORTH
	db WEST
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_e20b:
	db NORTH
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_e20f:
	db NORTH
	db EAST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_e213:
	db SOUTH
	db $ff

NPCMovement_e215:
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_e218:
	db EAST
NPCMovement_e219:
	db EAST
	db SOUTH | NO_MOVE
	db $ff

Script_Joshua:
	start_script
	jump_if_event_false EVENT_BEAT_AMANDA, .sara_and_amanda_not_beaten
	jump_if_event_false EVENT_BEAT_SARA, .sara_and_amanda_not_beaten
	script_jump .beat_sara_and_amanda

.sara_and_amanda_not_beaten
	set_event EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_npc_text JoshuaGoDefeatSaraAndAmandaText
	quit_script_fully

.beat_sara_and_amanda
	jump_if_event_nonzero EVENT_JOSHUA_STATE, .already_talked
	set_event EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_npc_text JoshuaGoDefeatSaraAndAmandaText
	print_npc_text JoshuaSaraAndAmandaDefeatedText
.already_talked
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text JoshuaWantsToDuelInitialText, JoshuaWantsToDuelRepeatText
	ask_question_jump JoshuaWouldYouLikeToDuelText, .start_duel
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text JoshuaDeclinedDuelInitialText, JoshuaDeclinedDuelRepeatText
	quit_script_fully

.start_duel
	print_npc_text JoshuaDuelStartText
	try_give_pc_pack $04
	start_duel PRIZES_4, SOUND_OF_THE_WAVES_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_LostToJoshua:
	start_script
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text JoshuaPlayerLostInitialText, JoshuaPlayerLostRepeatText
	quit_script_fully

Script_BeatJoshua:
	start_script
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text JoshuaPlayerWonInitial1Text, JoshuaPlayerWonRepeat1Text
	give_booster_packs BOOSTER_MYSTERY_WATER_COLORLESS, BOOSTER_MYSTERY_WATER_COLORLESS, NO_BOOSTER
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text JoshuaPlayerWonInitial2Text, JoshuaPlayerWonRepeat2Text
	jump_if_event_not_equal EVENT_JOSHUA_STATE, JOSHUA_DEFEATED, .first_joshua_win
	quit_script_fully

.first_joshua_win
	set_event EVENT_JOSHUA_STATE, JOSHUA_DEFEATED
	print_npc_text JoshuaWakesAmy1Text
	close_text_box
	move_active_npc_by_direction NPCMovementTable_e2a1
	print_npc_text JoshuaWakesAmy2Text
	set_active_npc_direction NORTH
	close_advanced_text_box
	set_next_npc_and_script NPC_AMY, Script_MeetAmy
	end_script
	ret

NPCMovementTable_e2a1:
	dw NPCMovement_e2a9
	dw NPCMovement_e2a9
	dw NPCMovement_e2a9
	dw NPCMovement_e2a9

NPCMovement_e2a9:
	db NORTH
	db $ff

NPCMovement_e2ab:
	db SOUTH
	db $ff

Preload_Amy:
	xor a
	ld [wd3d0], a
	ld a, [wActiveGameEvent]
	or a
	jr z, .asm_e2cf
	ld a, [wPlayerXCoord]
	cp $14
	jr nz, .asm_e2cf
	ld a, [wPlayerYCoord]
	cp $06
	jr nz, .asm_e2cf
	ld a, $14
	ld [wLoadNPCXPos], a
	ld a, $01
	ld [wd3d0], a
.asm_e2cf
	scf
	ret

Script_MeetAmy:
	start_script
	print_npc_text AmyMeetsPlayer1Text
	set_dialog_npc NPC_JOSHUA
	print_npc_text JoshuaWakesAmy3Text
	set_dialog_npc NPC_AMY
	print_npc_text AmyMeetsPlayer2Text
	close_text_box
	set_sprite_attributes SPRITE_ANIM_SGB_AMY_STAND, SPRITE_ANIM_CGB_AMY_STAND, NPC_FLAG_DIRECTIONLESS
	do_frames 32
	set_sprite_attributes SPRITE_ANIM_DARK_NPC_UP, SPRITE_ANIM_BLUE_NPC_UP, $00
	set_active_npc_coords 20, 4
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction NORTH
	move_player NORTH, 1
	move_player NORTH, 1
	move_npc NPC_JOSHUA, NPCMovement_e2ab
	print_npc_text AmyMeetsPlayer3Text
	script_jump Script_Amy.ask_for_duel

Script_Amy:
	start_script
	jump_if_event_true EVENT_BEAT_AMY, Script_Amy_AlreadyHaveMedal
	print_npc_text AmyWantsToDuelInitialText
.ask_for_duel
	ask_question_jump AmyWouldYouLikeToDuelText, .start_duel
.deny_duel
	print_npc_text AmyDeclinedDuelInitialText
	jump_if_active_npc_coords_match 20, 4, Script_LostToAmy.ows_e34e
	quit_script_fully

.start_duel
	print_npc_text AmyDuelStartInitialText
	start_duel PRIZES_6, GO_GO_RAIN_DANCE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatAmy:
	start_script
	print_npc_text AmyPlayerWon1Text
	jump_if_event_true EVENT_BEAT_AMY, .give_booster_packs
	print_npc_text AmyGivesMedal1Text
	max_out_event_value EVENT_BEAT_AMY
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_AMY
	record_master_win $03
	print_npc_text AmyGivesMedal2Text
.give_booster_packs
	give_booster_packs BOOSTER_LABORATORY_WATER, BOOSTER_LABORATORY_WATER, NO_BOOSTER
	print_npc_text AmyPlayerWon2Text
	jump_if_active_npc_coords_match 20, 4, Script_LostToAmy.ows_e34e
	quit_script_fully

Script_LostToAmy:
	start_script
	print_npc_text AmyPlayerLostText
	jump_if_active_npc_coords_match 20, 4, .ows_e34e
	quit_script_fully

.ows_e34e
	set_sprite_attributes SPRITE_ANIM_SGB_AMY_LAYING, SPRITE_ANIM_CGB_AMY_LAYING, NPC_FLAG_DIRECTIONLESS
	set_active_npc_coords 22, 4
	quit_script_fully

Script_Amy_AlreadyHaveMedal:
	print_npc_text AmyWantsToDuelRepeatText
	ask_question_jump AmyWouldYouLikeToDuelText, .start_duel
	script_jump Script_Amy.deny_duel

.start_duel
	print_npc_text AmyDuelStartRepeatText
	start_duel PRIZES_6, GO_GO_RAIN_DANCE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully
