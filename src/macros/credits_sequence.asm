credits_seq_disable_lcd: MACRO
	dw CreditsSequenceCmd_DisableLCD
ENDM

; x coordinate
; y coordinate
; OVERWORLD_* constant
credits_seq_load_ow_map: MACRO
	dw CreditsSequenceCmd_LoadOWMap
	db \1, \2, \3
ENDM

credits_seq_init_volcano_sprite: MACRO
	dw CreditsSequenceCmd_InitVolcanoSprite
ENDM

credits_seq_init_overlay: MACRO
	dw CreditsSequenceCmd_InitOverlay
	db \1, \2, \3, \4
ENDM

credits_seq_transform_overlay: MACRO
	dw CreditsSequenceCmd_TransformOverlay
	db \1, \2, \3, \4
ENDM

; x coordinate
; y coordinate
; text ID
credits_seq_print_text_box: MACRO
	dw CreditsSequenceCmd_PrintTextBox
	db \1, \2
	tx \3
ENDM

; x coordinate
; y coordinate
; text ID
credits_seq_print_text: MACRO
	dw CreditsSequenceCmd_PrintText
	db \1, \2
	tx \3
ENDM

credits_seq_fade_in: MACRO
	dw CreditsSequenceCmd_FadeIn
ENDM

credits_seq_fade_out: MACRO
	dw CreditsSequenceCmd_FadeOut
ENDM

; frames to wait
credits_seq_wait: MACRO
	dw CreditsSequenceCmd_Wait
	db \1
ENDM

; x coordinate
; y coordinate
; direction
; NPC ID
credits_seq_load_npc: MACRO
	dw CreditsSequenceCmd_LoadNPC
	db \1, \2, \3, \4
ENDM

; y offset
; heigh
credits_seq_draw_rectangle: MACRO
	dw CreditsSequenceCmd_DrawRectangle
	db \1, \2
ENDM

; x coordinate
; y coordinate
; scene ID
credits_seq_load_scene: MACRO
	dw CreditsSequenceCmd_LoadScene
	db \1, \2, \3
ENDM

; x coordinate
; y coordinate
; booster scene ID
credits_seq_load_booster: MACRO
	dw CreditsSequenceCmd_LoadBooster
	db \1, \2, \3
ENDM

; index of beaten Club Master
credits_seq_load_club_map: MACRO
	dw CreditsSequenceCmd_LoadClubMap
	db \1
ENDM

credits_seq_end: MACRO
	credits_seq_wait $ff
ENDM
