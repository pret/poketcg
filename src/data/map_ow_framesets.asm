; each map has two corresponding OW framesets, for non-CGB and CGB respectively
; within each frameset there is a header which contains relative
; offsets to each frameset subgroup, for a total of 3
; (in fact, only the first subgroup is effectively used,
; the other two always point to end of data, -1)
; inside a subgroup, some OW frames are defined with data
; regarding its duration, and which tile to substitute
; each OW frame defines 1 single tile to substitute, however
; frames with duration of 0 are processed at the same time as previous ones,
; so several tiles can be changed concurrently

INCLUDE "data/map_ow_frameset_pointers.asm"

; OW_FRAME_STRUCT (see constants/animation_constants.asm)
; \1 = duration
; \2 = VRAM tile offset
; \3 = VRAM bank
; \4 = tileset
; \5 = tileset offset
MACRO ow_frame
	db \1
	db \2
	db \3
	dbw BANK(\4) - BANK(MapOWFramesetPointers), \4 + $2
	dw \5
ENDM

DefaultOWFrameset: ; 8055e (20:455e)
	db $3, $3, $3
	db -1 ; end

OverworldMapOWFrameset: ; 80662 (20:4662)
	db $3, $33, $33

	ow_frame 7, $f3, 0, OverworldMapTiles, $73
	ow_frame 7, $f4, 0, OverworldMapTiles, $74
	ow_frame 7, $f3, 0, OverworldMapTiles, $74
	ow_frame 7, $f4, 0, OverworldMapTiles, $75
	ow_frame 7, $f3, 0, OverworldMapTiles, $75
	ow_frame 7, $f4, 0, OverworldMapTiles, $73
	db -1 ; end

OverworldMapCGBOWFrameset: ; 80696 (20:4696)
	db $3, $ab, $ab

	ow_frame 4, $f3, 0, OverworldMapTiles, $73
	ow_frame 4, $f4, 0, OverworldMapTiles, $74
	ow_frame 4, $18, 1, OverworldMapTiles, $98
	ow_frame 0, $19, 1, OverworldMapTiles, $99
	ow_frame 0, $1a, 1, OverworldMapTiles, $9a
	ow_frame 0, $1b, 1, OverworldMapTiles, $9b
	ow_frame 0, $1c, 1, OverworldMapTiles, $9c
	ow_frame 4, $f3, 0, OverworldMapTiles, $74
	ow_frame 4, $f4, 0, OverworldMapTiles, $75
	ow_frame 4, $18, 1, OverworldMapTiles, $9d
	ow_frame 0, $19, 1, OverworldMapTiles, $9e
	ow_frame 0, $1a, 1, OverworldMapTiles, $9f
	ow_frame 0, $1b, 1, OverworldMapTiles, $a0
	ow_frame 0, $1c, 1, OverworldMapTiles, $a1
	ow_frame 7, $f3, 0, OverworldMapTiles, $75
	ow_frame 7, $f4, 0, OverworldMapTiles, $73
	ow_frame 4, $18, 1, OverworldMapTiles, $a2
	ow_frame 0, $19, 1, OverworldMapTiles, $a3
	ow_frame 0, $1a, 1, OverworldMapTiles, $a4
	ow_frame 0, $1b, 1, OverworldMapTiles, $a5
	ow_frame 0, $1c, 1, OverworldMapTiles, $a6
	db -1 ; end

MasonLaboratoryOWFrameset: ; 80742 (20:4742)
	db $3, $43, $43

	ow_frame 3, $dc, 0, MasonLaboratoryTilesetGfx, $5c
	ow_frame 0, $dd, 0, MasonLaboratoryTilesetGfx, $5d
	ow_frame 3, $de, 0, MasonLaboratoryTilesetGfx, $5e
	ow_frame 0, $df, 0, MasonLaboratoryTilesetGfx, $5f
	ow_frame 3, $dc, 0, MasonLaboratoryTilesetGfx, $60
	ow_frame 0, $dd, 0, MasonLaboratoryTilesetGfx, $61
	ow_frame 3, $de, 0, MasonLaboratoryTilesetGfx, $62
	ow_frame 0, $df, 0, MasonLaboratoryTilesetGfx, $63
	db -1 ; end

