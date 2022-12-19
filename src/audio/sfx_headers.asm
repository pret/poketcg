NumberOfSFX:
	db $60

SFXHeaderPointers:
	table_width 2, SFXHeaderPointers
	dw SfxStop
	dw Sfx01
	dw Sfx02
	dw Sfx03
	dw Sfx04
	dw Sfx05
	dw Sfx06
	dw Sfx07
	dw Sfx08
	dw Sfx09
	dw Sfx0a
	dw Sfx0b
	dw Sfx0c
	dw Sfx0d
	dw Sfx0e
	dw Sfx0f
	dw Sfx10
	dw Sfx11
	dw Sfx12
	dw Sfx13
	dw Sfx14
	dw Sfx15
	dw Sfx16
	dw Sfx17
	dw Sfx18
	dw Sfx19
	dw Sfx1a
	dw Sfx1b
	dw Sfx1c
	dw Sfx1d
	dw Sfx1e
	dw Sfx1f
	dw Sfx20
	dw Sfx21
	dw Sfx22
	dw Sfx23
	dw Sfx24
	dw Sfx25
	dw Sfx26
	dw Sfx27
	dw Sfx28
	dw Sfx29
	dw Sfx2a
	dw Sfx2b
	dw Sfx2c
	dw Sfx2d
	dw Sfx2e
	dw Sfx2f
	dw Sfx30
	dw Sfx31
	dw Sfx32
	dw Sfx33
	dw Sfx34
	dw Sfx35
	dw Sfx36
	dw Sfx37
	dw Sfx38
	dw Sfx39
	dw Sfx3a
	dw Sfx3b
	dw Sfx3c
	dw Sfx3d
	dw Sfx3e
	dw Sfx3f
	dw Sfx40
	dw Sfx41
	dw Sfx42
	dw Sfx43
	dw Sfx44
	dw Sfx45
	dw Sfx46
	dw Sfx47
	dw Sfx48
	dw Sfx49
	dw Sfx4a
	dw Sfx4b
	dw Sfx4c
	dw Sfx4d
	dw Sfx4e
	dw Sfx4f
	dw Sfx50
	dw Sfx51
	dw Sfx52
	dw Sfx53
	dw Sfx54
	dw Sfx55
	dw Sfx56
	dw Sfx57
	dw Sfx58
	dw Sfx59
	dw Sfx5a
	dw Sfx5b
	dw Sfx5c
	dw Sfx5d
	dw Sfx5e
	dw Sfx5f
	assert_table_length NUM_SFX

SfxStop:
	db %0000

Sfx01:
	db %0010
	dw Sfx01_Ch1

Sfx02:
	db %0010
	dw Sfx02_Ch1

Sfx03:
	db %0010
	dw Sfx03_Ch1

Sfx04:
	db %0010
	dw Sfx04_Ch1

Sfx05:
	db %0010
	dw Sfx05_Ch1

Sfx06:
	db %0010
	dw Sfx06_Ch1

Sfx07:
	db %1000
	dw Sfx07_Ch1

Sfx08:
	db %1000
	dw Sfx08_Ch1

Sfx09:
	db %1000
	dw Sfx09_Ch1

Sfx0a:
	db %0010
	dw Sfx0a_Ch1

Sfx0b:
	db %0010
	dw Sfx0b_Ch1

Sfx0c:
	db %1000
	dw Sfx0c_Ch1

Sfx0d:
	db %0010
	dw Sfx0d_Ch1

Sfx0e:
	db %0010
	dw Sfx0e_Ch1

Sfx0f:
	db %1000
	dw Sfx0f_Ch1

Sfx10:
	db %0010
	dw Sfx10_Ch1

Sfx11:
	db %0010
	dw Sfx11_Ch1

Sfx12:
	db %0010
	dw Sfx12_Ch1

Sfx13:
	db %0010
	dw Sfx13_Ch1

Sfx14:
	db %0010
	dw Sfx14_Ch1

Sfx15:
	db %0010
	dw Sfx15_Ch1

Sfx16:
	db %1000
	dw Sfx16_Ch1

Sfx17:
	db %1000
	dw Sfx17_Ch1

Sfx18:
	db %1000
	dw Sfx18_Ch1

Sfx19:
	db %1000
	dw Sfx19_Ch1

Sfx1a:
	db %1000
	dw Sfx1a_Ch1

Sfx1b:
	db %1000
	dw Sfx1b_Ch1

Sfx1c:
	db %1000
	dw Sfx1c_Ch1

Sfx1d:
	db %1000
	dw Sfx1d_Ch1

Sfx1e:
	db %1000
	dw Sfx1e_Ch1

Sfx1f:
	db %1000
	dw Sfx1f_Ch1

Sfx20:
	db %1000
	dw Sfx20_Ch1

