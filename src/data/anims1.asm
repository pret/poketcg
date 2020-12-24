AnimData0:: ; a8e54 (2a:4e54)
	frame_table AnimFrameTable0
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa8e6b

AnimFrameTable0:: ; a8e6b (2a:4e6b)
	dw .data_a8e7f
	dw .data_a8e90
	dw .data_a8ea1
	dw .data_a8eb2
	dw .data_a8ec3
	dw .data_a8ed4
	dw .data_a8ee5
	dw .data_a8ef6
	dw .data_a8f07
	dw .data_a8f18

.data_a8e7f
	db 4 ; size
	db 0, 0, 8, $0
	db 0, 8, 9, $0
	db 8, 0, 10, $0
	db 8, 8, 11, $0

.data_a8e90
	db 4 ; size
	db 0, 0, 6, $0
	db 8, 0, 7, $0
	db 8, 8, 7, (1 << OAM_X_FLIP)
	db 0, 8, 6, (1 << OAM_X_FLIP)

.data_a8ea1
	db 4 ; size
	db 0, 0, 9, (1 << OAM_X_FLIP)
	db 8, 0, 11, (1 << OAM_X_FLIP)
	db 0, 8, 8, (1 << OAM_X_FLIP)
	db 8, 8, 10, (1 << OAM_X_FLIP)

.data_a8eb2
	db 4 ; size
	db 0, 0, 12, $0
	db 0, 8, 13, $0
	db 8, 0, 14, $0
	db 8, 8, 15, $0

.data_a8ec3
	db 4 ; size
	db 0, 0, 16, $0
	db 0, 8, 17, $0
	db 8, 0, 18, $0
	db 8, 8, 19, $0

.data_a8ed4
	db 4 ; size
	db 0, 0, 2, $0
	db 0, 8, 3, $0
	db 8, 0, 4, $0
	db 8, 8, 5, $0

.data_a8ee5
	db 4 ; size
	db 0, 0, 0, $0
	db 8, 0, 1, $0
	db 0, 8, 0, (1 << OAM_X_FLIP)
	db 8, 8, 1, (1 << OAM_X_FLIP)

.data_a8ef6
	db 4 ; size
	db 0, 0, 3, (1 << OAM_X_FLIP)
	db 8, 0, 5, (1 << OAM_X_FLIP)
	db 0, 8, 2, (1 << OAM_X_FLIP)
	db 8, 8, 4, (1 << OAM_X_FLIP)

.data_a8f07
	db 4 ; size
	db 0, 0, 13, (1 << OAM_X_FLIP)
	db 8, 0, 15, (1 << OAM_X_FLIP)
	db 0, 8, 12, (1 << OAM_X_FLIP)
	db 8, 8, 14, (1 << OAM_X_FLIP)

.data_a8f18
	db 4 ; size
	db 0, 0, 17, (1 << OAM_X_FLIP)
	db 8, 0, 19, (1 << OAM_X_FLIP)
	db 0, 8, 16, (1 << OAM_X_FLIP)
	db 8, 8, 18, (1 << OAM_X_FLIP)
; 0xa8f29

AnimData4:: ; a8f29 (2a:4f29)
	frame_table AnimFrameTable1
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa8f40

AnimFrameTable1:: ; a8f40 (2a:4f40)
	dw .data_a8f54
	dw .data_a8f65
	dw .data_a8f76
	dw .data_a8f87
	dw .data_a8f98
	dw .data_a8fa9
	dw .data_a8fba
	dw .data_a8fcb
	dw .data_a8fdc
	dw .data_a8fed

.data_a8f54
	db 4 ; size
	db 0, 0, 8, (1 << OAM_OBP_NUM)
	db 0, 8, 9, (1 << OAM_OBP_NUM)
	db 8, 0, 10, (1 << OAM_OBP_NUM)
	db 8, 8, 11, (1 << OAM_OBP_NUM)

.data_a8f65
	db 4 ; size
	db 0, 0, 6, (1 << OAM_OBP_NUM)
	db 8, 0, 7, (1 << OAM_OBP_NUM)
	db 8, 8, 7, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 6, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a8f76
	db 4 ; size
	db 0, 0, 9, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 11, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 8, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 10, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a8f87
	db 4 ; size
	db 0, 0, 12, (1 << OAM_OBP_NUM)
	db 0, 8, 13, (1 << OAM_OBP_NUM)
	db 8, 0, 14, (1 << OAM_OBP_NUM)
	db 8, 8, 15, (1 << OAM_OBP_NUM)

.data_a8f98
	db 4 ; size
	db 0, 0, 16, (1 << OAM_OBP_NUM)
	db 0, 8, 17, (1 << OAM_OBP_NUM)
	db 8, 0, 18, (1 << OAM_OBP_NUM)
	db 8, 8, 19, (1 << OAM_OBP_NUM)

.data_a8fa9
	db 4 ; size
	db 0, 0, 2, (1 << OAM_OBP_NUM)
	db 0, 8, 3, (1 << OAM_OBP_NUM)
	db 8, 0, 4, (1 << OAM_OBP_NUM)
	db 8, 8, 5, (1 << OAM_OBP_NUM)

.data_a8fba
	db 4 ; size
	db 0, 0, 0, (1 << OAM_OBP_NUM)
	db 8, 0, 1, (1 << OAM_OBP_NUM)
	db 0, 8, 0, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 1, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a8fcb
	db 4 ; size
	db 0, 0, 3, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 5, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 2, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 4, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a8fdc
	db 4 ; size
	db 0, 0, 13, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 15, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 12, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 14, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a8fed
	db 4 ; size
	db 0, 0, 17, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 19, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 16, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 18, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
; 0xa8ffe

AnimData7:: ; a8ffe (2a:4ffe)
	frame_table AnimFrameTable1
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa900d

AnimData8:: ; a900d (2a:500d)
	frame_table AnimFrameTable2
	frame_data 0, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9018

AnimFrameTable2:: ; a9018 (2a:5018)
	dw .data_a9020
	dw .data_a9031
	dw .data_a9042
	dw .data_a9053

.data_a9020
	db 4 ; size
	db -2, 7, 20, (1 << OAM_OBP_NUM)
	db -2, 15, 21, (1 << OAM_OBP_NUM)
	db 6, 7, 22, (1 << OAM_OBP_NUM)
	db 6, 15, 23, (1 << OAM_OBP_NUM)

.data_a9031
	db 4 ; size
	db 5, 4, 24, (1 << OAM_OBP_NUM)
	db 5, 12, 25, (1 << OAM_OBP_NUM)
	db -3, 4, 13, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db -3, 12, 12, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9042
	db 4 ; size
	db 5, 2, 25, (1 << OAM_OBP_NUM)
	db -3, -6, 13, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db -3, 2, 12, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 5, -6, 26, (1 << OAM_OBP_NUM)

.data_a9053
	db 4 ; size
	db 0, -16, 0, (1 << OAM_OBP_NUM)
	db 8, -16, 1, (1 << OAM_OBP_NUM)
	db 0, -8, 0, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, -8, 1, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
; 0xa9064

AnimData9:: ; a9064 (2a:5064)
	frame_table AnimFrameTable2
	frame_data 1, 9, 0, 0
	frame_data 2, 7, 0, 0
	frame_data 3, 16, 0, 0
	frame_data 3, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xa907b

AnimData10:: ; a907b (2a:507b)
	frame_table AnimFrameTable3
	frame_data 0, 8, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9086

AnimFrameTable3:: ; a9086 (2a:5086)
	dw .data_a908e
	dw .data_a909f
	dw .data_a90b0
	dw .data_a90c1

.data_a908e
	db 4 ; size
	db 0, 0, 6, $0
	db 8, 0, 7, $0
	db 0, 8, 6, (1 << OAM_X_FLIP)
	db 8, 8, 7, (1 << OAM_X_FLIP)

.data_a909f
	db 4 ; size
	db 0, 0, 2, $0
	db 0, 8, 3, $0
	db 8, 0, 4, $0
	db 8, 8, 5, $0

.data_a90b0
	db 4 ; size
	db 0, 0, 0, $0
	db 8, 0, 1, $0
	db 0, 8, 0, (1 << OAM_X_FLIP)
	db 8, 8, 1, (1 << OAM_X_FLIP)

.data_a90c1
	db 4 ; size
	db 0, 0, 3, (1 << OAM_X_FLIP)
	db 8, 0, 5, (1 << OAM_X_FLIP)
	db 0, 8, 2, (1 << OAM_X_FLIP)
	db 8, 8, 4, (1 << OAM_X_FLIP)
; 0xa90d2

AnimData13:: ; a90d2 (2a:50d2)
	frame_table AnimFrameTable3
	frame_data 3, 8, 0, 0
	frame_data 0, 0, 0, 0
; 0xa90dd

AnimData14:: ; a90dd (2a:50dd)
	frame_table AnimFrameTable4
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa90f4

AnimFrameTable4:: ; a90f4 (2a:50f4)
	dw .data_a9108
	dw .data_a9119
	dw .data_a912a
	dw .data_a913b
	dw .data_a914c
	dw .data_a915d
	dw .data_a916e
	dw .data_a917f
	dw .data_a9190
	dw .data_a91a1

.data_a9108
	db 4 ; size
	db 0, 0, 8, $0
	db 0, 8, 9, $0
	db 8, 0, 10, $0
	db 8, 8, 11, $0

.data_a9119
	db 4 ; size
	db 0, 0, 6, $0
	db 8, 0, 7, $0
	db 8, 8, 7, (1 << OAM_X_FLIP)
	db 0, 8, 6, (1 << OAM_X_FLIP)

.data_a912a
	db 4 ; size
	db 0, 0, 9, (1 << OAM_X_FLIP)
	db 8, 0, 11, (1 << OAM_X_FLIP)
	db 0, 8, 8, (1 << OAM_X_FLIP)
	db 8, 8, 10, (1 << OAM_X_FLIP)

.data_a913b
	db 4 ; size
	db 0, 0, 12, $0
	db 0, 8, 13, $0
	db 8, 0, 14, $0
	db 8, 8, 15, $0

.data_a914c
	db 4 ; size
	db 0, 0, 16, $0
	db 0, 8, 17, $0
	db 8, 0, 18, $0
	db 8, 8, 19, $0

.data_a915d
	db 4 ; size
	db 0, 0, 2, $0
	db 0, 8, 3, $0
	db 8, 0, 4, $0
	db 8, 8, 5, $0

.data_a916e
	db 4 ; size
	db 0, 0, 0, $0
	db 8, 0, 1, $0
	db 0, 8, 0, (1 << OAM_X_FLIP)
	db 8, 8, 1, (1 << OAM_X_FLIP)

.data_a917f
	db 4 ; size
	db 0, 0, 3, (1 << OAM_X_FLIP)
	db 8, 0, 5, (1 << OAM_X_FLIP)
	db 0, 8, 2, (1 << OAM_X_FLIP)
	db 8, 8, 4, (1 << OAM_X_FLIP)

.data_a9190
	db 4 ; size
	db 0, 0, 13, (1 << OAM_X_FLIP)
	db 8, 0, 15, (1 << OAM_X_FLIP)
	db 0, 8, 12, (1 << OAM_X_FLIP)
	db 8, 8, 14, (1 << OAM_X_FLIP)

.data_a91a1
	db 4 ; size
	db 0, 0, 17, (1 << OAM_X_FLIP)
	db 8, 0, 19, (1 << OAM_X_FLIP)
	db 0, 8, 16, (1 << OAM_X_FLIP)
	db 8, 8, 18, (1 << OAM_X_FLIP)
; 0xa91b2

AnimData15:: ; a91b2 (2a:51b2)
	frame_table AnimFrameTable4
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa91c1

AnimData16:: ; a91c1 (2a:51c1)
	frame_table AnimFrameTable4
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa91d8

AnimData17:: ; a91d8 (2a:51d8)
	frame_table AnimFrameTable4
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa91e7

AnimData18:: ; a91e7 (2a:51e7)
	frame_table AnimFrameTable5
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa91fe

AnimFrameTable5:: ; a91fe (2a:51fe)
	dw .data_a9212
	dw .data_a9223
	dw .data_a9234
	dw .data_a9245
	dw .data_a9256
	dw .data_a9267
	dw .data_a9278
	dw .data_a9289
	dw .data_a929a
	dw .data_a92ab

.data_a9212
	db 4 ; size
	db 0, 0, 8, %001 | (1 << OAM_OBP_NUM)
	db 0, 8, 9, %001 | (1 << OAM_OBP_NUM)
	db 8, 0, 10, %001 | (1 << OAM_OBP_NUM)
	db 8, 8, 11, %001 | (1 << OAM_OBP_NUM)

.data_a9223
	db 4 ; size
	db 0, 0, 6, %001 | (1 << OAM_OBP_NUM)
	db 8, 0, 7, %001 | (1 << OAM_OBP_NUM)
	db 8, 8, 7, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 6, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9234
	db 4 ; size
	db 0, 0, 9, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 11, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 8, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 10, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9245
	db 4 ; size
	db 0, 0, 12, %001 | (1 << OAM_OBP_NUM)
	db 0, 8, 13, %001 | (1 << OAM_OBP_NUM)
	db 8, 0, 14, %001 | (1 << OAM_OBP_NUM)
	db 8, 8, 15, %001 | (1 << OAM_OBP_NUM)

.data_a9256
	db 4 ; size
	db 0, 0, 16, %001 | (1 << OAM_OBP_NUM)
	db 0, 8, 17, %001 | (1 << OAM_OBP_NUM)
	db 8, 0, 18, %001 | (1 << OAM_OBP_NUM)
	db 8, 8, 19, %001 | (1 << OAM_OBP_NUM)

.data_a9267
	db 4 ; size
	db 0, 0, 2, %001 | (1 << OAM_OBP_NUM)
	db 0, 8, 3, %001 | (1 << OAM_OBP_NUM)
	db 8, 0, 4, %001 | (1 << OAM_OBP_NUM)
	db 8, 8, 5, %001 | (1 << OAM_OBP_NUM)

.data_a9278
	db 4 ; size
	db 0, 0, 0, %001 | (1 << OAM_OBP_NUM)
	db 8, 0, 1, %001 | (1 << OAM_OBP_NUM)
	db 0, 8, 0, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 1, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9289
	db 4 ; size
	db 0, 0, 3, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 5, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 2, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 4, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a929a
	db 4 ; size
	db 0, 0, 13, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 15, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 12, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 14, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a92ab
	db 4 ; size
	db 0, 0, 17, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 19, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 16, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 18, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
; 0xa92bc

AnimData19:: ; a92bc (2a:52bc)
	frame_table AnimFrameTable5
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa92cb

AnimData20:: ; a92cb (2a:52cb)
	frame_table AnimFrameTable5
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa92e2

AnimData21:: ; a92e2 (2a:52e2)
	frame_table AnimFrameTable5
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa92f1

AnimData22:: ; a92f1 (2a:52f1)
	frame_table AnimFrameTable6
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9308

AnimFrameTable6:: ; a9308 (2a:5308)
	dw .data_a931c
	dw .data_a932d
	dw .data_a933e
	dw .data_a934f
	dw .data_a9360
	dw .data_a9371
	dw .data_a9382
	dw .data_a9393
	dw .data_a93a4
	dw .data_a93b5

.data_a931c
	db 4 ; size
	db 0, 0, 8, %010
	db 0, 8, 9, %010
	db 8, 0, 10, %010
	db 8, 8, 11, %010

.data_a932d
	db 4 ; size
	db 0, 0, 6, %010
	db 8, 0, 7, %010
	db 8, 8, 7, %010 | (1 << OAM_X_FLIP)
	db 0, 8, 6, %010 | (1 << OAM_X_FLIP)

