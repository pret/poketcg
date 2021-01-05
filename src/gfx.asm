INCLUDE "macros.asm"
INCLUDE "constants.asm"

SECTION "Gfx 1", ROMX

Fonts::

FullWidthFonts:: ; 74000 (1d:4000)
INCBIN "gfx/fonts/full_width/0_0_katakana.1bpp"
INCBIN "gfx/fonts/full_width/0_1_hiragana.1bpp"
INCBIN "gfx/fonts/full_width/0_2_digits_kanji1.1bpp"
INCBIN "gfx/fonts/full_width/1_kanji2.1bpp"
INCBIN "gfx/fonts/full_width/2_kanji3.1bpp"
INCBIN "gfx/fonts/full_width/3.1bpp"
INCBIN "gfx/fonts/full_width/4.1bpp"

HalfWidthFont:: ; 76668 (1d:6668)
INCBIN "gfx/fonts/half_width.1bpp"

SymbolsFont:: ; 76968 (1d:6968)
INCBIN "gfx/fonts/symbols.2bpp"

DuelGraphics::

DuelCardHeaderGraphics:: ; 76ce8 (1d:6ce8)
INCBIN "gfx/duel/card_headers.2bpp"

DuelDmgSgbSymbolGraphics:: ; 76fe8 (1d:6fe8)
INCBIN "gfx/duel/dmg_sgb_symbols.2bpp"

DuelCgbSymbolGraphics:: ; 777f8 (1d:77f8)
INCBIN "gfx/duel/cgb_symbols.2bpp", $0, $808

SECTION "Gfx 2", ROMX

INCBIN "gfx/duel/cgb_symbols.2bpp", $808, $8

DuelOtherGraphics:: ; 78008 (1e:4008)
INCBIN "gfx/duel/other.2bpp"

DuelBoxMessages:: ; 78318 (1e:4318)
INCBIN "gfx/duel/box_messages.2bpp"

rept $2b68
	db $ff
endr

SECTION "Gfx 3", ROMX

	INCROM $84000, $87828

IshiharaTilesetGfx: ; 87828 (21:7828)
	dw $4d
	INCBIN "gfx/tilesets/ishihara.2bpp"

SolidTiles1: ; 87cfa (21:7cfa)
	dw $4
	INCBIN "gfx/solid_tiles.2bpp"

SolidTiles2: ; 87d3c (21:7d3c)
	dw $4
	INCBIN "gfx/solid_tiles.2bpp"

PlayerGfx: ; 87d7e (21:7d7e)
	dw $24
	INCBIN "gfx/duelists/player.2bpp"

Duel55Gfx:: ; 87fc0 (21:7fc0)
	dw $2
	INCBIN "gfx/duel/anims/55.2bpp"

Duel56Gfx:: ; 87fe2 (21:7fe2)
	dw $1
	INCBIN "gfx/duel/anims/56.2bpp"

AnimData12:: ; 87ff4 (21:7ff4)
	frame_table AnimFrameTable3
	frame_data 2, 8, 0, 0
	frame_data 0, 0, 0, 0

	db $ff

SECTION "Gfx 4", ROMX

OverworldMapTiles: ; 88000 (22:4000)
	dw $c1
	INCBIN "gfx/overworld_map.2bpp"

MasonLaboratoryTilesetGfx: ; 88c12 (22:4c12)
	dw $97
	INCBIN "gfx/tilesets/masonlaboratory.2bpp"

ClubEntranceTilesetGfx: ; 89584 (22:5584)
	dw $81
	INCBIN "gfx/tilesets/clubentrance.2bpp"

ClubLobbyTilesetGfx: ; 89d96 (22:5d96)
	dw $78
	INCBIN "gfx/tilesets/clublobby.2bpp"

FightingClubTilesetGfx: ; 8a518 (22:6518)
	dw $63
	INCBIN "gfx/tilesets/fightingclub.2bpp"

RockClubTilesetGfx: ; 8ab4a (22:6b4a)
	dw $3c
	INCBIN "gfx/tilesets/rockclub.2bpp"

WaterClubTilesetGfx: ; 8af0c (22:6f0c)
	dw $a1
	INCBIN "gfx/tilesets/waterclub.2bpp"

GrassClubTilesetGfx: ; 8b91e (22:791e)
	dw $57
	INCBIN "gfx/tilesets/grassclub.2bpp"

OWPlayerGfx:: ; 8be90 (22:7e90)
	dw $14
	INCBIN "gfx/overworld_sprites/player.2bpp"

Duel57Gfx:: ; 8bfd2 (22:7fd2)
	dw $1
	INCBIN "gfx/duel/anims/57.2bpp"

AnimData2:: ; 8bfe4 (22:7fe4)
	frame_table AnimFrameTable0
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0

Palette109:: ; 8bffb (22:7ffb)
	db 1, %11100100
	db 0

rept $2
	db $ff
endr

SECTION "Gfx 5", ROMX

LightningClubTilesetGfx: ; 8c000 (23:4000)
	dw $83
	INCBIN "gfx/tilesets/lightningclub.2bpp"

PsychicClubTilesetGfx: ; 8c832 (23:4832)
	dw $3a
	INCBIN "gfx/tilesets/psychicclub.2bpp"

ScienceClubTilesetGfx: ; 8cbd4 (23:4bd4)
	dw $52
	INCBIN "gfx/tilesets/scienceclub.2bpp"

FireClubTilesetGfx: ; 8d0f6 (23:50f6)
	dw $57
	INCBIN "gfx/tilesets/fireclub.2bpp"

ChallengeHallTilesetGfx: ; 8d668 (23:5668)
	dw $9d
	INCBIN "gfx/tilesets/challengehall.2bpp"

PokemonDomeEntranceTilesetGfx: ; 8e03a (23:603a)
	dw $4e
	INCBIN "gfx/tilesets/pokemondomeentrance.2bpp"

PokemonDomeTilesetGfx: ; 8e51c (23:651c)
	dw $cf
	INCBIN "gfx/tilesets/pokemondome.2bpp"

HallOfHonorTilesetGfx: ; 8f20e (23:720e)
	dw $79
	INCBIN "gfx/tilesets/hallofhonor.2bpp"

MedalGfx: ; 8f9a0 (23:79a0)
	dw $48
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

NintendoGfx: ; 8fe22 (23:7e22)
	dw $18
	INCBIN "gfx/nintendo.2bpp"

Duel58Gfx:: ; 8ffa4 (23:7fa4)
	dw $4
	INCBIN "gfx/duel/anims/58.2bpp"

AnimData3:: ; 8ffe6 (23:7fe6)
	frame_table AnimFrameTable0
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0

AnimData11:: ; 8fff5 (23:7ff5)
	frame_table AnimFrameTable3
	frame_data 1, 8, 0, 0
	frame_data 0, 0, 0, 0

SECTION "Gfx 6", ROMX

CardPop1Gfx: ; 90000 (24:4000)
	dw $bd
	INCBIN "gfx/cardpop/cardpop1.2bpp"

CardPop2Gfx: ; 90bd2 (24:4bd2)
	dw $6d
	INCBIN "gfx/cardpop/cardpop2.2bpp"

CardPop3Gfx: ; 912a4 (24:52a4)
	dw $5d
	INCBIN "gfx/cardpop/cardpop3.2bpp"

Colosseum1Gfx: ; 91876 (24:5876)
	dw $60
	INCBIN "gfx/booster_packs/colosseum1.2bpp"

Colosseum2Gfx: ; 91e78 (24:5e78)
	dw $56
	INCBIN "gfx/booster_packs/colosseum2.2bpp"

Evolution1Gfx: ; 923da (24:63da)
	dw $60
	INCBIN "gfx/booster_packs/evolution1.2bpp"

Evolution2Gfx: ; 929dc (24:69dc)
	dw $56
	INCBIN "gfx/booster_packs/evolution2.2bpp"

Mystery1Gfx: ; 92f3e (24:6f3e)
	dw $60
	INCBIN "gfx/booster_packs/mystery1.2bpp"

Mystery2Gfx: ; 93540 (24:7540)
	dw $56
	INCBIN "gfx/booster_packs/mystery2.2bpp"

RonaldGfx: ; 93aa2 (24:7aa2)
	dw $24
	INCBIN "gfx/duelists/ronald.2bpp"

CopyrightGfx: ; 93ce4 (24:7ce4)
	dw $24
	INCBIN "gfx/copyright.2bpp"

OWClerkGfx:: ; 93f26 (24:7f26)
	dw $8
	INCBIN "gfx/overworld_sprites/clerk.2bpp"

Duel59Gfx:: ; 93fa8 (24:7fa8)
	dw $3
	INCBIN "gfx/duel/anims/59.2bpp"

Duel60Gfx:: ; 93fda (24:7fda)
	dw $2
	INCBIN "gfx/duel/anims/60.2bpp"

rept $4
	db $ff
endr

SECTION "Gfx 7", ROMX

Laboratory1Gfx: ; 94000 (25:4000)
	dw $60
	INCBIN "gfx/booster_packs/laboratory1.2bpp"

Laboratory2Gfx: ; 94602 (25:4602)
	dw $56
	INCBIN "gfx/booster_packs/laboratory2.2bpp"

CharizardIntro1Gfx: ; 94b64 (25:4b64)
	dw $60
	INCBIN "gfx/titlescreen/booster_packs/charizardintro1.2bpp"

CharizardIntro2Gfx: ; 95166 (25:5166)
	dw $60
	INCBIN "gfx/titlescreen/booster_packs/charizardintro2.2bpp"

