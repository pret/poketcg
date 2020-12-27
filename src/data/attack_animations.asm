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
	dw $0000
	dw AttackAnimation_52c6
	dw AttackAnimation_52cf
	dw AttackAnimation_52c6
	dw AttackAnimation_52c6
	dw AttackAnimation_52c6
	dw AttackAnimation_52d8
	dw AttackAnimation_52d8
	dw AttackAnimation_52e3
	dw AttackAnimation_52d8
	dw AttackAnimation_52f0
	dw AttackAnimation_52f0
	dw AttackAnimation_52f0
	dw AttackAnimation_52f0
	dw AttackAnimation_52fd
	dw AttackAnimation_5308
	dw AttackAnimation_5313
	dw AttackAnimation_531e
	dw AttackAnimation_5329
	dw AttackAnimation_5334
	dw AttackAnimation_533f
	dw AttackAnimation_534a
	dw AttackAnimation_5357
	dw AttackAnimation_5362
	dw AttackAnimation_5362
	dw AttackAnimation_536d
	dw AttackAnimation_536d
	dw AttackAnimation_536d
	dw AttackAnimation_5378
	dw AttackAnimation_5383
	dw AttackAnimation_538e
	dw AttackAnimation_5383
	dw AttackAnimation_5399
	dw AttackAnimation_53a4
	dw AttackAnimation_53af
	dw AttackAnimation_53ba
	dw AttackAnimation_53c5
	dw AttackAnimation_53d0
	dw AttackAnimation_53d5
	dw AttackAnimation_53e0
	dw AttackAnimation_53eb
	dw AttackAnimation_53f6
	dw AttackAnimation_53f6
	dw AttackAnimation_53f6
	dw AttackAnimation_5401
	dw AttackAnimation_540c
	dw AttackAnimation_5417
	dw AttackAnimation_5422
	dw AttackAnimation_542d
	dw AttackAnimation_542d
	dw AttackAnimation_5438
	dw AttackAnimation_5438
	dw AttackAnimation_5438
	dw AttackAnimation_5438
	dw AttackAnimation_5438
	dw AttackAnimation_5443
	dw AttackAnimation_5443
	dw AttackAnimation_544e
	dw AttackAnimation_5443
	dw AttackAnimation_5443
	dw AttackAnimation_5443
	dw AttackAnimation_5453
	dw AttackAnimation_5453
	dw AttackAnimation_5460
	dw AttackAnimation_5453
	dw AttackAnimation_5467
	dw AttackAnimation_5467
	dw AttackAnimation_5472
	dw AttackAnimation_5472
	dw AttackAnimation_547d
	dw AttackAnimation_5488
	dw AttackAnimation_548f
	dw AttackAnimation_549c
	dw AttackAnimation_549c
	dw AttackAnimation_54a9
	dw AttackAnimation_54a9
	dw AttackAnimation_54ae
	dw AttackAnimation_54ae
	dw AttackAnimation_54b3
	dw AttackAnimation_54be
	dw AttackAnimation_54c3
	dw AttackAnimation_54c8
	dw AttackAnimation_54d3
	dw AttackAnimation_54e0
	dw AttackAnimation_54eb
	dw AttackAnimation_54f2
	dw AttackAnimation_54f9
	dw AttackAnimation_5504
	dw AttackAnimation_5513
	dw AttackAnimation_5516
	dw AttackAnimation_5521
	dw AttackAnimation_552e
	dw AttackAnimation_5533
	dw AttackAnimation_553a
	dw AttackAnimation_5543
	dw AttackAnimation_554a
	dw AttackAnimation_5555
	dw AttackAnimation_555e
	dw AttackAnimation_556d
	dw AttackAnimation_5574
	dw AttackAnimation_557b
	dw AttackAnimation_557e
	dw AttackAnimation_5583
	dw AttackAnimation_5583
	dw AttackAnimation_5583
	dw AttackAnimation_558c
	dw AttackAnimation_5597
	dw AttackAnimation_559c
	dw AttackAnimation_55a1
	dw AttackAnimation_55a4
	dw AttackAnimation_55a9
	dw AttackAnimation_55b4
	dw AttackAnimation_55b4
	dw AttackAnimation_55bf
	dw AttackAnimation_55c4
	dw AttackAnimation_55c9
	dw AttackAnimation_55ce
	dw AttackAnimation_55d5
	dw AttackAnimation_55e0
	dw AttackAnimation_55e5
	dw AttackAnimation_55e6
	dw AttackAnimation_55ed
	dw AttackAnimation_55f2
	dw AttackAnimation_55fb
	dw AttackAnimation_55fe
	dw AttackAnimation_5601
	dw AttackAnimation_5604
	dw AttackAnimation_5607
	dw AttackAnimation_560a
	dw AttackAnimation_560f
	dw AttackAnimation_5612
	dw AttackAnimation_561d
	dw AttackAnimation_5628
	dw AttackAnimation_562d
	dw AttackAnimation_5632
	dw AttackAnimation_5637
	dw AttackAnimation_5644
	dw AttackAnimation_564f
	dw AttackAnimation_5654
	dw AttackAnimation_5659
	dw AttackAnimation_565e
	dw AttackAnimation_5665
	dw AttackAnimation_5668
	dw AttackAnimation_5673
	dw AttackAnimation_5673

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
	anim_player         DUEL_ANIM_62
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55f2:
	anim_unknown        DUEL_ANIM_GLOW
	anim_player         DUEL_ANIM_HIT
	anim_normal         DUEL_ANIM_SHAKE3
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_55fb:
	anim_opponent       DUEL_ANIM_5
	anim_end

AttackAnimation_55fe:
	anim_opponent       DUEL_ANIM_4
	anim_end

AttackAnimation_5601:
	anim_opponent       DUEL_ANIM_2
	anim_end

AttackAnimation_5604:
	anim_opponent       DUEL_ANIM_3
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
	anim_player         DUEL_ANIM_5
	anim_player         DUEL_ANIM_SHOW_DAMAGE
	anim_end

AttackAnimation_5654:
	anim_player         DUEL_ANIM_62
	anim_normal         $98
	anim_end

AttackAnimation_5659:
	anim_player         DUEL_ANIM_3
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
	anim_player         DUEL_ANIM_62
	anim_opponent       DUEL_ANIM_62
	anim_end

AttackAnimation_5673:
	anim_end
