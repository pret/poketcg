INCBIN "baserom.gbc",$1c000,$1c056 - $1c000

Func_1c056: ; 1c056 (7:4056)
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0005
	ld a, [wPlayerXCoord]
	ld d, a
	ld a, [wPlayerYCoord]
	ld e, a
.asm_1c072
	ld a, [hli]
	or [hl]
	jr z, .asm_1c095
	ld a, [hld]
	cp e
	jr nz, .asm_1c07e
	ld a, [hl]
	cp d
	jr z, .asm_1c081
.asm_1c07e
	add hl, bc
	jr .asm_1c072
.asm_1c081
	inc hl
	inc hl
	ld a, [hli]
	ld [$d0bb], a
	ld a, [hli]
	ld [$d0bc], a
	ld a, [hli]
	ld [$d0bd], a
	ld a, [$d334]
	ld [$d0be], a
.asm_1c095
	pop de
	pop bc
	pop hl
	ret

WarpDataPointers: ; 1c099 (7:4099)
	dw $0000
	dw MasonLaboratoryWarpData
	dw DeckMachineRoomWarpData
	dw IshiharasHouseWarpData
	dw FightingClubEntranceWarpData
	dw FightingClubLobbyWarpData
	dw FightingClubWarpData
	dw RockClubEntranceWarpData
	dw RockClubLobbyWarpData
	dw RockClubWarpData
	dw WaterClubEntranceWarpData
	dw WaterClubLobbyWarpData
	dw WaterClubWarpData
	dw LightningClubEntranceWarpData
	dw LightningClubLobbyWarpData
	dw LightningClubWarpData
	dw GrassClubEntranceWarpData
	dw GrassClubLobbyWarpData
	dw GrassClubWarpData
	dw PsychicClubEntranceWarpData
	dw PsychicClubLobbyWarpData
	dw PsychicClubWarpData
	dw ScienceClubEntranceWarpData
	dw ScienceClubLobbyWarpData
	dw ScienceClubWarpData
	dw FireClubEntranceWarpData
	dw FireClubLobbyWarpData
	dw FireClubWarpData
	dw ChallengeHallEntranceWarpData
	dw ChallengeHallLobbyWarpData
	dw ChallengeHallWarpData
	dw PokemonDomeEntranceWarpData
	dw PokemonDomeWarpData
	dw HallOfHonorWarpData

; each warp is five bytes long
; coordinates are measured in tiles
; 1: x coordinate of current map
; 2: y coordinate of current map
; 3: id of connected map
; 4: x coordinate of connected map
; 5: y coordinate of connected map
; double null terminated
MasonLaboratoryWarpData: ; 1c0dd (7:40dd)
	db $0E,$1C,OVERWORLD_MAP,    $00,$00
	db $10,$1C,OVERWORLD_MAP,    $00,$00
	db $1A,$0A,DECK_MACHINE_ROOM,$02,$0A
	db $1A,$0C,DECK_MACHINE_ROOM,$02,$0C
	db $00,$00

DeckMachineRoomWarpData: ; 1c0f3 (7:40f3)
	db $00,$0A,MASON_LABORATORY,$18,$0A
	db $00,$0C,MASON_LABORATORY,$18,$0C
	db $00,$00

IshiharasHouseWarpData: ; 1c0ff (7:40ff)
	db $08,$16,OVERWORLD_MAP,$00,$00
	db $0A,$16,OVERWORLD_MAP,$00,$00
	db $00,$00

FightingClubEntranceWarpData: ; 1c10b (7:410b)
	db $08,$10,OVERWORLD_MAP,      $00,$00
	db $0A,$10,OVERWORLD_MAP,      $00,$00
	db $00,$06,FIGHTING_CLUB_LOBBY,$18,$0A
	db $00,$08,FIGHTING_CLUB_LOBBY,$18,$0C
	db $08,$00,FIGHTING_CLUB,      $0A,$0E
	db $0A,$00,FIGHTING_CLUB,      $0C,$0E
	db $00,$00

FightingClubLobbyWarpData: ; 1c12b (7:412b)
	db $1A,$0A,FIGHTING_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,FIGHTING_CLUB_ENTRANCE,$02,$08
	db $00,$00

FightingClubWarpData: ; 1c137 (7:4137)
	db $0A,$10,FIGHTING_CLUB_ENTRANCE,$08,$02
	db $0C,$10,FIGHTING_CLUB_ENTRANCE,$0A,$02
	db $00,$00

RockClubEntranceWarpData: ; 1c143 (7:4143)
	db $08,$10,OVERWORLD_MAP,  $00,$00
	db $0A,$10,OVERWORLD_MAP,  $00,$00
	db $00,$06,ROCK_CLUB_LOBBY,$18,$0A
	db $00,$08,ROCK_CLUB_LOBBY,$18,$0C
	db $08,$00,ROCK_CLUB,      $0C,$1A
	db $0A,$00,ROCK_CLUB,      $0E,$1A
	db $00,$00

