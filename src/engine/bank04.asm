Func_10000: ; 10000 (4:4000)
	ld a, $0
	ld [wTileMapFill], a
	call EmptyScreen
	call LoadSymbolsFont
	lb de, $30, $7f
	call SetupText
	call Set_OBJ_8x8
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, [wLCDC]
	bit LCDC_ENABLE_F, a
	jr nz, .asm_10025
	xor a
	ldh [rSCX], a
	ldh [rSCY], a

.asm_10025
	call Func_1288c
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ret

Func_10031: ; 10031 (4:4031)
	ldh a, [hBankSRAM]
	push af
	ld a, $1
	call BankswitchSRAM
	call Func_10cbb
	call DisableSRAM
	call Func_10b28
	call FlushAllPalettes
	call EnableLCD
	call DoFrameIfLCDEnabled
	call Func_10cea
	call FlushAllPalettes
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret

Func_10059: ; 10059 (4:4059)
	INCROM $10059, $100a2

Func_100a2: ; 100a2 (4:40a2)
	INCROM $100a2, $1010c

Func_1010c: ; 1010c (4:410c)
	INCROM $1010c, $10197

Func_10197: ; 10197 (4:4197)
	INCROM $10197, $1029e

Medal_1029e: ; 1029e (4:429e)
	sub $8
	ld c, a
	ld [wd115], a
	ld a, [wd291]
	push af
	push bc
	call PauseSong
	ld a, MUSIC_STOP
	call PlaySong
	farcall Func_70000
	call DisableLCD
	call Func_10000
	ld a, $fa
	ld [wd114], a
	call Func_1010c
	pop bc
	ld a, c
	add a
	ld c, a
	ld b, $0
	ld hl, MasterMedalNames
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	call Func_10031
	ld a, MUSIC_MEDAL
	call PlaySong
	ld a, $ff
	ld [wd116], a
.asm_102e2
	call DoFrameIfLCDEnabled
	ld a, [wd116]
	inc a
	ld [wd116], a
	and $f
	jr nz, .asm_102e2
	call Func_10197
	ld a, [wd116]
	cp $e0
	jr nz, .asm_102e2
	ldtx hl, WonTheMedalText
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	pop af
	ld [wd291], a
	ret

MasterMedalNames: ; 1030b (4:430b)
	tx GrassClubMapNameText
	tx ScienceClubMapNameText
	tx FireClubMapNameText
	tx WaterClubMapNameText
	tx LightningClubMapNameText
	tx PsychicClubMapNameText
	tx RockClubMapNameText
	tx FightingClubMapNameText

GiveBoosterPack: ; 1031b (4:431b)
	ld c, a
	ld a, [wd291]
	push af
	push bc
	call DisableLCD
	call Func_10000
	xor a
	ld [wTextBoxFrameType], a
	pop bc
	push bc
	ld b, 0
	ld hl, BoosterTypes
	add hl, bc
	ld a, [hl]
	ld c, a
	add a
	add a
	ld c, a
	ld hl, BoosterScenesAndNameTexts
	add hl, bc
	ld a, [hli]
	push hl
	lb bc, 6, 0
	call LoadBoosterGfx
	pop hl
	ld a, [hli]
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	call Func_10031
	call PauseSong
	ld a, MUSIC_BOOSTER_PACK
	call PlaySong
	pop bc
	ld a, c
	farcall GenerateBoosterPack
	ldtx hl, ReceivedBoosterPackText
	ld a, [wAnotherBoosterPack]
	cp TRUE
	jr nz, .first_booster
	ldtx hl, AndAnotherBoosterPackText
.first_booster
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ldtx hl, CheckedCardsInBoosterPackText
	call PrintScrollableText_NoTextBoxLabel
	call DisableLCD
	call Func_1288c
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ld a, $4
	ld [wTextBoxFrameType], a
	farcall OpenBoosterPack
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	pop af
	ld [wd291], a
	ret

BoosterTypes: ; 103a5 (4:43a5)
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_NEUTRAL
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_GRASS
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_FIRE
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_WATER
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_LIGHTNING
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_FIGHTING
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_TRAINER
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_NEUTRAL
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_GRASS
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_FIRE
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_WATER
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_FIGHTING
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_PSYCHIC
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_TRAINER
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_NEUTRAL
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_GRASS_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_WATER_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_LIGHTNING_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_FIGHTING_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_TRAINER_COLORLESS
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_NEUTRAL
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_GRASS
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_WATER
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_PSYCHIC
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_TRAINER
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_LIGHTNING_FIRE
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_WATER_FIGHTING
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_GRASS_PSYCHIC
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_RANDOM

BoosterScenesAndNameTexts: ; 103c2 (4:43c2)
	db SCENE_COLOSSEUM_BOOSTER, SCENE_COLOSSEUM_BOOSTER
	tx ColosseumBoosterText

	db SCENE_EVOLUTION_BOOSTER, SCENE_EVOLUTION_BOOSTER
	tx EvolutionBoosterText

	db SCENE_MYSTERY_BOOSTER, SCENE_MYSTERY_BOOSTER
	tx MysteryBoosterText

	db SCENE_LABORATORY_BOOSTER, SCENE_LABORATORY_BOOSTER
	tx LaboratoryBoosterText

Func_103d2: ; 103d2 (4:43d2)
	INCROM $103d2, $103d3

Duel_Init: ; 103d3 (4:43d3)
	ld a, [wd291]
	push af
	call DisableLCD
	call Func_10000
	ld a, $4
	ld [wTextBoxFrameType], a
	lb de, 0, 12
	lb bc, 20, 6
	call DrawRegularTextBox
	ld a, [wNPCDuelDeckID]
	add a
	add a
	ld c, a
	ld b, $0
	ld hl, Unknown_1045b
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hli]
	ld [wTxRam2 + 1], a
	push hl
	ld a, [wOpponentName]
	ld [wTxRam2_b], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2_b + 1], a
	ld hl, Unknown_10451
	call Func_111b3 ; LoadDuelistName
	pop hl
	ld a, [hli]
	ld [wTxRam2], a
	ld c, a
	ld a, [hli]
	ld [wTxRam2 + 1], a
	or c
	jr z, .asm_10425
	ld hl, Unknown_10456
	call Func_111b3 ; LoadDeckName

.asm_10425
	ld bc, $0703
	ld a, [wOpponentPortrait]
	call Func_3e2a ; LoadDuelistPortrait
	ld a, [wMatchStartTheme]
	call PlaySong
	call Func_10031
	call DoFrameIfLCDEnabled
	lb bc, $2f, $1d ; cursor tile, tile behind cursor
	lb de, 18, 17 ; x, y
	call SetCursorParametersForTextBox
	call WaitForButtonAorB
	call WaitForSongToFinish
	call Func_10ab4 ; fade out
	pop af
	ld [wd291], a
	ret

Unknown_10451: ; 10451 (4:4451)
	INCROM $10451, $10456

Unknown_10456: ; 10456 (4:4456)
	INCROM $10456, $1045b

Unknown_1045b: ; 1045b (4:445b)
	INCROM $1045b, $1052f

Func_1052f: ; 1052f (4:452f)
	INCROM $1052f, $10548

Func_10548: ; 10548 (4:4548)
	INCROM $10548, $10756

Func_10756: ; 10756 (4:4756)
	INCROM $10756, $1076d

Func_1076d: ; 1076d (4:476d)
	INCROM $1076d, $10a70

; gives the pc pack described in a
TryGivePCPack: ; 10a70 (4:4a70)
	push hl
	push bc
	push de
	ld b, a
	ld c, $f ; number of packs possible
	ld hl, wPCPacks
.searchLoop1
	ld a, [hli]
	and $7f
	cp b
	jr z, .quit
	dec c
	jr nz, .searchLoop1
	ld c, $f
	ld hl, wPCPacks
.findFreeSlotLoop
	ld a, [hl]
	and $7f
	jr z, .foundFreeSlot
	inc hl
	dec c
	jr nz, .findFreeSlotLoop
	debug_nop
	jr .quit

.foundFreeSlot
	ld a, b
	or $80 ; mark pack as unopened
	ld [hl], a

.quit
	pop de
	pop bc
	pop hl
	ret

Func_10a9b: ; 10a9b (4:4a9b)
	INCROM $10a9b, $10ab4

Func_10ab4: ; 10ab4 (4:4ab4)
	INCROM $10ab4, $10af9

Func_10af9: ; 10af9 (4:4af9)
	INCROM $10af9, $10b28

Func_10b28: ; 10b28 (4:4b28)
	INCROM $10b28, $10c96

Func_10c96: ; 10c96 (4:4c96)
	ldh a, [hBankSRAM]
	push af
	push bc
	ld a, $1
	call BankswitchSRAM
	call Func_10cbb
	call Func_10ab4
	pop bc
	ld a, c
	or a
	jr nz, .asm_10cb0
	call Func_10cea
	call Func_10af9

