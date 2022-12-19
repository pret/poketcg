MACRO anim_end
	db $00
ENDM
MACRO anim_normal
	db $01, \1
ENDM
MACRO anim_player
	db $02, \1
ENDM
MACRO anim_opponent
	db $03, \1
ENDM
MACRO anim_unknown
	db $04, \1
ENDM
MACRO anim_unknown2
	db $05, \1
ENDM
MACRO anim_end2
	db $06
ENDM

PointerTable_AttackAnimation:
	table_width 2, PointerTable_AttackAnimation
	dw NULL                                ; ATK_ANIM_NONE
	dw AttackAnimation_Hit                 ; ATK_ANIM_HIT
	dw AttackAnimation_BigHit              ; ATK_ANIM_BIG_HIT
	dw AttackAnimation_Hit                 ; ATK_ANIM_3
	dw AttackAnimation_Hit                 ; ATK_ANIM_HIT_RECOIL
	dw AttackAnimation_Hit                 ; ATK_ANIM_HIT_EFFECT
	dw AttackAnimation_ThunderShock        ; ATK_ANIM_THUNDERSHOCK
	dw AttackAnimation_ThunderShock        ; ATK_ANIM_THUNDER
	dw AttackAnimation_Thunderbolt         ; ATK_ANIM_THUNDERBOLT
	dw AttackAnimation_ThunderShock        ; ATK_ANIM_9
	dw AttackAnimation_BigLightning        ; ATK_ANIM_THUNDER_WHOLE_SCREEN
	dw AttackAnimation_BigLightning        ; ATK_ANIM_11
	dw AttackAnimation_BigLightning        ; ATK_ANIM_THUNDERSTORM
	dw AttackAnimation_BigLightning        ; ATK_ANIM_CHAIN_LIGHTNING
	dw AttackAnimation_SmallFlame          ; ATK_ANIM_SMALL_FLAME
	dw AttackAnimation_BigFlame            ; ATK_ANIM_BIG_FLAME
	dw AttackAnimation_FireSpin            ; ATK_ANIM_FIRE_SPIN
	dw AttackAnimation_DiveBomb            ; ATK_ANIM_DIVE_BOMB
	dw AttackAnimation_WaterJets           ; ATK_ANIM_WATER_JETS
	dw AttackAnimation_WaterGun            ; ATK_ANIM_WATER_GUN
	dw AttackAnimation_Whirlpool           ; ATK_ANIM_WHIRLPOOL
	dw AttackAnimation_DragonRage          ; ATK_ANIM_DRAGON_RAGE
	dw AttackAnimation_HydroPump           ; ATK_ANIM_HYDRO_PUMP
	dw AttackAnimation_Blizzard            ; ATK_ANIM_23
	dw AttackAnimation_Blizzard            ; ATK_ANIM_BLIZZARD
	dw AttackAnimation_PsychicHit          ; ATK_ANIM_PSYCHIC_HIT
	dw AttackAnimation_PsychicHit          ; ATK_ANIM_NIGHTMARE
	dw AttackAnimation_PsychicHit          ; ATK_ANIM_27
	dw AttackAnimation_DarkMind            ; ATK_ANIM_DARK_MIND
	dw AttackAnimation_Beam                ; ATK_ANIM_BEAM
	dw AttackAnimation_HyperBeam           ; ATK_ANIM_HYPER_BEAM
	dw AttackAnimation_Beam                ; ATK_ANIM_31
	dw AttackAnimation_RockThrow           ; ATK_ANIM_ROCK_THROW
	dw AttackAnimation_StoneBarrage        ; ATK_ANIM_STONE_BARRAGE
	dw AttackAnimation_Punch               ; ATK_ANIM_PUNCH
	dw AttackAnimation_Thunderpunch        ; ATK_ANIM_THUNDERPUNCH
	dw AttackAnimation_FirePunch           ; ATK_ANIM_FIRE_PUNCH
	dw AttackAnimation_StretchKick         ; ATK_ANIM_STRETCH_KICK
	dw AttackAnimation_Slash               ; ATK_ANIM_SLASH
	dw AttackAnimation_Whip                ; ATK_ANIM_WHIP
	dw AttackAnimation_Tear                ; ATK_ANIM_TEAR
	dw AttackAnimation_MultipleSlash       ; ATK_ANIM_MULTIPLE_SLASH
	dw AttackAnimation_MultipleSlash       ; ATK_ANIM_42
	dw AttackAnimation_MultipleSlash       ; ATK_ANIM_RAMPAGE
	dw AttackAnimation_Drill               ; ATK_ANIM_DRILL
	dw AttackAnimation_PotSmash            ; ATK_ANIM_POT_SMASH
	dw AttackAnimation_Bonemerang          ; ATK_ANIM_BONEMERANG
	dw AttackAnimation_SeismicToss         ; ATK_ANIM_SEISMIC_TOSS
	dw AttackAnimation_Needles             ; ATK_ANIM_NEEDLES
	dw AttackAnimation_Needles             ; ATK_ANIM_49
	dw AttackAnimation_WhiteGas            ; ATK_ANIM_SMOG
	dw AttackAnimation_WhiteGas            ; ATK_ANIM_51
	dw AttackAnimation_WhiteGas            ; ATK_ANIM_52
	dw AttackAnimation_WhiteGas            ; ATK_ANIM_FOUL_GAS
	dw AttackAnimation_WhiteGas            ; ATK_ANIM_FOUL_ODOR
	dw AttackAnimation_Powder              ; ATK_ANIM_POWDER_EFFECT_CHANCE
	dw AttackAnimation_Powder              ; ATK_ANIM_POWDER_HIT_POISON
	dw AttackAnimation_544e                ; ATK_ANIM_POISON_POWDER
	dw AttackAnimation_Powder              ; ATK_ANIM_58
	dw AttackAnimation_Powder              ; ATK_ANIM_59
	dw AttackAnimation_Powder              ; ATK_ANIM_60
	dw AttackAnimation_Goo                 ; ATK_ANIM_GOO
	dw AttackAnimation_Goo                 ; ATK_ANIM_62
	dw AttackAnimation_SpitPoisonFail      ; ATK_ANIM_SPIT_POISON
	dw AttackAnimation_Goo                 ; ATK_ANIM_64
	dw AttackAnimation_Bubbles             ; ATK_ANIM_BUBBLES
	dw AttackAnimation_Bubbles             ; ATK_ANIM_66
	dw AttackAnimation_StringShot          ; ATK_ANIM_STRING_SHOT
	dw AttackAnimation_StringShot          ; ATK_ANIM_68
	dw AttackAnimation_Boyfriends          ; ATK_ANIM_BOYFRIENDS
	dw AttackAnimation_Lure                ; ATK_ANIM_LURE
	dw AttackAnimation_Toxic               ; ATK_ANIM_TOXIC
	dw AttackAnimation_ConfuseRay          ; ATK_ANIM_CONFUSE_RAY
	dw AttackAnimation_ConfuseRay          ; ATK_ANIM_73
	dw AttackAnimation_Sing                ; ATK_ANIM_SING
	dw AttackAnimation_Sing                ; ATK_ANIM_LULLABY
	dw AttackAnimation_Supersonic          ; ATK_ANIM_SUPERSONIC
	dw AttackAnimation_Supersonic          ; ATK_ANIM_77
	dw AttackAnimation_PetalDance          ; ATK_ANIM_PETAL_DANCE
	dw AttackAnimation_Protect             ; ATK_ANIM_PROTECT
	dw AttackAnimation_Barrier             ; ATK_ANIM_BARRIER
	dw AttackAnimation_QuickAttack         ; ATK_ANIM_QUICK_ATTACK
	dw AttackAnimation_AgilityProtect      ; ATK_ANIM_AGILITY_PROTECT
	dw AttackAnimation_Whirlwind           ; ATK_ANIM_WHIRLWIND
	dw AttackAnimation_Cry                 ; ATK_ANIM_CRY
	dw AttackAnimation_Amnesia             ; ATK_ANIM_AMNESIA
	dw AttackAnimation_Selfdestruct        ; ATK_ANIM_SELFDESTRUCT
	dw AttackAnimation_BigSelfdestruct     ; ATK_ANIM_BIG_SELFDESTRUCTION
	dw AttackAnimation_Recover             ; ATK_ANIM_RECOVER
	dw AttackAnimation_Drain               ; ATK_ANIM_DRAIN
	dw AttackAnimation_DarkGas             ; ATK_ANIM_DARK_GAS
	dw AttackAnimation_GlowEffect          ; ATK_ANIM_GLOW_EFFECT
	dw AttackAnimation_MirrorMove          ; ATK_ANIM_MIRROR_MOVE
	dw AttackAnimation_DevolutionBeam      ; ATK_ANIM_DEVOLUTION_BEAM
	dw AttackAnimation_5543                ; ATK_ANIM_PKMN_POWER_1
	dw AttackAnimation_Firegiver           ; ATK_ANIM_FIREGIVER
	dw AttackAnimation_Quickfreeze         ; ATK_ANIM_QUICKFREEZE
	dw AttackAnimation_PealOfThunder       ; ATK_ANIM_PEAL_OF_THUNDER
	dw AttackAnimation_HealingWind         ; ATK_ANIM_HEALING_WIND
	dw AttackAnimation_WhirlwindZigzag     ; ATK_ANIM_WHIRLWIND_ZIGZAG
	dw AttackAnimation_BigThunder          ; ATK_ANIM_BIG_THUNDER
	dw AttackAnimation_SolarPower          ; ATK_ANIM_SOLAR_POWER
	dw AttackAnimation_PoisonFang          ; ATK_ANIM_POISON_FANG
	dw AttackAnimation_PoisonFang          ; ATK_ANIM_103
	dw AttackAnimation_PoisonFang          ; ATK_ANIM_104
	dw AttackAnimation_558c                ; ATK_ANIM_105
	dw AttackAnimation_FriendshipSong      ; ATK_ANIM_FRIENDSHIP_SONG
	dw AttackAnimation_Scrunch             ; ATK_ANIM_SCRUNCH
	dw AttackAnimation_CatPunch            ; ATK_ANIM_CAT_PUNCH
	dw AttackAnimation_MagneticStorm       ; ATK_ANIM_MAGNETIC_STORM
	dw AttackAnimation_PoisonWhip          ; ATK_ANIM_POISON_WHIP
	dw AttackAnimation_ThunderWave         ; ATK_ANIM_THUNDER_WAVE
	dw AttackAnimation_ThunderWave         ; ATK_ANIM_112
	dw AttackAnimation_Spore               ; ATK_ANIM_SPORE
	dw AttackAnimation_Hypnosis            ; ATK_ANIM_HYPNOSIS
	dw AttackAnimation_EnergyConversion    ; ATK_ANIM_ENERGY_CONVERSION
	dw AttackAnimation_Leer                ; ATK_ANIM_LEER
	dw AttackAnimation_ConfusionHit        ; ATK_ANIM_CONFUSION_HIT
	dw AttackAnimation_55e0                ; ATK_ANIM_118
	dw AttackAnimation_55e5                ; ATK_ANIM_119
	dw AttackAnimation_BenchHit            ; ATK_ANIM_BENCH_HIT
	dw AttackAnimation_Heal                ; ATK_ANIM_HEAL
	dw AttackAnimation_RecoilHit           ; ATK_ANIM_RECOIL_HIT
	dw AttackAnimation_Poison              ; ATK_ANIM_POISON
	dw AttackAnimation_Confusion           ; ATK_ANIM_CONFUSION
	dw AttackAnimation_Paralysis           ; ATK_ANIM_PARALYSIS
	dw AttackAnimation_Sleep               ; ATK_ANIM_SLEEP
	dw AttackAnimation_ImakuniConfusion    ; ATK_ANIM_IMAKUNI_CONFUSION
	dw AttackAnimation_SleepingGas         ; ATK_ANIM_SLEEPING_GAS
	dw AttackAnimation_560f                ; ATK_ANIM_129
	dw AttackAnimation_ThunderPlayArea     ; ATK_ANIM_THUNDER_PLAY_AREA
	dw AttackAnimation_CatPunchPlayArea    ; ATK_ANIM_CAT_PUNCH_PLAY_AREA
	dw AttackAnimation_FiregiverPlayer     ; ATK_ANIM_FIREGIVER_PLAYER
	dw AttackAnimation_FiregiverOpp        ; ATK_ANIM_FIREGIVER_OPP
	dw AttackAnimation_HealingWindPlayArea ; ATK_ANIM_HEALING_WIND_PLAY_AREA
	dw AttackAnimation_Gale                ; ATK_ANIM_GALE
	dw AttackAnimation_Expand              ; ATK_ANIM_EXPAND
	dw AttackAnimation_564f                ; ATK_ANIM_137
	dw AttackAnimation_FullHeal            ; ATK_ANIM_FULL_HEAL
	dw AttackAnimation_5659                ; ATK_ANIM_139
	dw AttackAnimation_SpitPoisonSuccess   ; ATK_ANIM_SPIT_POISON_SUCCESS
	dw AttackAnimation_GustOfWind          ; ATK_ANIM_GUST_OF_WIND
	dw AttackAnimation_HealBothSides       ; ATK_ANIM_HEAL_BOTH_SIDES
	dw AttackAnimation_5673                ; ATK_ANIM_143
	dw AttackAnimation_5673                ; ATK_ANIM_144
	assert_table_length NUM_ATK_ANIMS

