; palette data are read by LoadPaletteData, expected to be structured as so:
; the first byte has possible values of 0, 1 or 2
; - if 0, nothing is done;
; - if 1, then the next byte is written to OBP0 (or to OBP1 if wd4ca == $1);
; - if 2, then the next 2 bytes are written to OBP0 and OBP1 respectively
;   (or only the first written to OBP1 if wd4ca == $1, skipping the second byte)
; next there is a byte declaring the size of the palette data
; indicating the number of palettes

Palette0::
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

Palette1::
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

Palette2::
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

Palette3::
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

Palette4::
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

Palette5::
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

Palette6::
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

Palette7::
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

Palette8::
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

Palette9::
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

Palette10::
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

Palette11::
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

Palette12::
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

Palette13::
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

Palette14::
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

Palette15::
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

Palette16::
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

Palette17::
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

Palette18::
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

Palette19::
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

Palette20::
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

Palette21::
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

Palette22::
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

Palette23::
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

Palette24::
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

Palette25::
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

Palette26::
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

Palette27::
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

Palette28::
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

Palette29::
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

Palette30::
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

Palette32::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 28, 28, 24
	rgb 28, 20, 12
	rgb  0,  0,  0

Palette33::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 28, 20, 12
	rgb  0,  0,  0

Palette34::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31,  0
	rgb 31, 13,  0
	rgb 11,  4,  0

Palette35::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 17, 17, 29
	rgb  8,  8, 24
	rgb  0,  0, 10

Palette36::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 23, 23
	rgb 31,  6,  7
	rgb  0,  0,  0

Palette37::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 15, 15, 15
	rgb  0,  0,  0

Palette38::
	db 1, %11000010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 26,  0
	rgb  0,  0,  0

Palette39::
	db 1, %11000010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 26,  0
	rgb  0,  0,  0

Palette40::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 31,  0
	rgb  0,  0,  0

Palette41::
	db 1, %11000010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 26,  0
	rgb  0,  0,  0

Palette42::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 30, 28, 13
	rgb 31, 17,  8
	rgb 12,  0,  0

Palette43::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 30, 28, 13
	rgb 31, 17,  8
	rgb 12,  0,  0

Palette44::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 30, 28, 13
	rgb 31, 17,  8
	rgb 12,  0,  0

Palette45::
	db 1, %11100010
	db 1

	rgb 16, 23, 20
	rgb 20, 31, 31
	rgb  6, 14, 31
	rgb 14,  0, 31

Palette46::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb  0, 31, 31
	rgb  0, 15, 31
	rgb  0,  0, 21

Palette47::
	db 1, %10010010
	db 1

	rgb 11, 11, 11
	rgb  0, 31, 31
	rgb  0, 15, 31
	rgb  0,  0,  9

Palette48::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb  0, 31, 31
	rgb  0, 15, 31
	rgb  0,  0, 21

Palette49::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb  0, 15, 31
	rgb  0, 15, 31

Palette50::
	db 1, %11100010
	db 1

	rgb  0,  0,  0
	rgb  7, 20, 31
	rgb  5, 13, 27
	rgb  0,  1,  8

Palette51::
	db 1, %11010010
	db 1

	rgb 28, 28, 24
	rgb 31, 31, 31
	rgb 31,  0,  8
	rgb  7,  0,  3

Palette52::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 28, 20, 20
	rgb 28, 12, 12
	rgb 12,  4,  4

Palette53::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 22
	rgb 28, 20, 12
	rgb  0,  0,  0

Palette54::
	db 1, %11010010
	db 1

	rgb 28, 28, 24
	rgb 31, 31, 31
	rgb 21, 13,  0
	rgb  0,  0,  0

Palette55::
	db 1, %11100010
	db 1

	rgb 28, 28, 24
	rgb 31, 12,  0
	rgb 28,  0,  0
	rgb  8,  0,  0

Palette56::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 28, 20, 12
	rgb  0,  0,  0

Palette57::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 18
	rgb 18, 19,  4
	rgb  6,  7,  0

Palette58::
	db 1, %11100010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 18
	rgb 31, 13,  0
	rgb  6,  7,  0

Palette59::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 18
	rgb 18, 19,  4
	rgb  6,  7,  0