ScytherIntro1Gfx: ; 95768 (25:5768)
	dw $60
	INCBIN "gfx/titlescreen/booster_packs/scytherintro1.2bpp"

ScytherIntro2Gfx: ; 95d6a (25:5d6a)
	dw $60
	INCBIN "gfx/titlescreen/booster_packs/scytherintro2.2bpp"

AerodactylIntro1Gfx: ; 9636c (25:636c)
	dw $60
	INCBIN "gfx/titlescreen/booster_packs/aerodactylintro1.2bpp"

AerodactylIntro2Gfx: ; 9696e (25:696e)
	dw $60
	INCBIN "gfx/titlescreen/booster_packs/aerodactylintro2.2bpp"

Titlescreen1Gfx: ; 96f70 (25:6f70)
	dw $61
	INCBIN "gfx/titlescreen/titlescreen1.2bpp"

Titlescreen2Gfx: ; 97582 (25:7582)
	dw $61
	INCBIN "gfx/titlescreen/titlescreen2.2bpp"

CompaniesGfx: ; 97b94 (25:7b94)
	dw $31
	INCBIN "gfx/companies.2bpp"

OWRonaldGfx:: ; 97ea6 (25:7ea6)
	dw $14
	INCBIN "gfx/overworld_sprites/ronald.2bpp"

AnimData5:: ; 97fe8 (25:7fe8)
	frame_table AnimFrameTable1
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0

rept $9
	db $ff
endr

SECTION "Gfx 8", ROMX

Titlescreen3Gfx: ; 98000 (26:4000)
	dw $f4
	INCBIN "gfx/titlescreen/titlescreen3.2bpp"

Titlescreen4Gfx: ; 98f42 (26:4f42)
	dw $13b
	INCBIN "gfx/titlescreen/titlescreen4.2bpp"

Titlescreen5Gfx: ; 9a2f4 (26:62f4)
	dw $dc
	INCBIN "gfx/titlescreen/titlescreen5.2bpp"

Titlescreen6Gfx: ; 9b0b6 (26:70b6)
	dw $d4
	INCBIN "gfx/titlescreen/titlescreen6.2bpp"

OWDrMasonGfx:: ; 9bdf8 (26:7df8)
	dw $14
	INCBIN "gfx/overworld_sprites/doctormason.2bpp"

OverworldMapOAMGfx:: ; 9bf3a (26:7f3a)
	dw $8
	INCBIN "gfx/overworld_map_oam.2bpp"

Duel61Gfx:: ; 9bfbc (26:7fbc)
	dw $3
	INCBIN "gfx/duel/anims/61.2bpp"

Duel62Gfx:: ; 9bfee (26:7fee)
	dw $1
	INCBIN "gfx/duel/anims/62.2bpp"

SECTION "Gfx 9", ROMX

SamGfx: ; 9c000 (27:4000)
	dw $24
	INCBIN "gfx/duelists/sam.2bpp"

ImakuniGfx: ; 9c242 (27:4242)
	dw $24
	INCBIN "gfx/duelists/imakuni.2bpp"

NikkiGfx: ; 9c484 (27:4484)
	dw $24
	INCBIN "gfx/duelists/nikki.2bpp"

RickGfx: ; 9c6c6 (27:46c6)
	dw $24
	INCBIN "gfx/duelists/rick.2bpp"

KenGfx: ; 9c908 (27:4908)
	dw $24
	INCBIN "gfx/duelists/ken.2bpp"

AmyGfx: ; 9cb4a (27:4b4a)
	dw $24
	INCBIN "gfx/duelists/amy.2bpp"

IsaacGfx: ; 9cd8c (27:4d8c)
	dw $24
	INCBIN "gfx/duelists/isaac.2bpp"

MitchGfx: ; 9cfce (27:4fce)
	dw $24
	INCBIN "gfx/duelists/mitch.2bpp"

GeneGfx: ; 9d210 (27:5210)
	dw $24
	INCBIN "gfx/duelists/gene.2bpp"

MurrayGfx: ; 9d452 (27:5452)
	dw $24
	INCBIN "gfx/duelists/murray.2bpp"

CourtneyGfx: ; 9d694 (27:5694)
	dw $24
	INCBIN "gfx/duelists/courtney.2bpp"

SteveGfx: ; 9d8d6 (27:58d6)
	dw $24
	INCBIN "gfx/duelists/steve.2bpp"

JackGfx: ; 9db18 (27:5b18)
	dw $24
	INCBIN "gfx/duelists/jack.2bpp"

RodGfx: ; 9dd5a (27:5d5a)
	dw $24
	INCBIN "gfx/duelists/rod.2bpp"

JosephGfx: ; 9df9c (27:5f9c)
	dw $24
	INCBIN "gfx/duelists/joseph.2bpp"

DavidGfx: ; 9e1de (27:61de)
	dw $24
	INCBIN "gfx/duelists/david.2bpp"

ErikGfx: ; 9e420 (27:6420)
	dw $24
	INCBIN "gfx/duelists/erik.2bpp"

JohnGfx: ; 9e662 (27:6662)
	dw $24
	INCBIN "gfx/duelists/john.2bpp"

AdamGfx: ; 9e8a4 (27:68a4)
	dw $24
	INCBIN "gfx/duelists/adam.2bpp"

JonathanGfx: ; 9eae6 (27:6ae6)
	dw $24
	INCBIN "gfx/duelists/jonathan.2bpp"

JoshuaGfx: ; 9ed28 (27:6d28)
	dw $24
	INCBIN "gfx/duelists/joshua.2bpp"

NicholasGfx: ; 9ef6a (27:6f6a)
	dw $24
	INCBIN "gfx/duelists/nicholas.2bpp"

BrandonGfx: ; 9f1ac (27:71ac)
	dw $24
	INCBIN "gfx/duelists/brandon.2bpp"

MatthewGfx: ; 9f3ee (27:73ee)
	dw $24
	INCBIN "gfx/duelists/matthew.2bpp"

RyanGfx: ; 9f630 (27:7630)
	dw $24
	INCBIN "gfx/duelists/ryan.2bpp"

AndrewGfx: ; 9f872 (27:7872)
	dw $24
	INCBIN "gfx/duelists/andrew.2bpp"

ChrisGfx: ; 9fab4 (27:7ab4)
	dw $24
	INCBIN "gfx/duelists/chris.2bpp"

MichaelGfx: ; 9fcf6 (27:7cf6)
	dw $24
	INCBIN "gfx/duelists/michael.2bpp"

Duel63Gfx:: ; 9ff38 (27:7f38)
	dw $a
	INCBIN "gfx/duel/anims/63.2bpp"

Duel64Gfx:: ; 9ffda (27:7fda)
	dw $2
	INCBIN "gfx/duel/anims/64.2bpp"

rept $4
	db $ff
endr

SECTION "Gfx 10", ROMX

DanielGfx: ; a0000 (28:4000)
	dw $24
	INCBIN "gfx/duelists/daniel.2bpp"

RobertGfx: ; a0242 (28:4242)
	dw $24
	INCBIN "gfx/duelists/robert.2bpp"

BrittanyGfx: ; a0484 (28:4484)
	dw $24
	INCBIN "gfx/duelists/brittany.2bpp"

KristinGfx: ; a06c6 (28:46c6)
	dw $24
	INCBIN "gfx/duelists/kristin.2bpp"

HeatherGfx: ; a0908 (28:4908)
	dw $24
	INCBIN "gfx/duelists/heather.2bpp"

SaraGfx: ; a0b4a (28:4b4a)
	dw $24
	INCBIN "gfx/duelists/sara.2bpp"

AmandaGfx: ; a0d8c (28:4d8c)
	dw $24
	INCBIN "gfx/duelists/amanda.2bpp"

JenniferGfx: ; a0fce (28:4fce)
	dw $24
	INCBIN "gfx/duelists/jennifer.2bpp"

JessicaGfx: ; a1210 (28:5210)
	dw $24
	INCBIN "gfx/duelists/jessica.2bpp"

StephanieGfx: ; a1452 (28:5452)
	dw $24
	INCBIN "gfx/duelists/stephanie.2bpp"

AaronGfx: ; a1694 (28:5694)
	dw $24
	INCBIN "gfx/duelists/aaron.2bpp"

OWIshiharaGfx:: ; a18d6 (28:58d6)
	dw $14
	INCBIN "gfx/overworld_sprites/ishihara.2bpp"

OWImakuniGfx:: ; a1a18 (28:5a18)
	dw $14
	INCBIN "gfx/overworld_sprites/imakuni.2bpp"

OWNikkiGfx:: ; a1b5a (28:5b5a)
	dw $14
	INCBIN "gfx/overworld_sprites/nikki.2bpp"

OWRickGfx:: ; a1c9c (28:5c9c)
	dw $14
	INCBIN "gfx/overworld_sprites/rick.2bpp"

OWKenGfx:: ; a1dde (28:5dde)
	dw $14
	INCBIN "gfx/overworld_sprites/ken.2bpp"

OWAmyGfx:: ; a1f20 (28:5f20)
	dw $1b
	INCBIN "gfx/overworld_sprites/amy.2bpp"

OWIsaacGfx:: ; a20d2 (28:60d2)
	dw $14
	INCBIN "gfx/overworld_sprites/isaac.2bpp"

OWMitchGfx:: ; a2214 (28:6214)
	dw $14
	INCBIN "gfx/overworld_sprites/mitch.2bpp"

