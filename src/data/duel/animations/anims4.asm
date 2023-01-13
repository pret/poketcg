AnimData178::
	frame_table AnimFrameTable82
	frame_data 0, 4, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 3, 4, 0, 0
	frame_data 4, 4, 0, 0
	frame_data -1, 6, 0, 0
	frame_data 5, 4, 0, 0
	frame_data 6, 4, 0, 0
	frame_data 7, 4, 0, 0
	frame_data 8, 4, 0, 0
	frame_data 9, 4, 0, 0
	frame_data -1, 6, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable82::
	dw .data_b407b
	dw .data_b4084
	dw .data_b409d
	dw .data_b40ce
	dw .data_b40f7
	dw .data_b4110
	dw .data_b4119
	dw .data_b4132
	dw .data_b4163
	dw .data_b418c
	dw .data_b41a5
	dw .data_b41aa
	dw .data_b41b3
	dw .data_b41c0
	dw .data_b41d1
	dw .data_b41e6
	dw .data_b41ff
	dw .data_b421c
	dw .data_b423d
	dw .data_b4262
	dw .data_b428b
	dw .data_b42b8
	dw .data_b42e9
	dw .data_b42ee
	dw .data_b42f7
	dw .data_b4304
	dw .data_b4315
	dw .data_b432a
	dw .data_b4343
	dw .data_b4360
	dw .data_b4381
	dw .data_b43a6
	dw .data_b43cf
	dw .data_b43fc

.data_b407b
	db 2 ; size
	db -32, -31, 1, $0
	db -24, -31, 1, (1 << OAM_Y_FLIP)

.data_b4084
	db 6 ; size
	db -32, -31, 1, $0
	db -24, -31, 1, (1 << OAM_Y_FLIP)
	db -40, -22, 2, $0
	db -32, -20, 3, $0
	db -16, -22, 2, (1 << OAM_Y_FLIP)
	db -24, -20, 3, (1 << OAM_Y_FLIP)

.data_b409d
	db 12 ; size
	db -32, -31, 1, $0
	db -24, -31, 1, (1 << OAM_Y_FLIP)
	db -40, -22, 2, $0
	db -32, -20, 3, $0
	db -48, -13, 4, $0
	db -40, -9, 5, $0
	db -32, -8, 6, $0
	db -16, -22, 2, (1 << OAM_Y_FLIP)
	db -24, -20, 3, (1 << OAM_Y_FLIP)
	db -8, -13, 4, (1 << OAM_Y_FLIP)
	db -16, -9, 5, (1 << OAM_Y_FLIP)
	db -24, -8, 6, (1 << OAM_Y_FLIP)

.data_b40ce
	db 10 ; size
	db -40, -22, 2, $0
	db -32, -20, 3, $0
	db -48, -13, 4, $0
	db -40, -9, 5, $0
	db -32, -8, 6, $0
	db -16, -22, 2, (1 << OAM_Y_FLIP)
	db -24, -20, 3, (1 << OAM_Y_FLIP)
	db -8, -13, 4, (1 << OAM_Y_FLIP)
	db -16, -9, 5, (1 << OAM_Y_FLIP)
	db -24, -8, 6, (1 << OAM_Y_FLIP)

.data_b40f7
	db 6 ; size
	db -48, -13, 4, $0
	db -40, -9, 5, $0
	db -32, -8, 6, $0
	db -8, -13, 4, (1 << OAM_Y_FLIP)
	db -16, -9, 5, (1 << OAM_Y_FLIP)
	db -24, -8, 6, (1 << OAM_Y_FLIP)