.data_a933e
	db 4 ; size
	db 0, 0, 9, %010 | (1 << OAM_X_FLIP)
	db 8, 0, 11, %010 | (1 << OAM_X_FLIP)
	db 0, 8, 8, %010 | (1 << OAM_X_FLIP)
	db 8, 8, 10, %010 | (1 << OAM_X_FLIP)

.data_a934f
	db 4 ; size
	db 0, 0, 12, %010
	db 0, 8, 13, %010
	db 8, 0, 14, %010
	db 8, 8, 15, %010

.data_a9360
	db 4 ; size
	db 0, 0, 16, %010
	db 0, 8, 17, %010
	db 8, 0, 18, %010
	db 8, 8, 19, %010

.data_a9371
	db 4 ; size
	db 0, 0, 2, %010
	db 0, 8, 3, %010
	db 8, 0, 4, %010
	db 8, 8, 5, %010

.data_a9382
	db 4 ; size
	db 0, 0, 0, %010
	db 8, 0, 1, %010
	db 0, 8, 0, %010 | (1 << OAM_X_FLIP)
	db 8, 8, 1, %010 | (1 << OAM_X_FLIP)

.data_a9393
	db 4 ; size
	db 0, 0, 3, %010 | (1 << OAM_X_FLIP)
	db 8, 0, 5, %010 | (1 << OAM_X_FLIP)
	db 0, 8, 2, %010 | (1 << OAM_X_FLIP)
	db 8, 8, 4, %010 | (1 << OAM_X_FLIP)

.data_a93a4
	db 4 ; size
	db 0, 0, 13, %010 | (1 << OAM_X_FLIP)
	db 8, 0, 15, %010 | (1 << OAM_X_FLIP)
	db 0, 8, 12, %010 | (1 << OAM_X_FLIP)
	db 8, 8, 14, %010 | (1 << OAM_X_FLIP)

.data_a93b5
	db 4 ; size
	db 0, 0, 17, %010 | (1 << OAM_X_FLIP)
	db 8, 0, 19, %010 | (1 << OAM_X_FLIP)
	db 0, 8, 16, %010 | (1 << OAM_X_FLIP)
	db 8, 8, 18, %010 | (1 << OAM_X_FLIP)
; 0xa93c6

AnimData23:: ; a93c6 (2a:53c6)
	frame_table AnimFrameTable6
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa93d5

AnimData24:: ; a93d5 (2a:53d5)
	frame_table AnimFrameTable6
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa93ec

AnimData25:: ; a93ec (2a:53ec)
	frame_table AnimFrameTable6
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa93fb

AnimData26:: ; a93fb (2a:53fb)
	frame_table AnimFrameTable7
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9412

AnimFrameTable7:: ; a9412 (2a:5412)
	dw .data_a9426
	dw .data_a9437
	dw .data_a9448
	dw .data_a9459
	dw .data_a946a
	dw .data_a947b
	dw .data_a948c
	dw .data_a949d
	dw .data_a94ae
	dw .data_a94bf

.data_a9426
	db 4 ; size
	db 0, 0, 8, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 9, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 10, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 11, %011 | (1 << OAM_OBP_NUM)

.data_a9437
	db 4 ; size
	db 0, 0, 6, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 7, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 7, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 6, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9448
	db 4 ; size
	db 0, 0, 9, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 11, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 8, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 10, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9459
	db 4 ; size
	db 0, 0, 6, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 13, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 14, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 15, %011 | (1 << OAM_OBP_NUM)

.data_a946a
	db 4 ; size
	db 0, 0, 8, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 17, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 18, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 19, %011 | (1 << OAM_OBP_NUM)

.data_a947b
	db 4 ; size
	db 0, 0, 2, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 3, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 4, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 5, %011 | (1 << OAM_OBP_NUM)

.data_a948c
	db 4 ; size
	db 0, 0, 0, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 1, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 0, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 1, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a949d
	db 4 ; size
	db 0, 0, 3, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 5, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 2, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 4, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a94ae
	db 4 ; size
	db 0, 0, 13, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 15, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 6, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 14, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a94bf
	db 4 ; size
	db 0, 0, 17, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 19, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 8, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 18, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
; 0xa94d0

AnimData27:: ; a94d0 (2a:54d0)
	frame_table AnimFrameTable7
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa94df

AnimData28:: ; a94df (2a:54df)
	frame_table AnimFrameTable7
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa94f6

AnimData29:: ; a94f6 (2a:54f6)
	frame_table AnimFrameTable7
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9505

AnimData30:: ; a9505 (2a:5505)
	frame_table AnimFrameTable8
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa951c

AnimFrameTable8:: ; a951c (2a:551c)
	dw .data_a9530
	dw .data_a9541
	dw .data_a9552
	dw .data_a9563
	dw .data_a9574
	dw .data_a9585
	dw .data_a9596
	dw .data_a95a7
	dw .data_a95b8
	dw .data_a95c9

.data_a9530
	db 4 ; size
	db 0, 0, 8, %100
	db 0, 8, 9, %100
	db 8, 0, 10, %100
	db 8, 8, 11, %100

.data_a9541
	db 4 ; size
	db 0, 0, 6, %100
	db 8, 0, 7, %100
	db 8, 8, 7, %100 | (1 << OAM_X_FLIP)
	db 0, 8, 6, %100 | (1 << OAM_X_FLIP)

.data_a9552
	db 4 ; size
	db 0, 0, 9, %100 | (1 << OAM_X_FLIP)
	db 8, 0, 11, %100 | (1 << OAM_X_FLIP)
	db 0, 8, 8, %100 | (1 << OAM_X_FLIP)
	db 8, 8, 10, %100 | (1 << OAM_X_FLIP)

.data_a9563
	db 4 ; size
	db 0, 0, 12, %100
	db 0, 8, 13, %100
	db 8, 0, 14, %100
	db 8, 8, 15, %100

.data_a9574
	db 4 ; size
	db 0, 0, 16, %100
	db 0, 8, 17, %100
	db 8, 0, 18, %100
	db 8, 8, 19, %100

.data_a9585
	db 4 ; size
	db 0, 0, 2, %100
	db 0, 8, 3, %100
	db 8, 0, 4, %100
	db 8, 8, 5, %100

.data_a9596
	db 4 ; size
	db 0, 0, 0, %100
	db 8, 0, 1, %100
	db 0, 8, 0, %100 | (1 << OAM_X_FLIP)
	db 8, 8, 1, %100 | (1 << OAM_X_FLIP)

.data_a95a7
	db 4 ; size
	db 0, 0, 3, %100 | (1 << OAM_X_FLIP)
	db 8, 0, 5, %100 | (1 << OAM_X_FLIP)
	db 0, 8, 2, %100 | (1 << OAM_X_FLIP)
	db 8, 8, 4, %100 | (1 << OAM_X_FLIP)

.data_a95b8
	db 4 ; size
	db 0, 0, 13, %100 | (1 << OAM_X_FLIP)
	db 8, 0, 15, %100 | (1 << OAM_X_FLIP)
	db 0, 8, 12, %100 | (1 << OAM_X_FLIP)
	db 8, 8, 14, %100 | (1 << OAM_X_FLIP)

.data_a95c9
	db 4 ; size
	db 0, 0, 17, %100 | (1 << OAM_X_FLIP)
	db 8, 0, 19, %100 | (1 << OAM_X_FLIP)
	db 0, 8, 16, %100 | (1 << OAM_X_FLIP)
	db 8, 8, 18, %100 | (1 << OAM_X_FLIP)
; 0xa95da

AnimData31:: ; a95da (2a:55da)
	frame_table AnimFrameTable8
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa95e9

AnimData32:: ; a95e9 (2a:55e9)
	frame_table AnimFrameTable8
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9600

AnimData33:: ; a9600 (2a:5600)
	frame_table AnimFrameTable8
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa960f

AnimData34:: ; a960f (2a:560f)
	frame_table AnimFrameTable9
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9626

AnimFrameTable9:: ; a9626 (2a:5626)
	dw .data_a963a
	dw .data_a964b
	dw .data_a965c
	dw .data_a966d
	dw .data_a967e
	dw .data_a968f
	dw .data_a96a0
	dw .data_a96b1
	dw .data_a96c2
	dw .data_a96d3

.data_a963a
	db 4 ; size
	db 0, 0, 8, %101 | (1 << OAM_OBP_NUM)
	db 0, 8, 9, %101 | (1 << OAM_OBP_NUM)
	db 8, 0, 10, %101 | (1 << OAM_OBP_NUM)
	db 8, 8, 11, %101 | (1 << OAM_OBP_NUM)

.data_a964b
	db 4 ; size
	db 0, 0, 6, %101 | (1 << OAM_OBP_NUM)
	db 8, 0, 7, %101 | (1 << OAM_OBP_NUM)
	db 8, 8, 7, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 6, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a965c
	db 4 ; size
	db 0, 0, 9, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 11, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 8, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 10, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a966d
	db 4 ; size
	db 0, 0, 12, %101 | (1 << OAM_OBP_NUM)
	db 0, 8, 13, %101 | (1 << OAM_OBP_NUM)
	db 8, 0, 14, %101 | (1 << OAM_OBP_NUM)
	db 8, 8, 15, %101 | (1 << OAM_OBP_NUM)

.data_a967e
	db 4 ; size
	db 0, 0, 16, %101 | (1 << OAM_OBP_NUM)
	db 0, 8, 17, %101 | (1 << OAM_OBP_NUM)
	db 8, 0, 18, %101 | (1 << OAM_OBP_NUM)
	db 8, 8, 19, %101 | (1 << OAM_OBP_NUM)

.data_a968f
	db 4 ; size
	db 0, 0, 2, %101 | (1 << OAM_OBP_NUM)
	db 0, 8, 3, %101 | (1 << OAM_OBP_NUM)
	db 8, 0, 4, %101 | (1 << OAM_OBP_NUM)
	db 8, 8, 5, %101 | (1 << OAM_OBP_NUM)

.data_a96a0
	db 4 ; size
	db 0, 0, 0, %101 | (1 << OAM_OBP_NUM)
	db 8, 0, 1, %101 | (1 << OAM_OBP_NUM)
	db 0, 8, 0, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 1, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a96b1
	db 4 ; size
	db 0, 0, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 5, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 2, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a96c2
	db 4 ; size
	db 0, 0, 13, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 15, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 12, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 14, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a96d3
	db 4 ; size
	db 0, 0, 17, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 19, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 16, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 18, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
; 0xa96e4

AnimData35:: ; a96e4 (2a:56e4)
	frame_table AnimFrameTable9
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa96f3

AnimData36:: ; a96f3 (2a:56f3)
	frame_table AnimFrameTable9
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa970a

AnimData37:: ; a970a (2a:570a)
	frame_table AnimFrameTable9
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9719

AnimData38:: ; a9719 (2a:5719)
	frame_table AnimFrameTable10
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9730

AnimFrameTable10:: ; a9730 (2a:5730)
	dw .data_a9744
	dw .data_a9755
	dw .data_a9766
	dw .data_a9777
	dw .data_a9788
	dw .data_a9799
	dw .data_a97aa
	dw .data_a97bb
	dw .data_a97cc
	dw .data_a97dd

.data_a9744
	db 4 ; size
	db 0, 0, 8, %110
	db 0, 8, 9, %110
	db 8, 0, 10, %110
	db 8, 8, 11, %110

.data_a9755
	db 4 ; size
	db 0, 0, 6, %110
	db 8, 0, 7, %110
	db 8, 8, 7, %110 | (1 << OAM_X_FLIP)
	db 0, 8, 6, %110 | (1 << OAM_X_FLIP)

.data_a9766
	db 4 ; size
	db 0, 0, 9, %110 | (1 << OAM_X_FLIP)
	db 8, 0, 11, %110 | (1 << OAM_X_FLIP)
	db 0, 8, 8, %110 | (1 << OAM_X_FLIP)
	db 8, 8, 10, %110 | (1 << OAM_X_FLIP)

.data_a9777
	db 4 ; size
	db 0, 0, 12, %110
	db 0, 8, 13, %110
	db 8, 0, 14, %110
	db 8, 8, 15, %110

.data_a9788
	db 4 ; size
	db 0, 0, 16, %110
	db 0, 8, 17, %110
	db 8, 0, 18, %110
	db 8, 8, 19, %110

.data_a9799
	db 4 ; size
	db 0, 0, 2, %110
	db 0, 8, 3, %110
	db 8, 0, 4, %110
	db 8, 8, 5, %110

.data_a97aa
	db 4 ; size
	db 0, 0, 0, %110
	db 8, 0, 1, %110
	db 0, 8, 0, %110 | (1 << OAM_X_FLIP)
	db 8, 8, 1, %110 | (1 << OAM_X_FLIP)

.data_a97bb
	db 4 ; size
	db 0, 0, 3, %110 | (1 << OAM_X_FLIP)
	db 8, 0, 5, %110 | (1 << OAM_X_FLIP)
	db 0, 8, 2, %110 | (1 << OAM_X_FLIP)
	db 8, 8, 4, %110 | (1 << OAM_X_FLIP)

.data_a97cc
	db 4 ; size
	db 0, 0, 13, %110 | (1 << OAM_X_FLIP)
	db 8, 0, 15, %110 | (1 << OAM_X_FLIP)
	db 0, 8, 12, %110 | (1 << OAM_X_FLIP)
	db 8, 8, 14, %110 | (1 << OAM_X_FLIP)

.data_a97dd
	db 4 ; size
	db 0, 0, 17, %110 | (1 << OAM_X_FLIP)
	db 8, 0, 19, %110 | (1 << OAM_X_FLIP)
	db 0, 8, 16, %110 | (1 << OAM_X_FLIP)
	db 8, 8, 18, %110 | (1 << OAM_X_FLIP)
; 0xa97ee

AnimData39:: ; a97ee (2a:57ee)
	frame_table AnimFrameTable10
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa97fd

AnimData40:: ; a97fd (2a:57fd)
	frame_table AnimFrameTable10
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9814

AnimData41:: ; a9814 (2a:5814)
	frame_table AnimFrameTable10
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9823

AnimData42:: ; a9823 (2a:5823)
	frame_table AnimFrameTable11
	frame_data 0, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 2, 16, 0, 0
	frame_data 1, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa983a

AnimFrameTable11:: ; a983a (2a:583a)
	dw .data_a984e
	dw .data_a985f
	dw .data_a9870
	dw .data_a9881
	dw .data_a9892
	dw .data_a98a3
	dw .data_a98b4
	dw .data_a98c5
	dw .data_a98d6
	dw .data_a98e7

.data_a984e
	db 4 ; size
	db 0, 0, 8, %111 | (1 << OAM_OBP_NUM)
	db 0, 8, 9, %111 | (1 << OAM_OBP_NUM)
	db 8, 0, 10, %111 | (1 << OAM_OBP_NUM)
	db 8, 8, 11, %111 | (1 << OAM_OBP_NUM)

.data_a985f
	db 4 ; size
	db 0, 0, 6, %111 | (1 << OAM_OBP_NUM)
	db 8, 0, 7, %111 | (1 << OAM_OBP_NUM)
	db 8, 8, 7, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 6, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9870
	db 4 ; size
	db 0, 0, 9, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 11, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 8, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 10, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9881
	db 4 ; size
	db 0, 0, 12, %111 | (1 << OAM_OBP_NUM)
	db 0, 8, 13, %111 | (1 << OAM_OBP_NUM)
	db 8, 0, 14, %111 | (1 << OAM_OBP_NUM)
	db 8, 8, 15, %111 | (1 << OAM_OBP_NUM)

