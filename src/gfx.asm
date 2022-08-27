INCLUDE "macros.asm"
INCLUDE "constants.asm"

SECTION "Gfx 1", ROMX

Fonts::

FullWidthFonts::
INCBIN "gfx/fonts/full_width/0_0_katakana.1bpp"
INCBIN "gfx/fonts/full_width/0_1_hiragana.1bpp"
INCBIN "gfx/fonts/full_width/0_2_digits_kanji1.1bpp"
INCBIN "gfx/fonts/full_width/1_kanji2.1bpp"
INCBIN "gfx/fonts/full_width/2_kanji3.1bpp"
INCBIN "gfx/fonts/full_width/3.1bpp"
INCBIN "gfx/fonts/full_width/4.1bpp"

HalfWidthFont::
INCBIN "gfx/fonts/half_width.1bpp"

SymbolsFont::
INCBIN "gfx/fonts/symbols.2bpp"

DuelGraphics::

DuelCardHeaderGraphics::
INCBIN "gfx/duel/card_headers.2bpp"

DuelDmgSgbSymbolGraphics::
INCBIN "gfx/duel/dmg_sgb_symbols.2bpp"

DuelCgbSymbolGraphics::
INCBIN "gfx/duel/cgb_symbols.2bpp", $0, $808

SECTION "Gfx 2", ROMX

INCBIN "gfx/duel/cgb_symbols.2bpp", $808, $8

DuelOtherGraphics::
INCBIN "gfx/duel/other.2bpp"

DuelBoxMessages::
INCBIN "gfx/duel/box_messages.2bpp"

SECTION "Gfx 3", ROMX

WaterClubTilemap::
	db $1c ; width
	db $20 ; height
	dw WaterClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/water_club.bin"
WaterClubPermissions:
	INCBIN "data/maps/permissions/water_club.bin"

WaterClubCGBTilemap::
	db $1c ; width
	db $20 ; height
	dw WaterClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/water_club_cgb.bin"
WaterClubCGBPermissions:
	INCBIN "data/maps/permissions/water_club_cgb.bin"

LightningClubTilemap::
	db $1c ; width
	db $20 ; height
	dw LightningClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/lightning_club.bin"
LightningClubPermissions:
	INCBIN "data/maps/permissions/lightning_club.bin"

LightningClubCGBTilemap::
	db $1c ; width
	db $20 ; height
	dw LightningClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/lightning_club_cgb.bin"
LightningClubCGBPermissions:
	INCBIN "data/maps/permissions/lightning_club_cgb.bin"

GrassClubTilemap::
	db $1c ; width
	db $20 ; height
	dw GrassClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/grass_club.bin"
GrassClubPermissions:
	INCBIN "data/maps/permissions/grass_club.bin"

GrassClubCGBTilemap::
	db $1c ; width
	db $20 ; height
	dw GrassClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/grass_club_cgb.bin"
GrassClubCGBPermissions:
	INCBIN "data/maps/permissions/grass_club_cgb.bin"

PsychicClubTilemap::
	db $1c ; width
	db $1c ; height
	dw PsychicClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/psychic_club.bin"
PsychicClubPermissions:
	INCBIN "data/maps/permissions/psychic_club.bin"

PsychicClubCGBTilemap::
	db $1c ; width
	db $1c ; height
	dw PsychicClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/psychic_club_cgb.bin"
PsychicClubCGBPermissions:
	INCBIN "data/maps/permissions/psychic_club_cgb.bin"

ScienceClubTilemap::
	db $1c ; width
	db $20 ; height
	dw ScienceClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/science_club.bin"
ScienceClubPermissions:
	INCBIN "data/maps/permissions/science_club.bin"

ScienceClubCGBTilemap::
	db $1c ; width
	db $20 ; height
	dw ScienceClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/science_club_cgb.bin"
ScienceClubCGBPermissions:
	INCBIN "data/maps/permissions/science_club_cgb.bin"

FireClubTilemap::
	db $1c ; width
	db $20 ; height
	dw FireClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fire_club.bin"
FireClubPermissions:
	INCBIN "data/maps/permissions/fire_club.bin"

FireClubCGBTilemap::
	db $1c ; width
	db $20 ; height
	dw FireClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fire_club_cgb.bin"
FireClubCGBPermissions:
	INCBIN "data/maps/permissions/fire_club_cgb.bin"

ChallengeHallTilemap::
	db $20 ; width
	db $20 ; height
	dw ChallengeHallPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/challenge_hall.bin"
ChallengeHallPermissions:
	INCBIN "data/maps/permissions/challenge_hall.bin"

ChallengeHallCGBTilemap::
	db $20 ; width
	db $20 ; height
	dw ChallengeHallCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/challenge_hall_cgb.bin"
ChallengeHallCGBPermissions:
	INCBIN "data/maps/permissions/challenge_hall_cgb.bin"

PokemonDomeEntranceTilemap::
	db $20 ; width
	db $12 ; height
	dw PokemonDomeEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_entrance.bin"
PokemonDomeEntrancePermissions:
	INCBIN "data/maps/permissions/pokemon_dome_entrance.bin"

PokemonDomeEntranceCGBTilemap::
	db $20 ; width
	db $12 ; height
	dw PokemonDomeEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_entrance_cgb.bin"
PokemonDomeEntranceCGBPermissions:
	INCBIN "data/maps/permissions/pokemon_dome_entrance_cgb.bin"

PokemonDomeTilemap::
	db $20 ; width
	db $20 ; height
	dw PokemonDomePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome.bin"
PokemonDomePermissions:
	INCBIN "data/maps/permissions/pokemon_dome.bin"

PokemonDomeCGBTilemap::
	db $20 ; width
	db $20 ; height
	dw PokemonDomeCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_cgb.bin"
PokemonDomeCGBPermissions:
	INCBIN "data/maps/permissions/pokemon_dome_cgb.bin"

HallOfHonorTilemap::
	db $18 ; width
	db $1a ; height
	dw HallOfHonorPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/hall_of_honor.bin"
HallOfHonorPermissions:
	INCBIN "data/maps/permissions/hall_of_honor.bin"

HallOfHonorCGBTilemap::
	db $18 ; width
	db $1a ; height
	dw HallOfHonorCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/hall_of_honor_cgb.bin"
HallOfHonorCGBPermissions:
	INCBIN "data/maps/permissions/hall_of_honor_cgb.bin"

CardPopCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/card_pop_cgb.bin"

CardPopTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/card_pop.bin"

ScienceMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/science_medal.bin"

FireMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fire_medal.bin"

WaterMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/water_medal.bin"

LightningMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/lightning_medal.bin"

FightingMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fighting_medal.bin"

RockMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/rock_medal.bin"

PsychicMedalTilemap::
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/psychic_medal.bin"

GameBoyLinkCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/gameboy_link_cgb.bin"

GameBoyLinkTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gameboy_link.bin"

GameBoyLinkConnectingCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/gameboy_link_connecting_cgb.bin"

GameBoyLinkConnectingTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gameboy_link_connecting.bin"

GameBoyPrinterCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/gameboy_printer_cgb.bin"

GameBoyPrinterTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/gameboy_printer.bin"

ColosseumTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/colosseum.bin"

ColosseumCGBTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/colosseum_cgb.bin"

EvolutionTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/evolution.bin"

EvolutionCGBTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/evolution_cgb.bin"

MysteryTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/mystery.bin"

MysteryCGBTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/mystery_cgb.bin"

LaboratoryTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/laboratory.bin"

LaboratoryCGBTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/laboratory_cgb.bin"

CharizardIntroTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/charizard_intro.bin"

CharizardIntroCGBTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/charizard_intro_cgb.bin"

ScytherIntroTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/scyther_intro.bin"

ScytherIntroCGBTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/scyther_intro_cgb.bin"

AerodactylIntroTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/aerodactyl_intro.bin"

AerodactylIntroCGBTilemap::
	db $08 ; width
	db $0c ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/aerodactyl_intro_cgb.bin"

JapaneseTitleScreenTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/japanese_title_screen.bin"

JapaneseTitleScreenCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/japanese_title_screen_cgb.bin"

SolidTiles1Tilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/solid_tiles_1.bin"

SolidTiles2Tilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/solid_tiles_2.bin"

SolidTiles3Tilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/solid_tiles_3.bin"

JapaneseTitleScreen2Tilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/japanese_title_screen_2.bin"