RockClubLobbyWarpData: ; 1c163 (7:4163)
	db $1A,$0A,ROCK_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,ROCK_CLUB_ENTRANCE,$02,$08
	db $00,$00

RockClubWarpData: ; 1c16f (7:416f)
	db $0C,$1C,ROCK_CLUB_ENTRANCE,$08,$02
	db $0E,$1C,ROCK_CLUB_ENTRANCE,$0A,$02
	db $00,$00

WaterClubEntranceWarpData: ; 1c17b (7:417b)
	db $08,$10,OVERWORLD_MAP,   $00,$00
	db $0A,$10,OVERWORLD_MAP,   $00,$00
	db $00,$06,WATER_CLUB_LOBBY,$18,$0A
	db $00,$08,WATER_CLUB_LOBBY,$18,$0C
	db $08,$00,WATER_CLUB,      $0C,$1C
	db $0A,$00,WATER_CLUB,      $0E,$1C
	db $00,$00

WaterClubLobbyWarpData: ; 1c19b (7:419b)
	db $1A,$0A,WATER_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,WATER_CLUB_ENTRANCE,$02,$08
	db $00,$00

WaterClubWarpData: ; 1c1a7 (7:41a7)
	db $0C,$1E,WATER_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,WATER_CLUB_ENTRANCE,$0A,$02
	db $00,$00

LightningClubEntranceWarpData: ; 1c1b3 (7:41b3)
	db $08,$10,OVERWORLD_MAP,       $00,$00
	db $0A,$10,OVERWORLD_MAP,       $00,$00
	db $00,$06,LIGHTNING_CLUB_LOBBY,$18,$0A
	db $00,$08,LIGHTNING_CLUB_LOBBY,$18,$0C
	db $08,$00,LIGHTNING_CLUB,      $0C,$1C
	db $0A,$00,LIGHTNING_CLUB,      $0E,$1C
	db $00,$00

LightningClubLobbyWarpData: ; 1c1d3 (7:41d3)
	db $1A,$0A,LIGHTNING_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,LIGHTNING_CLUB_ENTRANCE,$02,$08
	db $00,$00

LightningClubWarpData: ; 1c1df (7:41df)
	db $0C,$1E,LIGHTNING_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,LIGHTNING_CLUB_ENTRANCE,$0A,$02
	db $00,$00

GrassClubEntranceWarpData: ; 1c1eb (7:41eb)
	db $08,$10,OVERWORLD_MAP,   $00,$00
	db $0A,$10,OVERWORLD_MAP,   $00,$00
	db $00,$06,GRASS_CLUB_LOBBY,$18,$0A
	db $00,$08,GRASS_CLUB_LOBBY,$18,$0C
	db $08,$00,GRASS_CLUB,      $0C,$1C
	db $0A,$00,GRASS_CLUB,      $0E,$1C
	db $00,$00

GrassClubLobbyWarpData: ; 1c20b (7:420b)
	db $1A,$0A,GRASS_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,GRASS_CLUB_ENTRANCE,$02,$08
	db $00,$00

GrassClubWarpData: ; 1c217 (7:4217)
	db $0C,$1E,GRASS_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,GRASS_CLUB_ENTRANCE,$0A,$02
	db $00,$00

PsychicClubEntranceWarpData: ; 1c223 (7:4223)
	db $08,$10,OVERWORLD_MAP,     $00,$00
	db $0A,$10,OVERWORLD_MAP,     $00,$00
	db $00,$06,PSYCHIC_CLUB_LOBBY,$18,$0A
	db $00,$08,PSYCHIC_CLUB_LOBBY,$18,$0C
	db $08,$00,PSYCHIC_CLUB,      $0C,$18
	db $0A,$00,PSYCHIC_CLUB,      $0E,$18
	db $00,$00

PsychicClubLobbyWarpData: ; 1c243 (7:4243)
	db $1A,$0A,PSYCHIC_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,PSYCHIC_CLUB_ENTRANCE,$02,$08
	db $00,$00

PsychicClubWarpData: ; 1c24f (7:424f)
	db $0C,$1A,PSYCHIC_CLUB_ENTRANCE,$08,$02
	db $0E,$1A,PSYCHIC_CLUB_ENTRANCE,$0A,$02
	db $00,$00

