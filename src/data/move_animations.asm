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

PointerTable_MoveAnimation:
	dw $0000
	dw MoveAnimation_52c6
	dw MoveAnimation_52cf
	dw MoveAnimation_52c6
	dw MoveAnimation_52c6
	dw MoveAnimation_52c6
	dw MoveAnimation_52d8
	dw MoveAnimation_52d8
	dw MoveAnimation_52e3
	dw MoveAnimation_52d8
	dw MoveAnimation_52f0
	dw MoveAnimation_52f0
	dw MoveAnimation_52f0
	dw MoveAnimation_52f0
	dw MoveAnimation_52fd
	dw MoveAnimation_5308
	dw MoveAnimation_5313
	dw MoveAnimation_531e
	dw MoveAnimation_5329
	dw MoveAnimation_5334
	dw MoveAnimation_533f
	dw MoveAnimation_534a
	dw MoveAnimation_5357
	dw MoveAnimation_5362
	dw MoveAnimation_5362
	dw MoveAnimation_536d
	dw MoveAnimation_536d
	dw MoveAnimation_536d
	dw MoveAnimation_5378
	dw MoveAnimation_5383
	dw MoveAnimation_538e
	dw MoveAnimation_5383
	dw MoveAnimation_5399
	dw MoveAnimation_53a4
	dw MoveAnimation_53af
	dw MoveAnimation_53ba
	dw MoveAnimation_53c5
	dw MoveAnimation_53d0
	dw MoveAnimation_53d5
	dw MoveAnimation_53e0
	dw MoveAnimation_53eb
	dw MoveAnimation_53f6
	dw MoveAnimation_53f6
	dw MoveAnimation_53f6
	dw MoveAnimation_5401
	dw MoveAnimation_540c
	dw MoveAnimation_5417
	dw MoveAnimation_5422
	dw MoveAnimation_542d
	dw MoveAnimation_542d
	dw MoveAnimation_5438
	dw MoveAnimation_5438
	dw MoveAnimation_5438
	dw MoveAnimation_5438
	dw MoveAnimation_5438
	dw MoveAnimation_5443
	dw MoveAnimation_5443
	dw MoveAnimation_544e
	dw MoveAnimation_5443
	dw MoveAnimation_5443
	dw MoveAnimation_5443
	dw MoveAnimation_5453
	dw MoveAnimation_5453
	dw MoveAnimation_5460
	dw MoveAnimation_5453
	dw MoveAnimation_5467
	dw MoveAnimation_5467
	dw MoveAnimation_5472
	dw MoveAnimation_5472
	dw MoveAnimation_547d
	dw MoveAnimation_5488
	dw MoveAnimation_548f
	dw MoveAnimation_549c
	dw MoveAnimation_549c
	dw MoveAnimation_54a9
	dw MoveAnimation_54a9
	dw MoveAnimation_54ae
	dw MoveAnimation_54ae
	dw MoveAnimation_54b3
	dw MoveAnimation_54be
	dw MoveAnimation_54c3
	dw MoveAnimation_54c8
	dw MoveAnimation_54d3
	dw MoveAnimation_54e0
	dw MoveAnimation_54eb
	dw MoveAnimation_54f2
	dw MoveAnimation_54f9
	dw MoveAnimation_5504
	dw MoveAnimation_5513
	dw MoveAnimation_5516
	dw MoveAnimation_5521
	dw MoveAnimation_552e
	dw MoveAnimation_5533
	dw MoveAnimation_553a
	dw MoveAnimation_5543
	dw MoveAnimation_554a
	dw MoveAnimation_5555
	dw MoveAnimation_555e
	dw MoveAnimation_556d
	dw MoveAnimation_5574
	dw MoveAnimation_557b
	dw MoveAnimation_557e
	dw MoveAnimation_5583
	dw MoveAnimation_5583
	dw MoveAnimation_5583
	dw MoveAnimation_558c
	dw MoveAnimation_5597
	dw MoveAnimation_559c
	dw MoveAnimation_55a1
	dw MoveAnimation_55a4
	dw MoveAnimation_55a9
	dw MoveAnimation_55b4
	dw MoveAnimation_55b4
	dw MoveAnimation_55bf
	dw MoveAnimation_55c4
	dw MoveAnimation_55c9
	dw MoveAnimation_55ce
	dw MoveAnimation_55d5
	dw MoveAnimation_55e0
	dw MoveAnimation_55e5
	dw MoveAnimation_55e6
	dw MoveAnimation_55ed
	dw MoveAnimation_55f2
	dw MoveAnimation_55fb
	dw MoveAnimation_55fe
	dw MoveAnimation_5601
	dw MoveAnimation_5604
	dw MoveAnimation_5607
	dw MoveAnimation_560a
	dw MoveAnimation_560f
	dw MoveAnimation_5612
	dw MoveAnimation_561d
	dw MoveAnimation_5628
	dw MoveAnimation_562d
	dw MoveAnimation_5632
	dw MoveAnimation_5637
	dw MoveAnimation_5644
	dw MoveAnimation_564f
	dw MoveAnimation_5654
	dw MoveAnimation_5659
	dw MoveAnimation_565e
	dw MoveAnimation_5665
	dw MoveAnimation_5668
	dw MoveAnimation_5673
	dw MoveAnimation_5673

