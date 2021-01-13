anim_end: MACRO
	db $00
ENDM
anim_normal: MACRO
	db $01, \1
ENDM
anim_player: MACRO
	db $02, \1
ENDM
anim_opponent: MACRO
	db $03, \1
ENDM
anim_unknown: MACRO
	db $04, \1
ENDM
anim_unknown2: MACRO
	db $05, \1
ENDM
anim_end2: MACRO
	db $06
ENDM

PointerTable_AttackAnimation:
	dw $0000                            ; ATK_ANIM_NONE
	dw AttackAnimation_Hit              ; ATK_ANIM_HIT
	dw AttackAnimation_BigHit           ; ATK_ANIM_BIG_HIT
	dw AttackAnimation_Hit              ; ATK_ANIM_3
	dw AttackAnimation_Hit              ; ATK_ANIM_HIT_RECOIL
	dw AttackAnimation_Hit              ; ATK_ANIM_HIT_EFFECT
	dw AttackAnimation_ThunderShock     ; ATK_ANIM_THUNDERSHOCK
	dw AttackAnimation_ThunderShock     ; ATK_ANIM_THUNDER
	dw AttackAnimation_Thunderbolt      ; ATK_ANIM_THUNDERBOLT
	dw AttackAnimation_ThunderShock     ; ATK_ANIM_9
	dw AttackAnimation_52f0             ; ATK_ANIM_THUNDER_WHOLE_SCREEN
	dw AttackAnimation_52f0             ; ATK_ANIM_11
	dw AttackAnimation_52f0             ; ATK_ANIM_THUNDERSTORM
	dw AttackAnimation_52f0             ; ATK_ANIM_CHAIN_LIGHTNING
	dw AttackAnimation_SmallFlame       ; ATK_ANIM_SMALL_FLAME
	dw AttackAnimation_BigFlame         ; ATK_ANIM_BIG_FLAME
	dw AttackAnimation_FireSpin         ; ATK_ANIM_FIRE_SPIN
	dw AttackAnimation_531e             ; ATK_ANIM_17
	dw AttackAnimation_WaterJets        ; ATK_ANIM_WATER_JETS
	dw AttackAnimation_WaterGun         ; ATK_ANIM_WATER_GUN
	dw AttackAnimation_Whirlpool        ; ATK_ANIM_WHIRLPOOL
	dw AttackAnimation_DragonRage       ; ATK_ANIM_DRAGON_RAGE
	dw AttackAnimation_HydroPump        ; ATK_ANIM_HYDRO_PUMP
	dw AttackAnimation_Blizzard         ; ATK_ANIM_23
	dw AttackAnimation_Blizzard         ; ATK_ANIM_BLIZZARD
	dw AttackAnimation_PsychicHit       ; ATK_ANIM_PSYCHIC_HIT
	dw AttackAnimation_PsychicHit       ; ATK_ANIM_NIGHTMARE
	dw AttackAnimation_PsychicHit       ; ATK_ANIM_27
	dw AttackAnimation_DarkMind         ; ATK_ANIM_DARK_MIND
	dw AttackAnimation_Beam             ; ATK_ANIM_BEAM
	dw AttackAnimation_HyperBeam        ; ATK_ANIM_HYPER_BEAM
	dw AttackAnimation_Beam             ; ATK_ANIM_31
	dw AttackAnimation_RockThrow        ; ATK_ANIM_ROCK_THROW
	dw AttackAnimation_StoneBarrage     ; ATK_ANIM_STONE_BARRAGE
	dw AttackAnimation_Punch            ; ATK_ANIM_PUNCH
	dw AttackAnimation_Thunderpunch     ; ATK_ANIM_THUNDERPUNCH
	dw AttackAnimation_FirePunch        ; ATK_ANIM_FIRE_PUNCH
	dw AttackAnimation_StretchKick      ; ATK_ANIM_STRETCH_KICK
	dw AttackAnimation_Slash            ; ATK_ANIM_SLASH
	dw AttackAnimation_Whip             ; ATK_ANIM_WHIP
	dw AttackAnimation_Tear             ; ATK_ANIM_TEAR
	dw AttackAnimation_MultipleSlash    ; ATK_ANIM_MULTIPLE_SLASH
	dw AttackAnimation_MultipleSlash    ; ATK_ANIM_42
	dw AttackAnimation_MultipleSlash    ; ATK_ANIM_RAMPAGE
	dw AttackAnimation_Drill            ; ATK_ANIM_DRILL
	dw AttackAnimation_PotSmash         ; ATK_ANIM_POT_SMASH
	dw AttackAnimation_Bonemerang       ; ATK_ANIM_BONEMERANG
	dw AttackAnimation_SeismicToss      ; ATK_ANIM_SEISMIC_TOSS
	dw AttackAnimation_Needles          ; ATK_ANIM_NEEDLES
	dw AttackAnimation_Needles          ; ATK_ANIM_49
	dw AttackAnimation_WhiteGas         ; ATK_ANIM_SMOG
	dw AttackAnimation_WhiteGas         ; ATK_ANIM_51
	dw AttackAnimation_WhiteGas         ; ATK_ANIM_52
	dw AttackAnimation_WhiteGas         ; ATK_ANIM_FOUL_GAS
	dw AttackAnimation_WhiteGas         ; ATK_ANIM_FOUL_ODOR
	dw AttackAnimation_Powder           ; ATK_ANIM_POWDER_EFFECT_CHANCE
	dw AttackAnimation_Powder           ; ATK_ANIM_POWDER_HIT_POISON
	dw AttackAnimation_544e             ; ATK_ANIM_POISON_POWDER
	dw AttackAnimation_Powder           ; ATK_ANIM_58
	dw AttackAnimation_Powder           ; ATK_ANIM_59
	dw AttackAnimation_Powder           ; ATK_ANIM_60
	dw AttackAnimation_Goo              ; ATK_ANIM_GOO
	dw AttackAnimation_Goo              ; ATK_ANIM_62
	dw AttackAnimation_5460             ; ATK_ANIM_SPIT_POISON
	dw AttackAnimation_Goo              ; ATK_ANIM_64
	dw AttackAnimation_Bubbles          ; ATK_ANIM_BUBBLES
	dw AttackAnimation_Bubbles          ; ATK_ANIM_66
	dw AttackAnimation_StringShot       ; ATK_ANIM_STRING_SHOT
	dw AttackAnimation_StringShot       ; ATK_ANIM_68
	dw AttackAnimation_Boyfriends       ; ATK_ANIM_BOYFRIENDS
	dw AttackAnimation_Lure             ; ATK_ANIM_LURE
	dw AttackAnimation_Toxic            ; ATK_ANIM_TOXIC
	dw AttackAnimation_ConfuseRay       ; ATK_ANIM_CONFUSE_RAY
	dw AttackAnimation_ConfuseRay       ; ATK_ANIM_73
	dw AttackAnimation_Sing             ; ATK_ANIM_SING
	dw AttackAnimation_Sing             ; ATK_ANIM_LULLABY
	dw AttackAnimation_Supersonic       ; ATK_ANIM_SUPERSONIC
	dw AttackAnimation_Supersonic       ; ATK_ANIM_77
	dw AttackAnimation_PetalDance       ; ATK_ANIM_PETAL_DANCE
	dw AttackAnimation_Protect          ; ATK_ANIM_PROTECT
	dw AttackAnimation_Barrier          ; ATK_ANIM_BARRIER
	dw AttackAnimation_QuickAttack      ; ATK_ANIM_QUICK_ATTACK
	dw AttackAnimation_54d3             ; ATK_ANIM_82
	dw AttackAnimation_Whirlwind        ; ATK_ANIM_WHIRLWIND
	dw AttackAnimation_Cry              ; ATK_ANIM_CRY
	dw AttackAnimation_Amnesia          ; ATK_ANIM_AMNESIA
	dw AttackAnimation_Selfdestruct     ; ATK_ANIM_SELFDESTRUCT
	dw AttackAnimation_BigSelfdestruct  ; ATK_ANIM_BIG_SELFDESTRUCTION
	dw AttackAnimation_Recover          ; ATK_ANIM_RECOVER
	dw AttackAnimation_Drain            ; ATK_ANIM_DRAIN
	dw AttackAnimation_DarkGas          ; ATK_ANIM_DARK_GAS
	dw AttackAnimation_GlowEffect       ; ATK_ANIM_GLOW_EFFECT
	dw AttackAnimation_MirrorMove       ; ATK_ANIM_MIRROR_MOVE
	dw AttackAnimation_553a             ; ATK_ANIM_93
	dw AttackAnimation_5543             ; ATK_ANIM_PKMN_POWER_1
	dw AttackAnimation_Firegiver        ; ATK_ANIM_FIREGIVER
	dw AttackAnimation_Quickfreeze      ; ATK_ANIM_QUICKFREEZE
	dw AttackAnimation_PealOfThunder    ; ATK_ANIM_PEAL_OF_THUNDER
	dw AttackAnimation_HealingWind      ; ATK_ANIM_HEALING_WIND
	dw AttackAnimation_WhirlwindZigzag  ; ATK_ANIM_WHIRLWIND_ZIGZAG
	dw AttackAnimation_BigThunder       ; ATK_ANIM_BIG_THUNDER
	dw AttackAnimation_SolarPower       ; ATK_ANIM_SOLAR_POWER
	dw AttackAnimation_PoisonFang       ; ATK_ANIM_POISON_FANG
	dw AttackAnimation_PoisonFang       ; ATK_ANIM_103
	dw AttackAnimation_PoisonFang       ; ATK_ANIM_104
	dw AttackAnimation_558c             ; ATK_ANIM_105
	dw AttackAnimation_5597             ; ATK_ANIM_106
	dw AttackAnimation_559c             ; ATK_ANIM_107
	dw AttackAnimation_CatPunch         ; ATK_ANIM_CAT_PUNCH
	dw AttackAnimation_MagneticStorm    ; ATK_ANIM_MAGNETIC_STORM
	dw AttackAnimation_PoisonWhip       ; ATK_ANIM_POISON_WHIP
	dw AttackAnimation_ThunderWave      ; ATK_ANIM_THUNDER_WAVE
	dw AttackAnimation_ThunderWave      ; ATK_ANIM_112
	dw AttackAnimation_Spore            ; ATK_ANIM_SPORE
	dw AttackAnimation_Hypnosis         ; ATK_ANIM_HYPNOSIS
	dw AttackAnimation_EnergyConversion ; ATK_ANIM_ENERGY_CONVERSION
	dw AttackAnimation_55ce             ; ATK_ANIM_116
	dw AttackAnimation_55d5             ; ATK_ANIM_117
	dw AttackAnimation_55e0             ; ATK_ANIM_118
	dw AttackAnimation_55e5             ; ATK_ANIM_119
	dw AttackAnimation_55e6             ; ATK_ANIM_120
	dw AttackAnimation_55ed             ; ATK_ANIM_121
	dw AttackAnimation_55f2             ; ATK_ANIM_122
	dw AttackAnimation_55fb             ; ATK_ANIM_123
	dw AttackAnimation_55fe             ; ATK_ANIM_124
	dw AttackAnimation_5601             ; ATK_ANIM_125
	dw AttackAnimation_5604             ; ATK_ANIM_126
	dw AttackAnimation_5607             ; ATK_ANIM_127
	dw AttackAnimation_SleepingGas      ; ATK_ANIM_SLEEPING_GAS
	dw AttackAnimation_560f             ; ATK_ANIM_129
	dw AttackAnimation_5612             ; ATK_ANIM_130
	dw AttackAnimation_561d             ; ATK_ANIM_131
	dw AttackAnimation_5628             ; ATK_ANIM_132
	dw AttackAnimation_562d             ; ATK_ANIM_133
	dw AttackAnimation_5632             ; ATK_ANIM_134
	dw AttackAnimation_5637             ; ATK_ANIM_135
	dw AttackAnimation_Expand           ; ATK_ANIM_EXPAND
	dw AttackAnimation_564f             ; ATK_ANIM_137
	dw AttackAnimation_5654             ; ATK_ANIM_138
	dw AttackAnimation_5659             ; ATK_ANIM_139
	dw AttackAnimation_565e             ; ATK_ANIM_140
	dw AttackAnimation_5665             ; ATK_ANIM_141
	dw AttackAnimation_5668             ; ATK_ANIM_142
	dw AttackAnimation_5673             ; ATK_ANIM_143
	dw AttackAnimation_5673             ; ATK_ANIM_144

