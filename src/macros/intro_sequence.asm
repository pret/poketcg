intro_seq_wait_orbs_animation: MACRO
	dw IntroSequenceCmd_WaitOrbsAnimation
ENDM

; argument = frames to delay
intro_seq_wait: MACRO
	dw IntroSequenceCmd_Wait
	db \1
ENDM

; argument = list of animations to set
intro_seq_set_orbs_animations: MACRO
	dw IntroSequenceCmd_SetOrbsAnimations
	dw \1
ENDM

; argument = list of coordinates to set
intro_seq_set_orbs_coordinates: MACRO
	dw IntroSequenceCmd_SetOrbsCoordinates
	dw \1
ENDM

intro_seq_play_title_screen_music: MACRO
	dw IntroSequenceCmd_PlayTitleScreenMusic
ENDM

intro_seq_wait_sfx: MACRO
	dw IntroSequenceCmd_WaitSFX
ENDM

; argument = SFX to play
intro_seq_play_sfx: MACRO
	dw IntroSequenceCmd_PlaySFX
	db \1
ENDM

intro_seq_fade_in: MACRO
	dw IntroSequenceCmd_FadeIn
ENDM

intro_seq_fade_out: MACRO
	dw IntroSequenceCmd_FadeOut
ENDM

intro_seq_load_charizard_scene: MACRO
	dw IntroSequenceCmd_LoadCharizardScene
ENDM

intro_seq_load_scyther_scene: MACRO
	dw IntroSequenceCmd_LoadScytherScene
ENDM

intro_seq_load_aerodactyl_scene: MACRO
	dw IntroSequenceCmd_LoadAerodactylScene
ENDM

intro_seq_load_title_screen_scene: MACRO
	dw IntroSequenceCmd_LoadTitleScreenScene
ENDM

intro_seq_end: MACRO
	intro_seq_wait $ff
ENDM