ScienceClubEntranceWarpData: ; 1c25b (7:425b)
	db $08,$10,OVERWORLD_MAP,     $00,$00
	db $0A,$10,OVERWORLD_MAP,     $00,$00
	db $00,$06,SCIENCE_CLUB_LOBBY,$18,$0A
	db $00,$08,SCIENCE_CLUB_LOBBY,$18,$0C
	db $08,$00,SCIENCE_CLUB,      $0C,$1C
	db $0A,$00,SCIENCE_CLUB,      $0E,$1C
	db $00,$00

ScienceClubLobbyWarpData: ; 1c27b (7:427b)
	db $1A,$0A,SCIENCE_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,SCIENCE_CLUB_ENTRANCE,$02,$08
	db $00,$00

ScienceClubWarpData: ; 1c287 (7:4287)
	db $0C,$1E,SCIENCE_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,SCIENCE_CLUB_ENTRANCE,$0A,$02
	db $00,$00

FireClubEntranceWarpData: ; 1c293 (7:4293)
	db $08,$10,OVERWORLD_MAP,  $00,$00
	db $0A,$10,OVERWORLD_MAP,  $00,$00
	db $00,$06,FIRE_CLUB_LOBBY,$18,$0A
	db $00,$08,FIRE_CLUB_LOBBY,$18,$0C
	db $08,$00,FIRE_CLUB,      $0C,$1C
	db $0A,$00,FIRE_CLUB,      $0E,$1C
	db $00,$00

FireClubLobbyWarpData: ; 1c2b3 (7:42b3)
	db $1A,$0A,FIRE_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,FIRE_CLUB_ENTRANCE,$02,$08
	db $00,$00

FireClubWarpData: ; 1c2bf (7:42bf)
	db $0C,$1E,FIRE_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,FIRE_CLUB_ENTRANCE,$0A,$02
	db $00,$00

ChallengeHallEntranceWarpData: ; 1c2cb (7:42cb)
	db $08,$10,OVERWORLD_MAP,       $00,$00
	db $0A,$10,OVERWORLD_MAP,       $00,$00
	db $00,$06,CHALLENGE_HALL_LOBBY,$18,$0A
	db $00,$08,CHALLENGE_HALL_LOBBY,$18,$0C
	db $08,$00,CHALLENGE_HALL,      $0E,$1C
	db $0A,$00,CHALLENGE_HALL,      $10,$1C
	db $00,$00

ChallengeHallLobbyWarpData: ; 1c2eb (7:42eb)
	db $1A,$0A,CHALLENGE_HALL_ENTRANCE,$02,$06
	db $1A,$0C,CHALLENGE_HALL_ENTRANCE,$02,$08
	db $00,$00

ChallengeHallWarpData: ; 1c2f7 (7:42f7)
	db $0E,$1E,CHALLENGE_HALL_ENTRANCE,$08,$02
	db $10,$1E,CHALLENGE_HALL_ENTRANCE,$0A,$02
	db $00,$00

PokemonDomeEntranceWarpData: ; 1c303 (7:4303)
	db $0E,$10,OVERWORLD_MAP,$00,$00
	db $10,$10,OVERWORLD_MAP,$00,$00
	db $16,$00,POKEMON_DOME, $0E,$1C
	db $18,$00,POKEMON_DOME, $10,$1C
	db $00,$00

PokemonDomeWarpData: ; 1c319 (7:4319)
	db $0E,$1E,POKEMON_DOME_ENTRANCE,$16,$02
	db $10,$1E,POKEMON_DOME_ENTRANCE,$18,$02
	db $0E,$00,HALL_OF_HONOR,        $0A,$16
	db $10,$00,HALL_OF_HONOR,        $0C,$16
	db $00,$00

HallOfHonorWarpData: ; 1c32f (7:432f)
	db $0A,$18,POKEMON_DOME,$0E,$02
	db $0C,$18,POKEMON_DOME,$10,$02
	db $00,$00

Func_1c33b: ; 1c33b (7:433b)
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	add a
	add c
	ld c, a
	ld b, $0
	ld hl, MapSongs
	add hl, bc
	ld a, [hli]
	ld [$d131], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld [$d28f], a
	ld a, [hli]
	ld [$d132], a
	ld a, [hli]
	ld [$d290], a
	ld a, [hli]
	ld [$d111], a
	ld a, [$cab4]
	cp $2
	jr nz, .asm_1c370
	ld a, c
	or a
	jr z, .asm_1c370
	ld [$d131], a
.asm_1c370
	pop de
	pop bc
	pop hl
	ret

