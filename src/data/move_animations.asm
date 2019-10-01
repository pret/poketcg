ani_end: MACRO
	db $00
ENDM
ani_normal: MACRO
	db $01, \1
ENDM
ani_player: MACRO
	db $02, \1
ENDM
ani_opponent: MACRO
	db $03, \1
ENDM
ani_unknown: MACRO
	db $04, \1
ENDM
ani_unknown2: MACRO
	db $05, \1
ENDM
ani_end2: MACRO
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

MoveAnimation_52c6:    ; (6:52c6)
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_52cf:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $08
	ani_normal 	 	   ANI_SHAKE2
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_52d8:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       ANI_THUNDER_SHOCK
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_52e3:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $0b
	ani_opponent       $0c
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_52f0:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_normal 	 	   $65
	ani_normal 	 	   $0d
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_52fd:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $0e
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5308:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $0f
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5313:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_normal 	 	   $10
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_531e:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $11
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5329:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_normal 	 	   $12
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5334:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $13
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_533f:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_normal 	 	   $14
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_534a:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $0b
	ani_opponent       $13
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5357:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $15
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5362:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_normal 	 	   $16
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_536d:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $17
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5378:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $18
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5383:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $19
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_538e:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $1a
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5399:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $1b
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_53a4:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $1c
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_53af:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $1d
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_53ba:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       $1e
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_53c5:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $1f
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_53d0:
	ani_player         ANI_SPELL_MOVE
	ani_player         $20
	ani_end

MoveAnimation_53d5:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $21
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_53e0:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $22
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_53eb:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $23
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_53f6:
	ani_player 	 	   ANI_SPELL_MOVE
	ani_opponent       ANI_FURY_SWEEPES
	ani_opponent       ANI_GET_HIT
	ani_normal 	 	   ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5401:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $25
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_540c:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $26
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5417:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $27
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5422:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $28
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_542d:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $29
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5438:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2a
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5443:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2b
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_544e:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2b
	ani_end

MoveAnimation_5453:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2c
	ani_normal         $66
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5460:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2c
	ani_normal         $66
	ani_end

MoveAnimation_5467:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2d
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5472:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2e
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_547d:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2f
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5488:
	ani_player         ANI_SPELL_MOVE
	ani_player         $30
	ani_normal         $66
	ani_end

MoveAnimation_548f:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $66
	ani_opponent       $31
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_549c:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $65
	ani_opponent       $32
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_54a9:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $33
	ani_end

MoveAnimation_54ae:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $34
	ani_end

MoveAnimation_54b3:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $35
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_54be:
	ani_player         ANI_SPELL_MOVE
	ani_player         $36
	ani_end

MoveAnimation_54c3:
	ani_player         ANI_SPELL_MOVE
	ani_player         $37
	ani_end

MoveAnimation_54c8:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $38
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_54d3:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $38
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_player         $36
	ani_end

MoveAnimation_54e0:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $39
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_54eb:
	ani_player         ANI_SPELL_MOVE
	ani_player         $3a
	ani_normal         ANI_SHAKE1
	ani_end

MoveAnimation_54f2:
	ani_player         ANI_SPELL_MOVE
	ani_normal         ANI_SHAKE1
	ani_opponent       $3b
	ani_end

MoveAnimation_54f9:
	ani_player         ANI_SPELL_MOVE
	ani_player         $3c
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5504:
	ani_player         ANI_SPELL_MOVE
	ani_player         $3d
	ani_normal         $65
	ani_player         $41
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5513:
	ani_player         ANI_SPELL_MOVE
	ani_end

MoveAnimation_5516:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $3f
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5521:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $40
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_opponent       $3b
	ani_end

MoveAnimation_552e:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $65
	ani_end

MoveAnimation_5533:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $65
	ani_opponent       $01
	ani_end

MoveAnimation_553a:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $65
	ani_unknown        $04
	ani_unknown2       $46
	ani_end

MoveAnimation_5543:
	ani_unknown        $04
	ani_unknown2       $46
	ani_normal         $65
	ani_end

MoveAnimation_554a:
	ani_unknown        $04
	ani_unknown2       $46
	ani_normal         $65
	ani_unknown2       $47
	ani_unknown2       $47
	ani_end

MoveAnimation_5555:
	ani_unknown        $04
	ani_unknown2       $46
	ani_normal         $45
	ani_unknown        $01
	ani_end

