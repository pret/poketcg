	dw .vibrato_type_0
	dw .vibrato_type_1
	dw .vibrato_type_2
	dw .vibrato_type_3
	dw .vibrato_type_4
	dw .vibrato_type_5
	dw .vibrato_type_6
	dw .vibrato_type_7
	dw .vibrato_type_8
	dw .vibrato_type_9
	dw .vibrato_type_A

.vibrato_type_0
	db $00,$80,$80

.vibrato_type_1
	db $01,$02,$01,$00,$ff,$fe,$ff,$00,$80,$80

.vibrato_type_2
	db $03,$fd,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$01

.vibrato_type_3
	db $01,$01,$00,$00,$ff,$ff,$00,$00,$80,$80

.vibrato_type_4
	db $01,$01,$01,$00,$00,$00,$ff,$ff,$ff,$00,$00,$00,$80,$80

.vibrato_type_5
	db $02,$04,$06,$04,$02,$00,$fe,$fc,$fa,$fc,$fe,$00,$80,$80

.vibrato_type_6
	db $04,$04,$08,$08,$04,$04,$00,$00,$fc,$fc,$f8,$f8,$fc,$fc,$00,$00,$80,$80

.vibrato_type_7
	db $f8,$f8,$f9,$f9,$fa,$fa,$fb,$fb,$fc,$fc,$fd,$fd,$fe,$fe,$ff,$ff,$00,$00,$80,$05

.vibrato_type_8
	db $02,$04,$02,$00,$fe,$fc,$fe,$00,$80,$80

.vibrato_type_9
	db $01,$02,$04,$02,$01,$00,$ff,$fe,$fc,$fe,$ff,$00,$80,$08

.vibrato_type_A
	db $01,$01,$01,$01,$00,$00,$00,$00,$ff,$ff,$ff,$ff,$00,$00,$00,$00,$80,$80
