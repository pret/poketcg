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
	dw $0000                ; ATK_ANIM_NONE
	dw AttackAnimation_52c6 ; ATK_ANIM_1
	dw AttackAnimation_52cf ; ATK_ANIM_2
	dw AttackAnimation_52c6 ; ATK_ANIM_3
	dw AttackAnimation_52c6 ; ATK_ANIM_4
	dw AttackAnimation_52c6 ; ATK_ANIM_5
	dw AttackAnimation_52d8 ; ATK_ANIM_6
	dw AttackAnimation_52d8 ; ATK_ANIM_7
	dw AttackAnimation_52e3 ; ATK_ANIM_8
	dw AttackAnimation_52d8 ; ATK_ANIM_9
	dw AttackAnimation_52f0 ; ATK_ANIM_10
	dw AttackAnimation_52f0 ; ATK_ANIM_11
	dw AttackAnimation_52f0 ; ATK_ANIM_12
	dw AttackAnimation_52f0 ; ATK_ANIM_13
	dw AttackAnimation_52fd ; ATK_ANIM_14
	dw AttackAnimation_5308 ; ATK_ANIM_15
	dw AttackAnimation_5313 ; ATK_ANIM_16
	dw AttackAnimation_531e ; ATK_ANIM_17
	dw AttackAnimation_5329 ; ATK_ANIM_18
	dw AttackAnimation_5334 ; ATK_ANIM_19
	dw AttackAnimation_533f ; ATK_ANIM_20
	dw AttackAnimation_534a ; ATK_ANIM_21
	dw AttackAnimation_5357 ; ATK_ANIM_22
	dw AttackAnimation_5362 ; ATK_ANIM_23
	dw AttackAnimation_5362 ; ATK_ANIM_24
	dw AttackAnimation_536d ; ATK_ANIM_25
	dw AttackAnimation_536d ; ATK_ANIM_26
	dw AttackAnimation_536d ; ATK_ANIM_27
	dw AttackAnimation_5378 ; ATK_ANIM_28
	dw AttackAnimation_5383 ; ATK_ANIM_29
	dw AttackAnimation_538e ; ATK_ANIM_30
	dw AttackAnimation_5383 ; ATK_ANIM_31
	dw AttackAnimation_5399 ; ATK_ANIM_32
	dw AttackAnimation_53a4 ; ATK_ANIM_33
	dw AttackAnimation_53af ; ATK_ANIM_34
	dw AttackAnimation_53ba ; ATK_ANIM_35
	dw AttackAnimation_53c5 ; ATK_ANIM_36
	dw AttackAnimation_53d0 ; ATK_ANIM_37
	dw AttackAnimation_53d5 ; ATK_ANIM_38
	dw AttackAnimation_53e0 ; ATK_ANIM_39
	dw AttackAnimation_53eb ; ATK_ANIM_40
	dw AttackAnimation_53f6 ; ATK_ANIM_41
	dw AttackAnimation_53f6 ; ATK_ANIM_42
	dw AttackAnimation_53f6 ; ATK_ANIM_43
	dw AttackAnimation_5401 ; ATK_ANIM_44
	dw AttackAnimation_540c ; ATK_ANIM_45
	dw AttackAnimation_5417 ; ATK_ANIM_46
	dw AttackAnimation_5422 ; ATK_ANIM_47
	dw AttackAnimation_542d ; ATK_ANIM_48
	dw AttackAnimation_542d ; ATK_ANIM_49
	dw AttackAnimation_5438 ; ATK_ANIM_50
	dw AttackAnimation_5438 ; ATK_ANIM_51
	dw AttackAnimation_5438 ; ATK_ANIM_52
	dw AttackAnimation_5438 ; ATK_ANIM_53
	dw AttackAnimation_5438 ; ATK_ANIM_54
	dw AttackAnimation_5443 ; ATK_ANIM_55
	dw AttackAnimation_5443 ; ATK_ANIM_56
	dw AttackAnimation_544e ; ATK_ANIM_57
	dw AttackAnimation_5443 ; ATK_ANIM_58
	dw AttackAnimation_5443 ; ATK_ANIM_59
	dw AttackAnimation_5443 ; ATK_ANIM_60
	dw AttackAnimation_5453 ; ATK_ANIM_61
	dw AttackAnimation_5453 ; ATK_ANIM_62
	dw AttackAnimation_5460 ; ATK_ANIM_63
	dw AttackAnimation_5453 ; ATK_ANIM_64
	dw AttackAnimation_5467 ; ATK_ANIM_65
	dw AttackAnimation_5467 ; ATK_ANIM_66
	dw AttackAnimation_5472 ; ATK_ANIM_67
	dw AttackAnimation_5472 ; ATK_ANIM_68
	dw AttackAnimation_547d ; ATK_ANIM_69
	dw AttackAnimation_5488 ; ATK_ANIM_70
	dw AttackAnimation_548f ; ATK_ANIM_71
	dw AttackAnimation_549c ; ATK_ANIM_72
	dw AttackAnimation_549c ; ATK_ANIM_73
	dw AttackAnimation_54a9 ; ATK_ANIM_74
	dw AttackAnimation_54a9 ; ATK_ANIM_75
	dw AttackAnimation_54ae ; ATK_ANIM_76
	dw AttackAnimation_54ae ; ATK_ANIM_77
	dw AttackAnimation_54b3 ; ATK_ANIM_78
	dw AttackAnimation_54be ; ATK_ANIM_79
	dw AttackAnimation_54c3 ; ATK_ANIM_80
	dw AttackAnimation_54c8 ; ATK_ANIM_81
	dw AttackAnimation_54d3 ; ATK_ANIM_82
	dw AttackAnimation_54e0 ; ATK_ANIM_83
	dw AttackAnimation_54eb ; ATK_ANIM_84
	dw AttackAnimation_54f2 ; ATK_ANIM_85
	dw AttackAnimation_54f9 ; ATK_ANIM_86
	dw AttackAnimation_5504 ; ATK_ANIM_87
	dw AttackAnimation_5513 ; ATK_ANIM_88
	dw AttackAnimation_5516 ; ATK_ANIM_89
	dw AttackAnimation_5521 ; ATK_ANIM_90
	dw AttackAnimation_552e ; ATK_ANIM_91
	dw AttackAnimation_5533 ; ATK_ANIM_92
	dw AttackAnimation_553a ; ATK_ANIM_93
	dw AttackAnimation_5543 ; ATK_ANIM_94
	dw AttackAnimation_554a ; ATK_ANIM_95
	dw AttackAnimation_5555 ; ATK_ANIM_96
	dw AttackAnimation_555e ; ATK_ANIM_97
	dw AttackAnimation_556d ; ATK_ANIM_98
	dw AttackAnimation_5574 ; ATK_ANIM_99
	dw AttackAnimation_557b ; ATK_ANIM_100
	dw AttackAnimation_557e ; ATK_ANIM_101
	dw AttackAnimation_5583 ; ATK_ANIM_102
	dw AttackAnimation_5583 ; ATK_ANIM_103
	dw AttackAnimation_5583 ; ATK_ANIM_104
	dw AttackAnimation_558c ; ATK_ANIM_105
	dw AttackAnimation_5597 ; ATK_ANIM_106
	dw AttackAnimation_559c ; ATK_ANIM_107
	dw AttackAnimation_55a1 ; ATK_ANIM_108
	dw AttackAnimation_55a4 ; ATK_ANIM_109
	dw AttackAnimation_55a9 ; ATK_ANIM_110
	dw AttackAnimation_55b4 ; ATK_ANIM_111
	dw AttackAnimation_55b4 ; ATK_ANIM_112
	dw AttackAnimation_55bf ; ATK_ANIM_113
	dw AttackAnimation_55c4 ; ATK_ANIM_114
	dw AttackAnimation_55c9 ; ATK_ANIM_115
	dw AttackAnimation_55ce ; ATK_ANIM_116
	dw AttackAnimation_55d5 ; ATK_ANIM_117
	dw AttackAnimation_55e0 ; ATK_ANIM_118
	dw AttackAnimation_55e5 ; ATK_ANIM_119
	dw AttackAnimation_55e6 ; ATK_ANIM_120
	dw AttackAnimation_55ed ; ATK_ANIM_121
	dw AttackAnimation_55f2 ; ATK_ANIM_122
	dw AttackAnimation_55fb ; ATK_ANIM_123
	dw AttackAnimation_55fe ; ATK_ANIM_124
	dw AttackAnimation_5601 ; ATK_ANIM_125
	dw AttackAnimation_5604 ; ATK_ANIM_126
	dw AttackAnimation_5607 ; ATK_ANIM_127
	dw AttackAnimation_560a ; ATK_ANIM_128
	dw AttackAnimation_560f ; ATK_ANIM_129
	dw AttackAnimation_5612 ; ATK_ANIM_130
	dw AttackAnimation_561d ; ATK_ANIM_131
	dw AttackAnimation_5628 ; ATK_ANIM_132
	dw AttackAnimation_562d ; ATK_ANIM_133
	dw AttackAnimation_5632 ; ATK_ANIM_134
	dw AttackAnimation_5637 ; ATK_ANIM_135
	dw AttackAnimation_5644 ; ATK_ANIM_136
	dw AttackAnimation_564f ; ATK_ANIM_137
	dw AttackAnimation_5654 ; ATK_ANIM_138
	dw AttackAnimation_5659 ; ATK_ANIM_139
	dw AttackAnimation_565e ; ATK_ANIM_140
	dw AttackAnimation_5665 ; ATK_ANIM_141
	dw AttackAnimation_5668 ; ATK_ANIM_142
	dw AttackAnimation_5673 ; ATK_ANIM_143
	dw AttackAnimation_5673 ; ATK_ANIM_144