AttackAnimation_Hit: ; (6:52c6)
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_BigHit:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_BIG_HIT
	anim_normal         DUEL_ANIM_SHAKE2
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_ThunderShock:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_THUNDER_SHOCK
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Thunderbolt:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_LIGHTNING
	anim_opponent       DUEL_ANIM_BORDER_SPARK
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_BigLightning:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_FLASH
	anim_normal         DUEL_ANIM_BIG_LIGHTNING
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_SmallFlame:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_SMALL_FLAME
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_BigFlame:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_BIG_FLAME
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_FireSpin:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_FIRE_SPIN
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_DiveBomb:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_DIVE_BOMB
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_WaterJets:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_WATER_JETS
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_WaterGun:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_WATER_GUN
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Whirlpool:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_WHIRLPOOL
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_DragonRage:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_LIGHTNING
	anim_opponent       DUEL_ANIM_WATER_GUN
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_HydroPump:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_HYDRO_PUMP
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Blizzard:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_BLIZZARD
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_PsychicHit:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_PSYCHIC
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_DarkMind:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_GLARE
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Beam:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_BEAM
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_HyperBeam:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_HYPER_BEAM
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_RockThrow:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_ROCK_THROW
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_StoneBarrage:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_STONE_BARRAGE
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Punch:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_PUNCH
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Thunderpunch:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_THUNDERPUNCH
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_FirePunch:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_FIRE_PUNCH
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_StretchKick:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_STRETCH_KICK
	anim_end

