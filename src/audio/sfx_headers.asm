NumberOfSFX:
	db NUM_SFX

SFXHeaderPointers:
	table_width 2, SFXHeaderPointers
	dw Sfx_Stop
	dw Sfx_Cursor
	dw Sfx_Confirm
	dw Sfx_Cancel
	dw Sfx_Denied
	dw Sfx_Unused05
	dw Sfx_Unused06
	dw Sfx_CardShuffle
	dw Sfx_PlacePrize
	dw Sfx_Unused09
	dw Sfx_Unused0a
	dw Sfx_CoinToss
	dw Sfx_Warp
	dw Sfx_Unused0d
	dw Sfx_Unused0e
	dw Sfx_PokemonDomeDoors
	dw Sfx_LegendaryCards
	dw Sfx_Glow
	dw Sfx_Paralysis
	dw Sfx_Sleep
	dw Sfx_Confusion
	dw Sfx_Poison
	dw Sfx_SingleHit
	dw Sfx_BigHit
	dw Sfx_ThunderShock
	dw Sfx_Lightning
	dw Sfx_BorderSpark
	dw Sfx_BigLightning
	dw Sfx_SmallFlame
	dw Sfx_BigFlame
	dw Sfx_FireSpin
	dw Sfx_DiveBomb
	dw Sfx_WaterJets
	dw Sfx_WaterGun
	dw Sfx_Whirlpool
	dw Sfx_HydroPump
	dw Sfx_Blizzard
	dw Sfx_Psychic
	dw Sfx_Leer
	dw Sfx_Beam
	dw Sfx_HyperBeam
	dw Sfx_RockThrow
	dw Sfx_StoneBarrage
	dw Sfx_Punch
	dw Sfx_StretchKick
	dw Sfx_Slash
	dw Sfx_Sonicboom
	dw Sfx_FurySwipes
	dw Sfx_Drill
	dw Sfx_PotSmash
	dw Sfx_Bonemerang
	dw Sfx_SeismicToss
	dw Sfx_Needles
	dw Sfx_WhiteGas
	dw Sfx_Powder
	dw Sfx_Goo
	dw Sfx_Bubbles
	dw Sfx_StringShot
	dw Sfx_Boyfriends
	dw Sfx_Lure
	dw Sfx_Toxic
	dw Sfx_ConfuseRay
	dw Sfx_Sing
	dw Sfx_Supersonic
	dw Sfx_PetalDance
	dw Sfx_Protect
	dw Sfx_Barrier
	dw Sfx_Speed
	dw Sfx_Whirlwind
	dw Sfx_Cry
	dw Sfx_QuestionMark
	dw Sfx_Selfdestruct
	dw Sfx_BigSelfdestruct
	dw Sfx_Heal
	dw Sfx_Drain
	dw Sfx_DarkGas
	dw Sfx_HealingWind
	dw Sfx_BenchWhirlwind
	dw Sfx_Expand
	dw Sfx_CatPunch
	dw Sfx_ThunderWave
	dw Sfx_Firegiver
	dw Sfx_Thunderpunch
	dw Sfx_FirePunch
	dw Sfx_CoinTossHeads
	dw Sfx_CoinTossTails
	dw Sfx_SaveGame
	dw Sfx_PlayerWalkMap
	dw Sfx_IntroOrb
	dw Sfx_IntroOrbSwoop
	dw Sfx_IntroOrbTitle
	dw Sfx_IntroOrbScatter
	dw Sfx_FiregiverStart
	dw Sfx_ReceiveCardPop
	dw Sfx_PokemonEvolution
	dw Sfx_Unused5f
	assert_table_length NUM_SFX

Sfx_Stop:
	db %0000

Sfx_Cursor:
	db %0010
	dw Sfx_Cursor_Ch1

Sfx_Confirm:
	db %0010
	dw Sfx_Confirm_Ch1

Sfx_Cancel:
	db %0010
	dw Sfx_Cancel_Ch1

Sfx_Denied:
	db %0010
	dw Sfx_Denied_Ch1

Sfx_Unused05:
	db %0010
	dw Sfx_Unused05_Ch1

Sfx_Unused06:
	db %0010
	dw Sfx_Unused06_Ch1

Sfx_CardShuffle:
	db %1000
	dw Sfx_CardShuffle_Ch1

Sfx_PlacePrize:
	db %1000
	dw Sfx_PlacePrize_Ch1

