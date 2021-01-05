; palette data are read by Func_80418, expected to be structured as so:
; the first byte has possible values of 0, 1 or 2
; - if 0, nothing is done;
; - if 1, then the next byte is written to OBP0 (or to OBP1 if wd4ca == $1);
; - if 2, then the next 2 bytes are written to OBP0 and OBP1 respectively
;   (or only the first written to OBP1 if wd4ca == $1, skipping the second byte)
; next there is a byte declaring the size of the palette data
; indicating the number of palettes

Palette0:: ; b738a (2d:738a)
	db 1, %11100100
	db 8

	rgb 28, 28, 24
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

Palette1:: ; b73cd (2d:73cd)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  8, 26,  0
	rgb  9,  3, 31
	rgb  1,  0,  5

	rgb 31, 31, 31
	rgb  8, 26,  0
	rgb  1, 15,  0
	rgb  1,  0,  5

	rgb 31, 31, 31
	rgb 25, 18,  6
	rgb 15,  6,  0
	rgb  1,  0,  5

	rgb 31, 31, 31
	rgb  8, 26,  0
	rgb 31,  0,  0
	rgb  1,  0,  5

	rgb 31, 31, 31
	rgb  8, 26,  0
	rgb 25, 18,  6
	rgb  1,  0,  5

	rgb 31, 31, 31
	rgb 31, 29,  0
	rgb 25, 18,  6
	rgb  1,  0,  5

	rgb 31, 31, 31
	rgb 25, 18,  6
	rgb  9,  3, 31
	rgb  1,  0,  5

Palette2:: ; b740f (2d:740f)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 25, 31, 31
	rgb  9, 21, 31
	rgb 24, 13,  0
	rgb  5,  3,  0

	rgb 28, 28, 28
	rgb 25, 20,  0
	rgb  8,  6,  1
	rgb  0,  0,  0

	rgb 30, 27, 15
	rgb 24, 13,  0
	rgb 14,  8,  0
	rgb  0,  0,  0

	rgb 28, 28, 28
	rgb  1, 20,  0
	rgb  8,  6,  1
	rgb  0,  0,  0

	rgb 25, 31, 31
	rgb  9, 21, 31
	rgb  5,  7, 31
	rgb  0,  0,  5

	rgb 25, 31, 31
	rgb  9, 21, 31
	rgb 31,  0, 31
	rgb  0,  0,  5

	rgb 25, 31, 31
	rgb  9, 21, 31
	rgb  4, 21,  1
	rgb  1, 10,  0

Palette3:: ; b7451 (2d:7451)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 30, 21
	rgb 30, 15,  5
	rgb  9,  0,  0
	rgb  0,  0,  0

	rgb 31, 29, 15
	rgb 23, 17,  7
	rgb  1, 22,  0
	rgb  0,  8,  0

	rgb 31, 31, 31
	rgb 31, 26, 20
	rgb 25, 16,  2
	rgb  5,  2,  0

	rgb 31, 29, 15
	rgb 23, 17,  7
	rgb 22, 11,  6
	rgb  6,  6,  3

	rgb 31, 31, 31
	rgb  8, 15, 31
	rgb  0,  3, 23
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

Palette4:: ; b7493 (2d:7493)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  0, 21, 10
	rgb  0,  0,  0

	rgb 31, 30, 22
	rgb 28, 12,  0
	rgb 13,  5,  0
	rgb  4,  1,  0

	rgb 31, 31, 17
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 24, 13,  0
	rgb  5,  3,  0

Palette5:: ; b74d5 (2d:74d5)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  0, 21, 10
	rgb  0,  0,  0

	rgb 27, 25, 23
	rgb 22, 16, 12
	rgb 14,  8,  4
	rgb  4,  1,  0

	rgb 31, 31, 17
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 31, 31, 31
	rgb  0, 31,  6
	rgb 24, 13,  0
	rgb  5,  3,  0

Palette6:: ; b7517 (2d:7517)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  0, 21, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0, 31, 30
	rgb  0, 14, 31
	rgb  0,  2,  5

	rgb 31, 31, 17
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 24, 13,  0
	rgb  5,  3,  0

Palette7:: ; b7559 (2d:7559)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  0, 21, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31, 31,  0
	rgb 31, 20,  0
	rgb  7,  4,  0

	rgb 31, 31, 17
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 24, 13,  0
	rgb  5,  3,  0