.data_b4110
	db 2 ; size
	db -32, -9, 1, (1 << OAM_X_FLIP)
	db -24, -9, 1, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_b4119
	db 6 ; size
	db -32, -9, 1, (1 << OAM_X_FLIP)
	db -24, -9, 1, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -40, -18, 2, (1 << OAM_X_FLIP)
	db -32, -20, 3, (1 << OAM_X_FLIP)
	db -16, -18, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -24, -20, 3, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_b4132
	db 12 ; size
	db -32, -9, 1, (1 << OAM_X_FLIP)
	db -24, -9, 1, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -40, -18, 2, (1 << OAM_X_FLIP)
	db -32, -20, 3, (1 << OAM_X_FLIP)
	db -48, -27, 4, (1 << OAM_X_FLIP)
	db -40, -31, 5, (1 << OAM_X_FLIP)
	db -32, -32, 6, (1 << OAM_X_FLIP)
	db -16, -18, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -24, -20, 3, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, -27, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, -31, 5, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -24, -32, 6, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_b4163
	db 10 ; size
	db -40, -18, 2, (1 << OAM_X_FLIP)
	db -32, -20, 3, (1 << OAM_X_FLIP)
	db -48, -27, 4, (1 << OAM_X_FLIP)
	db -40, -31, 5, (1 << OAM_X_FLIP)
	db -32, -32, 6, (1 << OAM_X_FLIP)
	db -16, -18, 2, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -24, -20, 3, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, -27, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, -31, 5, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -24, -32, 6, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_b418c
	db 6 ; size
	db -48, -27, 4, (1 << OAM_X_FLIP)
	db -40, -31, 5, (1 << OAM_X_FLIP)
	db -32, -32, 6, (1 << OAM_X_FLIP)
	db -8, -27, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, -31, 5, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -24, -32, 6, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

.data_b41a5
	db 1 ; size
	db -48, -28, 7, $0

.data_b41aa
	db 2 ; size
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b41b3
	db 3 ; size
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b41c0
	db 4 ; size
	db -48, -4, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b41d1
	db 5 ; size
	db -40, -4, 7, $0
	db -48, -4, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b41e6
	db 6 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -48, -4, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b41ff
	db 7 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -48, -4, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b421c
	db 8 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -48, -4, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b423d
	db 9 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -48, -4, 7, $0
	db -8, -4, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b4262
	db 10 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -48, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b428b
	db 11 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -48, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b42b8
	db 12 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -48, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0
	db -48, -28, 7, $0

.data_b42e9
	db 1 ; size
	db -8, 20, 7, $0

.data_b42ee
	db 2 ; size
	db -8, 12, 7, $0
	db -8, 20, 7, $0

.data_b42f7
	db 3 ; size
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0

.data_b4304
	db 4 ; size
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0

.data_b4315
	db 5 ; size
	db -16, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0

.data_b432a
	db 6 ; size
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0

.data_b4343
	db 7 ; size
	db -32, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0

.data_b4360
	db 8 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0

.data_b4381
	db 9 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -48, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0

.data_b43a6
	db 10 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -48, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0
	db -48, -12, 7, $0

.data_b43cf
	db 11 ; size
	db -32, -4, 7, $0
	db -40, -4, 7, $0
	db -24, -4, 7, $0
	db -16, -4, 7, $0
	db -48, -4, 7, $0
	db -8, -4, 7, $0
	db -8, 4, 7, $0
	db -8, 12, 7, $0
	db -8, 20, 7, $0
	db -48, -12, 7, $0
	db -48, -20, 7, $0

.data_b43fc
	db 12 ; size
	db -24, -14, 8, $0
	db -24, -6, 9, $0
	db -16, -14, 10, $0
	db -24, 6, 8, (1 << OAM_X_FLIP)
	db -24, -2, 9, (1 << OAM_X_FLIP)
	db -16, 6, 10, (1 << OAM_X_FLIP)
	db -32, -14, 8, (1 << OAM_Y_FLIP)
	db -32, -6, 9, (1 << OAM_Y_FLIP)
	db -40, -14, 10, (1 << OAM_Y_FLIP)
	db -32, 6, 8, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -32, -2, 9, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -40, 6, 10, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

AnimData181::
	frame_table AnimFrameTable83
	frame_data 0, 4, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 3, 4, 0, 0
	frame_data 4, 4, 0, 0
	frame_data 5, 4, 0, 0
	frame_data 6, 4, 0, 0
	frame_data 7, 4, 0, 0
	frame_data 8, 4, 0, 0
	frame_data 9, 4, 0, 0
	frame_data 10, 4, 0, 0
	frame_data 11, 4, 0, 0
	frame_data 12, 4, 0, 0
	frame_data 13, 4, 0, 0
	frame_data 14, 4, 0, 0
	frame_data 15, 4, 0, 0
	frame_data 16, 4, 0, 0
	frame_data 17, 4, 0, 0
	frame_data -1, 4, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable83::
	dw .data_b44a6
	dw .data_b44af
	dw .data_b44c0
	dw .data_b44d9
	dw .data_b44fa
	dw .data_b4523
	dw .data_b4554
	dw .data_b458d
	dw .data_b45ce
	dw .data_b4617
	dw .data_b4668
	dw .data_b46c1
	dw .data_b4722
	dw .data_b478b
	dw .data_b47fc
	dw .data_b4875
	dw .data_b48f6
	dw .data_b497f
	dw .data_b4a10