.data_a9892
	db 4 ; size
	db 0, 0, 16, %111 | (1 << OAM_OBP_NUM)
	db 0, 8, 17, %111 | (1 << OAM_OBP_NUM)
	db 8, 0, 18, %111 | (1 << OAM_OBP_NUM)
	db 8, 8, 19, %111 | (1 << OAM_OBP_NUM)

.data_a98a3
	db 4 ; size
	db 0, 0, 2, %111 | (1 << OAM_OBP_NUM)
	db 0, 8, 3, %111 | (1 << OAM_OBP_NUM)
	db 8, 0, 4, %111 | (1 << OAM_OBP_NUM)
	db 8, 8, 5, %111 | (1 << OAM_OBP_NUM)

.data_a98b4
	db 4 ; size
	db 0, 0, 0, %111 | (1 << OAM_OBP_NUM)
	db 8, 0, 1, %111 | (1 << OAM_OBP_NUM)
	db 0, 8, 0, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 1, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a98c5
	db 4 ; size
	db 0, 0, 3, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 5, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 2, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 4, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a98d6
	db 4 ; size
	db 0, 0, 13, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 15, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 12, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 14, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a98e7
	db 4 ; size
	db 0, 0, 17, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 19, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 8, 16, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 18, %111 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
; 0xa98f8

AnimData43:: ; a98f8 (2a:58f8)
	frame_table AnimFrameTable11
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9907

AnimData44:: ; a9907 (2a:5907)
	frame_table AnimFrameTable11
	frame_data 5, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 7, 16, 0, 0
	frame_data 6, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa991e

AnimData45:: ; a991e (2a:591e)
	frame_table AnimFrameTable11
	frame_data 8, 16, 0, 0
	frame_data 9, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa992d

AnimData46:: ; a992d (2a:592d)
	frame_table AnimFrameTable12
	frame_data 0, 16, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9938

AnimFrameTable12:: ; a9938 (2a:5938)
	dw .data_a9940
	dw .data_a9951
	dw .data_a9962
	dw .data_a9973

.data_a9940
	db 4 ; size
	db -2, 7, 20, $0
	db -2, 15, 21, $0
	db 6, 7, 22, $0
	db 6, 15, 23, $0

.data_a9951
	db 4 ; size
	db 5, 4, 24, $0
	db 5, 12, 25, $0
	db -3, 4, 13, (1 << OAM_X_FLIP)
	db -3, 12, 12, (1 << OAM_X_FLIP)

.data_a9962
	db 4 ; size
	db 5, 2, 25, $0
	db -3, -6, 13, (1 << OAM_X_FLIP)
	db -3, 2, 12, (1 << OAM_X_FLIP)
	db 5, -6, 26, $0

.data_a9973
	db 4 ; size
	db 0, -16, 0, $0
	db 8, -16, 1, $0
	db 0, -8, 0, (1 << OAM_X_FLIP)
	db 8, -8, 1, (1 << OAM_X_FLIP)
; 0xa9984

AnimData47:: ; a9984 (2a:5984)
	frame_table AnimFrameTable12
	frame_data 1, 9, 0, 0
	frame_data 2, 7, 0, 0
	frame_data 3, 16, 0, 0
	frame_data 3, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xa999b

AnimData48:: ; a999b (2a:599b)
	frame_table AnimFrameTable13
	frame_data 0, 8, 0, 0
	frame_data 0, 0, 0, 0
; 0xa99a6

AnimFrameTable13:: ; a99a6 (2a:59a6)
	dw .data_a99ae
	dw .data_a99bf
	dw .data_a99d0
	dw .data_a99e1

.data_a99ae
	db 4 ; size
	db 0, 0, 6, $0
	db 8, 0, 7, $0
	db 0, 8, 6, (1 << OAM_X_FLIP)
	db 8, 8, 7, (1 << OAM_X_FLIP)

.data_a99bf
	db 4 ; size
	db 0, 0, 2, $0
	db 0, 8, 3, $0
	db 8, 0, 4, $0
	db 8, 8, 5, $0

.data_a99d0
	db 4 ; size
	db 0, 0, 0, $0
	db 8, 0, 1, $0
	db 0, 8, 0, (1 << OAM_X_FLIP)
	db 8, 8, 1, (1 << OAM_X_FLIP)

.data_a99e1
	db 4 ; size
	db 0, 0, 3, (1 << OAM_X_FLIP)
	db 8, 0, 5, (1 << OAM_X_FLIP)
	db 0, 8, 2, (1 << OAM_X_FLIP)
	db 8, 8, 4, (1 << OAM_X_FLIP)
; 0xa99f2

AnimData49:: ; a99f2 (2a:59f2)
	frame_table AnimFrameTable13
	frame_data 1, 8, 0, 0
	frame_data 0, 0, 0, 0
; 0xa99fd

AnimData50:: ; a99fd (2a:59fd)
	frame_table AnimFrameTable13
	frame_data 2, 8, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9a08

AnimData51:: ; a9a08 (2a:5a08)
	frame_table AnimFrameTable13
	frame_data 3, 8, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9a13

AnimData52:: ; a9a13 (2a:5a13)
	frame_table AnimFrameTable14
	frame_data 0, 13, 0, 0
	frame_data 1, 13, 0, 0
	frame_data 2, 13, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9a26

AnimFrameTable14:: ; a9a26 (2a:5a26)
	dw .data_a9a30
	dw .data_a9a39
	dw .data_a9a4a
	dw .data_a9a5b
	dw .data_a9a60

.data_a9a30
	db 2 ; size
	db 0, 0, 0, $0
	db 0, 8, 0, (1 << OAM_X_FLIP)

.data_a9a39
	db 4 ; size
	db 0, 0, 1, $0
	db 8, 0, 2, $0
	db 0, 8, 1, (1 << OAM_X_FLIP)
	db 8, 8, 2, (1 << OAM_X_FLIP)

.data_a9a4a
	db 4 ; size
	db 0, 0, 3, $0
	db 8, 0, 4, $0
	db 0, 8, 3, (1 << OAM_X_FLIP)
	db 8, 8, 4, (1 << OAM_X_FLIP)

.data_a9a5b
	db 1 ; size
	db 4, 4, 5, $0

.data_a9a60
	db 4 ; size
	db 0, 0, 6, $0
	db 8, 0, 7, $0
	db 0, 8, 6, (1 << OAM_X_FLIP)
	db 8, 8, 7, (1 << OAM_X_FLIP)
; 0xa9a71

AnimData53:: ; a9a71 (2a:5a71)
	frame_table AnimFrameTable14
	frame_data 4, 5, 0, 0
	frame_data 3, 10, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9a80

AnimData54:: ; a9a80 (2a:5a80)
	frame_table AnimFrameTable14
	frame_data 4, 4, 0, 0
	frame_data 3, 4, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9a8f

AnimData55:: ; a9a8f (2a:5a8f)
	frame_table AnimFrameTable15
	frame_data 0, 13, 0, 0
	frame_data 1, 13, 0, 0
	frame_data 2, 13, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9aa2

AnimFrameTable15:: ; a9aa2 (2a:5aa2)
	dw .data_a9aac
	dw .data_a9ab5
	dw .data_a9ac6
	dw .data_a9ad7
	dw .data_a9adc

.data_a9aac
	db 2 ; size
	db 0, 0, 0, %110
	db 0, 8, 0, %110 | (1 << OAM_X_FLIP)

.data_a9ab5
	db 4 ; size
	db 0, 0, 1, %110
	db 8, 0, 2, %110
	db 0, 8, 1, %110 | (1 << OAM_X_FLIP)
	db 8, 8, 2, %110 | (1 << OAM_X_FLIP)

.data_a9ac6
	db 4 ; size
	db 0, 0, 3, %110
	db 8, 0, 4, %110
	db 0, 8, 3, %110 | (1 << OAM_X_FLIP)
	db 8, 8, 4, %110 | (1 << OAM_X_FLIP)

.data_a9ad7
	db 1 ; size
	db 4, 4, 5, %100

.data_a9adc
	db 4 ; size
	db 0, 0, 6, %100
	db 8, 0, 7, %100
	db 0, 8, 6, %100 | (1 << OAM_X_FLIP)
	db 8, 8, 7, %100 | (1 << OAM_X_FLIP)
; 0xa9aed

AnimData56:: ; a9aed (2a:5aed)
	frame_table AnimFrameTable15
	frame_data 4, 5, 0, 0
	frame_data 3, 10, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9afc

AnimData57:: ; a9afc (2a:5afc)
	frame_table AnimFrameTable15
	frame_data 4, 4, 0, 0
	frame_data 3, 4, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9b0b

AnimData58:: ; a9b0b (2a:5b0b)
	frame_table AnimFrameTable16
	frame_data 0, 6, 0, 0
	frame_data 1, 6, 0, 0
	frame_data 2, 6, 0, 0
	frame_data 3, 6, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9b22

AnimFrameTable16:: ; a9b22 (2a:5b22)
	dw .data_a9b2a
	dw .data_a9b3b
	dw .data_a9b4c
	dw .data_a9b5d

.data_a9b2a
	db 4 ; size
	db 0, 0, 0, (1 << OAM_OBP_NUM)
	db 0, 8, 1, (1 << OAM_OBP_NUM)
	db 8, 0, 2, (1 << OAM_OBP_NUM)
	db 8, 8, 3, (1 << OAM_OBP_NUM)

.data_a9b3b
	db 4 ; size
	db 0, 8, 0, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 0, 1, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 2, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 3, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9b4c
	db 4 ; size
	db 0, 0, 4, (1 << OAM_OBP_NUM)
	db 0, 8, 5, (1 << OAM_OBP_NUM)
	db 8, 0, 6, (1 << OAM_OBP_NUM)
	db 8, 8, 7, (1 << OAM_OBP_NUM)

.data_a9b5d
	db 4 ; size
	db 0, 8, 4, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 0, 5, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 6, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 7, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
; 0xa9b6e

AnimData59:: ; a9b6e (2a:5b6e)
	frame_table AnimFrameTable17
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 3, 2, 0, 0
	frame_data 2, 2, 0, 0
	frame_data 3, 2, 0, 0
	frame_data 2, 2, 0, 0
	frame_data 3, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 5, 2, 0, 0
	frame_data 4, 2, 0, 0
	frame_data 5, 2, 0, 0
	frame_data 4, 2, 0, 0
	frame_data 5, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9bc5

AnimFrameTable17:: ; a9bc5 (2a:5bc5)
	dw .data_a9bf9
	dw .data_a9c0a
	dw .data_a9c0f
	dw .data_a9c20
	dw .data_a9c25
	dw .data_a9c36
	dw .data_a9c3b
	dw .data_a9c4c
	dw .data_a9c51
	dw .data_a9c62
	dw .data_a9c67
	dw .data_a9c78
	dw .data_a9c7d
	dw .data_a9c86
	dw .data_a9c97
	dw .data_a9c9c
	dw .data_a9cad
	dw .data_a9cb2
	dw .data_a9cc3
	dw .data_a9cc8
	dw .data_a9cd9
	dw .data_a9cde
	dw .data_a9cef
	dw .data_a9cf4
	dw .data_a9d05
	dw .data_a9d0a

.data_a9bf9
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, (1 << OAM_OBP_NUM)

.data_a9c0a
	db 1 ; size
	db 8, 8, 4, (1 << OAM_OBP_NUM)

.data_a9c0f
	db 4 ; size
	db -1, 0, 0, $0
	db -1, 8, 1, $0
	db 7, 0, 2, $0
	db 7, 8, 3, (1 << OAM_OBP_NUM)

.data_a9c20
	db 1 ; size
	db 7, 8, 4, (1 << OAM_OBP_NUM)

.data_a9c25
	db 4 ; size
	db 1, 0, 0, $0
	db 1, 8, 1, $0
	db 9, 0, 2, $0
	db 9, 8, 3, (1 << OAM_OBP_NUM)

.data_a9c36
	db 1 ; size
	db 9, 8, 4, (1 << OAM_OBP_NUM)

.data_a9c3b
	db 4 ; size
	db 0, 8, 0, (1 << OAM_X_FLIP)
	db 0, 0, 1, (1 << OAM_X_FLIP)
	db 8, 8, 2, (1 << OAM_X_FLIP)
	db 8, 0, 3, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9c4c
	db 1 ; size
	db 8, 0, 4, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9c51
	db 4 ; size
	db -1, 8, 0, (1 << OAM_X_FLIP)
	db -1, 0, 1, (1 << OAM_X_FLIP)
	db 7, 8, 2, (1 << OAM_X_FLIP)
	db 7, 0, 3, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9c62
	db 1 ; size
	db 7, 0, 4, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9c67
	db 4 ; size
	db 1, 8, 0, (1 << OAM_X_FLIP)
	db 1, 0, 1, (1 << OAM_X_FLIP)
	db 9, 8, 2, (1 << OAM_X_FLIP)
	db 9, 0, 3, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9c78
	db 1 ; size
	db 9, 0, 4, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9c7d
	db 2 ; size
	db 0, 8, 5, $0
	db 8, 8, 6, $0

.data_a9c86
	db 4 ; size
	db 0, 0, 7, $0
	db 8, 8, 9, $0
	db 8, 0, 8, $0
	db 0, 8, 3, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_a9c97
	db 1 ; size
	db 0, 8, 4, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_a9c9c
	db 4 ; size
	db -1, 0, 7, $0
	db 7, 8, 9, $0
	db 7, 0, 8, $0
	db -1, 8, 3, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_a9cad
	db 1 ; size
	db -1, 8, 4, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_a9cb2
	db 4 ; size
	db 1, 0, 7, $0
	db 9, 8, 9, $0
	db 9, 0, 8, $0
	db 1, 8, 3, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_a9cc3
	db 1 ; size
	db 1, 8, 4, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_a9cc8
	db 4 ; size
	db 0, 8, 7, (1 << OAM_X_FLIP)
	db 8, 0, 9, (1 << OAM_X_FLIP)
	db 8, 8, 8, (1 << OAM_X_FLIP)
	db 0, 0, 3, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_a9cd9
	db 1 ; size
	db 0, 0, 4, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_a9cde
	db 4 ; size
	db -1, 8, 7, (1 << OAM_X_FLIP)
	db 7, 0, 9, (1 << OAM_X_FLIP)
	db 7, 8, 8, (1 << OAM_X_FLIP)
	db -1, 0, 3, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_a9cef
	db 1 ; size
	db -1, 0, 4, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_a9cf4
	db 4 ; size
	db 1, 8, 7, (1 << OAM_X_FLIP)
	db 9, 0, 9, (1 << OAM_X_FLIP)
	db 9, 8, 8, (1 << OAM_X_FLIP)
	db 1, 0, 3, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_a9d05
	db 1 ; size
	db 1, 0, 4, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_a9d0a
	db 2 ; size
	db 0, 0, 5, (1 << OAM_X_FLIP)
	db 8, 0, 6, (1 << OAM_X_FLIP)
; 0xa9d13

AnimData60:: ; a9d13 (2a:5d13)
	frame_table AnimFrameTable17
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 9, 2, 0, 0
	frame_data 8, 2, 0, 0
	frame_data 9, 2, 0, 0
	frame_data 8, 2, 0, 0
	frame_data 9, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 11, 2, 0, 0
	frame_data 10, 2, 0, 0
	frame_data 11, 2, 0, 0
	frame_data 10, 2, 0, 0
	frame_data 11, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9d6a

AnimData61:: ; a9d6a (2a:5d6a)
	frame_table AnimFrameTable17
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9dc1

