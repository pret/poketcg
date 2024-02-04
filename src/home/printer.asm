; send printer packet:
; - d = PRINTERPKT_* constant
; - e = in case of PRINTERPKT_DATA, whether it's compressed
; - bc = number of bytes in data
SendPrinterPacket::
	push hl
	ld hl, wPrinterPacket
	; Preamble
	ld a, $88
	ld [hli], a          ; [wPrinterPacketPreamble + 0] ← $88
	ld a, $33
	ld [hli], a          ; [wPrinterPacketPreamble + 1] ← $33

	; Header
	ld [hl], d           ; [wPrinterPacketInstructions + 0] ← d
	inc hl
	ld [hl], e           ; [wPrinterPacketInstructions + 1] ← e
	inc hl
	ld [hl], c           ; [wPrinterPacketDataSize + 0] ← c
	inc hl
	ld [hl], b           ; [wPrinterPacketDataSize + 1] ← b
	inc hl

	; Data pointer
	pop de
	ld [hl], e           ; [wPrinterPacketDataPtr + 0] ← l
	inc hl
	ld [hl], d           ; [wPrinterPacketDataPtr + 1] ← h
	inc hl
	ld de, -$bb
	ld [hl], e           ; [wPrinterPacketChecksum + 0] ← $45
	inc hl
	ld [hl], d           ; [wPrinterPacketChecksum + 1] ← $ff

	ld hl, wSerialDataPtr
	ld [hl], LOW(wPrinterPacket)  ; [wSerialDataPtr] ← $64
	inc hl
	ld [hl], HIGH(wPrinterPacket) ; [wSerialDataPtr] ← $ce

	call Func_0e8e

	ld a, $1
	ld [wPrinterPacketSequence], a        ; [wPrinterPacketSequence] ← 1
	call SendNextPrinterPacketByte
.wait_printer_packet_transmission
	call DoFrame
	ld a, [wPrinterPacketSequence]
	or a
	jr nz, .wait_printer_packet_transmission
	call ResetSerial

	ld bc, 1500
.post_transmission_delay
	dec bc
	ld a, b
	or c
	jr nz, .post_transmission_delay

	; we expect printer to send $81
	; as the device number, any other value
	; means that a second device in connected
	ld a, [wSerialTransferData]
	cp $81
	jr nz, .unexpected_device_number
	ld a, [wPrinterStatus]
	ld l, a
	and $f1
	ld a, l
	ret z
	scf
	ret

.unexpected_device_number
	ld a, $ff
	ld [wPrinterStatus], a
	scf
	ret

; a = which sequence to execute
ExecutePrinterPacketSequence::
	ld hl, .SequencePointers
	dec a
	jp JumpToFunctionInTable

.SequencePointers:
	; each entry corresponds to value in wPrinterPacketSequence
	dw .SendPreambleOrHeaderByte   ; 1: send wPrinterPacketPreamble + 1
	dw .SendPreambleOrHeaderByte   ; 2: send wPrinterPacketInstructions + 0
	dw .SendPreambleOrHeaderByte   ; 3: send wPrinterPacketInstructions + 1
	dw .SendPreambleOrHeaderByte   ; 4: send wPrinterPacketDataSize + 0
	dw .SendPreambleOrHeaderByte   ; 5: send wPrinterPacketDataSize + 1
	dw .StartDataSection           ; 6
	dw .SendRestOfDataSection      ; 7
	dw .SendChecksumByte1          ; 8
	dw .SendChecksumByte2          ; 9
	dw .SendDummyByte              ; 10
	dw .GetDeviceNumber            ; 11
	dw .GetStatusAndFinishSequence ; 12

; send next byte and increment sequence
.SendPreambleOrHeaderByte:
	call SendNextPrinterPacketByte
.increment_sequence
	ld hl, wPrinterPacketSequence
	inc [hl]
	ret

; check if there is data to send
; if so, then update serial data pointer
; otherwise, skip sending data section
.StartDataSection:
	call .increment_sequence
	ld hl, wPrinterPacketDataSize
	ld a, [hli]
	or [hl]
	jr nz, .set_data_ptr
	; no data to send
	call .increment_sequence
	jr .SendChecksumByte1

.set_data_ptr
	ld hl, wPrinterPacketDataPtr
	ld de, wSerialDataPtr
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
;	fallthrough

; sends next byte in data section
; only increment sequence when
; there are no more bytes to send
.SendRestOfDataSection:
	call SendNextPrinterPacketByte
	ld hl, wPrinterPacketDataSize
	ld a, [hl]
	dec [hl]
	or a
	jr nz, .finish_data_section
	inc hl
	dec [hl]
	dec hl
.finish_data_section
	ld a, [hli]
	or [hl]
	jr z, .increment_sequence
	ret

; sends first byte of checksum
.SendChecksumByte1:
	ld a, [wPrinterPacketChecksum + 0]
.send_byte_and_increment_sequence
	call SendByteThroughSerialData
	jr .increment_sequence

; sends second byte of checksum
.SendChecksumByte2:
	ld a, [wPrinterPacketChecksum + 1]
	jr .send_byte_and_increment_sequence

; gets number of device, and sends a dummy byte
.GetDeviceNumber:
	ldh a, [rSB]
	ld [wSerialTransferData], a
;	fallthrough

; sends a dummy byte
.SendDummyByte:
	xor a
	jr .send_byte_and_increment_sequence

; gets the printer status, then finishes sequence
.GetStatusAndFinishSequence:
	ldh a, [rSB]
	ld [wPrinterStatus], a
	xor a
	ld [wPrinterPacketSequence], a
	ret

; sends byte pointed by wSerialDataPtr to printer
; then increments this pointer to point to next byte
; for next iteration, and adds byte value to checksum
SendNextPrinterPacketByte::
	ld hl, wSerialDataPtr
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ld e, a

	ld hl, wPrinterPacketChecksum
	add [hl]
	ld [hli], a
	ld a, $0
	adc [hl]
	ld [hl], a
	ld a, e
;	fallthrough

; a = byte to send through serial data transfer
SendByteThroughSerialData:
	ldh [rSB], a
	ld a, SC_INTERNAL
	ldh [rSC], a
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a
	ret