.data_b44a6
	db 2 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)

.data_b44af
	db 4 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)

.data_b44c0
	db 6 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0

.data_b44d9
	db 8 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0

.data_b44fa
	db 10 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0

.data_b4523
	db 12 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0

.data_b4554
	db 14 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0

.data_b458d
	db 16 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0

.data_b45ce
	db 18 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0

.data_b4617
	db 20 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0

.data_b4668
	db 22 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0

.data_b46c1
	db 24 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0

.data_b4722
	db 26 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0

.data_b478b
	db 28 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0

.data_b47fc
	db 30 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0
	db 32, 44, 1, $0
	db 32, 52, 1, $0

.data_b4875
	db 32 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0
	db 32, 44, 1, $0
	db 32, 52, 1, $0
	db 32, 60, 1, $0
	db 32, 68, 2, (1 << OAM_Y_FLIP)

.data_b48f6
	db 34 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0
	db 32, 44, 1, $0
	db 32, 52, 1, $0
	db 32, 60, 1, $0
	db 16, 68, 2, (1 << OAM_Y_FLIP)
	db 24, 68, 2, (1 << OAM_Y_FLIP)
	db 32, 68, 2, (1 << OAM_Y_FLIP)

.data_b497f
	db 36 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0
	db 32, 44, 1, $0
	db 32, 52, 1, $0
	db 32, 60, 1, $0
	db 16, 68, 2, (1 << OAM_Y_FLIP)
	db 24, 68, 2, (1 << OAM_Y_FLIP)
	db 32, 68, 2, (1 << OAM_Y_FLIP)
	db 8, 60, 1, (1 << OAM_X_FLIP)
	db 8, 68, 1, (1 << OAM_X_FLIP)

.data_b4a10
	db 12 ; size
	db 0, -14, 3, %001 | (1 << OAM_OBP_NUM)
	db 0, -6, 4, %001 | (1 << OAM_OBP_NUM)
	db 8, -14, 5, %001 | (1 << OAM_OBP_NUM)
	db 0, 6, 3, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, -2, 4, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 6, 5, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db -8, -14, 3, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -8, -6, 4, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -16, -14, 5, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -8, 6, 3, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, -2, 4, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, 6, 5, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

AnimData183::
	frame_table AnimFrameTable84
	frame_data 0, 4, 0, 0
	frame_data 1, 4, 0, 0
	frame_data 2, 4, 0, 0
	frame_data 3, 4, 0, 0
	frame_data 4, 4, 0, 0
	frame_data 5, 4, 0, 0
	frame_data 6, 4, 0, 0
	frame_data 7, 4, 0, 0
	frame_data 8, 4, 0, 0
	frame_data 9, 4, 0, 0
	frame_data 10, 4, 0, 0
	frame_data 11, 4, 0, 0
	frame_data 12, 4, 0, 0
	frame_data 13, 4, 0, 0
	frame_data 14, 4, 0, 0
	frame_data 15, 4, 0, 0
	frame_data 16, 4, 0, 0
	frame_data 17, 4, 0, 0
	frame_data -1, 4, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable84::
	dw .data_b4aba
	dw .data_b4ac3
	dw .data_b4ad4
	dw .data_b4aed
	dw .data_b4b0e
	dw .data_b4b37
	dw .data_b4b68
	dw .data_b4ba1
	dw .data_b4be2
	dw .data_b4c2b
	dw .data_b4c7c
	dw .data_b4cd5
	dw .data_b4d36
	dw .data_b4d9f
	dw .data_b4e10
	dw .data_b4e89
	dw .data_b4f0a
	dw .data_b4f93
	dw .data_b5024

.data_b4aba
	db 2 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)

.data_b4ac3
	db 4 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)

.data_b4ad4
	db 6 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0

.data_b4aed
	db 8 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0

.data_b4b0e
	db 10 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0

.data_b4b37
	db 12 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0

.data_b4b68
	db 14 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0

.data_b4ba1
	db 16 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0

.data_b4be2
	db 18 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0