MoveAnimation_52c6: ; (6:52c6)
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_52cf:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $08
	anim_normal         ANIM_SHAKE2
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_52d8:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       ANIM_THUNDER_SHOCK
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_52e3:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $0b
	anim_opponent       $0c
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_52f0:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $65
	anim_normal         $0d
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_52fd:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $0e
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5308:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $0f
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5313:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $10
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_531e:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $11
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5329:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $12
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5334:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $13
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_533f:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $14
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_534a:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $0b
	anim_opponent       $13
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5357:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $15
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5362:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $16
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_536d:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $17
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5378:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $18
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5383:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $19
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_538e:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $1a
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5399:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $1b
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_53a4:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $1c
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_53af:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $1d
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_53ba:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $1e
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_53c5:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $1f
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_53d0:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $20
	anim_end

MoveAnimation_53d5:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $21
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_53e0:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $22
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_53eb:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $23
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_53f6:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       ANIM_FURY_SWIPES
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5401:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $25
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_540c:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $26
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5417:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $27
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5422:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $28
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_542d:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $29
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5438:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2a
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5443:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2b
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_544e:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2b
	anim_end

MoveAnimation_5453:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2c
	anim_normal         $66
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5460:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2c
	anim_normal         $66
	anim_end

MoveAnimation_5467:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2d
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5472:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2e
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_547d:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2f
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5488:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $30
	anim_normal         $66
	anim_end

MoveAnimation_548f:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $66
	anim_opponent       $31
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_549c:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $65
	anim_opponent       $32
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_54a9:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $33
	anim_end

MoveAnimation_54ae:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $34
	anim_end

MoveAnimation_54b3:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $35
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_54be:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $36
	anim_end

MoveAnimation_54c3:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $37
	anim_end

MoveAnimation_54c8:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $38
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_54d3:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $38
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_player         $36
	anim_end

MoveAnimation_54e0:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $39
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_54eb:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $3a
	anim_normal         ANIM_SHAKE1
	anim_end

MoveAnimation_54f2:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         ANIM_SHAKE1
	anim_opponent       $3b
	anim_end

MoveAnimation_54f9:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $3c
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5504:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $3d
	anim_normal         $65
	anim_player         $41
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5513:
	anim_player         ANIM_SPELL_MOVE
	anim_end

MoveAnimation_5516:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $3f
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5521:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $40
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_opponent       $3b
	anim_end

MoveAnimation_552e:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $65
	anim_end

MoveAnimation_5533:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $65
	anim_opponent       $01
	anim_end

MoveAnimation_553a:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $65
	anim_unknown        $04
	anim_unknown2       $46
	anim_end

MoveAnimation_5543:
	anim_unknown        $04
	anim_unknown2       $46
	anim_normal         $65
	anim_end

MoveAnimation_554a:
	anim_unknown        $04
	anim_unknown2       $46
	anim_normal         $65
	anim_unknown2       $47
	anim_unknown2       $47
	anim_end