AttackAnimation_Slash:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_SLASH
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Whip:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_WHIP
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Tear:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_TEAR
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_MultipleSlash:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_FURY_SWIPES
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Drill:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_DRILL
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_PotSmash:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_POT_SMASH
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Bonemerang:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_BONEMERANG
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_SeismicToss:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_SEISMIC_TOSS
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Needles:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_NEEDLES
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_WhiteGas:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_WHITE_GAS
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Powder:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_POWDER
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_544e:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_POWDER
	anim_end

AttackAnimation_Goo:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_GOO
	anim_normal         DUEL_ANIM_DISTORT
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_SpitPoisonFail:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_GOO
	anim_normal         DUEL_ANIM_DISTORT
	anim_end

AttackAnimation_Bubbles:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_BUBBLES
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_StringShot:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_STRING_SHOT
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Boyfriends:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_BOYFRIENDS
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Lure:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_LURE
	anim_normal         DUEL_ANIM_DISTORT
	anim_end

AttackAnimation_Toxic:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_DISTORT
	anim_opponent       DUEL_ANIM_TOXIC
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_ConfuseRay:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_FLASH
	anim_opponent       DUEL_ANIM_CONFUSE_RAY
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Sing:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_SING
	anim_end

AttackAnimation_Supersonic:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_SUPERSONIC
	anim_end

