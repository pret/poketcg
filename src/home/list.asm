; Save a pointer to a list, given at de, to wListPointer
SetListPointer: ; 0c6c (0:0c6c)
	push hl
	ld hl, wListPointer
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	ret

; Return the current element of the list at wListPointer,
; and advance the list to the next element
GetNextElementOfList: ; 0c75 (0:0c75)
	push hl
	push de
	ld hl, wListPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	inc de
;	fallthrough

SetListToNextPosition: ; 0c7f (0:0c7f)
	ld [hl], d
	dec hl
	ld [hl], e
	pop de
	pop hl
	ret

; Set the current element of the list at wListPointer to a,
; and advance the list to the next element
SetNextElementOfList: ; 0c85 (0:0c85)
	push hl
	push de
	ld hl, wListPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld [de], a
	inc de
	jr SetListToNextPosition
