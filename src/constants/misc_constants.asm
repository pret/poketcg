; console types (wConsole)
DEF CONSOLE_DMG EQU $00
DEF CONSOLE_SGB EQU $01
DEF CONSOLE_CGB EQU $02

; wReentrancyFlag bits
DEF IN_VBLANK EQU 0
DEF IN_TIMER  EQU 1

; wFlushPaletteFlags constants
DEF FLUSH_ONE_PAL    EQU %10000000
DEF FLUSH_ALL_PALS   EQU %11000000
DEF FLUSH_ALL_PALS_F EQU 6

; Game event constants (wGameEvent)
	const_def
	const GAME_EVENT_OVERWORLD         ; $0
	const GAME_EVENT_DUEL              ; $1
	const GAME_EVENT_BATTLE_CENTER     ; $2
	const GAME_EVENT_GIFT_CENTER       ; $3
	const GAME_EVENT_CREDITS           ; $4
	const GAME_EVENT_CONTINUE_DUEL     ; $5
	const GAME_EVENT_CHALLENGE_MACHINE ; $6
DEF NUM_GAME_EVENTS EQU const_value

DEF OWMODE_MAP            EQU 0
DEF OWMODE_MOVE           EQU 1
DEF OWMODE_START_SCRIPT   EQU 2
DEF OWMODE_SCRIPT         EQU 3

; overworld NPC flag constants (see wOverworldNPCFlags)
DEF AUTO_CLOSE_TEXTBOX       EQU 0
DEF RESTORE_FACING_DIRECTION EQU 1
DEF HIDE_ALL_NPC_SPRITES     EQU 7

; max number of player names that
; can be written to sCardPopNameList
DEF CARDPOP_NAME_LIST_MAX_ELEMS EQU 16
DEF CARDPOP_NAME_LIST_SIZE EQUS "CARDPOP_NAME_LIST_MAX_ELEMS * NAME_BUFFER_LENGTH"

DEF NUM_CHALLENGE_MACHINE_OPPONENTS EQU 5

; rJOYP constants to read SNES input
DEF JOYP_SGB_MLT_REQ EQU %00000011

; rJOYP constants to read IR signals
DEF P14 EQU %00010000
DEF P11 EQU %00000010
DEF P10 EQU %00000001

; commands transmitted through IR to be
; executed by the other device
; (see ExecuteReceivedIRCommands)
	const_def
	const IRCMD_CLOSE             ; $0
	const IRCMD_RETURN_WO_CLOSING ; $1
	const IRCMD_TRANSMIT_DATA     ; $2
	const IRCMD_RECEIVE_DATA      ; $3
	const IRCMD_CALL_FUNCTION     ; $4
DEF NUM_IR_COMMANDS EQU const_value

; parameters for IR communication
; (see InitIRCommunications)
	const_def 1
	const IRPARAM_CARD_POP    ; $1
	const IRPARAM_SEND_CARDS  ; $2
	const IRPARAM_SEND_DECK   ; $3

DEF NULL EQU $0000

DEF FALSE EQU 0
DEF TRUE  EQU 1