.data_b4c2b
	db 20 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0

.data_b4c7c
	db 22 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0

.data_b4cd5
	db 24 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0

.data_b4d36
	db 26 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0

.data_b4d9f
	db 28 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0

.data_b4e10
	db 30 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0
	db 32, 44, 1, $0
	db 32, 52, 1, $0

.data_b4e89
	db 32 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0
	db 32, 44, 1, $0
	db 32, 52, 1, $0
	db 32, 60, 1, $0
	db 32, 68, 2, (1 << OAM_Y_FLIP)

.data_b4f0a
	db 34 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0
	db 32, 44, 1, $0
	db 32, 52, 1, $0
	db 32, 60, 1, $0
	db 16, 68, 2, (1 << OAM_Y_FLIP)
	db 24, 68, 2, (1 << OAM_Y_FLIP)
	db 32, 68, 2, (1 << OAM_Y_FLIP)

.data_b4f93
	db 36 ; size
	db -16, -68, 1, (1 << OAM_X_FLIP)
	db -24, -76, 2, (1 << OAM_Y_FLIP)
	db -32, -76, 2, (1 << OAM_Y_FLIP)
	db -16, -76, 2, (1 << OAM_Y_FLIP)
	db -40, -76, 1, $0
	db -40, -68, 1, $0
	db -40, -60, 1, $0
	db -40, -52, 1, $0
	db -40, -44, 1, $0
	db -40, -36, 1, $0
	db -40, -28, 1, $0
	db -40, -20, 1, $0
	db -40, -12, 1, $0
	db -40, -4, 2, $0
	db -32, -4, 2, $0
	db -24, -4, 2, $0
	db -16, -4, 2, $0
	db -8, -4, 2, $0
	db 0, -4, 2, $0
	db 8, -4, 2, $0
	db 16, -4, 2, $0
	db 24, -4, 2, $0
	db 32, -4, 1, $0
	db 32, 4, 1, $0
	db 32, 12, 1, $0
	db 32, 20, 1, $0
	db 32, 28, 1, $0
	db 32, 36, 1, $0
	db 32, 44, 1, $0
	db 32, 52, 1, $0
	db 32, 60, 1, $0
	db 16, 68, 2, (1 << OAM_Y_FLIP)
	db 24, 68, 2, (1 << OAM_Y_FLIP)
	db 32, 68, 2, (1 << OAM_Y_FLIP)
	db 8, 60, 1, (1 << OAM_X_FLIP)
	db 8, 68, 1, (1 << OAM_X_FLIP)

.data_b5024
	db 12 ; size
	db 0, -14, 3, $0
	db 0, -6, 4, $0
	db 8, -14, 5, $0
	db 0, 6, 3, (1 << OAM_X_FLIP)
	db 0, -2, 4, (1 << OAM_X_FLIP)
	db 8, 6, 5, (1 << OAM_X_FLIP)
	db -8, -14, 3, (1 << OAM_Y_FLIP)
	db -8, -6, 4, (1 << OAM_Y_FLIP)
	db -16, -14, 5, (1 << OAM_Y_FLIP)
	db -8, 6, 3, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, -2, 4, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, 6, 5, (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)

AnimData185::
	frame_table AnimFrameTable85
	frame_data 0, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 3, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 5, 8, 0, 0
	frame_data 6, 8, 0, 0
	frame_data 7, 8, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable85::
	dw .data_b508e
	dw .data_b50bf
	dw .data_b50e4
	dw .data_b5121
	dw .data_b5156
	dw .data_b519b
	dw .data_b51d0
	dw .data_b5219
	dw .data_b523e

.data_b508e
	db 12 ; size
	db 0, -8, 0, $0
	db 0, 0, 0, (1 << OAM_X_FLIP)
	db 8, -8, 16, $0
	db 8, 0, 16, (1 << OAM_X_FLIP)
	db -16, -16, 14, $0
	db -8, -16, 15, $0
	db -16, 8, 14, (1 << OAM_X_FLIP)
	db -8, 8, 15, (1 << OAM_X_FLIP)
	db -16, -8, 12, $0
	db -8, -8, 13, $0
	db -16, 0, 12, (1 << OAM_X_FLIP)
	db -8, 0, 13, (1 << OAM_X_FLIP)

