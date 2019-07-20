NumberOfSFX: ; fc290 (3f:4290)
	db $60

SFXHeaderPointers: ; fc291 (3f:4291)
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

SfxStop: ; fc351 (3f:4351)
	db %0000

Sfx01: ; fc352 (3f:4352)
	db %0010
	dw Sfx01_Ch1

Sfx02: ; fc355 (3f:4355)
	db %0010
	dw Sfx02_Ch1

Sfx03: ; fc358 (3f:4358)
	db %0010
	dw Sfx03_Ch1

Sfx04: ; fc35b (3f:435b)
	db %0010
	dw Sfx04_Ch1

Sfx05: ; fc35e (3f:435e)
	db %0010
	dw Sfx05_Ch1

Sfx06: ; fc361 (3f:4361)
	db %0010
	dw Sfx06_Ch1

Sfx07: ; fc364 (3f:4364)
	db %1000
	dw Sfx07_Ch1

Sfx08: ; fc367 (3f:4367)
	db %1000
	dw Sfx08_Ch1

Sfx09: ; fc36a (3f:436a)
	db %1000
	dw Sfx09_Ch1

Sfx0a: ; fc36d (3f:436d)
	db %0010
	dw Sfx0a_Ch1

Sfx0b: ; fc370 (3f:4370)
	db %0010
	dw Sfx0b_Ch1

Sfx0c: ; fc373 (3f:4373)
	db %1000
	dw Sfx0c_Ch1

Sfx0d: ; fc376 (3f:4376)
	db %0010
	dw Sfx0d_Ch1

Sfx0e: ; fc379 (3f:4379)
	db %0010
	dw Sfx0e_Ch1

Sfx0f: ; fc37c (3f:437c)
	db %1000
	dw Sfx0f_Ch1

Sfx10: ; fc37f (3f:437f)
	db %0010
	dw Sfx10_Ch1

Sfx11: ; fc382 (3f:4382)
	db %0010
	dw Sfx11_Ch1

Sfx12: ; fc385 (3f:4385)
	db %0010
	dw Sfx12_Ch1

Sfx13: ; fc388 (3f:4388)
	db %0010
	dw Sfx13_Ch1

Sfx14: ; fc38b (3f:438b)
	db %0010
	dw Sfx14_Ch1

Sfx15: ; fc38e (3f:438e)
	db %0010
	dw Sfx15_Ch1

Sfx16: ; fc391 (3f:4391)
	db %1000
	dw Sfx16_Ch1

Sfx17: ; fc394 (3f:4394)
	db %1000
	dw Sfx17_Ch1

Sfx18: ; fc397 (3f:4397)
	db %1000
	dw Sfx18_Ch1

Sfx19: ; fc39a (3f:439a)
	db %1000
	dw Sfx19_Ch1

Sfx1a: ; fc39d (3f:439d)
	db %1000
	dw Sfx1a_Ch1

Sfx1b: ; fc3a0 (3f:43a0)
	db %1000
	dw Sfx1b_Ch1

Sfx1c: ; fc3a3 (3f:43a3)
	db %1000
	dw Sfx1c_Ch1

Sfx1d: ; fc3a6 (3f:43a6)
	db %1000
	dw Sfx1d_Ch1

Sfx1e: ; fc3a9 (3f:43a9)
	db %1000
	dw Sfx1e_Ch1

Sfx1f: ; fc3ac (3f:43ac)
	db %1000
	dw Sfx1f_Ch1

Sfx20: ; fc3af (3f:43af)
	db %1000
	dw Sfx20_Ch1

Sfx21: ; fc3b2 (3f:43b2)
	db %1000
	dw Sfx21_Ch1

Sfx22: ; fc3b5 (3f:43b5)
	db %1000
	dw Sfx22_Ch1

Sfx23: ; fc3b8 (3f:43b8)
	db %1000
	dw Sfx23_Ch1

Sfx24: ; fc3bb (3f:43bb)
	db %1000
	dw Sfx24_Ch1

Sfx25: ; fc3be (3f:43be)
	db %0010
	dw Sfx25_Ch1

Sfx26: ; fc3c1 (3f:43c1)
	db %0010
	dw Sfx26_Ch1

Sfx27: ; fc3c4 (3f:43c4)
	db %0010
	dw Sfx27_Ch1

Sfx28: ; fc3c7 (3f:43c7)
	db %1010
	dw Sfx28_Ch1
	dw Sfx28_Ch2

Sfx29: ; fc3cc (3f:43cc)
	db %1000
	dw Sfx29_Ch1

Sfx2a: ; fc3cf (3f:43cf)
	db %1000
	dw Sfx2a_Ch1

Sfx2b: ; fc3d2 (3f:43d2)
	db %0010
	dw Sfx2b_Ch1

Sfx2c: ; fc3d5 (3f:43d5)
	db %0010
	dw Sfx2c_Ch1

Sfx2d: ; fc3d8 (3f:43d8)
	db %1000
	dw Sfx2d_Ch1

Sfx2e: ; fc3db (3f:43db)
	db %1000
	dw Sfx2e_Ch1

Sfx2f: ; fc3de (3f:43de)
	db %1000
	dw Sfx2f_Ch1

Sfx30: ; fc3e1 (3f:43e1)
	db %1000
	dw Sfx30_Ch1