MoveAnimation_5555:
	anim_unknown        $04
	anim_unknown2       $46
	anim_normal         $45
	anim_unknown        $01
	anim_end

MoveAnimation_555e:
	anim_unknown        $04
	anim_unknown2       $46
	anim_unknown2       $44
	anim_unknown        $04
	anim_unknown2       $07
	anim_normal         ANIM_SHAKE1
	anim_unknown2       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_556d:
	anim_unknown        $04
	anim_unknown2       $46
	anim_unknown2       $49
	anim_end

MoveAnimation_5574:
	anim_player         ANIM_SPELL_MOVE
	anim_unknown        $04
	anim_normal         $4a
	anim_end

MoveAnimation_557b:
	anim_player         ANIM_SPELL_MOVE
	anim_end

MoveAnimation_557e:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $65
	anim_end

MoveAnimation_5583:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_558c:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $29
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5597:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $33
	anim_end

MoveAnimation_559c:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $4b
	anim_end

MoveAnimation_55a1:
	anim_player         ANIM_SPELL_MOVE
	anim_end

MoveAnimation_55a4:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $4d
	anim_end

MoveAnimation_55a9:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $22
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_55b4:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $4d
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_55bf:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2b
	anim_end

MoveAnimation_55c4:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $17
	anim_end

MoveAnimation_55c9:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $65
	anim_end

MoveAnimation_55ce:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $18
	anim_opponent       $3b
	anim_end

MoveAnimation_55d5:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $04
	anim_player         $07
	anim_normal         ANIM_SHAKE3
	anim_player         ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_55e0:
	anim_player         ANIM_SPELL_MOVE
	anim_normal         $12
	anim_end

MoveAnimation_55e5:
	anim_end

MoveAnimation_55e6:
	anim_unknown        $04
	anim_unknown2       $06
	anim_unknown2       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_55ed:
	anim_player         $3e
	anim_player         ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_55f2:
	anim_unknown        $01
	anim_player         $07
	anim_normal         ANIM_SHAKE3
	anim_player         ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_55fb:
	anim_opponent       $05
	anim_end

MoveAnimation_55fe:
	anim_opponent       $04
	anim_end

MoveAnimation_5601:
	anim_opponent       $02
	anim_end

MoveAnimation_5604:
	anim_opponent       $03
	anim_end

MoveAnimation_5607:
	anim_player         $04
	anim_end

MoveAnimation_560a:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2a
	anim_end

MoveAnimation_560f:
	anim_opponent       $3b
	anim_end

MoveAnimation_5612:
	anim_unknown        $04
	anim_unknown2       $44
	anim_unknown2       $07
	anim_normal         ANIM_SHAKE1
	anim_unknown2       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_561d:
	anim_unknown        $04
	anim_unknown2       $4c
	anim_unknown2       $07
	anim_normal         ANIM_SHAKE1
	anim_unknown2       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5628:
	anim_unknown        $04
	anim_normal         $4e
	anim_end

MoveAnimation_562d:
	anim_unknown        $04
	anim_normal         $4f
	anim_end

MoveAnimation_5632:
	anim_unknown        $04
	anim_unknown2       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5637:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $39
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_normal         $65
	anim_end

MoveAnimation_5644:
	anim_player         ANIM_SPELL_MOVE
	anim_player         $4b
	anim_opponent       ANIM_GET_HIT
	anim_normal         ANIM_SHAKE1
	anim_opponent       ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_564f:
	anim_player         $05
	anim_player         ANIM_SHOW_DAMAGE
	anim_end

MoveAnimation_5654:
	anim_player         $3e
	anim_normal         $98
	anim_end

MoveAnimation_5659:
	anim_player         $03
	anim_normal         $98
	anim_end

MoveAnimation_565e:
	anim_player         ANIM_SPELL_MOVE
	anim_opponent       $2c
	anim_normal         $66
	anim_end

MoveAnimation_5665:
	anim_opponent       $39
	anim_end

MoveAnimation_5668:
	anim_unknown        $04
	anim_unknown2       $46
	anim_unknown        $01
	anim_player         $3e
	anim_opponent       $3e
	anim_end

MoveAnimation_5673:
	anim_end
