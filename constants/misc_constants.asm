
; WRAM addresses $Cxxx
DATA_INITIAL_A              EQU $CAB3
DATA_CONSOLE                EQU $CAB4
CONSOLE_DMG                 EQU $00
CONSOLE_SGB                 EQU $01
CONSOLE_CGB                 EQU $02
DATA_TILE_MAP_FILL          EQU $CAB6
CURR_IE                     EQU $CAB7
DATA_VBLANK_COUNTER         EQU $CAB8
CURR_LCDC                   EQU $CABB
CURR_BGP                    EQU $CABC
CURR_OBP0                   EQU $CABD
CURR_OBP1                   EQU $CABE

BUF_PALETTE                 EQU $CAF0
BUF_SERIAL                  EQU $CB74

; HRAM addresses
CURR_ROM_BANK               EQU $FF80
CURR_RAM_BANK               EQU $FF81
CURR_DEST_VRAM_BANK         EQU $FF82

DMA_FUNCTION                EQU $FF83

DPAD_REPEAT_CTR             EQU $FF8D
BUTTONS_RELEASED            EQU $FF8E
BUTTONS_PRESSED_2           EQU $FF8F
BUTTONS_HELD                EQU $FF90
BUTTONS_PRESSED             EQU $FF91

CURR_SCX                    EQU $FF92
CURR_SCY                    EQU $FF93
CURR_WX                     EQU $FF94
CURR_WY                     EQU $FF95