OWGeneGfx:: ; a2356 (28:6356)
	dw $14
	INCBIN "gfx/overworld_sprites/gene.2bpp"

OWMurrayGfx:: ; a2498 (28:6498)
	dw $14
	INCBIN "gfx/overworld_sprites/murray.2bpp"

OWCourtneyGfx:: ; a25da (28:65da)
	dw $14
	INCBIN "gfx/overworld_sprites/courtney.2bpp"

OWSteveGfx:: ; a271c (28:671c)
	dw $14
	INCBIN "gfx/overworld_sprites/steve.2bpp"

OWJackGfx:: ; a285e (28:685e)
	dw $14
	INCBIN "gfx/overworld_sprites/jack.2bpp"

OWRodGfx:: ; a29a0 (28:69a0)
	dw $14
	INCBIN "gfx/overworld_sprites/rod.2bpp"

OWBoyGfx:: ; a2ae2 (28:6ae2)
	dw $14
	INCBIN "gfx/overworld_sprites/youngster.2bpp"

OWLadGfx:: ; a2c24 (28:6c24)
	dw $14
	INCBIN "gfx/overworld_sprites/lad.2bpp"

OWSpecsGfx:: ; a2d66 (28:6d66)
	dw $14
	INCBIN "gfx/overworld_sprites/specs.2bpp"

OWButchGfx:: ; a2ea8 (28:6ea8)
	dw $14
	INCBIN "gfx/overworld_sprites/butch.2bpp"

OWManiaGfx:: ; a2fea (28:6fea)
	dw $14
	INCBIN "gfx/overworld_sprites/mania.2bpp"

OWJoshuaGfx:: ; a312c (28:712c)
	dw $14
	INCBIN "gfx/overworld_sprites/joshua.2bpp"

OWHoodGfx:: ; a326e (28:726e)
	dw $14
	INCBIN "gfx/overworld_sprites/hood.2bpp"

OWTechGfx:: ; a33b0 (28:73b0)
	dw $14
	INCBIN "gfx/overworld_sprites/tech.2bpp"

OWChapGfx:: ; a34f2 (28:74f2)
	dw $14
	INCBIN "gfx/overworld_sprites/chap.2bpp"

OWManGfx:: ; a3634 (28:7634)
	dw $14
	INCBIN "gfx/overworld_sprites/man.2bpp"

OWPappyGfx:: ; a3776 (28:7776)
	dw $14
	INCBIN "gfx/overworld_sprites/pappy.2bpp"

OWGirlGfx:: ; a38b8 (28:78b8)
	dw $14
	INCBIN "gfx/overworld_sprites/girl.2bpp"

OWLass1Gfx:: ; a39fa (28:79fa)
	dw $14
	INCBIN "gfx/overworld_sprites/lass1.2bpp"

OWLass2Gfx:: ; a3b3c (28:7b3c)
	dw $14
	INCBIN "gfx/overworld_sprites/lass2.2bpp"

OWLass3Gfx:: ; a3c7e (28:7c7e)
	dw $14
	INCBIN "gfx/overworld_sprites/lass3.2bpp"

OWSwimmerGfx:: ; a3dc0 (28:7dc0)
	dw $14
	INCBIN "gfx/overworld_sprites/swimmer.2bpp"

DuelGlowGfx:: ; a3f02 (28:7f02)
	dw $b
	INCBIN "gfx/duel/anims/glow.2bpp"

Duel66Gfx:: ; a3fb4 (28:7fb4)
	dw $4
	INCBIN "gfx/duel/anims/66.2bpp"

Palette117:: ; a3ff6 (28:7ff6)
	db 0
	db 1

	rgb 27, 27, 24
	rgb 31, 31,  0
	rgb 31,  0,  0
	rgb  0,  8, 19

SECTION "Gfx 11", ROMX

OWGalGfx:: ; a4000 (29:4000)
	dw $14
	INCBIN "gfx/overworld_sprites/gal.2bpp"

OWWomanGfx:: ; a4142 (29:4142)
	dw $14
	INCBIN "gfx/overworld_sprites/woman.2bpp"

OWGrannyGfx:: ; a4284 (29:4284)
	dw $14
	INCBIN "gfx/overworld_sprites/granny.2bpp"

Duel0Gfx:: ; a43c6 (29:43c6)
	dw $16
	INCBIN "gfx/duel/anims/0.2bpp"

Duel1Gfx:: ; a4528 (29:4528)
	dw $06
	INCBIN "gfx/duel/anims/1.2bpp"

Duel2Gfx:: ; a458a (29:458a)
	dw $08
	INCBIN "gfx/duel/anims/2.2bpp"

Duel3Gfx:: ; a460c (29:460c)
	dw $09
	INCBIN "gfx/duel/anims/3.2bpp"

Duel4Gfx:: ; a469e (29:469e)
	dw $12
	INCBIN "gfx/duel/anims/4.2bpp"

Duel5Gfx:: ; a47c0 (29:47c0)
	dw $09
	INCBIN "gfx/duel/anims/5.2bpp"

Duel6Gfx:: ; a4852 (29:4852)
	dw $11
	INCBIN "gfx/duel/anims/6.2bpp"

Duel7Gfx:: ; a4964 (29:4964)
	dw $2d
	INCBIN "gfx/duel/anims/7.2bpp"

Duel8Gfx:: ; a4c36 (29:4c36)
	dw $0d
	INCBIN "gfx/duel/anims/8.2bpp"

Duel9Gfx:: ; a4d08 (29:4d08)
	dw $1c
	INCBIN "gfx/duel/anims/9.2bpp"

Duel10Gfx:: ; a4eca (29:4eca)
	dw $4c
	INCBIN "gfx/duel/anims/10.2bpp"

Duel11Gfx:: ; a538c (29:538c)
	dw $1b
	INCBIN "gfx/duel/anims/11.2bpp"

Duel12Gfx:: ; a553e (29:553e)
	dw $07
	INCBIN "gfx/duel/anims/12.2bpp"

Duel13Gfx:: ; a55b0 (29:55b0)
	dw $0c
	INCBIN "gfx/duel/anims/13.2bpp"

Duel14Gfx:: ; a5672 (29:5672)
	dw $22
	INCBIN "gfx/duel/anims/14.2bpp"

Duel15Gfx:: ; a5894 (29:5894)
	dw $20
	INCBIN "gfx/duel/anims/15.2bpp"

Duel16Gfx:: ; a5a96 (29:5a96)
	dw $0a
	INCBIN "gfx/duel/anims/16.2bpp"

Duel17Gfx:: ; a5b38 (29:5b38)
	dw $25
	INCBIN "gfx/duel/anims/17.2bpp"

Duel18Gfx:: ; a5d8a (29:5d8a)
	dw $18
	INCBIN "gfx/duel/anims/18.2bpp"

Duel19Gfx:: ; a5f0c (29:5f0c)
	dw $1b
	INCBIN "gfx/duel/anims/19.2bpp"

Duel20Gfx:: ; a60be (29:60be)
	dw $08
	INCBIN "gfx/duel/anims/20.2bpp"

Duel21Gfx:: ; a6140 (29:6140)
	dw $0d
	INCBIN "gfx/duel/anims/21.2bpp"

Duel22Gfx:: ; a6212 (29:6212)
	dw $22
	INCBIN "gfx/duel/anims/22.2bpp"

Duel23Gfx:: ; a6434 (29:6434)
	dw $0c
	INCBIN "gfx/duel/anims/23.2bpp"

Duel24Gfx:: ; a64f6 (29:64f6)
	dw $25
	INCBIN "gfx/duel/anims/24.2bpp"

Duel25Gfx:: ; a6748 (29:6748)
	dw $22
	INCBIN "gfx/duel/anims/25.2bpp"

Duel26Gfx:: ; a696a (29:696a)
	dw $0c
	INCBIN "gfx/duel/anims/26.2bpp"

Duel27Gfx:: ; a6a2c (29:6a2c)
	dw $4c
	INCBIN "gfx/duel/anims/27.2bpp"

Duel28Gfx:: ; a6eee (29:6eee)
	dw $08
	INCBIN "gfx/duel/anims/28.2bpp"

Duel29Gfx:: ; a6f70 (29:6f70)
	dw $07
	INCBIN "gfx/duel/anims/29.2bpp"

Duel30Gfx:: ; a6fe2 (29:6fe2)
	dw $1a
	INCBIN "gfx/duel/anims/30.2bpp"

Duel31Gfx:: ; a7184 (29:7184)
	dw $0a
	INCBIN "gfx/duel/anims/31.2bpp"

Duel32Gfx:: ; a7226 (29:7226)
	dw $2e
	INCBIN "gfx/duel/anims/32.2bpp"

Duel33Gfx:: ; a7508 (29:7508)
	dw $08
	INCBIN "gfx/duel/anims/33.2bpp"

Duel34Gfx:: ; a758a (29:758a)
	dw $07
	INCBIN "gfx/duel/anims/34.2bpp"

Duel35Gfx:: ; a75fc (29:75fc)
	dw $1c
	INCBIN "gfx/duel/anims/35.2bpp"

Duel36Gfx:: ; a77be (29:77be)
	dw $08
	INCBIN "gfx/duel/anims/36.2bpp"

Duel37Gfx:: ; a7840 (29:7840)
	dw $0b
	INCBIN "gfx/duel/anims/37.2bpp"

Duel38Gfx:: ; a78f2 (29:78f2)
	dw $1c
	INCBIN "gfx/duel/anims/38.2bpp"

