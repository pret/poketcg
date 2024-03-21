; if carry flag is set, only delays
; if carry not set:
; - set rRP edge up, wait;
; - set rRP edge down, wait;
; - return
TransmitIRBit:
	jr c, .delay_once
	ld [hl], RPF_WRITE_HI | RPF_ENREAD
	ld a, 5
	jr .loop_delay_1 ; jump to possibly to add more cycles?
.loop_delay_1
	dec a
	jr nz, .loop_delay_1
	ld [hl], RPF_WRITE_LO | RPF_ENREAD
	ld a, 14
	jr .loop_delay_2 ; jump to possibly to add more cycles?
.loop_delay_2
	dec a
	jr nz, .loop_delay_2
	ret

.delay_once
	ld a, 21
	jr .loop_delay_3 ; jump to possibly to add more cycles?
.loop_delay_3
	dec a
	jr nz, .loop_delay_3
	nop
	ret

; input a = byte to transmit through IR
TransmitByteThroughIR:
	push hl
	ld hl, rRP
	push de
	push bc
	ld b, a
	scf  ; carry set
	call TransmitIRBit
	or a ; carry not set
	call TransmitIRBit
	ld c, 8
	ld c, 8 ; number of input bits
.loop
	ld a, $00
	rr b
	call TransmitIRBit
	dec c
	jr nz, .loop
	pop bc
	pop de
	pop hl
	ldh a, [rJOYP]
	bit 1, a ; P11
	jr z, ReturnZFlagUnsetAndCarryFlagSet
	xor a ; return z set
	ret

; same as ReceiveByteThroughIR but
; returns $0 in a if there's an error in IR
ReceiveByteThroughIR_ZeroIfUnsuccessful:
	call ReceiveByteThroughIR
	ret nc
	xor a
	ret

; returns carry if there's some time out
; and outputs $ff in register a
; otherwise returns in a some sequence of bits
; related to how rRP sets/unsets bit 1
ReceiveByteThroughIR:
	push de
	push bc
	push hl

; waits for bit 1 in rRP to be unset
; up to $100 loops
	ld b, 0
	ld hl, rRP
.wait_ir
	bit RPB_DATAIN, [hl]
	jr z, .ok
	dec b
	jr nz, .wait_ir
	; looped around $100 times
	; return $ff and carry set
	pop hl
	pop bc
	pop de
	scf
	ld a, $ff
	ret

.ok
; delay for some cycles
	ld a, 15
.loop_delay
	dec a
	jr nz, .loop_delay

; loop for each bit
	ld e, 8
.loop
	ld a, $01
	; possibly delay cycles?
	ld b, 9
	ld b, 9
	ld b, 9
	ld b, 9

; checks for bit 1 in rRP
; if in any of the checks it is unset,
; then a is set to 0
; this is done a total of 9 times
	bit RPB_DATAIN, [hl]
	jr nz, .asm_196ec
	xor a
.asm_196ec
	bit RPB_DATAIN, [hl]
	jr nz, .asm_196f1
	xor a
.asm_196f1
	dec b
	jr nz, .asm_196ec
	; one bit received
	rrca
	rr d
	dec e
	jr nz, .loop
	ld a, d ; has bits set for each "cycle" that bit 1 was not unset
	pop hl
	pop bc
	pop de
	or a
	ret

ReturnZFlagUnsetAndCarryFlagSet:
	ld a, $ff
	or a ; z not set
	scf  ; carry set
	ret

; called when expecting to transmit data
Func_19705:
	ld hl, rRP
.loop
	ldh a, [rJOYP]
	bit 1, a
	jr z, ReturnZFlagUnsetAndCarryFlagSet
	ld a, $aa ; request
	call TransmitByteThroughIR
	push hl
	pop hl
	call ReceiveByteThroughIR_ZeroIfUnsuccessful
	cp $33 ; acknowledge
	jr nz, .loop
	xor a
	ret

; called when expecting to receive data
Func_1971e:
	ld hl, rRP
.asm_19721
	ldh a, [rJOYP]
	bit 1, a
	jr z, ReturnZFlagUnsetAndCarryFlagSet
	call ReceiveByteThroughIR_ZeroIfUnsuccessful
	cp $aa ; request
	jr nz, .asm_19721
	ld a, $33 ; acknowledge
	call TransmitByteThroughIR
	xor a
	ret

ReturnZFlagUnsetAndCarryFlagSet2:
	jp ReturnZFlagUnsetAndCarryFlagSet

