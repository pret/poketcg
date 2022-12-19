; data for each animation ID (see src/constants/sprite_constants.asm)
Animations: ; 1ce32 (7:4e32)
	table_width 6, Animations
	; DUEL_ANIM_NONE
	db $00 ; sprite ID
	db $00 ; palette ID
	db $00 ; anim ID
	db $00 ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_GLOW
	db SPRITE_DUEL_GLOW ; sprite ID
	db PALETTE_31 ; palette ID
	db SPRITE_ANIM_71 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_11 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PARALYSIS
	db SPRITE_DUEL_1 ; sprite ID
	db PALETTE_32 ; palette ID
	db SPRITE_ANIM_72 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_12 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SLEEP
	db SPRITE_DUEL_2 ; sprite ID
	db PALETTE_33 ; palette ID
	db SPRITE_ANIM_73 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_13 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_CONFUSION
	db SPRITE_DUEL_55 ; sprite ID
	db PALETTE_34 ; palette ID
	db SPRITE_ANIM_74 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_14 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_POISON
	db SPRITE_DUEL_58 ; sprite ID
	db PALETTE_35 ; palette ID
	db SPRITE_ANIM_75 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_15 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_6
	db SPRITE_DUEL_3 ; sprite ID
	db PALETTE_36 ; palette ID
	db SPRITE_ANIM_76 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_16 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_HIT
	db SPRITE_DUEL_3 ; sprite ID
	db PALETTE_36 ; palette ID
	db SPRITE_ANIM_77 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_16 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BIG_HIT
	db SPRITE_DUEL_3 ; sprite ID
	db PALETTE_36 ; palette ID
	db SPRITE_ANIM_78 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_17 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SHOW_DAMAGE
	db SPRITE_DUEL_4 ; sprite ID
	db PALETTE_37 ; palette ID
	db $00 ; anim ID
	db $00 ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_THUNDER_SHOCK
	db SPRITE_DUEL_5 ; sprite ID
	db PALETTE_38 ; palette ID
	db SPRITE_ANIM_92 ; anim ID
	db $00 ; anim flags
	db SFX_18 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_LIGHTNING
	db SPRITE_DUEL_6 ; sprite ID
	db PALETTE_39 ; palette ID
	db SPRITE_ANIM_94 ; anim ID
	db $00 ; anim flags
	db SFX_19 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BORDER_SPARK
	db SPRITE_DUEL_59 ; sprite ID
	db PALETTE_40 ; palette ID
	db SPRITE_ANIM_95 ; anim ID
	db $00 ; anim flags
	db SFX_1A ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BIG_LIGHTNING
	db SPRITE_DUEL_7 ; sprite ID
	db PALETTE_41 ; palette ID
	db SPRITE_ANIM_96 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_1B ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SMALL_FLAME
	db SPRITE_DUEL_8 ; sprite ID
	db PALETTE_42 ; palette ID
	db SPRITE_ANIM_97 ; anim ID
	db $00 ; anim flags
	db SFX_1C ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BIG_FLAME
	db SPRITE_DUEL_8 ; sprite ID
	db PALETTE_42 ; palette ID
	db SPRITE_ANIM_98 ; anim ID
	db $00 ; anim flags
	db SFX_1D ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_FIRE_SPIN
	db SPRITE_DUEL_9 ; sprite ID
	db PALETTE_43 ; palette ID
	db SPRITE_ANIM_99 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_1E ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DIVE_BOMB
	db SPRITE_DUEL_10 ; sprite ID
	db PALETTE_44 ; palette ID
	db SPRITE_ANIM_100 ; anim ID
	db $00 ; anim flags
	db SFX_1F ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_WATER_JETS
	db SPRITE_DUEL_61 ; sprite ID
	db PALETTE_45 ; palette ID
	db SPRITE_ANIM_105 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_20 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_WATER_GUN
	db SPRITE_DUEL_11 ; sprite ID
	db PALETTE_46 ; palette ID
	db SPRITE_ANIM_106 ; anim ID
	db $00 ; anim flags
	db SFX_21 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_WHIRLPOOL
	db SPRITE_DUEL_12 ; sprite ID
	db PALETTE_47 ; palette ID
	db SPRITE_ANIM_107 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_22 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_HYDRO_PUMP
	db SPRITE_DUEL_13 ; sprite ID
	db PALETTE_48 ; palette ID
	db SPRITE_ANIM_108 ; anim ID
	db $00 ; anim flags
	db SFX_23 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BLIZZARD
	db SPRITE_DUEL_62 ; sprite ID
	db PALETTE_49 ; palette ID
	db SPRITE_ANIM_109 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_24 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PSYCHIC
	db SPRITE_DUEL_14 ; sprite ID
	db PALETTE_50 ; palette ID
	db SPRITE_ANIM_110 ; anim ID
	db $00 ; anim flags
	db SFX_25 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_GLARE
	db SPRITE_DUEL_15 ; sprite ID
	db PALETTE_51 ; palette ID
	db SPRITE_ANIM_111 ; anim ID
	db $00 ; anim flags
	db SFX_26 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BEAM
	db SPRITE_DUEL_16 ; sprite ID
	db PALETTE_52 ; palette ID
	db SPRITE_ANIM_112 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_6) | (1 << SPRITE_ANIM_FLAG_Y_SUBTRACT) ; anim flags
	db SFX_27 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_HYPER_BEAM
	db SPRITE_DUEL_17 ; sprite ID
	db PALETTE_53 ; palette ID
	db SPRITE_ANIM_113 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_6) | (1 << SPRITE_ANIM_FLAG_Y_SUBTRACT) ; anim flags
	db SFX_28 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_ROCK_THROW
	db SPRITE_DUEL_18 ; sprite ID
	db PALETTE_54 ; palette ID
	db SPRITE_ANIM_114 ; anim ID
	db $00 ; anim flags
	db SFX_29 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_STONE_BARRAGE
	db SPRITE_DUEL_18 ; sprite ID
	db PALETTE_54 ; palette ID
	db SPRITE_ANIM_115 ; anim ID
	db $00 ; anim flags
	db SFX_2A ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PUNCH
	db SPRITE_DUEL_19 ; sprite ID
	db PALETTE_55 ; palette ID
	db SPRITE_ANIM_116 ; anim ID
	db $00 ; anim flags
	db SFX_2B ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_THUNDERPUNCH
	db SPRITE_DUEL_19 ; sprite ID
	db PALETTE_55 ; palette ID
	db SPRITE_ANIM_117 ; anim ID
	db $00 ; anim flags
	db SFX_52 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_FIRE_PUNCH
	db SPRITE_DUEL_19 ; sprite ID
	db PALETTE_55 ; palette ID
	db SPRITE_ANIM_118 ; anim ID
	db $00 ; anim flags
	db SFX_53 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_STRETCH_KICK
	db SPRITE_DUEL_20 ; sprite ID
	db PALETTE_56 ; palette ID
	db SPRITE_ANIM_119 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_5) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT) ; anim flags
	db SFX_2C ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SLASH
	db SPRITE_DUEL_21 ; sprite ID
	db PALETTE_57 ; palette ID
	db SPRITE_ANIM_120 ; anim ID
	db $00 ; anim flags
	db SFX_2D ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_WHIP
	db SPRITE_DUEL_22 ; sprite ID
	db PALETTE_58 ; palette ID
	db SPRITE_ANIM_122 ; anim ID
	db $00 ; anim flags
	db SFX_2D ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_TEAR
	db SPRITE_DUEL_23 ; sprite ID
	db PALETTE_59 ; palette ID
	db SPRITE_ANIM_123 ; anim ID
	db $00 ; anim flags
	db SFX_2E ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_FURY_SWIPES
	db SPRITE_DUEL_21 ; sprite ID
	db PALETTE_57 ; palette ID
	db SPRITE_ANIM_121 ; anim ID
	db $00 ; anim flags
	db SFX_2F ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DRILL
	db SPRITE_DUEL_24 ; sprite ID
	db PALETTE_60 ; palette ID
	db SPRITE_ANIM_124 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_5) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT) ; anim flags
	db SFX_30 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_POT_SMASH
	db SPRITE_DUEL_25 ; sprite ID
	db PALETTE_61 ; palette ID
	db SPRITE_ANIM_125 ; anim ID
	db $00 ; anim flags
	db SFX_31 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BONEMERANG
	db SPRITE_DUEL_26 ; sprite ID
	db PALETTE_62 ; palette ID
	db SPRITE_ANIM_126 ; anim ID
	db $00 ; anim flags
	db SFX_32 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SEISMIC_TOSS
	db SPRITE_DUEL_27 ; sprite ID
	db PALETTE_63 ; palette ID
	db SPRITE_ANIM_127 ; anim ID
	db $00 ; anim flags
	db SFX_33 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_NEEDLES
	db SPRITE_DUEL_28 ; sprite ID
	db PALETTE_64 ; palette ID
	db SPRITE_ANIM_128 ; anim ID
	db $00 ; anim flags
	db SFX_34 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_WHITE_GAS
	db SPRITE_DUEL_29 ; sprite ID
	db PALETTE_65 ; palette ID
	db SPRITE_ANIM_129 ; anim ID
	db $00 ; anim flags
	db SFX_35 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_POWDER
	db SPRITE_DUEL_56 ; sprite ID
	db PALETTE_66 ; palette ID
	db SPRITE_ANIM_130 ; anim ID
	db $00 ; anim flags
	db SFX_36 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_GOO
	db SPRITE_DUEL_30 ; sprite ID
	db PALETTE_67 ; palette ID
	db SPRITE_ANIM_131 ; anim ID
	db $00 ; anim flags
	db SFX_37 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BUBBLES
	db SPRITE_DUEL_31 ; sprite ID
	db PALETTE_68 ; palette ID
	db SPRITE_ANIM_132 ; anim ID
	db $00 ; anim flags
	db SFX_38 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_STRING_SHOT
	db SPRITE_DUEL_32 ; sprite ID
	db PALETTE_69 ; palette ID
	db SPRITE_ANIM_133 ; anim ID
	db $00 ; anim flags
	db SFX_39 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BOYFRIENDS
	db SPRITE_DUEL_33 ; sprite ID
	db PALETTE_70 ; palette ID
	db SPRITE_ANIM_134 ; anim ID
	db $00 ; anim flags
	db SFX_3A ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_LURE
	db SPRITE_DUEL_34 ; sprite ID
	db PALETTE_71 ; palette ID
	db SPRITE_ANIM_135 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_5) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT) ; anim flags
	db SFX_3B ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_TOXIC
	db SPRITE_DUEL_35 ; sprite ID
	db PALETTE_72 ; palette ID
	db SPRITE_ANIM_136 ; anim ID
	db $00 ; anim flags
	db SFX_3C ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_CONFUSE_RAY
	db SPRITE_DUEL_66 ; sprite ID
	db PALETTE_73 ; palette ID
	db SPRITE_ANIM_137 ; anim ID
	db $00 ; anim flags
	db SFX_3D ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SING
	db SPRITE_DUEL_36 ; sprite ID
	db PALETTE_74 ; palette ID
	db SPRITE_ANIM_138 ; anim ID
	db $00 ; anim flags
	db SFX_3E ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SUPERSONIC
	db SPRITE_DUEL_37 ; sprite ID
	db PALETTE_75 ; palette ID
	db SPRITE_ANIM_139 ; anim ID
	db $00 ; anim flags
	db SFX_3F ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PETAL_DANCE
	db SPRITE_DUEL_57 ; sprite ID
	db PALETTE_76 ; palette ID
	db SPRITE_ANIM_140 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_40 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PROTECT
	db SPRITE_DUEL_38 ; sprite ID
	db PALETTE_77 ; palette ID
	db SPRITE_ANIM_141 ; anim ID
	db $00 ; anim flags
	db SFX_41 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BARRIER
	db SPRITE_DUEL_39 ; sprite ID
	db PALETTE_78 ; palette ID
	db SPRITE_ANIM_142 ; anim ID
	db $00 ; anim flags
	db SFX_42 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_QUICK_ATTACK
	db SPRITE_DUEL_40 ; sprite ID
	db PALETTE_79 ; palette ID
	db SPRITE_ANIM_143 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_43 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_WHIRLWIND
	db SPRITE_DUEL_41 ; sprite ID
	db PALETTE_80 ; palette ID
	db SPRITE_ANIM_144 ; anim ID
	db $00 ; anim flags
	db SFX_44 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_CRY
	db SPRITE_DUEL_42 ; sprite ID
	db PALETTE_81 ; palette ID
	db SPRITE_ANIM_146 ; anim ID
	db $00 ; anim flags
	db SFX_45 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_QUESTION_MARK
	db SPRITE_DUEL_43 ; sprite ID
	db PALETTE_82 ; palette ID
	db SPRITE_ANIM_147 ; anim ID
	db $00 ; anim flags
	db SFX_46 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SELFDESTRUCT
	db SPRITE_DUEL_44 ; sprite ID
	db PALETTE_83 ; palette ID
	db SPRITE_ANIM_148 ; anim ID
	db $00 ; anim flags
	db SFX_47 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BIG_SELFDESTRUCT_1
	db SPRITE_DUEL_44 ; sprite ID
	db PALETTE_83 ; palette ID
	db SPRITE_ANIM_149 ; anim ID
	db $00 ; anim flags
	db SFX_48 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_HEAL
	db SPRITE_DUEL_60 ; sprite ID
	db PALETTE_84 ; palette ID
	db SPRITE_ANIM_151 ; anim ID
	db $00 ; anim flags
	db SFX_49 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DRAIN
	db SPRITE_DUEL_64 ; sprite ID
	db PALETTE_85 ; palette ID
	db SPRITE_ANIM_153 ; anim ID
	db $00 ; anim flags
	db SFX_4A ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DARK_GAS
	db SPRITE_DUEL_29 ; sprite ID
	db PALETTE_86 ; palette ID
	db SPRITE_ANIM_129 ; anim ID
	db $00 ; anim flags
	db SFX_4B ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BIG_SELFDESTRUCT_2
	db SPRITE_DUEL_44 ; sprite ID
	db PALETTE_83 ; palette ID
	db SPRITE_ANIM_150 ; anim ID
	db $00 ; anim flags
	db SFX_47 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_66
	db SPRITE_DUEL_3 ; sprite ID
	db PALETTE_36 ; palette ID
	db SPRITE_ANIM_77 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_16 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_67
	db SPRITE_DUEL_3 ; sprite ID
	db PALETTE_36 ; palette ID
	db SPRITE_ANIM_78 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_17 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_68
	db SPRITE_DUEL_5 ; sprite ID
	db PALETTE_38 ; palette ID
	db SPRITE_ANIM_92 ; anim ID
	db $00 ; anim flags
	db SFX_18 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_69
	db SPRITE_DUEL_62 ; sprite ID
	db PALETTE_49 ; palette ID
	db SPRITE_ANIM_109 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_24 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_70
	db SPRITE_DUEL_45 ; sprite ID
	db PALETTE_87 ; palette ID
	db SPRITE_ANIM_154 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db SFX_11 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_71
	db SPRITE_DUEL_10 ; sprite ID
	db PALETTE_44 ; palette ID
	db SPRITE_ANIM_101 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_5C ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_72
	db SPRITE_DUEL_10 ; sprite ID
	db PALETTE_44 ; palette ID
	db SPRITE_ANIM_102 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_73
	db SPRITE_DUEL_60 ; sprite ID
	db PALETTE_84 ; palette ID
	db SPRITE_ANIM_152 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_4C ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_74
	db SPRITE_DUEL_41 ; sprite ID
	db PALETTE_80 ; palette ID
	db SPRITE_ANIM_145 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_4D ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_EXPAND
	db SPRITE_DUEL_46 ; sprite ID
	db PALETTE_88 ; palette ID
	db SPRITE_ANIM_155 ; anim ID
	db $00 ; anim flags
	db SFX_4E ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_76
	db SPRITE_DUEL_47 ; sprite ID
	db PALETTE_89 ; palette ID
	db SPRITE_ANIM_156 ; anim ID
	db $00 ; anim flags
	db SFX_4F ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_THUNDER_WAVE
	db SPRITE_DUEL_48 ; sprite ID
	db PALETTE_90 ; palette ID
	db SPRITE_ANIM_157 ; anim ID
	db $00 ; anim flags
	db SFX_50 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_78
	db SPRITE_DUEL_10 ; sprite ID
	db PALETTE_44 ; palette ID
	db SPRITE_ANIM_103 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_51 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_79
	db SPRITE_DUEL_10 ; sprite ID
	db PALETTE_44 ; palette ID
	db SPRITE_ANIM_104 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_51 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_80
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_158 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PLAYER_SHUFFLE
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_159 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_07 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_OPP_SHUFFLE
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_160 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_07 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BOTH_SHUFFLE
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_161 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_07 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_84
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_162 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BOTH_DRAW
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_163 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PLAYER_DRAW
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_164 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_OPP_DRAW
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_165 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_SPIN
	db SPRITE_DUEL_50 ; sprite ID
	db PALETTE_92 ; palette ID
	db SPRITE_ANIM_167 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_TOSS1
	db SPRITE_DUEL_50 ; sprite ID
	db PALETTE_92 ; palette ID
	db SPRITE_ANIM_168 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_0B ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_TOSS2
	db SPRITE_DUEL_50 ; sprite ID
	db PALETTE_92 ; palette ID
	db SPRITE_ANIM_169 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_0B ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_TAILS
	db SPRITE_DUEL_50 ; sprite ID
	db PALETTE_92 ; palette ID
	db SPRITE_ANIM_170 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_HEADS
	db SPRITE_DUEL_50 ; sprite ID
	db PALETTE_92 ; palette ID
	db SPRITE_ANIM_171 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DUEL_WIN
	db SPRITE_DUEL_WON_LOST_DRAW ; sprite ID
	db PALETTE_93 ; palette ID
	db SPRITE_ANIM_172 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DUEL_LOSS
	db SPRITE_DUEL_WON_LOST_DRAW ; sprite ID
	db PALETTE_93 ; palette ID
	db SPRITE_ANIM_173 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DUEL_DRAW
	db SPRITE_DUEL_WON_LOST_DRAW ; sprite ID
	db PALETTE_93 ; palette ID
	db SPRITE_ANIM_174 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_96
	db SPRITE_DUEL_49 ; sprite ID
	db PALETTE_91 ; palette ID
	db SPRITE_ANIM_166 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db SFX_STOP ; sound FX ID
	db $00 ; handler function
	assert_table_length NUM_REGULAR_DUEL_ANIMS
