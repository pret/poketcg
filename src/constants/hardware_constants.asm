; From http://bgb.bircd.org/pandocs.htm and https://github.com/tobiasvl/hardware.inc

GBC EQU $11

; MBC3
MBC3SRamEnable EQU $0000
MBC3RomBank    EQU $2000
MBC3SRamBank   EQU $4000
MBC3LatchClock EQU $6000
MBC3RTC        EQU $a000

SRAM_DISABLE EQU $00
SRAM_ENABLE  EQU $0a

NUM_SRAM_BANKS EQU 4

RTC_S  EQU $08 ; Seconds   0-59 (0-3Bh)
RTC_M  EQU $09 ; Minutes   0-59 (0-3Bh)
RTC_H  EQU $0a ; Hours     0-23 (0-17h)
RTC_DL EQU $0b ; Lower 8 bits of Day Counter (0-FFh)
RTC_DH EQU $0c ; Upper 1 bit of Day Counter, Carry Bit, Halt Flag
        ; Bit 0  Most significant bit of Day Counter (Bit 8)
        ; Bit 6  Halt (0=Active, 1=Stop Timer)
        ; Bit 7  Day Counter Carry Bit (1=Counter Overflow)

; interrupt flags
INT_VBLANK   EQU 0
INT_LCD_STAT EQU 1
INT_TIMER    EQU 2
INT_SERIAL   EQU 3
INT_JOYPAD   EQU 4

; OAM attribute flags
OAM_PALETTE   EQU %111
OAM_TILE_BANK EQU 3
OAM_OBP_NUM   EQU 4 ; Non CGB Mode Only
OAM_X_FLIP    EQU 5
OAM_Y_FLIP    EQU 6
OAM_PRIORITY  EQU 7 ; 0: OBJ above BG, 1: OBJ behind BG (colors 1-3)

; Hardware registers
rJOYP       EQU $ff00 ; Joypad (R/W)
P15              EQU %00100000
JOY_BTNS_SELECT  EQU P15
P14              EQU %00010000
JOY_DPAD_SELECT  EQU P14
JOY_INPUT_MASK   EQU %00001111
P13              EQU %00001000
P12              EQU %00000100
P11              EQU %00000010
P10              EQU %00000001
JOY_INPUT_DOWN   EQU P13
JOY_INPUT_UP     EQU P12
JOY_INPUT_LEFT   EQU P11
JOY_INPUT_RIGHT  EQU P10
JOY_INPUT_START  EQU P13
JOY_INPUT_SELECT EQU P12
JOY_INPUT_B      EQU P11
JOY_INPUT_A      EQU P10
SNES_JOYPAD1     EQU $3 ; lower two bits
SNES_JOYPAD2     EQU $2 ; lower two bits
SNES_JOYPAD3     EQU $1 ; lower two bits
SNES_JOYPAD4     EQU $0 ; lower two bits

rSB         EQU $ff01 ; Serial transfer data (R/W)
rSC         EQU $ff02 ; Serial Transfer Control (R/W)
SC_START    EQU $80
SC_INTERNAL EQU $01
SC_EXTERNAL EQU $00

rDIV        EQU $ff04 ; Divider Register (R/W)
rTIMA       EQU $ff05 ; Timer counter (R/W)
rTMA        EQU $ff06 ; Timer Modulo (R/W)
rTAC        EQU $ff07 ; Timer Control (R/W)
TAC_START     EQU $04
TAC_STOP      EQU $00
TAC_4096_HZ   EQU $00
TAC_262144_HZ EQU $01
TAC_65536_HZ  EQU $02
TAC_16384_HZ  EQU $03

rIF         EQU $ff0f ; Interrupt Flag (R/W)

rNR10       EQU $ff10 ; Channel 1 Sweep register (R/W)
rNR11       EQU $ff11 ; Channel 1 Sound length/Wave pattern duty (R/W)
rNR12       EQU $ff12 ; Channel 1 Volume Envelope (R/W)
rNR13       EQU $ff13 ; Channel 1 Frequency lo (Write Only)
rNR14       EQU $ff14 ; Channel 1 Frequency hi (R/W)

rNR21       EQU $ff16 ; Channel 2 Sound Length/Wave Pattern Duty (R/W)
rNR22       EQU $ff17 ; Channel 2 Volume Envelope (R/W)
rNR23       EQU $ff18 ; Channel 2 Frequency lo data (W)
rNR24       EQU $ff19 ; Channel 2 Frequency hi data (R/W)

rNR30       EQU $ff1a ; Channel 3 Sound on/off (R/W)
rNR31       EQU $ff1b ; Channel 3 Sound Length
rNR32       EQU $ff1c ; Channel 3 Select output level (R/W)
rNR33       EQU $ff1d ; Channel 3 Frequency's lower data (W)
rNR34       EQU $ff1e ; Channel 3 Frequency's higher data (R/W)

rNR41       EQU $ff20 ; Channel 4 Sound Length (R/W)
rNR42       EQU $ff21 ; Channel 4 Volume Envelope (R/W)
rNR43       EQU $ff22 ; Channel 4 Polynomial Counter (R/W)
rNR44       EQU $ff23 ; Channel 4 Counter/consecutive; Initial (R/W)

rNR50       EQU $ff24 ; Channel control / ON-OFF / Volume (R/W)
rNR51       EQU $ff25 ; Selection of Sound output terminal (R/W)
rNR52       EQU $ff26 ; Sound on/off

