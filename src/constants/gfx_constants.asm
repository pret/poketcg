; screen size
SCREEN_WIDTH  EQU 20 ; tiles
SCREEN_HEIGHT EQU 18 ; tiles

; background map size
BG_MAP_WIDTH  EQU 32 ; tiles
BG_MAP_HEIGHT EQU 32 ; tiles

; cgb palette size
CGB_PAL_SIZE EQU 8 ; bytes
palettes EQUS "* CGB_PAL_SIZE"

NUM_BACKGROUND_PALETTES EQU 8
NUM_OBJECT_PALETTES     EQU 8

; tile size
TILE_SIZE EQU 16 ; bytes
tiles EQUS "* TILE_SIZE"

TILE_SIZE_1BPP EQU 8 ; bytes
tiles_1bpp EQUS "* TILE_SIZE_1BPP"