AttackAnimation_Hit: ; (6:52c6)
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_BigHit:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_8
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
	anim_opponent       DUEL_ANIM_11
	anim_opponent       DUEL_ANIM_12
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_52f0:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_normal         DUEL_ANIM_13
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_SmallFlame:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_14
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_BigFlame:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_15
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_FireSpin:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_16
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_531e:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_17
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_WaterJets:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_18
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_WaterGun:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_19
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Whirlpool:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_20
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_DragonRage:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_11
	anim_opponent       DUEL_ANIM_19
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_HydroPump:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_21
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Blizzard:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_22
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_PsychicHit:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_23
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_DarkMind:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_24
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Beam:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_25
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_HyperBeam:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_26
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_RockThrow:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_27
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_StoneBarrage:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_28
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Punch:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_29
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Thunderpunch:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_30
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_FirePunch:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_31
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_StretchKick:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_32
	anim_end

AttackAnimation_Slash:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_33
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Whip:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_34
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Tear:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_35
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
	anim_opponent       DUEL_ANIM_37
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_PotSmash:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_38
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Bonemerang:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_39
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_SeismicToss:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_40
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Needles:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_41
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_WhiteGas:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_42
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Powder:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_43
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_544e:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_43
	anim_end

AttackAnimation_Goo:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_44
	anim_normal         $66
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5460:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_44
	anim_normal         $66
	anim_end

