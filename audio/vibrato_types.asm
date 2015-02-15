	dw .vibratoType0
	dw .vibratoType1
	dw .vibratoType2
	dw .vibratoType3
	dw .vibratoType4
	dw .vibratoType5
	dw .vibratoType6
	dw .vibratoType7
	dw .vibratoType8
	dw .vibratoType9
	dw .vibratoTypeA

.vibratoType0
	db $00,$80,$80

.vibratoType1
	db $01,$02,$01,$00,$ff,$fe,$ff,$00,$80,$80

.vibratoType2
	db $03,$fd,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$01

.vibratoType3
	db $01,$01,$00,$00,$ff,$ff,$00,$00,$80,$80

.vibratoType4
	db $01,$01,$01,$00,$00,$00,$ff,$ff,$ff,$00,$00,$00,$80,$80

.vibratoType5
	db $02,$04,$06,$04,$02,$00,$fe,$fc,$fa,$fc,$fe,$00,$80,$80

.vibratoType6
	db $04,$04,$08,$08,$04,$04,$00,$00,$fc,$fc,$f8,$f8,$fc,$fc,$00,$00,$80,$80

.vibratoType7
	db $f8,$f8,$f9,$f9,$fa,$fa,$fb,$fb,$fc,$fc,$fd,$fd,$fe,$fe,$ff,$ff,$00,$00,$80,$05

.vibratoType8
	db $02,$04,$02,$00,$fe,$fc,$fe,$00,$80,$80

.vibratoType9
	db $01,$02,$04,$02,$01,$00,$ff,$fe,$fc,$fe,$ff,$00,$80,$08

.vibratoTypeA
	db $01,$01,$01,$01,$00,$00,$00,$00,$ff,$ff,$ff,$ff,$00,$00,$00,$00,$80,$80
