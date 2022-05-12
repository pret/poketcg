PracticeDuelTextPointerTable:
	dw PracticeDuelText_Turn1
	dw PracticeDuelText_Turn2
	dw PracticeDuelText_Turn3
	dw PracticeDuelText_Turn4
	dw PracticeDuelText_Turn5
	dw PracticeDuelText_Turn6
	dw PracticeDuelText_Turn7
	dw PracticeDuelText_Turn8

MACRO practicetext
	db \1 ; Y coord to place the point-by-point instruction
	tx \2 ; Dr. Mason's instruction
	tx \3 ; static point-by-point instruction
ENDM

PracticeDuelText_Turn1:
	practicetext 2, Turn1DrMason1PracticeDuelText, Turn1Instr1PracticeDuelText
	practicetext 5, Turn1DrMason2PracticeDuelText, Turn1Instr2PracticeDuelText
	practicetext 8, Turn1DrMason3PracticeDuelText, Turn1Instr3PracticeDuelText
	db $00

PracticeDuelText_Turn2:
	practicetext 2, Turn2DrMason1PracticeDuelText, Turn2Instr1PracticeDuelText
	practicetext 5, Turn2DrMason2PracticeDuelText, Turn2Instr2PracticeDuelText
	practicetext 8, Turn2DrMason3PracticeDuelText, Turn2Instr3PracticeDuelText
	db $00

PracticeDuelText_Turn3:
	practicetext 2, Turn3DrMason1PracticeDuelText, Turn3Instr1PracticeDuelText
	practicetext 5, Turn3DrMason2PracticeDuelText, Turn3Instr2PracticeDuelText
	practicetext 8, Turn3DrMason3PracticeDuelText, Turn3Instr3PracticeDuelText
	db $00

PracticeDuelText_Turn4:
	practicetext 2, Turn4DrMason1PracticeDuelText, Turn4Instr1PracticeDuelText
	practicetext 5, Turn4DrMason2PracticeDuelText, Turn4Instr2PracticeDuelText
	practicetext 8, Turn4DrMason3PracticeDuelText, Turn4Instr3PracticeDuelText
	db $00

PracticeDuelText_Turn5:
	practicetext 2, Turn5DrMason1PracticeDuelText, Turn5Instr1PracticeDuelText
	practicetext 6, Turn5DrMason2PracticeDuelText, Turn5Instr2PracticeDuelText
	db $00

PracticeDuelText_Turn6:
	practicetext 2, Turn6DrMason1PracticeDuelText, Turn6Instr1PracticeDuelText
	practicetext 5, Turn6DrMason2PracticeDuelText, Turn6Instr2PracticeDuelText
	practicetext 8, Turn6DrMason3PracticeDuelText, Turn6Instr3PracticeDuelText
	db $00

PracticeDuelText_Turn7:
	practicetext 2, Turn7DrMason1PracticeDuelText, Turn7Instr1PracticeDuelText
	practicetext 5, Turn7DrMason2PracticeDuelText, Turn7Instr2PracticeDuelText
	db $00

PracticeDuelText_Turn8:
	practicetext 2, Turn8DrMason1PracticeDuelText, Turn8Instr1PracticeDuelText
	practicetext 5, Turn8DrMason2PracticeDuelText, Turn8Instr2PracticeDuelText
	db $00

; on player's Seaking knocked out
PracticeDuelText_SamTurn4:
	practicetext 2, SamTurn4DrMason1PracticeDuelText, SamTurn4Instr1PracticeDuelText
	practicetext 7, SamTurn4DrMason2PracticeDuelText, SamTurn4Instr2PracticeDuelText
	db $00