.data_b50bf
	db 9 ; size
	db -19, 11, 3, $0
	db -8, -24, 0, $0
	db 0, -24, 16, $0
	db -8, -16, 0, (1 << OAM_X_FLIP)
	db 0, -16, 16, (1 << OAM_X_FLIP)
	db -8, 8, 0, $0
	db 0, 8, 16, $0
	db -8, 16, 0, (1 << OAM_X_FLIP)
	db 0, 16, 16, (1 << OAM_X_FLIP)

.data_b50e4
	db 15 ; size
	db 0, 16, 0, $0
	db 0, 24, 0, (1 << OAM_X_FLIP)
	db 8, 16, 16, $0
	db 8, 24, 16, (1 << OAM_X_FLIP)
	db -19, 11, 2, $0
	db -16, -16, 1, $0
	db -7, -16, 17, $0
	db -16, 8, 1, (1 << OAM_X_FLIP)
	db -7, 8, 17, (1 << OAM_X_FLIP)
	db -16, -32, 0, $0
	db -8, -32, 16, $0
	db -16, -24, 0, (1 << OAM_X_FLIP)
	db -8, -24, 16, (1 << OAM_X_FLIP)
	db 0, -8, 19, $0
	db 0, 0, 19, (1 << OAM_X_FLIP)

.data_b5121
	db 13 ; size
	db -22, 7, 4, $0
	db -22, 15, 5, $0
	db -14, 7, 6, $0
	db -14, 15, 7, $0
	db 24, -16, 3, $0
	db -16, -24, 12, $0
	db -8, -24, 13, $0
	db -16, -16, 12, (1 << OAM_X_FLIP)
	db -8, -16, 13, (1 << OAM_X_FLIP)
	db 8, 8, 0, $0
	db 16, 8, 16, $0
	db 8, 16, 0, (1 << OAM_X_FLIP)
	db 16, 16, 16, (1 << OAM_X_FLIP)

.data_b5156
	db 17 ; size
	db 0, -8, 0, $0
	db 0, 0, 0, (1 << OAM_X_FLIP)
	db 8, -8, 16, $0
	db 8, 0, 16, (1 << OAM_X_FLIP)
	db 24, -16, 2, $0
	db -24, 8, 8, $0
	db -24, 16, 9, $0
	db -16, 8, 10, $0
	db -16, 16, 11, $0
	db -16, -16, 14, $0
	db -8, -16, 15, $0
	db -16, 8, 14, (1 << OAM_X_FLIP)
	db -8, 8, 15, (1 << OAM_X_FLIP)
	db -16, -8, 12, $0
	db -8, -8, 13, $0
	db -16, 0, 12, (1 << OAM_X_FLIP)
	db -8, 0, 13, (1 << OAM_X_FLIP)

.data_b519b
	db 13 ; size
	db 28, -20, 6, $0
	db 28, -12, 7, $0
	db 20, -20, 4, $0
	db 20, -12, 5, $0
	db -20, 12, 3, $0
	db -8, -24, 0, $0
	db 0, -24, 16, $0
	db -8, -16, 0, (1 << OAM_X_FLIP)
	db 0, -16, 16, (1 << OAM_X_FLIP)
	db -8, 8, 0, $0
	db 0, 8, 16, $0
	db -8, 16, 0, (1 << OAM_X_FLIP)
	db 0, 16, 16, (1 << OAM_X_FLIP)

.data_b51d0
	db 18 ; size
	db 0, 16, 0, $0
	db 0, 24, 0, (1 << OAM_X_FLIP)
	db -16, -32, 0, $0
	db -16, -24, 0, (1 << OAM_X_FLIP)
	db -8, -32, 16, $0
	db -8, -24, 16, (1 << OAM_X_FLIP)
	db 8, 16, 16, $0
	db 8, 24, 16, (1 << OAM_X_FLIP)
	db 20, -20, 8, $0
	db 20, -12, 9, $0
	db 28, -20, 10, $0
	db 28, -12, 11, $0
	db -16, -16, 1, $0
	db -7, -16, 17, $0
	db -16, 8, 1, (1 << OAM_X_FLIP)
	db -7, 8, 17, (1 << OAM_X_FLIP)
	db 0, -8, 19, $0
	db 0, 0, 19, (1 << OAM_X_FLIP)

