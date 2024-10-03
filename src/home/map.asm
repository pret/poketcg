
OverworldDoFrameFunction::
	ld a, [wOverworldNPCFlags]
	bit HIDE_ALL_NPC_SPRITES, a
	ret nz
	ldh a, [hBankROM]
	push af
	ld a, BANK(SetScreenScrollWram)
	call BankswitchROM
	call SetScreenScrollWram
	call Func_c554
	ld a, BANK(HandleAllNPCMovement)
	call BankswitchROM
	call HandleAllNPCMovement
	call HandleAllSpriteAnimations
	ld a, BANK(DoLoadedFramesetSubgroupsFrame)
	call BankswitchROM
	call DoLoadedFramesetSubgroupsFrame
	call UpdateRNGSources
	pop af
	call BankswitchROM
	ret

; enable the play time counter and execute the game event at [wGameEvent].
; then return to the overworld, or restart the game (only after Credits).
ExecuteGameEvent::
	ld a, 1
	ld [wPlayTimeCounterEnable], a
	ldh a, [hBankROM]
	push af
.loop
	call _ExecuteGameEvent
	jr nc, .restart
	farcall LoadMap
	jr .loop
.restart
	pop af
	call BankswitchROM
	ret

; execute a game event at [wGameEvent] from GameEventPointerTable
_ExecuteGameEvent::
	ld a, [wGameEvent]
	cp NUM_GAME_EVENTS
	jr c, .got_game_event
	ld a, GAME_EVENT_CHALLENGE_MACHINE
.got_game_event
	ld hl, GameEventPointerTable
	jp JumpToFunctionInTable

GameEventPointerTable::
	dw GameEvent_Overworld
	dw GameEvent_Duel
	dw GameEvent_BattleCenter
	dw GameEvent_GiftCenter
	dw GameEvent_Credits
	dw GameEvent_ContinueDuel
	dw GameEvent_ChallengeMachine
	dw GameEvent_Overworld

GameEvent_Overworld::
	scf
	ret

GameEvent_GiftCenter::
	ldh a, [hBankROM]
	push af
	call PauseSong
	ld a, MUSIC_CARD_POP
	call PlaySong
	ld a, GAME_EVENT_GIFT_CENTER
	ld [wActiveGameEvent], a
	ld a, [wGiftCenterChoice]
	or $10
	ld [wGiftCenterChoice], a
	farcall HandleGiftCenter
	ld a, [wGiftCenterChoice]
	and $ef
	ld [wGiftCenterChoice], a
	call ResumeSong
	pop af
	call BankswitchROM
	scf
	ret

GameEvent_BattleCenter::
	ld a, GAME_EVENT_BATTLE_CENTER
	ld [wActiveGameEvent], a
	xor a
	ld [wSongOverride], a
	ld a, -1
	ld [wDuelResult], a
	ld a, MUSIC_DUEL_THEME_1
	ld [wDuelTheme], a
	ld a, MUSIC_CARD_POP
	call PlaySong
	bank1call SetUpAndStartLinkDuel
	scf
	ret

GameEvent_Duel::
	ld a, GAME_EVENT_DUEL
	ld [wActiveGameEvent], a
	xor a
	ld [wSongOverride], a
	call EnableSRAM
	xor a
	ld [sPlayerInChallengeMachine], a
	call DisableSRAM
	call SaveGeneralSaveData
	bank1call StartDuel_VSAIOpp
	scf
	ret

GameEvent_ChallengeMachine::
	ld a, MUSIC_PC_MAIN_MENU
	ld [wDefaultSong], a
	call PlayDefaultSong
	call EnableSRAM
	xor a
	ld [sPlayerInChallengeMachine], a
	call DisableSRAM
.asm_38ed
	farcall ChallengeMachine_Start
	ld a, MUSIC_OVERWORLD
	ld [wDefaultSong], a
	call PlayDefaultSong
	scf
	ret

GameEvent_ContinueDuel::
	xor a
	ld [wSongOverride], a
	bank1call TryContinueDuel
	call EnableSRAM
	ld a, [sPlayerInChallengeMachine]
	call DisableSRAM
	cp $ff
	jr z, GameEvent_ChallengeMachine.asm_38ed
	scf
	ret

GameEvent_Credits::
	farcall PlayCreditsSequence
	or a
	ret

GetReceivedLegendaryCards::
	ld a, EVENT_RECEIVED_LEGENDARY_CARDS
	farcall GetEventValue
	call EnableSRAM
	ld [sReceivedLegendaryCards], a
	call DisableSRAM
	ret

; return in a the permission byte corresponding to the current map's x,y coordinates at bc
GetPermissionOfMapPosition::
	push hl
	call GetPermissionByteOfMapPosition
	ld a, [hl]
	pop hl
	ret

; set to a the permission byte corresponding to the current map's x,y coordinates at bc
SetPermissionOfMapPosition::
	push hl
	push af
	call GetPermissionByteOfMapPosition
	pop af
	ld [hl], a
	pop hl
	ret