Palette8:: ; b759b (2d:759b)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  0, 21, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 19, 31,  5
	rgb  0, 19,  4
	rgb  0,  4,  1

	rgb 31, 31, 17
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 24, 13,  0
	rgb  5,  3,  0

Palette9:: ; b75dd (2d:75dd)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  0, 21, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31,  5, 31
	rgb 20,  0, 31
	rgb  1,  0,  5

	rgb 31, 31, 17
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 24, 13,  0
	rgb  5,  3,  0

Palette10:: ; b761f (2d:761f)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  0, 21, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0, 31,  6
	rgb  0, 23,  4
	rgb  0,  7,  2

	rgb 31, 31, 17
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 24, 13,  0
	rgb  5,  3,  0

Palette11:: ; b7661 (2d:7661)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  0, 21, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31, 20,  0
	rgb 31,  0,  0
	rgb  8,  0,  0

	rgb 31, 31, 17
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 24, 13,  0
	rgb  5,  3,  0

Palette12:: ; b76a3 (2d:76a3)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 24, 21,  6
	rgb 11,  8,  5
	rgb  0,  0,  0

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 31, 31, 31
	rgb 28, 12,  0
	rgb 11,  8,  5
	rgb  0,  0,  6

	rgb 27, 31, 22
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 31, 31, 31
	rgb  9, 21, 31
	rgb  5,  7, 31
	rgb  0,  0,  5

	rgb 31, 31, 31
	rgb 31, 31,  4
	rgb 28, 12,  0
	rgb  6,  4,  0

	rgb 27, 31, 22
	rgb  0, 25,  6
	rgb 28, 12,  0
	rgb  0,  0,  6

Palette13:: ; b76e5 (2d:76e5)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 26, 22,  9
	rgb 12,  5,  1
	rgb  0,  7,  0

	rgb 31, 31, 31
	rgb 18, 18, 24
	rgb  6,  5, 18
	rgb  0,  0,  0

	rgb 22, 31, 22
	rgb  5, 31,  0
	rgb  0, 19,  2
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 26, 22,  9
	rgb 31,  2,  0
	rgb 12,  5,  1

	rgb 22, 31, 22
	rgb  5, 31,  0
	rgb 11, 10, 10
	rgb  0,  0,  0

	rgb 22, 31, 22
	rgb  5, 31,  0
	rgb  8,  9,  8
	rgb 31,  2,  0

	rgb 31, 31, 31
	rgb 18, 18, 24
	rgb  5, 31, 25
	rgb  0,  0,  6

Palette14:: ; b7727 (2d:7727)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31, 16, 11
	rgb 10,  8, 25
	rgb  0,  0,  6

	rgb 31, 31, 31
	rgb 17, 25, 31
	rgb  0,  6, 27
	rgb 31, 31,  0

	rgb 31, 31, 31
	rgb 29, 20,  3
	rgb 16,  5,  0
	rgb  3,  2,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 25,  3

	rgb 31, 31, 31
	rgb 31, 25,  3
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 31, 31, 31
	rgb 31, 25,  3
	rgb 20, 13,  0
	rgb  3,  2,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

Palette15:: ; b7769 (2d:7769)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0, 21, 31
	rgb  3,  0, 31
	rgb  0,  0,  8

	rgb 31, 31, 20
	rgb 31, 16,  0
	rgb 31, 31, 31
	rgb  0,  0,  8

	rgb 31, 31, 20
	rgb 31, 16,  0
	rgb 31,  2,  0
	rgb  0,  0,  8

	rgb 31, 31, 31
	rgb  0, 21, 31
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 31, 31, 20
	rgb 31, 16,  0
	rgb  0, 31,  0
	rgb  0,  4,  0

	rgb 31, 31, 20
	rgb 31, 16,  0
	rgb 24, 13,  0
	rgb  5,  3,  0

	rgb 31, 31, 31
	rgb  0, 31,  0
	rgb  4, 21,  1
	rgb  1, 10,  0

Palette16:: ; b77ab (2d:77ab)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 21
	rgb 31, 23,  4
	rgb 10,  3,  0
	rgb  0,  0,  0

	rgb 31, 31, 27
	rgb  0, 23, 31
	rgb  3,  0, 20
	rgb  0,  0,  4

	rgb 31, 31, 31
	rgb 28, 17,  0
	rgb 31,  0,  5
	rgb  3,  0, 10

	rgb 31, 31, 27
	rgb 21,  0, 12
	rgb  3,  0, 20
	rgb  0,  0,  4

	rgb 31, 31, 27
	rgb 21,  0, 12
	rgb  0, 23, 31
	rgb  3,  0, 20

	rgb 31, 31, 31
	rgb 28, 17,  0
	rgb 14,  0,  8
	rgb  3,  0, 10

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