AttackAnimation_PetalDance:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_PETAL_DANCE
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Protect:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_PROTECT
	anim_end

AttackAnimation_Barrier:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_BARRIER
	anim_end

AttackAnimation_QuickAttack:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_QUICK_ATTACK
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_AgilityProtect:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_QUICK_ATTACK
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_player         DUEL_ANIM_PROTECT
	anim_end

AttackAnimation_Whirlwind:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_WHIRLWIND
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Cry:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_CRY
	anim_normal         DUEL_ANIM_SHAKE1
	anim_end

AttackAnimation_Amnesia:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_QUESTION_MARK
	anim_end

AttackAnimation_Selfdestruct:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_SELFDESTRUCT
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_BigSelfdestruct:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_BIG_SELFDESTRUCT_1
	anim_normal         DUEL_ANIM_FLASH
	anim_player         DUEL_ANIM_BIG_SELFDESTRUCT_2
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Recover:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_Drain:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_DRAIN
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_DarkGas:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_DARK_GAS
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_opponent       DUEL_ANIM_QUESTION_MARK
	anim_end

AttackAnimation_GlowEffect:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_FLASH
	anim_end

AttackAnimation_MirrorMove:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_FLASH
	anim_opponent       DUEL_ANIM_GLOW
	anim_end

AttackAnimation_DevolutionBeam:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_FLASH
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_70
	anim_end

