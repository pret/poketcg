	const_def
	const EVENT_FLAG_00                         ; $00
	const EVENT_FLAG_01                         ; $01
	const EVENT_TEMP_TALKED_TO_IMAKUNI          ; $02
	const EVENT_TEMP_BATTLED_IMAKUNI            ; $03
	const EVENT_FLAG_04                         ; $04
	const EVENT_FLAG_05                         ; $05
	const EVENT_FLAG_06                         ; $06
	const EVENT_FLAG_07                         ; $07
	const EVENT_FLAG_08                         ; $08
	const EVENT_FLAG_09                         ; $09
	const EVENT_FLAG_0A                         ; $0a
	const EVENT_BEAT_AMY                        ; $0b
	const EVENT_FLAG_0C                         ; $0c
	const EVENT_FLAG_0D                         ; $0d
	const EVENT_FLAG_0E                         ; $0e
	const EVENT_FLAG_0F                         ; $0f
	const EVENT_FLAG_10                         ; $10
	const EVENT_FLAG_11                         ; $11
	const EVENT_FLAG_12                         ; $12
	const EVENT_IMAKUNI_STATE                   ; $13
	const EVENT_FLAG_14                         ; $14
	const EVENT_BEAT_SARA                       ; $15
	const EVENT_BEAT_AMANDA                     ; $16
	const EVENT_FLAG_17                         ; $17
	const EVENT_FLAG_18                         ; $18
	const EVENT_FLAG_19                         ; $19
	const EVENT_FLAG_1A                         ; $1a
	const EVENT_FLAG_1B                         ; $1b
	const EVENT_FLAG_1C                         ; $1c
	const EVENT_FLAG_1D                         ; $1d
	const EVENT_FLAG_1E                         ; $1e
	const EVENT_FLAG_1F                         ; $1f
	const EVENT_FLAG_20                         ; $20
	const EVENT_FLAG_21                         ; $21
	const EVENT_RECEIVED_LEGENDARY_CARD         ; $22
	const EVENT_FLAG_23                         ; $23
	const EVENT_FLAG_24                         ; $24
	const EVENT_FLAG_25                         ; $25
	const EVENT_FLAG_26                         ; $26
	const EVENT_FLAG_27                         ; $27
	const EVENT_FLAG_28                         ; $28
	const EVENT_FLAG_29                         ; $29
	const EVENT_FLAG_2A                         ; $2a
	const EVENT_FLAG_2B                         ; $2b
	const EVENT_FLAG_2C                         ; $2c
	const EVENT_FLAG_2D                         ; $2d
	const EVENT_MEDAL_COUNT                     ; $2e
	const EVENT_FLAG_2F                         ; $2f
	const EVENT_FLAG_30                         ; $30
	const EVENT_FLAG_31                         ; $31
	const EVENT_FLAG_32                         ; $32
	const EVENT_JOSHUA_STATE                    ; $33
	const EVENT_IMAKUNI_ROOM                    ; $34
	const EVENT_FLAG_35                         ; $35
	const EVENT_IMAKUNI_WIN_COUNT               ; $36
	const EVENT_FLAG_37                         ; $37
	const EVENT_FLAG_38                         ; $38
	const EVENT_FLAG_39                         ; $39
	const EVENT_FLAG_3A                         ; $3a
	const EVENT_FLAG_3B                         ; $3b
	const FLAG_BEAT_BRITTANY                    ; $3c
	const EVENT_FLAG_3D                         ; $3d
	const EVENT_FLAG_3E                         ; $3e
	const EVENT_FLAG_3F                         ; $3f
	const EVENT_FLAG_40                         ; $40
	const EVENT_FLAG_41                         ; $41
	const EVENT_FLAG_42                         ; $42
	const EVENT_FLAG_43                         ; $43
	const EVENT_FLAG_44                         ; $44
	const EVENT_FLAG_45                         ; $45
	const EVENT_FLAG_46                         ; $46
	const EVENT_FLAG_47                         ; $47
	const EVENT_FLAG_48                         ; $48
	const EVENT_FLAG_49                         ; $49
	const EVENT_FLAG_4A                         ; $4a
	const EVENT_FLAG_4B                         ; $4b
	const EVENT_FLAG_4C                         ; $4c
	const EVENT_FLAG_4D                         ; $4d
	const EVENT_FLAG_4E                         ; $4e
	const EVENT_FLAG_4F                         ; $4f
	const EVENT_FLAG_50                         ; $50
	const EVENT_FLAG_51                         ; $51
	const EVENT_FLAG_52                         ; $52
	const EVENT_FLAG_53                         ; $53
	const EVENT_FLAG_54                         ; $54
	const EVENT_FLAG_55                         ; $55
	const EVENT_FLAG_56                         ; $56
	const EVENT_FLAG_57                         ; $57
	const EVENT_FLAG_58                         ; $58
	const EVENT_FLAG_59                         ; $59
	const EVENT_FLAG_5A                         ; $5a
	const EVENT_FLAG_5B                         ; $5b
	const EVENT_FLAG_5C                         ; $5c
	const EVENT_FLAG_5D                         ; $5d
	const EVENT_FLAG_5E                         ; $5e
	const EVENT_FLAG_5F                         ; $5f
	const EVENT_FLAG_60                         ; $60
	const EVENT_FLAG_61                         ; $61
	const EVENT_FLAG_62                         ; $62
	const EVENT_FLAG_63                         ; $63
	const EVENT_FLAG_64                         ; $64
	const EVENT_FLAG_65                         ; $65
	const EVENT_FLAG_66                         ; $66
	const EVENT_FLAG_67                         ; $67
	const EVENT_FLAG_68                         ; $68
	const EVENT_FLAG_69                         ; $69
	const EVENT_FLAG_6A                         ; $6a
	const EVENT_FLAG_6B                         ; $6b
	const EVENT_FLAG_6C                         ; $6c
	const EVENT_FLAG_6D                         ; $6d
	const EVENT_FLAG_6E                         ; $6e
	const EVENT_FLAG_6F                         ; $6f
	const EVENT_FLAG_70                         ; $70
	const EVENT_FLAG_71                         ; $71
	const EVENT_FLAG_72                         ; $72
	const EVENT_FLAG_73                         ; $73
	const EVENT_FLAG_74                         ; $74
	const EVENT_FLAG_75                         ; $75
	const EVENT_FLAG_76                         ; $76
EVENT_FLAG_AMOUNT EQU const_value

EVENT_FLAG_BYTES EQU $40

; EVENT_IMAKUNI_STATE
; Starts at 0, Talking to lass moves it to MENTIONED (1), then
; talking to Imakuni at least once sets it to TALKED (2)
IMAKUNI_MENTIONED   EQU 1
IMAKUNI_TALKED      EQU 2

; EVENT_JOSHUA_STATE
JOSHUA_TALKED     EQU 1
JOSHUA_BEATEN     EQU 2

; EVENT_IMAKUNI_ROOM
IMAKUNI_FIGHTING_CLUB     EQU 0
IMAKUNI_SCIENCE_CLUB      EQU 1
IMAKUNI_LIGHTNING_CLUB    EQU 2
IMAKUNI_WATER_CLUB        EQU 3

NO_JUMP EQU $0000

NORTH    EQU $00
EAST     EQU $01
SOUTH    EQU $02
WEST     EQU $03
NO_MOVE  EQU %10000000 ; For rotations without movement