Palette17:: ; b77ed (2d:77ed)
	db 0
	db 8

	rgb 31, 31, 30
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 16
	rgb  4, 29,  4
	rgb  0, 12,  0
	rgb 12,  2,  0

	rgb 31, 31, 31
	rgb  4, 29,  4
	rgb  0, 12,  0
	rgb 19, 19, 19

	rgb 30, 24, 10
	rgb  4, 29,  4
	rgb  0, 12,  0
	rgb 12,  2,  0

	rgb 31, 31, 31
	rgb  0, 31,  6
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb 31, 31,  0
	rgb 10, 28, 31
	rgb 10, 12, 31
	rgb  0,  0, 11

	rgb 31, 22, 31
	rgb  4, 29,  4
	rgb 24, 13,  0
	rgb 12,  2,  0

	rgb 30, 24, 10
	rgb 27, 19,  6
	rgb 20, 10,  0
	rgb 11,  2,  0

Palette18:: ; b782f (2d:782f)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 19
	rgb 30, 21,  0
	rgb 23,  8,  0
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 19, 13, 31
	rgb  0,  0, 31
	rgb  0,  0, 10

	rgb 31, 31, 19
	rgb 30, 21,  0
	rgb 31,  0,  0
	rgb 11,  0,  0

	rgb 31, 31, 19
	rgb 19, 13, 31
	rgb 30, 21,  0
	rgb  0,  0, 10

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

Palette19:: ; b7871 (2d:7871)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 28, 22, 31
	rgb 21, 13, 31
	rgb 13,  0, 31
	rgb  0,  0,  0

	rgb 31, 31,  0
	rgb  0, 31,  0
	rgb  0,  0, 31
	rgb 31,  0,  0

	rgb 31, 31, 31
	rgb 28, 12,  3
	rgb 11,  2,  1
	rgb  4,  1,  1

	rgb 31, 31, 31
	rgb 10, 28, 31
	rgb  0, 18,  8
	rgb  0,  0,  2

	rgb 28, 22, 31
	rgb 10, 11, 31
	rgb  2,  4, 31
	rgb  6,  0,  0

	rgb 28, 22, 31
	rgb 21, 13, 31
	rgb 31,  2,  0
	rgb 12,  2,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

Palette20:: ; b78b3 (2d:78b3)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 26, 31
	rgb  8, 20, 31
	rgb  0,  0, 28
	rgb  0,  0,  5

	rgb 31, 31, 24
	rgb 31, 19,  7
	rgb 16, 31,  7
	rgb  0, 11,  6

	rgb 31, 31, 24
	rgb 31, 19,  7
	rgb 31,  0,  0
	rgb 16,  0,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

Palette21:: ; b78f5 (2d:78f5)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31, 22,  7
	rgb  0, 23,  0
	rgb  1, 10,  0

	rgb 31, 31, 21
	rgb 31, 22,  7
	rgb 22,  8,  0
	rgb  5,  3,  0

	rgb 31, 31, 21
	rgb 31, 26,  0
	rgb 31,  0, 31
	rgb  0,  0,  3

	rgb 31, 31, 31
	rgb 31, 30,  0
	rgb 31,  0,  0
	rgb  2,  0,  0

	rgb 31, 31, 31
	rgb  8, 31, 31
	rgb  0, 23,  0
	rgb  4,  2,  1

	rgb 31, 31, 31
	rgb 31, 30,  0
	rgb 24, 13,  0
	rgb  2,  0,  0

	rgb 31, 31, 23
	rgb 31, 22,  7
	rgb 22,  8,  0
	rgb  5,  3,  0

Palette22:: ; b7937 (2d:7937)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 28, 16
	rgb 31,  0,  0
	rgb 20,  0,  0
	rgb 11,  1,  4

	rgb 31, 28, 16
	rgb 31,  0,  0
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 31, 28, 16
	rgb 31,  0,  0
	rgb 24, 13,  0
	rgb  5,  3,  0

	rgb 31, 31, 31
	rgb  9, 21, 31
	rgb  5,  7, 31
	rgb  0,  0,  5

	rgb 30, 27, 15
	rgb 24, 13,  0
	rgb 14,  8,  0
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31, 25,  0
	rgb  6,  4,  0
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 23, 12,  0
	rgb  6,  4,  0
	rgb  2,  0,  0