.data_b5219
	db 9 ; size
	db 24, -16, 3, $0
	db -24, -24, 12, $0
	db -16, -24, 13, $0
	db -24, -16, 12, (1 << OAM_X_FLIP)
	db -16, -16, 13, (1 << OAM_X_FLIP)
	db 8, 8, 0, $0
	db 16, 8, 16, $0
	db 8, 16, 0, (1 << OAM_X_FLIP)
	db 16, 16, 16, (1 << OAM_X_FLIP)

.data_b523e
	db 12 ; size
	db 0, -14, 20, %001 | (1 << OAM_OBP_NUM)
	db 0, -6, 21, %001 | (1 << OAM_OBP_NUM)
	db 8, -14, 18, %001 | (1 << OAM_OBP_NUM)
	db -8, -14, 20, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -8, -6, 21, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -16, -14, 18, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -8, 6, 20, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, -2, 21, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, 6, 18, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, 6, 20, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, -2, 21, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 6, 18, %001 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

AnimData187::
	frame_table AnimFrameTable86
	frame_data 0, 8, 0, 0
	frame_data 1, 8, 0, 0
	frame_data 2, 8, 0, 0
	frame_data 3, 8, 0, 0
	frame_data 4, 8, 0, 0
	frame_data 5, 8, 0, 0
	frame_data 6, 8, 0, 0
	frame_data 7, 8, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable86::
	dw .data_b52a8
	dw .data_b52d9
	dw .data_b52fe
	dw .data_b533b
	dw .data_b5370
	dw .data_b53b5
	dw .data_b53ea
	dw .data_b5433
	dw .data_b5458

.data_b52a8
	db 12 ; size
	db -8, -8, 0, $0
	db -8, 0, 0, (1 << OAM_X_FLIP)
	db 0, -8, 16, $0
	db 0, 0, 16, (1 << OAM_X_FLIP)
	db -16, -16, 14, $0
	db -8, -16, 15, $0
	db -16, 8, 14, (1 << OAM_X_FLIP)
	db -8, 8, 15, (1 << OAM_X_FLIP)
	db -24, -8, 12, $0
	db -16, -8, 13, $0
	db -24, 0, 12, (1 << OAM_X_FLIP)
	db -16, 0, 13, (1 << OAM_X_FLIP)

.data_b52d9
	db 9 ; size
	db -19, 11, 3, $0
	db -8, -24, 0, $0
	db 0, -24, 16, $0
	db -8, -16, 0, (1 << OAM_X_FLIP)
	db 0, -16, 16, (1 << OAM_X_FLIP)
	db -8, 8, 0, $0
	db 0, 8, 16, $0
	db -8, 16, 0, (1 << OAM_X_FLIP)
	db 0, 16, 16, (1 << OAM_X_FLIP)

.data_b52fe
	db 15 ; size
	db 0, 16, 0, $0
	db 0, 24, 0, (1 << OAM_X_FLIP)
	db 8, 16, 16, $0
	db 8, 24, 16, (1 << OAM_X_FLIP)
	db -19, 11, 2, $0
	db -16, -16, 1, $0
	db -7, -16, 17, $0
	db -16, 8, 1, (1 << OAM_X_FLIP)
	db -7, 8, 17, (1 << OAM_X_FLIP)
	db -16, -32, 0, $0
	db -8, -32, 16, $0
	db -16, -24, 0, (1 << OAM_X_FLIP)
	db -8, -24, 16, (1 << OAM_X_FLIP)
	db 0, -8, 19, $0
	db 0, 0, 19, (1 << OAM_X_FLIP)

.data_b533b
	db 13 ; size
	db -22, 7, 4, $0
	db -22, 15, 5, $0
	db -14, 7, 6, $0
	db -14, 15, 7, $0
	db 24, -16, 3, $0
	db -16, -24, 12, $0
	db -8, -24, 13, $0
	db -16, -16, 12, (1 << OAM_X_FLIP)
	db -8, -16, 13, (1 << OAM_X_FLIP)
	db 8, 8, 0, $0
	db 16, 8, 16, $0
	db 8, 16, 0, (1 << OAM_X_FLIP)
	db 16, 16, 16, (1 << OAM_X_FLIP)

