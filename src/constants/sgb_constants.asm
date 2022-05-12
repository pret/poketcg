DEF SGB_PACKET_SIZE EQU $10 ; bytes

DEF PAL01    EQU $00 ; Set SGB Palette 0,1 Data
DEF PAL23    EQU $01 ; Set SGB Palette 2,3 Data
DEF PAL03    EQU $02 ; Set SGB Palette 0,3 Data
DEF PAL12    EQU $03 ; Set SGB Palette 1,2 Data
DEF ATTR_BLK EQU $04 ; "Block" Area Designation Mode
DEF ATTR_LIN EQU $05 ; "Line" Area Designation Mode
DEF ATTR_DIV EQU $06 ; "Divide" Area Designation Mode
DEF ATTR_CHR EQU $07 ; "1CHR" Area Designation Mode
DEF SOUND    EQU $08 ; Sound On/Off
DEF SOU_TRN  EQU $09 ; Transfer Sound PRG/DATA
DEF PAL_SET  EQU $0a ; Set SGB Palette Indirect
DEF PAL_TRN  EQU $0b ; Set System Color Palette Data
DEF ATRC_EN  EQU $0c ; Enable/disable Attraction Mode
DEF TEST_EN  EQU $0d ; Speed Function
DEF ICON_EN  EQU $0e ; SGB Function
DEF DATA_SND EQU $0f ; SUPER NES WRAM Transfer 1
DEF DATA_TRN EQU $10 ; SUPER NES WRAM Transfer 2
DEF MLT_REQ  EQU $11 ; Controller 2 Request
DEF JUMP     EQU $12 ; Set SNES Program Counter
DEF CHR_TRN  EQU $13 ; Transfer Character Font Data
DEF PCT_TRN  EQU $14 ; Set Screen Data Color Data
DEF ATTR_TRN EQU $15 ; Set Attribute from ATF
DEF ATTR_SET EQU $16 ; Set Data to ATF
DEF MASK_EN  EQU $17 ; Game Boy Window Mask
DEF OBJ_TRN  EQU $18 ; Super NES OBJ Mode

DEF ATTR_BLK_CTRL_INSIDE  EQU 1
DEF ATTR_BLK_CTRL_LINE    EQU 2
DEF ATTR_BLK_CTRL_OUTSIDE EQU 4

DEF MLT_REQ_1_PLAYER  EQU 0
DEF MLT_REQ_2_PLAYERS EQU 1
DEF MLT_REQ_4_PLAYERS EQU 3

DEF MASK_EN_CANCEL_MASK          EQU 0
DEF MASK_EN_FREEZE_SCREEN        EQU 1
DEF MASK_EN_BLANK_SCREEN_BLACK   EQU 2
DEF MASK_EN_BLANK_SCREEN_COLOR_0 EQU 3