Palette23:: ; b7979 (2d:7979)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 28, 16
	rgb 31,  0,  0
	rgb 20,  0,  0
	rgb 11,  1,  4

	rgb 31, 28, 16
	rgb 31,  0,  0
	rgb  4, 21,  1
	rgb  1, 10,  0

	rgb 31, 28, 16
	rgb 31,  0,  0
	rgb 24, 13,  0
	rgb  5,  3,  0

	rgb 31, 31,  0
	rgb 31,  0,  0
	rgb 13, 10, 31
	rgb  3,  3, 20

	rgb 31, 31, 31
	rgb 23, 12,  0
	rgb  0, 23,  0
	rgb  0,  8,  0

	rgb 31, 31, 31
	rgb 25, 21,  0
	rgb 31,  0,  0
	rgb  2,  0,  0

	rgb 31, 31, 31
	rgb 23, 12,  0
	rgb  6,  4,  0
	rgb  2,  0,  0

Palette24:: ; b79bb (2d:79bb)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31,  0,  0
	rgb 20,  0,  0
	rgb 11,  1,  4

	rgb 31, 31, 31
	rgb 31, 28,  0
	rgb 31, 20,  6
	rgb 29,  6,  0

	rgb 31, 31, 31
	rgb 15, 16, 31
	rgb  7,  8, 20
	rgb  0,  0, 10

	rgb 31, 31, 31
	rgb 15, 16, 31
	rgb 31, 28,  0
	rgb  0,  0, 10

	rgb 31, 31, 31
	rgb 31, 28,  0
	rgb 20,  0,  0
	rgb 29,  6,  0

	rgb 31, 31, 31
	rgb 15, 16, 31
	rgb 31,  0,  0
	rgb  0,  0, 10

	rgb 31, 31, 31
	rgb 23, 12,  0
	rgb  6,  4,  0
	rgb  4,  2,  1

Palette25:: ; b79fd (2d:79fd)
	db 0
	db 8

	rgb 28, 28, 24
	rgb 18, 18, 16
	rgb  8,  8,  8
	rgb  0,  0,  0

	rgb 28, 28, 24
	rgb 31, 22,  0
	rgb  0, 10, 27
	rgb  0,  0,  3

	rgb 28, 28, 24
	rgb 31,  0,  0
	rgb  0, 10, 27
	rgb  0,  0,  0

	rgb 28, 28, 24
	rgb 31, 22,  0
	rgb 31,  0,  0
	rgb  0,  0,  0

	rgb 28, 28, 24
	rgb 26, 23, 13
	rgb 31,  0,  0
	rgb  0,  0,  0

	rgb 28, 28, 24
	rgb 31, 16,  0
	rgb  0, 10, 27
	rgb  0,  0,  3

	rgb 28, 28, 24
	rgb 31, 22,  0
	rgb 26, 23, 13
	rgb  0,  0,  3

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

Palette26:: ; b7a3f (2d:7a3f)
	db 0
	db 8

	rgb 27, 27, 24
	rgb 20, 20, 17
	rgb 12, 12, 10
	rgb  5,  5,  3

	rgb 27, 27, 24
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb  0,  0, 31

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

Palette27:: ; b7a81 (2d:7a81)
	db 0
	db 8

	rgb 28, 28, 24
	rgb 21, 21, 16
	rgb 10, 10,  8
	rgb  0,  0,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

Palette28:: ; b7ac3 (2d:7ac3)
	db 0
	db 8

	rgb 27, 27, 24
	rgb 20, 20, 17
	rgb 12, 12, 10
	rgb  5,  5,  3

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

Palette29:: ; b7b05 (2d:7b05)
	db 2, %11010011, %11100011
	db 8

	rgb  6, 14, 11
	rgb 30, 27, 24
	rgb  6, 15, 25
	rgb  0,  0,  0

	rgb  6, 14, 11
	rgb 30, 27, 24
	rgb 30, 13, 18
	rgb  0,  0,  0

	rgb  6, 14, 11
	rgb 30, 27, 24
	rgb 28, 24,  5
	rgb  0,  0,  0

	rgb  6, 14, 11
	rgb 30, 27, 24
	rgb  4, 19,  3
	rgb  0,  0,  0

	rgb  6, 14, 11
	rgb 30, 27, 24
	rgb 30,  5,  9
	rgb  0,  0,  0

	rgb  6, 14, 11
	rgb 30, 27, 24
	rgb 15,  8, 26
	rgb  0,  0,  0

	rgb  6, 14, 11
	rgb 30, 27, 24
	rgb 31, 31, 31
	rgb  0,  0,  0

	rgb  6, 14, 11
	rgb 30, 27, 24
	rgb  9,  9, 27
	rgb  0,  0,  0