MoveAnimation_555e:
	ani_unknown        $04
	ani_unknown2       $46
	ani_unknown2       $44
	ani_unknown        $04
	ani_unknown2       $07
	ani_normal         ANI_SHAKE1
	ani_unknown2       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_556d:
	ani_unknown        $04
	ani_unknown2       $46
	ani_unknown2       $49
	ani_end

MoveAnimation_5574:
	ani_player         ANI_SPELL_MOVE
	ani_unknown        $04
	ani_normal         $4a
	ani_end

MoveAnimation_557b:
	ani_player         ANI_SPELL_MOVE
	ani_end

MoveAnimation_557e:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $65
	ani_end

MoveAnimation_5583:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_558c:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $29
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5597:
	ani_player         ANI_SPELL_MOVE
	ani_player         $33
	ani_end

MoveAnimation_559c:
	ani_player         ANI_SPELL_MOVE
	ani_player         $4b
	ani_end

MoveAnimation_55a1:
	ani_player         ANI_SPELL_MOVE
	ani_end

MoveAnimation_55a4:
	ani_player         ANI_SPELL_MOVE
	ani_player         $4d
	ani_end

MoveAnimation_55a9:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $22
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_55b4:
	ani_player         ANI_SPELL_MOVE
	ani_player         $4d
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_55bf:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2b
	ani_end

MoveAnimation_55c4:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $17
	ani_end

MoveAnimation_55c9:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $65
	ani_end

MoveAnimation_55ce:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $18
	ani_opponent       $3b
	ani_end

MoveAnimation_55d5:
	ani_player         ANI_SPELL_MOVE
	ani_player         $04
	ani_player         $07
	ani_normal         ANI_SHAKE3
	ani_player         ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_55e0:
	ani_player         ANI_SPELL_MOVE
	ani_normal         $12
	ani_end

MoveAnimation_55e5:
	ani_end

MoveAnimation_55e6:
	ani_unknown        $04
	ani_unknown2       $06
	ani_unknown2       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_55ed:
	ani_player         $3e
	ani_player         ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_55f2:
	ani_unknown        $01
	ani_player         $07
	ani_normal         ANI_SHAKE3
	ani_player         ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_55fb:
	ani_opponent       $05
	ani_end

MoveAnimation_55fe:
	ani_opponent       $04
	ani_end

MoveAnimation_5601:
	ani_opponent       $02
	ani_end

MoveAnimation_5604:
	ani_opponent       $03
	ani_end

MoveAnimation_5607:
	ani_player         $04
	ani_end

MoveAnimation_560a:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2a
	ani_end

MoveAnimation_560f:
	ani_opponent       $3b
	ani_end

MoveAnimation_5612:
	ani_unknown        $04
	ani_unknown2       $44
	ani_unknown2       $07
	ani_normal         ANI_SHAKE1
	ani_unknown2       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_561d:
	ani_unknown        $04
	ani_unknown2       $4c
	ani_unknown2       $07
	ani_normal         ANI_SHAKE1
	ani_unknown2       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5628:
	ani_unknown        $04
	ani_normal         $4e
	ani_end

MoveAnimation_562d:
	ani_unknown        $04
	ani_normal         $4f
	ani_end

MoveAnimation_5632:
	ani_unknown        $04
	ani_unknown2       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5637:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $39
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_normal         $65
	ani_end

MoveAnimation_5644:
	ani_player         ANI_SPELL_MOVE
	ani_player         $4b
	ani_opponent       ANI_GET_HIT
	ani_normal         ANI_SHAKE1
	ani_opponent       ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_564f:
	ani_player         $05
	ani_player         ANI_SHOW_DAMAGE
	ani_end

MoveAnimation_5654:
	ani_player         $3e
	ani_normal         $98
	ani_end

MoveAnimation_5659:
	ani_player         $03
	ani_normal         $98
	ani_end

MoveAnimation_565e:
	ani_player         ANI_SPELL_MOVE
	ani_opponent       $2c
	ani_normal         $66
	ani_end

MoveAnimation_5665:
	ani_opponent       $39
	ani_end

MoveAnimation_5668:
	ani_unknown        $04
	ani_unknown2       $46
	ani_unknown        $01
	ani_player         $3e
	ani_opponent       $3e
	ani_end

MoveAnimation_5673:
	ani_end