Sfx21:
	db %1000
	dw Sfx21_Ch1

Sfx22:
	db %1000
	dw Sfx22_Ch1

Sfx23:
	db %1000
	dw Sfx23_Ch1

Sfx24:
	db %1000
	dw Sfx24_Ch1

Sfx25:
	db %0010
	dw Sfx25_Ch1

Sfx26:
	db %0010
	dw Sfx26_Ch1

Sfx27:
	db %0010
	dw Sfx27_Ch1

Sfx28:
	db %1010
	dw Sfx28_Ch1
	dw Sfx28_Ch2

Sfx29:
	db %1000
	dw Sfx29_Ch1

Sfx2a:
	db %1000
	dw Sfx2a_Ch1

Sfx2b:
	db %0010
	dw Sfx2b_Ch1

Sfx2c:
	db %0010
	dw Sfx2c_Ch1

Sfx2d:
	db %1000
	dw Sfx2d_Ch1

Sfx2e:
	db %1000
	dw Sfx2e_Ch1

Sfx2f:
	db %1000
	dw Sfx2f_Ch1

Sfx30:
	db %1000
	dw Sfx30_Ch1

Sfx31:
	db %0010
	dw Sfx31_Ch1

Sfx32:
	db %1010
	dw Sfx32_Ch1
	dw Sfx32_Ch2

Sfx33:
	db %1010
	dw Sfx33_Ch1
	dw Sfx33_Ch2

Sfx34:
	db %0010
	dw Sfx34_Ch1

Sfx35:
	db %1000
	dw Sfx35_Ch1

Sfx36:
	db %0010
	dw Sfx36_Ch1

Sfx37:
	db %1010
	dw Sfx37_Ch1
	dw Sfx37_Ch2

Sfx38:
	db %0010
	dw Sfx38_Ch1

Sfx39:
	db %1010
	dw Sfx39_Ch1
	dw Sfx39_Ch2

Sfx3a:
	db %0010
	dw Sfx3a_Ch1

Sfx3b:
	db %0010
	dw Sfx3b_Ch1

Sfx3c:
	db %0010
	dw Sfx3c_Ch1

Sfx3d:
	db %0010
	dw Sfx3d_Ch1

Sfx3e:
	db %0010
	dw Sfx3e_Ch1

Sfx3f:
	db %1000
	dw Sfx3f_Ch1

Sfx40:
	db %0010
	dw Sfx40_Ch1

Sfx41:
	db %0010
	dw Sfx41_Ch1

Sfx42:
	db %0010
	dw Sfx42_Ch1

Sfx43:
	db %1000
	dw Sfx43_Ch1

Sfx44:
	db %1000
	dw Sfx44_Ch1

Sfx45:
	db %0010
	dw Sfx45_Ch1

Sfx46:
	db %0010
	dw Sfx46_Ch1

Sfx47:
	db %1000
	dw Sfx47_Ch1

Sfx48:
	db %1000
	dw Sfx48_Ch1

Sfx49:
	db %0010
	dw Sfx49_Ch1

Sfx4a:
	db %0010
	dw Sfx4a_Ch1

Sfx4b:
	db %1000
	dw Sfx4b_Ch1

Sfx4c:
	db %0010
	dw Sfx4c_Ch1

Sfx4d:
	db %0010
	dw Sfx4d_Ch1

Sfx4e:
	db %0010
	dw Sfx4e_Ch1

Sfx4f:
	db %0010
	dw Sfx4f_Ch1

Sfx50:
	db %1010
	dw Sfx50_Ch1
	dw Sfx50_Ch2

Sfx51:
	db %1010
	dw Sfx51_Ch1
	dw Sfx51_Ch2

Sfx52:
	db %1010
	dw Sfx52_Ch1
	dw Sfx52_Ch2

Sfx53:
	db %1010
	dw Sfx53_Ch1
	dw Sfx53_Ch2

Sfx54:
	db %0010
	dw Sfx54_Ch1

Sfx55:
	db %0010
	dw Sfx55_Ch1

Sfx56:
	db %0010
	dw Sfx56_Ch1

Sfx57:
	db %0010
	dw Sfx57_Ch1

Sfx58:
	db %0010
	dw Sfx58_Ch1

Sfx59:
	db %0010
	dw Sfx59_Ch1

Sfx5a:
	db %0010
	dw Sfx5a_Ch1

Sfx5b:
	db %0010
	dw Sfx5b_Ch1

Sfx5c:
	db %1000
	dw Sfx5c_Ch1

Sfx5d:
	db %1011
	dw Sfx5d_Ch1
	dw Sfx5d_Ch2
	dw Sfx5d_Ch3

Sfx5e:
	db %0010
	dw Sfx5e_Ch1

Sfx5f:
	db %1000
	dw Sfx5f_Ch1
