OverworldMapTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/overworld_map.bin.lz"

OverworldMapCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/overworld_map_cgb.bin.lz"

MasonLaboratoryTilemap::
	db $1c ; width
	db $1e ; height
	dw MasonLaboratoryPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/mason_laboratory.bin.lz"
MasonLaboratoryPermissions:
	INCBIN "data/maps/permissions/mason_laboratory.bin.lz"

MasonLaboratoryCGBTilemap::
	db $1c ; width
	db $1e ; height
	dw MasonLaboratoryCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/mason_laboratory_cgb.bin.lz"
MasonLaboratoryCGBPermissions:
	INCBIN "data/maps/permissions/mason_laboratory_cgb.bin.lz"

ChallengeMachineMapEventTilemap::
	db $04 ; width
	db $06 ; height
	dw ChallengeMachineMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/challenge_machine_map_event.bin.lz"
ChallengeMachineMapEventPermissions:
	INCBIN "data/maps/permissions/challenge_machine_map_event.bin.lz"

ChallengeMachineMapEventCGBTilemap::
	db $04 ; width
	db $06 ; height
	dw ChallengeMachineMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/challenge_machine_map_event_cgb.bin.lz"
ChallengeMachineMapEventCGBPermissions:
	INCBIN "data/maps/permissions/challenge_machine_map_event_cgb.bin.lz"

DeckMachineRoomTilemap::
	db $18 ; width
	db $1e ; height
	dw DeckMachineRoomPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_room.bin.lz"
DeckMachineRoomPermissions:
	INCBIN "data/maps/permissions/deck_machine_room.bin.lz"

DeckMachineRoomCGBTilemap::
	db $18 ; width
	db $1e ; height
	dw DeckMachineRoomCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_room_cgb.bin.lz"
DeckMachineRoomCGBPermissions:
	INCBIN "data/maps/permissions/deck_machine_room_cgb.bin.lz"

DeckMachineMapEventTilemap::
	db $04 ; width
	db $01 ; height
	dw DeckMachineMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_map_event.bin.lz"
DeckMachineMapEventPermissions:
	INCBIN "data/maps/permissions/deck_machine_map_event.bin.lz"

DeckMachineMapEventCGBTilemap::
	db $04 ; width
	db $01 ; height
	dw DeckMachineMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_map_event_cgb.bin.lz"
DeckMachineMapEventCGBPermissions:
	INCBIN "data/maps/permissions/deck_machine_map_event_cgb.bin.lz"

IshiharaTilemap::
	db $14 ; width
	db $18 ; height
	dw IshiharaPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/ishihara.bin.lz"
IshiharaPermissions:
	INCBIN "data/maps/permissions/ishihara.bin.lz"

IshiharaCGBTilemap::
	db $14 ; width
	db $18 ; height
	dw IshiharaCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/ishihara_cgb.bin.lz"
IshiharaCGBPermissions:
	INCBIN "data/maps/permissions/ishihara_cgb.bin.lz"

FightingClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw FightingClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_entrance.bin.lz"
FightingClubEntrancePermissions:
	INCBIN "data/maps/permissions/fighting_club_entrance.bin.lz"

FightingClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw FightingClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_entrance_cgb.bin.lz"
FightingClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/fighting_club_entrance_cgb.bin.lz"

RockClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw RockClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_entrance.bin.lz"
RockClubEntrancePermissions:
	INCBIN "data/maps/permissions/rock_club_entrance.bin.lz"

RockClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw RockClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_entrance_cgb.bin.lz"
RockClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/rock_club_entrance_cgb.bin.lz"

WaterClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw WaterClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/water_club_entrance.bin.lz"
WaterClubEntrancePermissions:
	INCBIN "data/maps/permissions/water_club_entrance.bin.lz"

WaterClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw WaterClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/water_club_entrance_cgb.bin.lz"
WaterClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/water_club_entrance_cgb.bin.lz"

LightningClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw LightningClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/lightning_club_entrance.bin.lz"
LightningClubEntrancePermissions:
	INCBIN "data/maps/permissions/lightning_club_entrance.bin.lz"

LightningClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw LightningClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/lightning_club_entrance_cgb.bin.lz"
LightningClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/lightning_club_entrance_cgb.bin.lz"

GrassClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw GrassClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/grass_club_entrance.bin.lz"
GrassClubEntrancePermissions:
	INCBIN "data/maps/permissions/grass_club_entrance.bin.lz"

GrassClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw GrassClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/grass_club_entrance_cgb.bin.lz"
GrassClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/grass_club_entrance_cgb.bin.lz"

PsychicClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw PsychicClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/psychic_club_entrance.bin.lz"
PsychicClubEntrancePermissions:
	INCBIN "data/maps/permissions/psychic_club_entrance.bin.lz"

PsychicClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw PsychicClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/psychic_club_entrance_cgb.bin.lz"
PsychicClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/psychic_club_entrance_cgb.bin.lz"

ScienceClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw ScienceClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/science_club_entrance.bin.lz"
ScienceClubEntrancePermissions:
	INCBIN "data/maps/permissions/science_club_entrance.bin.lz"

ScienceClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw ScienceClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/science_club_entrance_cgb.bin.lz"
ScienceClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/science_club_entrance_cgb.bin.lz"

FireClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw FireClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fire_club_entrance.bin.lz"
FireClubEntrancePermissions:
	INCBIN "data/maps/permissions/fire_club_entrance.bin.lz"

FireClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw FireClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fire_club_entrance_cgb.bin.lz"
FireClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/fire_club_entrance_cgb.bin.lz"

ChallengeHallEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw ChallengeHallEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/challenge_hall_entrance.bin.lz"
ChallengeHallEntrancePermissions:
	INCBIN "data/maps/permissions/challenge_hall_entrance.bin.lz"

ChallengeHallEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw ChallengeHallEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/challenge_hall_entrance_cgb.bin.lz"
ChallengeHallEntranceCGBPermissions:
	INCBIN "data/maps/permissions/challenge_hall_entrance_cgb.bin.lz"

ClubLobbyTilemap::
	db $1c ; width
	db $1a ; height
	dw ClubLobbyPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/club_lobby.bin.lz"
ClubLobbyPermissions:
	INCBIN "data/maps/permissions/club_lobby.bin.lz"

ClubLobbyCGBTilemap::
	db $1c ; width
	db $1a ; height
	dw ClubLobbyCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/club_lobby_cgb.bin.lz"
ClubLobbyCGBPermissions:
	INCBIN "data/maps/permissions/club_lobby_cgb.bin.lz"

FightingClubTilemap::
	db $18 ; width
	db $12 ; height
	dw FightingClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club.bin.lz"
FightingClubPermissions:
	INCBIN "data/maps/permissions/fighting_club.bin.lz"

FightingClubCGBTilemap::
	db $18 ; width
	db $12 ; height
	dw FightingClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_cgb.bin.lz"
FightingClubCGBPermissions:
	INCBIN "data/maps/permissions/fighting_club_cgb.bin.lz"

RockClubTilemap::
	db $1c ; width
	db $1e ; height
	dw RockClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/rock_club.bin.lz"
RockClubPermissions:
	INCBIN "data/maps/permissions/rock_club.bin.lz"

RockClubCGBTilemap::
	db $1c ; width
	db $1e ; height
	dw RockClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_cgb.bin.lz"
RockClubCGBPermissions:
	INCBIN "data/maps/permissions/rock_club_cgb.bin.lz"

PokemonDomeDoorMapEventTilemap::
	db $04 ; width
	db $03 ; height
	dw PokemonDomeDoorMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_door_map_event.bin.lz"
PokemonDomeDoorMapEventPermissions:
	INCBIN "data/maps/permissions/pokemon_dome_door_map_event.bin.lz"

PokemonDomeDoorMapEventCGBTilemap::
	db $04 ; width
	db $03 ; height
	dw PokemonDomeDoorMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_door_map_event_cgb.bin.lz"
PokemonDomeDoorMapEventCGBPermissions:
	INCBIN "data/maps/permissions/pokemon_dome_door_map_event_cgb.bin.lz"

HallOfHonorDoorMapEventTilemap::
	db $04 ; width
	db $03 ; height
	dw HallOfHonorDoorMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/hall_of_honor_door_map_event.bin.lz"
HallOfHonorDoorMapEventPermissions:
	INCBIN "data/maps/permissions/hall_of_honor_door_map_event.bin.lz"

HallOfHonorDoorMapEventCGBTilemap::
	db $04 ; width
	db $03 ; height
	dw HallOfHonorDoorMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/hall_of_honor_door_map_event_cgb.bin.lz"
HallOfHonorDoorMapEventCGBPermissions:
	INCBIN "data/maps/permissions/hall_of_honor_door_map_event_cgb.bin.lz"

GrassMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/grass_medal.bin.lz"

AnimData1::
	frame_table AnimFrameTable0
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0

Palette110::
	db $00, $00
