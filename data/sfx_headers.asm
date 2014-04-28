NumberOfSFX: ; fc290 (3f:4290)
	db $60

SFXHeaderPointers: ; fc291 (3f:4291)
	dw SFX_Stop
	dw SFX_01
	dw SFX_02
	dw SFX_03
	dw SFX_04
	dw SFX_05
	dw SFX_06
	dw SFX_07
	dw SFX_08
	dw SFX_09
	dw SFX_0a
	dw SFX_0b
	dw SFX_0c
	dw SFX_0d
	dw SFX_0e
	dw SFX_0f
	dw SFX_10
	dw SFX_11
	dw SFX_12
	dw SFX_13
	dw SFX_14
	dw SFX_15
	dw SFX_16
	dw SFX_17
	dw SFX_18
	dw SFX_19
	dw SFX_1a
	dw SFX_1b
	dw SFX_1c
	dw SFX_1d
	dw SFX_1e
	dw SFX_1f
	dw SFX_20
	dw SFX_21
	dw SFX_22
	dw SFX_23
	dw SFX_24
	dw SFX_25
	dw SFX_26
	dw SFX_27
	dw SFX_28
	dw SFX_29
	dw SFX_2a
	dw SFX_2b
	dw SFX_2c
	dw SFX_2d
	dw SFX_2e
	dw SFX_2f
	dw SFX_30
	dw SFX_31
	dw SFX_32
	dw SFX_33
	dw SFX_34
	dw SFX_35
	dw SFX_36
	dw SFX_37
	dw SFX_38
	dw SFX_39
	dw SFX_3a
	dw SFX_3b
	dw SFX_3c
	dw SFX_3d
	dw SFX_3e
	dw SFX_3f
	dw SFX_40
	dw SFX_41
	dw SFX_42
	dw SFX_43
	dw SFX_44
	dw SFX_45
	dw SFX_46
	dw SFX_47
	dw SFX_48
	dw SFX_49
	dw SFX_4a
	dw SFX_4b
	dw SFX_4c
	dw SFX_4d
	dw SFX_4e
	dw SFX_4f
	dw SFX_50
	dw SFX_51
	dw SFX_52
	dw SFX_53
	dw SFX_54
	dw SFX_55
	dw SFX_56
	dw SFX_57
	dw SFX_58
	dw SFX_59
	dw SFX_5a
	dw SFX_5b
	dw SFX_5c
	dw SFX_5d
	dw SFX_5e
	dw SFX_5f

SFX_Stop: ; fc351 (3f:4351)
	db %0000

SFX_01: ; fc352 (3f:4352)
	db %0010
	dw SFX_01_Ch1

SFX_02: ; fc355 (3f:4355)
	db %0010
	dw SFX_02_Ch1

SFX_03: ; fc358 (3f:4358)
	db %0010
	dw SFX_03_Ch1

SFX_04: ; fc35b (3f:435b)
	db %0010
	dw SFX_04_Ch1

SFX_05: ; fc35e (3f:435e)
	db %0010
	dw SFX_05_Ch1

SFX_06: ; fc361 (3f:4361)
	db %0010
	dw SFX_06_Ch1

SFX_07: ; fc364 (3f:4364)
	db %1000
	dw SFX_07_Ch1

SFX_08: ; fc367 (3f:4367)
	db %1000
	dw SFX_08_Ch1

SFX_09: ; fc36a (3f:436a)
	db %1000
	dw SFX_09_Ch1

SFX_0a: ; fc36d (3f:436d)
	db %0010
	dw SFX_0a_Ch1

SFX_0b: ; fc370 (3f:4370)
	db %0010
	dw SFX_0b_Ch1

SFX_0c: ; fc373 (3f:4373)
	db %1000
	dw SFX_0c_Ch1

SFX_0d: ; fc376 (3f:4376)
	db %0010
	dw SFX_0d_Ch1

SFX_0e: ; fc379 (3f:4379)
	db %0010
	dw SFX_0e_Ch1

SFX_0f: ; fc37c (3f:437c)
	db %1000
	dw SFX_0f_Ch1

SFX_10: ; fc37f (3f:437f)
	db %0010
	dw SFX_10_Ch1

SFX_11: ; fc382 (3f:4382)
	db %0010
	dw SFX_11_Ch1