.asm_10cb0
	call EnableLCD
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret

Func_10cbb: ; 10cbb (4:4cbb)
	INCROM $10cbb, $10cea

Func_10cea: ; 10cea (4:4cea)
	INCROM $10cea, $10d98

Unknown_10d98: ; 10d98 (4:4d98)
	INCROM $10d98, $10da9

Unknown_10da9: ; 10da9 (4:4da9)
	INCROM $10da9, $10dba

Func_10dba: ; 10dba (4:4dba)
	ld a, $1
	farcall Func_c29b
	ld a, [wd0ba]
	ld hl, Unknown_10e17
	farcall Func_111e9
.asm_10dca
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .asm_10dca
	ld a, e
	ld [wd0ba], a
	ldh a, [hCurMenuItem]
	cp e
	jr z, .asm_10ddd
	ld a, $4

.asm_10ddd
	ld [wd10e], a
	push af
	ld hl, Unknown_10df0
	call JumpToFunctionInTable
	farcall CloseTextBox
	call DoFrameIfLCDEnabled
	pop af
	ret

Unknown_10df0: ; 10df0 (4:4df0)
	INCROM $10df0, $10e17

Unknown_10e17: ; 10e17 (4:4e17)
	INCROM $10e17, $10e28

Func_10e28: ; 10e28 (4:4e28)
	push hl
	push bc
	push de
	ld a, [wd33b]
	ld [wWhichSprite], a
	ld a, [wOverworldMapSelection]
	ld d, $00
	ld e, $f4
	call Func_10ef0
	ld a, [wd33e]
	or a
	jr nz, .asm_10e51
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wd33d]
	ld d, $00
	ld e, $00
	call Func_10ef0
.asm_10e51
	pop de
	pop bc
	pop hl
	ret

Func_10e55: ; 10e55 (4:4e55)
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wd33e]
	or a
	jr nz, .asm_10e65
	call OverworldMap_HandleKeyPress
	ret
.asm_10e65
	cp $2
	jr z, .asm_10e6d
	call Func_11060
	ret
.asm_10e6d
	call LoadOverworldMapSelection
	ret

OverworldMap_HandleKeyPress: ; 10e71 (4:4e71)
	ldh a, [hKeysPressed]
	and D_PAD
	jr z, .no_d_pad
	farcall GetDirectionFromDPad
	ld [wPlayerDirection], a
	call OverworldMap_HandleDPad
	jr .done
.no_d_pad
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .done
	ld a, SFX_02
	call PlaySFX
	call Func_11016 ; load map?
	call Func_11024
	jr .done
.done
	ret

OverworldMap_HandleDPad: ; 10e97 (4:4e97)
	push hl
	pop hl
	ld a, [wOverworldMapSelection]
	rlca
	rlca
	ld c, a
	ld a, [wPlayerDirection]
	add c
	ld c, a
	ld b, 0
	ld hl, OverworldMap_CursorTransitions
	add hl, bc
	ld a, [hl]
	or a
	jr z, .no_transition
	ld [wOverworldMapSelection], a
	call PrintOverworldMapName ; update cursor oam?
	ld a, SFX_01
	call PlaySFX
.no_transition
	pop bc
	pop hl
	ret

OverworldMap_CursorTransitions: ; 10ebc (4:4ebc)
	; unused
	db OWMAP_SCIENCE_CLUB     ; NORTH
	db OWMAP_SCIENCE_CLUB     ; EAST
	db OWMAP_SCIENCE_CLUB     ; SOUTH
	db OWMAP_SCIENCE_CLUB     ; WEST

	; OWMAP_MASON_LABORATORY
	db OWMAP_LIGHTNING_CLUB   ; NORTH
	db OWMAP_FIGHTING_CLUB    ; EAST
	db $00                    ; SOUTH
	db $00                    ; WEST

	; OWMAP_ISHIHARAS_HOUSE
	db $00                    ; NORTH
	db OWMAP_CHALLENGE_HALL   ; EAST
	db OWMAP_ROCK_CLUB        ; SOUTH
	db $00                    ; WEST

	; OWMAP_FIGHTING_CLUB
	db OWMAP_LIGHTNING_CLUB   ; NORTH
	db OWMAP_WATER_CLUB       ; EAST
	db $00                    ; SOUTH
	db OWMAP_MASON_LABORATORY ; WEST

	; OWMAP_ROCK_CLUB
	db OWMAP_ISHIHARAS_HOUSE  ; NORTH
	db OWMAP_POKEMON_DOME     ; EAST
	db OWMAP_LIGHTNING_CLUB   ; SOUTH
	db $00                    ; WEST

	; OWMAP_WATER_CLUB
	db OWMAP_GRASS_CLUB       ; NORTH
	db $00                    ; EAST
	db $00                    ; SOUTH
	db OWMAP_FIGHTING_CLUB    ; WEST

	; OWMAP_LIGHTNING_CLUB
	db OWMAP_ROCK_CLUB        ; NORTH
	db OWMAP_POKEMON_DOME     ; EAST
	db OWMAP_FIGHTING_CLUB    ; SOUTH
	db OWMAP_MASON_LABORATORY ; WEST

	; OWMAP_GRASS_CLUB
	db OWMAP_SCIENCE_CLUB     ; NORTH
	db $00                    ; EAST
	db OWMAP_WATER_CLUB       ; SOUTH
	db OWMAP_PSYCHIC_CLUB     ; WEST

	; OWMAP_PSYCHIC_CLUB
	db OWMAP_FIRE_CLUB        ; NORTH
	db OWMAP_SCIENCE_CLUB     ; EAST
	db OWMAP_GRASS_CLUB       ; SOUTH
	db OWMAP_POKEMON_DOME     ; WEST

	; OWMAP_SCIENCE_CLUB
	db OWMAP_FIRE_CLUB        ; NORTH
	db $00                    ; EAST
	db OWMAP_GRASS_CLUB       ; SOUTH
	db OWMAP_PSYCHIC_CLUB     ; WEST

	; OWMAP_FIRE_CLUB
	db $00                    ; NORTH
	db OWMAP_SCIENCE_CLUB     ; EAST
	db OWMAP_SCIENCE_CLUB     ; SOUTH
	db OWMAP_PSYCHIC_CLUB     ; WEST

	; OWMAP_CHALLENGE_HALL
	db $00                    ; NORTH
	db OWMAP_PSYCHIC_CLUB     ; EAST
	db OWMAP_POKEMON_DOME     ; SOUTH
	db OWMAP_ISHIHARAS_HOUSE  ; WEST

	; OWMAP_POKEMON_DOME
	db OWMAP_CHALLENGE_HALL   ; NORTH
	db OWMAP_PSYCHIC_CLUB     ; EAST
	db OWMAP_FIGHTING_CLUB    ; SOUTH
	db OWMAP_ROCK_CLUB        ; WEST

Func_10ef0: ; 10ef0 (4:4ef0)
	call Func_10efd
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	ret

Func_10efd: ; 10efd (4:4efd)
	push hl
	push de
	rlca
	ld e, a
	ld d, $0
	ld hl, Unknown_10f14
	add hl, de
	pop de
	ld a, [hli]
	add $8
	add d
	ld d, a
	ld a, [hl]
	add $10
	add e
	ld e, a
	pop hl
	ret

Unknown_10f14: ; 10f14 (4:4f14)
	INCROM $10f14, $10f2e

PrintOverworldMapName: ; 10f2e (4:4f2e)
	push hl
	push de
	lb de, 1, 1
	call InitTextPrinting
	call GetOverworldMapName
	rlca
	ld e, a
	ld d, $0
	ld hl, OverworldMapNames
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	pop de
	pop hl
	ret

GetOverworldMapName: ; 10f4a (4:4f4a)
	push bc
	ld a, [wOverworldMapSelection]
	cp OWMAP_ISHIHARAS_HOUSE
	jr nz, .asm_10f5f
	ld c, a
	ld a, EVENT_ISHIHARAS_HOUSE_MENTIONED
	farcall GetEventValue
	or a
	ld a, c
	jr nz, .asm_10f5f
	ld a, $d
.asm_10f5f
	pop bc
	ret

LoadOverworldMapSelection: ; 10f61 (4:4f61)
	push hl
	push bc
	ld a, [wOverworldMapSelection]
	rlca
	rlca
	ld c, a
	ld b, 0
	ld hl, OverworldMapIndexes
	add hl, bc
	ld a, [hli]
	ld [wTempMap], a
	ld a, [hli]
	ld [wTempPlayerXCoord], a
	ld a, [hli]
	ld [wTempPlayerYCoord], a
	ld a, NORTH
	ld [wTempPlayerDirection], a
	ld hl, wd0b4
	set 4, [hl]
	pop bc
	pop hl
	ret

INCLUDE "data/overworld_indexes.asm"