AttackAnimation_Bubbles:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_45
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_StringShot:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_46
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Boyfriends:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_47
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Lure:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_48
	anim_normal         $66
	anim_end

AttackAnimation_Toxic:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $66
	anim_opponent       DUEL_ANIM_49
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_ConfuseRay:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_opponent       DUEL_ANIM_50
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Sing:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_51
	anim_end

AttackAnimation_Supersonic:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_52
	anim_end

AttackAnimation_PetalDance:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_53
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Protect:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_54
	anim_end

AttackAnimation_Barrier:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_55
	anim_end

AttackAnimation_QuickAttack:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_56
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_54d3:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_56
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_player         DUEL_ANIM_54
	anim_end

AttackAnimation_Whirlwind:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_57
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Cry:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_58
	anim_normal         DUEL_ANIM_SHAKE1
	anim_end

AttackAnimation_Amnesia:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_59
	anim_end

AttackAnimation_Selfdestruct:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_60
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_BigSelfdestruct:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_61
	anim_normal         $65
	anim_player         DUEL_ANIM_65
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Recover:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_Drain:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_63
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_DarkGas:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_64
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_opponent       DUEL_ANIM_59
	anim_end

AttackAnimation_GlowEffect:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_end

AttackAnimation_MirrorMove:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_opponent       DUEL_ANIM_GLOW
	anim_end

