DeckPointers::
	table_width 2, DeckPointers
	dw UnnamedDeck
	dw UnnamedDeck2
	dw SamsPracticeDeck
	dw PracticePlayerDeck
	dw SamsPracticeDeck
	dw CharmanderAndFriendsDeck
	dw CharmanderExtraDeck
	dw SquirtleAndFriendsDeck
	dw SquirtleExtraDeck
	dw BulbasaurAndFriendsDeck
	dw BulbasaurExtraDeck
	dw LightningAndFireDeck
	dw WaterAndFightingDeck
	dw GrassAndPsychicDeck
	dw LegendaryMoltresDeck
	dw LegendaryZapdosDeck
	dw LegendaryArticunoDeck
	dw LegendaryDragoniteDeck
	dw FirstStrikeDeck
	dw RockCrusherDeck
	dw GoGoRainDanceDeck
	dw ZappingSelfdestructDeck
	dw FlowerPowerDeck
	dw StrangePsyshockDeck
	dw WondersofScienceDeck
	dw FireChargeDeck
	dw ImRonaldDeck
	dw PowerfulRonaldDeck
	dw InvincibleRonaldDeck
	dw LegendaryRonaldDeck
	dw MusclesforBrainsDeck
	dw HeatedBattleDeck
	dw LovetoBattleDeck
	dw ExcavationDeck
	dw BlisteringPokemonDeck
	dw HardPokemonDeck
	dw WaterfrontPokemonDeck
	dw LonelyFriendsDeck
	dw SoundoftheWavesDeck
	dw PikachuDeck
	dw BoomBoomSelfdestructDeck
	dw PowerGeneratorDeck
	dw EtceteraDeck
	dw FlowerGardenDeck
	dw KaleidoscopeDeck
	dw GhostDeck
	dw NapTimeDeck
	dw StrangePowerDeck
	dw FlyinPokemonDeck
	dw LovelyNidoranDeck
	dw PoisonDeck
	dw AngerDeck
	dw FlamethrowerDeck
	dw ReshuffleDeck
	dw ImakuniDeck
	dw NULL
	assert_table_length NUM_VALID_DECKS + 1

UnnamedDeck:
	deck_list_start
	card_item PSYCHIC_ENERGY,         20
	card_item SLOWPOKE_LV9,            4
	card_item CLEFAIRY,                4
	card_item MEW_LV8,                 4
	card_item PIDGEOT_LV40,            2
	card_item PIDGEOTTO,               2
	card_item PIDGEY,                  4
	card_item IMAKUNI_CARD,            2
	card_item GAMBLER,                 2
	card_item PROFESSOR_OAK,           2
	card_item ENERGY_REMOVAL,          2
	card_item ENERGY_RETRIEVAL,        2
	card_item ENERGY_SEARCH,           2
	card_item POKEMON_BREEDER,         2
	card_item IMPOSTER_PROFESSOR_OAK,  2
	card_item SCOOP_UP,                1
	card_item DEVOLUTION_SPRAY,        1
	card_item POTION,                  1
	card_item SUPER_POTION,            1
	deck_list_end

	deck_list_start
	card_item LIGHTNING_ENERGY, 8
	card_item GRASS_ENERGY,     8
	card_item ZAPDOS_LV68,      4
	card_item MAGNEMITE_LV15,   4
	card_item ELECTRODE_LV42,   4
	card_item JOLTEON_LV24,     4
	card_item VOLTORB,          4
	card_item EEVEE,            4
	card_item TANGELA_LV12,     4
	card_item VENUSAUR_LV64,    4
	card_item BULBASAUR,        4
	card_item IVYSAUR,          4
	card_item POKEMON_BREEDER,  4
	deck_list_end

	deck_list_start
	card_item FIRE_ENERGY,            24
	card_item PIDGEOT_LV40,            4
	card_item CHARMANDER,              4
	card_item PIDGEY,                  4
	card_item GASTLY_LV17,             4
	card_item EEVEE,                   4
	card_item TAUROS,                  4
	card_item ENERGY_SEARCH,           2
	card_item GAMBLER,                 2
	card_item ITEM_FINDER,             2
	card_item IMPOSTER_PROFESSOR_OAK,  2
	card_item POKEMON_BREEDER,         2
	card_item SCOOP_UP,                2
	card_item POTION,                  1
	card_item SUPER_POTION,            1
	card_item POKEMON_BREEDER,         4
	; this deck list has 66 cards
	;deck_list_end
	db 0 ; end

	deck_list_start
	card_item PSYCHIC_ENERGY,  4
	card_item FIGHTING_ENERGY, 4
	card_item WEEDLE,          4
	card_item CUBONE,          4
	card_item MAROWAK_LV32,    4
	card_item DRATINI,         4
	card_item DRAGONAIR,       4
	card_item DRAGONITE_LV41,  4
	card_item MEOWTH_LV14,     4
	card_item DITTO,           4
	card_item PIDGEY,          4
	card_item PIDGEOTTO,       4
	card_item PIDGEOT_LV40,    4
	card_item JIGGLYPUFF_LV13, 4
	card_item POKEMON_BREEDER, 4
	deck_list_end

	deck_list_start
	card_item PSYCHIC_ENERGY,   10
	card_item LIGHTNING_ENERGY, 12
	card_item GASTLY_LV8,        2
	card_item GASTLY_LV17,       2
	card_item HAUNTER_LV22,      2
	card_item HAUNTER_LV17,      1
	card_item GENGAR,            2
	card_item ELECTABUZZ_LV35,   2
	card_item ELECTABUZZ_LV20,   2
	card_item PIKACHU_LV12,      2
	card_item PIKACHU_LV14,      2
	card_item RAICHU_LV40,       1
	card_item RAICHU_LV45,       2
	card_item ZAPDOS_LV68,       2
	card_item FLYING_PIKACHU,    2
	card_item DRATINI,           4
	card_item DRAGONAIR,         3
	card_item DRAGONITE_LV41,    2
	card_item PROFESSOR_OAK,     1
	card_item POKEMON_BREEDER,   2
	card_item BILL,              2
	deck_list_end

	deck_list_start
	card_item PSYCHIC_ENERGY,   10
	card_item LIGHTNING_ENERGY, 10
	card_item MANKEY,            4
	card_item SLOWPOKE_LV9,      4
	card_item SLOWBRO,           4
	card_item ABRA,              4
	card_item KADABRA,           4
	card_item ALAKAZAM,          4
	card_item GASTLY_LV17,       4
	card_item HAUNTER_LV17,      4
	card_item GENGAR,            4
	card_item POKEMON_BREEDER,   4
	deck_list_end

	deck_list_start
	card_item FIRE_ENERGY,     24
	card_item PIDGEOT_LV40,     4
	card_item CHARMANDER,       4
	card_item PIDGEY,           4
	card_item GASTLY_LV17,      4
	card_item HAUNTER_LV17,     4
	card_item RATTATA,          4
	card_item RATICATE,         4
	card_item POKEMON_BREEDER,  4
	card_item SCOOP_UP,         2
	card_item POTION,           1
	card_item SUPER_POTION,     1
	deck_list_end

	deck_list_start
	card_item PSYCHIC_ENERGY,  20
	card_item SLOWPOKE_LV9,     4
	card_item SLOWBRO,          4
	card_item CLEFAIRY,         4
	card_item SPEAROW,          4
	card_item PORYGON,          4
	card_item GASTLY_LV17,      4
	card_item HAUNTER_LV17,     4
	card_item GENGAR,           4
	card_item MEW_LV23,         4
	card_item POKEMON_BREEDER,  4
	deck_list_end

	deck_list_start
	card_item PSYCHIC_ENERGY, 24
	card_item SLOWPOKE_LV9,    4
	card_item SLOWBRO,         4
	card_item CLEFAIRY,        4
	card_item MEW_LV23,        4
	card_item DROWZEE,         4
	card_item SPEAROW,         4
	card_item PORYGON,         4
	card_item VENONAT,         4
	card_item VENOMOTH,        4
	deck_list_end

	deck_list_start
	card_item PSYCHIC_ENERGY,  24
	card_item SLOWPOKE_LV9,     4
	card_item CLEFAIRY,         4
	card_item MEW_LV23,         4
	card_item DROWZEE,          4
	card_item HYPNO,            4
	card_item RATTATA,          4
	card_item PORYGON,          4
	card_item POKEMON_BREEDER,  4
	card_item SCOOP_UP,         2
	card_item POTION,           1
	card_item SUPER_POTION,     1
	deck_list_end

	deck_list_start
	card_item PSYCHIC_ENERGY,  24
	card_item MACHAMP,          4
	card_item MACHOKE,          4
	card_item MACHOP,           4
	card_item GASTLY_LV17,      4
	card_item HAUNTER_LV17,     4
	card_item RATTATA,          4
	card_item POKEMON_BREEDER,  4
	card_item DEFENDER,         2
	card_item GUST_OF_WIND,     2
	card_item SCOOP_UP,         2
	card_item POTION,           1
	card_item SUPER_POTION,     1
	deck_list_end

	deck_list_start
	card_item LIGHTNING_ENERGY, 12
	card_item ELECTRODE_LV42,    4
	card_item ELECTABUZZ_LV20,   4
	card_item MAGNEMITE_LV13,    4
	card_item EEVEE,             4
	card_item ZAPDOS_LV40,       4
	card_item JOLTEON_LV29,      4
	card_item FLYING_PIKACHU,    4
	card_item PIKACHU_LV16,      4
	card_item PIKACHU_ALT_LV16,  4
	card_item PIKACHU_LV12,      4
	card_item PIKACHU_LV14,      4
	card_item RAICHU_LV40,       4
	deck_list_end

	deck_list_start
	card_item FIGHTING_ENERGY, 24
	card_item HITMONCHAN,       4
	card_item DIGLETT,          4
	card_item MACHOP,           4
	card_item MEOWTH_LV15,      4
	card_item RATTATA,          4
	card_item DODUO,            4
	card_item POKEDEX,          2
	card_item PLUSPOWER,        2
	card_item DEFENDER,         2
	card_item GUST_OF_WIND,     2
	card_item SCOOP_UP,         2
	card_item POTION,           1
	card_item SUPER_POTION,     1
	deck_list_end