Func_10fbc: ; 10fbc (4:4fbc)
	ld a, SPRITE_OW_MAP_OAM
	farcall CreateSpriteAndAnimBufferEntry
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, $80
	ld [hli], a
	ld a, $10
	ld [hl], a
	ld b, $34 ; non-cgb volcano smoke
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, $37 ; cgb volcano smoke
.not_cgb
	ld a, b
	farcall StartNewSpriteAnimation
	ret

Func_10fde: ; 10fde (4:4fde)
	ld a, [wOverworldMapSelection]
	ld [wd33d], a
	xor a
	ld [wd33e], a
	ld a, SPRITE_OW_MAP_OAM
	call CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wd33b], a
	ld b, $35 ; blue overworld map cursor
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, $38 ; red overworld map cursor
.not_cgb
	ld a, b
	ld [wd33c], a
	call StartNewSpriteAnimation
	ld a, EVENT_MASON_LAB_STATE
	farcall GetEventValue
	or a
	jr nz, .asm_11015
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	set 7, [hl]
.asm_11015
	ret

Func_11016: ; 11016 (4:5016)
	ld a, [wd33b]
	ld [wWhichSprite], a
	ld a, [wd33c]
	inc a
	call StartNewSpriteAnimation
	ret

Func_11024: ; 11024 (4:5024)
	ld a, SFX_57
	call PlaySFX
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	set 2, [hl]
	ld hl, Unknown_1229f
	ld a, [wd33d]
	dec a
	add a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wOverworldMapSelection]
	dec a
	add a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld [wd33f], a
	ld a, [hl]
	ld [wd340], a
	ld a, $1
	ld [wd33e], a
	xor a
	ld [wd341], a
	ret

; used while animating the player across the overworld map
Func_11060: ; 11060 (4:5060)
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wd341]
	or a
	jp nz, Func_11184
	ld a, [wd33f]
	ld l, a
	ld a, [wd340]
	ld h, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	and b
	cp $ff
	jr z, .asm_110a0
	ld a, c
	or b
	jr nz, .asm_11094
	ld a, [wd33d]
	ld e, a
	ld a, [wOverworldMapSelection]
	cp e
	jr z, .asm_110a0
	ld de, $0000
	call Func_10efd
	ld b, d
	ld c, e
.asm_11094
	ld a, l
	ld [wd33f], a
	ld a, h
	ld [wd340], a
	call Func_110a6
	ret
.asm_110a0
	ld a, $2
	ld [wd33e], a
	ret

Func_110a6: ; 110a6 (4:50a6)
	push hl
	push bc
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	pop bc
	ld a, b
	sub [hl]
	ld [wd343], a
	ld a, $0
	sbc $0
	ld [wd344], a
	inc hl
	ld a, c
	sub [hl]
	ld [wd345], a
	ld a, $0
	sbc $0
	ld [wd346], a
	ld a, [wd343]
	ld b, a
	ld a, [wd344]
	bit 7, a
	jr z, .asm_110d8
	ld a, [wd343]
	cpl
	inc a
	ld b, a
.asm_110d8
	ld a, [wd345]
	ld c, a
	ld a, [wd346]
	bit 7, a
	jr z, .asm_110e9
	ld a, [wd345]
	cpl
	inc a
	ld c, a
.asm_110e9
	ld a, b
	cp c
	jr c, .asm_110f2
	call Func_11102
	jr .asm_110f5
.asm_110f2
	call Func_1113e
.asm_110f5
	xor a
	ld [wd347], a
	ld [wd348], a
	farcall UpdatePlayerSprite
	pop hl
	ret

Func_11102: ; 11102 (4:5102)
	ld a, b
	ld [wd341], a
	ld e, a
	ld d, $0
	ld hl, wd343
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .asm_11115
	dec a
	jr .asm_11116
.asm_11115
	inc a
.asm_11116
	ld [hl], a
	ld b, c
	ld c, $0
	call DivideBCbyDE
	ld a, [wd346]
	bit 7, a
	jr z, .asm_11127
	call Func_11179
.asm_11127
	ld a, c
	ld [wd345], a
	ld a, b
	ld [wd346], a
	ld hl, wd344
	ld a, $1
	bit 7, [hl]
	jr z, .asm_1113a
	ld a, $3
.asm_1113a
	ld [wPlayerDirection], a
	ret

Func_1113e: ; 1113e (4:513e)
	ld a, c
	ld [wd341], a
	ld e, a
	ld d, $0
	ld hl, wd345
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .asm_11151
	dec a
	jr .asm_11152
.asm_11151
	inc a
.asm_11152
	ld [hl], a
	ld c, $0
	call DivideBCbyDE
	ld a, [wd344]
	bit 7, a
	jr z, .asm_11162
	call Func_11179
.asm_11162
	ld a, c
	ld [wd343], a
	ld a, b
	ld [wd344], a
	ld hl, wd346
	ld a, $2
	bit 7, [hl]
	jr z, .asm_11175
	ld a, $0
.asm_11175
	ld [wPlayerDirection], a
	ret

Func_11179: ; 11179 (4:5179)
	ld a, c
	cpl
	add $1
	ld c, a
	ld a, b
	cpl
	adc $0
	ld b, a
	ret

Func_11184: ; 11184 (4:5184)
	ld a, [wd347]
	ld d, a
	ld a, [wd348]
	ld e, a
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, [wd343]
	add d
	ld d, a
	ld a, [wd344]
	adc [hl]
	ld [hl], a
	inc hl
	ld a, [wd345]
	add e
	ld e, a
	ld a, [wd346]
	adc [hl]
	ld [hl], a
	ld a, d
	ld [wd347], a
	ld a, e
	ld [wd348], a
	ld hl, wd341
	dec [hl]
	ret

Func_111b3: ; 111b3 (4:51b3)
	INCROM $111b3, $111e9

Func_111e9: ; 111e9 (4:51e9)
	INCROM $111e9, $11238

Func_11238: ; 11238 (4:5238)
	INCROM $11238, $1124d

Func_1124d: ; 1124d (4:524d)
	INCROM $1124d, $11320

Func_11320: ; 11320 (4:5320)
	INCROM $11320, $11343

Func_11343: ; 11343 (4:5343)
	INCROM $11343, $11416

Func_11416: ; 11416 (4:5416)
	INCROM $11416, $11430

Func_11430: ; 11430 (4:5430)
	INCROM $11430, $1157c

; save the game
; if c is 0, save the player at their current position
; otherwise, save the player in Mason's lab
_SaveGame: ; 1157c (4:557c)
	ld a, c
	or a
	jr nz, .force_mason_lab
	farcall BackupPlayerPosition
	jr .save

.force_mason_lab
	ld a, $2
	ld [wTempPlayerXCoord], a
	ld a, $4
	ld [wTempPlayerYCoord], a
	ld a, SOUTH
	ld [wTempPlayerDirection], a
	ld a, MASON_LABORATORY
	ld [wTempMap], a
	ld a, OWMAP_MASON_LABORATORY
	ld [wOverworldMapSelection], a

.save
	call Func_11238
	ret

Func_115a3: ; 115a3 (4:55a3)
	INCROM $115a3, $1162a

INCLUDE "data/map_scripts.asm"

; loads a pointer into hl found on NPCHeaderPointers
GetNPCHeaderPointer: ; 1184a (4:584a)
	rlca
	add LOW(NPCHeaderPointers)
	ld l, a
	ld a, HIGH(NPCHeaderPointers)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

LoadNPCSpriteData: ; 11857 (4:5857)
	push hl
	push bc
	call GetNPCHeaderPointer
	ld a, [hli]
	ld [wTempNPC], a
	ld a, [hli]
	ld [wNPCSpriteID], a
	ld a, [hli]
	ld [wd3b1], a
	ld a, [hli]
	push af
	ld a, [hli]
	ld [wd3b2], a
	pop bc
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld a, b
	ld [wd3b1], a
.not_cgb
	pop bc
	pop hl
	ret

; Loads Name into wCurrentNPCNameTx and gets Script ptr into bc
GetNPCNameAndScript: ; 1187d (4:587d)
	push hl
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_SCRIPT_PTR
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld [wCurrentNPCNameTx], a
	ld a, [hli]
	ld [wCurrentNPCNameTx + 1], a
	pop hl
	ret

; Sets Dialog Box title to the name of the npc in 'a'
SetNPCDialogName: ; 11893 (4:5893)
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_NAME_TEXT
	add hl, bc
	ld a, [hli]
	ld [wCurrentNPCNameTx], a
	ld a, [hli]
	ld [wCurrentNPCNameTx + 1], a
	pop bc
	pop hl
	ret

; set the opponent name and portrait for the NPC id in register a
SetNPCOpponentNameAndPortrait: ; 118a7 (4:58a7)
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_NAME_TEXT
	add hl, bc
	ld a, [hli]
	ld [wOpponentName], a
	ld a, [hli]
	ld [wOpponentName + 1], a
	ld a, [hli]
	ld [wOpponentPortrait], a
	pop bc
	pop hl
	ret