DeckMachineRoomOWFrameset: ; 80786 (20:4786)
	db $3, $83, $83

	ow_frame 3, $dc, 0, MasonLaboratoryTilesetGfx, $5c
	ow_frame 0, $dd, 0, MasonLaboratoryTilesetGfx, $5d
	ow_frame 3, $de, 0, MasonLaboratoryTilesetGfx, $5e
	ow_frame 0, $df, 0, MasonLaboratoryTilesetGfx, $5f
	ow_frame 5, $e4, 0, MasonLaboratoryTilesetGfx, $64
	ow_frame 0, $e5, 0, MasonLaboratoryTilesetGfx, $65
	ow_frame 0, $e6, 0, MasonLaboratoryTilesetGfx, $66
	ow_frame 0, $e7, 0, MasonLaboratoryTilesetGfx, $67
	ow_frame 3, $dc, 0, MasonLaboratoryTilesetGfx, $60
	ow_frame 0, $dd, 0, MasonLaboratoryTilesetGfx, $61
	ow_frame 3, $de, 0, MasonLaboratoryTilesetGfx, $62
	ow_frame 0, $df, 0, MasonLaboratoryTilesetGfx, $63
	ow_frame 5, $e4, 0, MasonLaboratoryTilesetGfx, $68
	ow_frame 0, $e5, 0, MasonLaboratoryTilesetGfx, $69
	ow_frame 0, $e6, 0, MasonLaboratoryTilesetGfx, $6a
	ow_frame 0, $e7, 0, MasonLaboratoryTilesetGfx, $6b
	db -1 ; end

DeckMachineRoomCGBOWFrameset: ; 8080a (20:480a)
	db $3, $83, $83

	ow_frame 3, $dc, 0, MasonLaboratoryTilesetGfx, $5c
	ow_frame 0, $dd, 0, MasonLaboratoryTilesetGfx, $5d
	ow_frame 3, $de, 0, MasonLaboratoryTilesetGfx, $5e
	ow_frame 0, $df, 0, MasonLaboratoryTilesetGfx, $5f
	ow_frame 5, $03, 1, MasonLaboratoryTilesetGfx, $83
	ow_frame 0, $04, 1, MasonLaboratoryTilesetGfx, $84
	ow_frame 0, $05, 1, MasonLaboratoryTilesetGfx, $85
	ow_frame 0, $06, 1, MasonLaboratoryTilesetGfx, $86
	ow_frame 3, $dc, 0, MasonLaboratoryTilesetGfx, $60
	ow_frame 0, $dd, 0, MasonLaboratoryTilesetGfx, $61
	ow_frame 3, $de, 0, MasonLaboratoryTilesetGfx, $62
	ow_frame 0, $df, 0, MasonLaboratoryTilesetGfx, $63
	ow_frame 5, $03, 1, MasonLaboratoryTilesetGfx, $87
	ow_frame 0, $04, 1, MasonLaboratoryTilesetGfx, $88
	ow_frame 0, $05, 1, MasonLaboratoryTilesetGfx, $89
	ow_frame 0, $06, 1, MasonLaboratoryTilesetGfx, $8a
	db -1 ; end