AttackAnimation_52c6: ; (6:52c6)
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_52cf:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_8
	anim_normal         DUEL_ANIM_SHAKE2
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_52d8:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_THUNDER_SHOCK
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_52e3:
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

AttackAnimation_52fd:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_14
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5308:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_15
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5313:
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

AttackAnimation_5329:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_18
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5334:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_19
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_533f:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_20
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_534a:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_11
	anim_opponent       DUEL_ANIM_19
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5357:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_21
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5362:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_22
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_536d:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_23
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5378:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_24
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5383:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_25
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_538e:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_26
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5399:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_27
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_53a4:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_28
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_53af:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_29
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_53ba:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_30
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_53c5:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_31
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_53d0:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_32
	anim_end

AttackAnimation_53d5:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_33
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_53e0:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_34
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_53eb:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_35
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_53f6:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_FURY_SWIPES
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5401:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_37
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_540c:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_38
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5417:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_39
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5422:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_40
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_542d:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_41
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5438:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_42
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5443:
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

AttackAnimation_5453:
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

AttackAnimation_5467:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_45
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5472:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_46
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_547d:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_47
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5488:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_48
	anim_normal         $66
	anim_end

AttackAnimation_548f:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $66
	anim_opponent       DUEL_ANIM_49
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_549c:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_opponent       DUEL_ANIM_50
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_54a9:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_51
	anim_end

