; clears wOWMapEvents
ClearOWMapEvents:
	push hl
	push bc
	ld c, NUM_MAP_EVENTS
	ld hl, wOWMapEvents
	xor a
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	pop hl
	ret

; input:
; - a = MAP_EVENT_* constant
ApplyOWMapEventChangeIfEventSet:
	push hl
	push bc
	push af
	ld c, a
	ld a, TRUE
	ld [wWriteBGMapToSRAM], a
	ld b, $0
	ld hl, wOWMapEvents
	add hl, bc
	ld a, [hl]
	or a
	jr z, .false
	ld a, c
	call SetOWMapEvent_SRAMOrVRAM
.false
	pop af
	pop bc
	pop hl
	ret

; input:
; - a = MAP_EVENT_* constant
SetOWMapEvent:
	push af
	xor a
	ld [wWriteBGMapToSRAM], a
	pop af
;	fallthrough

; set OWMapEvent given in a to TRUE
; and applies the corresponding map changes to that event
; (door permissions, and which tiles to overwrite)
; input:
; - a = MAP_EVENT_* constant
SetOWMapEvent_SRAMOrVRAM:
	push hl
	push bc
	push de
	ld c, a
	ld a, [wCurTilemap]
	push af
	ld a, [wBGMapBank]
	push af
	ld a, [wBGMapWidth]
	push af
	ld a, [wBGMapHeight]
	push af
	ld a, [wBGMapPermissionDataPtr]
	push af
	ld a, [wBGMapPermissionDataPtr + 1]
	push af

	ld b, $0
	ld hl, wOWMapEvents
	add hl, bc
	ld a, TRUE
	ld [hl], a

	ld a, c
	add a
	ld c, a
	ld b, $0
	ld hl, .TilemapPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl

	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .got_tilemap
	inc hl
.got_tilemap
	ld a, [hl]
	ld [wCurTilemap], a

	push bc
	farcall LoadTilemap ; unnecessary farcall
	pop bc
	srl b
	ld a, c
	rrca
	and $0f
	swap a ; * $10
	add b
	ld c, a
	ld b, $0
	ld hl, wPermissionMap
	add hl, bc
	farcall DecompressPermissionMap
	pop af
	ld [wBGMapPermissionDataPtr + 1], a
	pop af
	ld [wBGMapPermissionDataPtr], a
	pop af
	ld [wBGMapHeight], a
	pop af
	ld [wBGMapWidth], a
	pop af
	ld [wBGMapBank], a
	pop af
	ld [wCurTilemap], a
	pop de
	pop bc
	pop hl
	ret

.TilemapPointers
	table_width 2
	dw .PokemonDomeDoor      ; MAP_EVENT_POKEMON_DOME_DOOR
	dw .HallOfHonorDoor      ; MAP_EVENT_HALL_OF_HONOR_DOOR
	dw .FightingDeckMachine  ; MAP_EVENT_FIGHTING_DECK_MACHINE
	dw .RockDeckMachine      ; MAP_EVENT_ROCK_DECK_MACHINE
	dw .WaterDeckMachine     ; MAP_EVENT_WATER_DECK_MACHINE
	dw .LightningDeckMachine ; MAP_EVENT_LIGHTNING_DECK_MACHINE
	dw .GrassDeckMachine     ; MAP_EVENT_GRASS_DECK_MACHINE
	dw .PsychicDeckMachine   ; MAP_EVENT_PSYCHIC_DECK_MACHINE
	dw .ScienceDeckMachine   ; MAP_EVENT_SCIENCE_DECK_MACHINE
	dw .FireDeckMachine      ; MAP_EVENT_FIRE_DECK_MACHINE
	dw .ChallengeMachine     ; MAP_EVENT_CHALLENGE_MACHINE
	assert_table_length NUM_MAP_EVENTS

; x coordinate, y coordinate, non-cgb tilemap, cgb tilemap
.PokemonDomeDoor
	db $16, $00, TILEMAP_POKEMON_DOME_DOOR_MAP_EVENT, TILEMAP_POKEMON_DOME_DOOR_MAP_EVENT_CGB
.HallOfHonorDoor
	db $0e, $00, TILEMAP_HALL_OF_HONOR_DOOR_MAP_EVENT, TILEMAP_HALL_OF_HONOR_DOOR_MAP_EVENT_CGB
.FightingDeckMachine
	db $06, $02, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.RockDeckMachine
	db $0a, $02, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.WaterDeckMachine
	db $0e, $02, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.LightningDeckMachine
	db $12, $02, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.GrassDeckMachine
	db $0e, $0a, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.PsychicDeckMachine
	db $12, $0a, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.ScienceDeckMachine
	db $0e, $12, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.FireDeckMachine
	db $12, $12, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.ChallengeMachine
	db $0a, $00, TILEMAP_CHALLENGE_MACHINE_MAP_EVENT, TILEMAP_CHALLENGE_MACHINE_MAP_EVENT_CGB
