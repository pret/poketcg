LOADED_NPC_MAX EQU $08

; wLoadedNPCs structure
	const_def
	const LOADED_NPC_ID
	const LOADED_NPC_SPRITE
	const LOADED_NPC_COORD_X
	const LOADED_NPC_COORD_Y
	const LOADED_NPC_DIRECTION
	const LOADED_NPC_FIELD_05
	const LOADED_NPC_FIELD_06
	const LOADED_NPC_FIELD_07
	const LOADED_NPC_FIELD_08
	const LOADED_NPC_FIELD_09
	const LOADED_NPC_FIELD_0A
	const LOADED_NPC_FIELD_0B
LOADED_NPC_LENGTH EQU const_value

; npc_struct constants
	const_def
	const NPC_DATA_ID
	const NPC_DATA_SPRITE_ID
	const NPC_DATA_FIELD_02 ; 02-04 Seem to relate to sprites
	const NPC_DATA_FIELD_03
	const NPC_DATA_FIELD_04
	const NPC_DATA_SCRIPT_PTR
const_value = const_value+1
	const NPC_DATA_NAME_TEXT
const_value = const_value+1
	const NPC_DATA_DUELIST_PICTURE
	const NPC_DATA_DECK_ID
	const NPC_DATA_DUEL_THEME_ID
	const NPC_DATA_MATCH_START_ID