TransmitIRDataBuffer:
	call Func_19705
	jr c, ReturnZFlagUnsetAndCarryFlagSet2
	ld a, $49
	call TransmitByteThroughIR
	ld a, $52
	call TransmitByteThroughIR
	ld hl, wIRDataBuffer
	ld c, 8
	jr TransmitNBytesFromHLThroughIR

ReceiveIRDataBuffer:
	call Func_1971e
	jr c, ReturnZFlagUnsetAndCarryFlagSet2
	call ReceiveByteThroughIR
	cp $49
	jr nz, ReceiveIRDataBuffer
	call ReceiveByteThroughIR
	cp $52
	jr nz, ReceiveIRDataBuffer
	ld hl, wIRDataBuffer
	ld c, 8
	jr ReceiveNBytesToHLThroughIR

; hl = start of data to transmit
; c = number of bytes to transmit
TransmitNBytesFromHLThroughIR:
	ld b, $0
.loop_data_bytes
	ld a, b
	add [hl]
	ld b, a
	ld a, [hli]
	call TransmitByteThroughIR
	jr c, .asm_1977c
	dec c
	jr nz, .loop_data_bytes
	ld a, b
	cpl
	inc a
	call TransmitByteThroughIR
.asm_1977c
	ret

; hl = address to write received data
; c = number of bytes to be received
ReceiveNBytesToHLThroughIR:
	ld b, 0
.loop_data_bytes
	call ReceiveByteThroughIR
	jr c, ReturnZFlagUnsetAndCarryFlagSet2
	ld [hli], a
	add b
	ld b, a
	dec c
	jr nz, .loop_data_bytes
	call ReceiveByteThroughIR
	add b
	or a
	jr nz, ReturnZFlagUnsetAndCarryFlagSet2
	ret

; disables interrupts, and sets joypad and IR communication port
; switches to CGB normal speed
StartIRCommunications:
	di
	call SwitchToCGBNormalSpeed
	ld a, P14
	ldh [rJOYP], a
	ld a, RPF_ENREAD
	ldh [rRP], a
	ret

; reenables interrupts, and switches CGB back to double speed
CloseIRCommunications:
	ld a, P14 | P15
	ldh [rJOYP], a
.wait_vblank_on
	ldh a, [rSTAT]
	and STAT_LCDC_STATUS
	cp STAT_ON_VBLANK
	jr z, .wait_vblank_on
.wait_vblank_off
	ldh a, [rSTAT]
	and STAT_LCDC_STATUS
	cp STAT_ON_VBLANK
	jr nz, .wait_vblank_off
	call SwitchToCGBDoubleSpeed
	ei
	ret

; set rRP to 0
ClearRP:
	ld a, $00
	ldh [rRP], a
	ret

; expects to receive a command (IRCMD_* constant)
; in wIRDataBuffer + 1, then calls the subroutine
; corresponding to that command
ExecuteReceivedIRCommands:
	call StartIRCommunications
.loop_commands
	call ReceiveIRDataBuffer
	jr c, .error
	jr nz, .loop_commands
	ld hl, wIRDataBuffer + 1
	ld a, [hl]
	ld hl, .CmdPointerTable
	cp NUM_IR_COMMANDS
	jr nc, .loop_commands ; invalid command
	call .JumpToCmdPointer ; execute command
	jr .loop_commands
.error
	call CloseIRCommunications
	xor a
	scf
	ret

.JumpToCmdPointer
	add a ; *2
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
.jp_hl
	jp hl

.CmdPointerTable
	dw .Close                ; IRCMD_CLOSE
	dw .ReturnWithoutClosing ; IRCMD_RETURN_WO_CLOSING
	dw .TransmitData         ; IRCMD_TRANSMIT_DATA
	dw .ReceiveData          ; IRCMD_RECEIVE_DATA
	dw .CallFunction         ; IRCMD_CALL_FUNCTION

; closes the IR communications
; pops hl so that the sp points
; to the return address of ExecuteReceivedIRCommands
.Close
	pop hl
	call CloseIRCommunications
	or a
	ret

; returns without closing the IR communications
; will continue the command loop
.ReturnWithoutClosing
	or a
	ret

; receives an address and number of bytes
; and transmits starting at that address
.TransmitData
	call Func_19705
	ret c
	call LoadRegistersFromIRDataBuffer
	jp TransmitNBytesFromHLThroughIR