Duel39Gfx:: ; a7ab4 (29:7ab4)
	dw $16
	INCBIN "gfx/duel/anims/39.2bpp"

Duel40Gfx:: ; a7c16 (29:7c16)
	dw $10
	INCBIN "gfx/duel/anims/40.2bpp"

Duel41Gfx:: ; a7d18 (29:7d18)
	dw $0f
	INCBIN "gfx/duel/anims/41.2bpp"

Duel42Gfx:: ; a7e0a (29:7e0a)
	dw $07
	INCBIN "gfx/duel/anims/42.2bpp"

Duel43Gfx:: ; a7e7c (29:7e7c)
	dw $0a
	INCBIN "gfx/duel/anims/43.2bpp"

Duel44Gfx:: ; a7f1e (29:7f1e)
	dw $09
	INCBIN "gfx/duel/anims/44.2bpp"

Duel45Gfx:: ; a7fb0 (29:7fb0)
	dw $03
	INCBIN "gfx/duel/anims/45.2bpp"

AnimData6:: ; a7fe2 (29:7fe2)
	frame_table AnimFrameTable1
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0

rept $7
	db $ff
endr

SECTION "Gfx 12", ROMX

Duel46Gfx:: ; a8000 (2a:4000)
	dw $08
	INCBIN "gfx/duel/anims/46.2bpp"

Duel47Gfx:: ; a8082 (2a:4082)
	dw $0f
	INCBIN "gfx/duel/anims/47.2bpp"

Duel48Gfx:: ; a8174 (2a:4174)
	dw $03
	INCBIN "gfx/duel/anims/48.2bpp"

Duel49Gfx:: ; a81a6 (2a:41a6)
	dw $05
	INCBIN "gfx/duel/anims/49.2bpp"

Duel50Gfx:: ; a81f8 (2a:41f8)
	dw $17
	INCBIN "gfx/duel/anims/50.2bpp"

Duel51Gfx:: ; a836a (2a:436a)
	dw $36
	INCBIN "gfx/duel/anims/51.2bpp"

Duel52Gfx:: ; a86cc (2a:46cc)
	dw $0b
	INCBIN "gfx/duel/anims/52.2bpp"

Duel53Gfx:: ; a877e (2a:477e)
	dw $06
	INCBIN "gfx/duel/anims/53.2bpp"

Duel54Gfx:: ; a87e0 (2a:47e0)
	dw $16
	INCBIN "gfx/duel/anims/54.2bpp"

BoosterPackOAMGfx:: ; a8942 (2a:4942)
	dw $20
	INCBIN "gfx/booster_packs/oam.2bpp"

PressStartGfx:: ; a8b44 (2a:4b44)
	dw $14
	INCBIN "gfx/titlescreen/press_start.2bpp"

GrassGfx:: ; a8c86 (2a:4c86)
	dw $04
	INCBIN "gfx/titlescreen/energies/grass.2bpp"

FireGfx:: ; a8cc8 (2a:4cc8)
	dw $04
	INCBIN "gfx/titlescreen/energies/fire.2bpp"

WaterGfx:: ; a8d0a (2a:4d0a)
	dw $04
	INCBIN "gfx/titlescreen/energies/water.2bpp"

ColorlessGfx:: ; a8d4c (2a:4d4c)
	dw $04
	INCBIN "gfx/titlescreen/energies/colorless.2bpp"

LightningGfx:: ; a8d8e (2a:4d8e)
	dw $04
	INCBIN "gfx/titlescreen/energies/lightning.2bpp"

PsychicGfx:: ; a8dd0 (2a:4dd0)
	dw $04
	INCBIN "gfx/titlescreen/energies/psychic.2bpp"

FightingGfx:: ; a8e12 (2a:4e12)
	dw $04
	INCBIN "gfx/titlescreen/energies/fighting.2bpp"

SECTION "Anims 1", ROMX
	INCLUDE "data/anims1.asm"

	db $ff

SECTION "Anims 2", ROMX
	INCLUDE "data/anims2.asm"

rept $2
	db $ff
endr

SECTION "Anims 3", ROMX
	INCLUDE "data/anims3.asm"

Palette31:: ; b3feb (2c:7feb)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31,  7
	rgb 31, 24,  6
	rgb 11,  3,  0

Palette119:: ; b3ff6 (2c:7ff6)
	db 0
	db 1

	rgb 28, 28, 24
	rgb 28, 16, 12
	rgb 28,  4,  8
	rgb  0,  0,  8

SECTION "Anims 4", ROMX
	INCLUDE "data/anims4.asm"

SECTION "Palettes1", ROMX
	INCLUDE "data/palettes1.asm"

SECTION "Palettes2", ROMX
	INCLUDE "data/palettes2.asm"

rept $3b61
	db $ff
endr

SECTION "Card Gfx 1", ROMX

CardGraphics:: ; c4000 (31:4000)

GrassEnergyCardGfx:: ; c4000 (31:4000)
	INCBIN "gfx/cards/grassenergy.2bpp"
	INCBIN "gfx/cards/grassenergy.pal"

FireEnergyCardGfx:: ; c4308 (31:4308)
	INCBIN "gfx/cards/fireenergy.2bpp"
	INCBIN "gfx/cards/fireenergy.pal"

WaterEnergyCardGfx:: ; c4610 (31:4610)
	INCBIN "gfx/cards/waterenergy.2bpp"
	INCBIN "gfx/cards/waterenergy.pal"

LightningEnergyCardGfx:: ; c4918 (31:4918)
	INCBIN "gfx/cards/lightningenergy.2bpp"
	INCBIN "gfx/cards/lightningenergy.pal"

FightingEnergyCardGfx:: ; c4c20 (31:4c20)
	INCBIN "gfx/cards/fightingenergy.2bpp"
	INCBIN "gfx/cards/fightingenergy.pal"

PsychicEnergyCardGfx:: ; c4f28 (31:4f28)
	INCBIN "gfx/cards/psychicenergy.2bpp"
	INCBIN "gfx/cards/psychicenergy.pal"

DoubleColorlessEnergyCardGfx:: ; c5230 (31:5230)
	INCBIN "gfx/cards/doublecolorlessenergy.2bpp"
	INCBIN "gfx/cards/doublecolorlessenergy.pal"

BulbasaurCardGfx:: ; c5538 (31:5538)
	INCBIN "gfx/cards/bulbasaur.2bpp"
	INCBIN "gfx/cards/bulbasaur.pal"

IvysaurCardGfx:: ; c5840 (31:5840)
	INCBIN "gfx/cards/ivysaur.2bpp"
	INCBIN "gfx/cards/ivysaur.pal"

Venusaur1CardGfx:: ; c5b48 (31:5b48)
	INCBIN "gfx/cards/venusaur1.2bpp"
	INCBIN "gfx/cards/venusaur1.pal"

Venusaur2CardGfx:: ; c5e50 (31:5e50)
	INCBIN "gfx/cards/venusaur2.2bpp"
	INCBIN "gfx/cards/venusaur2.pal"

CaterpieCardGfx:: ; c6158 (31:6158)
	INCBIN "gfx/cards/caterpie.2bpp"
	INCBIN "gfx/cards/caterpie.pal"

MetapodCardGfx:: ; c6460 (31:6460)
	INCBIN "gfx/cards/metapod.2bpp"
	INCBIN "gfx/cards/metapod.pal"

ButterfreeCardGfx:: ; c6768 (31:6768)
	INCBIN "gfx/cards/butterfree.2bpp"
	INCBIN "gfx/cards/butterfree.pal"

WeedleCardGfx:: ; c6a70 (31:6a70)
	INCBIN "gfx/cards/weedle.2bpp"
	INCBIN "gfx/cards/weedle.pal"

KakunaCardGfx:: ; c6d78 (31:6d78)
	INCBIN "gfx/cards/kakuna.2bpp"
	INCBIN "gfx/cards/kakuna.pal"

BeedrillCardGfx:: ; c7080 (31:7080)
	INCBIN "gfx/cards/beedrill.2bpp"
	INCBIN "gfx/cards/beedrill.pal"

EkansCardGfx:: ; c7388 (31:7388)
	INCBIN "gfx/cards/ekans.2bpp"
	INCBIN "gfx/cards/ekans.pal"

ArbokCardGfx:: ; c7690 (31:7690)
	INCBIN "gfx/cards/arbok.2bpp"
	INCBIN "gfx/cards/arbok.pal"

NidoranFCardGfx:: ; c7998 (31:7998)
	INCBIN "gfx/cards/nidoranf.2bpp"
	INCBIN "gfx/cards/nidoranf.pal"

NidorinaCardGfx:: ; c7ca0 (31:7ca0)
	INCBIN "gfx/cards/nidorina.2bpp"
	INCBIN "gfx/cards/nidorina.pal"

SECTION "Card Gfx 2", ROMX

NidoqueenCardGfx:: ; c8000 (32:4000)
	INCBIN "gfx/cards/nidoqueen.2bpp"
	INCBIN "gfx/cards/nidoqueen.pal"

NidoranMCardGfx:: ; c8308 (32:4308)
	INCBIN "gfx/cards/nidoranm.2bpp"
	INCBIN "gfx/cards/nidoranm.pal"

NidorinoCardGfx:: ; c8610 (32:4610)
	INCBIN "gfx/cards/nidorino.2bpp"
	INCBIN "gfx/cards/nidorino.pal"

NidokingCardGfx:: ; c8918 (32:4918)
	INCBIN "gfx/cards/nidoking.2bpp"
	INCBIN "gfx/cards/nidoking.pal"