JapaneseTitleScreen2CGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/japanese_title_screen_2_cgb.bin"

SolidTiles4Tilemap::
	db $08 ; width
	db $04 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/solid_tiles_4.bin"

PlayerTilemap::
	db $06 ; width
	db $06 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/player.bin"

OpponentTilemap::
	db $06 ; width
	db $06 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/opponent.bin"

TitleScreenTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/title_screen.bin"

TitleScreenCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/title_screen_cgb.bin"

CopyrightTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/copyright.bin"

CopyrightCGBTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/copyright_cgb.bin"

NintendoTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/nintendo.bin"

CompaniesTilemap::
	db $14 ; width
	db $12 ; height
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/companies.bin"

IshiharaTilesetGfx::
	dw 77
	INCBIN "gfx/tilesets/ishihara.2bpp"

SolidTiles1::
	dw 4
	INCBIN "gfx/solid_tiles.2bpp"

SolidTiles2::
	dw 4
	INCBIN "gfx/solid_tiles.2bpp"

PlayerGfx::
	dw 36
	INCBIN "gfx/duelists/player.2bpp"

Duel55Gfx::
	dw $2
	INCBIN "gfx/duel/anims/55.2bpp"

Duel56Gfx::
	dw $1
	INCBIN "gfx/duel/anims/56.2bpp"

AnimData12::
	frame_table AnimFrameTable3
	frame_data 2, 8, 0, 0
	frame_data 0, 0, 0, 0

SECTION "Gfx 4", ROMX

OverworldMapTiles::
	dw 193
	INCBIN "gfx/overworld_map.2bpp"

MasonLaboratoryTilesetGfx::
	dw 151
	INCBIN "gfx/tilesets/masonlaboratory.2bpp"

ClubEntranceTilesetGfx::
	dw 129
	INCBIN "gfx/tilesets/clubentrance.2bpp"

ClubLobbyTilesetGfx::
	dw 120
	INCBIN "gfx/tilesets/clublobby.2bpp"

FightingClubTilesetGfx::
	dw 99
	INCBIN "gfx/tilesets/fightingclub.2bpp"

RockClubTilesetGfx::
	dw 60
	INCBIN "gfx/tilesets/rockclub.2bpp"

WaterClubTilesetGfx::
	dw 161
	INCBIN "gfx/tilesets/waterclub.2bpp"

GrassClubTilesetGfx::
	dw 87
	INCBIN "gfx/tilesets/grassclub.2bpp"

OWPlayerGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/player.2bpp"

Duel57Gfx::
	dw $1
	INCBIN "gfx/duel/anims/57.2bpp"

AnimData2::
	frame_table AnimFrameTable0
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0

Palette109::
	db 1, %11100100
	db 0

SECTION "Gfx 5", ROMX

LightningClubTilesetGfx::
	dw 131
	INCBIN "gfx/tilesets/lightningclub.2bpp"

PsychicClubTilesetGfx::
	dw 58
	INCBIN "gfx/tilesets/psychicclub.2bpp"

ScienceClubTilesetGfx::
	dw 82
	INCBIN "gfx/tilesets/scienceclub.2bpp"

FireClubTilesetGfx::
	dw 87
	INCBIN "gfx/tilesets/fireclub.2bpp"

ChallengeHallTilesetGfx::
	dw 157
	INCBIN "gfx/tilesets/challengehall.2bpp"

PokemonDomeEntranceTilesetGfx::
	dw 78
	INCBIN "gfx/tilesets/pokemondomeentrance.2bpp"

PokemonDomeTilesetGfx::
	dw 207
	INCBIN "gfx/tilesets/pokemondome.2bpp"

HallOfHonorTilesetGfx::
	dw 121
	INCBIN "gfx/tilesets/hallofhonor.2bpp"

MedalGfx::
	dw 72
	INCBIN "gfx/medals.2bpp", $0, $c0
	INCBIN "gfx/medals.2bpp", $240, $30
	INCBIN "gfx/medals.2bpp", $340, $10
	INCBIN "gfx/medals.2bpp", $c0, $c0
	INCBIN "gfx/medals.2bpp", $300, $30
	INCBIN "gfx/medals.2bpp", $350, $10
	INCBIN "gfx/medals.2bpp", $180, $c0
	INCBIN "gfx/medals.2bpp", $3c0, $30
	INCBIN "gfx/medals.2bpp", $410, $10
	INCBIN "gfx/medals.2bpp", $2d0, $30
	INCBIN "gfx/medals.2bpp", $2a0, $30
	INCBIN "gfx/medals.2bpp", $270, $30
	INCBIN "gfx/medals.2bpp", $390, $30
	INCBIN "gfx/medals.2bpp", $360, $30
	INCBIN "gfx/medals.2bpp", $330, $10
	INCBIN "gfx/medals.2bpp", $450, $30
	INCBIN "gfx/medals.2bpp", $420, $30
	INCBIN "gfx/medals.2bpp", $3f0, $20

NintendoGfx::
	dw 24
	INCBIN "gfx/nintendo.2bpp"

Duel58Gfx::
	dw $4
	INCBIN "gfx/duel/anims/58.2bpp"

AnimData3::
	frame_table AnimFrameTable0
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0

AnimData11::
	frame_table AnimFrameTable3
	frame_data 1, 8, 0, 0
	frame_data 0, 0, 0, 0

SECTION "Gfx 6", ROMX

CardPopGfx::
	dw 189
	INCBIN "gfx/link/cardpop.2bpp"

GameBoyLinkGfx::
	dw 109
	INCBIN "gfx/link/gameboylink.2bpp"

GameBoyPrinterGfx::
	dw 93
	INCBIN "gfx/link/gameboyprinter.2bpp"

Colosseum1Gfx::
	dw 96
	INCBIN "gfx/booster_packs/colosseum1.2bpp"

Colosseum2Gfx::
	dw 86
	INCBIN "gfx/booster_packs/colosseum2.2bpp"

Evolution1Gfx::
	dw 96
	INCBIN "gfx/booster_packs/evolution1.2bpp"

Evolution2Gfx::
	dw 86
	INCBIN "gfx/booster_packs/evolution2.2bpp"

Mystery1Gfx::
	dw 96
	INCBIN "gfx/booster_packs/mystery1.2bpp"

Mystery2Gfx::
	dw 86
	INCBIN "gfx/booster_packs/mystery2.2bpp"

RonaldGfx::
	dw 36
	INCBIN "gfx/duelists/ronald.2bpp"

CopyrightGfx::
	dw 36
	INCBIN "gfx/copyright.2bpp"

OWClerkGfx::
	dw $8
	INCBIN "gfx/overworld_sprites/clerk.2bpp"

Duel59Gfx::
	dw $3
	INCBIN "gfx/duel/anims/59.2bpp"

Duel60Gfx::
	dw $2
	INCBIN "gfx/duel/anims/60.2bpp"

SECTION "Gfx 7", ROMX

Laboratory1Gfx::
	dw 96
	INCBIN "gfx/booster_packs/laboratory1.2bpp"

Laboratory2Gfx::
	dw 86
	INCBIN "gfx/booster_packs/laboratory2.2bpp"

CharizardIntro1Gfx::
	dw 96
	INCBIN "gfx/titlescreen/booster_packs/charizardintro1.2bpp"

CharizardIntro2Gfx::
	dw 96
	INCBIN "gfx/titlescreen/booster_packs/charizardintro2.2bpp"

ScytherIntro1Gfx::
	dw 96
	INCBIN "gfx/titlescreen/booster_packs/scytherintro1.2bpp"

ScytherIntro2Gfx::
	dw 96
	INCBIN "gfx/titlescreen/booster_packs/scytherintro2.2bpp"

AerodactylIntro1Gfx::
	dw 96
	INCBIN "gfx/titlescreen/booster_packs/aerodactylintro1.2bpp"

AerodactylIntro2Gfx::
	dw 96
	INCBIN "gfx/titlescreen/booster_packs/aerodactylintro2.2bpp"

JapaneseTitleScreenGfx::
	dw 97
	INCBIN "gfx/titlescreen/japanese_title_screen.2bpp"

JapaneseTitleScreenCGBGfx::
	dw 97
	INCBIN "gfx/titlescreen/japanese_title_screen_cgb.2bpp"

CompaniesGfx::
	dw 49
	INCBIN "gfx/companies.2bpp"

OWRonaldGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/ronald.2bpp"

AnimData5::
	frame_table AnimFrameTable1
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0

SECTION "Gfx 8", ROMX

JapaneseTitleScreen2Gfx::
	dw 244
	INCBIN "gfx/titlescreen/japanese_title_screen_2.2bpp"

JapaneseTitleScreen2CGBGfx::
	dw 315
	INCBIN "gfx/titlescreen/japanese_title_screen_2_cgb.2bpp"

TitleScreenGfx::
	dw 220
	INCBIN "gfx/titlescreen/title_screen.2bpp"

TitleScreenCGBGfx::
	dw 212
	INCBIN "gfx/titlescreen/title_screen_cgb.2bpp"

OWDrMasonGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/doctormason.2bpp"

OverworldMapOAMGfx::
	dw $8
	INCBIN "gfx/overworld_map_oam.2bpp"

Duel61Gfx::
	dw $3
	INCBIN "gfx/duel/anims/61.2bpp"

Duel62Gfx::
	dw $1
	INCBIN "gfx/duel/anims/62.2bpp"

SECTION "Gfx 9", ROMX

SamGfx::
	dw 36
	INCBIN "gfx/duelists/sam.2bpp"

ImakuniGfx::
	dw 36
	INCBIN "gfx/duelists/imakuni.2bpp"

NikkiGfx::
	dw 36
	INCBIN "gfx/duelists/nikki.2bpp"

RickGfx::
	dw 36
	INCBIN "gfx/duelists/rick.2bpp"

KenGfx::
	dw 36
	INCBIN "gfx/duelists/ken.2bpp"

AmyGfx::
	dw 36
	INCBIN "gfx/duelists/amy.2bpp"

IsaacGfx::
	dw 36
	INCBIN "gfx/duelists/isaac.2bpp"

MitchGfx::
	dw 36
	INCBIN "gfx/duelists/mitch.2bpp"

GeneGfx::
	dw 36
	INCBIN "gfx/duelists/gene.2bpp"

MurrayGfx::
	dw 36
	INCBIN "gfx/duelists/murray.2bpp"

CourtneyGfx::
	dw 36
	INCBIN "gfx/duelists/courtney.2bpp"

SteveGfx::
	dw 36
	INCBIN "gfx/duelists/steve.2bpp"

JackGfx::
	dw 36
	INCBIN "gfx/duelists/jack.2bpp"

RodGfx::
	dw 36
	INCBIN "gfx/duelists/rod.2bpp"

JosephGfx::
	dw 36
	INCBIN "gfx/duelists/joseph.2bpp"

DavidGfx::
	dw 36
	INCBIN "gfx/duelists/david.2bpp"

ErikGfx::
	dw 36
	INCBIN "gfx/duelists/erik.2bpp"

JohnGfx::
	dw 36
	INCBIN "gfx/duelists/john.2bpp"

AdamGfx::
	dw 36
	INCBIN "gfx/duelists/adam.2bpp"

JonathanGfx::
	dw 36
	INCBIN "gfx/duelists/jonathan.2bpp"

JoshuaGfx::
	dw 36
	INCBIN "gfx/duelists/joshua.2bpp"

NicholasGfx::
	dw 36
	INCBIN "gfx/duelists/nicholas.2bpp"

BrandonGfx::
	dw 36
	INCBIN "gfx/duelists/brandon.2bpp"

MatthewGfx::
	dw 36
	INCBIN "gfx/duelists/matthew.2bpp"

RyanGfx::
	dw 36
	INCBIN "gfx/duelists/ryan.2bpp"

AndrewGfx::
	dw 36
	INCBIN "gfx/duelists/andrew.2bpp"

ChrisGfx::
	dw 36
	INCBIN "gfx/duelists/chris.2bpp"

MichaelGfx::
	dw 36
	INCBIN "gfx/duelists/michael.2bpp"

Duel63Gfx::
	dw $a
	INCBIN "gfx/duel/anims/63.2bpp"

Duel64Gfx::
	dw $2
	INCBIN "gfx/duel/anims/64.2bpp"

SECTION "Gfx 10", ROMX

DanielGfx::
	dw 36
	INCBIN "gfx/duelists/daniel.2bpp"

RobertGfx::
	dw 36
	INCBIN "gfx/duelists/robert.2bpp"

BrittanyGfx::
	dw 36
	INCBIN "gfx/duelists/brittany.2bpp"

KristinGfx::
	dw 36
	INCBIN "gfx/duelists/kristin.2bpp"

HeatherGfx::
	dw 36
	INCBIN "gfx/duelists/heather.2bpp"

SaraGfx::
	dw 36
	INCBIN "gfx/duelists/sara.2bpp"

AmandaGfx::
	dw 36
	INCBIN "gfx/duelists/amanda.2bpp"

JenniferGfx::
	dw 36
	INCBIN "gfx/duelists/jennifer.2bpp"

JessicaGfx::
	dw 36
	INCBIN "gfx/duelists/jessica.2bpp"

StephanieGfx::
	dw 36
	INCBIN "gfx/duelists/stephanie.2bpp"

AaronGfx::
	dw 36
	INCBIN "gfx/duelists/aaron.2bpp"

OWIshiharaGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/ishihara.2bpp"

OWImakuniGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/imakuni.2bpp"

OWNikkiGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/nikki.2bpp"

OWRickGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/rick.2bpp"

OWKenGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/ken.2bpp"

OWAmyGfx::
	dw $1b
	INCBIN "gfx/overworld_sprites/amy.2bpp"

OWIsaacGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/isaac.2bpp"

OWMitchGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/mitch.2bpp"

OWGeneGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/gene.2bpp"

OWMurrayGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/murray.2bpp"

OWCourtneyGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/courtney.2bpp"

OWSteveGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/steve.2bpp"

OWJackGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/jack.2bpp"

OWRodGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/rod.2bpp"

OWBoyGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/youngster.2bpp"

OWLadGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/lad.2bpp"

OWSpecsGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/specs.2bpp"

OWButchGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/butch.2bpp"

OWManiaGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/mania.2bpp"

OWJoshuaGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/joshua.2bpp"

OWHoodGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/hood.2bpp"

OWTechGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/tech.2bpp"

OWChapGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/chap.2bpp"

OWManGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/man.2bpp"

OWPappyGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/pappy.2bpp"

OWGirlGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/girl.2bpp"

OWLass1Gfx::
	dw $14
	INCBIN "gfx/overworld_sprites/lass1.2bpp"

OWLass2Gfx::
	dw $14
	INCBIN "gfx/overworld_sprites/lass2.2bpp"

OWLass3Gfx::
	dw $14
	INCBIN "gfx/overworld_sprites/lass3.2bpp"

OWSwimmerGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/swimmer.2bpp"

DuelGlowGfx::
	dw $b
	INCBIN "gfx/duel/anims/glow.2bpp"

Duel66Gfx::
	dw $4
	INCBIN "gfx/duel/anims/66.2bpp"

Palette117::
	db 0
	db 1

	rgb 27, 27, 24
	rgb 31, 31,  0
	rgb 31,  0,  0
	rgb  0,  8, 19

SECTION "Gfx 11", ROMX

OWGalGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/gal.2bpp"

OWWomanGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/woman.2bpp"

OWGrannyGfx::
	dw $14
	INCBIN "gfx/overworld_sprites/granny.2bpp"

Duel0Gfx::
	dw $16
	INCBIN "gfx/duel/anims/0.2bpp"

Duel1Gfx::
	dw $06
	INCBIN "gfx/duel/anims/1.2bpp"

Duel2Gfx::
	dw $08
	INCBIN "gfx/duel/anims/2.2bpp"

Duel3Gfx::
	dw $09
	INCBIN "gfx/duel/anims/3.2bpp"

Duel4Gfx::
	dw $12
	INCBIN "gfx/duel/anims/4.2bpp"

Duel5Gfx::
	dw $09
	INCBIN "gfx/duel/anims/5.2bpp"

Duel6Gfx::
	dw $11
	INCBIN "gfx/duel/anims/6.2bpp"

Duel7Gfx::
	dw $2d
	INCBIN "gfx/duel/anims/7.2bpp"

Duel8Gfx::
	dw $0d
	INCBIN "gfx/duel/anims/8.2bpp"

Duel9Gfx::
	dw $1c
	INCBIN "gfx/duel/anims/9.2bpp"