UnnamedDeck2:
	deck_list_start
	card_item FIRE_ENERGY,              4
	card_item GRASS_ENERGY,            20
	card_item KANGASKHAN,               2
	card_item ODDISH,                   4
	card_item GLOOM,                    2
	card_item VILEPLUME,                2
	card_item BULBASAUR,                4
	card_item IVYSAUR,                  3
	card_item CHARMANDER,               4
	card_item CHARMELEON,               3
	card_item CHARIZARD,                2
	card_item POKEMON_BREEDER,          2
	card_item CHANSEY,                  2
	card_item ENERGY_RETRIEVAL,         2
	card_item PROFESSOR_OAK,            2
	card_item GUST_OF_WIND,             2
	card_item DOUBLE_COLORLESS_ENERGY,  2
	; this deck list has 62 cards
	;deck_list_end
	db 0 ; end

	deck_list_start
	card_item FIRE_ENERGY,              4
	card_item GRASS_ENERGY,            20
	card_item KANGASKHAN,               4
	card_item BULBASAUR,                4
	card_item IVYSAUR,                  3
	card_item VENUSAUR_LV67,            2
	card_item CHARMANDER,               4
	card_item CHARMELEON,               3
	card_item CHARIZARD,                2
	card_item POKEMON_BREEDER,          3
	card_item POKEMON_TRADER,           3
	card_item ENERGY_RETRIEVAL,         2
	card_item PROFESSOR_OAK,            2
	card_item GUST_OF_WIND,             2
	card_item DOUBLE_COLORLESS_ENERGY,  2
	deck_list_end

	deck_list_start
	card_item PSYCHIC_ENERGY,  4
	card_item FIGHTING_ENERGY, 4
	card_item MEW_LV15,        4
	card_item CUBONE,          4
	card_item MAROWAK_LV32,    4
	card_item DRATINI,         4
	card_item DRAGONAIR,       4
	card_item DRAGONITE_LV41,  4
	card_item MEOWTH_LV14,     4
	card_item DITTO,           4
	card_item PIDGEY,          4
	card_item PIDGEOTTO,       4
	card_item PIDGEOT_LV38,    4
	card_item JIGGLYPUFF_LV13, 4
	card_item POKEMON_BREEDER, 4
	deck_list_end

	deck_list_start
	card_item GRASS_ENERGY,      24
	card_item CLEFAIRY,           4
	card_item CLEFABLE,           4
	card_item CATERPIE,           4
	card_item MYSTERIOUS_FOSSIL,  4
	card_item SCYTHER,            4
	card_item PARAS,              4
	card_item JIGGLYPUFF_LV14,    4
	card_item WEEDLE,             4
	card_item AERODACTYL,         4
	deck_list_end

	deck_list_start
	card_item LIGHTNING_ENERGY, 8
	card_item GRASS_ENERGY,     8
	card_item ZAPDOS_LV68,      4
	card_item MAGNEMITE_LV15,   4
	card_item ELECTRODE_LV35,   4
	card_item JOLTEON_LV24,     4
	card_item VOLTORB,          4
	card_item EEVEE,            4
	card_item TANGELA_LV12,     4
	card_item VENUSAUR_LV64,    4
	card_item BULBASAUR,        4
	card_item IVYSAUR,          4
	card_item POKEMON_BREEDER,  4
	deck_list_end

	deck_list_start
	card_item FIRE_ENERGY,     24
	card_item FLAREON_LV22,     4
	card_item NINETALES_LV35,   4
	card_item MOLTRES_LV37,     4
	card_item EEVEE,            4
	card_item CHARMANDER,       4
	card_item VULPIX,           4
	card_item ARTICUNO_LV37,    4
	card_item VAPOREON_LV29,    4
	card_item POKEMON_BREEDER,  4
	deck_list_end

	deck_list_start
	card_item GRASS_ENERGY,      20
	card_item CATERPIE,           4
	card_item MYSTERIOUS_FOSSIL,  4
	card_item POKEMON_BREEDER,    4
	card_item PSYDUCK,            4
	card_item JIGGLYPUFF_LV14,    4
	card_item WEEDLE,             4
	card_item AERODACTYL,         4
	card_item BULBASAUR,          4
	card_item IVYSAUR,            4
	card_item VENUSAUR_LV67,      4
	deck_list_end

	deck_list_start
	card_item GRASS_ENERGY,    24
	card_item PLUSPOWER,        4
	card_item BILL,             4
	card_item POKEMON_CENTER,   4
	card_item CATERPIE,         4
	card_item NIDORANM,         4
	card_item SCYTHER,          4
	card_item PARAS,            4
	card_item JIGGLYPUFF_LV14,  4
	card_item WEEDLE,           4
	deck_list_end

	deck_list_start
	card_item WATER_ENERGY,      24
	card_item BLASTOISE,          4
	card_item SQUIRTLE,           4
	card_item HORSEA,             4
	card_item PSYDUCK,            4
	card_item POLIWAG,            4
	card_item MYSTERIOUS_FOSSIL,  4
	card_item TENTACOOL,          4
	card_item AERODACTYL,         4
	card_item POKEMON_BREEDER,    4
	deck_list_end

	deck_list_start
	card_item WATER_ENERGY,      24
	card_item BLASTOISE,          4
	card_item WARTORTLE,          4
	card_item SQUIRTLE,           4
	card_item PSYDUCK,            4
	card_item GOLDUCK,            4
	card_item POLIWAG,            4
	card_item MYSTERIOUS_FOSSIL,  4
	card_item AERODACTYL,         4
	card_item POTION,             4
	deck_list_end

	deck_list_start
	card_item GRASS_ENERGY,    24
	card_item PINSIR,           4
	card_item ZUBAT,            4
	card_item GOLBAT,           4
	card_item DODUO,            4
	card_item DODRIO,           4
	card_item JIGGLYPUFF_LV14,  4
	card_item POKEMON_CENTER,   4
	card_item PLUSPOWER,        3
	card_item PROFESSOR_OAK,    2
	card_item BILL,             3
	deck_list_end

	deck_list_start
	card_item LIGHTNING_ENERGY, 12
	card_item ELECTRODE_LV42,    4
	card_item ELECTABUZZ_LV20,   4
	card_item MAGNEMITE_LV13,    4
	card_item EEVEE,             4
	card_item ZAPDOS_LV40,       4
	card_item JOLTEON_LV29,      4
	card_item FLYING_PIKACHU,    4
	card_item PIKACHU_LV16,      4
	card_item PIKACHU_ALT_LV16,  4
	card_item PIKACHU_LV12,      4
	card_item PIKACHU_LV14,      4
	card_item RAICHU_LV40,       4
	deck_list_end

	deck_list_start
	card_item RAICHU_LV45,    4
	card_item MAGNETON_LV28,  4
	card_item MAGNETON_LV35,  4
	card_item WATER_ENERGY,  24
	card_item SEAKING,        4
	card_item OMASTAR,        4
	card_item OMANYTE,        4
	card_item WARTORTLE,      4
	card_item BLASTOISE,      4
	card_item GYARADOS,       4
	card_item KINGLER,        4
	card_item KRABBY,         4
	card_item MAGIKARP,       4
	; this deck list has 72 cards
	;deck_list_end
	db 0 ; end

	dw $4544
	dw $4d52
	dw $4c5b
	dw $4156
	dw $4a51
	dw $4753
	dw $4648
	dw $4e4b
	dw $5e55
	dw $5949