; set the deck id and duel theme for the NPC id in register a
SetNPCDeckIDAndDuelTheme: ; 118bf (4:58bf)
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_DECK_ID
	add hl, bc
	ld a, [hli]
	ld [wNPCDuelDeckID], a
	ld a, [hli]
	ld [wDuelTheme], a
	pop bc
	pop hl
	ret

; set the start theme for the NPC id in register a
SetNPCMatchStartTheme: ; 118d3 (4:58d3)
	push hl
	push bc
	push af
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_MATCH_START_ID
	add hl, bc
	ld a, [hli]
	ld [wMatchStartTheme], a
	pop af
	cp NPC_RONALD1
	jr nz, .not_ronald_final_duel
	ld a, [wCurMap]
	cp POKEMON_DOME
	jr nz, .not_ronald_final_duel
	ld a, MUSIC_MATCH_START_3
	ld [wMatchStartTheme], a

.not_ronald_final_duel
	pop bc
	pop hl
	ret

INCLUDE "data/npcs.asm"

Func_11f4e: ; 11f4e (4:5f4e)
	INCROM $11f4e, $1217b

OverworldScriptTable: ; 1217b (4:617b)
	dw ScriptCommand_EndScript
	dw ScriptCommand_CloseAdvancedTextBox
	dw ScriptCommand_PrintNPCText
	dw ScriptCommand_PrintText
	dw ScriptCommand_AskQuestionJump
	dw ScriptCommand_StartDuel
	dw ScriptCommand_PrintVariableNPCText
	dw ScriptCommand_PrintVariableText
	dw ScriptCommand_PrintTextQuitFully
	dw ScriptCommand_UnloadActiveNPC
	dw ScriptCommand_MoveActiveNPCByDirection
	dw ScriptCommand_CloseTextBox
	dw ScriptCommand_GiveBoosterPacks
	dw ScriptCommand_JumpIfCardOwned
	dw ScriptCommand_JumpIfCardInCollection
	dw ScriptCommand_GiveCard
	dw ScriptCommand_TakeCard
	dw ScriptCommand_JumpIfAnyEnergyCardsInCollection
	dw ScriptCommand_RemoveAllEnergyCardsFromCollection
	dw ScriptCommand_JumpIfEnoughCardsOwned
	dw ScriptCommand_JumpBasedOnFightingClubPupilStatus
	dw ScriptCommand_SetActiveNPCDirection
	dw ScriptCommand_PickNextMan1RequestedCard
	dw ScriptCommand_LoadMan1RequestedCardIntoTxRamSlot
	dw ScriptCommand_JumpIfMan1RequestedCardOwned
	dw ScriptCommand_JumpIfMan1RequestedCardInCollection
	dw ScriptCommand_RemoveMan1RequestedCardFromCollection
	dw ScriptCommand_Jump
	dw ScriptCommand_TryGiveMedalPCPacks
	dw ScriptCommand_SetPlayerDirection
	dw ScriptCommand_MovePlayer
	dw ScriptCommand_ShowCardReceivedScreen
	dw ScriptCommand_SetDialogNPC
	dw ScriptCommand_SetNextNPCAndScript
	dw ScriptCommand_SetSpriteAttributes
	dw ScriptCommand_SetActiveNPCCoords
	dw ScriptCommand_DoFrames
	dw ScriptCommand_JumpIfActiveNPCCoordsMatch
	dw ScriptCommand_JumpIfPlayerCoordsMatch
	dw ScriptCommand_MoveActiveNPC
	dw ScriptCommand_GiveOneOfEachTrainerBooster
	dw ScriptCommand_JumpIfNPCLoaded
	dw ScriptCommand_ShowMedalReceivedScreen
	dw ScriptCommand_LoadCurrentMapNameIntoTxRamSlot
	dw ScriptCommand_LoadChallengeHallNPCIntoTxRamSlot
	dw ScriptCommand_StartChallengeHallDuel
	dw ScriptCommand_PrintTextForChallengeCup
	dw ScriptCommand_MoveChallengeHallNPC
	dw ScriptCommand_UnloadChallengeHallNPC
	dw ScriptCommand_SetChallengeHallNPCCoords
	dw ScriptCommand_PickChallengeHallOpponent
	dw ScriptCommand_OpenMenu
	dw ScriptCommand_PickChallengeCupPrizeCard
	dw ScriptCommand_QuitScriptFully
	dw ScriptCommand_ReplaceMapBlocks
	dw ScriptCommand_ChooseDeckToDuelAgainstMultichoice
	dw ScriptCommand_OpenDeckMachine
	dw ScriptCommand_ChooseStarterDeckMultichoice
	dw ScriptCommand_EnterMap
	dw ScriptCommand_MoveArbitraryNPC
	dw ScriptCommand_PickLegendaryCard
	dw ScriptCommand_FlashScreen
	dw ScriptCommand_SaveGame
	dw ScriptCommand_BattleCenter
	dw ScriptCommand_GiftCenter
	dw ScriptCommand_PlayCredits
	dw ScriptCommand_TryGivePCPack
	dw ScriptCommand_nop
	dw ScriptCommand_GiveStarterDeck
	dw ScriptCommand_WalkPlayerToMasonLaboratory
	dw ScriptCommand_OverrideSong
	dw ScriptCommand_SetDefaultSong
	dw ScriptCommand_PlaySong
	dw ScriptCommand_PlaySFX
	dw ScriptCommand_PauseSong
	dw ScriptCommand_ResumeSong
	dw ScriptCommand_PlayDefaultSong
	dw ScriptCommand_WaitForSongToFinish
	dw ScriptCommand_RecordMasterWin
	dw ScriptCommand_AskQuestionJumpDefaultYes
	dw ScriptCommand_ShowSamNormalMultichoice
	dw ScriptCommand_ShowSamRulesMultichoice
	dw ScriptCommand_ChallengeMachine
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_SetEventValue
	dw ScriptCommand_JumpIfEventZero
	dw ScriptCommand_JumpIfEventNonzero
	dw ScriptCommand_JumpIfEventEqual
	dw ScriptCommand_JumpIfEventNotEqual
	dw ScriptCommand_JumpIfEventGreaterOrEqual
	dw ScriptCommand_JumpIfEventLessThan
	dw ScriptCommand_MaxOutEventValue
	dw ScriptCommand_ZeroOutEventValue
	dw ScriptCommand_JumpIfEventTrue
	dw ScriptCommand_JumpIfEventFalse
	dw ScriptCommand_IncrementEventValue
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript


MultichoiceTextbox_ConfigTable_ChooseDeckToDuelAgainst: ; 1224b (4:624b)
	db $04, $00     ; x, y to start drawing box
	db $10, $08     ; width, height of box
	db $06, $02     ; x, y coordinate to start printing next text
	tx LightningAndFireDeckChoiceText     ; text id to print next
	db $06, $04     ; x, y coordinate to start printing next text
	tx WaterAndFightingDeckChoiceText     ; text id to print next
	db $06, $06     ; x, y coordinate to start printing next text
	tx GrassAndPsychicDeckChoiceText      ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $05, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $03          ; cursor max index
	db $0f          ; cursor image

	db $00, $00, $00 ; marker bytes -- end of config table

MultichoiceTextbox_ConfigTable_ChooseDeckStarterDeck: ; 12264 (4:6264)
	db $04, $00     ; x, y to start drawing box
	db $10, $08     ; width, height of box
	db $06, $02     ; x, y coordinate to start printing next text
	tx CharmanderAndFriendsDeckChoiceText     ; text id to print next
	db $06, $04     ; x, y coordinate to start printing next text
	tx SquirtleAndFriendsDeckChoiceText       ; text id to print next
	db $06, $06     ; x, y coordinate to start printing next text
	tx BulbasaurAndFriendsDeckChoiceText      ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $05, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $03          ; cursor max index
	db $0f          ; cursor image

	db $00, $00, $00 ; marker bytes -- end of config table

SamNormalMultichoice_ConfigurationTable: ; 1227d (4:627d)
	db $0A, $00     ; x, y to start drawing box
	db $0A, $0A     ;  width, height of box
	db $0C, $02     ; x, y coordinate to start printing next text
	tx Text03ff     ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $0b, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $04          ; cursor max index
	db $0f          ; cursor image

	db $00, $00, $00 ; marker bytes -- end of config table

SamRulesMultichoice_ConfigurationTable: ; 1228e (4:628e)
	db $06, $00     ; x, y to start drawing box
	db $0E, $12     ; width, height of box
	db $08, $02     ; x coordinate to start printing text
	tx Text0400     ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $07, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $08          ; cursor max index
	db $0f          ; cursor image

	db $00, $00, $00 ; marker bytes -- end of config table