ZubatCardGfx:: ; c8c20 (32:4c20)
	INCBIN "gfx/cards/zubat.2bpp"
	INCBIN "gfx/cards/zubat.pal"

GolbatCardGfx:: ; c8f28 (32:4f28)
	INCBIN "gfx/cards/golbat.2bpp"
	INCBIN "gfx/cards/golbat.pal"

OddishCardGfx:: ; c9230 (32:5230)
	INCBIN "gfx/cards/oddish.2bpp"
	INCBIN "gfx/cards/oddish.pal"

GloomCardGfx:: ; c9538 (32:5538)
	INCBIN "gfx/cards/gloom.2bpp"
	INCBIN "gfx/cards/gloom.pal"

VileplumeCardGfx:: ; c9840 (32:5840)
	INCBIN "gfx/cards/vileplume.2bpp"
	INCBIN "gfx/cards/vileplume.pal"

ParasCardGfx:: ; c9b48 (32:5b48)
	INCBIN "gfx/cards/paras.2bpp"
	INCBIN "gfx/cards/paras.pal"

ParasectCardGfx:: ; c9e50 (32:5e50)
	INCBIN "gfx/cards/parasect.2bpp"
	INCBIN "gfx/cards/parasect.pal"

VenonatCardGfx:: ; ca158 (32:6158)
	INCBIN "gfx/cards/venonat.2bpp"
	INCBIN "gfx/cards/venonat.pal"

VenomothCardGfx:: ; ca460 (32:6460)
	INCBIN "gfx/cards/venomoth.2bpp"
	INCBIN "gfx/cards/venomoth.pal"

BellsproutCardGfx:: ; ca768 (32:6768)
	INCBIN "gfx/cards/bellsprout.2bpp"
	INCBIN "gfx/cards/bellsprout.pal"

WeepinbellCardGfx:: ; caa70 (32:6a70)
	INCBIN "gfx/cards/weepinbell.2bpp"
	INCBIN "gfx/cards/weepinbell.pal"

VictreebelCardGfx:: ; cad78 (32:6d78)
	INCBIN "gfx/cards/victreebel.2bpp"
	INCBIN "gfx/cards/victreebel.pal"

GrimerCardGfx:: ; cb080 (32:7080)
	INCBIN "gfx/cards/grimer.2bpp"
	INCBIN "gfx/cards/grimer.pal"

MukCardGfx:: ; cb388 (32:7388)
	INCBIN "gfx/cards/muk.2bpp"
	INCBIN "gfx/cards/muk.pal"

ExeggcuteCardGfx:: ; cb690 (32:7690)
	INCBIN "gfx/cards/exeggcute.2bpp"
	INCBIN "gfx/cards/exeggcute.pal"

ExeggutorCardGfx:: ; cb998 (32:7998)
	INCBIN "gfx/cards/exeggutor.2bpp"
	INCBIN "gfx/cards/exeggutor.pal"

KoffingCardGfx:: ; cbca0 (32:7ca0)
	INCBIN "gfx/cards/koffing.2bpp"
	INCBIN "gfx/cards/koffing.pal"

SECTION "Card Gfx 3", ROMX

WeezingCardGfx:: ; cc000 (33:4000)
	INCBIN "gfx/cards/weezing.2bpp"
	INCBIN "gfx/cards/weezing.pal"

Tangela1CardGfx:: ; cc308 (33:4308)
	INCBIN "gfx/cards/tangela1.2bpp"
	INCBIN "gfx/cards/tangela1.pal"

Tangela2CardGfx:: ; cc610 (33:4610)
	INCBIN "gfx/cards/tangela2.2bpp"
	INCBIN "gfx/cards/tangela2.pal"

ScytherCardGfx:: ; cc918 (33:4918)
	INCBIN "gfx/cards/scyther.2bpp"
	INCBIN "gfx/cards/scyther.pal"

PinsirCardGfx:: ; ccc20 (33:4c20)
	INCBIN "gfx/cards/pinsir.2bpp"
	INCBIN "gfx/cards/pinsir.pal"

CharmanderCardGfx:: ; ccf28 (33:4f28)
	INCBIN "gfx/cards/charmander.2bpp"
	INCBIN "gfx/cards/charmander.pal"

CharmeleonCardGfx:: ; cd230 (33:5230)
	INCBIN "gfx/cards/charmeleon.2bpp"
	INCBIN "gfx/cards/charmeleon.pal"

CharizardCardGfx:: ; cd538 (33:5538)
	INCBIN "gfx/cards/charizard.2bpp"
	INCBIN "gfx/cards/charizard.pal"

VulpixCardGfx:: ; cd840 (33:5840)
	INCBIN "gfx/cards/vulpix.2bpp"
	INCBIN "gfx/cards/vulpix.pal"

Ninetails1CardGfx:: ; cdb48 (33:5b48)
	INCBIN "gfx/cards/ninetails1.2bpp"
	INCBIN "gfx/cards/ninetails1.pal"

Ninetails2CardGfx:: ; cde50 (33:5e50)
	INCBIN "gfx/cards/ninetails2.2bpp"
	INCBIN "gfx/cards/ninetails2.pal"

GrowlitheCardGfx:: ; ce158 (33:6158)
	INCBIN "gfx/cards/growlithe.2bpp"
	INCBIN "gfx/cards/growlithe.pal"

Arcanine1CardGfx:: ; ce460 (33:6460)
	INCBIN "gfx/cards/arcanine1.2bpp"
	INCBIN "gfx/cards/arcanine1.pal"

Arcanine2CardGfx:: ; ce768 (33:6768)
	INCBIN "gfx/cards/arcanine2.2bpp"
	INCBIN "gfx/cards/arcanine2.pal"

PonytaCardGfx:: ; cea70 (33:6a70)
	INCBIN "gfx/cards/ponyta.2bpp"
	INCBIN "gfx/cards/ponyta.pal"

RapidashCardGfx:: ; ced78 (33:6d78)
	INCBIN "gfx/cards/rapidash.2bpp"
	INCBIN "gfx/cards/rapidash.pal"

Magmar1CardGfx:: ; cf080 (33:7080)
	INCBIN "gfx/cards/magmar1.2bpp"
	INCBIN "gfx/cards/magmar1.pal"

Magmar2CardGfx:: ; cf388 (33:7388)
	INCBIN "gfx/cards/magmar2.2bpp"
	INCBIN "gfx/cards/magmar2.pal"

Flareon1CardGfx:: ; cf690 (33:7690)
	INCBIN "gfx/cards/flareon1.2bpp"
	INCBIN "gfx/cards/flareon1.pal"

Flareon2CardGfx:: ; cf998 (33:7998)
	INCBIN "gfx/cards/flareon2.2bpp"
	INCBIN "gfx/cards/flareon2.pal"

Moltres1CardGfx:: ; cfca0 (33:7ca0)
	INCBIN "gfx/cards/moltres1.2bpp"
	INCBIN "gfx/cards/moltres1.pal"

SECTION "Card Gfx 4", ROMX

Moltres2CardGfx:: ; d0000 (34:4000)
	INCBIN "gfx/cards/moltres2.2bpp"
	INCBIN "gfx/cards/moltres2.pal"

SquirtleCardGfx:: ; d0308 (34:4308)
	INCBIN "gfx/cards/squirtle.2bpp"
	INCBIN "gfx/cards/squirtle.pal"

WartortleCardGfx:: ; d0610 (34:4610)
	INCBIN "gfx/cards/wartortle.2bpp"
	INCBIN "gfx/cards/wartortle.pal"

BlastoiseCardGfx:: ; d0918 (34:4918)
	INCBIN "gfx/cards/blastoise.2bpp"
	INCBIN "gfx/cards/blastoise.pal"

PsyduckCardGfx:: ; d0c20 (34:4c20)
	INCBIN "gfx/cards/psyduck.2bpp"
	INCBIN "gfx/cards/psyduck.pal"

GolduckCardGfx:: ; d0f28 (34:4f28)
	INCBIN "gfx/cards/golduck.2bpp"
	INCBIN "gfx/cards/golduck.pal"

PoliwagCardGfx:: ; d1230 (34:5230)
	INCBIN "gfx/cards/poliwag.2bpp"
	INCBIN "gfx/cards/poliwag.pal"

PoliwhirlCardGfx:: ; d1538 (34:5538)
	INCBIN "gfx/cards/poliwhirl.2bpp"
	INCBIN "gfx/cards/poliwhirl.pal"

PoliwrathCardGfx:: ; d1840 (34:5840)
	INCBIN "gfx/cards/poliwrath.2bpp"
	INCBIN "gfx/cards/poliwrath.pal"

TentacoolCardGfx:: ; d1b48 (34:5b48)
	INCBIN "gfx/cards/tentacool.2bpp"
	INCBIN "gfx/cards/tentacool.pal"

TentacruelCardGfx:: ; d1e50 (34:5e50)
	INCBIN "gfx/cards/tentacruel.2bpp"
	INCBIN "gfx/cards/tentacruel.pal"

SeelCardGfx:: ; d2158 (34:6158)
	INCBIN "gfx/cards/seel.2bpp"
	INCBIN "gfx/cards/seel.pal"

DewgongCardGfx:: ; d2460 (34:6460)
	INCBIN "gfx/cards/dewgong.2bpp"
	INCBIN "gfx/cards/dewgong.pal"