PracticePlayerDeck:
	deck_list_start
	card_item WATER_ENERGY,   2
	card_item PSYCHIC_ENERGY, 1
	card_item SEAKING,        1
	card_item STARYU,         1
	card_item FULL_HEAL,      1
	card_item GOLDEEN,        1
	card_item WATER_ENERGY,   5
	card_item DROWZEE,        1
	card_item POTION,         1
	card_item SEAKING,        1
	card_item STARMIE,        1
	card_item WATER_ENERGY,   1
	card_item BILL,           1
	card_item PSYCHIC_ENERGY, 1
	card_item JYNX,           1
	card_item SQUIRTLE,       1
	card_item WATER_ENERGY,   1
	card_item SQUIRTLE,       1
	card_item WATER_ENERGY,   1
	card_item PSYCHIC_ENERGY, 1
	card_item WARTORTLE,      1
	card_item BILL,           1
	card_item WATER_ENERGY,   1
	card_item BLASTOISE,      1
	card_item WATER_ENERGY,   1
	card_item PSYCHIC_ENERGY, 1
	card_item WATER_ENERGY,   1
	card_item PSYCHIC_ENERGY, 1
	card_item RATTATA,        1
	card_item ABRA,           1
	card_item PSYCHIC_ENERGY, 1
	card_item HYPNO,          1
	card_item WATER_ENERGY,   1
	card_item PSYCHIC_ENERGY, 1
	card_item SEEL,           1
	card_item PSYCHIC_ENERGY, 1
	card_item KADABRA,        1
	card_item POTION,         1
	card_item PSYCHIC_ENERGY, 1
	card_item DROWZEE,        1
	card_item PSYCHIC_ENERGY, 1
	card_item RATTATA,        1
	card_item GOLDEEN,        1
	card_item SEEL,           1
	card_item DEWGONG,        1
	card_item GOLDEEN,        1
	card_item STARYU,         1
	card_item LAPRAS,         1
	card_item ABRA,           1
	card_item DROWZEE,        1
	card_item HYPNO,          1
	card_item RATTATA,        1
	card_item RATICATE,       1
	card_item RATICATE,       1
	card_item ALAKAZAM,       1
	deck_list_end
	tx PracticePlayerDeckName

SamsPracticeDeck:
	deck_list_start
	card_item LIGHTNING_ENERGY,        2
	card_item FIGHTING_ENERGY,         2
	card_item MACHOP,                  1
	card_item RATICATE,                1
	card_item MACHAMP,                 1
	card_item FIGHTING_ENERGY,         2
	card_item MACHAMP,                 1
	card_item RATTATA,                 1
	card_item FIGHTING_ENERGY,         2
	card_item MACHOP,                  1
	card_item FIGHTING_ENERGY,         1
	card_item RATICATE,                1
	card_item LIGHTNING_ENERGY,        1
	card_item MACHOP,                  1
	card_item BILL,                    1
	card_item FIGHTING_ENERGY,         1
	card_item DIGLETT,                 1
	card_item DUGTRIO,                 1
	card_item FIGHTING_ENERGY,         1
	card_item MACHOKE,                 1
	card_item LIGHTNING_ENERGY,        1
	card_item LIGHTNING_ENERGY,        1
	card_item GUST_OF_WIND,            1
	card_item JOLTEON_LV29,            1
	card_item LIGHTNING_ENERGY,        1
	card_item ELECTABUZZ_LV35,         1
	card_item FIGHTING_ENERGY,         1
	card_item HITMONCHAN,              1
	card_item LIGHTNING_ENERGY,        1
	card_item PROFESSOR_OAK,           1
	card_item FIGHTING_ENERGY,         1
	card_item EEVEE,                   1
	card_item FIGHTING_ENERGY,         1
	card_item DOUBLE_COLORLESS_ENERGY, 1
	card_item PIKACHU_LV12,            1
	card_item LIGHTNING_ENERGY,        1
	card_item PIKACHU_LV12,            1
	card_item LIGHTNING_ENERGY,        1
	card_item POTION,                  1
	card_item LIGHTNING_ENERGY,        1
	card_item PIKACHU_LV14,            1
	card_item LIGHTNING_ENERGY,        1
	card_item RAICHU_LV40,             1
	card_item RAICHU_LV45,             1
	card_item LIGHTNING_ENERGY,        1
	card_item JOLTEON_LV29,            1
	card_item DIGLETT,                 1
	card_item MACHOP,                  1
	card_item MACHOKE,                 1
	card_item ONIX,                    1
	card_item RHYHORN,                 1
	card_item RHYHORN,                 1
	card_item RHYDON,                  1
	card_item RATTATA,                 1
	card_item EEVEE,                   1
	card_item EEVEE,                   1
	deck_list_end
	tx SamsPracticeDeckName

CharmanderAndFriendsDeck:
	deck_list_start
	card_item FIRE_ENERGY,      10
	card_item LIGHTNING_ENERGY,  8
	card_item FIGHTING_ENERGY,   6
	card_item CHARMANDER,        2
	card_item CHARMELEON,        1
	card_item CHARIZARD,         1
	card_item GROWLITHE,         2
	card_item ARCANINE_LV45,     1
	card_item PONYTA,            2
	card_item MAGMAR_LV24,       1
	card_item PIKACHU_LV12,      2
	card_item RAICHU_LV40,       1
	card_item MAGNEMITE_LV13,    2
	card_item MAGNETON_LV28,     1
	card_item ZAPDOS_LV64,       1
	card_item DIGLETT,           2
	card_item DUGTRIO,           1
	card_item MACHOP,            1
	card_item MACHOKE,           1
	card_item RATTATA,           2
	card_item RATICATE,          1
	card_item MEOWTH_LV14,       1
	card_item PROFESSOR_OAK,     1
	card_item BILL,              2
	card_item SWITCH,            1
	card_item COMPUTER_SEARCH,   1
	card_item PLUSPOWER,         1
	card_item POTION,            2
	card_item FULL_HEAL,         2
	deck_list_end
	tx CharmanderAndFriendsDeckName

CharmanderExtraDeck:
	deck_list_start
	card_item GRASS_ENERGY,    4
	card_item WATER_ENERGY,    4
	card_item PSYCHIC_ENERGY,  3
	card_item BULBASAUR,       1
	card_item IVYSAUR,         1
	card_item NIDORANF,        2
	card_item CATERPIE,        2
	card_item METAPOD,         1
	card_item NIDORANM,        1
	card_item PINSIR,          1
	card_item SEEL,            2
	card_item DEWGONG,         1
	card_item GOLDEEN,         2
	card_item SEAKING,         1
	card_item ABRA,            2
	card_item KADABRA,         1
	card_item GASTLY_LV8,      1
	card_item GRASS_ENERGY,   30 ; irrelevant
	deck_list_end
	tx CharmanderExtraDeckName

SquirtleAndFriendsDeck:
	deck_list_start
	card_item WATER_ENERGY,    11
	card_item FIGHTING_ENERGY,  6
	card_item PSYCHIC_ENERGY,   8
	card_item SQUIRTLE,         2
	card_item WARTORTLE,        1
	card_item BLASTOISE,        1
	card_item SEEL,             2
	card_item DEWGONG,          1
	card_item STARYU,           1
	card_item STARMIE,          1
	card_item GOLDEEN,          1
	card_item SEAKING,          1
	card_item LAPRAS,           1
	card_item ABRA,             2
	card_item KADABRA,          1
	card_item GASTLY_LV8,       2
	card_item HAUNTER_LV22,     1
	card_item MACHOP,           1
	card_item MACHOKE,          1
	card_item GEODUDE,          2
	card_item HITMONCHAN,       1
	card_item RATTATA,          2
	card_item RATICATE,         1
	card_item MEOWTH_LV14,      1
	card_item PROFESSOR_OAK,    1
	card_item BILL,             1
	card_item SWITCH,           1
	card_item POKE_BALL,        1
	card_item SCOOP_UP,         1
	card_item ITEM_FINDER,      1
	card_item POTION,           1
	card_item FULL_HEAL,        1
	deck_list_end
	tx SquirtleAndFriendsDeckName