Palette30:: ; b7b49 (2d:7b49)
	db 2, %11010010, %11111111
	db 8

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb  5, 19,  6
	rgb  1,  0,  5

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb 31,  2,  4
	rgb  1,  0,  5

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb  7, 23, 31
	rgb  1,  0,  5

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb 25, 24, 31
	rgb  1,  0,  5

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb 31, 31,  0
	rgb  1,  0,  5

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb 27, 18, 31
	rgb  1,  0,  5

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb 23, 11,  7
	rgb  1,  0,  5

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 31, 13,  0
	rgb 31, 31,  0

Palette32:: ; b7b8d (2d:7b8d)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb 28, 20, 12
	rgb  0,  0,  0

Palette33:: ; b7b98 (2d:7b98)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 28, 20, 12
	rgb  0,  0,  0

Palette34:: ; b7ba3 (2d:7ba3)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31,  0
	rgb 31, 13,  0
	rgb 11,  4,  0

Palette35:: ; b7bae (2d:7bae)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 17, 17, 29
	rgb  8,  8, 24
	rgb  0,  0, 10

Palette36:: ; b7bb9 (2d:7bb9)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 23, 23
	rgb 31,  6,  7
	rgb  0,  0,  0

Palette37:: ; b7bc4 (2d:7bc4)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 15, 15, 15
	rgb  0,  0,  0

Palette38:: ; b7bcf (2d:7bcf)
	db 1, %11000010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 26,  0
	rgb  0,  0,  0

Palette39:: ; b7bda (2d:7bda)
	db 1, %11000010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 26,  0
	rgb  0,  0,  0

Palette40:: ; b7be5 (2d:7be5)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 31,  0
	rgb  0,  0,  0

Palette41:: ; b7bf0 (2d:7bf0)
	db 1, %11000010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 26,  0
	rgb  0,  0,  0

Palette42:: ; b7bfb (2d:7bfb)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 30, 28, 13
	rgb 31, 17,  8
	rgb 12,  0,  0

Palette43:: ; b7c06 (2d:7c06)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 30, 28, 13
	rgb 31, 17,  8
	rgb 12,  0,  0

Palette44:: ; b7c11 (2d:7c11)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 30, 28, 13
	rgb 31, 17,  8
	rgb 12,  0,  0

Palette45:: ; b7c1c (2d:7c1c)
	db 1, %11100010
	db 1

	rgb 16, 23, 20
	rgb 20, 31, 31
	rgb  6, 14, 31
	rgb 14,  0, 31

Palette46:: ; b7c27 (2d:7c27)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb  0, 31, 31
	rgb  0, 15, 31
	rgb  0,  0, 21

Palette47:: ; b7c32 (2d:7c32)
	db 1, %10010010
	db 1

	rgb 11, 11, 11
	rgb  0, 31, 31
	rgb  0, 15, 31
	rgb  0,  0,  9

Palette48:: ; b7c3d (2d:7c3d)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb  0, 31, 31
	rgb  0, 15, 31
	rgb  0,  0, 21

Palette49:: ; b7c48 (2d:7c48)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb  0, 15, 31
	rgb  0, 15, 31

Palette50:: ; b7c53 (2d:7c53)
	db 1, %11100010
	db 1

	rgb  0,  0,  0
	rgb  7, 20, 31
	rgb  5, 13, 27
	rgb  0,  1,  8

Palette51:: ; b7c5e (2d:7c5e)
	db 1, %11010010
	db 1

	rgb 28, 28, 24
	rgb 31, 31, 31
	rgb 31,  0,  8
	rgb  7,  0,  3

Palette52:: ; b7c69 (2d:7c69)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 28, 20, 20
	rgb 28, 12, 12
	rgb 12,  4,  4

Palette53:: ; b7c74 (2d:7c74)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 22
	rgb 28, 20, 12
	rgb  0,  0,  0

Palette54:: ; b7c7f (2d:7c7f)
	db 1, %11010010
	db 1

	rgb 28, 28, 24
	rgb 31, 31, 31
	rgb 21, 13,  0
	rgb  0,  0,  0