ShellderCardGfx:: ; d2768 (34:6768)
	INCBIN "gfx/cards/shellder.2bpp"
	INCBIN "gfx/cards/shellder.pal"

CloysterCardGfx:: ; d2a70 (34:6a70)
	INCBIN "gfx/cards/cloyster.2bpp"
	INCBIN "gfx/cards/cloyster.pal"

KrabbyCardGfx:: ; d2d78 (34:6d78)
	INCBIN "gfx/cards/krabby.2bpp"
	INCBIN "gfx/cards/krabby.pal"

KinglerCardGfx:: ; d3080 (34:7080)
	INCBIN "gfx/cards/kingler.2bpp"
	INCBIN "gfx/cards/kingler.pal"

HorseaCardGfx:: ; d3388 (34:7388)
	INCBIN "gfx/cards/horsea.2bpp"
	INCBIN "gfx/cards/horsea.pal"

SeadraCardGfx:: ; d3690 (34:7690)
	INCBIN "gfx/cards/seadra.2bpp"
	INCBIN "gfx/cards/seadra.pal"

GoldeenCardGfx:: ; d3998 (34:7998)
	INCBIN "gfx/cards/goldeen.2bpp"
	INCBIN "gfx/cards/goldeen.pal"

SeakingCardGfx:: ; d3ca0 (34:7ca0)
	INCBIN "gfx/cards/seaking.2bpp"
	INCBIN "gfx/cards/seaking.pal"

SECTION "Card Gfx 5", ROMX

StaryuCardGfx:: ; d4000 (35:4000)
	INCBIN "gfx/cards/staryu.2bpp"
	INCBIN "gfx/cards/staryu.pal"

StarmieCardGfx:: ; d4308 (35:4308)
	INCBIN "gfx/cards/starmie.2bpp"
	INCBIN "gfx/cards/starmie.pal"

MagikarpCardGfx:: ; d4610 (35:4610)
	INCBIN "gfx/cards/magikarp.2bpp"
	INCBIN "gfx/cards/magikarp.pal"

GyaradosCardGfx:: ; d4918 (35:4918)
	INCBIN "gfx/cards/gyarados.2bpp"
	INCBIN "gfx/cards/gyarados.pal"

LaprasCardGfx:: ; d4c20 (35:4c20)
	INCBIN "gfx/cards/lapras.2bpp"
	INCBIN "gfx/cards/lapras.pal"

Vaporeon1CardGfx:: ; d4f28 (35:4f28)
	INCBIN "gfx/cards/vaporeon1.2bpp"
	INCBIN "gfx/cards/vaporeon1.pal"

Vaporeon2CardGfx:: ; d5230 (35:5230)
	INCBIN "gfx/cards/vaporeon2.2bpp"
	INCBIN "gfx/cards/vaporeon2.pal"

OmanyteCardGfx:: ; d5538 (35:5538)
	INCBIN "gfx/cards/omanyte.2bpp"
	INCBIN "gfx/cards/omanyte.pal"

OmastarCardGfx:: ; d5840 (35:5840)
	INCBIN "gfx/cards/omastar.2bpp"
	INCBIN "gfx/cards/omastar.pal"

Articuno1CardGfx:: ; d5b48 (35:5b48)
	INCBIN "gfx/cards/articuno1.2bpp"
	INCBIN "gfx/cards/articuno1.pal"

Articuno2CardGfx:: ; d5e50 (35:5e50)
	INCBIN "gfx/cards/articuno2.2bpp"
	INCBIN "gfx/cards/articuno2.pal"

Pikachu1CardGfx:: ; d6158 (35:6158)
	INCBIN "gfx/cards/pikachu1.2bpp"
	INCBIN "gfx/cards/pikachu1.pal"

Pikachu2CardGfx:: ; d6460 (35:6460)
	INCBIN "gfx/cards/pikachu2.2bpp"
	INCBIN "gfx/cards/pikachu2.pal"

Pikachu3CardGfx:: ; d6768 (35:6768)
	INCBIN "gfx/cards/pikachu3.2bpp"
	INCBIN "gfx/cards/pikachu3.pal"

Pikachu4CardGfx:: ; d6a70 (35:6a70)
	INCBIN "gfx/cards/pikachu4.2bpp"
	INCBIN "gfx/cards/pikachu4.pal"

FlyingPikachuCardGfx:: ; d6d78 (35:6d78)
	INCBIN "gfx/cards/flyingpikachu.2bpp"
	INCBIN "gfx/cards/flyingpikachu.pal"

SurfingPikachu1CardGfx:: ; d7080 (35:7080)
	INCBIN "gfx/cards/surfingpikachu1.2bpp"
	INCBIN "gfx/cards/surfingpikachu1.pal"

SurfingPikachu2CardGfx:: ; d7388 (35:7388)
	INCBIN "gfx/cards/surfingpikachu2.2bpp"
	INCBIN "gfx/cards/surfingpikachu2.pal"

Raichu1CardGfx:: ; d7690 (35:7690)
	INCBIN "gfx/cards/raichu1.2bpp"
	INCBIN "gfx/cards/raichu1.pal"

Raichu2CardGfx:: ; d7998 (35:7998)
	INCBIN "gfx/cards/raichu2.2bpp"
	INCBIN "gfx/cards/raichu2.pal"

Magnemite1CardGfx:: ; d7ca0 (35:7ca0)
	INCBIN "gfx/cards/magnemite1.2bpp"
	INCBIN "gfx/cards/magnemite1.pal"

SECTION "Card Gfx 6", ROMX

Magnemite2CardGfx:: ; d8000 (36:4000)
	INCBIN "gfx/cards/magnemite2.2bpp"
	INCBIN "gfx/cards/magnemite2.pal"

Magneton1CardGfx:: ; d8308 (36:4308)
	INCBIN "gfx/cards/magneton1.2bpp"
	INCBIN "gfx/cards/magneton1.pal"

Magneton2CardGfx:: ; d8610 (36:4610)
	INCBIN "gfx/cards/magneton2.2bpp"
	INCBIN "gfx/cards/magneton2.pal"

VoltorbCardGfx:: ; d8918 (36:4918)
	INCBIN "gfx/cards/voltorb.2bpp"
	INCBIN "gfx/cards/voltorb.pal"

Electrode1CardGfx:: ; d8c20 (36:4c20)
	INCBIN "gfx/cards/electrode1.2bpp"
	INCBIN "gfx/cards/electrode1.pal"

Electrode2CardGfx:: ; d8f28 (36:4f28)
	INCBIN "gfx/cards/electrode2.2bpp"
	INCBIN "gfx/cards/electrode2.pal"

Electabuzz1CardGfx:: ; d9230 (36:5230)
	INCBIN "gfx/cards/electabuzz1.2bpp"
	INCBIN "gfx/cards/electabuzz1.pal"

Electabuzz2CardGfx:: ; d9538 (36:5538)
	INCBIN "gfx/cards/electabuzz2.2bpp"
	INCBIN "gfx/cards/electabuzz2.pal"

Jolteon1CardGfx:: ; d9840 (36:5840)
	INCBIN "gfx/cards/jolteon1.2bpp"
	INCBIN "gfx/cards/jolteon1.pal"

Jolteon2CardGfx:: ; d9b48 (36:5b48)
	INCBIN "gfx/cards/jolteon2.2bpp"
	INCBIN "gfx/cards/jolteon2.pal"

Zapdos1CardGfx:: ; d9e50 (36:5e50)
	INCBIN "gfx/cards/zapdos1.2bpp"
	INCBIN "gfx/cards/zapdos1.pal"

Zapdos2CardGfx:: ; da158 (36:6158)
	INCBIN "gfx/cards/zapdos2.2bpp"
	INCBIN "gfx/cards/zapdos2.pal"

Zapdos3CardGfx:: ; da460 (36:6460)
	INCBIN "gfx/cards/zapdos3.2bpp"
	INCBIN "gfx/cards/zapdos3.pal"

SandshrewCardGfx:: ; da768 (36:6768)
	INCBIN "gfx/cards/sandshrew.2bpp"
	INCBIN "gfx/cards/sandshrew.pal"

SandslashCardGfx:: ; daa70 (36:6a70)
	INCBIN "gfx/cards/sandslash.2bpp"
	INCBIN "gfx/cards/sandslash.pal"

DiglettCardGfx:: ; dad78 (36:6d78)
	INCBIN "gfx/cards/diglett.2bpp"
	INCBIN "gfx/cards/diglett.pal"

DugtrioCardGfx:: ; db080 (36:7080)
	INCBIN "gfx/cards/dugtrio.2bpp"
	INCBIN "gfx/cards/dugtrio.pal"

MankeyCardGfx:: ; db388 (36:7388)
	INCBIN "gfx/cards/mankey.2bpp"
	INCBIN "gfx/cards/mankey.pal"

PrimeapeCardGfx:: ; db690 (36:7690)
	INCBIN "gfx/cards/primeape.2bpp"
	INCBIN "gfx/cards/primeape.pal"

MachopCardGfx:: ; db998 (36:7998)
	INCBIN "gfx/cards/machop.2bpp"
	INCBIN "gfx/cards/machop.pal"

MachokeCardGfx:: ; dbca0 (36:7ca0)
	INCBIN "gfx/cards/machoke.2bpp"
	INCBIN "gfx/cards/machoke.pal"

SECTION "Card Gfx 7", ROMX

MachampCardGfx:: ; dc000 (37:4000)
	INCBIN "gfx/cards/machamp.2bpp"
	INCBIN "gfx/cards/machamp.pal"