SquirtleExtraDeck:
	deck_list_start
	card_item GRASS_ENERGY,      3
	card_item FIRE_ENERGY,       4
	card_item LIGHTNING_ENERGY,  4
	card_item NIDORANF,          2
	card_item NIDORANM,          1
	card_item CATERPIE,          1
	card_item METAPOD,           1
	card_item WEEDLE,            1
	card_item KAKUNA,            1
	card_item PINSIR,            1
	card_item CHARMANDER,        2
	card_item CHARMELEON,        1
	card_item MAGMAR_LV24,       1
	card_item GROWLITHE,         1
	card_item ARCANINE_LV45,     1
	card_item PIKACHU_LV12,      2
	card_item MAGNEMITE_LV13,    1
	card_item MAGNETON_LV28,     1
	card_item ELECTABUZZ_LV35,   1
	card_item GRASS_ENERGY,     30 ; irrelevant
	deck_list_end
	tx SquirtleExtraDeckName

BulbasaurAndFriendsDeck:
	deck_list_start
	card_item GRASS_ENERGY,    11
	card_item FIRE_ENERGY,      3
	card_item WATER_ENERGY,     9
	card_item BULBASAUR,        2
	card_item IVYSAUR,          1
	card_item VENUSAUR_LV67,    1
	card_item CATERPIE,         2
	card_item METAPOD,          1
	card_item NIDORANF,         2
	card_item NIDORANM,         2
	card_item NIDORINO,         1
	card_item TANGELA_LV12,     1
	card_item FLAREON_LV28,     1
	card_item SEEL,             1
	card_item DEWGONG,          1
	card_item KRABBY,           2
	card_item KINGLER,          1
	card_item GOLDEEN,          2
	card_item SEAKING,          1
	card_item VAPOREON_LV42,    1
	card_item JIGGLYPUFF_LV14,  1
	card_item MEOWTH_LV14,      1
	card_item EEVEE,            2
	card_item KANGASKHAN,       1
	card_item PROFESSOR_OAK,    1
	card_item SWITCH,           1
	card_item POKE_BALL,        1
	card_item PLUSPOWER,        2
	card_item DEFENDER,         1
	card_item FULL_HEAL,        2
	card_item REVIVE,           1
	deck_list_end
	tx BulbasaurAndFriendsDeckName

BulbasaurExtraDeck:
	deck_list_start
	card_item LIGHTNING_ENERGY,  4
	card_item PSYCHIC_ENERGY,    4
	card_item FIGHTING_ENERGY,   3
	card_item PIKACHU_LV12,      2
	card_item RAICHU_LV40,       1
	card_item MAGNEMITE_LV13,    1
	card_item ELECTABUZZ_LV35,   1
	card_item ABRA,              2
	card_item KADABRA,           1
	card_item JYNX,              1
	card_item GASTLY_LV8,        2
	card_item HAUNTER_LV22,      1
	card_item DIGLETT,           1
	card_item DUGTRIO,           1
	card_item HITMONCHAN,        1
	card_item BILL,              1
	card_item POTION,            2
	card_item GUST_OF_WIND,      1
	card_item GRASS_ENERGY,     30 ; irrelevant
	deck_list_end
	tx BulbasaurExtraDeckName

LightningAndFireDeck:
	deck_list_start
	card_item FIRE_ENERGY,             10
	card_item LIGHTNING_ENERGY,        10
	card_item DOUBLE_COLORLESS_ENERGY,  2
	card_item CHARMANDER,               2
	card_item CHARMELEON,               1
	card_item CHARIZARD,                1
	card_item GROWLITHE,                2
	card_item ARCANINE_LV45,            1
	card_item PONYTA,                   2
	card_item RAPIDASH,                 1
	card_item MAGMAR_LV24,              1
	card_item MAGMAR_LV31,              1
	card_item PIKACHU_LV12,             1
	card_item PIKACHU_LV14,             1
	card_item RAICHU_LV40,              1
	card_item MAGNEMITE_LV13,           2
	card_item MAGNETON_LV28,            1
	card_item VOLTORB,                  3
	card_item ELECTRODE_LV35,           1
	card_item ELECTRODE_LV42,           1
	card_item RATTATA,                  2
	card_item RATICATE,                 1
	card_item PROFESSOR_OAK,            1
	card_item BILL,                     2
	card_item ENERGY_SEARCH,            2
	card_item SWITCH,                   2
	card_item PLUSPOWER,                2
	card_item DEFENDER,                 2
	card_item POTION,                   1
	deck_list_end
	tx LightningAndFireDeckName

WaterAndFightingDeck:
	deck_list_start
	card_item WATER_ENERGY,            12
	card_item FIGHTING_ENERGY,         10
	card_item DOUBLE_COLORLESS_ENERGY,  2
	card_item POLIWAG,                  2
	card_item POLIWHIRL,                1
	card_item POLIWRATH,                1
	card_item SEEL,                     2
	card_item DEWGONG,                  1
	card_item GOLDEEN,                  2
	card_item SEAKING,                  1
	card_item STARYU,                   2
	card_item STARMIE,                  1
	card_item SANDSHREW,                2
	card_item SANDSLASH,                1
	card_item MACHOP,                   3
	card_item MACHOKE,                  2
	card_item MACHAMP,                  1
	card_item HITMONCHAN,               1
	card_item RHYHORN,                  2
	card_item RHYDON,                   1
	card_item PROFESSOR_OAK,            1
	card_item BILL,                     2
	card_item ENERGY_SEARCH,            2
	card_item POTION,                   3
	card_item FULL_HEAL,                2
	deck_list_end
	tx WaterAndFightingDeckName

GrassAndPsychicDeck:
	deck_list_start
	card_item GRASS_ENERGY,   12
	card_item PSYCHIC_ENERGY, 12
	card_item WEEDLE,          2
	card_item KAKUNA,          1
	card_item BEEDRILL,        1
	card_item NIDORANF,        2
	card_item NIDORINA,        1
	card_item PARAS,           2
	card_item PARASECT,        1
	card_item EXEGGCUTE,       2
	card_item EXEGGUTOR,       1
	card_item PINSIR,          1
	card_item ABRA,            3
	card_item KADABRA,         2
	card_item DROWZEE,         3
	card_item HYPNO,           2
	card_item JYNX,            1
	card_item FARFETCHD,       1
	card_item TAUROS,          1
	card_item BILL,            2
	card_item ENERGY_SEARCH,   2
	card_item GUST_OF_WIND,    2
	card_item POTION,          2
	card_item FULL_HEAL,       2
	; this deck list has 61 cards
	;deck_list_end
	db 0 ; end
	tx GrassAndPsychicDeckName

LegendaryMoltresDeck:
	deck_list_start
	card_item FIRE_ENERGY,            25
	card_item VULPIX,                  4
	card_item NINETALES_LV35,          3
	card_item GROWLITHE,               4
	card_item ARCANINE_LV45,           2
	card_item MAGMAR_LV24,             2
	card_item MAGMAR_LV31,             2
	card_item MOLTRES_LV35,            2
	card_item MOLTRES_LV37,            2
	card_item BILL,                    3
	card_item LASS,                    2
	card_item POKEMON_TRADER,          1
	card_item ENERGY_RETRIEVAL,        1
	card_item SUPER_ENERGY_RETRIEVAL,  1
	card_item ENERGY_REMOVAL,          2
	card_item SWITCH,                  2
	card_item POTION,                  1
	card_item SUPER_POTION,            1
	deck_list_end
	tx LegendaryMoltresDeckName

LegendaryZapdosDeck:
	deck_list_start
	card_item LIGHTNING_ENERGY, 25
	card_item VOLTORB,           4
	card_item ELECTRODE_LV35,    3
	card_item ELECTABUZZ_LV35,   4
	card_item JOLTEON_LV29,      2
	card_item ZAPDOS_LV40,       1
	card_item ZAPDOS_LV64,       1
	card_item ZAPDOS_LV68,       2
	card_item EEVEE,             3
	card_item BILL,              4
	card_item ENERGY_RETRIEVAL,  2
	card_item SWITCH,            2
	card_item PLUSPOWER,         3
	card_item POTION,            3
	card_item GAMBLER,           1
	deck_list_end
	tx LegendaryZapdosDeckName