AttackAnimation_54ae:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_52
	anim_end

AttackAnimation_54b3:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_53
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_54be:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_54
	anim_end

AttackAnimation_54c3:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_55
	anim_end

AttackAnimation_54c8:
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

AttackAnimation_54e0:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_57
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_54eb:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_58
	anim_normal         DUEL_ANIM_SHAKE1
	anim_end

AttackAnimation_54f2:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_59
	anim_end

AttackAnimation_54f9:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_60
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5504:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_61
	anim_normal         $65
	anim_player         DUEL_ANIM_65
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5513:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_5516:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_63
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5521:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_64
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_opponent       DUEL_ANIM_59
	anim_end

AttackAnimation_552e:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_end

AttackAnimation_5533:
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

AttackAnimation_554a:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_normal         $65
	anim_unknown2       DUEL_ANIM_71
	anim_unknown2       DUEL_ANIM_71
	anim_end

AttackAnimation_5555:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_normal         DUEL_ANIM_69
	anim_unknown        DUEL_ANIM_GLOW
	anim_end

AttackAnimation_555e:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_unknown2       DUEL_ANIM_68
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_unknown2       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_556d:
	anim_unknown        DUEL_ANIM_4
	anim_unknown2       DUEL_ANIM_70
	anim_unknown2       DUEL_ANIM_73
	anim_end

AttackAnimation_5574:
	anim_player         DUEL_ANIM_GLOW
	anim_unknown        DUEL_ANIM_4
	anim_normal         DUEL_ANIM_74
	anim_end

AttackAnimation_557b:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_557e:
	anim_player         DUEL_ANIM_GLOW
	anim_normal         $65
	anim_end

AttackAnimation_5583:
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

AttackAnimation_55a1:
	anim_player         DUEL_ANIM_GLOW
	anim_end

AttackAnimation_55a4:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_77
	anim_end

AttackAnimation_55a9:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_34
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55b4:
	anim_player         DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_77
	anim_opponent       DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE1
	anim_opponent       DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55bf:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_43
	anim_end

AttackAnimation_55c4:
	anim_player         DUEL_ANIM_GLOW
	anim_opponent       DUEL_ANIM_23
	anim_end

AttackAnimation_55c9:
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

AttackAnimation_560a:
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

AttackAnimation_5644:
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
