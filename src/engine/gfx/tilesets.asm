; \1 = pointer
; \2 = number of tiles
MACRO tileset
	dwb \1, BANK(\1) - BANK(Tilesets)
	db \2
ENDM

Tilesets:
	table_width 4, Tilesets
	tileset OverworldMapTiles,             193 ; TILESET_OVERWORLD_MAP
	tileset MasonLaboratoryTilesetGfx,     151 ; TILESET_MASON_LABORATORY
	tileset IshiharaTilesetGfx,             77 ; TILESET_ISHIHARA
	tileset ClubEntranceTilesetGfx,        129 ; TILESET_CLUB_ENTRANCE
	tileset ClubLobbyTilesetGfx,           120 ; TILESET_CLUB_LOBBY
	tileset FightingClubTilesetGfx,         99 ; TILESET_FIGHTING_CLUB
	tileset RockClubTilesetGfx,             60 ; TILESET_ROCK_CLUB
	tileset WaterClubTilesetGfx,           161 ; TILESET_WATER_CLUB
	tileset LightningClubTilesetGfx,       131 ; TILESET_LIGHTNING_CLUB
	tileset GrassClubTilesetGfx,            87 ; TILESET_GRASS_CLUB
	tileset PsychicClubTilesetGfx,          58 ; TILESET_PSYCHIC_CLUB
	tileset ScienceClubTilesetGfx,          82 ; TILESET_SCIENCE_CLUB
	tileset FireClubTilesetGfx,             87 ; TILESET_FIRE_CLUB
	tileset ChallengeHallTilesetGfx,       157 ; TILESET_CHALLENGE_HALL
	tileset PokemonDomeEntranceTilesetGfx,  78 ; TILESET_POKEMON_DOME_ENTRANCE
	tileset PokemonDomeTilesetGfx,         207 ; TILESET_POKEMON_DOME
	tileset HallOfHonorTilesetGfx,         121 ; TILESET_HALL_OF_HONOR
	tileset CardPopGfx,                    189 ; TILESET_CARD_POP
	tileset MedalGfx,                       72 ; TILESET_MEDAL
	tileset GameBoyLinkGfx,                109 ; TILESET_GAMEBOY_LINK
	tileset GameBoyPrinterGfx,              93 ; TILESET_GAMEBOY_PRINTER
	tileset Colosseum1Gfx,                  96 ; TILESET_COLOSSEUM_1
	tileset Colosseum2Gfx,                  86 ; TILESET_COLOSSEUM_2
	tileset Evolution1Gfx,                  96 ; TILESET_EVOLUTION_1
	tileset Evolution2Gfx,                  86 ; TILESET_EVOLUTION_2
	tileset Mystery1Gfx,                    96 ; TILESET_MYSTERY_1
	tileset Mystery2Gfx,                    86 ; TILESET_MYSTERY_2
	tileset Laboratory1Gfx,                 96 ; TILESET_LABORATORY_1
	tileset Laboratory2Gfx,                 86 ; TILESET_LABORATORY_2
	tileset CharizardIntro1Gfx,             96 ; TILESET_CHARIZARD_INTRO_1
	tileset CharizardIntro2Gfx,             96 ; TILESET_CHARIZARD_INTRO_2
	tileset ScytherIntro1Gfx,               96 ; TILESET_SCYTHER_INTRO_1
	tileset ScytherIntro2Gfx,               96 ; TILESET_SCYTHER_INTRO_2
	tileset AerodactylIntro1Gfx,            96 ; TILESET_AERODACTYL_INTRO_1
	tileset AerodactylIntro2Gfx,            96 ; TILESET_AERODACTYL_INTRO_2
	tileset JapaneseTitleScreenGfx,         97 ; TILESET_JAPANESE_TITLE_SCREEN
	tileset JapaneseTitleScreenCGBGfx,      97 ; TILESET_JAPANESE_TITLE_SCREEN_CGB
	tileset SolidTiles1,                     4 ; TILESET_SOLID_TILES_1
	tileset JapaneseTitleScreen2Gfx,       244 ; TILESET_JAPANESE_TITLE_SCREEN_2
	tileset JapaneseTitleScreen2CGBGfx,     59 ; TILESET_JAPANESE_TITLE_SCREEN_2_CGB
	tileset SolidTiles2,                     4 ; TILESET_SOLID_TILES_2
	tileset PlayerGfx,                      36 ; TILESET_PLAYER
	tileset RonaldGfx,                      36 ; TILESET_RONALD
	tileset TitleScreenGfx,                220 ; TILESET_TITLE_SCREEN
	tileset TitleScreenCGBGfx,             212 ; TILESET_TITLE_SCREEN_CGB
	tileset CopyrightGfx,                   36 ; TILESET_COPYRIGHT
	tileset NintendoGfx,                    24 ; TILESET_NINTENDO
	tileset CompaniesGfx,                   49 ; TILESET_COMPANIES
	tileset SamGfx,                         36 ; TILESET_SAM
	tileset ImakuniGfx,                     36 ; TILESET_IMAKUNI
	tileset NikkiGfx,                       36 ; TILESET_NIKKI
	tileset RickGfx,                        36 ; TILESET_RICK
	tileset KenGfx,                         36 ; TILESET_KEN
	tileset AmyGfx,                         36 ; TILESET_AMY
	tileset IsaacGfx,                       36 ; TILESET_ISAAC
	tileset MitchGfx,                       36 ; TILESET_MITCH
	tileset GeneGfx,                        36 ; TILESET_GENE
	tileset MurrayGfx,                      36 ; TILESET_MURRAY
	tileset CourtneyGfx,                    36 ; TILESET_COURTNEY
	tileset SteveGfx,                       36 ; TILESET_STEVE
	tileset JackGfx,                        36 ; TILESET_JACK
	tileset RodGfx,                         36 ; TILESET_ROD
	tileset JosephGfx,                      36 ; TILESET_JOSEPH
	tileset DavidGfx,                       36 ; TILESET_DAVID
	tileset ErikGfx,                        36 ; TILESET_ERIK
	tileset JohnGfx,                        36 ; TILESET_JOHN
	tileset AdamGfx,                        36 ; TILESET_ADAM
	tileset JonathanGfx,                    36 ; TILESET_JONATHAN
	tileset JoshuaGfx,                      36 ; TILESET_JOSHUA
	tileset NicholasGfx,                    36 ; TILESET_NICHOLAS
	tileset BrandonGfx,                     36 ; TILESET_BRANDON
	tileset MatthewGfx,                     36 ; TILESET_MATTHEW
	tileset RyanGfx,                        36 ; TILESET_RYAN
	tileset AndrewGfx,                      36 ; TILESET_ANDREW
	tileset ChrisGfx,                       36 ; TILESET_CHRIS
	tileset MichaelGfx,                     36 ; TILESET_MICHAEL
	tileset DanielGfx,                      36 ; TILESET_DANIEL
	tileset RobertGfx,                      36 ; TILESET_ROBERT
	tileset BrittanyGfx,                    36 ; TILESET_BRITTANY
	tileset KristinGfx,                     36 ; TILESET_KRISTIN
	tileset HeatherGfx,                     36 ; TILESET_HEATHER
	tileset SaraGfx,                        36 ; TILESET_SARA
	tileset AmandaGfx,                      36 ; TILESET_AMANDA
	tileset JenniferGfx,                    36 ; TILESET_JENNIFER
	tileset JessicaGfx,                     36 ; TILESET_JESSICA
	tileset StephanieGfx,                   36 ; TILESET_STEPHANIE
	tileset AaronGfx,                       36 ; TILESET_AARON
	assert_table_length NUM_TILESETS