AnimData62:: ; a9dc1 (2a:5dc1)
	frame_table AnimFrameTable17
	frame_data 13, 2, 0, 0
	frame_data 14, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 14, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 16, 2, 0, 0
	frame_data 15, 2, 0, 0
	frame_data 16, 2, 0, 0
	frame_data 15, 2, 0, 0
	frame_data 16, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 14, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 14, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 18, 2, 0, 0
	frame_data 17, 2, 0, 0
	frame_data 18, 2, 0, 0
	frame_data 17, 2, 0, 0
	frame_data 18, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9e18

AnimData63:: ; a9e18 (2a:5e18)
	frame_table AnimFrameTable17
	frame_data 19, 2, 0, 0
	frame_data 20, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 20, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 22, 2, 0, 0
	frame_data 21, 2, 0, 0
	frame_data 22, 2, 0, 0
	frame_data 21, 2, 0, 0
	frame_data 22, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 20, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 20, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 24, 2, 0, 0
	frame_data 23, 2, 0, 0
	frame_data 24, 2, 0, 0
	frame_data 23, 2, 0, 0
	frame_data 24, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9e6f

AnimData64:: ; a9e6f (2a:5e6f)
	frame_table AnimFrameTable17
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9ec6

AnimData65:: ; a9ec6 (2a:5ec6)
	frame_table AnimFrameTable18
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 3, 2, 0, 0
	frame_data 2, 2, 0, 0
	frame_data 3, 2, 0, 0
	frame_data 2, 2, 0, 0
	frame_data 3, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 0, 2, 0, 0
	frame_data 5, 2, 0, 0
	frame_data 4, 2, 0, 0
	frame_data 5, 2, 0, 0
	frame_data 4, 2, 0, 0
	frame_data 5, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xa9f1d

AnimFrameTable18:: ; a9f1d (2a:5f1d)
	dw .data_a9f51
	dw .data_a9f62
	dw .data_a9f67
	dw .data_a9f78
	dw .data_a9f7d
	dw .data_a9f8e
	dw .data_a9f93
	dw .data_a9fa4
	dw .data_a9fa9
	dw .data_a9fba
	dw .data_a9fbf
	dw .data_a9fd0
	dw .data_a9fd5
	dw .data_a9fde
	dw .data_a9fef
	dw .data_a9ff4
	dw .data_aa005
	dw .data_aa00a
	dw .data_aa01b
	dw .data_aa020
	dw .data_aa031
	dw .data_aa036
	dw .data_aa047
	dw .data_aa04c
	dw .data_aa05d
	dw .data_aa062

.data_a9f51
	db 4 ; size
	db 0, 0, 0, %001 | (1 << OAM_OBP_NUM)
	db 0, 8, 1, %001 | (1 << OAM_OBP_NUM)
	db 8, 0, 2, %001 | (1 << OAM_OBP_NUM)
	db 8, 8, 3, %101 | (1 << OAM_OBP_NUM)

.data_a9f62
	db 1 ; size
	db 8, 8, 4, %101 | (1 << OAM_OBP_NUM)

.data_a9f67
	db 4 ; size
	db -1, 0, 0, %001 | (1 << OAM_OBP_NUM)
	db -1, 8, 1, %001 | (1 << OAM_OBP_NUM)
	db 7, 0, 2, %001 | (1 << OAM_OBP_NUM)
	db 7, 8, 3, %101 | (1 << OAM_OBP_NUM)

.data_a9f78
	db 1 ; size
	db 7, 8, 4, %101 | (1 << OAM_OBP_NUM)

.data_a9f7d
	db 4 ; size
	db 1, 0, 0, %001 | (1 << OAM_OBP_NUM)
	db 1, 8, 1, %001 | (1 << OAM_OBP_NUM)
	db 9, 0, 2, %001 | (1 << OAM_OBP_NUM)
	db 9, 8, 3, %101 | (1 << OAM_OBP_NUM)

.data_a9f8e
	db 1 ; size
	db 9, 8, 4, %101 | (1 << OAM_OBP_NUM)

.data_a9f93
	db 4 ; size
	db 0, 8, 0, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 0, 1, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 2, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9fa4
	db 1 ; size
	db 8, 0, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9fa9
	db 4 ; size
	db -1, 8, 0, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db -1, 0, 1, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 7, 8, 2, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 7, 0, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9fba
	db 1 ; size
	db 7, 0, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9fbf
	db 4 ; size
	db 1, 8, 0, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 1, 0, 1, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 9, 8, 2, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 9, 0, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9fd0
	db 1 ; size
	db 9, 0, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a9fd5
	db 2 ; size
	db 0, 8, 5, %001 | (1 << OAM_OBP_NUM)
	db 8, 8, 6, %001 | (1 << OAM_OBP_NUM)

.data_a9fde
	db 4 ; size
	db 0, 0, 7, %001 | (1 << OAM_OBP_NUM)
	db 8, 8, 9, %001 | (1 << OAM_OBP_NUM)
	db 8, 0, 8, %001 | (1 << OAM_OBP_NUM)
	db 0, 8, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_a9fef
	db 1 ; size
	db 0, 8, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_a9ff4
	db 4 ; size
	db -1, 0, 7, %001 | (1 << OAM_OBP_NUM)
	db 7, 8, 9, %001 | (1 << OAM_OBP_NUM)
	db 7, 0, 8, %001 | (1 << OAM_OBP_NUM)
	db -1, 8, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_aa005
	db 1 ; size
	db -1, 8, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_aa00a
	db 4 ; size
	db 1, 0, 7, %001 | (1 << OAM_OBP_NUM)
	db 9, 8, 9, %001 | (1 << OAM_OBP_NUM)
	db 9, 0, 8, %001 | (1 << OAM_OBP_NUM)
	db 1, 8, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_aa01b
	db 1 ; size
	db 1, 8, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)

.data_aa020
	db 4 ; size
	db 0, 8, 7, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 9, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 8, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 0, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa031
	db 1 ; size
	db 0, 0, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa036
	db 4 ; size
	db -1, 8, 7, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 7, 0, 9, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 7, 8, 8, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db -1, 0, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa047
	db 1 ; size
	db -1, 0, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa04c
	db 4 ; size
	db 1, 8, 7, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 9, 0, 9, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 9, 8, 8, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 1, 0, 3, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa05d
	db 1 ; size
	db 1, 0, 4, %101 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa062
	db 2 ; size
	db 0, 0, 5, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 6, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
; 0xaa06b

AnimData66:: ; aa06b (2a:606b)
	frame_table AnimFrameTable18
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 9, 2, 0, 0
	frame_data 8, 2, 0, 0
	frame_data 9, 2, 0, 0
	frame_data 8, 2, 0, 0
	frame_data 9, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 11, 2, 0, 0
	frame_data 10, 2, 0, 0
	frame_data 11, 2, 0, 0
	frame_data 10, 2, 0, 0
	frame_data 11, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa0c2

AnimData67:: ; aa0c2 (2a:60c2)
	frame_table AnimFrameTable18
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 12, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa119

AnimData68:: ; aa119 (2a:6119)
	frame_table AnimFrameTable18
	frame_data 13, 2, 0, 0
	frame_data 14, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 14, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 16, 2, 0, 0
	frame_data 15, 2, 0, 0
	frame_data 16, 2, 0, 0
	frame_data 15, 2, 0, 0
	frame_data 16, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 14, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 14, 2, 0, 0
	frame_data 13, 2, 0, 0
	frame_data 18, 2, 0, 0
	frame_data 17, 2, 0, 0
	frame_data 18, 2, 0, 0
	frame_data 17, 2, 0, 0
	frame_data 18, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa170

AnimData69:: ; aa170 (2a:6170)
	frame_table AnimFrameTable18
	frame_data 19, 2, 0, 0
	frame_data 20, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 20, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 22, 2, 0, 0
	frame_data 21, 2, 0, 0
	frame_data 22, 2, 0, 0
	frame_data 21, 2, 0, 0
	frame_data 22, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 20, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 20, 2, 0, 0
	frame_data 19, 2, 0, 0
	frame_data 24, 2, 0, 0
	frame_data 23, 2, 0, 0
	frame_data 24, 2, 0, 0
	frame_data 23, 2, 0, 0
	frame_data 24, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa1c7

AnimData70:: ; aa1c7 (2a:61c7)
	frame_table AnimFrameTable18
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 25, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa21e

AnimData71:: ; aa21e (2a:621e)
	frame_table AnimFrameTable19
	frame_data 0, 4, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 0, 4, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 0, 4, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 2, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa24d

AnimFrameTable19:: ; aa24d (2a:624d)
	dw .data_aa253
	dw .data_aa284
	dw .data_aa2c5

.data_aa253
	db 12 ; size
	db -8, -8, 9, $0
	db -16, -8, 8, $0
	db -8, -16, 10, $0
	db -8, 0, 9, (1 << OAM_X_FLIP)
	db -16, 0, 8, (1 << OAM_X_FLIP)
	db -8, 8, 10, (1 << OAM_X_FLIP)
	db 0, -8, 9, (1 << OAM_Y_FLIP)
	db 8, -8, 8, (1 << OAM_Y_FLIP)
	db 0, -16, 10, (1 << OAM_Y_FLIP)
	db 0, 0, 9, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 8, 0, 8, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, 8, 10, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa284
	db 16 ; size
	db -16, -16, 4, $0
	db -16, -8, 5, $0
	db -8, -8, 7, $0
	db -8, -16, 6, $0
	db -16, 8, 4, (1 << OAM_X_FLIP)
	db -16, 0, 5, (1 << OAM_X_FLIP)
	db -8, 0, 7, (1 << OAM_X_FLIP)
	db -8, 8, 6, (1 << OAM_X_FLIP)
	db 8, -16, 4, (1 << OAM_Y_FLIP)
	db 8, -8, 5, (1 << OAM_Y_FLIP)
	db 0, -8, 7, (1 << OAM_Y_FLIP)
	db 0, -16, 6, (1 << OAM_Y_FLIP)
	db 8, 8, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 8, 0, 5, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, 0, 7, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, 8, 6, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa2c5
	db 16 ; size
	db -16, -16, 0, $0
	db -16, -8, 1, $0
	db -8, -16, 2, $0
	db -8, -8, 3, $0
	db -16, 8, 0, (1 << OAM_X_FLIP)
	db -16, 0, 1, (1 << OAM_X_FLIP)
	db -8, 8, 2, (1 << OAM_X_FLIP)
	db -8, 0, 3, (1 << OAM_X_FLIP)
	db 8, 8, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 8, 0, 1, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, 8, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, 0, 3, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 8, -16, 0, (1 << OAM_Y_FLIP)
	db 8, -8, 1, (1 << OAM_Y_FLIP)
	db 0, -16, 2, (1 << OAM_Y_FLIP)
	db 0, -8, 3, (1 << OAM_Y_FLIP)
; 0xaa306

AnimData72:: ; aa306 (2a:6306)
	frame_table AnimFrameTable20
	frame_data 0, 7, 0, 0
	frame_data 1, 7, 0, 0
	frame_data 0, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa321

AnimFrameTable20:: ; aa321 (2a:6321)
	dw .data_aa325
	dw .data_aa386

.data_aa325
	db 24 ; size
	db -24, -32, 0, $0
	db -24, -24, 1, $0
	db -24, -16, 2, $0
	db -24, 24, 3, $0
	db -16, 24, 4, $0
	db -8, 24, 5, $0
	db -24, -8, 1, $0
	db -24, 0, 2, $0
	db -24, 8, 1, $0
	db -24, 16, 2, $0
	db 0, 24, 4, $0
	db 8, 24, 5, $0
	db 16, 24, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 16, 16, 1, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 16, 8, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 16, -32, 3, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 16, 0, 1, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 16, -8, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 16, -16, 1, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 16, -24, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 8, -32, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, -32, 5, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, -32, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, -32, 5, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa386
	db 24 ; size
	db -24, 24, 0, (1 << OAM_X_FLIP)
	db -24, 16, 1, (1 << OAM_X_FLIP)
	db -24, 8, 2, (1 << OAM_X_FLIP)
	db -24, -32, 3, (1 << OAM_X_FLIP)
	db -16, -32, 4, (1 << OAM_X_FLIP)
	db -8, -32, 5, (1 << OAM_X_FLIP)
	db -24, 0, 1, (1 << OAM_X_FLIP)
	db -24, -8, 2, (1 << OAM_X_FLIP)
	db -24, -16, 1, (1 << OAM_X_FLIP)
	db -24, -24, 2, (1 << OAM_X_FLIP)
	db 0, -32, 4, (1 << OAM_X_FLIP)
	db 8, -32, 5, (1 << OAM_X_FLIP)
	db 16, -32, 0, (1 << OAM_Y_FLIP)
	db 16, -24, 1, (1 << OAM_Y_FLIP)
	db 16, -16, 2, (1 << OAM_Y_FLIP)
	db 16, 24, 3, (1 << OAM_Y_FLIP)
	db 16, -8, 1, (1 << OAM_Y_FLIP)
	db 16, 0, 2, (1 << OAM_Y_FLIP)
	db 16, 8, 1, (1 << OAM_Y_FLIP)
	db 16, 16, 2, (1 << OAM_Y_FLIP)
	db 8, 24, 4, (1 << OAM_Y_FLIP)
	db 0, 24, 5, (1 << OAM_Y_FLIP)
	db -8, 24, 4, (1 << OAM_Y_FLIP)
	db -16, 24, 5, (1 << OAM_Y_FLIP)
; 0xaa3e7

AnimData73:: ; aa3e7 (2a:63e7)
	frame_table AnimFrameTable21
	frame_data 0, 10, 0, 0
	frame_data 1, 14, 0, 0
	frame_data 2, 10, 0, 0
	frame_data 3, 7, 0, 0
	frame_data 4, 7, 0, 0
	frame_data 3, 7, 0, -1
	frame_data 4, 7, 0, 0
	frame_data 3, 7, 0, 1
	frame_data 4, 7, 0, 0
	frame_data 3, 7, 0, -1
	frame_data 4, 7, 0, 0
	frame_data 4, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa41e

AnimFrameTable21:: ; aa41e (2a:641e)
	dw .data_aa428
	dw .data_aa449
	dw .data_aa46a
	dw .data_aa48b
	dw .data_aa4b0

.data_aa428
	db 8 ; size
	db 0, 8, 2, (1 << OAM_X_FLIP)
	db 0, 0, 2, $0
	db -8, 0, 2, (1 << OAM_Y_FLIP)
	db -8, 8, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, -16, 2, $0
	db 0, -8, 2, (1 << OAM_X_FLIP)
	db -8, -8, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, -16, 2, (1 << OAM_Y_FLIP)

.data_aa449
	db 8 ; size
	db -7, -8, 0, (1 << OAM_X_FLIP)
	db -7, -16, 1, (1 << OAM_X_FLIP)
	db 1, -8, 2, (1 << OAM_X_FLIP)
	db 1, -16, 3, (1 << OAM_X_FLIP)
	db -7, 0, 0, $0
	db -7, 8, 1, $0
	db 1, 0, 2, $0
	db 1, 8, 3, $0

.data_aa46a
	db 8 ; size
	db -6, -16, 1, (1 << OAM_X_FLIP)
	db -6, -8, 1, $0
	db 2, -16, 5, (1 << OAM_X_FLIP)
	db 2, -8, 4, (1 << OAM_X_FLIP)
	db -6, 8, 1, $0
	db -6, 0, 1, (1 << OAM_X_FLIP)
	db 2, 8, 5, $0
	db 2, 0, 4, $0

