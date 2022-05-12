MACRO credits_seq_disable_lcd
	dw CreditsSequenceCmd_DisableLCD
ENDM

; x coordinate
; y coordinate
; OVERWORLD_* constant
MACRO credits_seq_load_ow_map
	dw CreditsSequenceCmd_LoadOWMap
	db \1, \2, \3
ENDM

MACRO credits_seq_init_volcano_sprite
	dw CreditsSequenceCmd_InitVolcanoSprite
ENDM

MACRO credits_seq_init_overlay
	dw CreditsSequenceCmd_InitOverlay
	db \1, \2, \3, \4
ENDM

MACRO credits_seq_transform_overlay
	dw CreditsSequenceCmd_TransformOverlay
	db \1, \2, \3, \4
ENDM

; x coordinate
; y coordinate
; text ID
MACRO credits_seq_print_text_box
	dw CreditsSequenceCmd_PrintTextBox
	db \1, \2
	tx \3
ENDM

; x coordinate
; y coordinate
; text ID
MACRO credits_seq_print_text
	dw CreditsSequenceCmd_PrintText
	db \1, \2
	tx \3
ENDM

MACRO credits_seq_fade_in
	dw CreditsSequenceCmd_FadeIn
ENDM

MACRO credits_seq_fade_out
	dw CreditsSequenceCmd_FadeOut
ENDM

; frames to wait
MACRO credits_seq_wait
	dw CreditsSequenceCmd_Wait
	db \1
ENDM

; x coordinate
; y coordinate
; direction
; NPC ID
MACRO credits_seq_load_npc
	dw CreditsSequenceCmd_LoadNPC
	db \1, \2, \3, \4
ENDM

; y offset
; heigh
MACRO credits_seq_draw_rectangle
	dw CreditsSequenceCmd_DrawRectangle
	db \1, \2
ENDM

; x coordinate
; y coordinate
; scene ID
MACRO credits_seq_load_scene
	dw CreditsSequenceCmd_LoadScene
	db \1, \2, \3
ENDM

; x coordinate
; y coordinate
; booster scene ID
MACRO credits_seq_load_booster
	dw CreditsSequenceCmd_LoadBooster
	db \1, \2, \3
ENDM

; index of beaten Club Master
MACRO credits_seq_load_club_map
	dw CreditsSequenceCmd_LoadClubMap
	db \1
ENDM

MACRO credits_seq_end
	credits_seq_wait $ff
ENDM
