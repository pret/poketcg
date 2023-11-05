OverworldMapTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/overworld_map.bin.lz"

OverworldMapCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/overworld_map.bin.lz"

MasonLaboratoryTilemap::
	db $1c ; width
	db $1e ; height
	dw MasonLaboratoryPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/mason_laboratory.bin.lz"
MasonLaboratoryPermissions:
	INCBIN "data/maps/permissions/gb/mason_laboratory.bin.lz"

MasonLaboratoryCGBTilemap::
	db $1c ; width
	db $1e ; height
	dw MasonLaboratoryCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/mason_laboratory.bin.lz"
MasonLaboratoryCGBPermissions:
	INCBIN "data/maps/permissions/cgb/mason_laboratory.bin.lz"

ChallengeMachineMapEventTilemap::
	db $04 ; width
	db $06 ; height
	dw ChallengeMachineMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/challenge_machine_map_event.bin.lz"
ChallengeMachineMapEventPermissions:
	INCBIN "data/maps/permissions/gb/challenge_machine_map_event.bin.lz"

ChallengeMachineMapEventCGBTilemap::
	db $04 ; width
	db $06 ; height
	dw ChallengeMachineMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/challenge_machine_map_event.bin.lz"
ChallengeMachineMapEventCGBPermissions:
	INCBIN "data/maps/permissions/cgb/challenge_machine_map_event.bin.lz"

DeckMachineRoomTilemap::
	db $18 ; width
	db $1e ; height
	dw DeckMachineRoomPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/deck_machine_room.bin.lz"
DeckMachineRoomPermissions:
	INCBIN "data/maps/permissions/gb/deck_machine_room.bin.lz"

DeckMachineRoomCGBTilemap::
	db $18 ; width
	db $1e ; height
	dw DeckMachineRoomCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/deck_machine_room.bin.lz"
DeckMachineRoomCGBPermissions:
	INCBIN "data/maps/permissions/cgb/deck_machine_room.bin.lz"

DeckMachineMapEventTilemap::
	db $04 ; width
	db $01 ; height
	dw DeckMachineMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/deck_machine_map_event.bin.lz"
DeckMachineMapEventPermissions:
	INCBIN "data/maps/permissions/gb/deck_machine_map_event.bin.lz"

DeckMachineMapEventCGBTilemap::
	db $04 ; width
	db $01 ; height
	dw DeckMachineMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/deck_machine_map_event.bin.lz"
DeckMachineMapEventCGBPermissions:
	INCBIN "data/maps/permissions/cgb/deck_machine_map_event.bin.lz"

IshiharaTilemap::
	db $14 ; width
	db $18 ; height
	dw IshiharaPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/ishihara.bin.lz"
IshiharaPermissions:
	INCBIN "data/maps/permissions/gb/ishihara.bin.lz"

IshiharaCGBTilemap::
	db $14 ; width
	db $18 ; height
	dw IshiharaCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/ishihara.bin.lz"
IshiharaCGBPermissions:
	INCBIN "data/maps/permissions/cgb/ishihara.bin.lz"

FightingClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw FightingClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/fighting_club_entrance.bin.lz"
FightingClubEntrancePermissions:
	INCBIN "data/maps/permissions/gb/fighting_club_entrance.bin.lz"

FightingClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw FightingClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/fighting_club_entrance.bin.lz"
FightingClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/fighting_club_entrance.bin.lz"

RockClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw RockClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/rock_club_entrance.bin.lz"
RockClubEntrancePermissions:
	INCBIN "data/maps/permissions/gb/rock_club_entrance.bin.lz"

RockClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw RockClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/rock_club_entrance.bin.lz"
RockClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/rock_club_entrance.bin.lz"

WaterClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw WaterClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/water_club_entrance.bin.lz"
WaterClubEntrancePermissions:
	INCBIN "data/maps/permissions/gb/water_club_entrance.bin.lz"

WaterClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw WaterClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/water_club_entrance.bin.lz"
WaterClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/water_club_entrance.bin.lz"

LightningClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw LightningClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/lightning_club_entrance.bin.lz"
LightningClubEntrancePermissions:
	INCBIN "data/maps/permissions/gb/lightning_club_entrance.bin.lz"

LightningClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw LightningClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/lightning_club_entrance.bin.lz"
LightningClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/lightning_club_entrance.bin.lz"

GrassClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw GrassClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/grass_club_entrance.bin.lz"
GrassClubEntrancePermissions:
	INCBIN "data/maps/permissions/gb/grass_club_entrance.bin.lz"

GrassClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw GrassClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/grass_club_entrance.bin.lz"
GrassClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/grass_club_entrance.bin.lz"

PsychicClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw PsychicClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/psychic_club_entrance.bin.lz"
PsychicClubEntrancePermissions:
	INCBIN "data/maps/permissions/gb/psychic_club_entrance.bin.lz"

PsychicClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw PsychicClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/psychic_club_entrance.bin.lz"
PsychicClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/psychic_club_entrance.bin.lz"

ScienceClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw ScienceClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/science_club_entrance.bin.lz"
ScienceClubEntrancePermissions:
	INCBIN "data/maps/permissions/gb/science_club_entrance.bin.lz"

ScienceClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw ScienceClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/science_club_entrance.bin.lz"
ScienceClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/science_club_entrance.bin.lz"

FireClubEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw FireClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/fire_club_entrance.bin.lz"
FireClubEntrancePermissions:
	INCBIN "data/maps/permissions/gb/fire_club_entrance.bin.lz"

FireClubEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw FireClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/fire_club_entrance.bin.lz"
FireClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/fire_club_entrance.bin.lz"

ChallengeHallEntranceTilemap::
	db $14 ; width
	db $12 ; height
	dw ChallengeHallEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/challenge_hall_entrance.bin.lz"
ChallengeHallEntrancePermissions:
	INCBIN "data/maps/permissions/gb/challenge_hall_entrance.bin.lz"

ChallengeHallEntranceCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw ChallengeHallEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/challenge_hall_entrance.bin.lz"
ChallengeHallEntranceCGBPermissions:
	INCBIN "data/maps/permissions/cgb/challenge_hall_entrance.bin.lz"

ClubLobbyTilemap::
	db $1c ; width
	db $1a ; height
	dw ClubLobbyPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/club_lobby.bin.lz"
ClubLobbyPermissions:
	INCBIN "data/maps/permissions/gb/club_lobby.bin.lz"

ClubLobbyCGBTilemap::
	db $1c ; width
	db $1a ; height
	dw ClubLobbyCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/club_lobby.bin.lz"
ClubLobbyCGBPermissions:
	INCBIN "data/maps/permissions/cgb/club_lobby.bin.lz"

FightingClubTilemap::
	db $18 ; width
	db $12 ; height
	dw FightingClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/fighting_club.bin.lz"
FightingClubPermissions:
	INCBIN "data/maps/permissions/gb/fighting_club.bin.lz"

FightingClubCGBTilemap::
	db $18 ; width
	db $12 ; height
	dw FightingClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/fighting_club.bin.lz"
FightingClubCGBPermissions:
	INCBIN "data/maps/permissions/cgb/fighting_club.bin.lz"

RockClubTilemap::
	db $1c ; width
	db $1e ; height
	dw RockClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/rock_club.bin.lz"
RockClubPermissions:
	INCBIN "data/maps/permissions/gb/rock_club.bin.lz"

RockClubCGBTilemap::
	db $1c ; width
	db $1e ; height
	dw RockClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/rock_club.bin.lz"
RockClubCGBPermissions:
	INCBIN "data/maps/permissions/cgb/rock_club.bin.lz"

PokemonDomeDoorMapEventTilemap::
	db $04 ; width
	db $03 ; height
	dw PokemonDomeDoorMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/pokemon_dome_door_map_event.bin.lz"
PokemonDomeDoorMapEventPermissions:
	INCBIN "data/maps/permissions/gb/pokemon_dome_door_map_event.bin.lz"

PokemonDomeDoorMapEventCGBTilemap::
	db $04 ; width
	db $03 ; height
	dw PokemonDomeDoorMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/pokemon_dome_door_map_event.bin.lz"
PokemonDomeDoorMapEventCGBPermissions:
	INCBIN "data/maps/permissions/cgb/pokemon_dome_door_map_event.bin.lz"

HallOfHonorDoorMapEventTilemap::
	db $04 ; width
	db $03 ; height
	dw HallOfHonorDoorMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gb/hall_of_honor_door_map_event.bin.lz"
HallOfHonorDoorMapEventPermissions:
	INCBIN "data/maps/permissions/gb/hall_of_honor_door_map_event.bin.lz"

HallOfHonorDoorMapEventCGBTilemap::
	db $04 ; width
	db $03 ; height
	dw HallOfHonorDoorMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/cgb/hall_of_honor_door_map_event.bin.lz"
HallOfHonorDoorMapEventCGBPermissions:
	INCBIN "data/maps/permissions/cgb/hall_of_honor_door_map_event.bin.lz"

GrassMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/gb/grass_medal.bin.lz"

AnimData1::
	frame_table AnimFrameTable0
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0

Palette110::
	db $00, $00