SFX_12: ; fc385 (3f:4385)
	db %0010
	dw SFX_12_Ch1

SFX_13: ; fc388 (3f:4388)
	db %0010
	dw SFX_13_Ch1

SFX_14: ; fc38b (3f:438b)
	db %0010
	dw SFX_14_Ch1

SFX_15: ; fc38e (3f:438e)
	db %0010
	dw SFX_15_Ch1

SFX_16: ; fc391 (3f:4391)
	db %1000
	dw SFX_16_Ch1

SFX_17: ; fc394 (3f:4394)
	db %1000
	dw SFX_17_Ch1

SFX_18: ; fc397 (3f:4397)
	db %1000
	dw SFX_18_Ch1

SFX_19: ; fc39a (3f:439a)
	db %1000
	dw SFX_19_Ch1

SFX_1a: ; fc39d (3f:439d)
	db %1000
	dw SFX_1a_Ch1

SFX_1b: ; fc3a0 (3f:43a0)
	db %1000
	dw SFX_1b_Ch1

SFX_1c: ; fc3a3 (3f:43a3)
	db %1000
	dw SFX_1c_Ch1

SFX_1d: ; fc3a6 (3f:43a6)
	db %1000
	dw SFX_1d_Ch1

SFX_1e: ; fc3a9 (3f:43a9)
	db %1000
	dw SFX_1e_Ch1

SFX_1f: ; fc3ac (3f:43ac)
	db %1000
	dw SFX_1f_Ch1

SFX_20: ; fc3af (3f:43af)
	db %1000
	dw SFX_20_Ch1

SFX_21: ; fc3b2 (3f:43b2)
	db %1000
	dw SFX_21_Ch1

SFX_22: ; fc3b5 (3f:43b5)
	db %1000
	dw SFX_22_Ch1

SFX_23: ; fc3b8 (3f:43b8)
	db %1000
	dw SFX_23_Ch1

SFX_24: ; fc3bb (3f:43bb)
	db %1000
	dw SFX_24_Ch1

SFX_25: ; fc3be (3f:43be)
	db %0010
	dw SFX_25_Ch1

SFX_26: ; fc3c1 (3f:43c1)
	db %0010
	dw SFX_26_Ch1

SFX_27: ; fc3c4 (3f:43c4)
	db %0010
	dw SFX_27_Ch1

SFX_28: ; fc3c7 (3f:43c7)
	db %1010
	dw SFX_28_Ch1
	dw SFX_28_Ch2

SFX_29: ; fc3cc (3f:43cc)
	db %1000
	dw SFX_29_Ch1

SFX_2a: ; fc3cf (3f:43cf)
	db %1000
	dw SFX_2a_Ch1

SFX_2b: ; fc3d2 (3f:43d2)
	db %0010
	dw SFX_2b_Ch1

SFX_2c: ; fc3d5 (3f:43d5)
	db %0010
	dw SFX_2c_Ch1

SFX_2d: ; fc3d8 (3f:43d8)
	db %1000
	dw SFX_2d_Ch1

SFX_2e: ; fc3db (3f:43db)
	db %1000
	dw SFX_2e_Ch1

SFX_2f: ; fc3de (3f:43de)
	db %1000
	dw SFX_2f_Ch1

SFX_30: ; fc3e1 (3f:43e1)
	db %1000
	dw SFX_30_Ch1

SFX_31: ; fc3e4 (3f:43e4)
	db %0010
	dw SFX_31_Ch1

SFX_32: ; fc3e7 (3f:43e7)
	db %1010
	dw SFX_32_Ch1
	dw SFX_32_Ch2

SFX_33: ; fc3ec (3f:43ec)
	db %1010
	dw SFX_33_Ch1
	dw SFX_33_Ch2

SFX_34: ; fc3f1 (3f:43f1)
	db %0010
	dw SFX_34_Ch1

SFX_35: ; fc3f4 (3f:43f4)
	db %1000
	dw SFX_35_Ch1

SFX_36: ; fc3f7 (3f:43f7)
	db %0010
	dw SFX_36_Ch1

SFX_37: ; fc3fa (3f:43fa)
	db %1010
	dw SFX_37_Ch1
	dw SFX_37_Ch2

SFX_38: ; fc3ff (3f:43ff)
	db %0010
	dw SFX_38_Ch1