.data_aa48b
	db 9 ; size
	db -5, -16, 1, (1 << OAM_X_FLIP)
	db 3, -16, 5, (1 << OAM_X_FLIP)
	db -5, -8, 1, $0
	db 3, -8, 5, $0
	db -5, 8, 1, $0
	db 3, 8, 5, $0
	db -5, 0, 1, (1 << OAM_X_FLIP)
	db 3, 0, 5, (1 << OAM_X_FLIP)
	db -14, 11, 6, $0

.data_aa4b0
	db 9 ; size
	db -5, -16, 1, (1 << OAM_X_FLIP)
	db 3, -16, 5, (1 << OAM_X_FLIP)
	db -5, -8, 1, $0
	db 3, -8, 5, $0
	db -5, 8, 1, $0
	db 3, 8, 5, $0
	db -5, 0, 1, (1 << OAM_X_FLIP)
	db 3, 0, 5, (1 << OAM_X_FLIP)
	db -18, 15, 7, $0
; 0xaa4d5

AnimData74:: ; aa4d5 (2a:64d5)
	frame_table AnimFrameTable22
	frame_data 0, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 3, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 5, 8, 0, 0
	frame_data 6, 8, 0, 0
	frame_data 7, 8, 0, 0
	frame_data 7, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa500

AnimFrameTable22:: ; aa500 (2a:6500)
	dw .data_aa510
	dw .data_aa531
	dw .data_aa552
	dw .data_aa573
	dw .data_aa594
	dw .data_aa5b5
	dw .data_aa5d6
	dw .data_aa5f7

.data_aa510
	db 8 ; size
	db -8, -8, 0, $0
	db -8, 0, 0, (1 << OAM_X_FLIP)
	db -24, -8, 0, $0
	db -24, 0, 0, (1 << OAM_X_FLIP)
	db -16, -8, 1, $0
	db 0, -8, 1, $0
	db -16, 0, 1, (1 << OAM_X_FLIP)
	db 0, 0, 1, (1 << OAM_X_FLIP)

.data_aa531
	db 8 ; size
	db -16, -24, 0, $0
	db -16, -16, 0, (1 << OAM_X_FLIP)
	db -16, 8, 0, $0
	db -16, 16, 0, (1 << OAM_X_FLIP)
	db -8, -24, 1, $0
	db -8, -16, 1, (1 << OAM_X_FLIP)
	db -8, 8, 1, $0
	db -8, 16, 1, (1 << OAM_X_FLIP)

.data_aa552
	db 8 ; size
	db -24, -32, 0, $0
	db -24, -24, 0, (1 << OAM_X_FLIP)
	db -8, 16, 0, $0
	db -8, 24, 0, (1 << OAM_X_FLIP)
	db -16, -32, 1, $0
	db -16, -24, 1, (1 << OAM_X_FLIP)
	db 0, 16, 1, $0
	db 0, 24, 1, (1 << OAM_X_FLIP)

.data_aa573
	db 8 ; size
	db -32, -24, 0, $0
	db -32, -16, 0, (1 << OAM_X_FLIP)
	db 0, 8, 0, $0
	db 0, 16, 0, (1 << OAM_X_FLIP)
	db -24, -24, 1, $0
	db 8, 8, 1, $0
	db -24, -16, 1, (1 << OAM_X_FLIP)
	db 8, 16, 1, (1 << OAM_X_FLIP)

.data_aa594
	db 8 ; size
	db -24, -8, 0, $0
	db -24, 0, 0, (1 << OAM_X_FLIP)
	db -8, -8, 0, $0
	db -8, 0, 0, (1 << OAM_X_FLIP)
	db -16, -8, 1, $0
	db 0, -8, 1, $0
	db -16, 0, 1, (1 << OAM_X_FLIP)
	db 0, 0, 1, (1 << OAM_X_FLIP)

.data_aa5b5
	db 8 ; size
	db -16, 8, 0, $0
	db -16, 16, 0, (1 << OAM_X_FLIP)
	db -16, -24, 0, $0
	db -16, -16, 0, (1 << OAM_X_FLIP)
	db -8, -24, 1, $0
	db -8, -16, 1, (1 << OAM_X_FLIP)
	db -8, 8, 1, $0
	db -8, 16, 1, (1 << OAM_X_FLIP)

.data_aa5d6
	db 8 ; size
	db -8, 16, 0, $0
	db -8, 24, 0, (1 << OAM_X_FLIP)
	db -24, -32, 0, $0
	db -24, -24, 0, (1 << OAM_X_FLIP)
	db -16, -32, 1, $0
	db -16, -24, 1, (1 << OAM_X_FLIP)
	db 0, 16, 1, $0
	db 0, 24, 1, (1 << OAM_X_FLIP)

.data_aa5f7
	db 8 ; size
	db 0, 8, 0, $0
	db 0, 16, 0, (1 << OAM_X_FLIP)
	db -32, -24, 0, $0
	db -32, -16, 0, (1 << OAM_X_FLIP)
	db -24, -24, 1, $0
	db -24, -16, 1, (1 << OAM_X_FLIP)
	db 8, 8, 1, $0
	db 8, 16, 1, (1 << OAM_X_FLIP)
; 0xaa618

AnimData75:: ; aa618 (2a:6618)
	frame_table AnimFrameTable23
	frame_data 0, 10, 1, 1
	frame_data 1, 10, 0, 0
	frame_data 2, 10, 0, 0
	frame_data 3, 32, 0, 0
	frame_data 3, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa633

AnimFrameTable23:: ; aa633 (2a:6633)
	dw .data_aa63b
	dw .data_aa64c
	dw .data_aa675
	dw .data_aa6b6

.data_aa63b
	db 4 ; size
	db -24, -8, 3, $0
	db -24, 24, 3, $0
	db -24, -32, 1, $0
	db -24, 8, 1, $0

.data_aa64c
	db 10 ; size
	db -16, -8, 3, $0
	db -24, -8, 2, $0
	db -24, 8, 0, $0
	db -16, 24, 3, $0
	db -24, 24, 2, $0
	db -16, -32, 1, $0
	db -24, -32, 0, $0
	db -24, -16, 1, (1 << OAM_X_FLIP)
	db -16, 8, 1, $0
	db -24, 0, 3, $0

.data_aa675
	db 16 ; size
	db -8, -8, 3, $0
	db -16, 8, 0, $0
	db -16, -8, 2, $0
	db -24, 8, 0, $0
	db -24, -8, 2, $0
	db -8, 24, 3, $0
	db -16, 24, 2, $0
	db -24, 24, 2, $0
	db -24, 0, 2, $0
	db -24, -16, 0, (1 << OAM_X_FLIP)
	db -8, -32, 1, $0
	db -16, -32, 0, $0
	db -24, -32, 0, $0
	db -16, -16, 1, (1 << OAM_X_FLIP)
	db -8, 8, 1, $0
	db -16, 0, 3, $0

.data_aa6b6
	db 22 ; size
	db 0, -8, 3, $0
	db -8, 8, 0, $0
	db -8, -8, 2, $0
	db -16, 8, 0, $0
	db -16, -8, 2, $0
	db 0, 24, 3, $0
	db -8, 24, 2, $0
	db -16, 24, 2, $0
	db -24, 8, 0, $0
	db -24, -8, 2, $0
	db -24, 24, 2, $0
	db -16, 0, 2, $0
	db -24, 0, 2, $0
	db -24, -16, 0, (1 << OAM_X_FLIP)
	db -16, -16, 0, (1 << OAM_X_FLIP)
	db 0, -32, 1, $0
	db -8, -32, 0, $0
	db -16, -32, 0, $0
	db -24, -32, 0, $0
	db -8, -16, 1, (1 << OAM_X_FLIP)
	db 0, 8, 1, $0
	db -8, 0, 3, $0
; 0xaa70f

AnimData76:: ; aa70f (2a:670f)
	frame_table AnimFrameTable24
	frame_data 0, 5, 0, 0
	frame_data 1, 5, 0, 0
	frame_data 0, 5, 0, 0
	frame_data 1, 5, 0, 0
	frame_data -1, 16, 0, 0
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa72e

AnimFrameTable24:: ; aa72e (2a:672e)
	dw .data_aa73c
	dw .data_aa74d
	dw .data_aa772
	dw .data_aa7a7
	dw .data_aa7dc
	dw .data_aa821
	dw .data_aa866

.data_aa73c
	db 4 ; size
	db -8, -8, 0, $0
	db -8, 0, 1, $0
	db 0, -8, 2, $0
	db 0, 0, 3, $0

.data_aa74d
	db 9 ; size
	db -12, -12, 4, $0
	db -12, -4, 5, $0
	db -4, -12, 6, $0
	db -4, -4, 7, $0
	db -12, 4, 4, (1 << OAM_X_FLIP)
	db -4, 4, 6, (1 << OAM_X_FLIP)
	db 4, -12, 4, (1 << OAM_Y_FLIP)
	db 4, -4, 5, (1 << OAM_Y_FLIP)
	db 4, 4, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa772
	db 13 ; size
	db -8, 8, 0, $0
	db -8, 16, 1, $0
	db 0, 8, 2, $0
	db 0, 16, 3, $0
	db -20, -28, 4, $0
	db -20, -20, 5, $0
	db -12, -28, 6, $0
	db -12, -20, 7, $0
	db -20, -12, 4, (1 << OAM_X_FLIP)
	db -12, -12, 6, (1 << OAM_X_FLIP)
	db -4, -28, 4, (1 << OAM_Y_FLIP)
	db -4, -20, 5, (1 << OAM_Y_FLIP)
	db -4, -12, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa7a7
	db 13 ; size
	db 0, -12, 0, $0
	db 0, -4, 1, $0
	db 8, -12, 2, $0
	db 8, -4, 3, $0
	db -12, 4, 4, $0
	db -12, 12, 5, $0
	db -4, 4, 6, $0
	db -4, 12, 7, $0
	db -12, 20, 4, (1 << OAM_X_FLIP)
	db -4, 20, 6, (1 << OAM_X_FLIP)
	db 4, 4, 4, (1 << OAM_Y_FLIP)
	db 4, 12, 5, (1 << OAM_Y_FLIP)
	db 4, 20, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa7dc
	db 17 ; size
	db 4, 8, 0, $0
	db 4, 16, 1, $0
	db 12, 8, 2, $0
	db 12, 16, 3, $0
	db -24, -32, 4, $0
	db -24, -24, 5, $0
	db -16, -32, 6, $0
	db -16, -24, 7, $0
	db -24, -16, 4, (1 << OAM_X_FLIP)
	db -16, -16, 6, (1 << OAM_X_FLIP)
	db -8, -32, 4, (1 << OAM_Y_FLIP)
	db -8, -24, 5, (1 << OAM_Y_FLIP)
	db -8, -16, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -29, -11, 8, $0
	db -29, -37, 8, (1 << OAM_X_FLIP)
	db -3, -11, 8, (1 << OAM_Y_FLIP)
	db -3, -37, 8, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa821
	db 17 ; size
	db 0, -24, 0, $0
	db 0, -16, 1, $0
	db 8, -24, 2, $0
	db 8, -16, 3, $0
	db 0, 4, 4, $0
	db 0, 12, 5, $0
	db 8, 4, 6, $0
	db 8, 12, 7, $0
	db 0, 20, 4, (1 << OAM_X_FLIP)
	db 8, 20, 6, (1 << OAM_X_FLIP)
	db 16, 4, 4, (1 << OAM_Y_FLIP)
	db 16, 12, 5, (1 << OAM_Y_FLIP)
	db 16, 20, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -5, 25, 8, $0
	db -5, -1, 8, (1 << OAM_X_FLIP)
	db 21, 25, 8, (1 << OAM_Y_FLIP)
	db 21, -1, 8, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_aa866
	db 13 ; size
	db -4, -28, 4, $0
	db -4, -20, 5, $0
	db 4, -28, 6, $0
	db 4, -20, 7, $0
	db -4, -12, 4, (1 << OAM_X_FLIP)
	db 4, -12, 6, (1 << OAM_X_FLIP)
	db 12, -28, 4, (1 << OAM_Y_FLIP)
	db 12, -20, 5, (1 << OAM_Y_FLIP)
	db 12, -12, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -9, -7, 8, $0
	db -9, -33, 8, (1 << OAM_X_FLIP)
	db 17, -7, 8, (1 << OAM_Y_FLIP)
	db 17, -33, 8, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
; 0xaa89b

AnimData77:: ; aa89b (2a:689b)
	frame_table AnimFrameTable24
	frame_data 0, 5, -16, -8
	frame_data 2, 5, 16, 8
	frame_data 3, 5, 0, 0
	frame_data 1, 5, -4, 8
	frame_data -1, 16, 0, 0
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa8ba

AnimData78:: ; aa8ba (2a:68ba)
	frame_table AnimFrameTable24
	frame_data 0, 5, -20, -12
	frame_data 4, 5, 20, 12
	frame_data 5, 5, 0, 0
	frame_data 6, 5, 0, 0
	frame_data 1, 5, 8, -8
	frame_data 6, 5, 16, -8
	frame_data -1, 16, 0, 0
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa8e1

AnimData79:: ; aa8e1 (2a:68e1)
	frame_table AnimFrameTable25
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, 1, 0, 0
	frame_data 0, 1, 0, -1
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaa968

AnimFrameTable25:: ; aa968 (2a:6968)
	dw .data_aa982
	dw .data_aa987
	dw .data_aa98c
	dw .data_aa991
	dw .data_aa996
	dw .data_aa99b
	dw .data_aa9a0
	dw .data_aa9a5
	dw .data_aa9aa
	dw .data_aa9af
	dw .data_aa9b4
	dw .data_aa9c5
	dw .data_aa9d2

.data_aa982
	db 1 ; size
	db 0, 0, 0, $0

.data_aa987
	db 1 ; size
	db 0, 0, 1, $0

.data_aa98c
	db 1 ; size
	db 0, 0, 2, $0

.data_aa991
	db 1 ; size
	db 0, 0, 3, $0

.data_aa996
	db 1 ; size
	db 0, 0, 4, $0

.data_aa99b
	db 1 ; size
	db 0, 0, 5, $0

.data_aa9a0
	db 1 ; size
	db 0, 0, 6, $0

.data_aa9a5
	db 1 ; size
	db 0, 0, 7, $0

.data_aa9aa
	db 1 ; size
	db 0, 0, 8, $0

.data_aa9af
	db 1 ; size
	db 0, 0, 9, $0

.data_aa9b4
	db 4 ; size
	db 1, -3, 14, $0
	db 1, 5, 15, $0
	db 1, 13, 16, $0
	db 1, 21, 17, $0

.data_aa9c5
	db 3 ; size
	db 1, -3, 11, $0
	db 1, 5, 12, $0
	db 1, 13, 13, $0

.data_aa9d2
	db 1 ; size
	db 0, 0, 10, $0
; 0xaa9d7

AnimData80:: ; aa9d7 (2a:69d7)
	frame_table AnimFrameTable25
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, 1, 0, 0
	frame_data 1, 1, 0, -1
	frame_data 1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaaa5e

AnimData81:: ; aaa5e (2a:6a5e)
	frame_table AnimFrameTable25
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, 1, 0, 0
	frame_data 2, 1, 0, -1
	frame_data 2, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaaae5

AnimData82:: ; aaae5 (2a:6ae5)
	frame_table AnimFrameTable25
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, 1, 0, 0
	frame_data 3, 1, 0, -1
	frame_data 3, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaab6c

AnimData83:: ; aab6c (2a:6b6c)
	frame_table AnimFrameTable25
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, 1, 0, 0
	frame_data 4, 1, 0, -1
	frame_data 4, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaabf3