Duel10Gfx::
	dw $4c
	INCBIN "gfx/duel/anims/10.2bpp"

Duel11Gfx::
	dw $1b
	INCBIN "gfx/duel/anims/11.2bpp"

Duel12Gfx::
	dw $07
	INCBIN "gfx/duel/anims/12.2bpp"

Duel13Gfx::
	dw $0c
	INCBIN "gfx/duel/anims/13.2bpp"

Duel14Gfx::
	dw $22
	INCBIN "gfx/duel/anims/14.2bpp"

Duel15Gfx::
	dw $20
	INCBIN "gfx/duel/anims/15.2bpp"

Duel16Gfx::
	dw $0a
	INCBIN "gfx/duel/anims/16.2bpp"

Duel17Gfx::
	dw $25
	INCBIN "gfx/duel/anims/17.2bpp"

Duel18Gfx::
	dw $18
	INCBIN "gfx/duel/anims/18.2bpp"

Duel19Gfx::
	dw $1b
	INCBIN "gfx/duel/anims/19.2bpp"

Duel20Gfx::
	dw $08
	INCBIN "gfx/duel/anims/20.2bpp"

Duel21Gfx::
	dw $0d
	INCBIN "gfx/duel/anims/21.2bpp"

Duel22Gfx::
	dw $22
	INCBIN "gfx/duel/anims/22.2bpp"

Duel23Gfx::
	dw $0c
	INCBIN "gfx/duel/anims/23.2bpp"

Duel24Gfx::
	dw $25
	INCBIN "gfx/duel/anims/24.2bpp"

Duel25Gfx::
	dw $22
	INCBIN "gfx/duel/anims/25.2bpp"

Duel26Gfx::
	dw $0c
	INCBIN "gfx/duel/anims/26.2bpp"

Duel27Gfx::
	dw $4c
	INCBIN "gfx/duel/anims/27.2bpp"

Duel28Gfx::
	dw $08
	INCBIN "gfx/duel/anims/28.2bpp"

Duel29Gfx::
	dw $07
	INCBIN "gfx/duel/anims/29.2bpp"

Duel30Gfx::
	dw $1a
	INCBIN "gfx/duel/anims/30.2bpp"

Duel31Gfx::
	dw $0a
	INCBIN "gfx/duel/anims/31.2bpp"

Duel32Gfx::
	dw $2e
	INCBIN "gfx/duel/anims/32.2bpp"

Duel33Gfx::
	dw $08
	INCBIN "gfx/duel/anims/33.2bpp"

Duel34Gfx::
	dw $07
	INCBIN "gfx/duel/anims/34.2bpp"

Duel35Gfx::
	dw $1c
	INCBIN "gfx/duel/anims/35.2bpp"

Duel36Gfx::
	dw $08
	INCBIN "gfx/duel/anims/36.2bpp"

Duel37Gfx::
	dw $0b
	INCBIN "gfx/duel/anims/37.2bpp"

Duel38Gfx::
	dw $1c
	INCBIN "gfx/duel/anims/38.2bpp"

Duel39Gfx::
	dw $16
	INCBIN "gfx/duel/anims/39.2bpp"

Duel40Gfx::
	dw $10
	INCBIN "gfx/duel/anims/40.2bpp"

Duel41Gfx::
	dw $0f
	INCBIN "gfx/duel/anims/41.2bpp"

Duel42Gfx::
	dw $07
	INCBIN "gfx/duel/anims/42.2bpp"

Duel43Gfx::
	dw $0a
	INCBIN "gfx/duel/anims/43.2bpp"

Duel44Gfx::
	dw $09
	INCBIN "gfx/duel/anims/44.2bpp"

Duel45Gfx::
	dw $03
	INCBIN "gfx/duel/anims/45.2bpp"

AnimData6::
	frame_table AnimFrameTable1
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0

SECTION "Gfx 12", ROMX

Duel46Gfx::
	dw $08
	INCBIN "gfx/duel/anims/46.2bpp"

Duel47Gfx::
	dw $0f
	INCBIN "gfx/duel/anims/47.2bpp"

Duel48Gfx::
	dw $03
	INCBIN "gfx/duel/anims/48.2bpp"

Duel49Gfx::
	dw $05
	INCBIN "gfx/duel/anims/49.2bpp"

Duel50Gfx::
	dw $17
	INCBIN "gfx/duel/anims/50.2bpp"

Duel51Gfx::
	dw $36
	INCBIN "gfx/duel/anims/51.2bpp"

Duel52Gfx::
	dw $0b
	INCBIN "gfx/duel/anims/52.2bpp"

Duel53Gfx::
	dw $06
	INCBIN "gfx/duel/anims/53.2bpp"

Duel54Gfx::
	dw $16
	INCBIN "gfx/duel/anims/54.2bpp"

BoosterPackOAMGfx::
	dw $20
	INCBIN "gfx/booster_packs/oam.2bpp"

PressStartGfx::
	dw $14
	INCBIN "gfx/titlescreen/press_start.2bpp"

GrassGfx::
	dw $04
	INCBIN "gfx/titlescreen/energies/grass.2bpp"

FireGfx::
	dw $04
	INCBIN "gfx/titlescreen/energies/fire.2bpp"

WaterGfx::
	dw $04
	INCBIN "gfx/titlescreen/energies/water.2bpp"

ColorlessGfx::
	dw $04
	INCBIN "gfx/titlescreen/energies/colorless.2bpp"

LightningGfx::
	dw $04
	INCBIN "gfx/titlescreen/energies/lightning.2bpp"

PsychicGfx::
	dw $04
	INCBIN "gfx/titlescreen/energies/psychic.2bpp"

FightingGfx::
	dw $04
	INCBIN "gfx/titlescreen/energies/fighting.2bpp"

SECTION "Anims 1", ROMX
	INCLUDE "data/duel/animations/anims1.asm"

SECTION "Anims 2", ROMX
	INCLUDE "data/duel/animations/anims2.asm"

SECTION "Anims 3", ROMX
	INCLUDE "data/duel/animations/anims3.asm"

Palette31::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31,  7
	rgb 31, 24,  6
	rgb 11,  3,  0

Palette119::
	db 0
	db 1

	rgb 28, 28, 24
	rgb 28, 16, 12
	rgb 28,  4,  8
	rgb  0,  0,  8

SECTION "Anims 4", ROMX
	INCLUDE "data/duel/animations/anims4.asm"

SECTION "Palettes1", ROMX
	INCLUDE "data/palettes1.asm"

SECTION "Palettes2", ROMX
	INCLUDE "data/palettes2.asm"

SECTION "Card Gfx 1", ROMX

CardGraphics::

GrassEnergyCardGfx::
	INCBIN "gfx/cards/grassenergy.2bpp"
	INCBIN "gfx/cards/grassenergy.pal"

FireEnergyCardGfx::
	INCBIN "gfx/cards/fireenergy.2bpp"
	INCBIN "gfx/cards/fireenergy.pal"

WaterEnergyCardGfx::
	INCBIN "gfx/cards/waterenergy.2bpp"
	INCBIN "gfx/cards/waterenergy.pal"

LightningEnergyCardGfx::
	INCBIN "gfx/cards/lightningenergy.2bpp"
	INCBIN "gfx/cards/lightningenergy.pal"

FightingEnergyCardGfx::
	INCBIN "gfx/cards/fightingenergy.2bpp"
	INCBIN "gfx/cards/fightingenergy.pal"

PsychicEnergyCardGfx::
	INCBIN "gfx/cards/psychicenergy.2bpp"
	INCBIN "gfx/cards/psychicenergy.pal"

DoubleColorlessEnergyCardGfx::
	INCBIN "gfx/cards/doublecolorlessenergy.2bpp"
	INCBIN "gfx/cards/doublecolorlessenergy.pal"

BulbasaurCardGfx::
	INCBIN "gfx/cards/bulbasaur.2bpp"
	INCBIN "gfx/cards/bulbasaur.pal"

IvysaurCardGfx::
	INCBIN "gfx/cards/ivysaur.2bpp"
	INCBIN "gfx/cards/ivysaur.pal"

VenusaurLv64CardGfx::
	INCBIN "gfx/cards/venusaur1.2bpp"
	INCBIN "gfx/cards/venusaur1.pal"

VenusaurLv67CardGfx::
	INCBIN "gfx/cards/venusaur2.2bpp"
	INCBIN "gfx/cards/venusaur2.pal"