Sfx31: ; fc3e4 (3f:43e4)
	db %0010
	dw Sfx31_Ch1

Sfx32: ; fc3e7 (3f:43e7)
	db %1010
	dw Sfx32_Ch1
	dw Sfx32_Ch2

Sfx33: ; fc3ec (3f:43ec)
	db %1010
	dw Sfx33_Ch1
	dw Sfx33_Ch2

Sfx34: ; fc3f1 (3f:43f1)
	db %0010
	dw Sfx34_Ch1

Sfx35: ; fc3f4 (3f:43f4)
	db %1000
	dw Sfx35_Ch1

Sfx36: ; fc3f7 (3f:43f7)
	db %0010
	dw Sfx36_Ch1

Sfx37: ; fc3fa (3f:43fa)
	db %1010
	dw Sfx37_Ch1
	dw Sfx37_Ch2

Sfx38: ; fc3ff (3f:43ff)
	db %0010
	dw Sfx38_Ch1

Sfx39: ; fc402 (3f:4402)
	db %1010
	dw Sfx39_Ch1
	dw Sfx39_Ch2

Sfx3a: ; fc407 (3f:4407)
	db %0010
	dw Sfx3a_Ch1

Sfx3b: ; fc40a (3f:440a)
	db %0010
	dw Sfx3b_Ch1

Sfx3c: ; fc40d (3f:440d)
	db %0010
	dw Sfx3c_Ch1

Sfx3d: ; fc410 (3f:4410)
	db %0010
	dw Sfx3d_Ch1

Sfx3e: ; fc413 (3f:4413)
	db %0010
	dw Sfx3e_Ch1

Sfx3f: ; fc416 (3f:4416)
	db %1000
	dw Sfx3f_Ch1

Sfx40: ; fc419 (3f:4419)
	db %0010
	dw Sfx40_Ch1

Sfx41: ; fc41c (3f:441c)
	db %0010
	dw Sfx41_Ch1

Sfx42: ; fc41f (3f:441f)
	db %0010
	dw Sfx42_Ch1

Sfx43: ; fc422 (3f:4422)
	db %1000
	dw Sfx43_Ch1

Sfx44: ; fc425 (3f:4425)
	db %1000
	dw Sfx44_Ch1

Sfx45: ; fc428 (3f:4428)
	db %0010
	dw Sfx45_Ch1

Sfx46: ; fc42b (3f:442b)
	db %0010
	dw Sfx46_Ch1

Sfx47: ; fc42e (3f:442e)
	db %1000
	dw Sfx47_Ch1

Sfx48: ; fc431 (3f:4431)
	db %1000
	dw Sfx48_Ch1

Sfx49: ; fc434 (3f:4434)
	db %0010
	dw Sfx49_Ch1

Sfx4a: ; fc437 (3f:4437)
	db %0010
	dw Sfx4a_Ch1

Sfx4b: ; fc43a (3f:443a)
	db %1000
	dw Sfx4b_Ch1

Sfx4c: ; fc43d (3f:443d)
	db %0010
	dw Sfx4c_Ch1

Sfx4d: ; fc440 (3f:4440)
	db %0010
	dw Sfx4d_Ch1

Sfx4e: ; fc443 (3f:4443)
	db %0010
	dw Sfx4e_Ch1

Sfx4f: ; fc446 (3f:4446)
	db %0010
	dw Sfx4f_Ch1

Sfx50: ; fc449 (3f:4449)
	db %1010
	dw Sfx50_Ch1
	dw Sfx50_Ch2

Sfx51: ; fc44e (3f:444e)
	db %1010
	dw Sfx51_Ch1
	dw Sfx51_Ch2

Sfx52: ; fc453 (3f:4453)
	db %1010
	dw Sfx52_Ch1
	dw Sfx52_Ch2

Sfx53: ; fc458 (3f:4458)
	db %1010
	dw Sfx53_Ch1
	dw Sfx53_Ch2

Sfx54: ; fc45d (3f:445d)
	db %0010
	dw Sfx54_Ch1

Sfx55: ; fc460 (3f:4460)
	db %0010
	dw Sfx55_Ch1

Sfx56: ; fc463 (3f:4463)
	db %0010
	dw Sfx56_Ch1

Sfx57: ; fc466 (3f:4466)
	db %0010
	dw Sfx57_Ch1

Sfx58: ; fc469 (3f:4469)
	db %0010
	dw Sfx58_Ch1

Sfx59: ; fc46c (3f:446c)
	db %0010
	dw Sfx59_Ch1

Sfx5a: ; fc46f (3f:446f)
	db %0010
	dw Sfx5a_Ch1

Sfx5b: ; fc472 (3f:4472)
	db %0010
	dw Sfx5b_Ch1

Sfx5c: ; fc475 (3f:4475)
	db %1000
	dw Sfx5c_Ch1

Sfx5d: ; fc478 (3f:4478)
	db %1011
	dw Sfx5d_Ch1
	dw Sfx5d_Ch2
	dw Sfx5d_Ch3

Sfx5e: ; fc47f (3f:447f)
	db %0010
	dw Sfx5e_Ch1

Sfx5f: ; fc482 (3f:4482)
	db %1000
	dw Sfx5f_Ch1