GeodudeCardGfx:: ; dc308 (37:4308)
	INCBIN "gfx/cards/geodude.2bpp"
	INCBIN "gfx/cards/geodude.pal"

GravelerCardGfx:: ; dc610 (37:4610)
	INCBIN "gfx/cards/graveler.2bpp"
	INCBIN "gfx/cards/graveler.pal"

GolemCardGfx:: ; dc918 (37:4918)
	INCBIN "gfx/cards/golem.2bpp"
	INCBIN "gfx/cards/golem.pal"

OnixCardGfx:: ; dcc20 (37:4c20)
	INCBIN "gfx/cards/onix.2bpp"
	INCBIN "gfx/cards/onix.pal"

CuboneCardGfx:: ; dcf28 (37:4f28)
	INCBIN "gfx/cards/cubone.2bpp"
	INCBIN "gfx/cards/cubone.pal"

Marowak1CardGfx:: ; dd230 (37:5230)
	INCBIN "gfx/cards/marowak1.2bpp"
	INCBIN "gfx/cards/marowak1.pal"

Marowak2CardGfx:: ; dd538 (37:5538)
	INCBIN "gfx/cards/marowak2.2bpp"
	INCBIN "gfx/cards/marowak2.pal"

HitmonleeCardGfx:: ; dd840 (37:5840)
	INCBIN "gfx/cards/hitmonlee.2bpp"
	INCBIN "gfx/cards/hitmonlee.pal"

HitmonchanCardGfx:: ; ddb48 (37:5b48)
	INCBIN "gfx/cards/hitmonchan.2bpp"
	INCBIN "gfx/cards/hitmonchan.pal"

RhyhornCardGfx:: ; dde50 (37:5e50)
	INCBIN "gfx/cards/rhyhorn.2bpp"
	INCBIN "gfx/cards/rhyhorn.pal"

RhydonCardGfx:: ; de158 (37:6158)
	INCBIN "gfx/cards/rhydon.2bpp"
	INCBIN "gfx/cards/rhydon.pal"

KabutoCardGfx:: ; de460 (37:6460)
	INCBIN "gfx/cards/kabuto.2bpp"
	INCBIN "gfx/cards/kabuto.pal"

KabutopsCardGfx:: ; de768 (37:6768)
	INCBIN "gfx/cards/kabutops.2bpp"
	INCBIN "gfx/cards/kabutops.pal"

AerodactylCardGfx:: ; dea70 (37:6a70)
	INCBIN "gfx/cards/aerodactyl.2bpp"
	INCBIN "gfx/cards/aerodactyl.pal"

AbraCardGfx:: ; ded78 (37:6d78)
	INCBIN "gfx/cards/abra.2bpp"
	INCBIN "gfx/cards/abra.pal"

KadabraCardGfx:: ; df080 (37:7080)
	INCBIN "gfx/cards/kadabra.2bpp"
	INCBIN "gfx/cards/kadabra.pal"

AlakazamCardGfx:: ; df388 (37:7388)
	INCBIN "gfx/cards/alakazam.2bpp"
	INCBIN "gfx/cards/alakazam.pal"

Slowpoke1CardGfx:: ; df690 (37:7690)
	INCBIN "gfx/cards/slowpoke1.2bpp"
	INCBIN "gfx/cards/slowpoke1.pal"

Slowpoke2CardGfx:: ; df998 (37:7998)
	INCBIN "gfx/cards/slowpoke2.2bpp"
	INCBIN "gfx/cards/slowpoke2.pal"

SlowbroCardGfx:: ; dfca0 (37:7ca0)
	INCBIN "gfx/cards/slowbro.2bpp"
	INCBIN "gfx/cards/slowbro.pal"

SECTION "Card Gfx 8", ROMX

Gastly1CardGfx:: ; e0000 (38:4000)
	INCBIN "gfx/cards/gastly1.2bpp"
	INCBIN "gfx/cards/gastly1.pal"

Gastly2CardGfx:: ; e0308 (38:4308)
	INCBIN "gfx/cards/gastly2.2bpp"
	INCBIN "gfx/cards/gastly2.pal"

Haunter1CardGfx:: ; e0610 (38:4610)
	INCBIN "gfx/cards/haunter1.2bpp"
	INCBIN "gfx/cards/haunter1.pal"

Haunter2CardGfx:: ; e0918 (38:4918)
	INCBIN "gfx/cards/haunter2.2bpp"
	INCBIN "gfx/cards/haunter2.pal"

GengarCardGfx:: ; e0c20 (38:4c20)
	INCBIN "gfx/cards/gengar.2bpp"
	INCBIN "gfx/cards/gengar.pal"

DrowzeeCardGfx:: ; e0f28 (38:4f28)
	INCBIN "gfx/cards/drowzee.2bpp"
	INCBIN "gfx/cards/drowzee.pal"

HypnoCardGfx:: ; e1230 (38:5230)
	INCBIN "gfx/cards/hypno.2bpp"
	INCBIN "gfx/cards/hypno.pal"

MrMimeCardGfx:: ; e1538 (38:5538)
	INCBIN "gfx/cards/mrmime.2bpp"
	INCBIN "gfx/cards/mrmime.pal"

JynxCardGfx:: ; e1840 (38:5840)
	INCBIN "gfx/cards/jynx.2bpp"
	INCBIN "gfx/cards/jynx.pal"

Mewtwo1CardGfx:: ; e1b48 (38:5b48)
	INCBIN "gfx/cards/mewtwo1.2bpp"
	INCBIN "gfx/cards/mewtwo1.pal"

Mewtwo2CardGfx:: ; e1e50 (38:5e50)
	INCBIN "gfx/cards/mewtwo2.2bpp"
	INCBIN "gfx/cards/mewtwo2.pal"

Mewtwo3CardGfx:: ; e2158 (38:6158)
	INCBIN "gfx/cards/mewtwo3.2bpp"
	INCBIN "gfx/cards/mewtwo3.pal"

Mew1CardGfx:: ; e2460 (38:6460)
	INCBIN "gfx/cards/mew1.2bpp"
	INCBIN "gfx/cards/mew1.pal"

Mew2CardGfx:: ; e2768 (38:6768)
	INCBIN "gfx/cards/mew2.2bpp"
	INCBIN "gfx/cards/mew2.pal"

Mew3CardGfx:: ; e2a70 (38:6a70)
	INCBIN "gfx/cards/mew3.2bpp"
	INCBIN "gfx/cards/mew3.pal"

PidgeyCardGfx:: ; e2d78 (38:6d78)
	INCBIN "gfx/cards/pidgey.2bpp"
	INCBIN "gfx/cards/pidgey.pal"

PidgeottoCardGfx:: ; e3080 (38:7080)
	INCBIN "gfx/cards/pidgeotto.2bpp"
	INCBIN "gfx/cards/pidgeotto.pal"

Pidgeot1CardGfx:: ; e3388 (38:7388)
	INCBIN "gfx/cards/pidgeot1.2bpp"
	INCBIN "gfx/cards/pidgeot1.pal"

Pidgeot2CardGfx:: ; e3690 (38:7690)
	INCBIN "gfx/cards/pidgeot2.2bpp"
	INCBIN "gfx/cards/pidgeot2.pal"

RattataCardGfx:: ; e3998 (38:7998)
	INCBIN "gfx/cards/rattata.2bpp"
	INCBIN "gfx/cards/rattata.pal"

RaticateCardGfx:: ; e3ca0 (38:7ca0)
	INCBIN "gfx/cards/raticate.2bpp"
	INCBIN "gfx/cards/raticate.pal"

SECTION "Card Gfx 9", ROMX

SpearowCardGfx:: ; e4000 (39:4000)
	INCBIN "gfx/cards/spearow.2bpp"
	INCBIN "gfx/cards/spearow.pal"

FearowCardGfx:: ; e4308 (39:4308)
	INCBIN "gfx/cards/fearow.2bpp"
	INCBIN "gfx/cards/fearow.pal"

ClefairyCardGfx:: ; e4610 (39:4610)
	INCBIN "gfx/cards/clefairy.2bpp"
	INCBIN "gfx/cards/clefairy.pal"

ClefableCardGfx:: ; e4918 (39:4918)
	INCBIN "gfx/cards/clefable.2bpp"
	INCBIN "gfx/cards/clefable.pal"

Jigglypuff1CardGfx:: ; e4c20 (39:4c20)
	INCBIN "gfx/cards/jigglypuff1.2bpp"
	INCBIN "gfx/cards/jigglypuff1.pal"

Jigglypuff2CardGfx:: ; e4f28 (39:4f28)
	INCBIN "gfx/cards/jigglypuff2.2bpp"
	INCBIN "gfx/cards/jigglypuff2.pal"

Jigglypuff3CardGfx:: ; e5230 (39:5230)
	INCBIN "gfx/cards/jigglypuff3.2bpp"
	INCBIN "gfx/cards/jigglypuff3.pal"

WigglytuffCardGfx:: ; e5538 (39:5538)
	INCBIN "gfx/cards/wigglytuff.2bpp"
	INCBIN "gfx/cards/wigglytuff.pal"

Meowth1CardGfx:: ; e5840 (39:5840)
	INCBIN "gfx/cards/meowth1.2bpp"
	INCBIN "gfx/cards/meowth1.pal"

Meowth2CardGfx:: ; e5b48 (39:5b48)
	INCBIN "gfx/cards/meowth2.2bpp"
	INCBIN "gfx/cards/meowth2.pal"