AnimData84:: ; aabf3 (2a:6bf3)
	frame_table AnimFrameTable25
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, 1, 0, 0
	frame_data 5, 1, 0, -1
	frame_data 5, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaac7a

AnimData85:: ; aac7a (2a:6c7a)
	frame_table AnimFrameTable25
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, 1, 0, 0
	frame_data 6, 1, 0, -1
	frame_data 6, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaad01

AnimData86:: ; aad01 (2a:6d01)
	frame_table AnimFrameTable25
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, 1, 0, 0
	frame_data 7, 1, 0, -1
	frame_data 7, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaad88

AnimData87:: ; aad88 (2a:6d88)
	frame_table AnimFrameTable25
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, 1, 0, 0
	frame_data 8, 1, 0, -1
	frame_data 8, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaae0f

AnimData88:: ; aae0f (2a:6e0f)
	frame_table AnimFrameTable25
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, 1, 0, 0
	frame_data 9, 1, 0, -1
	frame_data 9, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaae96

AnimData89:: ; aae96 (2a:6e96)
	frame_table AnimFrameTable25
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, 1, 0, 0
	frame_data 10, 1, 0, -1
	frame_data 10, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaaf1d

AnimData90:: ; aaf1d (2a:6f1d)
	frame_table AnimFrameTable25
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, 1, 0, 0
	frame_data 11, 1, 0, -1
	frame_data 11, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaafa4

AnimData91:: ; aafa4 (2a:6fa4)
	frame_table AnimFrameTable25
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, 1, 0, 0
	frame_data 12, 1, 0, -1
	frame_data 12, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xab02b

AnimData92:: ; ab02b (2a:702b)
	frame_table AnimFrameTable26
	frame_data 0, 2, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 1, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 2, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 3, 2, 0, 0
	frame_data 4, 2, 0, 0
	frame_data 5, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 6, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xab066

AnimFrameTable26:: ; ab066 (2a:7066)
	dw .data_ab074
	dw .data_ab07d
	dw .data_ab09a
	dw .data_ab0b7
	dw .data_ab0c8
	dw .data_ab0d9
	dw .data_ab0ea

.data_ab074
	db 2 ; size
	db -32, -5, 0, $0
	db -24, -4, 1, (1 << OAM_X_FLIP)

.data_ab07d
	db 7 ; size
	db -32, -3, 0, (1 << OAM_X_FLIP)
	db -24, -4, 1, (1 << OAM_X_FLIP)
	db -16, -2, 2, (1 << OAM_X_FLIP)
	db -8, 0, 3, (1 << OAM_X_FLIP)
	db -8, -8, 4, (1 << OAM_X_FLIP)
	db 0, 0, 5, (1 << OAM_X_FLIP)
	db 0, -8, 6, (1 << OAM_X_FLIP)

.data_ab09a
	db 7 ; size
	db -32, -5, 0, $0
	db -24, -4, 1, $0
	db -16, -6, 2, $0
	db -8, -8, 3, $0
	db -8, 0, 4, $0
	db 0, -8, 5, $0
	db 0, 0, 6, $0

.data_ab0b7
	db 4 ; size
	db -12, -14, 8, $0
	db 4, 6, 8, $0
	db 4, -14, 7, $0
	db -12, 6, 7, $0

.data_ab0c8
	db 4 ; size
	db -16, 10, 8, (1 << OAM_X_FLIP)
	db 8, -18, 8, (1 << OAM_X_FLIP)
	db 8, 10, 7, (1 << OAM_X_FLIP)
	db -16, -18, 7, (1 << OAM_X_FLIP)

.data_ab0d9
	db 4 ; size
	db -18, -22, 8, $0
	db 10, 14, 8, $0
	db 10, -22, 7, $0
	db -18, 14, 7, $0

.data_ab0ea
	db 4 ; size
	db -22, 18, 8, (1 << OAM_X_FLIP)
	db 14, -26, 8, (1 << OAM_X_FLIP)
	db 14, 18, 7, (1 << OAM_X_FLIP)
	db -22, -26, 7, (1 << OAM_X_FLIP)
; 0xab0fb

AnimData93:: ; ab0fb (2a:70fb)
	frame_table AnimFrameTable26
	frame_data 8, 8, 0, 0
	frame_data 0, 0, 0, 0
; 0xab106

AnimData94:: ; ab106 (2a:7106)
	frame_table AnimFrameTable27
	frame_data 0, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 1, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 2, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 3, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 4, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 5, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xab141

AnimFrameTable27:: ; ab141 (2a:7141)
	dw .data_ab14d
	dw .data_ab17a
	dw .data_ab1c7
	dw .data_ab1f4
	dw .data_ab241
	dw .data_ab26e

.data_ab14d
	db 11 ; size
	db -40, -8, 0, $0
	db -40, 0, 1, $0
	db -32, -12, 2, $0
	db -32, -4, 3, $0
	db -24, -20, 4, $0
	db -24, -12, 5, $0
	db -24, -4, 6, $0
	db -16, -4, 9, $0
	db -16, 4, 10, $0
	db -8, 0, 13, $0
	db -8, 8, 14, $0

.data_ab17a
	db 19 ; size
	db -40, -8, 0, $0
	db -40, 0, 1, $0
	db -32, -12, 2, $0
	db -32, -4, 3, $0
	db -24, -20, 4, $0
	db -24, -12, 5, $0
	db -24, -4, 6, $0
	db -16, -4, 9, $0
	db -16, 4, 10, $0
	db -8, 0, 13, $0
	db -8, 8, 14, $0
	db -16, -24, 7, $0
	db -16, -16, 8, $0
	db -8, -24, 11, $0
	db -8, -16, 12, $0
	db 0, 8, 15, $0
	db 0, 16, 16, $0
	db 8, 16, 11, (1 << OAM_X_FLIP)
	db 8, 8, 12, (1 << OAM_X_FLIP)

.data_ab1c7
	db 11 ; size
	db -40, 0, 0, (1 << OAM_X_FLIP)
	db -40, -8, 1, (1 << OAM_X_FLIP)
	db -32, 4, 2, (1 << OAM_X_FLIP)
	db -32, -4, 3, (1 << OAM_X_FLIP)
	db -24, 12, 4, (1 << OAM_X_FLIP)
	db -24, 4, 5, (1 << OAM_X_FLIP)
	db -24, -4, 6, (1 << OAM_X_FLIP)
	db -16, -4, 9, (1 << OAM_X_FLIP)
	db -16, -12, 10, (1 << OAM_X_FLIP)
	db -8, -8, 13, (1 << OAM_X_FLIP)
	db -8, -16, 14, (1 << OAM_X_FLIP)

.data_ab1f4
	db 19 ; size
	db -40, 0, 0, (1 << OAM_X_FLIP)
	db -40, -8, 1, (1 << OAM_X_FLIP)
	db -32, 4, 2, (1 << OAM_X_FLIP)
	db -32, -4, 3, (1 << OAM_X_FLIP)
	db -24, 12, 4, (1 << OAM_X_FLIP)
	db -24, 4, 5, (1 << OAM_X_FLIP)
	db -24, -4, 6, (1 << OAM_X_FLIP)
	db -16, -4, 9, (1 << OAM_X_FLIP)
	db -16, -12, 10, (1 << OAM_X_FLIP)
	db -8, -8, 13, (1 << OAM_X_FLIP)
	db -8, -16, 14, (1 << OAM_X_FLIP)
	db -16, 16, 7, (1 << OAM_X_FLIP)
	db -16, 8, 8, (1 << OAM_X_FLIP)
	db -8, 16, 11, (1 << OAM_X_FLIP)
	db -8, 8, 12, (1 << OAM_X_FLIP)
	db 0, -16, 15, (1 << OAM_X_FLIP)
	db 0, -24, 16, (1 << OAM_X_FLIP)
	db 8, -24, 11, $0
	db 8, -16, 12, $0

.data_ab241
	db 11 ; size
	db -40, -8, 0, $0
	db -40, 0, 1, $0
	db -32, -12, 2, $0
	db -32, -4, 3, $0
	db -24, -4, 4, (1 << OAM_X_FLIP)
	db -24, -12, 5, (1 << OAM_X_FLIP)
	db -24, -20, 6, (1 << OAM_X_FLIP)
	db -16, -20, 9, (1 << OAM_X_FLIP)
	db -16, -28, 10, (1 << OAM_X_FLIP)
	db -8, -32, 13, $0
	db -8, -24, 14, $0

.data_ab26e
	db 19 ; size
	db -40, -8, 0, $0
	db -40, 0, 1, $0
	db -32, -12, 2, $0
	db -32, -4, 3, $0
	db -24, -4, 4, (1 << OAM_X_FLIP)
	db -24, -12, 5, (1 << OAM_X_FLIP)
	db -24, -20, 6, (1 << OAM_X_FLIP)
	db -16, -20, 9, (1 << OAM_X_FLIP)
	db -16, -28, 10, (1 << OAM_X_FLIP)
	db -8, -32, 13, $0
	db -8, -24, 14, $0
	db 0, -24, 15, $0
	db 0, -16, 16, $0
	db 8, -16, 11, (1 << OAM_X_FLIP)
	db 8, -24, 12, (1 << OAM_X_FLIP)
	db -16, 0, 7, (1 << OAM_X_FLIP)
	db -16, -8, 8, (1 << OAM_X_FLIP)
	db -8, 0, 11, (1 << OAM_X_FLIP)
	db -8, -8, 12, (1 << OAM_X_FLIP)
; 0xab2bb

AnimData95:: ; ab2bb (2a:72bb)
	frame_table AnimFrameTable28
	frame_data 0, 2, 0, 0
	frame_data 1, 2, 0, 0
	frame_data 2, 2, 0, 0
	frame_data 3, 2, 0, 0
	frame_data 4, 2, 0, 0
	frame_data 5, 2, 0, 0
	frame_data 6, 2, 0, 0
	frame_data 7, 2, 0, 0
	frame_data 8, 2, 0, 0
	frame_data 8, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xab2ea

AnimFrameTable28:: ; ab2ea (2a:72ea)
	dw .data_ab2fc
	dw .data_ab305
	dw .data_ab31e
	dw .data_ab33f
	dw .data_ab360
	dw .data_ab381
	dw .data_ab3a2
	dw .data_ab3c3
	dw .data_ab3e4

.data_ab2fc
	db 2 ; size
	db -27, -35, 0, $0
	db 20, 28, 0, $0

.data_ab305
	db 6 ; size
	db -27, -27, 1, $0
	db 20, 20, 1, $0
	db -19, -35, 0, $0
	db 12, 28, 0, $0
	db -27, -35, 0, $0
	db 20, 28, 0, $0

.data_ab31e
	db 8 ; size
	db -27, -20, 0, (1 << OAM_X_FLIP)
	db 20, 11, 0, (1 << OAM_X_FLIP)
	db -15, -35, 2, $0
	db 8, 28, 2, $0
	db -27, -27, 1, $0
	db 20, 20, 1, $0
	db -19, -35, 0, $0
	db 12, 28, 0, $0

.data_ab33f
	db 8 ; size
	db -27, -11, 2, $0
	db 20, 4, 2, $0
	db -12, -35, 0, (1 << OAM_Y_FLIP)
	db 3, 28, 0, (1 << OAM_Y_FLIP)
	db -27, -20, 0, (1 << OAM_X_FLIP)
	db 20, 11, 0, (1 << OAM_X_FLIP)
	db -15, -35, 2, $0
	db 8, 28, 2, $0

.data_ab360
	db 8 ; size
	db 19, -4, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -28, -5, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -7, -35, 1, $0
	db 0, 29, 1, $0
	db -27, -11, 2, $0
	db 20, 4, 2, $0
	db -12, -35, 0, (1 << OAM_Y_FLIP)
	db 3, 28, 0, (1 << OAM_Y_FLIP)

.data_ab381
	db 8 ; size
	db -27, 3, 1, (1 << OAM_X_FLIP)
	db 20, -12, 1, (1 << OAM_X_FLIP)
	db -4, -36, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -5, 27, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 19, -4, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -28, -5, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -7, -35, 1, $0
	db 0, 29, 1, $0

.data_ab3a2
	db 8 ; size
	db 19, -19, 0, (1 << OAM_Y_FLIP)
	db -28, 12, 0, (1 << OAM_Y_FLIP)
	db 1, -35, 2, $0
	db -8, 28, 2, $0
	db -27, 3, 1, (1 << OAM_X_FLIP)
	db 20, -12, 1, (1 << OAM_X_FLIP)
	db -4, -36, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -5, 27, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_ab3c3
	db 8 ; size
	db -27, 19, 2, (1 << OAM_X_FLIP)
	db 20, -28, 2, (1 << OAM_X_FLIP)
	db 5, -36, 0, (1 << OAM_X_FLIP)
	db -12, 27, 0, (1 << OAM_X_FLIP)
	db 19, -19, 0, (1 << OAM_Y_FLIP)
	db -28, 12, 0, (1 << OAM_Y_FLIP)
	db 1, -35, 2, $0
	db -8, 28, 2, $0

.data_ab3e4
	db 8 ; size
	db 20, -35, 0, $0
	db -27, 28, 0, $0
	db 8, -35, 1, $0
	db -16, 28, 1, $0
	db -27, 19, 2, (1 << OAM_X_FLIP)
	db 20, -28, 2, (1 << OAM_X_FLIP)
	db 5, -36, 0, (1 << OAM_X_FLIP)
	db -12, 27, 0, (1 << OAM_X_FLIP)
; 0xab405

AnimData96:: ; ab405 (2a:7405)
	frame_table AnimFrameTable29
	frame_data 0, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 1, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 2, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 3, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 4, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data 5, 4, 0, 0
	frame_data -1, 2, 0, 0
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xab440

AnimFrameTable29:: ; ab440 (2a:7440)
	dw .data_ab44c
	dw .data_ab4b5
	dw .data_ab506
	dw .data_ab583
	dw .data_ab5b4
	dw .data_ab5fd

.data_ab44c
	db 26 ; size
	db -72, -8, 0, $0
	db -72, 0, 1, $0
	db -64, 1, 2, (1 << OAM_X_FLIP)
	db -64, -7, 3, (1 << OAM_X_FLIP)
	db -56, -9, 4, $0
	db -56, -1, 5, $0
	db -48, -9, 15, $0
	db -48, -1, 16, $0
	db -48, 7, 17, $0
	db -48, 15, 18, $0
	db -40, -14, 19, $0
	db -40, -6, 20, $0
	db -40, 1, 21, $0
	db -40, 9, 22, $0
	db -40, 17, 23, $0
	db -32, -8, 25, $0
	db -32, 0, 26, $0
	db -24, -8, 27, $0
	db -24, 0, 28, $0
	db -16, -8, 29, $0
	db -16, 0, 30, $0
	db -16, 8, 31, $0
	db -8, -8, 32, $0
	db -8, 0, 33, $0
	db -8, 8, 34, $0
	db -32, 8, 24, $0

.data_ab4b5
	db 20 ; size
	db -72, 0, 0, (1 << OAM_X_FLIP)
	db -72, -8, 1, (1 << OAM_X_FLIP)
	db -64, 8, 2, (1 << OAM_X_FLIP)
	db -64, 0, 3, (1 << OAM_X_FLIP)
	db -56, 9, 4, (1 << OAM_X_FLIP)
	db -56, 1, 5, (1 << OAM_X_FLIP)
	db -48, 9, 15, (1 << OAM_X_FLIP)
	db -40, 14, 19, (1 << OAM_X_FLIP)
	db -40, 6, 20, (1 << OAM_X_FLIP)
	db -32, 8, 25, (1 << OAM_X_FLIP)
	db -32, 0, 26, (1 << OAM_X_FLIP)
	db -24, 8, 27, (1 << OAM_X_FLIP)
	db -24, 0, 28, (1 << OAM_X_FLIP)
	db -48, 1, 35, (1 << OAM_X_FLIP)
	db -16, -8, 36, $0
	db -16, 0, 37, $0
	db -16, 8, 38, $0
	db -8, -8, 39, $0
	db -8, 0, 40, $0
	db -8, 8, 41, $0