CaterpieCardGfx::
	INCBIN "gfx/cards/caterpie.2bpp"
	INCBIN "gfx/cards/caterpie.pal"

MetapodCardGfx::
	INCBIN "gfx/cards/metapod.2bpp"
	INCBIN "gfx/cards/metapod.pal"

ButterfreeCardGfx::
	INCBIN "gfx/cards/butterfree.2bpp"
	INCBIN "gfx/cards/butterfree.pal"

WeedleCardGfx::
	INCBIN "gfx/cards/weedle.2bpp"
	INCBIN "gfx/cards/weedle.pal"

KakunaCardGfx::
	INCBIN "gfx/cards/kakuna.2bpp"
	INCBIN "gfx/cards/kakuna.pal"

BeedrillCardGfx::
	INCBIN "gfx/cards/beedrill.2bpp"
	INCBIN "gfx/cards/beedrill.pal"

EkansCardGfx::
	INCBIN "gfx/cards/ekans.2bpp"
	INCBIN "gfx/cards/ekans.pal"

ArbokCardGfx::
	INCBIN "gfx/cards/arbok.2bpp"
	INCBIN "gfx/cards/arbok.pal"

NidoranFCardGfx::
	INCBIN "gfx/cards/nidoranf.2bpp"
	INCBIN "gfx/cards/nidoranf.pal"

NidorinaCardGfx::
	INCBIN "gfx/cards/nidorina.2bpp"
	INCBIN "gfx/cards/nidorina.pal"

	ds $58

SECTION "Card Gfx 2", ROMX

NidoqueenCardGfx::
	INCBIN "gfx/cards/nidoqueen.2bpp"
	INCBIN "gfx/cards/nidoqueen.pal"

NidoranMCardGfx::
	INCBIN "gfx/cards/nidoranm.2bpp"
	INCBIN "gfx/cards/nidoranm.pal"

NidorinoCardGfx::
	INCBIN "gfx/cards/nidorino.2bpp"
	INCBIN "gfx/cards/nidorino.pal"

NidokingCardGfx::
	INCBIN "gfx/cards/nidoking.2bpp"
	INCBIN "gfx/cards/nidoking.pal"

ZubatCardGfx::
	INCBIN "gfx/cards/zubat.2bpp"
	INCBIN "gfx/cards/zubat.pal"

GolbatCardGfx::
	INCBIN "gfx/cards/golbat.2bpp"
	INCBIN "gfx/cards/golbat.pal"

OddishCardGfx::
	INCBIN "gfx/cards/oddish.2bpp"
	INCBIN "gfx/cards/oddish.pal"

GloomCardGfx::
	INCBIN "gfx/cards/gloom.2bpp"
	INCBIN "gfx/cards/gloom.pal"

VileplumeCardGfx::
	INCBIN "gfx/cards/vileplume.2bpp"
	INCBIN "gfx/cards/vileplume.pal"

ParasCardGfx::
	INCBIN "gfx/cards/paras.2bpp"
	INCBIN "gfx/cards/paras.pal"

ParasectCardGfx::
	INCBIN "gfx/cards/parasect.2bpp"
	INCBIN "gfx/cards/parasect.pal"

VenonatCardGfx::
	INCBIN "gfx/cards/venonat.2bpp"
	INCBIN "gfx/cards/venonat.pal"

VenomothCardGfx::
	INCBIN "gfx/cards/venomoth.2bpp"
	INCBIN "gfx/cards/venomoth.pal"

BellsproutCardGfx::
	INCBIN "gfx/cards/bellsprout.2bpp"
	INCBIN "gfx/cards/bellsprout.pal"

WeepinbellCardGfx::
	INCBIN "gfx/cards/weepinbell.2bpp"
	INCBIN "gfx/cards/weepinbell.pal"

VictreebelCardGfx::
	INCBIN "gfx/cards/victreebel.2bpp"
	INCBIN "gfx/cards/victreebel.pal"

GrimerCardGfx::
	INCBIN "gfx/cards/grimer.2bpp"
	INCBIN "gfx/cards/grimer.pal"

MukCardGfx::
	INCBIN "gfx/cards/muk.2bpp"
	INCBIN "gfx/cards/muk.pal"

ExeggcuteCardGfx::
	INCBIN "gfx/cards/exeggcute.2bpp"
	INCBIN "gfx/cards/exeggcute.pal"

ExeggutorCardGfx::
	INCBIN "gfx/cards/exeggutor.2bpp"
	INCBIN "gfx/cards/exeggutor.pal"

KoffingCardGfx::
	INCBIN "gfx/cards/koffing.2bpp"
	INCBIN "gfx/cards/koffing.pal"

	ds $58

SECTION "Card Gfx 3", ROMX

WeezingCardGfx::
	INCBIN "gfx/cards/weezing.2bpp"
	INCBIN "gfx/cards/weezing.pal"

TangelaLv8CardGfx::
	INCBIN "gfx/cards/tangela1.2bpp"
	INCBIN "gfx/cards/tangela1.pal"

TangelaLv12CardGfx::
	INCBIN "gfx/cards/tangela2.2bpp"
	INCBIN "gfx/cards/tangela2.pal"

ScytherCardGfx::
	INCBIN "gfx/cards/scyther.2bpp"
	INCBIN "gfx/cards/scyther.pal"

PinsirCardGfx::
	INCBIN "gfx/cards/pinsir.2bpp"
	INCBIN "gfx/cards/pinsir.pal"

CharmanderCardGfx::
	INCBIN "gfx/cards/charmander.2bpp"
	INCBIN "gfx/cards/charmander.pal"

CharmeleonCardGfx::
	INCBIN "gfx/cards/charmeleon.2bpp"
	INCBIN "gfx/cards/charmeleon.pal"

CharizardCardGfx::
	INCBIN "gfx/cards/charizard.2bpp"
	INCBIN "gfx/cards/charizard.pal"

VulpixCardGfx::
	INCBIN "gfx/cards/vulpix.2bpp"
	INCBIN "gfx/cards/vulpix.pal"

NinetalesLv32CardGfx::
	INCBIN "gfx/cards/ninetales1.2bpp"
	INCBIN "gfx/cards/ninetales1.pal"

NinetalesLv35CardGfx::
	INCBIN "gfx/cards/ninetales2.2bpp"
	INCBIN "gfx/cards/ninetales2.pal"

GrowlitheCardGfx::
	INCBIN "gfx/cards/growlithe.2bpp"
	INCBIN "gfx/cards/growlithe.pal"

ArcanineLv34CardGfx::
	INCBIN "gfx/cards/arcanine1.2bpp"
	INCBIN "gfx/cards/arcanine1.pal"

ArcanineLv45CardGfx::
	INCBIN "gfx/cards/arcanine2.2bpp"
	INCBIN "gfx/cards/arcanine2.pal"

PonytaCardGfx::
	INCBIN "gfx/cards/ponyta.2bpp"
	INCBIN "gfx/cards/ponyta.pal"

RapidashCardGfx::
	INCBIN "gfx/cards/rapidash.2bpp"
	INCBIN "gfx/cards/rapidash.pal"

MagmarLv24CardGfx::
	INCBIN "gfx/cards/magmar1.2bpp"
	INCBIN "gfx/cards/magmar1.pal"

MagmarLv31CardGfx::
	INCBIN "gfx/cards/magmar2.2bpp"
	INCBIN "gfx/cards/magmar2.pal"

FlareonLv22CardGfx::
	INCBIN "gfx/cards/flareon1.2bpp"
	INCBIN "gfx/cards/flareon1.pal"

FlareonLv28CardGfx::
	INCBIN "gfx/cards/flareon2.2bpp"
	INCBIN "gfx/cards/flareon2.pal"

MoltresLv35CardGfx::
	INCBIN "gfx/cards/moltres1.2bpp"
	INCBIN "gfx/cards/moltres1.pal"

	ds $58

SECTION "Card Gfx 4", ROMX

MoltresLv37CardGfx::
	INCBIN "gfx/cards/moltres2.2bpp"
	INCBIN "gfx/cards/moltres2.pal"

SquirtleCardGfx::
	INCBIN "gfx/cards/squirtle.2bpp"
	INCBIN "gfx/cards/squirtle.pal"

WartortleCardGfx::
	INCBIN "gfx/cards/wartortle.2bpp"
	INCBIN "gfx/cards/wartortle.pal"