.data_b5370
	db 17 ; size
	db 0, -8, 0, $0
	db 0, 0, 0, (1 << OAM_X_FLIP)
	db 8, -8, 16, $0
	db 8, 0, 16, (1 << OAM_X_FLIP)
	db 24, -16, 2, $0
	db -24, 8, 8, $0
	db -24, 16, 9, $0
	db -16, 8, 10, $0
	db -16, 16, 11, $0
	db -16, -16, 14, $0
	db -8, -16, 15, $0
	db -16, 8, 14, (1 << OAM_X_FLIP)
	db -8, 8, 15, (1 << OAM_X_FLIP)
	db -16, -8, 12, $0
	db -8, -8, 13, $0
	db -16, 0, 12, (1 << OAM_X_FLIP)
	db -8, 0, 13, (1 << OAM_X_FLIP)

.data_b53b5
	db 13 ; size
	db 28, -20, 6, $0
	db 28, -12, 7, $0
	db 20, -20, 4, $0
	db 20, -12, 5, $0
	db -20, 12, 3, $0
	db -8, -24, 0, $0
	db 0, -24, 16, $0
	db -8, -16, 0, (1 << OAM_X_FLIP)
	db 0, -16, 16, (1 << OAM_X_FLIP)
	db -8, 8, 0, $0
	db 0, 8, 16, $0
	db -8, 16, 0, (1 << OAM_X_FLIP)
	db 0, 16, 16, (1 << OAM_X_FLIP)

.data_b53ea
	db 18 ; size
	db 0, 16, 0, $0
	db 0, 24, 0, (1 << OAM_X_FLIP)
	db -16, -32, 0, $0
	db -16, -24, 0, (1 << OAM_X_FLIP)
	db -8, -32, 16, $0
	db -8, -24, 16, (1 << OAM_X_FLIP)
	db 8, 16, 16, $0
	db 8, 24, 16, (1 << OAM_X_FLIP)
	db 20, -20, 8, $0
	db 20, -12, 9, $0
	db 28, -20, 10, $0
	db 28, -12, 11, $0
	db -16, -16, 1, $0
	db -7, -16, 17, $0
	db -16, 8, 1, (1 << OAM_X_FLIP)
	db -7, 8, 17, (1 << OAM_X_FLIP)
	db 0, -8, 19, $0
	db 0, 0, 19, (1 << OAM_X_FLIP)

.data_b5433
	db 9 ; size
	db 24, -16, 3, $0
	db -24, -24, 12, $0
	db -16, -24, 13, $0
	db -24, -16, 12, (1 << OAM_X_FLIP)
	db -16, -16, 13, (1 << OAM_X_FLIP)
	db 8, 8, 0, $0
	db 16, 8, 16, $0
	db 8, 16, 0, (1 << OAM_X_FLIP)
	db 16, 16, 16, (1 << OAM_X_FLIP)