.data_ab506
	db 31 ; size
	db -72, -8, 0, $0
	db -72, 0, 1, $0
	db -64, -16, 2, $0
	db -64, -8, 3, $0
	db -56, -16, 4, $0
	db -56, -8, 5, $0
	db -48, -2, 6, (1 << OAM_X_FLIP)
	db -48, -10, 7, (1 << OAM_X_FLIP)
	db -48, -18, 8, (1 << OAM_X_FLIP)
	db -40, 3, 9, (1 << OAM_X_FLIP)
	db -40, -5, 10, (1 << OAM_X_FLIP)
	db -40, -13, 11, (1 << OAM_X_FLIP)
	db -40, -21, 12, (1 << OAM_X_FLIP)
	db -32, -8, 13, $0
	db -32, 1, 14, $0
	db -32, -24, 15, $0
	db -32, -16, 35, $0
	db -24, -19, 19, (1 << OAM_X_FLIP)
	db -24, -27, 20, (1 << OAM_X_FLIP)
	db -16, -30, 25, $0
	db -16, -22, 26, $0
	db -8, -33, 25, $0
	db -8, -25, 26, $0
	db 0, -33, 27, (1 << OAM_X_FLIP)
	db 0, -41, 28, (1 << OAM_X_FLIP)
	db 8, -49, 36, $0
	db 8, -41, 37, $0
	db 8, -33, 38, $0
	db 16, -49, 39, $0
	db 16, -41, 40, $0
	db 16, -33, 41, $0

.data_ab583
	db 12 ; size
	db -72, 8, 0, (1 << OAM_X_FLIP)
	db -72, 0, 1, (1 << OAM_X_FLIP)
	db -64, 8, 44, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -64, 16, 42, $0
	db -64, 24, 43, $0
	db -64, 32, 44, $0
	db -56, 25, 29, $0
	db -56, 33, 30, $0
	db -56, 41, 31, $0
	db -48, 25, 32, $0
	db -48, 33, 33, $0
	db -48, 41, 34, $0

.data_ab5b4
	db 18 ; size
	db -72, 8, 0, $0
	db -72, 16, 1, $0
	db -64, 8, 44, (1 << OAM_Y_FLIP)
	db -64, 0, 42, (1 << OAM_X_FLIP)
	db -64, -8, 43, (1 << OAM_X_FLIP)
	db -64, -16, 44, (1 << OAM_X_FLIP)
	db -56, -16, 27, (1 << OAM_X_FLIP)
	db -56, -24, 28, (1 << OAM_X_FLIP)
	db -48, -23, 44, (1 << OAM_Y_FLIP)
	db -46, -31, 42, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -45, -39, 43, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -44, -47, 44, (1 << OAM_X_FLIP)
	db -36, -57, 36, $0
	db -36, -49, 37, $0
	db -36, -41, 38, $0
	db -28, -57, 39, $0
	db -28, -49, 40, $0
	db -28, -41, 41, $0

.data_ab5fd
	db 28 ; size
	db -72, -8, 0, (1 << OAM_X_FLIP)
	db -16, 32, 27, $0
	db -16, 40, 28, $0
	db -8, 32, 29, $0
	db -8, 40, 30, $0
	db 0, 32, 32, $0
	db 0, 40, 33, $0
	db -8, 48, 31, $0
	db 0, 48, 34, $0
	db -24, 32, 25, (1 << OAM_X_FLIP)
	db -24, 24, 26, (1 << OAM_X_FLIP)
	db -32, 21, 19, $0
	db -32, 29, 20, $0
	db -40, 26, 15, (1 << OAM_X_FLIP)
	db -40, 18, 16, (1 << OAM_X_FLIP)
	db -40, 10, 17, (1 << OAM_X_FLIP)
	db -40, 2, 18, (1 << OAM_X_FLIP)
	db -32, 16, 21, (1 << OAM_X_FLIP)
	db -32, 8, 22, (1 << OAM_X_FLIP)
	db -32, 0, 23, (1 << OAM_X_FLIP)
	db -24, 8, 24, (1 << OAM_X_FLIP)
	db -48, 15, 11, $0
	db -48, 23, 12, $0
	db -64, 8, 2, (1 << OAM_X_FLIP)
	db -64, 0, 3, (1 << OAM_X_FLIP)
	db -56, 18, 44, $0
	db -56, 2, 44, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -56, 10, 42, $0
; 0xab66e

AnimData97:: ; ab66e (2a:766e)
	frame_table AnimFrameTable30
	frame_data 0, 4, 0, 0
	frame_data 1, 5, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 3, 5, 0, 0
	frame_data 0, 6, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 5, 0, 0
	frame_data 3, 4, 0, 0
	frame_data 4, 4, 0, 0
	frame_data 5, 5, 0, 0
	frame_data 6, 4, 0, 0
	frame_data 7, 4, 0, 0
	frame_data 8, 4, 0, 0
	frame_data 8, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xab6ad

AnimFrameTable30:: ; ab6ad (2a:76ad)
	dw .data_ab6d5
	dw .data_ab6e6
	dw .data_ab6f7
	dw .data_ab708
	dw .data_ab719
	dw .data_ab74a
	dw .data_ab773
	dw .data_ab79c
	dw .data_ab7c5
	dw .data_ab7da
	dw .data_ab7ef
	dw .data_ab808
	dw .data_ab82d
	dw .data_ab856
	dw .data_ab88b
	dw .data_ab8cc
	dw .data_ab90d
	dw .data_ab94e
	dw .data_ab98f
	dw .data_ab9b0

.data_ab6d5
	db 4 ; size
	db -8, -8, 0, $0
	db 0, -8, 1, $0
	db -8, 0, 4, (1 << OAM_X_FLIP)
	db 0, 0, 5, (1 << OAM_X_FLIP)

.data_ab6e6
	db 4 ; size
	db -8, -8, 2, $0
	db 0, -8, 3, $0
	db -8, 0, 6, (1 << OAM_X_FLIP)
	db 0, 0, 7, (1 << OAM_X_FLIP)

.data_ab6f7
	db 4 ; size
	db -8, -8, 4, $0
	db 0, -8, 5, $0
	db -8, 0, 0, (1 << OAM_X_FLIP)
	db 0, 0, 1, (1 << OAM_X_FLIP)

.data_ab708
	db 4 ; size
	db -8, -8, 6, $0
	db 0, -8, 7, $0
	db -8, 0, 2, (1 << OAM_X_FLIP)
	db 0, 0, 3, (1 << OAM_X_FLIP)

.data_ab719
	db 12 ; size
	db -8, -8, 0, $0
	db 0, -8, 1, $0
	db -8, 0, 4, (1 << OAM_X_FLIP)
	db 0, 0, 5, (1 << OAM_X_FLIP)
	db -19, 2, 8, $0
	db 1, -10, 8, $0
	db -12, 2, 9, $0
	db 9, -10, 9, $0
	db -19, -10, 10, $0
	db -11, -10, 11, $0
	db 1, 2, 10, $0
	db 9, 2, 11, $0

.data_ab74a
	db 10 ; size
	db -24, -14, 8, $0
	db -16, -14, 9, $0
	db 4, 6, 9, $0
	db -4, 6, 8, $0
	db -23, 6, 10, $0
	db -4, -14, 10, $0
	db 4, -14, 11, $0
	db -15, 6, 11, $0
	db -8, -4, 8, $0
	db 0, -4, 9, $0

.data_ab773
	db 10 ; size
	db -28, -18, 10, $0
	db -20, -18, 11, $0
	db 6, 10, 11, $0
	db -2, 10, 10, $0
	db -28, 10, 8, $0
	db -2, -18, 8, $0
	db 6, -18, 9, $0
	db -20, 10, 9, $0
	db -8, -4, 10, $0
	db 0, -4, 11, $0

.data_ab79c
	db 10 ; size
	db -24, -20, 10, $0
	db -16, -20, 11, $0
	db 8, 12, 11, $0
	db 0, 12, 10, $0
	db -24, 12, 8, $0
	db 0, -20, 8, $0
	db 8, -20, 9, $0
	db -16, 12, 9, $0
	db -8, -4, 10, $0
	db 0, -4, 11, $0

.data_ab7c5
	db 5 ; size
	db -1, -4, 12, $0
	db -16, -20, 12, $0
	db 8, -20, 12, $0
	db -16, 12, 12, $0
	db 8, 12, 12, $0

.data_ab7da
	db 5 ; size
	db -8, 10, 4, $0
	db 0, 10, 5, $0
	db -8, 18, 0, (1 << OAM_X_FLIP)
	db 0, 18, 1, (1 << OAM_X_FLIP)
	db -16, 12, 12, $0

.data_ab7ef
	db 6 ; size
	db 2, 8, 6, $0
	db 10, 8, 7, $0
	db 2, 16, 2, (1 << OAM_X_FLIP)
	db 10, 16, 3, (1 << OAM_X_FLIP)
	db -19, 12, 10, $0
	db -11, 12, 11, $0

.data_ab808
	db 9 ; size
	db 6, -8, 0, $0
	db 14, -8, 1, $0
	db 6, 0, 4, (1 << OAM_X_FLIP)
	db 14, 0, 5, (1 << OAM_X_FLIP)
	db 8, 12, 12, $0
	db -21, 8, 0, $0
	db -13, 8, 1, $0
	db -21, 16, 4, (1 << OAM_X_FLIP)
	db -13, 16, 5, (1 << OAM_X_FLIP)

.data_ab82d
	db 10 ; size
	db 2, -22, 2, $0
	db 10, -22, 3, $0
	db 2, -14, 6, (1 << OAM_X_FLIP)
	db 10, -14, 7, (1 << OAM_X_FLIP)
	db 5, 12, 8, $0
	db 13, 12, 9, $0
	db -21, 9, 2, $0
	db -13, 9, 3, $0
	db -21, 17, 6, (1 << OAM_X_FLIP)
	db -13, 17, 7, (1 << OAM_X_FLIP)

.data_ab856
	db 13 ; size
	db -8, -26, 4, $0
	db 0, -26, 5, $0
	db -8, -18, 0, (1 << OAM_X_FLIP)
	db 0, -18, 1, (1 << OAM_X_FLIP)
	db 8, -20, 12, $0
	db -20, 8, 4, $0
	db -12, 8, 5, $0
	db -20, 16, 0, (1 << OAM_X_FLIP)
	db -12, 16, 1, (1 << OAM_X_FLIP)
	db 5, 8, 4, $0
	db 13, 8, 5, $0
	db 5, 16, 0, (1 << OAM_X_FLIP)
	db 13, 16, 1, (1 << OAM_X_FLIP)

.data_ab88b
	db 16 ; size
	db -20, -24, 6, $0
	db -12, -24, 7, $0
	db -20, -16, 2, (1 << OAM_X_FLIP)
	db -12, -16, 3, (1 << OAM_X_FLIP)
	db -20, 8, 6, $0
	db -12, 8, 7, $0
	db -20, 16, 2, (1 << OAM_X_FLIP)
	db -12, 16, 3, (1 << OAM_X_FLIP)
	db 5, 8, 6, $0
	db 13, 8, 7, $0
	db 5, 16, 2, (1 << OAM_X_FLIP)
	db 13, 16, 3, (1 << OAM_X_FLIP)
	db 5, -24, 6, $0
	db 13, -24, 7, $0
	db 5, -16, 2, (1 << OAM_X_FLIP)
	db 13, -16, 3, (1 << OAM_X_FLIP)

.data_ab8cc
	db 16 ; size
	db -20, -24, 0, $0
	db -12, -24, 1, $0
	db -20, -16, 4, (1 << OAM_X_FLIP)
	db -12, -16, 5, (1 << OAM_X_FLIP)
	db -20, 8, 0, $0
	db -12, 8, 1, $0
	db -20, 16, 4, (1 << OAM_X_FLIP)
	db -12, 16, 5, (1 << OAM_X_FLIP)
	db 5, -25, 0, $0
	db 13, -25, 1, $0
	db 5, -17, 4, (1 << OAM_X_FLIP)
	db 13, -17, 5, (1 << OAM_X_FLIP)
	db 6, 6, 0, $0
	db 14, 6, 1, $0
	db 6, 14, 4, (1 << OAM_X_FLIP)
	db 14, 14, 5, (1 << OAM_X_FLIP)

.data_ab90d
	db 16 ; size
	db -20, 16, 6, (1 << OAM_X_FLIP)
	db -12, 16, 7, (1 << OAM_X_FLIP)
	db -20, 8, 2, $0
	db -12, 8, 3, $0
	db -20, -16, 6, (1 << OAM_X_FLIP)
	db -12, -16, 7, (1 << OAM_X_FLIP)
	db -20, -24, 2, $0
	db -12, -24, 3, $0
	db 5, -16, 6, (1 << OAM_X_FLIP)
	db 13, -16, 7, (1 << OAM_X_FLIP)
	db 5, -24, 2, $0
	db 13, -24, 3, $0
	db 5, 16, 6, (1 << OAM_X_FLIP)
	db 13, 16, 7, (1 << OAM_X_FLIP)
	db 5, 8, 2, $0
	db 13, 8, 3, $0

.data_ab94e
	db 16 ; size
	db -20, -24, 4, $0
	db -12, -24, 5, $0
	db -20, -16, 0, (1 << OAM_X_FLIP)
	db -12, -16, 1, (1 << OAM_X_FLIP)
	db -19, 8, 4, $0
	db -11, 8, 5, $0
	db -19, 16, 0, (1 << OAM_X_FLIP)
	db -11, 16, 1, (1 << OAM_X_FLIP)
	db 4, 8, 4, $0
	db 12, 8, 5, $0
	db 4, 16, 0, (1 << OAM_X_FLIP)
	db 12, 16, 1, (1 << OAM_X_FLIP)
	db 5, -24, 4, $0
	db 13, -24, 5, $0
	db 5, -16, 0, (1 << OAM_X_FLIP)
	db 13, -16, 1, (1 << OAM_X_FLIP)

.data_ab98f
	db 8 ; size
	db -20, -20, 8, $0
	db -20, 12, 8, $0
	db 4, 12, 8, $0
	db 4, -20, 8, $0
	db -12, -20, 9, $0
	db -12, 12, 9, $0
	db 12, 12, 9, $0
	db 12, -20, 9, $0

.data_ab9b0
	db 4 ; size
	db -16, -20, 12, $0
	db -16, 12, 12, $0
	db 8, 12, 12, $0
	db 8, -20, 12, $0
; 0xab9c1

AnimData98:: ; ab9c1 (2a:79c1)
	frame_table AnimFrameTable30
	frame_data 0, 5, 0, 0
	frame_data 1, 5, 0, 0
	frame_data 2, 5, 0, 0
	frame_data 3, 5, 0, 0
	frame_data 0, 4, 6, -6
	frame_data 1, 4, 8, -4
	frame_data 9, 4, -14, 10
	frame_data 10, 4, 0, 0
	frame_data 11, 4, 0, 0
	frame_data 12, 4, 0, 0
	frame_data 13, 4, 0, 0
	frame_data 14, 4, 0, 0
	frame_data 15, 4, 0, 0
	frame_data 17, 4, 0, 0
	frame_data 18, 5, 0, 0
	frame_data 19, 5, 0, 0
	frame_data 19, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xaba0c