BlastoiseCardGfx::
	INCBIN "gfx/cards/blastoise.2bpp"
	INCBIN "gfx/cards/blastoise.pal"

PsyduckCardGfx::
	INCBIN "gfx/cards/psyduck.2bpp"
	INCBIN "gfx/cards/psyduck.pal"

GolduckCardGfx::
	INCBIN "gfx/cards/golduck.2bpp"
	INCBIN "gfx/cards/golduck.pal"

PoliwagCardGfx::
	INCBIN "gfx/cards/poliwag.2bpp"
	INCBIN "gfx/cards/poliwag.pal"

PoliwhirlCardGfx::
	INCBIN "gfx/cards/poliwhirl.2bpp"
	INCBIN "gfx/cards/poliwhirl.pal"

PoliwrathCardGfx::
	INCBIN "gfx/cards/poliwrath.2bpp"
	INCBIN "gfx/cards/poliwrath.pal"

TentacoolCardGfx::
	INCBIN "gfx/cards/tentacool.2bpp"
	INCBIN "gfx/cards/tentacool.pal"

TentacruelCardGfx::
	INCBIN "gfx/cards/tentacruel.2bpp"
	INCBIN "gfx/cards/tentacruel.pal"

SeelCardGfx::
	INCBIN "gfx/cards/seel.2bpp"
	INCBIN "gfx/cards/seel.pal"

DewgongCardGfx::
	INCBIN "gfx/cards/dewgong.2bpp"
	INCBIN "gfx/cards/dewgong.pal"

ShellderCardGfx::
	INCBIN "gfx/cards/shellder.2bpp"
	INCBIN "gfx/cards/shellder.pal"

CloysterCardGfx::
	INCBIN "gfx/cards/cloyster.2bpp"
	INCBIN "gfx/cards/cloyster.pal"

KrabbyCardGfx::
	INCBIN "gfx/cards/krabby.2bpp"
	INCBIN "gfx/cards/krabby.pal"

KinglerCardGfx::
	INCBIN "gfx/cards/kingler.2bpp"
	INCBIN "gfx/cards/kingler.pal"

HorseaCardGfx::
	INCBIN "gfx/cards/horsea.2bpp"
	INCBIN "gfx/cards/horsea.pal"

SeadraCardGfx::
	INCBIN "gfx/cards/seadra.2bpp"
	INCBIN "gfx/cards/seadra.pal"

GoldeenCardGfx::
	INCBIN "gfx/cards/goldeen.2bpp"
	INCBIN "gfx/cards/goldeen.pal"

SeakingCardGfx::
	INCBIN "gfx/cards/seaking.2bpp"
	INCBIN "gfx/cards/seaking.pal"

	ds $58

SECTION "Card Gfx 5", ROMX

StaryuCardGfx::
	INCBIN "gfx/cards/staryu.2bpp"
	INCBIN "gfx/cards/staryu.pal"

StarmieCardGfx::
	INCBIN "gfx/cards/starmie.2bpp"
	INCBIN "gfx/cards/starmie.pal"

MagikarpCardGfx::
	INCBIN "gfx/cards/magikarp.2bpp"
	INCBIN "gfx/cards/magikarp.pal"

GyaradosCardGfx::
	INCBIN "gfx/cards/gyarados.2bpp"
	INCBIN "gfx/cards/gyarados.pal"

LaprasCardGfx::
	INCBIN "gfx/cards/lapras.2bpp"
	INCBIN "gfx/cards/lapras.pal"

VaporeonLv29CardGfx::
	INCBIN "gfx/cards/vaporeon1.2bpp"
	INCBIN "gfx/cards/vaporeon1.pal"

VaporeonLv42CardGfx::
	INCBIN "gfx/cards/vaporeon2.2bpp"
	INCBIN "gfx/cards/vaporeon2.pal"

OmanyteCardGfx::
	INCBIN "gfx/cards/omanyte.2bpp"
	INCBIN "gfx/cards/omanyte.pal"

OmastarCardGfx::
	INCBIN "gfx/cards/omastar.2bpp"
	INCBIN "gfx/cards/omastar.pal"

ArticunoLv35CardGfx::
	INCBIN "gfx/cards/articuno1.2bpp"
	INCBIN "gfx/cards/articuno1.pal"

ArticunoLv37CardGfx::
	INCBIN "gfx/cards/articuno2.2bpp"
	INCBIN "gfx/cards/articuno2.pal"

PikachuLv12CardGfx::
	INCBIN "gfx/cards/pikachu1.2bpp"
	INCBIN "gfx/cards/pikachu1.pal"

PikachuLv14CardGfx::
	INCBIN "gfx/cards/pikachu2.2bpp"
	INCBIN "gfx/cards/pikachu2.pal"

PikachuLv16CardGfx::
	INCBIN "gfx/cards/pikachu3.2bpp"
	INCBIN "gfx/cards/pikachu3.pal"

PikachuAltLv16CardGfx::
	INCBIN "gfx/cards/pikachu4.2bpp"
	INCBIN "gfx/cards/pikachu4.pal"

FlyingPikachuCardGfx::
	INCBIN "gfx/cards/flyingpikachu.2bpp"
	INCBIN "gfx/cards/flyingpikachu.pal"

SurfingPikachuLv13CardGfx::
	INCBIN "gfx/cards/surfingpikachu1.2bpp"
	INCBIN "gfx/cards/surfingpikachu1.pal"

SurfingPikachuAltLv13CardGfx::
	INCBIN "gfx/cards/surfingpikachu2.2bpp"
	INCBIN "gfx/cards/surfingpikachu2.pal"

RaichuLv40CardGfx::
	INCBIN "gfx/cards/raichu1.2bpp"
	INCBIN "gfx/cards/raichu1.pal"

RaichuLv45CardGfx::
	INCBIN "gfx/cards/raichu2.2bpp"
	INCBIN "gfx/cards/raichu2.pal"

MagnemiteLv13CardGfx::
	INCBIN "gfx/cards/magnemite1.2bpp"
	INCBIN "gfx/cards/magnemite1.pal"

	ds $58

SECTION "Card Gfx 6", ROMX

MagnemiteLv15CardGfx::
	INCBIN "gfx/cards/magnemite2.2bpp"
	INCBIN "gfx/cards/magnemite2.pal"

MagnetonLv28CardGfx::
	INCBIN "gfx/cards/magneton1.2bpp"
	INCBIN "gfx/cards/magneton1.pal"

MagnetonLv35CardGfx::
	INCBIN "gfx/cards/magneton2.2bpp"
	INCBIN "gfx/cards/magneton2.pal"

VoltorbCardGfx::
	INCBIN "gfx/cards/voltorb.2bpp"
	INCBIN "gfx/cards/voltorb.pal"

ElectrodeLv35CardGfx::
	INCBIN "gfx/cards/electrode1.2bpp"
	INCBIN "gfx/cards/electrode1.pal"

ElectrodeLv42CardGfx::
	INCBIN "gfx/cards/electrode2.2bpp"
	INCBIN "gfx/cards/electrode2.pal"

ElectabuzzLv20CardGfx::
	INCBIN "gfx/cards/electabuzz1.2bpp"
	INCBIN "gfx/cards/electabuzz1.pal"

ElectabuzzLv35CardGfx::
	INCBIN "gfx/cards/electabuzz2.2bpp"
	INCBIN "gfx/cards/electabuzz2.pal"

JolteonLv24CardGfx::
	INCBIN "gfx/cards/jolteon1.2bpp"
	INCBIN "gfx/cards/jolteon1.pal"

JolteonLv29CardGfx::
	INCBIN "gfx/cards/jolteon2.2bpp"
	INCBIN "gfx/cards/jolteon2.pal"

ZapdosLv40CardGfx::
	INCBIN "gfx/cards/zapdos1.2bpp"
	INCBIN "gfx/cards/zapdos1.pal"

ZapdosLv64CardGfx::
	INCBIN "gfx/cards/zapdos2.2bpp"
	INCBIN "gfx/cards/zapdos2.pal"

ZapdosLv68CardGfx::
	INCBIN "gfx/cards/zapdos3.2bpp"
	INCBIN "gfx/cards/zapdos3.pal"

SandshrewCardGfx::
	INCBIN "gfx/cards/sandshrew.2bpp"
	INCBIN "gfx/cards/sandshrew.pal"

SandslashCardGfx::
	INCBIN "gfx/cards/sandslash.2bpp"
	INCBIN "gfx/cards/sandslash.pal"