LegendaryArticunoDeck:
	deck_list_start
	card_item WATER_ENERGY,     25
	card_item SEEL,              4
	card_item DEWGONG,           3
	card_item LAPRAS,            4
	card_item ARTICUNO_LV37,     2
	card_item ARTICUNO_LV35,     2
	card_item CHANSEY,           3
	card_item DITTO,             2
	card_item PROFESSOR_OAK,     2
	card_item POKEMON_TRADER,    2
	card_item ENERGY_RETRIEVAL,  3
	card_item SWITCH,            3
	card_item SCOOP_UP,          4
	card_item GAMBLER,           1
	deck_list_end
	tx LegendaryArticunoDeckName

LegendaryDragoniteDeck:
	deck_list_start
	card_item WATER_ENERGY,            20
	card_item DOUBLE_COLORLESS_ENERGY,  4
	card_item CHARMANDER,               3
	card_item CHARMELEON,               2
	card_item CHARIZARD,                2
	card_item MAGIKARP,                 3
	card_item GYARADOS,                 2
	card_item LAPRAS,                   2
	card_item KANGASKHAN,               2
	card_item DRATINI,                  4
	card_item DRAGONAIR,                3
	card_item DRAGONITE_LV41,           2
	card_item PROFESSOR_OAK,            2
	card_item POKEMON_TRADER,           2
	card_item POKEMON_BREEDER,          2
	card_item ENERGY_RETRIEVAL,         1
	card_item SUPER_ENERGY_RETRIEVAL,   1
	card_item SWITCH,                   2
	card_item GAMBLER,                  1
	deck_list_end
	tx LegendaryDragoniteDeckName

FirstStrikeDeck:
	deck_list_start
	card_item FIGHTING_ENERGY, 25
	card_item MACHOP,           4
	card_item MACHOKE,          3
	card_item MACHAMP,          2
	card_item HITMONCHAN,       2
	card_item HITMONLEE,        4
	card_item MANKEY,           4
	card_item PRIMEAPE,         1
	card_item POTION,           2
	card_item DEFENDER,         2
	card_item PLUSPOWER,        2
	card_item SWITCH,           2
	card_item GUST_OF_WIND,     3
	card_item BILL,             4
	deck_list_end
	tx FirstStrikeDeckName

RockCrusherDeck:
	deck_list_start
	card_item FIGHTING_ENERGY,         24
	card_item DOUBLE_COLORLESS_ENERGY,  2
	card_item DIGLETT,                  4
	card_item DUGTRIO,                  2
	card_item GEODUDE,                  4
	card_item GRAVELER,                 3
	card_item GOLEM,                    2
	card_item ONIX,                     3
	card_item RHYHORN,                  3
	card_item PROFESSOR_OAK,            2
	card_item POKEMON_BREEDER,          1
	card_item ENERGY_REMOVAL,           2
	card_item SWITCH,                   2
	card_item COMPUTER_SEARCH,          1
	card_item DEFENDER,                 2
	card_item SUPER_POTION,             1
	card_item POTION,                   2
	deck_list_end
	tx RockCrusherDeckName

GoGoRainDanceDeck:
	deck_list_start
	card_item WATER_ENERGY,           24
	card_item SQUIRTLE,                4
	card_item WARTORTLE,               3
	card_item BLASTOISE,               2
	card_item GOLDEEN,                 4
	card_item SEAKING,                 3
	card_item HORSEA,                  3
	card_item SEADRA,                  2
	card_item LAPRAS,                  2
	card_item PROFESSOR_OAK,           2
	card_item POKEMON_BREEDER,         1
	card_item ENERGY_RETRIEVAL,        1
	card_item SUPER_ENERGY_RETRIEVAL,  1
	card_item ENERGY_REMOVAL,          2
	card_item SUPER_ENERGY_REMOVAL,    1
	card_item SWITCH,                  2
	card_item POTION,                  2
	card_item GAMBLER,                 1
	deck_list_end
	tx GoGoRainDanceDeckName

ZappingSelfdestructDeck:
	deck_list_start
	card_item LIGHTNING_ENERGY,        24
	card_item DOUBLE_COLORLESS_ENERGY,  2
	card_item MAGNEMITE_LV13,           4
	card_item MAGNETON_LV28,            3
	card_item VOLTORB,                  4
	card_item ELECTRODE_LV35,           2
	card_item ELECTABUZZ_LV35,          4
	card_item KANGASKHAN,               2
	card_item TAUROS,                   1
	card_item PROFESSOR_OAK,            1
	card_item BILL,                     2
	card_item SWITCH,                   2
	card_item DEFENDER,                 4
	card_item GUST_OF_WIND,             1
	card_item POTION,                   4
	deck_list_end
	tx ZappingSelfdestructDeckName

FlowerPowerDeck:
	deck_list_start
	card_item GRASS_ENERGY,     18
	card_item PSYCHIC_ENERGY,    4
	card_item BULBASAUR,         4
	card_item IVYSAUR,           3
	card_item VENUSAUR_LV67,     2
	card_item ODDISH,            4
	card_item GLOOM,             3
	card_item VILEPLUME,         2
	card_item EXEGGCUTE,         4
	card_item EXEGGUTOR,         3
	card_item PROFESSOR_OAK,     2
	card_item BILL,              3
	card_item POKEMON_BREEDER,   2
	card_item ENERGY_RETRIEVAL,  2
	card_item SWITCH,            2
	card_item POTION,            2
	deck_list_end
	tx FlowerPowerDeckName

StrangePsyshockDeck:
	deck_list_start
	card_item PSYCHIC_ENERGY, 22
	card_item ABRA,            4
	card_item KADABRA,         3
	card_item ALAKAZAM,        2
	card_item MR_MIME,         2
	card_item CHANSEY,         3
	card_item KANGASKHAN,      3
	card_item SNORLAX,         2
	card_item PROFESSOR_OAK,   2
	card_item POKEMON_CENTER,  2
	card_item ENERGY_REMOVAL,  3
	card_item GUST_OF_WIND,    3
	card_item SCOOP_UP,        4
	card_item SWITCH,          4
	card_item GAMBLER,         1
	deck_list_end
	tx StrangePsyshockDeckName

WondersofScienceDeck:
	deck_list_start
	card_item GRASS_ENERGY,           15
	card_item PSYCHIC_ENERGY,          8
	card_item GRIMER,                  4
	card_item MUK,                     3
	card_item KOFFING,                 4
	card_item WEEZING,                 3
	card_item MEWTWO_LV53,             2
	card_item MEWTWO_ALT_LV60,         1
	card_item MEWTWO_LV60,             1
	card_item PORYGON,                 2
	card_item IMPOSTER_PROFESSOR_OAK,  1
	card_item PROFESSOR_OAK,           2
	card_item BILL,                    2
	card_item ENERGY_SEARCH,           2
	card_item SWITCH,                  2
	card_item COMPUTER_SEARCH,         2
	card_item POKEDEX,                 2
	card_item MAINTENANCE,             2
	card_item FULL_HEAL,               2
	deck_list_end
	tx WondersofScienceDeckName

FireChargeDeck:
	deck_list_start
	card_item FIRE_ENERGY,             21
	card_item DOUBLE_COLORLESS_ENERGY,  4
	card_item GROWLITHE,                4
	card_item ARCANINE_LV45,            3
	card_item MAGMAR_LV24,              2
	card_item JIGGLYPUFF_LV12,          3
	card_item JIGGLYPUFF_LV14,          1
	card_item WIGGLYTUFF,               1
	card_item CHANSEY,                  2
	card_item TAUROS,                   2
	card_item PROFESSOR_OAK,            1
	card_item BILL,                     2
	card_item ENERGY_RETRIEVAL,         2
	card_item POKE_BALL,                1
	card_item COMPUTER_SEARCH,          1
	card_item DEFENDER,                 2
	card_item POTION,                   3
	card_item FULL_HEAL,                1
	card_item RECYCLE,                  3
	card_item GAMBLER,                  1
	deck_list_end
	tx FireChargeDeckName