Unknown_1229f: ; 1229f (4:629f)
	INCROM $1229f, $126d1

; usually, the game doesn't loop here at all, since as soon as a main menu option
; is selected, there is no need to come back to the menu.
; the only exception is after returning from Card Pop!
_GameLoop: ; 126d1 (4:66d1)
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	farcall Func_70018
	ld a, $ff
	ld [wd627], a
.main_menu_loop
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	farcall Func_c1f8
	farcall Func_1d078
	ld a, [wd628]
	ld hl, MainMenuFunctionTable
	call JumpToFunctionInTable
	jr c, .main_menu_loop ; return to main menu
	jr _GameLoop ; virtually restart game

; this is never reached
	scf
	ret

MainMenuFunctionTable: ; 126fc (4:66fc)
	dw MainMenu_CardPop
	dw MainMenu_ContinueFromDiary
	dw MainMenu_NewGame
	dw MainMenu_ContinueDuel

MainMenu_NewGame: ; 12704 (4:6704)
	farcall Func_c1b1
	call DisplayPlayerNamingScreen
	farcall Func_1996e
	call EnableSRAM
	ld a, [sAnimationsDisabled]
	ld [wAnimationsDisabled], a
	ld a, [s0a006]
	ld [wTextSpeed], a
	call DisableSRAM
	ld a, MUSIC_STOP
	call PlaySong
	farcall Func_70000
	ld a, MUSIC_OVERWORLD
	ld [wDefaultSong], a
	call PlayDefaultSong
	farcall Func_1d306
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

MainMenu_ContinueFromDiary: ; 12741 (4:6741)
	ld a, MUSIC_STOP
	call PlaySong
	call Func_11320
	jr nc, MainMenu_NewGame
	farcall Func_c1ed
	farcall Func_70000
	call EnableSRAM
	xor a
	ld [sba44], a
	call DisableSRAM
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

MainMenu_CardPop: ; 12768 (4:6768)
	ld a, MUSIC_CARD_POP
	call PlaySong
	bank1call Func_7571
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	ld a, MUSIC_STOP
	call PlaySong
	scf
	ret

MainMenu_ContinueDuel: ; 1277e (4:677e)
	ld a, MUSIC_STOP
	call PlaySong
	farcall Func_c9cb
	farcall $04, Func_3a40
	farcall Func_70000
	ld a, GAME_EVENT_CONTINUE_DUEL
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret
; 0x1279a

	INCROM $1279a, $12863

Func_12863: ; 12863 (4:6863)
	INCROM $12863, $12871

Func_12871: ; 12871 (4:6871)
	INCROM $12871, $1288c

Func_1288c: ; 1288c (4:688c)
	INCROM $1288c, $128a9

DisplayPlayerNamingScreen:: ; 128a9 (4:68a9)
	; clear the name buffer.
	ld hl, wNameBuffer ; c500: name buffer.
	ld bc, NAME_BUFFER_LENGTH
	ld a, TX_END
	call FillMemoryWithA

	; get player's name
	; from the user into hl.
	ld hl, wNameBuffer
	farcall InputPlayerName

	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	call DisableLCD
	ld hl, wNameBuffer
	; get the first byte of the name buffer.
	ld a, [hl]
	or a
	; check if anything typed.
	jr nz, .no_name
	ld hl, .data
.no_name
	; set the default name.
	ld de, sPlayerName
	ld bc, NAME_BUFFER_LENGTH
	call EnableSRAM
	call CopyDataHLtoDE_SaveRegisters
	; it seems for integrity checking.
	call UpdateRNGSources
	ld [sPlayerName+$e], a
	call UpdateRNGSources
	ld [sPlayerName+$f], a
	call DisableSRAM
	ret
.data
	; "MARK": default player name.
	; last two bytes are reserved for RNG.
	textfw3 "M", "A", "R", "K"
rept 6
	done
endr
	db $10, $12
Unknown_128fb: ; 128fb
	INCROM $128fb, $1296e

; disables all sprite animations
; and clears memory related to sprites
Func_1296e: ; 1296e (4:696e)
	push af
	ld a, [wd5d7]
	or a
	jr z, .asm_12977
	pop af
	ret

.asm_12977
	pop af
	push bc
	push hl
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
	lb bc, 0, SPRITE_ANIM_LENGTH

; disable all sprite animations
.loop_sprites
	xor a
	ld [hl], a ; set SPRITE_ANIM_ENABLED to 0
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp SPRITE_ANIM_BUFFER_CAPACITY
	jr nz, .loop_sprites

	call Func_12bf3
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop hl
	pop bc
	ret
; 0x1299f

; creates a new entry in SpriteAnimBuffer, else loads the sprite if need be
CreateSpriteAndAnimBufferEntry: ; 1299f (4:699f)
	push af
	ld a, [wd5d7]
	or a
	jr z, .continue
	pop af
	ret
.continue
	pop af
	push bc
	push hl
	call Func_12c05
	ld [wCurrSpriteTileID], a
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
	ld bc, SPRITE_ANIM_LENGTH
.findFirstEmptyAnimField
	ld a, [hl]
	or a
	jr z, .foundEmptyAnimField
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp $10
	jr nz, .findFirstEmptyAnimField
	debug_nop
	scf
	jr .quit
.foundEmptyAnimField
	ld a, $1
	ld [hl], a
	call FillNewSpriteAnimBufferEntry
	or a
.quit
	pop hl
	pop bc
	ret

FillNewSpriteAnimBufferEntry: ; 129d9 (4:69d9)
	push hl
	push bc
	push hl
	inc hl
	ld c, SPRITE_ANIM_LENGTH - 1
	xor a
.clearSpriteAnimBufferEntryLoop
	ld [hli], a
	dec c
	jr nz, .clearSpriteAnimBufferEntryLoop
	pop hl
	ld bc, SPRITE_ANIM_ID - 1
	add hl, bc
	ld a, [wCurrSpriteTileID]
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld bc, SPRITE_ANIM_COUNTER - SPRITE_ANIM_ID
	add hl, bc
	ld a, $ff
	ld [hl], a
	pop bc
	pop hl
	ret

Func_129fa: ; 129fa (4:69fa)
	ld a, [wWhichSprite]
	; fallthrough

Func_129fd: ; 129fd (4:69fd)
	push af
	ld a, [wd5d7]
	or a
	jr z, .asm_12a06
	pop af
	ret
.asm_12a06
	pop af
	push hl
	push bc
	ld c, SPRITE_ANIM_ENABLED
	call GetSpriteAnimBufferProperty_SpriteInA
	ld [hl], $00
	pop bc
	pop hl
	ret
; 0x12a13

GetSpriteAnimCounter: ; 12a13 (4:6a13)
	ld a, [wWhichSprite]
	push hl
	push bc
	ld c, SPRITE_ANIM_COUNTER
	call GetSpriteAnimBufferProperty_SpriteInA
	ld a, [hl]
	pop bc
	pop hl
	ret
; 0x12a21

HandleAllSpriteAnimations: ; 12a21 (4:6a21)
	push af
	ld a, [wd5d7] ; skip animating this frame if enabled
	or a
	jr z, .continue
	pop af
	ret
.continue
	pop af
	push af
	push bc
	push de
	push hl
	call ZeroObjectPositions
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
.spriteLoop
	ld a, [hl]
	or a
	jr z, .nextSprite ; skip if SPRITE_ANIM_ENABLED is 0
	call TryHandleSpriteAnimationFrame
	call LoadSpriteDataForAnimationFrame
.nextSprite
	ld bc, SPRITE_ANIM_LENGTH
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp SPRITE_ANIM_BUFFER_CAPACITY
	jr nz, .spriteLoop
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop hl
	pop de
	pop bc
	pop af
	ret

LoadSpriteDataForAnimationFrame: ; 12a5b (4:6a5b)
	push hl
	push bc
	inc hl
	ld a, [hli]
	ld [wCurrSpriteAttributes], a
	ld a, [hli]
	ld [wCurrSpriteXPos], a
	ld a, [hli]
	ld [wCurrSpriteYPos], a
	ld a, [hl]
	ld [wCurrSpriteTileID], a
	ld bc, SPRITE_ANIM_FLAGS - SPRITE_ANIM_TILE_ID
	add hl, bc
	ld a, [hl]
	and 1 << SPRITE_ANIM_FLAG_UNSKIPPABLE
	jr nz, .quit
	ld bc, SPRITE_ANIM_FRAME_BANK - SPRITE_ANIM_FLAGS
	add hl, bc
	ld a, [hli]
	ld [wd5d6], a
	or a
	jr z, .quit
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DrawSpriteAnimationFrame
.quit
	pop bc
	pop hl
	ret