rLCDC       EQU $ff40 ; LCD Control (R/W)
LCDC_OFF        EQU %01111111 ; LCD Control Operation (and)
LCDC_ON         EQU %10000000 ; LCD Control Operation (ld/or)
LCDC_ENABLE_F   EQU 7
LCDC_WIN9800    EQU %10111111 ; Window Tile Map Display Select (and)
LCDC_WIN9C00    EQU %01000000 ; Window Tile Map Display Select (ld/or)
LCDC_WINSELECT  EQU LCDC_WIN9C00
LCDC_WINOFF     EQU %11011111 ; Window Display (and)
LCDC_WINON      EQU %00100000 ; Window Display (ld/or)
LCDC_WINENABLE  EQU LCDC_WINON
LCDC_BG8800     EQU %11101111 ; BG & Window Tile Data Select (and)
LCDC_BG8000     EQU %00010000 ; BG & Window Tile Data Select (ld/or)
LCDC_BGTILEDATA EQU LCDC_BG8000
LCDC_BG9800     EQU %11110111 ; BG Tile Map Display Select (and)
LCDC_BG9C00     EQU %00001000 ; BG Tile Map Display Select (ld/or)
LCDC_BGTILEMAP  EQU LCDC_BG9C00
LCDC_OBJ8       EQU %11111011 ; OBJ Construction (and)
LCDC_OBJ16      EQU %00000100 ; OBJ Construction (ld/or)
LCDC_OBJSIZE    EQU LCDC_OBJ16
LCDC_OBJOFF     EQU %11111101 ; OBJ Display (and)
LCDC_OBJON      EQU %00000010 ; OBJ Display (ld/or)
LCDC_OBJENABLE  EQU LCDC_OBJON
LCDC_BGOFF      EQU %11111110 ; BG Display (and)
LCDC_BGON       EQU %00000001 ; BG Display (ld/or)
LCDC_BGENABLE   EQU LCDC_BGON

rSTAT       EQU $ff41 ; LCDC Status (R/W)
STAT_LYC          EQU 6 ; LYC=LY Coincidence
STAT_MODE_OAM     EQU 5 ; Mode 10 (OAM)
STAT_MODE_VBLANK  EQU 4 ; Mode 01 (V-Blank)
STAT_MODE_HBLANK  EQU 3 ; Mode 00 (H-Blank)
STAT_LYCFLAG      EQU 2 ; 0:LYC<>LY, 1:LYC=LY
STAT_LCDC_STATUS  EQU %00000011
STAT_ON_HBLANK    EQU %00000000 ; H-Blank
STAT_ON_VBLANK    EQU %00000001 ; V-Blank
STAT_ON_OAM       EQU %00000010 ; OAM-RAM is used by system
STAT_ON_LCD       EQU %00000011 ; Both OAM and VRAM used by system
STAT_BUSY         EQU 1 ; When set, VRAM and OAM access is unsafe

rSCY        EQU $ff42 ; Scroll Y (R/W)
rSCX        EQU $ff43 ; Scroll X (R/W)

rLY         EQU $ff44 ; LCDC Y-Coordinate (R)
LY_VBLANK EQU 145
rLYC        EQU $ff45 ; LY Compare (R/W)

rDMA        EQU $ff46 ; DMA Transfer and Start Address (W)

rBGP        EQU $ff47 ; BG Palette Data (R/W) - Non CGB Mode Only
rOBP0       EQU $ff48 ; Object Palette 0 Data (R/W) - Non CGB Mode Only
rOBP1       EQU $ff49 ; Object Palette 1 Data (R/W) - Non CGB Mode Only

rWY         EQU $ff4a ; Window Y Position (R/W)
rWX         EQU $ff4b ; Window X Position minus 7 (R/W)

rKEY1       EQU $ff4d ; CGB Mode Only - Prepare Speed Switch

rVBK        EQU $ff4f ; CGB Mode Only - VRAM Bank

rHDMA1      EQU $ff51 ; CGB Mode Only - New DMA Source, High
rHDMA2      EQU $ff52 ; CGB Mode Only - New DMA Source, Low
rHDMA3      EQU $ff53 ; CGB Mode Only - New DMA Destination, High
rHDMA4      EQU $ff54 ; CGB Mode Only - New DMA Destination, Low
rHDMA5      EQU $ff55 ; CGB Mode Only - New DMA Length/Mode/Start

rRP         EQU $ff56 ; CGB Mode Only - Infrared Communications Port

rBGPI       EQU $ff68 ; CGB Mode Only - Background Palette Index
rBGPD       EQU $ff69 ; CGB Mode Only - Background Palette Data
rOBPI       EQU $ff6a ; CGB Mode Only - Sprite Palette Index
rOBPD       EQU $ff6b ; CGB Mode Only - Sprite Palette Data

rUNKNOWN1   EQU $ff6c ; (FEh) Bit 0 (Read/Write) - CGB Mode Only

rSVBK       EQU $ff70 ; CGB Mode Only - WRAM Bank

rUNKNOWN2   EQU $ff72 ; (00h) - Bit 0-7 (Read/Write)
rUNKNOWN3   EQU $ff73 ; (00h) - Bit 0-7 (Read/Write)
rUNKNOWN4   EQU $ff74 ; (00h) - Bit 0-7 (Read/Write) - CGB Mode Only
rUNKNOWN5   EQU $ff75 ; (8Fh) - Bit 4-6 (Read/Write)
rUNKNOWN6   EQU $ff76 ; (00h) - Always 00h (Read Only)
rUNKNOWN7   EQU $ff77 ; (00h) - Always 00h (Read Only)

rIE         EQU $ffff ; Interrupt Enable (R/W)