ImRonaldDeck:
	deck_list_start
	card_item FIRE_ENERGY,       9
	card_item WATER_ENERGY,     10
	card_item FIGHTING_ENERGY,   8
	card_item CHARMANDER,        3
	card_item CHARMELEON,        2
	card_item GROWLITHE,         3
	card_item ARCANINE_LV45,     1
	card_item SQUIRTLE,          3
	card_item WARTORTLE,         2
	card_item SEEL,              2
	card_item DEWGONG,           1
	card_item LAPRAS,            2
	card_item CUBONE,            3
	card_item MAROWAK_LV26,      2
	card_item PROFESSOR_OAK,     1
	card_item ENERGY_RETRIEVAL,  1
	card_item ENERGY_SEARCH,     2
	card_item SWITCH,            1
	card_item PLUSPOWER,         1
	card_item DEFENDER,          1
	card_item GUST_OF_WIND,      2
	deck_list_end
	tx ImRonaldDeckName

PowerfulRonaldDeck:
	deck_list_start
	card_item LIGHTNING_ENERGY,        7
	card_item FIGHTING_ENERGY,         9
	card_item PSYCHIC_ENERGY,          7
	card_item DOUBLE_COLORLESS_ENERGY, 3
	card_item ELECTABUZZ_LV35,         3
	card_item HITMONLEE,               2
	card_item HITMONCHAN,              2
	card_item MR_MIME,                 1
	card_item JYNX,                    2
	card_item MEWTWO_LV53,             1
	card_item DODUO,                   2
	card_item DODRIO,                  1
	card_item LICKITUNG,               2
	card_item KANGASKHAN,              2
	card_item TAUROS,                  3
	card_item ENERGY_RETRIEVAL,        2
	card_item SUPER_ENERGY_RETRIEVAL,  1
	card_item ENERGY_SEARCH,           1
	card_item ENERGY_REMOVAL,          2
	card_item SWITCH,                  1
	card_item PLUSPOWER,               2
	card_item GUST_OF_WIND,            2
	card_item FULL_HEAL,               1
	card_item GAMBLER,                 1
	deck_list_end
	tx PowerfulRonaldDeckName

InvincibleRonaldDeck:
	deck_list_start
	card_item GRASS_ENERGY,            7
	card_item FIRE_ENERGY,             6
	card_item FIGHTING_ENERGY,         7
	card_item DOUBLE_COLORLESS_ENERGY, 4
	card_item GRIMER,                  3
	card_item MUK,                     2
	card_item SCYTHER,                 4
	card_item MAGMAR_LV31,             3
	card_item GEODUDE,                 3
	card_item GRAVELER,                2
	card_item CHANSEY,                 2
	card_item KANGASKHAN,              2
	card_item PROFESSOR_OAK,           2
	card_item BILL,                    2
	card_item ENERGY_RETRIEVAL,        2
	card_item ENERGY_REMOVAL,          2
	card_item SCOOP_UP,                2
	card_item GUST_OF_WIND,            2
	card_item PLUSPOWER,               2
	card_item GAMBLER,                 1
	deck_list_end
	tx InvincibleRonaldDeckName

LegendaryRonaldDeck:
	deck_list_start
	card_item FIRE_ENERGY,             20
	card_item DOUBLE_COLORLESS_ENERGY,  4
	card_item FLAREON_LV22,             1
	card_item MOLTRES_LV37,             2
	card_item VAPOREON_LV29,            1
	card_item ARTICUNO_LV37,            1
	card_item JOLTEON_LV24,             1
	card_item ZAPDOS_LV68,              1
	card_item KANGASKHAN,               2
	card_item EEVEE,                    4
	card_item DRATINI,                  4
	card_item DRAGONAIR,                3
	card_item DRAGONITE_LV41,           2
	card_item PROFESSOR_OAK,            1
	card_item BILL,                     3
	card_item POKEMON_TRADER,           1
	card_item POKEMON_BREEDER,          2
	card_item ENERGY_REMOVAL,           3
	card_item SCOOP_UP,                 3
	card_item GAMBLER,                  1
	deck_list_end
	tx LegendaryRonaldDeckName

MusclesforBrainsDeck:
	deck_list_start
	card_item FIGHTING_ENERGY,         26
	card_item DOUBLE_COLORLESS_ENERGY,  2
	card_item MANKEY,                   1
	card_item PRIMEAPE,                 1
	card_item MACHOP,                   3
	card_item MACHOKE,                  2
	card_item MACHAMP,                  2
	card_item HITMONLEE,                2
	card_item HITMONCHAN,               2
	card_item MEOWTH_LV15,              3
	card_item PERSIAN,                  2
	card_item LICKITUNG,                1
	card_item KANGASKHAN,               1
	card_item TAUROS,                   2
	card_item BILL,                     1
	card_item ENERGY_REMOVAL,           1
	card_item PLUSPOWER,                2
	card_item GUST_OF_WIND,             2
	card_item POTION,                   1
	card_item SUPER_POTION,             1
	card_item FULL_HEAL,                1
	card_item REVIVE,                   1
	deck_list_end
	tx MusclesforBrainsDeckName

HeatedBattleDeck:
	deck_list_start
	card_item FIRE_ENERGY,       8
	card_item LIGHTNING_ENERGY,  4
	card_item FIGHTING_ENERGY,  15
	card_item MAGMAR_LV24,       4
	card_item ELECTABUZZ_LV35,   2
	card_item MANKEY,            3
	card_item PRIMEAPE,          2
	card_item HITMONLEE,         3
	card_item HITMONCHAN,        3
	card_item KANGASKHAN,        2
	card_item ENERGY_SEARCH,     2
	card_item SCOOP_UP,          2
	card_item PLUSPOWER,         3
	card_item DEFENDER,          2
	card_item POTION,            3
	card_item FULL_HEAL,         2
	deck_list_end
	tx HeatedBattleDeckName

LovetoBattleDeck:
	deck_list_start
	card_item FIGHTING_ENERGY, 26
	card_item MANKEY,           2
	card_item PRIMEAPE,         1
	card_item MACHOP,           4
	card_item MACHOKE,          3
	card_item MACHAMP,          2
	card_item RATTATA,          3
	card_item RATICATE,         2
	card_item DODUO,            2
	card_item DODRIO,           1
	card_item TAUROS,           1
	card_item PLUSPOWER,        4
	card_item DEFENDER,         4
	card_item POTION,           3
	card_item FULL_HEAL,        2
	deck_list_end
	tx LovetoBattleDeckName

ExcavationDeck:
	deck_list_start
	card_item FIGHTING_ENERGY,    15
	card_item WATER_ENERGY,        8
	card_item SHELLDER,            3
	card_item CLOYSTER,            1
	card_item OMANYTE,             3
	card_item OMASTAR,             2
	card_item SANDSHREW,           4
	card_item SANDSLASH,           2
	card_item CUBONE,              3
	card_item MAROWAK_LV32,        1
	card_item HITMONCHAN,          3
	card_item KABUTO,              2
	card_item KABUTOPS,            1
	card_item AERODACTYL,          2
	card_item PROFESSOR_OAK,       2
	card_item BILL,                2
	card_item POKEMON_BREEDER,     2
	card_item MYSTERIOUS_FOSSIL,   4
	deck_list_end
	tx ExcavationDeckName

BlisteringPokemonDeck:
	deck_list_start
	card_item FIRE_ENERGY,             4
	card_item FIGHTING_ENERGY,         8
	card_item PSYCHIC_ENERGY,          5
	card_item DOUBLE_COLORLESS_ENERGY, 2
	card_item PONYTA,                  3
	card_item RAPIDASH,                2
	card_item ONIX,                    4
	card_item CUBONE,                  4
	card_item MAROWAK_LV26,            2
	card_item RHYHORN,                 4
	card_item RHYDON,                  2
	card_item JYNX,                    2
	card_item PROFESSOR_OAK,           2
	card_item BILL,                    3
	card_item POKEMON_TRADER,          2
	card_item ENERGY_RETRIEVAL,        1
	card_item MR_FUJI,                 2
	card_item SWITCH,                  3
	card_item DEFENDER,                3
	card_item GUST_OF_WIND,            2
	deck_list_end
	tx BlisteringPokemonDeckName

HardPokemonDeck:
	deck_list_start
	card_item FIGHTING_ENERGY, 25
	card_item GEODUDE,          4
	card_item GRAVELER,         3
	card_item GOLEM,            2
	card_item ONIX,             3
	card_item CUBONE,           3
	card_item MAROWAK_LV26,     2
	card_item RHYHORN,          2
	card_item RHYDON,           1
	card_item SNORLAX,          1
	card_item BILL,             3
	card_item POKE_BALL,        2
	card_item DEFENDER,         4
	card_item GUST_OF_WIND,     3
	card_item POTION,           2
	deck_list_end
	tx HardPokemonDeckName