DiglettCardGfx::
	INCBIN "gfx/cards/diglett.2bpp"
	INCBIN "gfx/cards/diglett.pal"

DugtrioCardGfx::
	INCBIN "gfx/cards/dugtrio.2bpp"
	INCBIN "gfx/cards/dugtrio.pal"

MankeyCardGfx::
	INCBIN "gfx/cards/mankey.2bpp"
	INCBIN "gfx/cards/mankey.pal"

PrimeapeCardGfx::
	INCBIN "gfx/cards/primeape.2bpp"
	INCBIN "gfx/cards/primeape.pal"

MachopCardGfx::
	INCBIN "gfx/cards/machop.2bpp"
	INCBIN "gfx/cards/machop.pal"

MachokeCardGfx::
	INCBIN "gfx/cards/machoke.2bpp"
	INCBIN "gfx/cards/machoke.pal"

	ds $58

SECTION "Card Gfx 7", ROMX

MachampCardGfx::
	INCBIN "gfx/cards/machamp.2bpp"
	INCBIN "gfx/cards/machamp.pal"

GeodudeCardGfx::
	INCBIN "gfx/cards/geodude.2bpp"
	INCBIN "gfx/cards/geodude.pal"

GravelerCardGfx::
	INCBIN "gfx/cards/graveler.2bpp"
	INCBIN "gfx/cards/graveler.pal"

GolemCardGfx::
	INCBIN "gfx/cards/golem.2bpp"
	INCBIN "gfx/cards/golem.pal"

OnixCardGfx::
	INCBIN "gfx/cards/onix.2bpp"
	INCBIN "gfx/cards/onix.pal"

CuboneCardGfx::
	INCBIN "gfx/cards/cubone.2bpp"
	INCBIN "gfx/cards/cubone.pal"

MarowakLv26CardGfx::
	INCBIN "gfx/cards/marowak1.2bpp"
	INCBIN "gfx/cards/marowak1.pal"

MarowakLv32CardGfx::
	INCBIN "gfx/cards/marowak2.2bpp"
	INCBIN "gfx/cards/marowak2.pal"

HitmonleeCardGfx::
	INCBIN "gfx/cards/hitmonlee.2bpp"
	INCBIN "gfx/cards/hitmonlee.pal"

HitmonchanCardGfx::
	INCBIN "gfx/cards/hitmonchan.2bpp"
	INCBIN "gfx/cards/hitmonchan.pal"

RhyhornCardGfx::
	INCBIN "gfx/cards/rhyhorn.2bpp"
	INCBIN "gfx/cards/rhyhorn.pal"

RhydonCardGfx::
	INCBIN "gfx/cards/rhydon.2bpp"
	INCBIN "gfx/cards/rhydon.pal"

KabutoCardGfx::
	INCBIN "gfx/cards/kabuto.2bpp"
	INCBIN "gfx/cards/kabuto.pal"

KabutopsCardGfx::
	INCBIN "gfx/cards/kabutops.2bpp"
	INCBIN "gfx/cards/kabutops.pal"

AerodactylCardGfx::
	INCBIN "gfx/cards/aerodactyl.2bpp"
	INCBIN "gfx/cards/aerodactyl.pal"

AbraCardGfx::
	INCBIN "gfx/cards/abra.2bpp"
	INCBIN "gfx/cards/abra.pal"

KadabraCardGfx::
	INCBIN "gfx/cards/kadabra.2bpp"
	INCBIN "gfx/cards/kadabra.pal"

AlakazamCardGfx::
	INCBIN "gfx/cards/alakazam.2bpp"
	INCBIN "gfx/cards/alakazam.pal"

SlowpokeLv9CardGfx::
	INCBIN "gfx/cards/slowpoke1.2bpp"
	INCBIN "gfx/cards/slowpoke1.pal"

SlowpokeLv18CardGfx::
	INCBIN "gfx/cards/slowpoke2.2bpp"
	INCBIN "gfx/cards/slowpoke2.pal"

SlowbroCardGfx::
	INCBIN "gfx/cards/slowbro.2bpp"
	INCBIN "gfx/cards/slowbro.pal"

	ds $58

SECTION "Card Gfx 8", ROMX

GastlyLv8CardGfx::
	INCBIN "gfx/cards/gastly1.2bpp"
	INCBIN "gfx/cards/gastly1.pal"

GastlyLv17CardGfx::
	INCBIN "gfx/cards/gastly2.2bpp"
	INCBIN "gfx/cards/gastly2.pal"

HaunterLv17CardGfx::
	INCBIN "gfx/cards/haunter1.2bpp"
	INCBIN "gfx/cards/haunter1.pal"

HaunterLv22CardGfx::
	INCBIN "gfx/cards/haunter2.2bpp"
	INCBIN "gfx/cards/haunter2.pal"

GengarCardGfx::
	INCBIN "gfx/cards/gengar.2bpp"
	INCBIN "gfx/cards/gengar.pal"

DrowzeeCardGfx::
	INCBIN "gfx/cards/drowzee.2bpp"
	INCBIN "gfx/cards/drowzee.pal"

HypnoCardGfx::
	INCBIN "gfx/cards/hypno.2bpp"
	INCBIN "gfx/cards/hypno.pal"

MrMimeCardGfx::
	INCBIN "gfx/cards/mrmime.2bpp"
	INCBIN "gfx/cards/mrmime.pal"

JynxCardGfx::
	INCBIN "gfx/cards/jynx.2bpp"
	INCBIN "gfx/cards/jynx.pal"

MewtwoLv53CardGfx::
	INCBIN "gfx/cards/mewtwo1.2bpp"
	INCBIN "gfx/cards/mewtwo1.pal"

MewtwoLv60CardGfx::
	INCBIN "gfx/cards/mewtwo2.2bpp"
	INCBIN "gfx/cards/mewtwo2.pal"

MewtwoAltLV60CardGfx::
	INCBIN "gfx/cards/mewtwo3.2bpp"
	INCBIN "gfx/cards/mewtwo3.pal"

MewLv8CardGfx::
	INCBIN "gfx/cards/mew1.2bpp"
	INCBIN "gfx/cards/mew1.pal"

MewLv15CardGfx::
	INCBIN "gfx/cards/mew2.2bpp"
	INCBIN "gfx/cards/mew2.pal"

MewLv23CardGfx::
	INCBIN "gfx/cards/mew3.2bpp"
	INCBIN "gfx/cards/mew3.pal"

PidgeyCardGfx::
	INCBIN "gfx/cards/pidgey.2bpp"
	INCBIN "gfx/cards/pidgey.pal"

PidgeottoCardGfx::
	INCBIN "gfx/cards/pidgeotto.2bpp"
	INCBIN "gfx/cards/pidgeotto.pal"

Pidgeot1CardGfx::
	INCBIN "gfx/cards/pidgeot1.2bpp"
	INCBIN "gfx/cards/pidgeot1.pal"

Pidgeot2CardGfx::
	INCBIN "gfx/cards/pidgeot2.2bpp"
	INCBIN "gfx/cards/pidgeot2.pal"

RattataCardGfx::
	INCBIN "gfx/cards/rattata.2bpp"
	INCBIN "gfx/cards/rattata.pal"

RaticateCardGfx::
	INCBIN "gfx/cards/raticate.2bpp"
	INCBIN "gfx/cards/raticate.pal"

	ds $58

SECTION "Card Gfx 9", ROMX

SpearowCardGfx::
	INCBIN "gfx/cards/spearow.2bpp"
	INCBIN "gfx/cards/spearow.pal"

FearowCardGfx::
	INCBIN "gfx/cards/fearow.2bpp"
	INCBIN "gfx/cards/fearow.pal"

ClefairyCardGfx::
	INCBIN "gfx/cards/clefairy.2bpp"
	INCBIN "gfx/cards/clefairy.pal"

ClefableCardGfx::
	INCBIN "gfx/cards/clefable.2bpp"
	INCBIN "gfx/cards/clefable.pal"

JigglypuffLv12CardGfx::
	INCBIN "gfx/cards/jigglypuff1.2bpp"
	INCBIN "gfx/cards/jigglypuff1.pal"

JigglypuffLv13CardGfx::
	INCBIN "gfx/cards/jigglypuff2.2bpp"
	INCBIN "gfx/cards/jigglypuff2.pal"