Sfx_Unused09:
	db %1000
	dw Sfx_Unused09_Ch1

Sfx_Unused0a:
	db %0010
	dw Sfx_Unused0a_Ch1

Sfx_CoinToss:
	db %0010
	dw Sfx_CoinToss_Ch1

Sfx_Warp:
	db %1000
	dw Sfx_Warp_Ch1

Sfx_Unused0d:
	db %0010
	dw Sfx_Unused0d_Ch1

Sfx_Unused0e:
	db %0010
	dw Sfx_Unused0e_Ch1

Sfx_PokemonDomeDoors:
	db %1000
	dw Sfx_PokemonDomeDoors_Ch1

Sfx_LegendaryCards:
	db %0010
	dw Sfx_LegendaryCards_Ch1

Sfx_Glow:
	db %0010
	dw Sfx_Glow_Ch1

Sfx_Paralysis:
	db %0010
	dw Sfx_Paralysis_Ch1

Sfx_Sleep:
	db %0010
	dw Sfx_Sleep_Ch1

Sfx_Confusion:
	db %0010
	dw Sfx_Confusion_Ch1

Sfx_Poison:
	db %0010
	dw Sfx_Poison_Ch1

Sfx_SingleHit:
	db %1000
	dw Sfx_SingleHit_Ch1

Sfx_BigHit:
	db %1000
	dw Sfx_BigHit_Ch1

Sfx_ThunderShock:
	db %1000
	dw Sfx_ThunderShock_Ch1

Sfx_Lightning:
	db %1000
	dw Sfx_Lightning_Ch1

Sfx_BorderSpark:
	db %1000
	dw Sfx_BorderSpark_Ch1

Sfx_BigLightning:
	db %1000
	dw Sfx_BigLightning_Ch1

Sfx_SmallFlame:
	db %1000
	dw Sfx_SmallFlame_Ch1

Sfx_BigFlame:
	db %1000
	dw Sfx_BigFlame_Ch1

Sfx_FireSpin:
	db %1000
	dw Sfx_FireSpin_Ch1

Sfx_DiveBomb:
	db %1000
	dw Sfx_DiveBomb_Ch1

Sfx_WaterJets:
	db %1000
	dw Sfx_WaterJets_Ch1

Sfx_WaterGun:
	db %1000
	dw Sfx_WaterGun_Ch1

Sfx_Whirlpool:
	db %1000
	dw Sfx_Whirlpool_Ch1

Sfx_HydroPump:
	db %1000
	dw Sfx_HydroPump_Ch1

Sfx_Blizzard:
	db %1000
	dw Sfx_Blizzard_Ch1

Sfx_Psychic:
	db %0010
	dw Sfx_Psychic_Ch1

Sfx_Leer:
	db %0010
	dw Sfx_Leer_Ch1

Sfx_Beam:
	db %0010
	dw Sfx_Beam_Ch1

Sfx_HyperBeam:
	db %1010
	dw Sfx_HyperBeam_Ch1
	dw Sfx_HyperBeam_Ch2

Sfx_RockThrow:
	db %1000
	dw Sfx_RockThrow_Ch1

Sfx_StoneBarrage:
	db %1000
	dw Sfx_StoneBarrage_Ch1

Sfx_Punch:
	db %0010
	dw Sfx_Punch_Ch1

Sfx_StretchKick:
	db %0010
	dw Sfx_StretchKick_Ch1

Sfx_Slash:
	db %1000
	dw Sfx_Slash_Ch1

Sfx_Sonicboom:
	db %1000
	dw Sfx_Sonicboom_Ch1

Sfx_FurySwipes:
	db %1000
	dw Sfx_FurySwipes_Ch1

Sfx_Drill:
	db %1000
	dw Sfx_Drill_Ch1

Sfx_PotSmash:
	db %0010
	dw Sfx_PotSmash_Ch1

Sfx_Bonemerang:
	db %1010
	dw Sfx_Bonemerang_Ch1
	dw Sfx_Bonemerang_Ch2

Sfx_SeismicToss:
	db %1010
	dw Sfx_SeismicToss_Ch1
	dw Sfx_SeismicToss_Ch2

Sfx_Needles:
	db %0010
	dw Sfx_Needles_Ch1

Sfx_WhiteGas:
	db %1000
	dw Sfx_WhiteGas_Ch1

Sfx_Powder:
	db %0010
	dw Sfx_Powder_Ch1