Palette55:: ; b7c8a (2d:7c8a)
	db 1, %11100010
	db 1

	rgb 28, 28, 24
	rgb 31, 12,  0
	rgb 28,  0,  0
	rgb  8,  0,  0

Palette56:: ; b7c95 (2d:7c95)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 28, 20, 12
	rgb  0,  0,  0

Palette57:: ; b7ca0 (2d:7ca0)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 18
	rgb 18, 19,  4
	rgb  6,  7,  0

Palette58:: ; b7cab (2d:7cab)
	db 1, %11100010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 18
	rgb 31, 13,  0
	rgb  6,  7,  0

Palette59:: ; b7cb6 (2d:7cb6)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 18
	rgb 18, 19,  4
	rgb  6,  7,  0

Palette60:: ; b7cc1 (2d:7cc1)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 28, 28, 28
	rgb 20, 20, 20
	rgb  6,  7,  0

Palette61:: ; b7ccc (2d:7ccc)
	db 1, %11010010
	db 1

	rgb 16, 23, 20
	rgb 31, 31,  0
	rgb 31, 20,  0
	rgb  7,  1,  0

Palette62:: ; b7cd7 (2d:7cd7)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  6,  7,  0

Palette63:: ; b7ce2 (2d:7ce2)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb  1, 10, 23
	rgb 26, 31, 18
	rgb  6,  7,  0

Palette64:: ; b7ced (2d:7ced)
	db 1, %11100010
	db 1

	rgb  0,  0,  0
	rgb 28, 25, 31
	rgb 16, 14, 22
	rgb  0,  0, 13

Palette65:: ; b7cf8 (2d:7cf8)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 30, 31, 29
	rgb 25, 25, 25
	rgb  1,  1,  1

Palette66:: ; b7d03 (2d:7d03)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 31, 31, 24
	rgb 10,  9,  0

Palette67:: ; b7d0e (2d:7d0e)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 26, 31, 18
	rgb 19, 23, 13
	rgb  6,  7,  0

Palette68:: ; b7d19 (2d:7d19)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 26, 29, 31
	rgb 13, 16, 28
	rgb  6,  7,  0

Palette69:: ; b7d24 (2d:7d24)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 27, 31, 27
	rgb 13, 16, 28
	rgb  6,  7,  0

Palette70:: ; b7d2f (2d:7d2f)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 26, 31
	rgb 31, 16, 27
	rgb 14,  0,  5

Palette71:: ; b7d3a (2d:7d3a)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 27, 16, 23
	rgb  0,  0,  2

Palette72:: ; b7d45 (2d:7d45)
	db 1, %11100010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 11, 10, 10
	rgb  0,  0,  2

Palette73:: ; b7d50 (2d:7d50)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 24
	rgb 31, 28, 18
	rgb 13, 10,  0

Palette74:: ; b7d5b (2d:7d5b)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 31, 31, 30
	rgb  5,  2,  0

Palette75:: ; b7d66 (2d:7d66)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 23
	rgb 26, 26,  4
	rgb 16,  3,  0

Palette76:: ; b7d71 (2d:7d71)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 28, 31
	rgb 31, 22, 29
	rgb 19,  8, 12

Palette77:: ; b7d7c (2d:7d7c)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 23
	rgb 26, 26,  4
	rgb  6,  7,  0

Palette78:: ; b7d87 (2d:7d87)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 28
	rgb 13, 23, 30
	rgb  1, 11,  8

Palette79:: ; b7d92 (2d:7d92)
	db 1, %11100010
	db 1

	rgb 11, 11, 11
	rgb 30, 31, 31
	rgb  8,  8, 12
	rgb  0,  0,  5

Palette80:: ; b7d9d (2d:7d9d)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 27, 29, 31
	rgb 18, 20, 31
	rgb  8,  4, 10

Palette81:: ; b7da8 (2d:7da8)
	db 1, %11000010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 18, 26, 30
	rgb  0,  0,  3

Palette82:: ; b7db3 (2d:7db3)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 31,  4,  4
	rgb 12,  2,  0

Palette83:: ; b7dbe (2d:7dbe)
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 26
	rgb 23, 21, 22
	rgb  3,  3,  3

Palette84:: ; b7dc9 (2d:7dc9)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 26, 26,  4
	rgb  6,  7,  0

Palette85:: ; b7dd4 (2d:7dd4)
	db 1, %11100010
	db 1

	rgb  0,  0,  0
	rgb 29, 24, 24
	rgb 17,  5,  5
	rgb  6,  7,  0