; decrements the given sprite's movement counter (2x if SPRITE_ANIM_FLAG_SPEED is set)
; moves to the next animation frame if necessary
TryHandleSpriteAnimationFrame: ; 12a8b (4:6a8b)
	push hl
	push bc
	push de
	push hl
	ld d, 1
	ld bc, SPRITE_ANIM_FLAGS
	add hl, bc
	bit SPRITE_ANIM_FLAG_SPEED, [hl]
	jr z, .skipSpeedIncrease
	inc d
.skipSpeedIncrease
	pop hl
	ld bc, SPRITE_ANIM_COUNTER
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .exit
	sub d
	ld [hl], a
	jr z, .doNextAnimationFrame
	jr nc, .exit
.doNextAnimationFrame
	ld bc, SPRITE_ANIM_ENABLED - SPRITE_ANIM_COUNTER
	add hl, bc
	call HandleAnimationFrame
.exit
	pop de
	pop bc
	pop hl
	ret

StartNewSpriteAnimation: ; 12ab5 (4:6ab5)
	push hl
	push af
	ld c, SPRITE_ANIM_ID
	call GetSpriteAnimBufferProperty
	pop af
	cp [hl]
	pop hl
	ret z
	; fallthrough

StartSpriteAnimation: ; 12ac0 (4:6ac0)
	push hl
	call LoadSpriteAnimPointers
	call HandleAnimationFrame
	pop hl
	ret
; 0x12ac9

Func_12ac9: ; 12ac9 (4:6ac9)
	push bc
	ld b, a
	ld a, c
	or a
	ld a, b
	pop bc
	jr z, StartSpriteAnimation

	push hl
	push bc
	call LoadSpriteAnimPointers
	ld a, $ff
	call GetAnimFramePointerFromOffset
	pop bc
	ld a, c
	call SetAnimationCounterAndLoop
	pop hl
	ret
; 0x12ae2

; Given an animation ID, fills the current sprite's Animation Pointer and Frame Offset Pointer
; a - Animation ID for current sprite
LoadSpriteAnimPointers: ; 12ae2 (4:6ae2)
	push bc
	push af
	call GetFirstSpriteAnimBufferProperty
	pop af
	push hl
	ld bc, SPRITE_ANIM_ID
	add hl, bc
	ld [hli], a
	push hl
	ld l, 6 ; 4th entry in MapDataPointers
	farcall GetMapDataPointer
	farcall LoadGraphicsPointerFromHL
	pop hl ; hl is animation bank
	ld a, [wTempPointerBank]
	ld [hli], a
	ld a, [wTempPointer]
	ld [hli], a
	ld c, a
	ld a, [wTempPointer + 1]
	ld [hli], a
	ld b, a
	; offset pointer = pointer + $3
	ld a, $3
	add c
	ld [hli], a
	ld a, $0
	adc b
	ld [hli], a
	pop hl
	pop bc
	ret

; hl - beginning of current sprite_anim_buffer
; Handles a full animation frame using all values in animation structure
; (frame data offset, anim counter, X Mov, Y Mov)
HandleAnimationFrame: ; 12b13 (4:6b13)
	push bc
	push de
	push hl
.tryHandlingFrame
	push hl
	ld bc, SPRITE_ANIM_BANK
	add hl, bc
	ld a, [hli]
	ld [wTempPointerBank], a

	inc hl
	inc hl
	ld a, [hl] ; SPRITE_ANIM_FRAME_OFFSET_POINTER
	ld [wTempPointer], a
	add SPRITE_FRAME_OFFSET_SIZE ; advance FRAME_OFFSET_POINTER by 1 frame, 4 bytes
	ld [hli], a
	ld a, [hl]
	ld [wTempPointer + 1], a
	adc 0
	ld [hl], a

	ld de, wLoadedPalData
	ld bc, SPRITE_FRAME_OFFSET_SIZE
	call CopyBankedDataToDE
	pop hl ; beginning of current sprite_anim_buffer
	ld de, wLoadedPalData
	ld a, [de]
	call GetAnimFramePointerFromOffset
	inc de
	ld a, [de]
	call SetAnimationCounterAndLoop
	jr c, .tryHandlingFrame
	inc de
	ld bc, SPRITE_ANIM_COORD_X
	add hl, bc
	push hl
	ld bc, SPRITE_ANIM_FLAGS - SPRITE_ANIM_COORD_X
	add hl, bc
	ld b, [hl]
	pop hl
	ld a, [de]
	bit SPRITE_ANIM_FLAG_X_SUBTRACT, b
	jr z, .addXOffset
	cpl
	inc a
.addXOffset
	add [hl]
	ld [hli], a
	inc de
	ld a, [de]
	bit SPRITE_ANIM_FLAG_Y_SUBTRACT, b
	jr z, .addYOffset
	cpl
	inc a
.addYOffset
	add [hl]
	ld [hl], a
	pop hl
	pop de
	pop bc
	ret

; Calls GetAnimationFramePointer after setting up wTempPointerBank
; and wVRAMTileOffset
; a - frame offset from Animation Data
; hl - beginning of Sprite Anim Buffer
GetAnimFramePointerFromOffset: ; 12b6a (4:6b6a)
	ld [wVRAMTileOffset], a
	push hl
	push bc
	push de
	push hl
	ld bc, SPRITE_ANIM_BANK
	add hl, bc
	ld a, [hli]
	ld [wTempPointerBank], a
	ld a, [hli]
	ld [wTempPointer], a
	ld a, [hli]
	ld [wTempPointer + 1], a
	pop hl
	call GetAnimationFramePointer ; calls with the original map data script pointer/bank
	pop de
	pop bc
	pop hl
	ret

; Sets the animation counter for the current sprite. If the value is zero, loop the animation
; a - new animation counter
SetAnimationCounterAndLoop: ; 12b89 (4:6b89)
	push hl
	push bc
	ld bc, SPRITE_ANIM_COUNTER
	add hl, bc
	ld [hl], a
	or a
	jr nz, .exit
	ld bc, SPRITE_ANIM_POINTER - SPRITE_ANIM_COUNTER
	add hl, bc
	ld a, [hli]
	add $3 ; skip base bank/pointer at beginning of data structure
	ld c, a
	ld a, [hli]
	adc 0
	ld b, a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	scf
.exit
	pop bc
	pop hl
	ret

Func_12ba7: ; 12ba7 (4:6ba7)
	INCROM $12ba7, $12bcd

Func_12bcd: ; 12bcd (4:6bcd)
	INCROM $12bcd, $12bf3

; clears wSpriteVRAMBufferSize and wSpriteVRAMBuffer
Func_12bf3: ; 12bf3 (4:6bf3)
	push hl
	push bc
	xor a
	ld [wSpriteVRAMBufferSize], a
	ld c, $40
	ld hl, wSpriteVRAMBuffer
.asm_12bfe
	ld [hli], a
	dec c
	jr nz, .asm_12bfe
	pop bc
	pop hl
	ret
; 0x12c05

; gets some value based on the sprite in a and wSpriteVRAMBuffer
; loads the sprites data if it doesn't already exist
Func_12c05: ; 12c05 (4:6c05)
	push hl
	push bc
	push de
	ld b, a
	ld d, $0
	ld a, [wSpriteVRAMBufferSize]
	ld c, a
	ld hl, wSpriteVRAMBuffer
	or a
	jr z, .tryToAddSprite

.findSpriteMatchLoop
	inc hl
	ld a, [hl]
	cp b
	jr z, .foundSpriteMatch
	inc hl
	ld a, [hli]
	add [hl] ; add tile size to tile offset
	ld d, a
	inc hl
	dec c
	jr nz, .findSpriteMatchLoop

.tryToAddSprite
	ld a, [wSpriteVRAMBufferSize]
	cp $10
	jr nc, .quitFail
	inc a
	ld [wSpriteVRAMBufferSize], a ; increase number of entries by 1
	inc hl
	push hl
	ld a, b
	ld [hli], a ; store sprite index
	call Func_12c4f
	push af
	ld a, d
	ld [hli], a ; store tile offset
	pop af
	ld [hl], a ; store tile size
	pop hl

.foundSpriteMatch
	dec hl
	inc [hl] ; mark this entry as valid
	inc hl
	inc hl
	ld a, [hli]
	add [hl]
	cp $81
	jr nc, .quitFail ; exceeds total tile size
	ld a, d
	or a
	jr .quitSucceed

.quitFail
	debug_nop
	xor a
	scf
.quitSucceed
	pop de
	pop bc
	pop hl
	ret

; input:
; a = sprite index within the data map
; d = tile offset in VRAM
; output:
; a = number of tiles in sprite
Func_12c4f: ; 12c4f (4:6c4f)
	push af
	xor a
	ld [wd4cb], a
	ld a, d
	ld [wVRAMTileOffset], a
	pop af
	farcall Func_8025b
	ret

Func_12c5e: ; 12c5e (4:6c5e)
	INCROM $12c5e, $12c7f