Sfx_Goo:
	db %1010
	dw Sfx_Goo_Ch1
	dw Sfx_Goo_Ch2

Sfx_Bubbles:
	db %0010
	dw Sfx_Bubbles_Ch1

Sfx_StringShot:
	db %1010
	dw Sfx_StringShot_Ch1
	dw Sfx_StringShot_Ch2

Sfx_Boyfriends:
	db %0010
	dw Sfx_Boyfriends_Ch1

Sfx_Lure:
	db %0010
	dw Sfx_Lure_Ch1

Sfx_Toxic:
	db %0010
	dw Sfx_Toxic_Ch1

Sfx_ConfuseRay:
	db %0010
	dw Sfx_ConfuseRay_Ch1

Sfx_Sing:
	db %0010
	dw Sfx_Sing_Ch1

Sfx_Supersonic:
	db %1000
	dw Sfx_Supersonic_Ch1

Sfx_PetalDance:
	db %0010
	dw Sfx_PetalDance_Ch1

Sfx_Protect:
	db %0010
	dw Sfx_Protect_Ch1

Sfx_Barrier:
	db %0010
	dw Sfx_Barrier_Ch1

Sfx_Speed:
	db %1000
	dw Sfx_Speed_Ch1

Sfx_Whirlwind:
	db %1000
	dw Sfx_Whirlwind_Ch1

Sfx_Cry:
	db %0010
	dw Sfx_Cry_Ch1

Sfx_QuestionMark:
	db %0010
	dw Sfx_QuestionMark_Ch1

Sfx_Selfdestruct:
	db %1000
	dw Sfx_Selfdestruct_Ch1

Sfx_BigSelfdestruct:
	db %1000
	dw Sfx_BigSelfdestruct_Ch1

Sfx_Heal:
	db %0010
	dw Sfx_Heal_Ch1

Sfx_Drain:
	db %0010
	dw Sfx_Drain_Ch1

Sfx_DarkGas:
	db %1000
	dw Sfx_DarkGas_Ch1

Sfx_HealingWind:
	db %0010
	dw Sfx_HealingWind_Ch1

Sfx_BenchWhirlwind:
	db %0010
	dw Sfx_BenchWhirlwind_Ch1

Sfx_Expand:
	db %0010
	dw Sfx_Expand_Ch1

Sfx_CatPunch:
	db %0010
	dw Sfx_CatPunch_Ch1

Sfx_ThunderWave:
	db %1010
	dw Sfx_ThunderWave_Ch1
	dw Sfx_ThunderWave_Ch2

Sfx_Firegiver:
	db %1010
	dw Sfx_Firegiver_Ch1
	dw Sfx_Firegiver_Ch2

Sfx_Thunderpunch:
	db %1010
	dw Sfx_Thunderpunch_Ch1
	dw Sfx_Thunderpunch_Ch2

Sfx_FirePunch:
	db %1010
	dw Sfx_FirePunch_Ch1
	dw Sfx_FirePunch_Ch2

Sfx_CoinTossHeads:
	db %0010
	dw Sfx_CoinTossHeads_Ch1

Sfx_CoinTossTails:
	db %0010
	dw Sfx_CoinTossTails_Ch1

Sfx_SaveGame:
	db %0010
	dw Sfx_SaveGame_Ch1

Sfx_PlayerWalkMap:
	db %0010
	dw Sfx_PlayerWalkMap_Ch1

Sfx_IntroOrb:
	db %0010
	dw Sfx_IntroOrb_Ch1

Sfx_IntroOrbSwoop:
	db %0010
	dw Sfx_IntroOrbSwoop_Ch1

Sfx_IntroOrbTitle:
	db %0010
	dw Sfx_IntroOrbTitle_Ch1

Sfx_IntroOrbScatter:
	db %0010
	dw Sfx_IntroOrbScatter_Ch1

Sfx_FiregiverStart:
	db %1000
	dw Sfx_FiregiverStart_Ch1

Sfx_ReceiveCardPop:
	db %1011
	dw Sfx_ReceiveCardPop_Ch1
	dw Sfx_ReceiveCardPop_Ch2
	dw Sfx_ReceiveCardPop_Ch3

Sfx_PokemonEvolution:
	db %0010
	dw Sfx_PokemonEvolution_Ch1

Sfx_Unused5f:
	db %1000
	dw Sfx_Unused5f_Ch1