Palette86:: ; b7ddf (2d:7ddf)
	db 1, %11100110
	db 1

	rgb 11, 11, 11
	rgb 25, 23, 23
	rgb 14, 13, 13
	rgb  3,  3,  3

Palette87:: ; b7dea (2d:7dea)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31,  7
	rgb 31, 24,  6
	rgb 11,  3,  0

Palette88:: ; b7df5 (2d:7df5)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  6,  7,  0

Palette89:: ; b7e00 (2d:7e00)
	db 1, %11100010
	db 1

	rgb 28, 28, 24
	rgb 31, 31,  0
	rgb 31, 17,  0
	rgb  9,  3,  0

Palette90:: ; b7e0b (2d:7e0b)
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  6,  7,  0

Palette91:: ; b7e16 (2d:7e16)
	db 1, %11100110
	db 1

	rgb 16, 16, 20
	rgb 28, 28, 24
	rgb 12, 12, 20
	rgb  0,  0,  0

Palette92:: ; b7e21 (2d:7e21)
	db 1, %11100100
	db 1

	rgb 28, 28, 24
	rgb 31, 19,  0
	rgb 23, 10,  0
	rgb  0,  0,  0

Palette93:: ; b7e2c (2d:7e2c)
	db 1, %11001001
	db 1

	rgb 20, 20, 16
	rgb 31,  0,  0
	rgb 31, 31,  0
	rgb  0,  0,  0

Palette94:: ; b7e37 (2d:7e37)
	db 0
	db 8

	rgb  0,  0,  0
	rgb  1,  0,  0
	rgb  2,  0,  0
	rgb  3,  0,  0

	rgb  4,  0,  0
	rgb  5,  0,  0
	rgb  6,  0,  0
	rgb  7,  0,  0

	rgb  8,  0,  0
	rgb  9,  0,  0
	rgb 10,  0,  0
	rgb 11,  0,  0

	rgb 12,  0,  0
	rgb 13,  0,  0
	rgb 14,  0,  0
	rgb 15,  0,  0

	rgb 16,  0,  0
	rgb 17,  0,  0
	rgb 18,  0,  0
	rgb 19,  0,  0

	rgb 20,  0,  0
	rgb 21,  0,  0
	rgb 22,  0,  0
	rgb 23,  0,  0

	rgb 24,  0,  0
	rgb 25,  0,  0
	rgb 26,  0,  0
	rgb 27,  0,  0

	rgb 28,  0,  0
	rgb 29,  0,  0
	rgb 30,  0,  0
	rgb 31,  0,  0

Palette95:: ; b7e79 (2d:7e79)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 31, 30, 30
	rgb 31, 29, 29
	rgb 31, 28, 28

	rgb 31, 27, 27
	rgb 31, 26, 26
	rgb 31, 25, 25
	rgb 31, 24, 24

	rgb 31, 23, 23
	rgb 31, 22, 22
	rgb 31, 21, 21
	rgb 31, 20, 20

	rgb 31, 19, 19
	rgb 31, 18, 18
	rgb 31, 17, 17
	rgb 31, 16, 16

	rgb 31, 15, 15
	rgb 31, 14, 14
	rgb 31, 13, 13
	rgb 31, 12, 12

	rgb 31, 11, 11
	rgb 31, 10, 10
	rgb 31,  9,  9
	rgb 31,  8,  8

	rgb 31,  7,  7
	rgb 31,  6,  6
	rgb 31,  5,  5
	rgb 31,  4,  4

	rgb 31,  3,  3
	rgb 31,  2,  2
	rgb 31,  1,  1
	rgb 31,  0,  0

Palette96:: ; b7ebb (2d:7ebb)
	db 0
	db 8

	rgb  0,  0,  0
	rgb  0,  1,  0
	rgb  0,  2,  0
	rgb  0,  3,  0

	rgb  0,  4,  0
	rgb  0,  5,  0
	rgb  0,  6,  0
	rgb  0,  7,  0

	rgb  0,  8,  0
	rgb  0,  9,  0
	rgb  0, 10,  0
	rgb  0, 11,  0

	rgb  0, 12,  0
	rgb  0, 13,  0
	rgb  0, 14,  0
	rgb  0, 15,  0

	rgb  0, 16,  0
	rgb  0, 17,  0
	rgb  0, 18,  0
	rgb  0, 19,  0

	rgb  0, 20,  0
	rgb  0, 21,  0
	rgb  0, 22,  0
	rgb  0, 23,  0

	rgb  0, 24,  0
	rgb  0, 25,  0
	rgb  0, 26,  0
	rgb  0, 27,  0

	rgb  0, 28,  0
	rgb  0, 29,  0
	rgb  0, 30,  0
	rgb  0, 31,  0

