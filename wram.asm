;--- Bank 0: $Cxxx ----------------------------------------
SECTION "WRAM0", WRAM0
	ds $ab3

wInitialA: ; cab3
	ds $1

wConsole: ; cab4
	ds $2

wTileMapFill: ; cab6
	ds $1

wIE: ; cab7
	ds $1

wVBlankCtr: ; cab8
	ds $3

wLCDC: ; cabb
	ds $1

wBGP: ; cabc
	ds $1

wOBP0: ; cabd
	ds $1

wOBP1: ; cabe
	ds $6

wCounterEnable: ; cac4
	ds $1

wCounter0: ; cac5
	ds $1

wCounter1: ; cac6
	ds $1

wCounter2: ; cac7
	ds $1

wCounter3: ; cac8
	ds $1

wCounter4: ; cac9
	ds $27

wBufPalette: ; caf0
	ds $84

wBufSerial: ; cb74
	ds $1


;--- Bank 1: $Dxxx ----------------------------------------
SECTION "WRAM1", WRAMX, BANK[1]
	ds $32f

wCurMap: ; d32f
	ds $1

wPlayerXCoord: ; d330
	ds $1

wPlayerYCoord: ; d331
	ds $a53

wMusicDC: ; dd84
	ds $2

wMusicDuty: ; dd86
	ds $4

wMusicWave: ; dd8a
	ds $1

wMusicWaveChange: ; dd8b
	ds $2

wMusicIsPlaying: ; dd8d
	ds $4

wMusicTie: ; dd91
	ds $c

wMusicMainLoop: ; dd9d
	ds $12

wMusicOctave: ; ddaf
	ds $10

wMusicE8: ; ddbf
	ds $8

wMusicE9: ; ddc7
	ds $4

wMusicEC: ; ddcb
	ds $4

wMusicSpeed: ; ddcf
	ds $4

wMusicVibratoType: ; ddd3
	ds $4

wMusicVibratoType2: ; ddd7
	ds $8

wMusicVibratoDelay: ; dddf
	ds $8

wMusicVolume: ; dde7
	ds $3

wMusicE4: ; ddea
	ds $9

wMusicReturnAddress: ; ddf3
	ds $8