JigglypuffLv14CardGfx::
	INCBIN "gfx/cards/jigglypuff3.2bpp"
	INCBIN "gfx/cards/jigglypuff3.pal"

WigglytuffCardGfx::
	INCBIN "gfx/cards/wigglytuff.2bpp"
	INCBIN "gfx/cards/wigglytuff.pal"

MeowthLv14CardGfx::
	INCBIN "gfx/cards/meowth1.2bpp"
	INCBIN "gfx/cards/meowth1.pal"

MeowthLv15CardGfx::
	INCBIN "gfx/cards/meowth2.2bpp"
	INCBIN "gfx/cards/meowth2.pal"

PersianCardGfx::
	INCBIN "gfx/cards/persian.2bpp"
	INCBIN "gfx/cards/persian.pal"

FarfetchdCardGfx::
	INCBIN "gfx/cards/farfetchd.2bpp"
	INCBIN "gfx/cards/farfetchd.pal"

DoduoCardGfx::
	INCBIN "gfx/cards/doduo.2bpp"
	INCBIN "gfx/cards/doduo.pal"

DodrioCardGfx::
	INCBIN "gfx/cards/dodrio.2bpp"
	INCBIN "gfx/cards/dodrio.pal"

LickitungCardGfx::
	INCBIN "gfx/cards/lickitung.2bpp"
	INCBIN "gfx/cards/lickitung.pal"

ChanseyCardGfx::
	INCBIN "gfx/cards/chansey.2bpp"
	INCBIN "gfx/cards/chansey.pal"

KangaskhanCardGfx::
	INCBIN "gfx/cards/kangaskhan.2bpp"
	INCBIN "gfx/cards/kangaskhan.pal"

TaurosCardGfx::
	INCBIN "gfx/cards/tauros.2bpp"
	INCBIN "gfx/cards/tauros.pal"

DittoCardGfx::
	INCBIN "gfx/cards/ditto.2bpp"
	INCBIN "gfx/cards/ditto.pal"

EeveeCardGfx::
	INCBIN "gfx/cards/eevee.2bpp"
	INCBIN "gfx/cards/eevee.pal"

PorygonCardGfx::
	INCBIN "gfx/cards/porygon.2bpp"
	INCBIN "gfx/cards/porygon.pal"

	ds $58

SECTION "Card Gfx 10", ROMX

SnorlaxCardGfx::
	INCBIN "gfx/cards/snorlax.2bpp"
	INCBIN "gfx/cards/snorlax.pal"

DratiniCardGfx::
	INCBIN "gfx/cards/dratini.2bpp"
	INCBIN "gfx/cards/dratini.pal"

DragonairCardGfx::
	INCBIN "gfx/cards/dragonair.2bpp"
	INCBIN "gfx/cards/dragonair.pal"

DragoniteLv41CardGfx::
	INCBIN "gfx/cards/dragonite1.2bpp"
	INCBIN "gfx/cards/dragonite1.pal"

DragoniteLv45CardGfx::
	INCBIN "gfx/cards/dragonite2.2bpp"
	INCBIN "gfx/cards/dragonite2.pal"

ProfessorOakCardGfx::
	INCBIN "gfx/cards/professoroak.2bpp"
	INCBIN "gfx/cards/professoroak.pal"

ImposterProfessorOakCardGfx::
	INCBIN "gfx/cards/imposterprofessoroak.2bpp"
	INCBIN "gfx/cards/imposterprofessoroak.pal"

BillCardGfx::
	INCBIN "gfx/cards/bill.2bpp"
	INCBIN "gfx/cards/bill.pal"

MrFujiCardGfx::
	INCBIN "gfx/cards/mrfuji.2bpp"
	INCBIN "gfx/cards/mrfuji.pal"

LassCardGfx::
	INCBIN "gfx/cards/lass.2bpp"
	INCBIN "gfx/cards/lass.pal"

ImakuniCardGfx::
	INCBIN "gfx/cards/imakuni.2bpp"
	INCBIN "gfx/cards/imakuni.pal"

PokemonTraderCardGfx::
	INCBIN "gfx/cards/pokemontrader.2bpp"
	INCBIN "gfx/cards/pokemontrader.pal"

PokemonBreederCardGfx::
	INCBIN "gfx/cards/pokemonbreeder.2bpp"
	INCBIN "gfx/cards/pokemonbreeder.pal"

ClefairyDollCardGfx::
	INCBIN "gfx/cards/clefairydoll.2bpp"
	INCBIN "gfx/cards/clefairydoll.pal"

MysteriousFossilCardGfx::
	INCBIN "gfx/cards/mysteriousfossil.2bpp"
	INCBIN "gfx/cards/mysteriousfossil.pal"

EnergyRetrievalCardGfx::
	INCBIN "gfx/cards/energyretrieval.2bpp"
	INCBIN "gfx/cards/energyretrieval.pal"

SuperEnergyRetrievalCardGfx::
	INCBIN "gfx/cards/superenergyretrieval.2bpp"
	INCBIN "gfx/cards/superenergyretrieval.pal"

EnergySearchCardGfx::
	INCBIN "gfx/cards/energysearch.2bpp"
	INCBIN "gfx/cards/energysearch.pal"

EnergyRemovalCardGfx::
	INCBIN "gfx/cards/energyremoval.2bpp"
	INCBIN "gfx/cards/energyremoval.pal"

SuperEnergyRemovalCardGfx::
	INCBIN "gfx/cards/superenergyremoval.2bpp"
	INCBIN "gfx/cards/superenergyremoval.pal"

SwitchCardGfx::
	INCBIN "gfx/cards/switch.2bpp"
	INCBIN "gfx/cards/switch.pal"

	ds $58

SECTION "Card Gfx 11", ROMX

PokemonCenterCardGfx::
	INCBIN "gfx/cards/pokemoncenter.2bpp"
	INCBIN "gfx/cards/pokemoncenter.pal"

PokeBallCardGfx::
	INCBIN "gfx/cards/pokeball.2bpp"
	INCBIN "gfx/cards/pokeball.pal"

ScoopUpCardGfx::
	INCBIN "gfx/cards/scoopup.2bpp"
	INCBIN "gfx/cards/scoopup.pal"

ComputerSearchCardGfx::
	INCBIN "gfx/cards/computersearch.2bpp"
	INCBIN "gfx/cards/computersearch.pal"

PokedexCardGfx::
	INCBIN "gfx/cards/pokedex.2bpp"
	INCBIN "gfx/cards/pokedex.pal"

PlusPowerCardGfx::
	INCBIN "gfx/cards/pluspower.2bpp"
	INCBIN "gfx/cards/pluspower.pal"

DefenderCardGfx::
	INCBIN "gfx/cards/defender.2bpp"
	INCBIN "gfx/cards/defender.pal"

ItemFinderCardGfx::
	INCBIN "gfx/cards/itemfinder.2bpp"
	INCBIN "gfx/cards/itemfinder.pal"

GustOfWindCardGfx::
	INCBIN "gfx/cards/gustofwind.2bpp"
	INCBIN "gfx/cards/gustofwind.pal"

DevolutionSprayCardGfx::
	INCBIN "gfx/cards/devolutionspray.2bpp"
	INCBIN "gfx/cards/devolutionspray.pal"

PotionCardGfx::
	INCBIN "gfx/cards/potion.2bpp"
	INCBIN "gfx/cards/potion.pal"

SuperPotionCardGfx::
	INCBIN "gfx/cards/superpotion.2bpp"
	INCBIN "gfx/cards/superpotion.pal"

FullHealCardGfx::
	INCBIN "gfx/cards/fullheal.2bpp"
	INCBIN "gfx/cards/fullheal.pal"

ReviveCardGfx::
	INCBIN "gfx/cards/revive.2bpp"
	INCBIN "gfx/cards/revive.pal"

MaintenanceCardGfx::
	INCBIN "gfx/cards/maintenance.2bpp"
	INCBIN "gfx/cards/maintenance.pal"

PokemonFluteCardGfx::
	INCBIN "gfx/cards/pokemonflute.2bpp"
	INCBIN "gfx/cards/pokemonflute.pal"

GamblerCardGfx::
	INCBIN "gfx/cards/gambler.2bpp"
	INCBIN "gfx/cards/gambler.pal"

RecycleCardGfx::
	INCBIN "gfx/cards/recycle.2bpp"
	INCBIN "gfx/cards/recycle.pal"