; input:
; a = scene ID (SCENE_* constant)
; b = base X position of scene in tiles
; c = base Y position of scene in tiles
_LoadScene: ; 12c7f (4:6c7f)
	push hl
	push bc
	push de
	ld e, a
	ld a, [wCurTilemap]
	push af
	ld a, [wd291]
	push af
	ld a, e
	push bc
	push af
	ld a, b
	add a
	add a
	add a
	add $08
	ld [wSceneBaseX], a
	ld a, c
	add a
	add a
	add a
	add $10
	ld [wSceneBaseY], a
	pop af
	add a
	ld c, a
	ld b, 0
	ld hl, ScenePointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wSceneSGBPacketPtr], a
	ld a, [hli]
	ld [wSceneSGBPacketPtr + 1], a
	ld a, [hli]
	ld [wSceneSGBRoutinePtr], a
	ld a, [hli]
	ld [wSceneSGBRoutinePtr + 1], a
	call Func_12f45
	ld a, %11100100
	ld [wBGP], a
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, [hli]
	jr nz, .not_cgb_1
	ld a, [hl]
.not_cgb_1
	inc hl
	push af
	xor a
	ld [wd4ca], a
	ld a, [hli]
	ld [wd4cb], a
	ld [wd291], a
	pop af
	farcall Func_803c9
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, [hli]
	jr nz, .not_cgb_2
	ld a, [hl]
.not_cgb_2
	inc hl
	ld [wCurTilemap], a
	pop bc
	push bc
	farcall Func_8007e
	pop bc
	call Func_12f5b
	ld a, [hli]
	ld [wd4ca], a
	ld a, [hli]
	ld [wd4cb], a
	farcall LoadTilesetGfx
.asm_12d02
	ld a, [hli]
	or a
	jr z, .done
	ld [wSceneSprite], a
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, [hli]
	jr nz, .not_cgb_3
	ld a, [hl]
.not_cgb_3
	inc hl
	push af
	xor a
	ld [wd4ca], a
	ld a, [hli]
	ld [wd4cb], a
	pop af
	farcall LoadPaletteData
.asm_12d21
	ld a, [hli]
	or a
	jr z, .asm_12d02
	dec hl
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, [hli]
	jr nz, .not_cgb_4
	ld a, [hl]