.data_b5458
	db 12 ; size
	db 0, -6, 21, (1 << OAM_OBP_NUM)
	db 0, -14, 20, (1 << OAM_OBP_NUM)
	db 8, -14, 18, (1 << OAM_OBP_NUM)
	db -8, -6, 21, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -8, -14, 20, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -16, -14, 18, (1 << OAM_OBP_NUM) | (1 << OAM_Y_FLIP)
	db -8, -2, 21, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -8, 6, 20, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db -16, 6, 18, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP)
	db 0, -2, 21, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 0, 6, 20, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 6, 18, (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

AnimData191::
	frame_table AnimFrameTable89
	frame_data 0, 37, 0, 0
	frame_data -1, 26, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable89::
	dw .data_b549a

.data_b549a
	db 20 ; size
	db -2, -5, 0, $0
	db -2, 3, 1, $0
	db -2, 19, 3, $0
	db -2, 27, 4, $0
	db -2, 11, 2, $0
	db 6, -5, 5, $0
	db 6, 3, 6, $0
	db 6, 11, 7, $0
	db 6, 19, 8, $0
	db 6, 27, 9, $0
	db -2, 41, 10, $0
	db -2, 49, 11, $0
	db -2, 57, 12, $0
	db -2, 65, 13, $0
	db -2, 73, 14, $0
	db 6, 41, 15, $0
	db 6, 49, 16, $0
	db 6, 73, 19, $0
	db 6, 65, 18, $0
	db 6, 57, 17, $0

AnimData192::
	frame_table AnimFrameTable90
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable90::
	dw .data_b5658

.data_b5658
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData193::
	frame_table AnimFrameTable90
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData194::
	frame_table AnimFrameTable91
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable91::
	dw .data_b59b9

.data_b59b9
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData195::
	frame_table AnimFrameTable91
	frame_data 0, 22, 0, 0
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData197::
	frame_table AnimFrameTable92
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable92::
	dw .data_b5cbe

.data_b5cbe
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData198::
	frame_table AnimFrameTable92
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -1, -2
	frame_data 0, 17, -2, -1
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData199::
	frame_table AnimFrameTable92
	frame_data 0, 1, -3, 0
	frame_data 0, 1, -3, 0
	frame_data 0, 1, -3, 0
	frame_data 0, 1, -3, 0
	frame_data 0, 1, -3, 0
	frame_data 0, 1, -1, 0
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData200::
	frame_table AnimFrameTable93
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable93::
	dw .data_b5ffa

.data_b5ffa
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData201::
	frame_table AnimFrameTable93
	frame_data 0, 22, 0, 0
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData202::
	frame_table AnimFrameTable93
	frame_data 0, 1, -3, 2
	frame_data 0, 1, -3, 1
	frame_data 0, 1, -3, 2
	frame_data 0, 1, -3, 1
	frame_data 0, 1, -3, 2
	frame_data 0, 1, -3, 1
	frame_data 0, 1, -3, 2
	frame_data 0, 1, -3, 1
	frame_data 0, 1, -3, 2
	frame_data 0, 1, -3, 1
	frame_data 0, 1, -3, 2
	frame_data 0, 1, -3, 1
	frame_data 0, 1, -3, 2
	frame_data 0, 1, -3, 1
	frame_data 0, 1, -3, 2
	frame_data 0, 1, -3, 1
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData203::
	frame_table AnimFrameTable94
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable94::
	dw .data_b629a

.data_b629a
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData204::
	frame_table AnimFrameTable94
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData205::
	frame_table AnimFrameTable94
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 1, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData206::
	frame_table AnimFrameTable95
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable95::
	dw .data_b65a6

.data_b65a6
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData207::
	frame_table AnimFrameTable95
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData208::
	frame_table AnimFrameTable95
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, 1, -1, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData209::
	frame_table AnimFrameTable96
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable96::
	dw .data_b6922

.data_b6922
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData210::
	frame_table AnimFrameTable96
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -2
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -2
	frame_data 0, 17, 2, -1
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData211::
	frame_table AnimFrameTable96
	frame_data 0, 1, 3, 0
	frame_data 0, 1, 3, 0
	frame_data 0, 1, 3, 0
	frame_data 0, 1, 3, 0
	frame_data 0, 1, 3, 0
	frame_data 0, 1, 1, 0
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData212::
	frame_table AnimFrameTable97
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable97::
	dw .data_b6bd6

.data_b6bd6
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData213::
	frame_table AnimFrameTable97
	frame_data 0, 22, 0, 0
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, 1, 0, -2
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData214::
	frame_table AnimFrameTable97
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 3
	frame_data 0, 1, 0, 1
	frame_data 0, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimData215::
	frame_table AnimFrameTable98
	frame_data 0, 1, 2, 16
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 1, 1
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 1, 1
	frame_data 0, 1, 1, 1
	frame_data 0, 1, 1, 1
	frame_data 0, 1, 1, 1
	frame_data 0, 1, 1, 1
	frame_data 0, 1, 1, 1
	frame_data 0, 1, 1, 1
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, -1, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, -1, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, -1, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 2
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 2
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0

AnimFrameTable98::
	dw .data_b7056

.data_b7056
	db 4 ; size
	db 0, 0, 0, $0
	db 0, 8, 1, $0
	db 8, 0, 2, $0
	db 8, 8, 3, $0

AnimData216::
	frame_table AnimFrameTable98
	frame_data 0, 1, 2, 48
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 1, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, -1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 0
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 2
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 2, 1
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 1, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, -1, 1
	frame_data 0, 1, 0, 2
	frame_data 0, 1, 0, 2
	frame_data 0, 1, -1, 1
	frame_data 0, 1, 0, 2
	frame_data 0, 1, -1, 1
	frame_data 0, 1, 0, 1
	frame_data 0, 1, -1, 2
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 2
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -1, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -2, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -2, 0
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data 0, 1, -1, -1
	frame_data -1, -1, 0, 0
	frame_data 0, 0, 0, 0