AttackAnimation_553a:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_end

AttackAnimation_5543:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_normal         $65
	anim_end

AttackAnimation_Firegiver:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_normal         $65
	anim_unknown2       DUEL_ANIM_71
	anim_unknown2       DUEL_ANIM_71
	anim_end

AttackAnimation_Quickfreeze:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_normal         DUEL_ANIM_69
	anim_unknown        DUEL_ANIM_GLOW
	anim_end

AttackAnimation_PealOfThunder:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_unknown2       DUEL_ANIM_68
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_HealingWind:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_unknown2       DUEL_ANIM_73
	anim_end

AttackAnimation_WhirlwindZigzag:
	anim_player         DUEL_ANIM_GLOW
	anim_unknown        DUEL_ANIM_4
	anim_normal         DUEL_ANIM_74
	anim_end

AttackAnimation_BigThunder:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_SolarPower:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_end

AttackAnimation_PoisonFang:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_558c:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_41
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5597:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_51
	anim_end

AttackAnimation_559c:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_75
	anim_end

AttackAnimation_CatPunch:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_MagneticStorm:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_77
	anim_end

AttackAnimation_PoisonWhip:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_34
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_ThunderWave:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_77
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_Spore:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_43
	anim_end

AttackAnimation_Hypnosis:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_23
	anim_end

AttackAnimation_EnergyConversion:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_end

AttackAnimation_55ce:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_24
	anim_opponent       DUEL_ANIM_59
	anim_end

AttackAnimation_55d5:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_4
	anim_player         DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE3
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55e0:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_18
	anim_end

AttackAnimation_55e5:
	anim_end

AttackAnimation_55e6:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_6
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55ed:
	anim_player         DUEL_ANIM_HEAL
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55f2:
	anim_unknown        DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE3
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55fb:
	anim_opponent       DUEL_ANIM_POISON
	anim_end

AttackAnimation_55fe:
	anim_opponent       DUEL_ANIM_4
	anim_end

AttackAnimation_5601:
	anim_opponent       DUEL_ANIM_2
	anim_end

AttackAnimation_5604:
	anim_opponent       DUEL_ANIM_SLEEP
	anim_end

AttackAnimation_5607:
	anim_player         DUEL_ANIM_4
	anim_end

AttackAnimation_SleepingGas:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_42
	anim_end

AttackAnimation_560f:
	anim_opponent       DUEL_ANIM_59
	anim_end

AttackAnimation_5612:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_68
	anim_unknown2       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_561d:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_76
	anim_unknown2       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5628:
	anim_unknown        DUEL_ANIM_4
	anim_normal         DUEL_ANIM_78
	anim_end

AttackAnimation_562d:
	anim_unknown        DUEL_ANIM_4
	anim_normal         DUEL_ANIM_79
	anim_end

AttackAnimation_5632:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5637:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_57
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_normal         $65
	anim_end

AttackAnimation_Expand:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_75
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_564f:
	anim_player         DUEL_ANIM_POISON
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5654:
	anim_player         DUEL_ANIM_HEAL
	anim_normal         $98
	anim_end

AttackAnimation_5659:
	anim_player         DUEL_ANIM_SLEEP
	anim_normal         $98
	anim_end

AttackAnimation_565e:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_44
	anim_normal         $66
	anim_end

AttackAnimation_5665:
	anim_opponent       DUEL_ANIM_57
	anim_end

AttackAnimation_5668:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_unknown        DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_HEAL
	anim_opponent       DUEL_ANIM_HEAL
	anim_end

AttackAnimation_5673:
	anim_end