Palette97:: ; b7efd (2d:7efd)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 30, 31, 30
	rgb 29, 31, 29
	rgb 28, 31, 28

	rgb 27, 31, 27
	rgb 26, 31, 26
	rgb 25, 31, 25
	rgb 24, 31, 24

	rgb 23, 31, 23
	rgb 22, 31, 22
	rgb 21, 31, 21
	rgb 20, 31, 20

	rgb 19, 31, 19
	rgb 18, 31, 18
	rgb 17, 31, 17
	rgb 16, 31, 16

	rgb 15, 31, 15
	rgb 14, 31, 14
	rgb 13, 31, 13
	rgb 12, 31, 12

	rgb 11, 31, 11
	rgb 10, 31, 10
	rgb  9, 31,  9
	rgb  8, 31,  8

	rgb  7, 31,  7
	rgb  6, 31,  6
	rgb  5, 31,  5
	rgb  4, 31,  4

	rgb  3, 31,  3
	rgb  2, 31,  2
	rgb  1, 31,  1
	rgb  0, 31,  0

Palette98:: ; b7f3f (2d:7f3f)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 31,  0,  0
	rgb 31,  6,  0
	rgb 31, 12,  0

	rgb 31, 19,  0
	rgb 31, 25,  0
	rgb 31, 31,  0
	rgb 25, 31,  0

	rgb 19, 31,  0
	rgb 12, 31,  0
	rgb  6, 31,  0
	rgb  0, 31,  0

	rgb  0, 31,  6
	rgb  0, 31, 12
	rgb  0, 31, 19
	rgb  0, 31, 25

	rgb  0, 31, 31
	rgb  0, 25, 31
	rgb  0, 19, 31
	rgb  0, 12, 31

	rgb  0,  6, 31
	rgb  0,  0, 31
	rgb  6,  0, 31
	rgb 12,  0, 31

	rgb 19,  0, 31
	rgb 25,  0, 31
	rgb 31,  0, 31
	rgb 31,  0, 25

	rgb 31,  0, 19
	rgb 31,  0, 12
	rgb 31,  0,  6
	rgb  0,  0,  0

Palette99:: ; b7f81 (2d:7f81)
	db 0
	db 8

	rgb 31, 31, 31
	rgb 15, 15, 15
	rgb 28, 28, 28
	rgb  0,  0, 15

	rgb 29, 29, 29
	rgb 13, 13, 13
	rgb 31, 31,  0
	rgb 31, 31, 31

	rgb 27, 27, 27
	rgb 11, 11, 11
	rgb  0, 31, 31
	rgb 15,  0, 15

	rgb 25, 25, 25
	rgb  9,  9,  9
	rgb  0, 31,  0
	rgb  0,  0,  0

	rgb 23, 23, 23
	rgb  7,  7,  7
	rgb 31,  0, 31
	rgb  4,  0,  0

	rgb 21, 21, 21
	rgb  5,  5,  5
	rgb 31,  0,  0
	rgb  0,  4,  0

	rgb 19, 19, 19
	rgb  3,  3,  3
	rgb  0,  0, 31
	rgb  0,  0,  4

	rgb 17, 17, 17
	rgb  1,  1,  1
	rgb  0,  0,  0
	rgb  0, 31,  0

Palette101:: ; b7fc3 (2d:7fc3)
	db 0
	db 7

	rgb 28, 28, 28
	rgb 28, 28,  0
	rgb 28, 16,  0
	rgb  4,  0,  0

	rgb 28, 28, 28
	rgb  0,  0, 28
	rgb  0,  0,  4
	rgb  4,  0,  0

	rgb 28, 28, 28
	rgb 24,  4,  0
	rgb 28, 16,  0
	rgb  4,  0,  0

	rgb 28, 28, 28
	rgb 28, 28,  0
	rgb 24,  4,  0
	rgb  4,  0,  0

	rgb 28, 28, 28
	rgb  4, 12,  0
	rgb 28, 16,  0
	rgb  4,  0,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 28, 12,  0
	rgb 28, 28,  0

Palette108:: ; b7ffd (2d:7ffd)
	db 1, %11100100
	db 0