PersianCardGfx:: ; e5e50 (39:5e50)
	INCBIN "gfx/cards/persian.2bpp"
	INCBIN "gfx/cards/persian.pal"

FarfetchdCardGfx:: ; e6158 (39:6158)
	INCBIN "gfx/cards/farfetchd.2bpp"
	INCBIN "gfx/cards/farfetchd.pal"

DoduoCardGfx:: ; e6460 (39:6460)
	INCBIN "gfx/cards/doduo.2bpp"
	INCBIN "gfx/cards/doduo.pal"

DodrioCardGfx:: ; e6768 (39:6768)
	INCBIN "gfx/cards/dodrio.2bpp"
	INCBIN "gfx/cards/dodrio.pal"

LickitungCardGfx:: ; e6a70 (39:6a70)
	INCBIN "gfx/cards/lickitung.2bpp"
	INCBIN "gfx/cards/lickitung.pal"

ChanseyCardGfx:: ; e6d78 (39:6d78)
	INCBIN "gfx/cards/chansey.2bpp"
	INCBIN "gfx/cards/chansey.pal"

KangaskhanCardGfx:: ; e7080 (39:7080)
	INCBIN "gfx/cards/kangaskhan.2bpp"
	INCBIN "gfx/cards/kangaskhan.pal"

TaurosCardGfx:: ; e7388 (39:7388)
	INCBIN "gfx/cards/tauros.2bpp"
	INCBIN "gfx/cards/tauros.pal"

DittoCardGfx:: ; e7690 (39:7690)
	INCBIN "gfx/cards/ditto.2bpp"
	INCBIN "gfx/cards/ditto.pal"

EeveeCardGfx:: ; e7998 (39:7998)
	INCBIN "gfx/cards/eevee.2bpp"
	INCBIN "gfx/cards/eevee.pal"

PorygonCardGfx:: ; e7ca0 (39:7ca0)
	INCBIN "gfx/cards/porygon.2bpp"
	INCBIN "gfx/cards/porygon.pal"

SECTION "Card Gfx 10", ROMX

SnorlaxCardGfx:: ; e8000 (3a:4000)
	INCBIN "gfx/cards/snorlax.2bpp"
	INCBIN "gfx/cards/snorlax.pal"

DratiniCardGfx:: ; e8308 (3a:4308)
	INCBIN "gfx/cards/dratini.2bpp"
	INCBIN "gfx/cards/dratini.pal"

DragonairCardGfx:: ; e8610 (3a:4610)
	INCBIN "gfx/cards/dragonair.2bpp"
	INCBIN "gfx/cards/dragonair.pal"

Dragonite1CardGfx:: ; e8918 (3a:4918)
	INCBIN "gfx/cards/dragonite1.2bpp"
	INCBIN "gfx/cards/dragonite1.pal"

Dragonite2CardGfx:: ; e8c20 (3a:4c20)
	INCBIN "gfx/cards/dragonite2.2bpp"
	INCBIN "gfx/cards/dragonite2.pal"

ProfessorOakCardGfx:: ; e8f28 (3a:4f28)
	INCBIN "gfx/cards/professoroak.2bpp"
	INCBIN "gfx/cards/professoroak.pal"

ImposterProfessorOakCardGfx:: ; e9230 (3a:5230)
	INCBIN "gfx/cards/imposterprofessoroak.2bpp"
	INCBIN "gfx/cards/imposterprofessoroak.pal"

BillCardGfx:: ; e9538 (3a:5538)
	INCBIN "gfx/cards/bill.2bpp"
	INCBIN "gfx/cards/bill.pal"

MrFujiCardGfx:: ; e9840 (3a:5840)
	INCBIN "gfx/cards/mrfuji.2bpp"
	INCBIN "gfx/cards/mrfuji.pal"

LassCardGfx:: ; e9b48 (3a:5b48)
	INCBIN "gfx/cards/lass.2bpp"
	INCBIN "gfx/cards/lass.pal"

ImakuniCardGfx:: ; e9e50 (3a:5e50)
	INCBIN "gfx/cards/imakuni.2bpp"
	INCBIN "gfx/cards/imakuni.pal"

PokemonTraderCardGfx:: ; ea158 (3a:6158)
	INCBIN "gfx/cards/pokemontrader.2bpp"
	INCBIN "gfx/cards/pokemontrader.pal"

PokemonBreederCardGfx:: ; ea460 (3a:6460)
	INCBIN "gfx/cards/pokemonbreeder.2bpp"
	INCBIN "gfx/cards/pokemonbreeder.pal"

ClefairyDollCardGfx:: ; ea768 (3a:6768)
	INCBIN "gfx/cards/clefairydoll.2bpp"
	INCBIN "gfx/cards/clefairydoll.pal"

MysteriousFossilCardGfx:: ; eaa70 (3a:6a70)
	INCBIN "gfx/cards/mysteriousfossil.2bpp"
	INCBIN "gfx/cards/mysteriousfossil.pal"

EnergyRetrievalCardGfx:: ; ead78 (3a:6d78)
	INCBIN "gfx/cards/energyretrieval.2bpp"
	INCBIN "gfx/cards/energyretrieval.pal"

SuperEnergyRetrievalCardGfx:: ; eb080 (3a:7080)
	INCBIN "gfx/cards/superenergyretrieval.2bpp"
	INCBIN "gfx/cards/superenergyretrieval.pal"

EnergySearchCardGfx:: ; eb388 (3a:7388)
	INCBIN "gfx/cards/energysearch.2bpp"
	INCBIN "gfx/cards/energysearch.pal"

EnergyRemovalCardGfx:: ; eb690 (3a:7690)
	INCBIN "gfx/cards/energyremoval.2bpp"
	INCBIN "gfx/cards/energyremoval.pal"

SuperEnergyRemovalCardGfx:: ; eb998 (3a:7998)
	INCBIN "gfx/cards/superenergyremoval.2bpp"
	INCBIN "gfx/cards/superenergyremoval.pal"

SwitchCardGfx:: ; ebca0 (3a:7ca0)
	INCBIN "gfx/cards/switch.2bpp"
	INCBIN "gfx/cards/switch.pal"

SECTION "Card Gfx 11", ROMX

PokemonCenterCardGfx:: ; ec000 (3b:4000)
	INCBIN "gfx/cards/pokemoncenter.2bpp"
	INCBIN "gfx/cards/pokemoncenter.pal"

PokeBallCardGfx:: ; ec308 (3b:4308)
	INCBIN "gfx/cards/pokeball.2bpp"
	INCBIN "gfx/cards/pokeball.pal"

ScoopUpCardGfx:: ; ec610 (3b:4610)
	INCBIN "gfx/cards/scoopup.2bpp"
	INCBIN "gfx/cards/scoopup.pal"

ComputerSearchCardGfx:: ; ec918 (3b:4918)
	INCBIN "gfx/cards/computersearch.2bpp"
	INCBIN "gfx/cards/computersearch.pal"

PokedexCardGfx:: ; ecc20 (3b:4c20)
	INCBIN "gfx/cards/pokedex.2bpp"
	INCBIN "gfx/cards/pokedex.pal"

PlusPowerCardGfx:: ; ecf28 (3b:4f28)
	INCBIN "gfx/cards/pluspower.2bpp"
	INCBIN "gfx/cards/pluspower.pal"

DefenderCardGfx:: ; ed230 (3b:5230)
	INCBIN "gfx/cards/defender.2bpp"
	INCBIN "gfx/cards/defender.pal"

ItemFinderCardGfx:: ; ed538 (3b:5538)
	INCBIN "gfx/cards/itemfinder.2bpp"
	INCBIN "gfx/cards/itemfinder.pal"

GustOfWindCardGfx:: ; ed840 (3b:5840)
	INCBIN "gfx/cards/gustofwind.2bpp"
	INCBIN "gfx/cards/gustofwind.pal"

DevolutionSprayCardGfx:: ; edb48 (3b:5b48)
	INCBIN "gfx/cards/devolutionspray.2bpp"
	INCBIN "gfx/cards/devolutionspray.pal"

PotionCardGfx:: ; ede50 (3b:5e50)
	INCBIN "gfx/cards/potion.2bpp"
	INCBIN "gfx/cards/potion.pal"

SuperPotionCardGfx:: ; ee158 (3b:6158)
	INCBIN "gfx/cards/superpotion.2bpp"
	INCBIN "gfx/cards/superpotion.pal"

FullHealCardGfx:: ; ee460 (3b:6460)
	INCBIN "gfx/cards/fullheal.2bpp"
	INCBIN "gfx/cards/fullheal.pal"

ReviveCardGfx:: ; ee768 (3b:6768)
	INCBIN "gfx/cards/revive.2bpp"
	INCBIN "gfx/cards/revive.pal"

MaintenanceCardGfx:: ; eea70 (3b:6a70)
	INCBIN "gfx/cards/maintenance.2bpp"
	INCBIN "gfx/cards/maintenance.pal"

PokemonFluteCardGfx:: ; eed78 (3b:6d78)
	INCBIN "gfx/cards/pokemonflute.2bpp"
	INCBIN "gfx/cards/pokemonflute.pal"

GamblerCardGfx:: ; ef080 (3b:7080)
	INCBIN "gfx/cards/gambler.2bpp"
	INCBIN "gfx/cards/gambler.pal"

RecycleCardGfx:: ; ef388 (3b:7388)
	INCBIN "gfx/cards/recycle.2bpp"
	INCBIN "gfx/cards/recycle.pal"

rept $970
	db $ff
endr
