opening_seq_wait_orbs_animation: MACRO
	dw OpeningSequenceCmd_WaitOrbsAnimation
ENDM

; argument = frames to delay
opening_seq_wait: MACRO
	dw OpeningSequenceCmd_Wait
	db \1
ENDM

; argument = list of animations to set
opening_seq_set_orbs_animations: MACRO
	dw OpeningSequenceCmd_SetOrbsAnimations
	dw \1
ENDM

; argument = list of coordinates to set
opening_seq_set_orbs_coordinates: MACRO
	dw OpeningSequenceCmd_SetOrbsCoordinates
	dw \1
ENDM

opening_seq_play_title_screen_music: MACRO
	dw OpeningSequenceCmd_PlayTitleScreenMusic
ENDM

opening_seq_wait_sfx: MACRO
	dw OpeningSequenceCmd_WaitSFX
ENDM

; argument = SFX to play
opening_seq_play_sfx: MACRO
	dw OpeningSequenceCmd_PlaySFX
	db \1
ENDM

opening_seq_fade_in: MACRO
	dw OpeningSequenceCmd_FadeIn
ENDM

opening_seq_fade_out: MACRO
	dw OpeningSequenceCmd_FadeOut
ENDM

opening_seq_load_charizard_scene: MACRO
	dw OpeningSequenceCmd_LoadCharizardScene
ENDM

opening_seq_load_scyther_scene: MACRO
	dw OpeningSequenceCmd_LoadScytherScene
ENDM

opening_seq_load_aerodactyl_scene: MACRO
	dw OpeningSequenceCmd_LoadAerodactylScene
ENDM

opening_seq_load_title_screen_scene: MACRO
	dw OpeningSequenceCmd_LoadTitleScreenScene
ENDM

opening_seq_end: MACRO
	opening_seq_wait $ff
ENDM