NPC_DATA_LENGTH EQU const_value

	const_def 1
	const PLAYER_PIC    ; $01
	const RONALD_PIC    ; $02
	const SAM_PIC       ; $03
	const IMAKUNI_PIC   ; $04
	const NIKKI_PIC     ; $05
	const RICK_PIC      ; $06
	const KEN_PIC       ; $07
	const AMY_PIC       ; $08
	const ISAAC_PIC     ; $09
	const MITCH_PIC     ; $0A
	const GENE_PIC      ; $0B
	const MURRAY_PIC    ; $0C
	const COURTNEY_PIC  ; $0D
	const STEVE_PIC     ; $0E
	const JACK_PIC      ; $0F
	const ROD_PIC       ; $10
	const JOSEPH_PIC    ; $11
	const DAVID_PIC     ; $12
	const ERIK_PIC      ; $13
	const JOHN_PIC      ; $14
	const ADAM_PIC      ; $15
	const JONATHAN_PIC  ; $16
	const JOSHUA_PIC    ; $17
	const NICHOLAS_PIC  ; $18
	const BRANDON_PIC   ; $19
	const MATTHEW_PIC   ; $1A
	const RYAN_PIC      ; $1B
	const ANDREW_PIC    ; $1C
	const CHRIS_PIC     ; $1D
	const MICHAEL_PIC   ; $1E
	const DANIEL_PIC    ; $1F
	const ROBERT_PIC    ; $20
	const BRITTANY_PIC  ; $21
	const KRISTIN_PIC   ; $22
	const HEATHER_PIC   ; $23
	const SARA_PIC      ; $24
	const AMANDA_PIC    ; $25
	const JENNIFER_PIC  ; $26
	const JESSICA_PIC   ; $27
	const STEPHANIE_PIC ; $28
	const AARON_PIC     ; $29

	const_def 1
	const NPC_DRMASON                     ; $01
	const NPC_RONALD1                     ; $02
	const NPC_ISHIHARA                    ; $03
	const NPC_IMAKUNI                     ; $04
	const NPC_05                          ; $05 (unused)
	const NPC_06                          ; $06 (unused)
	const NPC_SAM                         ; $07
	const NPC_TECH1                       ; $08
	const NPC_TECH2                       ; $09
	const NPC_TECH3                       ; $0a
	const NPC_TECH4                       ; $0b
	const NPC_TECH5                       ; $0c
	const NPC_TECH6                       ; $0d
	const NPC_CLERK1                      ; $0e
	const NPC_CLERK2                      ; $0f
	const NPC_CLERK3                      ; $10
	const NPC_CLERK4                      ; $11
	const NPC_CLERK5                      ; $12
	const NPC_CLERK6                      ; $13
	const NPC_CLERK7                      ; $14
	const NPC_CLERK8                      ; $15
	const NPC_CLERK9                      ; $16
	const NPC_CHRIS                       ; $17
	const NPC_MICHAEL                     ; $18
	const NPC_JESSICA                     ; $19
	const NPC_MITCH                       ; $1a
	const NPC_MATTHEW                     ; $1b
	const NPC_RYAN                        ; $1c
	const NPC_ANDREW                      ; $1d
	const NPC_GENE                        ; $1e
	const NPC_SARA                        ; $1f
	const NPC_AMANDA                      ; $20
	const NPC_JOSHUA                      ; $21
	const NPC_AMY                         ; $22
	const NPC_JENNIFER                    ; $23
	const NPC_NICHOLAS                    ; $24
	const NPC_BRANDON                     ; $25
	const NPC_ISAAC                       ; $26
	const NPC_BRITTANY                    ; $27
	const NPC_KRISTIN                     ; $28
	const NPC_HEATHER                     ; $29
	const NPC_NIKKI                       ; $2a
	const NPC_ROBERT                      ; $2b
	const NPC_DANIEL                      ; $2c
	const NPC_STEPHANIE                   ; $2d
	const NPC_MURRAY1                     ; $2e
	const NPC_JOSEPH                      ; $2f
	const NPC_DAVID                       ; $30
	const NPC_ERIK                        ; $31
	const NPC_RICK                        ; $32
	const NPC_JOHN                        ; $33
	const NPC_ADAM                        ; $34
	const NPC_JONATHAN                    ; $35
	const NPC_KEN                         ; $36
	const NPC_COURTNEY                    ; $37
	const NPC_STEVE                       ; $38
	const NPC_JACK                        ; $39
	const NPC_ROD                         ; $3a
	const NPC_CLERK10                     ; $3b
	const NPC_GIFT_CENTER_CLERK           ; $3c
	const NPC_MAN1                        ; $3d
	const NPC_WOMAN1                      ; $3e
	const NPC_CHAP1                       ; $3f
	const NPC_GAL1                        ; $40
	const NPC_LASS1                       ; $41
	const NPC_CHAP2                       ; $42
	const NPC_LASS2                       ; $43
	const NPC_PAPPY1                      ; $44
	const NPC_LAD1                        ; $45
	const NPC_LAD2                        ; $46
	const NPC_CHAP3                       ; $47
	const NPC_CLERK12                     ; $48
	const NPC_CLERK13                     ; $49
	const NPC_HOST                        ; $4a
	const NPC_SPECS1                      ; $4b
	const NPC_BUTCH                       ; $4c
	const NPC_GRANNY1                     ; $4d
	const NPC_LASS3                       ; $4e
	const NPC_MAN2                        ; $4f
	const NPC_PAPPY2                      ; $50
	const NPC_LASS4                       ; $51
	const NPC_HOOD1                       ; $52
	const NPC_GRANNY2                     ; $53
	const NPC_GAL2                        ; $54
	const NPC_LAD3                        ; $55
	const NPC_GAL3                        ; $56
	const NPC_CHAP4                       ; $57
	const NPC_MAN3                        ; $58
	const NPC_SPECS2                      ; $59
	const NPC_SPECS3                      ; $5a
	const NPC_WOMAN2                      ; $5b
	const NPC_MANIA                       ; $5c
	const NPC_PAPPY3                      ; $5d
	const NPC_GAL4                        ; $5e
	const NPC_CHAMP                       ; $5f
	const NPC_HOOD2                       ; $60
	const NPC_LASS5                       ; $61
	const NPC_CHAP5                       ; $62
	const NPC_AARON                       ; $63
	const NPC_GUIDE                       ; $64
	const NPC_TECH7                       ; $65
	const NPC_TECH8                       ; $66
	const NPC_TORCH                       ; $67
	const NPC_LEGENDARY_CARD_TOP_LEFT     ; $68
	const NPC_LEGENDARY_CARD_TOP_RIGHT    ; $69
	const NPC_LEGENDARY_CARD_LEFT_SPARK   ; $6a
	const NPC_LEGENDARY_CARD_BOTTOM_LEFT  ; $6b
	const NPC_LEGENDARY_CARD_BOTTOM_RIGHT ; $6c
	const NPC_LEGENDARY_CARD_RIGHT_SPARK  ; $6d
	const NPC_6E                          ; $6e (unused)
	const NPC_6F                          ; $6f (unused)
	const NPC_MURRAY2                     ; $70
	const NPC_RONALD2                     ; $71
	const NPC_RONALD3                     ; $72
	const NPC_73                          ; $73 (unused)