AttackAnimation_5543:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_70
	anim_normal         DUEL_ANIM_FLASH
	anim_end

AttackAnimation_Firegiver:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_70
	anim_normal         DUEL_ANIM_FLASH
	anim_unknown2       DUEL_ANIM_71
	anim_unknown2       DUEL_ANIM_71
	anim_end

AttackAnimation_Quickfreeze:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_70
	anim_normal         DUEL_ANIM_69
	anim_unknown        $01
	anim_end

AttackAnimation_PealOfThunder:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_70
	anim_unknown2       DUEL_ANIM_68
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_HealingWind:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_70
	anim_unknown2       DUEL_ANIM_73
	anim_end

AttackAnimation_WhirlwindZigzag:
	anim_player         DUEL_ANIM_GLOW
	anim_unknown        $04
	anim_normal         DUEL_ANIM_74
	anim_end

AttackAnimation_BigThunder:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_SolarPower:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_FLASH
	anim_end

AttackAnimation_PoisonFang:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_558c:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_NEEDLES
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_FriendshipSong:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_SING
	anim_end

AttackAnimation_Scrunch:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_EXPAND
	anim_end

AttackAnimation_CatPunch:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_MagneticStorm:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_THUNDER_WAVE
	anim_end

AttackAnimation_PoisonWhip:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_WHIP
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_ThunderWave:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_THUNDER_WAVE
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Spore:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_POWDER
	anim_end

AttackAnimation_Hypnosis:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_PSYCHIC
	anim_end

AttackAnimation_EnergyConversion:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_FLASH
	anim_end

AttackAnimation_Leer:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_GLARE
	anim_opponent       DUEL_ANIM_QUESTION_MARK
	anim_end

AttackAnimation_ConfusionHit:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_CONFUSION
	anim_player         DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE3
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55e0:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_WATER_JETS
	anim_end

AttackAnimation_55e5:
	anim_end

AttackAnimation_BenchHit:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_6
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Heal:
	anim_player         DUEL_ANIM_HEAL
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_RecoilHit:
	anim_unknown        $01
	anim_player         DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE3
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Poison:
	anim_opponent       DUEL_ANIM_POISON
	anim_end

AttackAnimation_Confusion:
	anim_opponent       DUEL_ANIM_CONFUSION
	anim_end

AttackAnimation_Paralysis:
	anim_opponent       DUEL_ANIM_PARALYSIS
	anim_end

AttackAnimation_Sleep:
	anim_opponent       DUEL_ANIM_SLEEP
	anim_end

AttackAnimation_ImakuniConfusion:
	anim_player         DUEL_ANIM_CONFUSION
	anim_end

AttackAnimation_SleepingGas:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_WHITE_GAS
	anim_end

AttackAnimation_560f:
	anim_opponent       DUEL_ANIM_QUESTION_MARK
	anim_end

AttackAnimation_ThunderPlayArea:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_68
	anim_unknown2       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_CatPunchPlayArea:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_76
	anim_unknown2       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_FiregiverPlayer:
	anim_unknown        $04
	anim_normal         DUEL_ANIM_78
	anim_end

AttackAnimation_FiregiverOpp:
	anim_unknown        $04
	anim_normal         DUEL_ANIM_79
	anim_end

AttackAnimation_HealingWindPlayArea:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Gale:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_WHIRLWIND
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_normal         DUEL_ANIM_FLASH
	anim_end

AttackAnimation_Expand:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_EXPAND
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_564f:
	anim_player         DUEL_ANIM_POISON
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_FullHeal:
	anim_player         DUEL_ANIM_HEAL
	anim_normal         $98
	anim_end

AttackAnimation_5659:
	anim_player         DUEL_ANIM_SLEEP
	anim_normal         $98
	anim_end

AttackAnimation_SpitPoisonSuccess:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_GOO
	anim_normal         DUEL_ANIM_DISTORT
	anim_end

AttackAnimation_GustOfWind:
	anim_opponent       DUEL_ANIM_WHIRLWIND
	anim_end

AttackAnimation_HealBothSides:
	anim_unknown        $04
	anim_unknown2       DUEL_ANIM_70
	anim_unknown        $01
	anim_player         DUEL_ANIM_HEAL
	anim_opponent       DUEL_ANIM_HEAL
	anim_end

AttackAnimation_5673:
	anim_end
