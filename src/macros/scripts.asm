start_script EQUS "rst $20"

run_script: MACRO
	db \1_index
ENDM

; TODO: create macros for overworld scripts after their usage and arguments are figured out.
; For example (current OWScript_GiveBoosterPacks_index):

;	const SCRIPT_GIVE_BOOSTER_PACKS ; $0c
;give_booster_packs: MACRO
;	db SCRIPT_GIVE_BOOSTER_PACKS
;	db \1, \2, \3
;ENDM

	const_def
	const OWScript_EndScriptLoop1_index         ; $00
	const OWScript_CloseAdvancedTextBox_index   ; $01
	const OWScript_PrintTextString_index        ; $02
	const Func_ccdc_index                       ; $03
	const OWScript_AskQuestionJump_index        ; $04
	const OWScript_StartBattle_index            ; $05
	const OWScript_PrintVariableText_index      ; $06
	const Func_cda8_index                       ; $07
	const OWScript_PrintTextCloseBox_index      ; $08
	const Func_cdcb_index                       ; $09
	const Func_ce26_index                       ; $0a
	const OWScript_CloseTextBox_index           ; $0b
	const OWScript_GiveBoosterPacks_index       ; $0c
	const Func_cf0c_index                       ; $0d
	const Func_cf12_index                       ; $0e
	const OWScript_GiveCard_index                       ; $0f
	const OWScript_TakeCard_index                       ; $10
	const Func_cf53_index                       ; $11
	const Func_cf7b_index                       ; $12
	const Func_cf2d_index                       ; $13
	const Func_cf96_index                       ; $14
	const Func_cfc6_index                       ; $15
	const Func_cfd4_index                       ; $16
	const Func_d00b_index                       ; $17
	const Func_d025_index                       ; $18
	const Func_d032_index                       ; $19
	const Func_d03f_index                       ; $1a
	const OWScript_Jump_index                   ; $1b
	const Func_d04f_index                       ; $1c
	const Func_d055_index                       ; $1d
	const OWScript_MovePlayer_index             ; $1e
	const Func_cee2_index                       ; $1f
	const OWScript_SetDialogName_index          ; $20
	const Func_d088_index                       ; $21
	const Func_d095_index                       ; $22
	const Func_d0be_index                       ; $23
	const OWScript_DoFrames_index               ; $24
	const Func_d0d9_index                       ; $25
	const Func_d0f2_index                       ; $26
	const Func_ce4a_index                       ; $27
	const Func_ceba_index                       ; $28
	const Func_d103_index                       ; $29
	const Func_d125_index                       ; $2a
	const Func_d135_index                       ; $2b
	const Func_d16b_index                       ; $2c
	const Func_cd4f_index                       ; $2d
	const Func_cd94_index                       ; $2e
	const Func_ce52_index                       ; $2f
	const Func_cdd8_index                       ; $30
	const Func_cdf5_index                       ; $31
	const Func_d195_index                       ; $32
	const Func_d1ad_index                       ; $33
	const Func_d1b3_index                       ; $34
	const OWScript_EndScriptCloseText_index     ; $35
	const Func_d244_index                       ; $36
	const Func_d24c_index                       ; $37
	const OWScript_OpenDeckMachine_index        ; $38
	const Func_d271_index                       ; $39
	const Func_d36d_index                       ; $3a
	const Func_ce6f_index                       ; $3b
	const Func_d209_index                       ; $3c
	const Func_d38f_index                       ; $3d
	const Func_d396_index                       ; $3e
	const Func_cd76_index                       ; $3f
	const Func_d39d_index                       ; $40
	const Func_d3b9_index                       ; $41
	const OWScript_GivePCPack_index             ; $42
	const Func_d3d1_index                       ; $43
	const Func_d3d4_index                       ; $44
	const Func_d3e0_index                       ; $45
	const Func_d3fe_index                       ; $46
	const Func_d408_index                       ; $47
	const Func_d40f_index                       ; $48
	const Func_d416_index                       ; $49
	const Func_d423_index                       ; $4a
	const Func_d429_index                       ; $4b
	const Func_d41d_index                       ; $4c
	const Func_d42f_index                       ; $4d
	const Func_d435_index                       ; $4e
	const Func_cce4_index                       ; $4f
	const Func_d2f6_index                       ; $50
	const Func_d317_index                       ; $51
	const Func_d43d_index                       ; $52
	const OWScript_EndScriptLoop2_index         ; $53
	const OWScript_EndScriptLoop3_index         ; $54
	const OWScript_EndScriptLoop4_index         ; $55
	const OWScript_EndScriptLoop5_index         ; $56
	const OWScript_EndScriptLoop6_index         ; $57
	const OWScript_SetFlagValue_index           ; $58
	const OWScript_JumpIfFlagZero1_index        ; $59
	const OWScript_JumpIfFlagNonzero1_index     ; $5a
	const OWScript_JumpIfFlagEqual_index        ; $5b
	const OWScript_JumpIfFlagNotEqual_index     ; $5c
	const OWScript_JumpIfFlagNotLessThan_index  ; $5d
	const OWScript_JumpIfFlagLessThan_index     ; $5e
	const OWScript_MaxOutFlagValue_index        ; $5f
	const OWScript_ZeroOutFlagValue_index       ; $60
	const OWScript_JumpIfFlagNonzero2_index     ; $61
	const OWScript_JumpIfFlagZero2_index        ; $62
	const OWScript_IncrementFlagValue_index     ; $63
	const OWScript_EndScriptLoop7_index         ; $64
	const OWScript_EndScriptLoop8_index         ; $65
	const OWScript_EndScriptLoop9_index         ; $66
	const OWScript_EndScriptLoop10_index        ; $67