FireClubOWFrameset: ; 8088e (20:488e)
	db $3, $83, $83

	ow_frame 5, $9f, 0, FireClubTilesetGfx, $1f
	ow_frame 0, $a0, 0, FireClubTilesetGfx, $20
	ow_frame 0, $a1, 0, FireClubTilesetGfx, $21
	ow_frame 0, $a2, 0, FireClubTilesetGfx, $22
	ow_frame 6, $a3, 0, FireClubTilesetGfx, $23
	ow_frame 0, $a4, 0, FireClubTilesetGfx, $24
	ow_frame 0, $a5, 0, FireClubTilesetGfx, $25
	ow_frame 0, $a6, 0, FireClubTilesetGfx, $26
	ow_frame 5, $9f, 0, FireClubTilesetGfx, $27
	ow_frame 0, $a0, 0, FireClubTilesetGfx, $28
	ow_frame 0, $a1, 0, FireClubTilesetGfx, $29
	ow_frame 0, $a2, 0, FireClubTilesetGfx, $2a
	ow_frame 6, $a3, 0, FireClubTilesetGfx, $2b
	ow_frame 0, $a4, 0, FireClubTilesetGfx, $2c
	ow_frame 0, $a5, 0, FireClubTilesetGfx, $2d
	ow_frame 0, $a6, 0, FireClubTilesetGfx, $2e
	db -1 ; end

FireClubCGBOWFrameset: ; 80912 (20:4912)
	db $3, $83, $83

	ow_frame 5, $bb, 0, FireClubTilesetGfx, $3b
	ow_frame 0, $bc, 0, FireClubTilesetGfx, $3c
	ow_frame 0, $bd, 0, FireClubTilesetGfx, $3d
	ow_frame 0, $be, 0, FireClubTilesetGfx, $3e
	ow_frame 6, $bf, 0, FireClubTilesetGfx, $3f
	ow_frame 0, $c0, 0, FireClubTilesetGfx, $40
	ow_frame 0, $c1, 0, FireClubTilesetGfx, $41
	ow_frame 0, $c2, 0, FireClubTilesetGfx, $42
	ow_frame 5, $bb, 0, FireClubTilesetGfx, $43
	ow_frame 0, $bc, 0, FireClubTilesetGfx, $44
	ow_frame 0, $bd, 0, FireClubTilesetGfx, $45
	ow_frame 0, $be, 0, FireClubTilesetGfx, $46
	ow_frame 6, $bf, 0, FireClubTilesetGfx, $47
	ow_frame 0, $c0, 0, FireClubTilesetGfx, $48
	ow_frame 0, $c1, 0, FireClubTilesetGfx, $49
	ow_frame 0, $c2, 0, FireClubTilesetGfx, $4a
	db -1 ; end

WaterClubOWFrameset: ; 80996 (20:4996)
	db $3, $c3, $c3

	ow_frame 1, $e2, 0, WaterClubTilesetGfx, $62
	ow_frame 1, $e3, 0, WaterClubTilesetGfx, $63
	ow_frame 3, $e4, 0, WaterClubTilesetGfx, $64
	ow_frame 0, $e5, 0, WaterClubTilesetGfx, $65
	ow_frame 3, $e6, 0, WaterClubTilesetGfx, $66
	ow_frame 0, $e7, 0, WaterClubTilesetGfx, $67
	ow_frame 1, $e2, 0, WaterClubTilesetGfx, $68
	ow_frame 1, $e3, 0, WaterClubTilesetGfx, $69
	ow_frame 3, $e4, 0, WaterClubTilesetGfx, $6a
	ow_frame 0, $e5, 0, WaterClubTilesetGfx, $6b
	ow_frame 3, $e6, 0, WaterClubTilesetGfx, $6c
	ow_frame 0, $e7, 0, WaterClubTilesetGfx, $6d
	ow_frame 1, $e2, 0, WaterClubTilesetGfx, $62
	ow_frame 1, $e3, 0, WaterClubTilesetGfx, $63
	ow_frame 3, $e4, 0, WaterClubTilesetGfx, $64
	ow_frame 0, $e5, 0, WaterClubTilesetGfx, $65
	ow_frame 3, $e6, 0, WaterClubTilesetGfx, $66
	ow_frame 0, $e7, 0, WaterClubTilesetGfx, $67
	ow_frame 1, $e2, 0, WaterClubTilesetGfx, $6e
	ow_frame 1, $e3, 0, WaterClubTilesetGfx, $6f
	ow_frame 3, $e4, 0, WaterClubTilesetGfx, $70
	ow_frame 0, $e5, 0, WaterClubTilesetGfx, $71
	ow_frame 3, $e6, 0, WaterClubTilesetGfx, $72
	ow_frame 0, $e7, 0, WaterClubTilesetGfx, $73
	db -1 ; end