Palette60::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 28, 28, 28
	rgb 20, 20, 20
	rgb  6,  7,  0

Palette61::
	db 1, %11010010
	db 1

	rgb 16, 23, 20
	rgb 31, 31,  0
	rgb 31, 20,  0
	rgb  7,  1,  0

Palette62::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  6,  7,  0

Palette63::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb  1, 10, 23
	rgb 26, 31, 18
	rgb  6,  7,  0

Palette64::
	db 1, %11100010
	db 1

	rgb  0,  0,  0
	rgb 28, 25, 31
	rgb 16, 14, 22
	rgb  0,  0, 13

Palette65::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 30, 31, 29
	rgb 25, 25, 25
	rgb  1,  1,  1

Palette66::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 31, 31, 24
	rgb 10,  9,  0

Palette67::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 26, 31, 18
	rgb 19, 23, 13
	rgb  6,  7,  0

Palette68::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 26, 29, 31
	rgb 13, 16, 28
	rgb  6,  7,  0

Palette69::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 27, 31, 27
	rgb 13, 16, 28
	rgb  6,  7,  0

Palette70::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 26, 31
	rgb 31, 16, 27
	rgb 14,  0,  5

Palette71::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 27, 16, 23
	rgb  0,  0,  2

Palette72::
	db 1, %11100010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 11, 10, 10
	rgb  0,  0,  2

Palette73::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 24
	rgb 31, 28, 18
	rgb 13, 10,  0

Palette74::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 31, 31, 30
	rgb  5,  2,  0

Palette75::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 23
	rgb 26, 26,  4
	rgb 16,  3,  0

Palette76::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 28, 31
	rgb 31, 22, 29
	rgb 19,  8, 12

Palette77::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 23
	rgb 26, 26,  4
	rgb  6,  7,  0

Palette78::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 28
	rgb 13, 23, 30
	rgb  1, 11,  8

Palette79::
	db 1, %11100010
	db 1

	rgb 11, 11, 11
	rgb 30, 31, 31
	rgb  8,  8, 12
	rgb  0,  0,  5

Palette80::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 27, 29, 31
	rgb 18, 20, 31
	rgb  8,  4, 10

Palette81::
	db 1, %11000010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 18, 26, 30
	rgb  0,  0,  3

Palette82::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 30
	rgb 31,  4,  4
	rgb 12,  2,  0

Palette83::
	db 1, %11010010
	db 1

	rgb 11, 11, 11
	rgb 31, 31, 26
	rgb 23, 21, 22
	rgb  3,  3,  3

Palette84::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 26, 26,  4
	rgb  6,  7,  0

Palette85::
	db 1, %11100010
	db 1

	rgb  0,  0,  0
	rgb 29, 24, 24
	rgb 17,  5,  5
	rgb  6,  7,  0

Palette86::
	db 1, %11100110
	db 1

	rgb 11, 11, 11
	rgb 25, 23, 23
	rgb 14, 13, 13
	rgb  3,  3,  3

Palette87::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31,  7
	rgb 31, 24,  6
	rgb 11,  3,  0

Palette88::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  6,  7,  0

Palette89::
	db 1, %11100010
	db 1

	rgb 28, 28, 24
	rgb 31, 31,  0
	rgb 31, 17,  0
	rgb  9,  3,  0

Palette90::
	db 1, %11010010
	db 1

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 20, 20, 16
	rgb  6,  7,  0

Palette91::
	db 1, %11100110
	db 1

	rgb 16, 16, 20
	rgb 28, 28, 24
	rgb 12, 12, 20
	rgb  0,  0,  0

Palette92::
	db 1, %11100100
	db 1

	rgb 28, 28, 24
	rgb 31, 19,  0
	rgb 23, 10,  0
	rgb  0,  0,  0

Palette93::
	db 1, %11001001
	db 1

	rgb 20, 20, 16
	rgb 31,  0,  0
	rgb 31, 31,  0
	rgb  0,  0,  0

Palette94::
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

Palette95::
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

Palette96::
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

Palette97::
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

Palette98::
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

Palette99::
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

Palette101::
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

Palette108::
	db 1, %11100100
	db 0