WaterfrontPokemonDeck:
	deck_list_start
	card_item WATER_ENERGY,     18
	card_item PSYCHIC_ENERGY,    7
	card_item SQUIRTLE,          2
	card_item WARTORTLE,         1
	card_item BLASTOISE,         1
	card_item PSYDUCK,           2
	card_item GOLDUCK,           1
	card_item POLIWAG,           2
	card_item POLIWHIRL,         1
	card_item POLIWRATH,         1
	card_item GOLDEEN,           2
	card_item SEAKING,           1
	card_item STARYU,            2
	card_item STARMIE,           1
	card_item SLOWPOKE_LV18,     2
	card_item SLOWBRO,           1
	card_item FARFETCHD,         1
	card_item DRATINI,           2
	card_item DRAGONAIR,         1
	card_item BILL,              2
	card_item ENERGY_RETRIEVAL,  2
	card_item SWITCH,            2
	card_item POKEDEX,           1
	card_item GUST_OF_WIND,      1
	card_item POTION,            2
	card_item SUPER_POTION,      1
	deck_list_end
	tx WaterfrontPokemonDeckName

LonelyFriendsDeck:
	deck_list_start
	card_item GRASS_ENERGY,            8
	card_item WATER_ENERGY,            9
	card_item DOUBLE_COLORLESS_ENERGY, 4
	card_item SCYTHER,                 4
	card_item POLIWAG,                 4
	card_item OMANYTE,                 2
	card_item OMASTAR,                 1
	card_item AERODACTYL,              1
	card_item JIGGLYPUFF_LV13,         2
	card_item JIGGLYPUFF_LV14,         2
	card_item WIGGLYTUFF,              4
	card_item PROFESSOR_OAK,           2
	card_item BILL,                    2
	card_item CLEFAIRY_DOLL,           4
	card_item MYSTERIOUS_FOSSIL,       4
	card_item SCOOP_UP,                2
	card_item POTION,                  4
	card_item SUPER_POTION,            1
	deck_list_end
	tx LonelyFriendsDeckName

SoundoftheWavesDeck:
	deck_list_start
	card_item WATER_ENERGY,   24
	card_item TENTACOOL,       2
	card_item TENTACRUEL,      1
	card_item SEEL,            3
	card_item DEWGONG,         2
	card_item SHELLDER,        3
	card_item CLOYSTER,        2
	card_item KRABBY,          3
	card_item KINGLER,         2
	card_item HORSEA,          2
	card_item SEADRA,          1
	card_item LAPRAS,          3
	card_item BILL,            3
	card_item POKEMON_TRADER,  2
	card_item ENERGY_REMOVAL,  2
	card_item PLUSPOWER,       3
	card_item FULL_HEAL,       2
	deck_list_end
	tx SoundoftheWavesDeckName

PikachuDeck:
	deck_list_start
	card_item WATER_ENERGY,             6
	card_item LIGHTNING_ENERGY,        16
	card_item PIKACHU_LV12,             1
	card_item PIKACHU_LV14,             1
	card_item PIKACHU_LV16,             1
	card_item PIKACHU_ALT_LV16,         1
	card_item FLYING_PIKACHU,           4
	card_item SURFING_PIKACHU_LV13,     2
	card_item SURFING_PIKACHU_ALT_LV13,	2
	card_item RAICHU_LV40,              2
	card_item RAICHU_LV45,              2
	card_item BILL,                     4
	card_item SWITCH,                   4
	card_item POKE_BALL,                4
	card_item POTION,                   4
	card_item SUPER_POTION,             2
	card_item FULL_HEAL,                4
	deck_list_end
	tx PikachuDeckName

BoomBoomSelfdestructDeck:
	deck_list_start
	card_item GRASS_ENERGY,      8
	card_item LIGHTNING_ENERGY, 14
	card_item FIGHTING_ENERGY,   8
	card_item KOFFING,           4
	card_item WEEZING,           3
	card_item MAGNEMITE_LV15,    4
	card_item MAGNETON_LV28,     2
	card_item MAGNETON_LV35,     2
	card_item GEODUDE,           4
	card_item GRAVELER,          3
	card_item GOLEM,             2
	card_item PROFESSOR_OAK,     2
	card_item ENERGY_SEARCH,     2
	card_item DEFENDER,          2
	deck_list_end
	tx BoomBoomSelfdestructDeckName

PowerGeneratorDeck:
	deck_list_start
	card_item LIGHTNING_ENERGY, 26
	card_item PIKACHU_LV12,      2
	card_item PIKACHU_LV14,      1
	card_item RAICHU_LV40,       1
	card_item MAGNEMITE_LV13,    1
	card_item MAGNEMITE_LV15,    1
	card_item MAGNETON_LV28,     1
	card_item MAGNETON_LV35,     1
	card_item VOLTORB,           3
	card_item ELECTRODE_LV35,    1
	card_item ELECTRODE_LV42,    1
	card_item ELECTABUZZ_LV20,   1
	card_item ELECTABUZZ_LV35,   1
	card_item JOLTEON_LV29,      3
	card_item ZAPDOS_LV64,       2
	card_item EEVEE,             4
	card_item BILL,              2
	card_item POKEMON_TRADER,    2
	card_item SWITCH,            2
	card_item DEFENDER,          4
	deck_list_end
	tx PowerGeneratorDeckName

EtceteraDeck:
	deck_list_start
	card_item GRASS_ENERGY,     8
	card_item FIRE_ENERGY,      4
	card_item LIGHTNING_ENERGY, 4
	card_item FIGHTING_ENERGY,  4
	card_item PSYCHIC_ENERGY,   4
	card_item CATERPIE,         1
	card_item WEEDLE,           1
	card_item NIDORANF,         2
	card_item ODDISH,           2
	card_item TANGELA_LV12,     2
	card_item CHARMANDER,       2
	card_item MAGMAR_LV31,      1
	card_item PIKACHU_LV12,     2
	card_item MAGNEMITE_LV13,   1
	card_item DIGLETT,          1
	card_item MACHOP,           2
	card_item GASTLY_LV8,       2
	card_item JYNX,             1
	card_item BILL,             3
	card_item ENERGY_RETRIEVAL, 2
	card_item ENERGY_SEARCH,    3
	card_item POKE_BALL,        3
	card_item PLUSPOWER,        3
	card_item DEFENDER,         2
	deck_list_end
	tx EtceteraDeckName

FlowerGardenDeck:
	deck_list_start
	card_item GRASS_ENERGY,            24
	card_item DOUBLE_COLORLESS_ENERGY,  2
	card_item BULBASAUR,                3
	card_item IVYSAUR,                  2
	card_item VENUSAUR_LV67,            2
	card_item ODDISH,                   3
	card_item GLOOM,                    2
	card_item VILEPLUME,                2
	card_item BELLSPROUT,               2
	card_item WEEPINBELL,               1
	card_item VICTREEBEL,               1
	card_item TANGELA_LV8,              2
	card_item TANGELA_LV12,             1
	card_item LICKITUNG,                2
	card_item POKEMON_TRADER,           2
	card_item POKEMON_BREEDER,          3
	card_item ENERGY_SEARCH,            1
	card_item SWITCH,                   2
	card_item POTION,                   2
	card_item FULL_HEAL,                1
	deck_list_end
	tx FlowerGardenDeckName

KaleidoscopeDeck:
	deck_list_start
	card_item GRASS_ENERGY,            10
	card_item FIRE_ENERGY,              4
	card_item WATER_ENERGY,             4
	card_item LIGHTNING_ENERGY,         4
	card_item DOUBLE_COLORLESS_ENERGY,  3
	card_item VENONAT,                  3
	card_item VENOMOTH,                 2
	card_item FLAREON_LV22,             1
	card_item FLAREON_LV28,             1
	card_item VAPOREON_LV29,            1
	card_item VAPOREON_LV42,            1
	card_item JOLTEON_LV24,             1
	card_item JOLTEON_LV29,             1
	card_item DITTO,                    4
	card_item EEVEE,                    4
	card_item PORYGON,                  4
	card_item BILL,                     2
	card_item MR_FUJI,                  2
	card_item ENERGY_SEARCH,            2
	card_item SWITCH,                   4
	card_item GUST_OF_WIND,             2
	deck_list_end
	tx KaleidoscopeDeckName