; receives an address and number of bytes
; and writes the data received to that address
.ReceiveData
	call LoadRegistersFromIRDataBuffer
	ld l, e
	ld h, d
	call ReceiveNBytesToHLThroughIR
	jr c, .asm_19812
	sub b
	call TransmitByteThroughIR
.asm_19812
	ret

; receives an address to call, then stores
; the registers in the IR data buffer
.CallFunction
	call LoadRegistersFromIRDataBuffer
	call .jp_hl
	call StoreRegistersInIRDataBuffer
	ret

; returns carry set if request sent was not acknowledged
TrySendIRRequest:
	call StartIRCommunications
	ld hl, rRP
	ld c, 4
.send_request
	ld a, $aa ; request
	push bc
	call TransmitByteThroughIR
	push bc
	pop bc
	call ReceiveByteThroughIR_ZeroIfUnsuccessful
	pop bc
	cp $33 ; acknowledgement
	jr z, .received_ack
	dec c
	jr nz, .send_request
	scf
	jr .close

.received_ack
	xor a
.close
	push af
	call CloseIRCommunications
	pop af
	ret

; returns carry set if request was not received
TryReceiveIRRequest:
	call StartIRCommunications
	ld hl, rRP
.wait_request
	call ReceiveByteThroughIR_ZeroIfUnsuccessful
	cp $aa ; request
	jr z, .send_ack
	ldh a, [rJOYP]
	cpl
	and P10 | P11
	jr z, .wait_request
	scf
	jr .close

.send_ack
	ld a, $33 ; acknowledgement
	call TransmitByteThroughIR
	xor a
.close
	push af
	call CloseIRCommunications
	pop af
	ret

; sends request for other device to close current communication
RequestCloseIRCommunication:
	call StartIRCommunications
	ld a, IRCMD_CLOSE
	ld [wIRDataBuffer + 1], a
	call TransmitIRDataBuffer
;	fallthrough

; calls CloseIRCommunications while preserving af
SafelyCloseIRCommunications:
	push af
	call CloseIRCommunications
	pop af
	ret

; sends a request for data to be transmitted
; from the other device
; hl = start of data to request to transmit
; de = address to write data received
; c = length of data
RequestDataTransmissionThroughIR:
	ld a, IRCMD_TRANSMIT_DATA
	call TransmitRegistersThroughIR
	push de
	push bc
	call Func_1971e
	pop bc
	pop hl
	jr c, SafelyCloseIRCommunications
	call ReceiveNBytesToHLThroughIR
	jr SafelyCloseIRCommunications

; transmits data to be written in the other device
; hl = start of data to transmit
; de = address for other device to write data
; c = length of data
RequestDataReceivalThroughIR:
	ld a, IRCMD_RECEIVE_DATA
	call TransmitRegistersThroughIR
	call TransmitNBytesFromHLThroughIR
	jr c, SafelyCloseIRCommunications
	call ReceiveByteThroughIR
	jr c, SafelyCloseIRCommunications
	add b
	jr nz, .asm_1989e
	xor a
	jr SafelyCloseIRCommunications
.asm_1989e
	call ReturnZFlagUnsetAndCarryFlagSet
	jr SafelyCloseIRCommunications

; first stores all the current registers in wIRDataBuffer
; then transmits it through IR
TransmitRegistersThroughIR:
	push hl
	push de
	push bc
	call StoreRegistersInIRDataBuffer
	call StartIRCommunications
	call TransmitIRDataBuffer
	pop bc
	pop de
	pop hl
	ret nc
	inc sp
	inc sp
	jr SafelyCloseIRCommunications

; stores af, hl, de and bc in wIRDataBuffer
StoreRegistersInIRDataBuffer:
	push de
	push hl
	push af
	ld hl, wIRDataBuffer
	pop de
	ld [hl], e ; <- f
	inc hl
	ld [hl], d ; <- a
	inc hl
	pop de
	ld [hl], e ; <- l
	inc hl
	ld [hl], d ; <- h
	inc hl
	pop de
	ld [hl], e ; <- e
	inc hl
	ld [hl], d ; <- d
	inc hl
	ld [hl], c ; <- c
	inc hl
	ld [hl], b ; <- b
	ret

; loads all the registers that were stored
; from StoreRegistersInIRDataBuffer
LoadRegistersFromIRDataBuffer:
	ld hl, wIRDataBuffer
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	pop af
	ret