; set the permission byte corresponding to the current map's x,y coordinates at bc
; to the value of register a anded by its current value
UpdatePermissionOfMapPosition::
	push hl
	push bc
	push de
	cpl
	ld e, a
	call GetPermissionByteOfMapPosition
	ld a, [hl]
	and e
	ld [hl], a
	pop de
	pop bc
	pop hl
	ret

; returns in hl the address within wPermissionMap that corresponds to
; the current map's x,y coordinates at bc
GetPermissionByteOfMapPosition::
	push bc
	srl b
	srl c
	swap c
	ld a, c
	and $f0
	or b
	ld c, a
	ld b, $0
	ld hl, wPermissionMap
	add hl, bc
	pop bc
	ret

; copy c bytes of data from hl in bank wTempPointerBank to de, b times.
CopyGfxDataFromTempBank::
	ldh a, [hBankROM]
	push af
	ld a, [wTempPointerBank]
	call BankswitchROM
	call CopyGfxData
	pop af
	call BankswitchROM
	ret

; Movement offsets for player movements
PlayerMovementOffsetTable::
	db  0, -1 ; NORTH
	db  1,  0 ; EAST
	db  0,  1 ; SOUTH
	db -1,  0 ; WEST

; Movement offsets for player movements, in tiles
PlayerMovementOffsetTable_Tiles::
	db  0, -2 ; NORTH
	db  2,  0 ; EAST
	db  0,  2 ; SOUTH
	db -2,  0 ; WEST

OverworldMapNames::
	table_width 2, OverworldMapNames
	tx OverworldMapMasonLaboratoryText
	tx OverworldMapMasonLaboratoryText
	tx OverworldMapIshiharasHouseText
	tx OverworldMapFightingClubText
	tx OverworldMapRockClubText
	tx OverworldMapWaterClubText
	tx OverworldMapLightningClubText
	tx OverworldMapGrassClubText
	tx OverworldMapPsychicClubText
	tx OverworldMapScienceClubText
	tx OverworldMapFireClubText
	tx OverworldMapChallengeHallText
	tx OverworldMapPokemonDomeText
	tx OverworldMapMysteryHouseText
	assert_table_length NUM_OWMAP_NAMES

HandleMapWarp::
	ldh a, [hBankROM]
	push af
	ld a, BANK(_HandleMapWarp)
	call BankswitchROM
	call _HandleMapWarp
	pop af
	call BankswitchROM
	ret

; returns in hl a pointer to the first element for the a'th NPC
GetLoadedNPCID::
	ld l, LOADED_NPC_ID
	call GetItemInLoadedNPCIndex
	ret

; return in hl a pointer to the a'th items element l
GetItemInLoadedNPCIndex::
	push bc
	cp LOADED_NPC_MAX
	jr c, .asm_39b4
	debug_nop
	xor a
.asm_39b4
	add a
	add a
	ld h, a
	add a
	add h
	add l
	ld l, a
	ld h, $0
	ld bc, wLoadedNPCs
	add hl, bc
	pop bc
	ret

; Finds the index on wLoadedNPCs table of the npc in wTempNPC
; returns it in a and puts it into wLoadedNPCTempIndex
; c flag set if no npc found
FindLoadedNPC::
	push hl
	push bc
	push de
	xor a
	ld [wLoadedNPCTempIndex], a
	ld b, a
	ld c, LOADED_NPC_MAX
	ld de, LOADED_NPC_LENGTH
	ld hl, wLoadedNPCs
	ld a, [wTempNPC]
.findNPCLoop
	cp [hl]
	jr z, .foundNPCMatch
	add hl, de
	inc b
	dec c
	jr nz, .findNPCLoop
	scf
	jr z, .exit
.foundNPCMatch
	ld a, b
	ld [wLoadedNPCTempIndex], a
	or a
.exit
	pop de
	pop bc
	pop hl
	ret

GetNextNPCMovementByte::
	push bc
	ldh a, [hBankROM]
	push af
	ld a, BANK(ExecuteNPCMovement)
	call BankswitchROM
	ld a, [bc]
	ld c, a
	pop af
	call BankswitchROM
	ld a, c
	pop bc
	ret

PlayDefaultSong::
	push hl
	push bc
	call AssertSongFinished
	or a
	push af
	call GetDefaultSong
	ld c, a
	pop af
	jr z, .asm_3a11
	ld a, c
	ld hl, wSongOverride
	cp [hl]
	jr z, .asm_3a1c
.asm_3a11
	ld a, c
	cp NUM_SONGS
	jr nc, .asm_3a1c
	ld [wSongOverride], a
	call PlaySong
.asm_3a1c
	pop bc
	pop hl
	ret

; returns [wDefaultSong] or MUSIC_RONALD in a
GetDefaultSong::
	ld a, [wRonaldIsInMap]
	or a
	jr z, .default_song
	; only return Ronald's theme if it's
	; not in one of the following maps
	ld a, [wOverworldMapSelection]
	cp OWMAP_ISHIHARAS_HOUSE
	jr z, .default_song
	cp OWMAP_CHALLENGE_HALL
	jr z, .default_song
	cp OWMAP_POKEMON_DOME
	jr z, .default_song
	ld a, MUSIC_RONALD
	ret
.default_song
	ld a, [wDefaultSong]
	ret