AnimData99:: ; aba0c (2a:7a0c)
	frame_table AnimFrameTable31
	frame_data 0, 5, 0, 0
	frame_data 1, 5, 0, 0
	frame_data 2, 5, 0, 0
	frame_data 3, 5, 0, 0
	frame_data 4, 4, 0, 0
	frame_data 5, 4, 0, 0
	frame_data 6, 4, 0, 0
	frame_data 7, 4, 0, 0
	frame_data 4, 2, -8, 0
	frame_data 4, 2, 16, 0
	frame_data 5, 2, -16, 0
	frame_data 5, 2, 16, 0
	frame_data 6, 2, -16, 0
	frame_data 6, 2, 16, 0
	frame_data 7, 2, -16, 0
	frame_data 7, 2, 16, 0
	frame_data 4, 2, -32, 0
	frame_data 4, 2, 48, 0
	frame_data 5, 2, -48, 0
	frame_data 5, 2, 48, 0
	frame_data 6, 2, -48, 0
	frame_data 6, 2, 48, 0
	frame_data 7, 2, -48, 0
	frame_data 7, 2, 48, 0
	frame_data 4, 2, -64, 0
	frame_data 4, 2, 80, 0
	frame_data 5, 2, -80, 0
	frame_data 5, 2, 80, 0
	frame_data 6, 2, -80, 0
	frame_data 6, 2, 80, 0
	frame_data 7, 2, -80, 0
	frame_data 7, 2, 80, 0
	frame_data 0, 2, -80, 0
	frame_data 0, 2, 80, 0
	frame_data 1, 2, -80, 0
	frame_data 1, 2, 80, 0
	frame_data 2, 2, -80, 0
	frame_data 2, 2, 80, 0
	frame_data 3, 2, -80, 0
	frame_data 3, 2, 80, 0
	frame_data 3, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xabab7

AnimFrameTable31:: ; abab7 (2a:7ab7)
	dw .data_abac7
	dw .data_abad8
	dw .data_abae9
	dw .data_abafa
	dw .data_abb0b
	dw .data_abb38
	dw .data_abb6d
	dw .data_abb9a

.data_abac7
	db 4 ; size
	db -42, -10, 24, (1 << OAM_X_FLIP)
	db -42, -18, 25, (1 << OAM_X_FLIP)
	db -34, -10, 26, (1 << OAM_X_FLIP)
	db -34, -18, 27, (1 << OAM_X_FLIP)

.data_abad8
	db 4 ; size
	db -14, -10, 24, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -14, -18, 25, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -22, -10, 26, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -22, -18, 27, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_abae9
	db 4 ; size
	db -14, 2, 24, (1 << OAM_Y_FLIP)
	db -14, 10, 25, (1 << OAM_Y_FLIP)
	db -22, 2, 26, (1 << OAM_Y_FLIP)
	db -22, 10, 27, (1 << OAM_Y_FLIP)

.data_abafa
	db 4 ; size
	db -42, 2, 24, $0
	db -42, 10, 25, $0
	db -34, 2, 26, $0
	db -34, 10, 27, $0

.data_abb0b
	db 11 ; size
	db -32, -24, 13, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -32, -32, 14, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -40, -32, 17, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -48, -32, 20, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -56, -28, 22, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -56, -20, 21, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -48, -16, 18, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -48, -24, 19, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -40, -24, 16, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -40, -16, 15, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -56, -8, 23, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_abb38
	db 13 ; size
	db 1, -8, 0, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -7, -8, 5, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 1, -16, 1, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -7, -16, 6, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, -24, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, -24, 7, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, -24, 10, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -1, -32, 3, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -1, -40, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -9, -40, 9, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -17, -40, 12, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -17, -32, 11, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -9, -32, 8, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_abb6d
	db 11 ; size
	db -24, 16, 13, $0
	db -24, 24, 14, $0
	db -16, 24, 17, $0
	db -8, 24, 20, $0
	db 0, 20, 22, $0
	db 0, 12, 21, $0
	db -8, 8, 18, $0
	db -8, 16, 19, $0
	db -16, 16, 16, $0
	db -16, 8, 15, $0
	db 0, 0, 23, $0

.data_abb9a
	db 13 ; size
	db -57, 0, 0, $0
	db -49, 0, 5, $0
	db -57, 8, 1, $0
	db -49, 8, 6, $0
	db -56, 16, 2, $0
	db -48, 16, 7, $0
	db -40, 16, 10, $0
	db -55, 24, 3, $0
	db -55, 32, 4, $0
	db -47, 32, 9, $0
	db -39, 32, 12, $0
	db -39, 24, 11, $0
	db -47, 24, 8, $0
; 0xabbcf

AnimData101:: ; abbcf (2a:7bcf)
	frame_table AnimFrameTable32
	frame_data 0, 12, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 2, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xabbfe

AnimData102:: ; abbfe (2a:7bfe)
	frame_table AnimFrameTable32
	frame_data 0, 8, 0, 0
	frame_data -1, 8, 0, 0
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xabc11

AnimData103:: ; abc11 (2a:7c11)
	frame_table AnimFrameTable32
	frame_data 1, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 3, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 3, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 5, 8, 0, 0
	frame_data 6, 8, 0, 0
	frame_data 7, 8, 0, 0
	frame_data 8, 8, 0, 0
	frame_data 9, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 9, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 9, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 9, 8, 0, 0
	frame_data 9, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xabc78

AnimData104:: ; abc78 (2a:7c78)
	frame_table AnimFrameTable32
	frame_data 1, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 3, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 3, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 5, 8, 0, 0
	frame_data 10, 8, 0, 0
	frame_data 11, 8, 0, 0
	frame_data 12, 8, 0, 0
	frame_data 13, 8, 0, 0
	frame_data 14, 8, 0, 0
	frame_data 15, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 15, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 15, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 15, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 2, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xabceb

AnimData105:: ; abceb (2a:7ceb)
	frame_table AnimFrameTable33
	frame_data 0, 6, 0, 4
	frame_data 1, 6, 0, 0
	frame_data 2, 6, 0, 0
	frame_data 3, 6, 0, 0
	frame_data 4, 6, 0, 0
	frame_data 5, 6, 0, 0
	frame_data 6, 6, 0, 0
	frame_data 7, 6, 0, 0
	frame_data 0, 4, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 3, 4, 0, 0
	frame_data 4, 4, 0, 0
	frame_data 5, 4, 0, 0
	frame_data 6, 4, 0, 0
	frame_data 7, 4, 0, 0
	frame_data -1, 4, 0, 0
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xabd3a

AnimFrameTable33:: ; abd3a (2a:7d3a)
	dw .data_abd4a
	dw .data_abd57
	dw .data_abd70
	dw .data_abd99
	dw .data_abdda
	dw .data_abe23
	dw .data_abe64
	dw .data_abe95

.data_abd4a
	db 3 ; size
	db 17, -24, 1, $0
	db 17, 0, 1, $0
	db 17, 24, 1, $0

.data_abd57
	db 6 ; size
	db 13, -24, 1, $0
	db 18, 16, 1, $0
	db 10, 0, 2, $0
	db 11, 24, 2, $0
	db 16, -56, 1, $0
	db 16, 56, 1, $0

.data_abd70
	db 10 ; size
	db -10, 0, 0, $0
	db -7, 24, 0, $0
	db 8, -24, 2, $0
	db 12, 16, 2, $0
	db 16, -8, 1, $0
	db 12, -56, 2, $0
	db 16, 40, 1, $0
	db 12, 56, 2, $0
	db -2, 0, 0, (1 << OAM_Y_FLIP)
	db 1, 24, 0, (1 << OAM_Y_FLIP)

.data_abd99
	db 16 ; size
	db -7, 16, 0, $0
	db -17, -24, 0, $0
	db 16, -32, 1, $0
	db 16, 8, 1, $0
	db 8, -8, 2, $0
	db -26, 0, 0, $0
	db -24, 24, 0, $0
	db 0, -56, 0, $0
	db 8, 40, 2, $0
	db 0, 56, 0, $0
	db 8, -56, 0, (1 << OAM_Y_FLIP)
	db -9, -24, 0, (1 << OAM_Y_FLIP)
	db -18, 0, 0, (1 << OAM_Y_FLIP)
	db -16, 24, 0, (1 << OAM_Y_FLIP)
	db 1, 16, 0, (1 << OAM_Y_FLIP)
	db 8, 56, 0, (1 << OAM_Y_FLIP)

.data_abdda
	db 18 ; size
	db 8, -32, 2, $0
	db 5, 8, 2, $0
	db -12, -8, 0, $0
	db -27, -24, 0, $0
	db -21, 16, 0, $0
	db -50, 0, 0, $0
	db -34, 24, 0, $0
	db -8, 40, 0, $0
	db -16, -56, 0, $0
	db -8, 56, 0, $0
	db -8, -56, 0, (1 << OAM_Y_FLIP)
	db -19, -24, 0, (1 << OAM_Y_FLIP)
	db -4, -8, 0, (1 << OAM_Y_FLIP)
	db -42, 0, 0, (1 << OAM_Y_FLIP)
	db -13, 16, 0, (1 << OAM_Y_FLIP)
	db -26, 24, 0, (1 << OAM_Y_FLIP)
	db 0, 40, 0, (1 << OAM_Y_FLIP)
	db 0, 56, 0, (1 << OAM_Y_FLIP)

.data_abe23
	db 16 ; size
	db -19, -32, 0, $0
	db -9, 8, 0, $0
	db -51, -24, 0, $0
	db -32, -8, 0, $0
	db -29, 40, 0, $0
	db -40, -56, 0, $0
	db -40, 56, 0, $0
	db -64, 16, 0, $0
	db -32, -56, 0, (1 << OAM_Y_FLIP)
	db -11, -32, 0, (1 << OAM_Y_FLIP)
	db -43, -24, 0, (1 << OAM_Y_FLIP)
	db -24, -8, 0, (1 << OAM_Y_FLIP)
	db -1, 8, 0, (1 << OAM_Y_FLIP)
	db -56, 16, 0, (1 << OAM_Y_FLIP)
	db -21, 40, 0, (1 << OAM_Y_FLIP)
	db -32, 56, 0, (1 << OAM_Y_FLIP)

.data_abe64
	db 12 ; size
	db -32, 8, 0, $0
	db -48, -32, 0, $0
	db -64, -8, 0, $0
	db -61, 40, 0, $0
	db -40, -32, 0, (1 << OAM_Y_FLIP)
	db -56, -8, 0, (1 << OAM_Y_FLIP)
	db -24, 8, 0, (1 << OAM_Y_FLIP)
	db -53, 40, 0, (1 << OAM_Y_FLIP)
	db -80, -56, 0, $0
	db -72, -56, 0, (1 << OAM_Y_FLIP)
	db -80, 56, 0, $0
	db -72, 56, 0, (1 << OAM_Y_FLIP)

.data_abe95
	db 4 ; size
	db -64, 0, 0, $0
	db -56, 0, 0, (1 << OAM_Y_FLIP)
	db -80, -32, 0, $0
	db -72, -32, 0, (1 << OAM_Y_FLIP)
; 0xabea6

AnimData106:: ; abea6 (2a:7ea6)
	frame_table AnimFrameTable34
	frame_data 0, 3, 0, 12
	frame_data 1, 3, 0, 0
	frame_data 2, 3, 0, 0
	frame_data 3, 3, 0, 0
	frame_data 4, 3, 0, 0
	frame_data 5, 3, 0, 0
	frame_data 6, 3, 0, 0
	frame_data 7, 3, 0, 0
	frame_data 8, 3, 0, 0
	frame_data 6, 3, 0, 0
	frame_data 7, 3, 0, 0
	frame_data 8, 3, 0, 0
	frame_data 6, 4, 0, 0
	frame_data 7, 4, 0, 0
	frame_data 8, 4, 0, 0
	frame_data 6, 4, 0, 0
	frame_data 7, 4, 0, 0
	frame_data 8, 4, 0, 0
	frame_data 8, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xabef9

AnimFrameTable34:: ; abef9 (2a:7ef9)
	dw .data_abf0b
	dw .data_abf1c
	dw .data_abf2d
	dw .data_abf3e
	dw .data_abf57
	dw .data_abf70
	dw .data_abf89
	dw .data_abfaa
	dw .data_abfcb

.data_abf0b
	db 4 ; size
	db -11, -8, 0, $0
	db -3, -8, 1, $0
	db -11, 0, 0, (1 << OAM_X_FLIP)
	db -3, 0, 1, (1 << OAM_X_FLIP)

.data_abf1c
	db 4 ; size
	db -11, -8, 2, $0
	db -3, -8, 3, $0
	db -11, 0, 2, (1 << OAM_X_FLIP)
	db -3, 0, 3, (1 << OAM_X_FLIP)

.data_abf2d
	db 4 ; size
	db -11, -8, 4, $0
	db -3, -8, 5, $0
	db -11, 0, 4, (1 << OAM_X_FLIP)
	db -3, 0, 5, (1 << OAM_X_FLIP)

.data_abf3e
	db 6 ; size
	db -19, -8, 6, $0
	db -11, -8, 7, $0
	db -3, -8, 8, $0
	db -19, 0, 6, (1 << OAM_X_FLIP)
	db -11, 0, 7, (1 << OAM_X_FLIP)
	db -3, 0, 8, (1 << OAM_X_FLIP)

.data_abf57
	db 6 ; size
	db -20, -8, 9, $0
	db -12, -8, 10, $0
	db -4, -8, 11, $0
	db -20, 0, 9, (1 << OAM_X_FLIP)
	db -12, 0, 10, (1 << OAM_X_FLIP)
	db -4, 0, 11, (1 << OAM_X_FLIP)

.data_abf70
	db 6 ; size
	db -19, -8, 12, $0
	db -11, -8, 13, $0
	db -3, -8, 14, $0
	db -19, 0, 12, (1 << OAM_X_FLIP)
	db -11, 0, 13, (1 << OAM_X_FLIP)
	db -3, 0, 14, (1 << OAM_X_FLIP)

.data_abf89
	db 8 ; size
	db -27, -8, 15, $0
	db -19, -8, 16, $0
	db -11, -8, 17, $0
	db -3, -8, 18, $0
	db -27, 0, 15, (1 << OAM_X_FLIP)
	db -19, 0, 16, (1 << OAM_X_FLIP)
	db -11, 0, 17, (1 << OAM_X_FLIP)
	db -3, 0, 18, (1 << OAM_X_FLIP)

.data_abfaa
	db 8 ; size
	db -27, -8, 19, $0
	db -19, -8, 20, $0
	db -11, -8, 21, $0
	db -3, -8, 22, $0
	db -19, 0, 20, (1 << OAM_X_FLIP)
	db -11, 0, 21, (1 << OAM_X_FLIP)
	db -3, 0, 22, (1 << OAM_X_FLIP)
	db -29, 0, 19, (1 << OAM_X_FLIP)

.data_abfcb
	db 8 ; size
	db -27, -8, 23, $0
	db -19, -8, 24, $0
	db -11, -8, 25, $0
	db -3, -8, 26, $0
	db -27, 0, 23, (1 << OAM_X_FLIP)
	db -19, 0, 24, (1 << OAM_X_FLIP)
	db -11, 0, 25, (1 << OAM_X_FLIP)
	db -3, 0, 26, (1 << OAM_X_FLIP)
; 0xabfec

AnimData149:: ; abfec (2a:7fec)
	frame_table AnimFrameTable71
	frame_data 0, 5, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 1, -1, 0, 0
	frame_data 0, 0, 0, 0
; 0xabfff