.not_cgb_4
	inc hl
	ld [wSceneSpriteAnimation], a
	ld a, [wSceneSprite]
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wSceneSpriteIndex], a
	push hl
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld e, l
	ld d, h
	pop hl
	ld a, [wSceneBaseX]
	add [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [wSceneBaseY]
	add [hl]
	ld [de], a
	inc hl
	ld a, [wSceneSpriteAnimation]
	cp $ff
	jr z, .no_animation
	farcall StartSpriteAnimation
.no_animation
	jr .asm_12d21
.done
	pop af
	ld [wd291], a
	pop af
	ld [wCurTilemap], a
	pop de
	pop bc
	pop hl
	ret

ScenePointers: ; 12d6f (4:6d6f)
	dw Scene_TitleScreen
	dw Scene_ColosseumBooster
	dw Scene_EvolutionBooster
	dw Scene_MysteryBooster
	dw Scene_LaboratoryBooster
	dw Scene_CharizardIntro
	dw Scene_ScytherIntro
	dw Scene_AerodactylIntro
	dw Scene_GradientBlackAndRed
	dw Scene_GradientWhiteAndRed
	dw Scene_GradientBlackAndGreen
	dw Scene_GradientWhiteAndGreen
	dw Scene_ColorWheel
	dw Scene_ColorTest
	dw Scene_GameBoyLinkConnecting
	dw Scene_GameBoyLinkTransmitting
	dw Scene_GameBoyLinkNotConnected
	dw Scene_GameBoyPrinterTransmitting
	dw Scene_GameBoyPrinterNotConnected
	dw Scene_CardPop
	dw Scene_CardPopError
	dw Scene_JapaneseTitleScreen
	dw Scene_Nintendo
	dw Scene_Companies
	dw Scene_JapaneseTitleScreen2
	dw Scene_Copyright
	dw Scene_JapaneseTitleScreen2
	dw Scene_ColorPalette

; format:
; dw compressed sgb packet
; dw custom sgb packet loading routine
; db palette (non-cgb), palette (cgb), palette offset
; db tilemap (non-cgb), tilemap (cgb), vram tile offset, vram0 or vram1
; db sprite
;
; if sprite is non-zero:
; db palette (non-cgb), palette (cgb), palette offset
; db animation (non-cgb), animation (cgb), x offset, y offset
; dw 0-terminator

Scene_TitleScreen: ; 12da7 (4:6da7)
	dw SGBData_TitleScreen
	dw NULL
	db PALETTE_25, PALETTE_25, $00
	db TILEMAP_TITLE_SCREEN_5, TILEMAP_TITLE_SCREEN_6, $00, $00
	db $00

Scene_JapaneseTitleScreen: ; 12db3 (4:6db3)
	dw SGBData_TitleScreen
	dw NULL
	db PALETTE_25, PALETTE_25, $00
	db TILEMAP_TITLE_SCREEN_1, TILEMAP_TITLE_SCREEN_2, $80, $00
	db $00

Scene_ColosseumBooster: ; 12dbf (4:6dbf)
	dw SGBData_ColosseumBooster
	dw NULL
	db PALETTE_108, PALETTE_101, $01
	db TILEMAP_COLOSSEUM, TILEMAP_COLOSSEUM_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, $bd, $00, $00
	dw $00

Scene_EvolutionBooster: ; 12dd4 (4:6dd4)
	dw SGBData_EvolutionBooster
	dw NULL
	db PALETTE_108, PALETTE_102, $01
	db TILEMAP_EVOLUTION, TILEMAP_EVOLUTION_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, $bd, $00, $00
	dw $00

Scene_MysteryBooster: ; 12de9 (4:6de9)
	dw SGBData_MysteryBooster
	dw NULL
	db PALETTE_108, PALETTE_103, $01
	db TILEMAP_MYSTERY, TILEMAP_MYSTERY_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, $bd, $00, $00
	dw $00

Scene_LaboratoryBooster: ; 12dfe (4:6dfe)
	dw SGBData_LaboratoryBooster
	dw NULL
	db PALETTE_108, PALETTE_104, $01
	db TILEMAP_LABORATORY, TILEMAP_LABORATORY_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, $bd, $00, $00
	dw $00

Scene_CharizardIntro: ; 12e13 (4:6e13)
	dw SGBData_CharizardIntro
	dw NULL
	db PALETTE_108, PALETTE_105, $01
	db TILEMAP_CHARIZARD_INTRO, TILEMAP_CHARIZARD_INTRO_CGB, $80, $00
	db $00

Scene_ScytherIntro: ; 12e1f (4:6e1f)
	dw SGBData_ScytherIntro
	dw NULL
	db PALETTE_108, PALETTE_106, $01
	db TILEMAP_SCYTHER_INTRO, TILEMAP_SCYTHER_INTRO_CGB, $80, $00
	db $00

Scene_AerodactylIntro: ; 12e2b (4:6e2b)
	dw SGBData_AerodactylIntro
	dw NULL
	db PALETTE_108, PALETTE_107, $01
	db TILEMAP_AERODACTYL_INTRO, TILEMAP_AERODACTYL_INTRO_CGB, $80, $00
	db $00

Scene_GradientBlackAndRed: ; 12e37 (4:6e37)
	dw NULL
	dw NULL
	db PALETTE_94, PALETTE_94, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientWhiteAndRed: ; 12e43 (4:6e43)
	dw NULL
	dw NULL
	db PALETTE_95, PALETTE_95, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientBlackAndGreen: ; 12e4f (4:6e4f)
	dw NULL
	dw NULL
	db PALETTE_96, PALETTE_96, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientWhiteAndGreen: ; 12e5b (4:6e5b)
	dw NULL
	dw NULL
	db PALETTE_97, PALETTE_97, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_ColorWheel: ; 12e67 (4:6e67)
	dw NULL
	dw NULL
	db PALETTE_98, PALETTE_98, $00
	db TILEMAP_SOLID_TILES_2, TILEMAP_SOLID_TILES_2, $01, $00
	db $00

Scene_ColorTest: ; 12e73 (4:6e73)
	dw NULL
	dw NULL
	db PALETTE_99, PALETTE_99, $00
	db TILEMAP_SOLID_TILES_3, TILEMAP_SOLID_TILES_3, $01, $00
	db $00

Scene_ColorPalette: ; 12e7f (4:6e7f)
	dw NULL
	dw NULL
	db PALETTE_110, PALETTE_110, $00
	db TILEMAP_SOLID_TILES_4, TILEMAP_SOLID_TILES_4, $fc, $01
	db $00

Scene_GameBoyLinkConnecting: ; 12e8b (4:6e8b)
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_CARD_POP_2_UNKNOWN_2, TILEMAP_CARD_POP_2_UNKNOWN_1, $90, $00
	db $00

Scene_GameBoyLinkTransmitting: ; 12e97 (4:6e97)
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_CARD_POP_2_CGB, TILEMAP_CARD_POP_2, $90, $00
	db SPRITE_DUEL_52
	db PALETTE_114, PALETTE_114, $00
	db $b3, $b0, $50, $50
	dw $00

Scene_GameBoyLinkNotConnected: ; 12eac (4:6eac)
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_CARD_POP_2_CGB, TILEMAP_CARD_POP_2, $90, $00
	db SPRITE_DUEL_52
	db PALETTE_114, PALETTE_114, $00
	db $b4, $b1, $50, $50
	dw $00

Scene_GameBoyPrinterTransmitting: ; 12ec1 (4:6ec1)
	dw SGBData_GameBoyPrinter
	dw Func_12f8c
	db PALETTE_112, PALETTE_112, $00
	db TILEMAP_CARD_POP_3_CGB, TILEMAP_CARD_POP_3, $90, $00
	db SPRITE_DUEL_53
	db PALETTE_115, PALETTE_115, $00
	db $b7, $b5, $50, $30
	dw $00

Scene_GameBoyPrinterNotConnected: ; 12ed6 (4:6ed6)
	dw SGBData_GameBoyPrinter
	dw Func_12f8c
	db PALETTE_112, PALETTE_112, $00
	db TILEMAP_CARD_POP_3_CGB, TILEMAP_CARD_POP_3, $90, $00
	db SPRITE_DUEL_53
	db PALETTE_115, PALETTE_115, $00
	db $b8, $b6, $50, $30
	dw $00

Scene_CardPop: ; 12eeb (4:6eeb)
	dw SGBData_CardPop
	dw Func_12fa9
	db PALETTE_113, PALETTE_113, $00
	db TILEMAP_CARD_POP_1_CGB, TILEMAP_CARD_POP_1, $80, $00
	db SPRITE_DUEL_54
	db PALETTE_116, PALETTE_116, $00
	db $bb, $b9, $50, $40
	dw $00

Scene_CardPopError: ; 12f00 (4:6f00)
	dw SGBData_CardPop
	dw Func_12fa9
	db PALETTE_113, PALETTE_113, $00
	db TILEMAP_CARD_POP_1_CGB, TILEMAP_CARD_POP_1, $80, $00
	db SPRITE_DUEL_54
	db PALETTE_116, PALETTE_116, $00
	db $bc, $ba, $50, $40
	dw $00

Scene_Nintendo: ; 12f15 (4:6f15)
	dw NULL
	dw NULL
	db PALETTE_27, PALETTE_27, $00
	db TILEMAP_NINTENDO, TILEMAP_NINTENDO, $00, $00
	db $00

Scene_Companies: ; 12f21 (4:6f21)
	dw NULL
	dw NULL
	db PALETTE_28, PALETTE_28, $00
	db TILEMAP_COMPANIES, TILEMAP_COMPANIES, $00, $00
	db $00

Scene_Copyright: ; 12f2d (4:6f2d)
	dw NULL
	dw NULL
	db PALETTE_26, PALETTE_26, $00
	db TILEMAP_COPYRIGHT, TILEMAP_COPYRIGHT_CGB, $00, $00
	db $00

Scene_JapaneseTitleScreen2: ; 12f39 (4:6f39)
	dw NULL
	dw NULL
	db PALETTE_109, PALETTE_100, $00
	db TILEMAP_TITLE_SCREEN_3, TILEMAP_TITLE_SCREEN_4, $01, $00
	db $00

Func_12f45: ; 12f45 (4:6f45)
	ld a, [wConsole]
	cp CONSOLE_SGB
	ret nz
	push hl
	ld hl, wSceneSGBPacketPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .skip
	farcall Func_703cb
.skip
	pop hl
	ret

Func_12f5b: ; 12f5b (4:6f5b)
	ld a, [wConsole]
	cp CONSOLE_SGB
	ret nz
	push hl
	push bc
	push de
	ld hl, wSceneSGBPacketPtr
	ld a, [hli]
	or [hl]
	jr z, .asm_12f88
	ld hl, wSceneSGBRoutinePtr + 1
	ld a, [hld]
	or [hl]
	jr z, .asm_12f7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CallHL2
	jr .asm_12f88
.asm_12f7a
	ld l, $0a
	ld a, [wBGMapWidth]
	ld d, a
	ld a, [wBGMapHeight]
	ld e, a
	farcall Func_70498
.asm_12f88
	pop de
	pop bc
	pop hl
	ret

Func_12f8c: ; 12f8c (4:6f8c)
	push hl
	push bc
	push de
	ld hl, SGCPacket_GameBoyPrinter
	call SendSGB
	pop de
	pop bc
	pop hl
	ret

SGCPacket_GameBoyPrinter: ; 12f99 (4:6f99)
	INCROM $12f99, $12fa9

Func_12fa9: ; 12fa9 (4:6fa9)
	push hl
	push bc
	push de
	ld hl, SGCPacket_CardPop
	call SendSGB
	pop de
	pop bc
	pop hl
	ret

SGCPacket_CardPop: ; 12fb6 (4:6fb6)
	INCROM $12fb6, $12fc6

Func_12fc6: ; 12fc6 (4:6fc6)
	INCROM $12fc6, $130ca

LoadBoosterGfx: ; 130ca (4:70ca)
	push hl
	push bc
	push de
	ld e, a
	ld a, [wCurTilemap]
	push af
	push bc
	ld a, e
	call _LoadScene
	call FlushAllPalettes
	call SetBoosterLogoOAM
	pop bc
	pop af
	ld [wCurTilemap], a
	pop de
	pop bc
	pop hl
	ret

SetBoosterLogoOAM: ; 130e6 (4:70e6)
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret nz
	push hl
	push bc
	push de
	push bc
	xor a
	ld [wd4cb], a
	ld [wd4ca], a
	ld a, SPRITE_BOOSTER_PACK_OAM
	farcall Func_8025b
	pop bc
	call ZeroObjectPositions
	ld hl, BoosterLogoOAM
	ld c, [hl]
	inc hl
.oam_loop
	push bc
	ldh a, [hSCX]
	ld d, a
	ldh a, [hSCY]
	ld e, a
	ld a, [wSceneBaseY]
	sub e
	add [hl]
	ld e, a
	inc hl
	ld a, [wSceneBaseX]
	sub d
	add [hl]
	ld d, a
	inc hl
	ld a, [wd61f]
	add [hl]
	ld c, a
	inc hl
	ld b, [hl]
	inc hl
	call SetOneObjectAttributes
	pop bc
	dec c
	jr nz, .oam_loop
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop de
	pop bc
	pop hl
	ret

BoosterLogoOAM: ; 13132 (4:7132)
	db $20
	db $00, $00, $00, $00
	db $00, $08, $01, $00
	db $00, $10, $02, $00
	db $00, $18, $03, $00
	db $00, $20, $04, $00
	db $00, $28, $05, $00
	db $00, $30, $06, $00
	db $00, $38, $07, $00
	db $08, $00, $10, $00
	db $08, $08, $11, $00
	db $08, $10, $12, $00
	db $08, $18, $13, $00
	db $08, $20, $14, $00
	db $08, $28, $15, $00
	db $08, $30, $16, $00
	db $08, $38, $17, $00
	db $10, $00, $08, $00
	db $10, $08, $09, $00
	db $10, $10, $0A, $00
	db $10, $18, $0B, $00
	db $10, $20, $0C, $00
	db $10, $28, $0D, $00
	db $10, $30, $0E, $00
	db $10, $38, $0F, $00
	db $18, $00, $18, $00
	db $18, $08, $19, $00
	db $18, $10, $1A, $00
	db $18, $18, $1B, $00
	db $18, $20, $1C, $00
	db $18, $28, $1D, $00
	db $18, $30, $1E, $00
	db $18, $38, $1F, $00

Func_131b3: ; 131b3 (4:71b3)
	INCROM $131b3, $131d3

Func_131d3: ; 131d3 (4:71d3)
	INCROM $131d3, $1344d

Func_1344d: ; 1344d (4:744d)
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ldtx hl, DefeatedFiveOpponentsText
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ret
; 0x13462

	INCROM $13462, $13485

Func_13485: ; 13485 (4:7485)
	call EnableSRAM
	ld a, [sba68]
	or a
	ret z
	ld a, [sba56]
	ld [wTxRam3], a
	ld a, [sba57]
	ld [wTxRam3 + 1], a
	call DisableSRAM
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ldtx hl, ConsecutiveWinRecordIncreasedText
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ret
; 0x134b1

	INCROM $134b1, $1372f

INCLUDE "data/npc_map_data.asm"
INCLUDE "data/map_objects.asm"

rept $119
	db $ff
endr
