MoveEffectCommands: ; 186f7 (6:46f7)
; Each move has a two-byte effect pointer (move's 7th param) that points to one of these structures:
; 	db CommandId ($01 - $09)
; 	dw Function
; 	...
; 	db $00

; Apparently every command has a "time", and a function is called multiple times during a turn
; with an argument identifying the command Id. If said command Id is found in the
; current move effect's array, its assigned function is immediately executed.

EkansSpitPoisonEffectCommands:
	dbw $03, $46F8
 	dbw $09, $46F0
	db  $00
EkansWrapEffectCommands:
	dbw $03, $4011
	db  $00
ArbokTerrorStrikeEffectCommands:	
	dbw $04, $4726
 	dbw $05, $470A
 	dbw $0A, $470A
	db  $00
ArbokPoisonFangEffectCommands:	
	dbw $03, $4007
 	dbw $09, $4730
	db  $00;NextEffectCommands:
	dbw $03, $4000
 	dbw $09, $4738
	db  $00;NextEffectCommands:
	dbw $01, $4740
 	dbw $04, $476A
 	dbw $05, $474B
 	dbw $08, $4764
	db  $00;NextEffectCommands:
	dbw $03, $477E
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $4007
 	dbw $09, $478B
	db  $00;NextEffectCommands:
	dbw $03, $4793
	db  $00;NextEffectCommands:
	dbw $03, $47A0
	db  $00;NextEffectCommands:
	dbw $03, $4000
 	dbw $09, $47B4
	db  $00;NextEffectCommands:
	dbw $04, $47BC
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $04, $47C6
	db  $00;NextEffectCommands:
	dbw $03, $47D0
	db  $00;NextEffectCommands:
	dbw $03, $47DC
	db  $00;NextEffectCommands:
	dbw $04, $47E3
	db  $00;NextEffectCommands:
	dbw $03, $47F5
 	dbw $09, $47ED
	db  $00;NextEffectCommands:
	dbw $03, $4000
 	dbw $09, $480D
	db  $00;NextEffectCommands:
	dbw $03, $4030
	db  $00;NextEffectCommands:
	dbw $04, $4815
	db  $00;NextEffectCommands:
	dbw $03, $482A
 	dbw $09, $4822
	db  $00;NextEffectCommands:
	dbw $03, $4836
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $01, $484A
 	dbw $04, $48CC
 	dbw $05, $485A
 	dbw $08, $48B7
	db  $00;NextEffectCommands:
	dbw $01, $48EC
 	dbw $04, $491A
 	dbw $05, $48F7
 	dbw $08, $490F
	db  $00;NextEffectCommands:
	dbw $03, $4944
 	dbw $09, $4925
	db  $00;NextEffectCommands:
	dbw $03, $4973
 	dbw $04, $4982
 	dbw $09, $496B
	db  $00;NextEffectCommands:
	dbw $03, $4994
 	dbw $09, $498C
	db  $00;NextEffectCommands:
	dbw $03, $4998
	db  $00;NextEffectCommands:
	dbw $03, $49C6
 	dbw $09, $49BE
	db  $00;NextEffectCommands:
	dbw $01, $49DB
 	dbw $04, $4A6E
 	dbw $05, $49EB
 	dbw $08, $4A55
	db  $00;NextEffectCommands:
	dbw $03, $4A96
 	dbw $09, $4A8E
	db  $00;NextEffectCommands:
	dbw $03, $4AAC
	db  $00;NextEffectCommands:
	dbw $03, $4ABB
 	dbw $09, $4AB3
	db  $00;NextEffectCommands:
	dbw $03, $4ADB
 	dbw $09, $4AD3
	db  $00;NextEffectCommands:
	dbw $04, $4B09
 	dbw $05, $4AF3
 	dbw $0A, $4AF3
	db  $00;NextEffectCommands:
	dbw $04, $4B0F
	db  $00;NextEffectCommands:
	dbw $03, $4030
	db  $00;NextEffectCommands:
	dbw $03, $4030
	db  $00;NextEffectCommands:
	dbw $03, $4000
 	dbw $09, $4B27
	db  $00;NextEffectCommands:
	dbw $03, $4007
 	dbw $09, $4B2F
	db  $00;NextEffectCommands:
	dbw $04, $4B37
	db  $00;NextEffectCommands:
	dbw $02, $4B44
 	dbw $03, $4B77
 	dbw $04, $4BFB
 	dbw $05, $4B6F
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $4C30
	db  $00;NextEffectCommands:
	dbw $01, $4C36
	db  $00;NextEffectCommands:
	dbw $03, $4000
 	dbw $09, $4C38
	db  $00;NextEffectCommands:
	dbw $01, $4C40
 	dbw $04, $4CC2
 	dbw $05, $4C50
 	dbw $08, $4CAD
	db  $00;NextEffectCommands:
	dbw $03, $4000
 	dbw $09, $4CE2
	db  $00;NextEffectCommands:
	dbw $04, $4CEA
	db  $00;NextEffectCommands:
	dbw $02, $4D09
 	dbw $03, $4D5D
 	dbw $05, $4D21
	db  $00;NextEffectCommands:
	dbw $03, $4D8C
 	dbw $09, $4D84
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $4007
 	dbw $09, $4DA0
	db  $00;NextEffectCommands:
	dbw $02, $4DA8
 	dbw $03, $4DC7
	db  $00;NextEffectCommands:
	dbw $03, $4E2B
 	dbw $09, $4E23
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $4007
 	dbw $09, $4E4B
	db  $00;NextEffectCommands:
	dbw $02, $4E53
 	dbw $03, $4E82
	db  $00;NextEffectCommands:
	dbw $04, $4EB0
	db  $00;NextEffectCommands:
	dbw $03, $4F05
 	dbw $09, $4F05
	db  $00;NextEffectCommands:
	dbw $03, $4F12
 	dbw $09, $4F0A
	db  $00;NextEffectCommands:
	dbw $01, $4F2A
	db  $00;NextEffectCommands:
	dbw $03, $4F2C
 	dbw $09, $4F2C
	db  $00;NextEffectCommands:
	dbw $03, $4F32
	db  $00;NextEffectCommands:
	dbw $01, $4F46
	db  $00;NextEffectCommands:
	dbw $03, $4F48
 	dbw $09, $4F48
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $4F54
 	dbw $09, $4F4E
	db  $00;NextEffectCommands:
	dbw $01, $4F5D
 	dbw $04, $4FDF
 	dbw $05, $4F6D
 	dbw $08, $4FCA
	db  $00;NextEffectCommands:
	dbw $03, $5005
 	dbw $09, $4FFF
	db  $00;NextEffectCommands:
	dbw $03, $500E
	db  $00;NextEffectCommands:
	dbw $03, $501E
 	dbw $09, $5016
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $04, $506B
 	dbw $05, $5033
 	dbw $08, $5065
	db  $00;NextEffectCommands:
	dbw $03, $5085
 	dbw $09, $5085
	db  $00;NextEffectCommands:
	dbw $03, $508B
	db  $00;NextEffectCommands:
	dbw $03, $509D
	db  $00;NextEffectCommands:
	dbw $03, $50A4
	db  $00;NextEffectCommands:
	dbw $03, $50C0
 	dbw $09, $50B8
	db  $00;NextEffectCommands:
	dbw $03, $50D3
 	dbw $09, $50D3
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $01, $50D9
 	dbw $02, $50F0
 	dbw $04, $5114
 	dbw $06, $510E
 	dbw $08, $5103
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $5120
	db  $00;NextEffectCommands:
	dbw $03, $5134
	db  $00;NextEffectCommands:
	dbw $03, $513A
	db  $00;NextEffectCommands:
	dbw $03, $4007
 	dbw $09, $5141
	db  $00;NextEffectCommands:
	dbw $01, $5149
 	dbw $02, $516F
 	dbw $03, $5179
 	dbw $08, $5173
	db  $00;NextEffectCommands:
	dbw $03, $51C8
 	dbw $09, $51C0
	db  $00;NextEffectCommands:
	dbw $03, $51E0
 	dbw $09, $51E0
	db  $00;NextEffectCommands:
	dbw $04, $5214
 	dbw $05, $51E6
 	dbw $08, $520E
	db  $00;NextEffectCommands:
	dbw $03, $5227
 	dbw $09, $5227
	db  $00;NextEffectCommands:
	dbw $03, $522D
	db  $00;NextEffectCommands:
	dbw $03, $524E
 	dbw $09, $5246
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $5266
 	dbw $04, $526F
	db  $00;NextEffectCommands:
	dbw $02, $528B
 	dbw $03, $52C3
 	dbw $05, $52AE
	db  $00;NextEffectCommands:
	dbw $03, $52EB
 	dbw $09, $52EB
	db  $00;NextEffectCommands:
	dbw $03, $401D
	db  $00;NextEffectCommands:
	dbw $01, $52F1
 	dbw $07, $52F3
	db  $00;NextEffectCommands:
	dbw $03, $5329
 	dbw $04, $532E
	db  $00;NextEffectCommands:
	dbw $03, $533F
	db  $00;NextEffectCommands:
	dbw $01, $5363
 	dbw $02, $5371
 	dbw $06, $5379
 	dbw $08, $5375
	db  $00;NextEffectCommands:
	dbw $04, $537F
	db  $00;NextEffectCommands:
	dbw $03, $538D
 	dbw $09, $5385
	db  $00;NextEffectCommands:
	dbw $01, $53A0
 	dbw $02, $53AE
 	dbw $03, $53EF
 	dbw $06, $53DE
 	dbw $08, $53D5
 	dbw $09, $53E9
	db  $00;NextEffectCommands:
	dbw $03, $5400
 	dbw $09, $53F8
	db  $00;NextEffectCommands:
	dbw $03, $5413
	db  $00;NextEffectCommands:
	dbw $01, $5425
 	dbw $04, $544F
 	dbw $05, $5430
 	dbw $08, $5449
	db  $00;NextEffectCommands:
	dbw $01, $5463
 	dbw $02, $5471
 	dbw $06, $5479
 	dbw $08, $5475
	db  $00;NextEffectCommands:
	dbw $01, $547F
 	dbw $02, $548D
 	dbw $06, $5495
 	dbw $08, $5491
	db  $00;NextEffectCommands:
	dbw $01, $549B
 	dbw $02, $54A9
 	dbw $04, $54F4
 	dbw $06, $54E1
 	dbw $08, $54DD
	db  $00;NextEffectCommands:
	dbw $03, $552B
 	dbw $09, $5523
	db  $00;NextEffectCommands:
	dbw $03, $5549
 	dbw $09, $5541
	db  $00;NextEffectCommands:
	dbw $01, $555C
 	dbw $02, $556A
 	dbw $06, $5572
 	dbw $08, $556E
	db  $00;NextEffectCommands:
	dbw $01, $5578
 	dbw $02, $5586
 	dbw $06, $558E
 	dbw $08, $558A
	db  $00;NextEffectCommands:
	dbw $03, $5594
	db  $00;NextEffectCommands:
	dbw $03, $4000
 	dbw $09, $559A
	db  $00;NextEffectCommands:
	dbw $01, $55A2
 	dbw $02, $55B0
 	dbw $06, $55B8
 	dbw $08, $55B4
	db  $00;NextEffectCommands:
	dbw $01, $55BE
	db  $00;NextEffectCommands:
	dbw $01, $55C0
 	dbw $02, $55CD
 	dbw $06, $5614
 	dbw $08, $5606
	db  $00;NextEffectCommands:
	dbw $03, $401D
	db  $00;NextEffectCommands:
	dbw $03, $563E
 	dbw $09, $5638
	db  $00;NextEffectCommands:
	dbw $04, $5647
	db  $00;NextEffectCommands:
	dbw $03, $56AB
 	dbw $09, $56A3
	db  $00;NextEffectCommands:
	dbw $01, $56C0
 	dbw $07, $56C2
	db  $00;NextEffectCommands:
	dbw $03, $5776
 	dbw $09, $576E
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $02, $57FC
 	dbw $03, $58BB
 	dbw $05, $5834
	db  $00;NextEffectCommands:
	dbw $04, $593C
 	dbw $05, $5903
 	dbw $08, $592A
	db  $00;NextEffectCommands:
	dbw $03, $594F
	db  $00;NextEffectCommands:
	dbw $01, $5956
 	dbw $02, $5964
 	dbw $03, $5987
 	dbw $06, $5981
 	dbw $08, $5976
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $01, $598D
 	dbw $04, $59B4
 	dbw $05, $5994
 	dbw $08, $599B
	db  $00;NextEffectCommands:
	dbw $03, $4030
	db  $00;NextEffectCommands:
	dbw $01, $59D6
	db  $00;NextEffectCommands:
	dbw $01, $59E5
	db  $00;NextEffectCommands:
	dbw $03, $4030
	db  $00;NextEffectCommands:
	dbw $01, $59E7
 	dbw $04, $5A41
 	dbw $05, $5A00
 	dbw $08, $5A3C
	db  $00;NextEffectCommands:
	dbw $04, $5B64
 	dbw $05, $5B2B
 	dbw $08, $5B52
	db  $00;NextEffectCommands:
	dbw $03, $401D
	db  $00;NextEffectCommands:
	dbw $01, $5B77
	db  $00;NextEffectCommands:
	dbw $03, $5B7F
 	dbw $09, $5B79
	db  $00;NextEffectCommands:
	dbw $02, $5B8E
 	dbw $03, $5BA2
 	dbw $04, $5C27
	db  $00;NextEffectCommands:
	dbw $03, $401D
	db  $00;NextEffectCommands:
	dbw $03, $5C49
	db  $00;NextEffectCommands:
	dbw $01, $5C53
 	dbw $02, $5C64
 	dbw $03, $5CB6
 	dbw $04, $5CBB
 	dbw $08, $5C9E
	db  $00;NextEffectCommands:
	dbw $01, $5D79
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $5D81
 	dbw $09, $5D7B
	db  $00;NextEffectCommands:
	dbw $01, $5D8E
 	dbw $02, $5D9C
 	dbw $03, $5DBF
 	dbw $06, $5DB9
 	dbw $08, $5DAE
	db  $00;NextEffectCommands:
	dbw $01, $5DC5
 	dbw $04, $5DEC
 	dbw $05, $5DCC
 	dbw $08, $5DD3
	db  $00;NextEffectCommands:
	dbw $01, $5DFF
 	dbw $04, $5E26
 	dbw $05, $5E06
 	dbw $08, $5E0D
	db  $00;NextEffectCommands:
	dbw $02, $5E39
 	dbw $03, $5E5B
 	dbw $04, $5EB3
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $01, $5ED5
 	dbw $03, $5EE0
 	dbw $04, $5EF1
	db  $00;NextEffectCommands:
	dbw $01, $5F05
 	dbw $02, $5F1A
 	dbw $04, $5F5F
 	dbw $05, $5F46
 	dbw $06, $5F40
 	dbw $08, $5F2D
	db  $00;NextEffectCommands:
	dbw $01, $5F74
 	dbw $02, $5F7B
 	dbw $03, $5F85
 	dbw $08, $5F7F
	db  $00;NextEffectCommands:
	dbw $01, $5F89
 	dbw $02, $5FA0
 	dbw $04, $5FC3
 	dbw $06, $5FBD
 	dbw $08, $5FB2
	db  $00;NextEffectCommands:
	dbw $03, $5FD7
 	dbw $09, $5FCF
	db  $00;NextEffectCommands:
	dbw $03, $5FF2
 	dbw $09, $5FEC
	db  $00;NextEffectCommands:
	dbw $03, $6009
 	dbw $04, $603E
 	dbw $09, $6001
	db  $00;NextEffectCommands:
	dbw $03, $6052
 	dbw $09, $604A
	db  $00;NextEffectCommands:
	dbw $03, $6075
	db  $00;NextEffectCommands:
	dbw $03, $6083
 	dbw $09, $607B
	db  $00;NextEffectCommands:
	dbw $03, $6099
	db  $00;NextEffectCommands:
	dbw $01, $60AF
	db  $00;NextEffectCommands:
	dbw $01, $60B1
	db  $00;NextEffectCommands:
	dbw $04, $60B3
	db  $00;NextEffectCommands:
	dbw $03, $60CB
	db  $00;NextEffectCommands:
	dbw $03, $60D7
 	dbw $09, $60D1
	db  $00;NextEffectCommands:
	dbw $03, $60E8
 	dbw $09, $60E0
	db  $00;NextEffectCommands:
	dbw $01, $6100
 	dbw $04, $6194
 	dbw $05, $6110
 	dbw $08, $6177
	db  $00;NextEffectCommands:
	dbw $03, $61BA
 	dbw $09, $61B4
	db  $00;NextEffectCommands:
	dbw $04, $61D1
	db  $00;NextEffectCommands:
	dbw $04, $61D7
	db  $00;NextEffectCommands:
	dbw $03, $61F6
	db  $00;NextEffectCommands:
	dbw $04, $6212
 	dbw $05, $61FC
 	dbw $0A, $61FC
	db  $00;NextEffectCommands:
	dbw $03, $621D
	db  $00;NextEffectCommands:
	dbw $01, $6231
 	dbw $04, $625B
 	dbw $05, $623C
 	dbw $08, $6255
	db  $00;NextEffectCommands:
	dbw $03, $626B
	db  $00;NextEffectCommands:
	dbw $03, $6279
 	dbw $09, $6271
	db  $00;NextEffectCommands:
	dbw $04, $628F
	db  $00;NextEffectCommands:
	dbw $01, $629A
	db  $00;NextEffectCommands:
	dbw $02, $629C
 	dbw $03, $62B4
	db  $00;NextEffectCommands:
	dbw $03, $630F
	db  $00;NextEffectCommands:
	dbw $01, $631C
 	dbw $04, $6335
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $63A1
 	dbw $04, $63B0
 	dbw $09, $6399
	db  $00;NextEffectCommands:
	dbw $03, $63BA
	db  $00;NextEffectCommands:
	dbw $03, $63C8
 	dbw $09, $63C0
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $04, $63db
	db  $00;NextEffectCommands:
	dbw $03, $63FA
 	dbw $04, $6409
	db  $00;NextEffectCommands:
	dbw $03, $6419
	db  $00;NextEffectCommands:
	dbw $04, $6429
	db  $00;NextEffectCommands:
	dbw $03, $64C3
 	dbw $09, $64BB
	db  $00;NextEffectCommands:
	dbw $03, $64DE
 	dbw $09, $64D6
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $64FC
 	dbw $09, $64F4
	db  $00;NextEffectCommands:
	dbw $03, $651A
 	dbw $04, $6529
	db  $00;NextEffectCommands:
	dbw $04, $6574
 	dbw $05, $6539
 	dbw $08, $6562
	db  $00;NextEffectCommands:
	dbw $03, $6589
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $658F
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $04, $6595
	db  $00;NextEffectCommands:
	dbw $03, $65DC
	db  $00;NextEffectCommands:
	dbw $03, $65EE
 	dbw $04, $65FD
	db  $00;NextEffectCommands:
	dbw $04, $671F
 	dbw $05, $660D
 	dbw $08, $66C3
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $04, $6739
	db  $00;NextEffectCommands:
	dbw $03, $6758
 	dbw $04, $675E
 	dbw $09, $6758
	db  $00;NextEffectCommands:
	dbw $04, $675F
	db  $00;NextEffectCommands:
	dbw $01, $677E
 	dbw $07, $6780
	db  $00;NextEffectCommands:
	dbw $04, $67CB
	db  $00;NextEffectCommands:
	dbw $04, $67D5
	db  $00;NextEffectCommands:
	dbw $03, $6870
 	dbw $04, $6876
 	dbw $09, $6870
	db  $00;NextEffectCommands:
	dbw $01, $6877
 	dbw $04, $68F6
 	dbw $05, $687B
 	dbw $08, $68F1
	db  $00;NextEffectCommands:
	dbw $03, $6938
 	dbw $09, $6930
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $694E
	db  $00;NextEffectCommands:
	dbw $03, $696A
 	dbw $09, $6962
	db  $00;NextEffectCommands:
	dbw $01, $697F
 	dbw $02, $6981
 	dbw $03, $6987
 	dbw $04, $6989
 	dbw $05, $6983
 	dbw $08, $6985
 	dbw $09, $697D
	db  $00;NextEffectCommands:
	dbw $03, $6AB8
	db  $00;NextEffectCommands:
	dbw $02, $6ACA
 	dbw $03, $6AE8
	db  $00;NextEffectCommands:
	dbw $03, $6AFE
 	dbw $09, $6AF6
	db  $00;NextEffectCommands:
	dbw $01, $6B15
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $01, $6B1F
 	dbw $03, $6B34
 	dbw $06, $6B2C
 	dbw $09, $6B17
	db  $00;NextEffectCommands:
	dbw $04, $6B40
	db  $00;NextEffectCommands:
	dbw $03, $6B65
 	dbw $09, $6B5D
	db  $00;NextEffectCommands:
	dbw $03, $6B83
 	dbw $09, $6B7B
	db  $00;NextEffectCommands:
	dbw $03, $6BA1
 	dbw $09, $6B96
	db  $00;NextEffectCommands:
	dbw $03, $6BC2
 	dbw $09, $6BBA
	db  $00;NextEffectCommands:
	dbw $01, $6BD7
	db  $00;NextEffectCommands:
	dbw $03, $6BDF
 	dbw $09, $6BD9
	db  $00;NextEffectCommands:
	dbw $04, $6BE8
	db  $00;NextEffectCommands:
	dbw $03, $6C14
 	dbw $09, $6C0C
	db  $00;NextEffectCommands:
	dbw $04, $6C35
 	dbw $05, $6C2C
 	dbw $08, $6C2F
	db  $00;NextEffectCommands:
	dbw $01, $6C77
 	dbw $02, $6C82
 	dbw $08, $6C7E
	db  $00;NextEffectCommands:
	dbw $03, $6C88
	db  $00;NextEffectCommands:
	dbw $04, $6C8E
	db  $00;NextEffectCommands:
	dbw $04, $6CE9
 	dbw $05, $6CD3
 	dbw $0A, $6CD3
	db  $00;NextEffectCommands:
	dbw $01, $6CF2
 	dbw $02, $6CF5
 	dbw $03, $6CFE
 	dbw $04, $6D01
 	dbw $05, $6CF8
 	dbw $08, $6CFB
 	dbw $09, $6CEF
	db  $00;NextEffectCommands:
	dbw $03, $6D04
	db  $00;NextEffectCommands:
	dbw $01, $6D0B
 	dbw $02, $6D16
 	dbw $08, $6D12
	db  $00;NextEffectCommands:
	dbw $03, $4030
	db  $00;NextEffectCommands:
	dbw $03, $6D87
 	dbw $09, $6D87
	db  $00;NextEffectCommands:
	dbw $03, $4030
	db  $00;NextEffectCommands:
	dbw $01, $6D94
 	dbw $04, $6D9F
	db  $00;NextEffectCommands:
	dbw $04, $6DA6
	db  $00;NextEffectCommands:
	dbw $03, $6DAC
	db  $00;NextEffectCommands:
	dbw $03, $4011
	db  $00;NextEffectCommands:
	dbw $03, $6DB2
	db  $00;NextEffectCommands:
	dbw $04, $6DCF
 	dbw $05, $6DB9
 	dbw $0A, $6DB9
	db  $00;NextEffectCommands:
	dbw $01, $6DD5
 	dbw $02, $6DED
 	dbw $04, $6DFB
 	dbw $08, $6DF7
	db  $00;NextEffectCommands:
	dbw $01, $6E1F
 	dbw $02, $6E31
 	dbw $04, $6E5E
 	dbw $08, $6E3C
	db  $00;NextEffectCommands:
	dbw $03, $6EE7
	db  $00;NextEffectCommands:
	dbw $04, $6EFB
	db  $00;NextEffectCommands:
	dbw $03, $6F07
 	dbw $09, $6F01
	db  $00;NextEffectCommands:
	dbw $02, $6F18
 	dbw $03, $6F3C
 	dbw $05, $6F27
	db  $00;NextEffectCommands:
	dbw $01, $6F51
 	dbw $07, $6F53
	db  $00;NextEffectCommands:
	dbw $03, $6FA4
 	dbw $09, $6F9C
	db  $00;NextEffectCommands:
	dbw $04, $6FE0
	db  $00;NextEffectCommands:
	dbw $04, $6FF6
	db  $00;NextEffectCommands:
	dbw $04, $70BF
	db  $00;NextEffectCommands:
	dbw $03, $70D0
 	dbw $04, $70D6
	db  $00;NextEffectCommands:
	dbw $01, $710D
 	dbw $04, $7119
	db  $00;NextEffectCommands:
	dbw $04, $7153
	db  $00;NextEffectCommands:
	db  $00;NextEffectCommands:
	db  $00;NextEffectCommands:
	db  $00;NextEffectCommands:
	db  $00;NextEffectCommands:
	db  $00;NextEffectCommands:
	db  $00;NextEffectCommands:
	db  $00;NextEffectCommands:
	dbw $01, $7159
 	dbw $02, $7167
 	dbw $03, $71B5
	db  $00;NextEffectCommands:
	dbw $03, $7216
	db  $00;NextEffectCommands:
	dbw $01, $7252
 	dbw $02, $725F
 	dbw $03, $7273
 	dbw $08, $726F
	db  $00;NextEffectCommands:
	dbw $01, $728E
 	dbw $02, $72A0
 	dbw $03, $72F8
 	dbw $05, $72B9
	db  $00;NextEffectCommands:
	dbw $01, $731C
 	dbw $03, $7372
 	dbw $05, $7328
	db  $00;NextEffectCommands:
	dbw $03, $73A1
	db  $00;NextEffectCommands:
	dbw $01, $73CA
 	dbw $02, $73D1
 	dbw $03, $73EF
	db  $00;NextEffectCommands:
	dbw $03, $73F9
	db  $00;NextEffectCommands:
	dbw $01, $743B
 	dbw $02, $744A
 	dbw $03, $7463
	db  $00;NextEffectCommands:
	dbw $02, $7488
 	dbw $03, $7499
	db  $00;NextEffectCommands:
	dbw $01, $74B3
 	dbw $03, $74BF
	db  $00;NextEffectCommands:
	dbw $01, $74C5
 	dbw $03, $74D1
	db  $00;NextEffectCommands:
	dbw $03, $74E1
	db  $00;NextEffectCommands:
	dbw $01, $7513
 	dbw $02, $752A
 	dbw $03, $7545
 	dbw $05, $752E
	db  $00;NextEffectCommands:
	dbw $01, $7561
 	dbw $03, $756D
	db  $00;NextEffectCommands:
	dbw $01, $7573
 	dbw $02, $757E
 	dbw $03, $758F
	db  $00;NextEffectCommands:
	dbw $03, $75E0
	db  $00;NextEffectCommands:
	dbw $01, $75EE
 	dbw $02, $75F9
 	dbw $03, $760A
	db  $00;NextEffectCommands:
	dbw $01, $7611
 	dbw $03, $7618
	db  $00;NextEffectCommands:
	dbw $01, $7659
 	dbw $02, $7672
 	dbw $03, $768F
	db  $00;NextEffectCommands:
	dbw $01, $76B3
 	dbw $02, $76C1
 	dbw $03, $76F4
	db  $00;NextEffectCommands:
	dbw $01, $7795
 	dbw $02, $77A0
 	dbw $03, $77C3
	db  $00;NextEffectCommands:
	dbw $01, $7826
 	dbw $02, $7838
 	dbw $03, $788D
 	dbw $05, $7853
	db  $00;NextEffectCommands:
	dbw $01, $78E1
 	dbw $03, $79AA
 	dbw $05, $78ED
	db  $00;NextEffectCommands:
	dbw $03, $79C4
	db  $00;NextEffectCommands:
	dbw $03, $79E3
	db  $00;NextEffectCommands:
	dbw $01, $7A70
 	dbw $02, $7A7B
 	dbw $03, $7A85
	db  $00;NextEffectCommands:
	dbw $01, $7AAD
 	dbw $03, $7B15
 	dbw $05, $7AB9
	db  $00;NextEffectCommands:
	dbw $01, $7B36
 	dbw $03, $7B68
 	dbw $05, $7B41
	db  $00;NextEffectCommands:
	dbw $01, $7B80
 	dbw $02, $7B93
 	dbw $03, $7BB0
	db  $00;NextEffectCommands:
	dbw $01, $7C0B
 	dbw $02, $7C24
 	dbw $03, $7C99
	db  $00;NextEffectCommands:
	dbw $01, $7CD0
 	dbw $02, $7CE4
 	dbw $03, $7D73
	db  $00;NextEffectCommands:
	dbw $01, $7DA4
 	dbw $02, $7DB6
 	dbw $03, $7DFA
 	dbw $05, $7DBA
	db  $00;NextEffectCommands:
	dbw $01, $7E6E
 	dbw $02, $7E79
 	dbw $03, $7E90
	db  $00
	