GhostDeck:
	deck_list_start
	card_item PSYCHIC_ENERGY,          15
	card_item GRASS_ENERGY,             6
	card_item DOUBLE_COLORLESS_ENERGY,  3
	card_item ZUBAT,                    4
	card_item GOLBAT,                   3
	card_item GASTLY_LV8,               2
	card_item GASTLY_LV17,              2
	card_item HAUNTER_LV17,             2
	card_item HAUNTER_LV22,             2
	card_item GENGAR,                   4
	card_item MEOWTH_LV15,              3
	card_item DITTO,                    3
	card_item PROFESSOR_OAK,            2
	card_item BILL,                     1
	card_item POKEMON_BREEDER,          2
	card_item GUST_OF_WIND,             1
	card_item POTION,                   2
	card_item FULL_HEAL,                1
	card_item RECYCLE,                  2
	deck_list_end
	tx GhostDeckName

NapTimeDeck:
	deck_list_start
	card_item GRASS_ENERGY,     8
	card_item PSYCHIC_ENERGY,  18
	card_item PARAS,            4
	card_item EXEGGCUTE,        4
	card_item GASTLY_LV8,       4
	card_item HAUNTER_LV17,     2
	card_item HAUNTER_LV22,     2
	card_item JIGGLYPUFF_LV14,  4
	card_item WIGGLYTUFF,       3
	card_item BILL,             2
	card_item SWITCH,           2
	card_item PLUSPOWER,        3
	card_item GUST_OF_WIND,     2
	card_item POTION,           2
	deck_list_end
	tx NapTimeDeckName

StrangePowerDeck:
	deck_list_start
	card_item PSYCHIC_ENERGY,          25
	card_item DOUBLE_COLORLESS_ENERGY,  1
	card_item SLOWPOKE_LV9,             3
	card_item SLOWBRO,                  2
	card_item DROWZEE,                  4
	card_item HYPNO,                    3
	card_item MR_MIME,                  2
	card_item JYNX,                     2
	card_item MEW_LV8,                  1
	card_item MEW_LV23,                 2
	card_item LICKITUNG,                2
	card_item SNORLAX,                  1
	card_item POKEMON_TRADER,           2
	card_item ENERGY_RETRIEVAL,         2
	card_item ENERGY_REMOVAL,           2
	card_item SUPER_ENERGY_REMOVAL,     1
	card_item PLUSPOWER,                2
	card_item ITEM_FINDER,              1
	card_item GUST_OF_WIND,             1
	card_item FULL_HEAL,                1
	deck_list_end
	tx StrangePowerDeckName

FlyinPokemonDeck:
	deck_list_start
	card_item GRASS_ENERGY,            13
	card_item LIGHTNING_ENERGY,        10
	card_item DOUBLE_COLORLESS_ENERGY,  2
	card_item ZUBAT,                    4
	card_item GOLBAT,                   3
	card_item FLYING_PIKACHU,           2
	card_item PIDGEY,                   4
	card_item PIDGEOTTO,                3
	card_item PIDGEOT_LV38,             1
	card_item PIDGEOT_LV40,             1
	card_item SPEAROW,                  4
	card_item FEAROW,                   3
	card_item IMPOSTER_PROFESSOR_OAK,   2
	card_item LASS,                     2
	card_item BILL,                     2
	card_item POTION,                   4
	deck_list_end
	tx FlyinPokemonDeckName

LovelyNidoranDeck:
	deck_list_start
	card_item GRASS_ENERGY,    24
	card_item NIDORANF,         4
	card_item NIDORINA,         2
	card_item NIDOQUEEN,        2
	card_item NIDORANM,         3
	card_item NIDORINO,         2
	card_item NIDOKING,         1
	card_item GRIMER,           2
	card_item MUK,              1
	card_item KOFFING,          2
	card_item WEEZING,          1
	card_item PINSIR,           1
	card_item MEOWTH_LV15,      2
	card_item FARFETCHD,        2
	card_item DODUO,            2
	card_item PROFESSOR_OAK,    1
	card_item BILL,             2
	card_item POKEMON_BREEDER,  2
	card_item SWITCH,           1
	card_item POKE_BALL,        2
	card_item GAMBLER,          1
	deck_list_end
	tx LovelyNidoranDeckName

PoisonDeck:
	deck_list_start
	card_item GRASS_ENERGY,           24
	card_item WEEDLE,                  3
	card_item KAKUNA,                  2
	card_item BEEDRILL,                1
	card_item EKANS,                   4
	card_item ARBOK,                   3
	card_item NIDORANM,                4
	card_item NIDORINO,                3
	card_item NIDOKING,                2
	card_item KOFFING,                 3
	card_item WEEZING,                 2
	card_item PROFESSOR_OAK,           1
	card_item IMPOSTER_PROFESSOR_OAK,  2
	card_item POKEMON_BREEDER,         1
	card_item POTION,                  2
	card_item FULL_HEAL,               2
	card_item GAMBLER,                 1
	deck_list_end
	tx PoisonDeckName

AngerDeck:
	deck_list_start
	card_item FIRE_ENERGY,             10
	card_item FIGHTING_ENERGY,          8
	card_item DOUBLE_COLORLESS_ENERGY,  4
	card_item GROWLITHE,                3
	card_item ARCANINE_LV34,            2
	card_item CUBONE,                   3
	card_item RATTATA,                  3
	card_item RATICATE,                 2
	card_item DODUO,                    3
	card_item DODRIO,                   2
	card_item TAUROS,                   3
	card_item PROFESSOR_OAK,            2
	card_item BILL,                     3
	card_item ENERGY_RETRIEVAL,         2
	card_item COMPUTER_SEARCH,          2
	card_item PLUSPOWER,                4
	card_item DEFENDER,                 2
	card_item GUST_OF_WIND,             2
	deck_list_end
	tx AngerDeckName

FlamethrowerDeck:
	deck_list_start
	card_item FIRE_ENERGY,             22
	card_item DOUBLE_COLORLESS_ENERGY,  4
	card_item CHARMANDER,               2
	card_item CHARMELEON,               2
	card_item CHARIZARD,                1
	card_item VULPIX,                   2
	card_item NINETALES_LV32,           1
	card_item GROWLITHE,                2
	card_item ARCANINE_LV45,            1
	card_item MAGMAR_LV24,              3
	card_item FLAREON_LV28,             2
	card_item EEVEE,                    3
	card_item BILL,                     3
	card_item POKEMON_TRADER,           1
	card_item ENERGY_RETRIEVAL,         3
	card_item SUPER_ENERGY_RETRIEVAL,   1
	card_item SWITCH,                   2
	card_item PLUSPOWER,                2
	card_item GUST_OF_WIND,             3
	deck_list_end
	tx FlamethrowerDeckName

ReshuffleDeck:
	deck_list_start
	card_item FIRE_ENERGY,             23
	card_item DOUBLE_COLORLESS_ENERGY,  2
	card_item VULPIX,                   4
	card_item NINETALES_LV35,           3
	card_item GROWLITHE,                2
	card_item ARCANINE_LV45,            1
	card_item PONYTA,                   2
	card_item PIDGEY,                   4
	card_item PIDGEOTTO,                3
	card_item PIDGEOT_LV38,             2
	card_item JIGGLYPUFF_LV13,          1
	card_item WIGGLYTUFF,               1
	card_item LICKITUNG,                2
	card_item KANGASKHAN,               1
	card_item TAUROS,                   1
	card_item BILL,                     2
	card_item ENERGY_RETRIEVAL,         2
	card_item ENERGY_REMOVAL,           1
	card_item SUPER_ENERGY_REMOVAL,     1
	card_item SWITCH,                   2
	card_item POKEMON_CENTER,           1
	card_item POTION,                   2
	; this deck list has 63 cards
	;deck_list_end
	db 0
	tx ReshuffleDeckName

ImakuniDeck:
	deck_list_start
	card_item WATER_ENERGY,   10
	card_item PSYCHIC_ENERGY, 16
	card_item PSYDUCK,         4
	card_item GOLDUCK,         3
	card_item SLOWPOKE_LV9,    2
	card_item SLOWPOKE_LV18,   2
	card_item SLOWBRO,         3
	card_item DROWZEE,         4
	card_item HYPNO,           3
	card_item FARFETCHD,       4
	card_item IMAKUNI_CARD,    4
	card_item MAINTENANCE,     2
	card_item POKEMON_FLUTE,   2
	card_item GAMBLER,         1
	deck_list_end
	tx ImakuniDeckName