SFX_39: ; fc402 (3f:4402)
	db %1010
	dw SFX_39_Ch1
	dw SFX_39_Ch2

SFX_3a: ; fc407 (3f:4407)
	db %0010
	dw SFX_3a_Ch1

SFX_3b: ; fc40a (3f:440a)
	db %0010
	dw SFX_3b_Ch1

SFX_3c: ; fc40d (3f:440d)
	db %0010
	dw SFX_3c_Ch1

SFX_3d: ; fc410 (3f:4410)
	db %0010
	dw SFX_3d_Ch1

SFX_3e: ; fc413 (3f:4413)
	db %0010
	dw SFX_3e_Ch1

SFX_3f: ; fc416 (3f:4416)
	db %1000
	dw SFX_3f_Ch1

SFX_40: ; fc419 (3f:4419)
	db %0010
	dw SFX_40_Ch1

SFX_41: ; fc41c (3f:441c)
	db %0010
	dw SFX_41_Ch1

SFX_42: ; fc41f (3f:441f)
	db %0010
	dw SFX_42_Ch1

SFX_43: ; fc422 (3f:4422)
	db %1000
	dw SFX_43_Ch1

SFX_44: ; fc425 (3f:4425)
	db %1000
	dw SFX_44_Ch1

SFX_45: ; fc428 (3f:4428)
	db %0010
	dw SFX_45_Ch1

SFX_46: ; fc42b (3f:442b)
	db %0010
	dw SFX_46_Ch1

SFX_47: ; fc42e (3f:442e)
	db %1000
	dw SFX_47_Ch1

SFX_48: ; fc431 (3f:4431)
	db %1000
	dw SFX_48_Ch1

SFX_49: ; fc434 (3f:4434)
	db %0010
	dw SFX_49_Ch1

SFX_4a: ; fc437 (3f:4437)
	db %0010
	dw SFX_4a_Ch1

SFX_4b: ; fc43a (3f:443a)
	db %1000
	dw SFX_4b_Ch1

SFX_4c: ; fc43d (3f:443d)
	db %0010
	dw SFX_4c_Ch1

SFX_4d: ; fc440 (3f:4440)
	db %0010
	dw SFX_4d_Ch1

SFX_4e: ; fc443 (3f:4443)
	db %0010
	dw SFX_4e_Ch1

SFX_4f: ; fc446 (3f:4446)
	db %0010
	dw SFX_4f_Ch1

SFX_50: ; fc449 (3f:4449)
	db %1010
	dw SFX_50_Ch1
	dw SFX_50_Ch2

SFX_51: ; fc44e (3f:444e)
	db %1010
	dw SFX_51_Ch1
	dw SFX_51_Ch2

SFX_52: ; fc453 (3f:4453)
	db %1010
	dw SFX_52_Ch1
	dw SFX_52_Ch2

SFX_53: ; fc458 (3f:4458)
	db %1010
	dw SFX_53_Ch1
	dw SFX_53_Ch2

SFX_54: ; fc45d (3f:445d)
	db %0010
	dw SFX_54_Ch1

SFX_55: ; fc460 (3f:4460)
	db %0010
	dw SFX_55_Ch1

SFX_56: ; fc463 (3f:4463)
	db %0010
	dw SFX_56_Ch1

SFX_57: ; fc466 (3f:4466)
	db %0010
	dw SFX_57_Ch1

SFX_58: ; fc469 (3f:4469)
	db %0010
	dw SFX_58_Ch1

SFX_59: ; fc46c (3f:446c)
	db %0010
	dw SFX_59_Ch1

SFX_5a: ; fc46f (3f:446f)
	db %0010
	dw SFX_5a_Ch1

SFX_5b: ; fc472 (3f:4472)
	db %0010
	dw SFX_5b_Ch1

SFX_5c: ; fc475 (3f:4475)
	db %1000
	dw SFX_5c_Ch1

SFX_5d: ; fc478 (3f:4478)
	db %1011
	dw SFX_5d_Ch1
	dw SFX_5d_Ch2
	dw SFX_5d_Ch3

SFX_5e: ; fc47f (3f:447f)
	db %0010
	dw SFX_5e_Ch1

SFX_5f: ; fc482 (3f:4482)
	db %1000
	dw SFX_5f_Ch1