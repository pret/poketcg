MACRO intro_seq_wait_orbs_animation
	dw IntroSequenceCmd_WaitOrbsAnimation
ENDM

; argument = frames to delay
MACRO intro_seq_wait
	dw IntroSequenceCmd_Wait
	db \1
ENDM

; argument = list of animations to set
MACRO intro_seq_set_orbs_animations
	dw IntroSequenceCmd_SetOrbsAnimations
	dw \1
ENDM

; argument = list of coordinates to set
MACRO intro_seq_set_orbs_coordinates
	dw IntroSequenceCmd_SetOrbsCoordinates
	dw \1
ENDM

MACRO intro_seq_play_title_screen_music
	dw IntroSequenceCmd_PlayTitleScreenMusic
ENDM

MACRO intro_seq_wait_sfx
	dw IntroSequenceCmd_WaitSFX
ENDM

; argument = SFX to play
MACRO intro_seq_play_sfx
	dw IntroSequenceCmd_PlaySFX
	db \1
ENDM

MACRO intro_seq_fade_in
	dw IntroSequenceCmd_FadeIn
ENDM

MACRO intro_seq_fade_out
	dw IntroSequenceCmd_FadeOut
ENDM

MACRO intro_seq_load_charizard_scene
	dw IntroSequenceCmd_LoadCharizardScene
ENDM

MACRO intro_seq_load_scyther_scene
	dw IntroSequenceCmd_LoadScytherScene
ENDM

MACRO intro_seq_load_aerodactyl_scene
	dw IntroSequenceCmd_LoadAerodactylScene
ENDM

MACRO intro_seq_load_title_screen_scene
	dw IntroSequenceCmd_LoadTitleScreenScene
ENDM

MACRO intro_seq_end
	intro_seq_wait $ff
ENDM
