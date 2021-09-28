OverworldMapTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/overworld_map.bin"

OverworldMapCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/overworld_map_cgb.bin"

MasonLaboratoryTilemap::
	db $1c ; width
	db $1e ; height
	dw MasonLaboratoryPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/mason_laboratory.bin"
MasonLaboratoryPermissions:
	INCBIN "data/maps/permissions/mason_laboratory.bin"

MasonLaboratoryCGBTilemap::
	db $1c ; width
	db $1e ; height
	dw MasonLaboratoryCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/mason_laboratory_cgb.bin"
MasonLaboratoryCGBPermissions:
	INCBIN "data/maps/permissions/mason_laboratory_cgb.bin"

ChallengeMachineMapEventTilemap::
	db $04 ; width
	db $06 ; height
	dw ChallengeMachineMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/challenge_machine_map_event.bin"
ChallengeMachineMapEventPermissions:
	INCBIN "data/maps/permissions/challenge_machine_map_event.bin"

ChallengeMachineMapEventCGBTilemap::
	db $04 ; width
	db $06 ; height
	dw ChallengeMachineMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/challenge_machine_map_event_cgb.bin"
ChallengeMachineMapEventCGBPermissions:
	INCBIN "data/maps/permissions/challenge_machine_map_event_cgb.bin"

DeckMachineRoomTilemap::
	db $18 ; width
	db $1e ; height
	dw DeckMachineRoomPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_room.bin"
DeckMachineRoomPermissions:
	INCBIN "data/maps/permissions/deck_machine_room.bin"

DeckMachineRoomCGBTilemap::
	db $18 ; width
	db $1e ; height
	dw DeckMachineRoomCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_room_cgb.bin"
DeckMachineRoomCGBPermissions:
	INCBIN "data/maps/permissions/deck_machine_room_cgb.bin"

DeckMachineMapEventTilemap::
	db $04 ; width
	db $01 ; height
	dw DeckMachineMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_map_event.bin"
DeckMachineMapEventPermissions:
	INCBIN "data/maps/permissions/deck_machine_map_event.bin"

DeckMachineMapEventCGBTilemap::
	db $04 ; width
	db $01 ; height
	dw DeckMachineMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_map_event_cgb.bin"
DeckMachineMapEventCGBPermissions:
	INCBIN "data/maps/permissions/deck_machine_map_event_cgb.bin"

IshiharaTilemap::
	db $14 ; width
	db $18 ; height
	dw IshiharaPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/ishihara.bin"
IshiharaPermissions:
	INCBIN "data/maps/permissions/ishihara.bin"

IshiharaCGBTilemap::
	db $14 ; width
	db $18 ; height
	dw IshiharaCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/ishihara_cgb.bin"
IshiharaCGBPermissions:
	INCBIN "data/maps/permissions/ishihara_cgb.bin"

FightingClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw FightingClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_entrance.bin"
FightingClubEntrancePermissions:
	INCBIN "data/maps/permissions/fighting_club_entrance.bin"

FightingClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw FightingClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_entrance_cgb.bin"
FightingClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/fighting_club_entrance_cgb.bin"

RockClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw RockClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_entrance.bin"
RockClubEntrancePermissions:
	INCBIN "data/maps/permissions/rock_club_entrance.bin"

RockClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw RockClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_entrance_cgb.bin"
RockClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/rock_club_entrance_cgb.bin"

WaterClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw WaterClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/water_club_entrance.bin"
WaterClubEntrancePermissions:
	INCBIN "data/maps/permissions/water_club_entrance.bin"

WaterClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw WaterClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/water_club_entrance_cgb.bin"
WaterClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/water_club_entrance_cgb.bin"

LightningClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw LightningClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/lightning_club_entrance.bin"
LightningClubEntrancePermissions:
	INCBIN "data/maps/permissions/lightning_club_entrance.bin"

LightningClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw LightningClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/lightning_club_entrance_cgb.bin"
LightningClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/lightning_club_entrance_cgb.bin"

GrassClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw GrassClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/grass_club_entrance.bin"
GrassClubEntrancePermissions:
	INCBIN "data/maps/permissions/grass_club_entrance.bin"

GrassClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw GrassClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/grass_club_entrance_cgb.bin"
GrassClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/grass_club_entrance_cgb.bin"

PsychicClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw PsychicClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/psychic_club_entrance.bin"
PsychicClubEntrancePermissions:
	INCBIN "data/maps/permissions/psychic_club_entrance.bin"

PsychicClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw PsychicClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/psychic_club_entrance_cgb.bin"
PsychicClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/psychic_club_entrance_cgb.bin"

ScienceClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw ScienceClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/science_club_entrance.bin"
ScienceClubEntrancePermissions:
	INCBIN "data/maps/permissions/science_club_entrance.bin"

ScienceClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw ScienceClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/science_club_entrance_cgb.bin"
ScienceClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/science_club_entrance_cgb.bin"

FireClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw FireClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fire_club_entrance.bin"
FireClubEntrancePermissions:
	INCBIN "data/maps/permissions/fire_club_entrance.bin"

FireClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw FireClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fire_club_entrance_cgb.bin"
FireClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/fire_club_entrance_cgb.bin"

ChallengeHallEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw ChallengeHallEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/challenge_hall_entrance.bin"
ChallengeHallEntrancePermissions:
	INCBIN "data/maps/permissions/challenge_hall_entrance.bin"

ChallengeHallEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw ChallengeHallEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/challenge_hall_entrance_cgb.bin"
ChallengeHallEntranceCGBPermissions:
	INCBIN "data/maps/permissions/challenge_hall_entrance_cgb.bin"

ClubLobbyTilemap::
	db $1c ; width
	db $1a ; height
	dw ClubLobbyPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/club_lobby.bin"
ClubLobbyPermissions:
	INCBIN "data/maps/permissions/club_lobby.bin"

ClubLobbyCGBTilemap::
	db $1c ; width
	db $1a ; height
	dw ClubLobbyCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/club_lobby_cgb.bin"
ClubLobbyCGBPermissions:
	INCBIN "data/maps/permissions/club_lobby_cgb.bin"

FightingClubTilemap::
	db $18 ; width
	db $12 ; height
	dw FightingClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club.bin"
FightingClubPermissions:
	INCBIN "data/maps/permissions/fighting_club.bin"

FightingClubCGBTilemap::
	db $18 ; width
	db $12 ; height
	dw FightingClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_cgb.bin"
FightingClubCGBPermissions:
	INCBIN "data/maps/permissions/fighting_club_cgb.bin"

RockClubTilemap::
	db $1c ; width
	db $1e ; height
	dw RockClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/rock_club.bin"
RockClubPermissions:
	INCBIN "data/maps/permissions/rock_club.bin"

RockClubCGBTilemap::
	db $1c ; width
	db $1e ; height
	dw RockClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_cgb.bin"
RockClubCGBPermissions:
	INCBIN "data/maps/permissions/rock_club_cgb.bin"

PokemonDomeDoorMapEventTilemap::
	db $04 ; width
	db $03 ; height
	dw PokemonDomeDoorMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_door_map_event.bin"
PokemonDomeDoorMapEventPermissions:
	INCBIN "data/maps/permissions/pokemon_dome_door_map_event.bin"

PokemonDomeDoorMapEventCGBTilemap::
	db $04 ; width
	db $03 ; height
	dw PokemonDomeDoorMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_door_map_event_cgb.bin"
PokemonDomeDoorMapEventCGBPermissions:
	INCBIN "data/maps/permissions/pokemon_dome_door_map_event_cgb.bin"

HallOfHonorDoorMapEventTilemap::
	db $04 ; width
	db $03 ; height
	dw HallOfHonorDoorMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/hall_of_honor_door_map_event.bin"
HallOfHonorDoorMapEventPermissions:
	INCBIN "data/maps/permissions/hall_of_honor_door_map_event.bin"

HallOfHonorDoorMapEventCGBTilemap::
	db $04 ; width
	db $03 ; height
	dw HallOfHonorDoorMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/hall_of_honor_door_map_event_cgb.bin"
HallOfHonorDoorMapEventCGBPermissions:
	INCBIN "data/maps/permissions/hall_of_honor_door_map_event_cgb.bin"

GrassMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/grass_medal.bin"

AnimData1::
	frame_table AnimFrameTable0
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0

Palette110::
	db $00, $00
