; wPrinterStatus
	const_def
	const PRINTER_ERROR_CHECKSUM              ; $0
	const PRINTER_STATUS_BUSY                 ; $1
	const PRINTER_STATUS_IMAGE_FULL           ; $2
	const PRINTER_STATUS_PRINTING             ; $3
	const PRINTER_ERROR_INVALID_PACKET        ; $4
	const PRINTER_ERROR_PAPER_JAMMED          ; $5
	const PRINTER_ERROR_CABLE_PRINTER_SWITCH  ; $6
	const PRINTER_ERROR_BATTERIES_LOST_CHARGE ; $7

; printer packet types
DEF PRINTERPKT_INIT              EQU $01
DEF PRINTERPKT_PRINT_INSTRUCTION EQU $02
DEF PRINTERPKT_DATA              EQU $04
DEF PRINTERPKT_BREAK             EQU $08
DEF PRINTERPKT_NUL               EQU $0f
