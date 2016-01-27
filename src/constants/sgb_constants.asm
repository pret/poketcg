PAL01    EQU $00 ; Set SGB Palette 0,1 Data
PAL23    EQU $01 ; Set SGB Palette 2,3 Data
PAL03    EQU $02 ; Set SGB Palette 0,3 Data
PAL12    EQU $03 ; Set SGB Palette 1,2 Data
ATTR_BLK EQU $04 ; "Block" Area Designation Mode
ATTR_LIN EQU $05 ; "Line" Area Designation Mode
ATTR_DIV EQU $06 ; "Divide" Area Designation Mode
ATTR_CHR EQU $07 ; "1CHR" Area Designation Mode
SOUND    EQU $08 ; Sound On/Off
SOU_TRN  EQU $09 ; Transfer Sound PRG/DATA
PAL_SET  EQU $0A ; Set SGB Palette Indirect
PAL_TRN  EQU $0B ; Set System Color Palette Data
ATRC_EN  EQU $0C ; Enable/disable Attraction Mode
TEST_EN  EQU $0D ; Speed Function
ICON_EN  EQU $0E ; SGB Function
DATA_SND EQU $0F ; SUPER NES WRAM Transfer 1
DATA_TRN EQU $10 ; SUPER NES WRAM Transfer 2
MLT_REQ  EQU $11 ; Controller 2 Request
JUMP     EQU $12 ; Set SNES Program Counter
CHR_TRN  EQU $13 ; Transfer Character Font Data
PCT_TRN  EQU $14 ; Set Screen Data Color Data
ATTR_TRN EQU $15 ; Set Attribute from ATF
ATTR_SET EQU $16 ; Set Data to ATF
MASK_EN  EQU $17 ; Game Boy Window Mask
OBJ_TRN  EQU $18 ; Super NES OBJ Mode