; todo: figure out the rest of the data for each map
; related to the table at 20:4e5d
MapSongs: ; 1c374 (7:4374)
	db $00,$01,$00,$01,$01,MUSIC_OVERWORLD   ; OVERWORLD_MAP
	db $02,$03,$00,$02,$02,MUSIC_OVERWORLD   ; MASON_LABORATORY
	db $06,$07,$00,$02,$02,MUSIC_OVERWORLD   ; DECK_MACHINE_ROOM
	db $0A,$0B,$00,$03,$03,MUSIC_OVERWORLD   ; ISHIHARAS_HOUSE
	db $0C,$0D,$00,$03,$04,MUSIC_OVERWORLD   ; FIGHTING_CLUB_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; FIGHTING_CLUB_LOBBY
	db $20,$21,$00,$04,$0D,MUSIC_CLUB3       ; FIGHTING_CLUB
	db $0E,$0F,$00,$03,$05,MUSIC_OVERWORLD   ; ROCK_CLUB_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; ROCK_CLUB_LOBBY
	db $22,$23,$00,$04,$0E,MUSIC_CLUB2       ; ROCK_CLUB
	db $10,$11,$00,$03,$06,MUSIC_OVERWORLD   ; WATER_CLUB_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; WATER_CLUB_LOBBY
	db $24,$25,$00,$02,$0F,MUSIC_CLUB2       ; WATER_CLUB
	db $12,$13,$00,$03,$07,MUSIC_OVERWORLD   ; LIGHTNING_CLUB_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; LIGHTNING_CLUB_LOBBY
	db $26,$27,$00,$05,$10,MUSIC_CLUB1       ; LIGHTNING_CLUB
	db $14,$15,$00,$03,$08,MUSIC_OVERWORLD   ; GRASS_CLUB_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; GRASS_CLUB_LOBBY
	db $28,$29,$00,$06,$11,MUSIC_CLUB1       ; GRASS_CLUB
	db $16,$17,$00,$03,$09,MUSIC_OVERWORLD   ; PSYCHIC_CLUB_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; PSYCHIC_CLUB_LOBBY
	db $2A,$2B,$00,$07,$12,MUSIC_CLUB2       ; PSYCHIC_CLUB
	db $18,$19,$00,$03,$0A,MUSIC_OVERWORLD   ; SCIENCE_CLUB_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; SCIENCE_CLUB_LOBBY
	db $2C,$2D,$00,$06,$13,MUSIC_CLUB3       ; SCIENCE_CLUB
	db $1A,$1B,$00,$03,$0B,MUSIC_OVERWORLD   ; FIRE_CLUB_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; FIRE_CLUB_LOBBY
	db $2E,$2F,$00,$08,$14,MUSIC_CLUB3       ; FIRE_CLUB
	db $1C,$1D,$00,$03,$04,MUSIC_OVERWORLD   ; CHALLENGE_HALL_ENTRANCE
	db $1E,$1F,$00,$03,$0C,MUSIC_OVERWORLD   ; CHALLENGE_HALL_LOBBY
	db $30,$31,$00,$09,$15,MUSIC_OVERWORLD   ; CHALLENGE_HALL
	db $32,$33,$00,$0A,$16,MUSIC_OVERWORLD   ; POKEMON_DOME_ENTRANCE
	db $36,$37,$00,$0A,$17,MUSIC_POKEMONDOME ; POKEMON_DOME
	db $3A,$3B,$00,$0A,$18,MUSIC_HALLOFHONOR ; HALL_OF_HONOR

Func_1c440: ; 1c440 (7:4440)
INCBIN "baserom.gbc",$1c440,$1c485 - $1c440

Func_1c485: ; 1c485 (7:4485)
INCBIN "baserom.gbc",$1c485,$1c58e - $1c485

Func_1c58e: ; 1c58e (7:458e)
INCBIN "baserom.gbc",$1c58e,$1c5e9 - $1c58e

Func_1c5e9: ; 1c5e9 (7:45e9)
INCBIN "baserom.gbc",$1c5e9,$1c610 - $1c5e9

Func_1c610: ; 1c610 (7:4610)
INCBIN "baserom.gbc",$1c610,$1c6f8 - $1c610

Func_1c6f8: ; 1c6f8 (7:46f8)
INCBIN "baserom.gbc",$1c6f8,$1c72e - $1c6f8

Func_1c72e: ; 1c72e (7:472e)
INCBIN "baserom.gbc",$1c72e,$1c768 - $1c72e

Func_1c768: ; 1c768 (7:4768)
INCBIN "baserom.gbc",$1c768,$1c82e - $1c768

Func_1c82e: ; 1c82e (7:482e)
INCBIN "baserom.gbc",$1c82e,$1d078 - $1c82e

Func_1d078: ; 1d078 (7:5078)
INCBIN "baserom.gbc",$1d078,$1d306 - $1d078

Func_1d306: ; 1d306 (7:5306)
INCBIN "baserom.gbc",$1d306,$1d6ad - $1d306

Func_1d6ad: ; 1d6ad (7:56ad)
INCBIN "baserom.gbc",$1d6ad,$20000 - $1d6ad