LightningClubOWFrameset: ; 80a5a (20:4a5a)
	db $3, $c3, $c3

	ow_frame 10, $a2, 0, LightningClubTilesetGfx, $22
	ow_frame  0, $a3, 0, LightningClubTilesetGfx, $23
	ow_frame  0, $aa, 0, LightningClubTilesetGfx, $2a
	ow_frame  0, $ab, 0, LightningClubTilesetGfx, $2b
	ow_frame  4, $a5, 0, LightningClubTilesetGfx, $25
	ow_frame  0, $a6, 0, LightningClubTilesetGfx, $26
	ow_frame  0, $ac, 0, LightningClubTilesetGfx, $2c
	ow_frame  0, $ad, 0, LightningClubTilesetGfx, $2d
	ow_frame  4, $a7, 0, LightningClubTilesetGfx, $27
	ow_frame  0, $a8, 0, LightningClubTilesetGfx, $28
	ow_frame  0, $b0, 0, LightningClubTilesetGfx, $30
	ow_frame  0, $b1, 0, LightningClubTilesetGfx, $31
	ow_frame 10, $a2, 0, LightningClubTilesetGfx, $2a
	ow_frame  0, $a3, 0, LightningClubTilesetGfx, $2b
	ow_frame  0, $aa, 0, LightningClubTilesetGfx, $22
	ow_frame  0, $ab, 0, LightningClubTilesetGfx, $23
	ow_frame  4, $a5, 0, LightningClubTilesetGfx, $2d
	ow_frame  0, $a6, 0, LightningClubTilesetGfx, $2e
	ow_frame  0, $ac, 0, LightningClubTilesetGfx, $24
	ow_frame  0, $ad, 0, LightningClubTilesetGfx, $25
	ow_frame  4, $a7, 0, LightningClubTilesetGfx, $2f
	ow_frame  0, $a8, 0, LightningClubTilesetGfx, $30
	ow_frame  0, $b0, 0, LightningClubTilesetGfx, $28
	ow_frame  0, $b1, 0, LightningClubTilesetGfx, $29
	db -1 ; end

ScienceClubOWFrameset: ; 80b1e (20:4b1e)
	db $3, $13, $13
	ow_frame 11, $c7, 0, ScienceClubTilesetGfx, $47
	ow_frame 11, $c7, 0, ScienceClubTilesetGfx, $48
	db -1 ; end

ChallengeHallOWFrameset: ; 80b32 (20:4b32)
	db $3, $3, $3
	db -1 ; end

HallOfHonorOWFrameset: ; 80b36 (20:4b36)
	db $3, $43, $43
	ow_frame 11, $a4, 0, HallOfHonorTilesetGfx, $28
	ow_frame  0, $a5, 0, HallOfHonorTilesetGfx, $29
	ow_frame  0, $a6, 0, HallOfHonorTilesetGfx, $2a
	ow_frame  0, $a7, 0, HallOfHonorTilesetGfx, $2b
	ow_frame 11, $a4, 0, HallOfHonorTilesetGfx, $2c
	ow_frame  0, $a5, 0, HallOfHonorTilesetGfx, $2d
	ow_frame  0, $a6, 0, HallOfHonorTilesetGfx, $2e
	ow_frame  0, $a7, 0, HallOfHonorTilesetGfx, $2f
	db -1 ; end
