; control characters
	charmap "<RAMNAME>", TX_RAM1
	charmap "<RAMTEXT>", TX_RAM2
	charmap "<RAMNUM>",  TX_RAM3

; ascii half-width font
	charmap "é", "`"
	charmap "♂", "$"
	charmap "♀", "%"
	charmap "”", "\""

fwcharmap: MACRO
	charmap STRCAT("FW\1_", \2), \3
ENDM

; TX_FULLWIDTH3
	fwcharmap 3, "A", $30
	fwcharmap 3, "B", $31
	fwcharmap 3, "C", $32
	fwcharmap 3, "D", $33
	fwcharmap 3, "E", $34
	fwcharmap 3, "F", $35
	fwcharmap 3, "G", $36
	fwcharmap 3, "H", $37
	fwcharmap 3, "I", $38
	fwcharmap 3, "J", $39
	fwcharmap 3, "K", $3a
	fwcharmap 3, "L", $3b
	fwcharmap 3, "M", $3c
	fwcharmap 3, "N", $3d
	fwcharmap 3, "O", $3e
	fwcharmap 3, "P", $3f
	fwcharmap 3, "Q", $40
	fwcharmap 3, "R", $41
	fwcharmap 3, "S", $42
	fwcharmap 3, "T", $43
	fwcharmap 3, "U", $44
	fwcharmap 3, "V", $45
	fwcharmap 3, "W", $46
	fwcharmap 3, "X", $47
	fwcharmap 3, "Y", $48
	fwcharmap 3, "Z", $49
	fwcharmap 3, "g", $4a
	fwcharmap 3, "c", $4b
	fwcharmap 3, "m", $4c
	fwcharmap 3, "r.", $4d
	fwcharmap 3, "♀", $4e
	fwcharmap 3, "♂", $4f
	fwcharmap 3, "【", $50
	fwcharmap 3, "】", $51
	fwcharmap 3, "●", $52
	fwcharmap 3, "◆", $53
	fwcharmap 3, "★", $54
	fwcharmap 3, "☆", $55
	fwcharmap 3, "_", $56
	fwcharmap 3, "■", $57
	fwcharmap 3, "ºC", $58
	fwcharmap 3, "“", $59
	fwcharmap 3, "º", $5a
	fwcharmap 3, "º(2)", $5b ; duplicate
	fwcharmap 3, "̳ ", $5c
	fwcharmap 3, "&", $5d
	fwcharmap 3, ":", $5e
	fwcharmap 3, "○", $5f
	fwcharmap 3, "❄", $60
	fwcharmap 3, "^", $62
	fwcharmap 3, "♪", $63
	fwcharmap 3, "a", $64
	fwcharmap 3, "b", $65
	fwcharmap 3, "d", $66
	fwcharmap 3, "e", $67
	fwcharmap 3, "f", $68
	fwcharmap 3, "h", $69
	fwcharmap 3, "i", $6a
	fwcharmap 3, "j", $6b
	fwcharmap 3, "k", $6c
	fwcharmap 3, "l", $6d
	fwcharmap 3, "n", $6e
	fwcharmap 3, "o", $6f
	fwcharmap 3, "p", $70
	fwcharmap 3, "q", $71
	fwcharmap 3, "s", $72
	fwcharmap 3, "t", $73
	fwcharmap 3, "u", $74
	fwcharmap 3, "v", $75
	fwcharmap 3, "w", $76
	fwcharmap 3, "x", $77
	fwcharmap 3, "y", $78
	fwcharmap 3, "z", $79
	fwcharmap 3, "'", $7a
	fwcharmap 3, "”", $7b
	fwcharmap 3, "r", $8e
	fwcharmap 3, "┌", $97
	fwcharmap 3, "＼", $98
	fwcharmap 3, "┐", $99
	fwcharmap 3, "|", $9a
	fwcharmap 3, " ", $9c
	fwcharmap 3, "!", $9d
	fwcharmap 3, "#", $9f
	fwcharmap 3, "$", $a0
	fwcharmap 3, "%", $a1
	fwcharmap 3, "(", $a4
	fwcharmap 3, ")", $a5
	fwcharmap 3, "*", $a6
	fwcharmap 3, "+", $a7
	fwcharmap 3, "､", $a8
	fwcharmap 3, "-", $a9
	fwcharmap 3, "/", $ab
	fwcharmap 3, "0", $ac
	fwcharmap 3, "1", $ad
	fwcharmap 3, "2", $ae
	fwcharmap 3, "3", $af
	fwcharmap 3, "4", $b0
	fwcharmap 3, "5", $b1
	fwcharmap 3, "6", $b2
	fwcharmap 3, "7", $b3
	fwcharmap 3, "8", $b4
	fwcharmap 3, "9", $b5
	fwcharmap 3, ";", $b7
	fwcharmap 3, "<", $b8
	fwcharmap 3, "=", $b9
	fwcharmap 3, ">", $ba
	fwcharmap 3, "?", $bb
	fwcharmap 3, "@", $bc
	fwcharmap 3, "[", $d7
	fwcharmap 3, "¥", $d8
	fwcharmap 3, "]", $d9

; TX_KATAKANA
	fwcharmap 0, "ヲ", $10
	fwcharmap 0, "ア", $11
	fwcharmap 0, "イ", $12
	fwcharmap 0, "ウ", $13
	fwcharmap 0, "エ", $14
	fwcharmap 0, "オ", $15
	fwcharmap 0, "カ", $16
	fwcharmap 0, "キ", $17
	fwcharmap 0, "ク", $18
	fwcharmap 0, "ケ", $19
	fwcharmap 0, "コ", $1a
	fwcharmap 0, "サ", $1b
	fwcharmap 0, "シ", $1c
	fwcharmap 0, "ス", $1d
	fwcharmap 0, "セ", $1e
	fwcharmap 0, "ソ", $1f
	fwcharmap 0, "タ", $20
	fwcharmap 0, "チ", $21
	fwcharmap 0, "ツ", $22
	fwcharmap 0, "テ", $23
	fwcharmap 0, "ト", $24
	fwcharmap 0, "ナ", $25
	fwcharmap 0, "ニ", $26
	fwcharmap 0, "ヌ", $27
	fwcharmap 0, "ネ", $28
	fwcharmap 0, "ノ", $29
	fwcharmap 0, "ハ", $2a
	fwcharmap 0, "ヒ", $2b
	fwcharmap 0, "フ", $2c
	fwcharmap 0, "ヘ", $2d
	fwcharmap 0, "ホ", $2e
	fwcharmap 0, "マ", $2f
	fwcharmap 0, "ミ", $30
	fwcharmap 0, "ム", $31
	fwcharmap 0, "メ", $32
	fwcharmap 0, "モ", $33
	fwcharmap 0, "ヤ", $34
	fwcharmap 0, "ユ", $35
	fwcharmap 0, "ヨ", $36
	fwcharmap 0, "ラ", $37
	fwcharmap 0, "リ", $38
	fwcharmap 0, "ル", $39
	fwcharmap 0, "レ", $3a
	fwcharmap 0, "ロ", $3b
	fwcharmap 0, "ワ", $3c
	fwcharmap 0, "ン", $3d
	fwcharmap 0, "ガ", $3e
	fwcharmap 0, "ギ", $3f
	fwcharmap 0, "グ", $40
	fwcharmap 0, "ゲ", $41
	fwcharmap 0, "ゴ", $42
	fwcharmap 0, "ザ", $43
	fwcharmap 0, "ジ", $44
	fwcharmap 0, "ズ", $45
	fwcharmap 0, "ゼ", $46
	fwcharmap 0, "ゾ", $47
	fwcharmap 0, "ダ", $48
	fwcharmap 0, "ヂ", $49
	fwcharmap 0, "ヅ", $4a
	fwcharmap 0, "デ", $4b
	fwcharmap 0, "ド", $4c
	fwcharmap 0, "バ", $4d
	fwcharmap 0, "ビ", $4e
	fwcharmap 0, "ブ", $4f
	fwcharmap 0, "ベ", $50
	fwcharmap 0, "ボ", $51
	fwcharmap 0, "パ", $52
	fwcharmap 0, "ピ", $53
	fwcharmap 0, "プ", $54
	fwcharmap 0, "ペ", $55
	fwcharmap 0, "ポ", $56
	fwcharmap 0, "ァ", $57
	fwcharmap 0, "ィ", $58
	fwcharmap 0, "ゥ", $59
	fwcharmap 0, "ェ", $5a
	fwcharmap 0, "ォ", $5b
	fwcharmap 0, "ャ", $5c
	fwcharmap 0, "ュ", $5d
	fwcharmap 0, "ョ", $5e
	fwcharmap 0, "ッ", $5f

; TX_HIRAGANA
	fwcharmap 0, "を", $10
	fwcharmap 0, "あ", $11
	fwcharmap 0, "い", $12
	fwcharmap 0, "う", $13
	fwcharmap 0, "え", $14
	fwcharmap 0, "お", $15
	fwcharmap 0, "か", $16
	fwcharmap 0, "き", $17
	fwcharmap 0, "く", $18
	fwcharmap 0, "け", $19
	fwcharmap 0, "こ", $1a
	fwcharmap 0, "さ", $1b
	fwcharmap 0, "し", $1c
	fwcharmap 0, "す", $1d
	fwcharmap 0, "せ", $1e
	fwcharmap 0, "そ", $1f
	fwcharmap 0, "た", $20
	fwcharmap 0, "ち", $21
	fwcharmap 0, "つ", $22
	fwcharmap 0, "て", $23
	fwcharmap 0, "と", $24
	fwcharmap 0, "な", $25
	fwcharmap 0, "に", $26
	fwcharmap 0, "ぬ", $27
	fwcharmap 0, "ね", $28
	fwcharmap 0, "の", $29
	fwcharmap 0, "は", $2a
	fwcharmap 0, "ひ", $2b
	fwcharmap 0, "ふ", $2c
	fwcharmap 0, "へ", $2d
	fwcharmap 0, "ほ", $2e
	fwcharmap 0, "ま", $2f
	fwcharmap 0, "み", $30
	fwcharmap 0, "む", $31
	fwcharmap 0, "め", $32
	fwcharmap 0, "も", $33
	fwcharmap 0, "や", $34
	fwcharmap 0, "ゆ", $35
	fwcharmap 0, "よ", $36
	fwcharmap 0, "ら", $37
	fwcharmap 0, "り", $38
	fwcharmap 0, "る", $39
	fwcharmap 0, "れ", $3a
	fwcharmap 0, "ろ", $3b
	fwcharmap 0, "わ", $3c
	fwcharmap 0, "ん", $3d
	fwcharmap 0, "が", $3e
	fwcharmap 0, "ぎ", $3f
	fwcharmap 0, "ぐ", $40
	fwcharmap 0, "げ", $41
	fwcharmap 0, "ご", $42
	fwcharmap 0, "ざ", $43
	fwcharmap 0, "じ", $44
	fwcharmap 0, "ず", $45
	fwcharmap 0, "ぜ", $46
	fwcharmap 0, "ぞ", $47
	fwcharmap 0, "だ", $48
	fwcharmap 0, "ぢ", $49
	fwcharmap 0, "づ", $4a
	fwcharmap 0, "で", $4b
	fwcharmap 0, "ど", $4c
	fwcharmap 0, "ば", $4d
	fwcharmap 0, "び", $4e
	fwcharmap 0, "ぶ", $4f
	fwcharmap 0, "べ", $50
	fwcharmap 0, "ぼ", $51
	fwcharmap 0, "ぱ", $52
	fwcharmap 0, "ぴ", $53
	fwcharmap 0, "ぷ", $54
	fwcharmap 0, "ぺ", $55
	fwcharmap 0, "ぽ", $56
	fwcharmap 0, "あ(2)", $57
	fwcharmap 0, "い(2)", $58
	fwcharmap 0, "う(2)", $59
	fwcharmap 0, "え(2)", $5a
	fwcharmap 0, "お(2)", $5b
	fwcharmap 0, "ゃ", $5c
	fwcharmap 0, "ゅ", $5d
	fwcharmap 0, "ょ", $5e
	fwcharmap 0, "っ", $5f

; TX_KATAKANA, TX_HIRAGANA, and default font
	fwcharmap 0, "0", $60
	fwcharmap 0, "1", $61
	fwcharmap 0, "2", $62
	fwcharmap 0, "3", $63
	fwcharmap 0, "4", $64
	fwcharmap 0, "5", $65
	fwcharmap 0, "6", $66
	fwcharmap 0, "7", $67
	fwcharmap 0, "8", $68
	fwcharmap 0, "9", $69
	fwcharmap 0, "+", $6a
	fwcharmap 0, "-", $6b
	fwcharmap 0, "✕", $6c
	fwcharmap 0, "/", $6d
	fwcharmap 0, "!", $6e
	fwcharmap 0, "?", $6f
	fwcharmap 0, " ", $70
	fwcharmap 0, "(", $71
	fwcharmap 0, ")", $72
	fwcharmap 0, "·", $77
	fwcharmap 0, "-(2)", $78 ; duplicate

FW_SPACE EQU $70

txsymbol: MACRO
	const SYM_\1
	charmap "\1>", const_value - 1
ENDM

; TX_SYMBOL
; TODO: If user-defined functions ever become a thing a symbol(*) syntax
;       would probably be preferred over SYM_*
	charmap "<", TX_SYMBOL
	const_def
	txsymbol SPACE      ; $00
	txsymbol FIRE       ; $01
	txsymbol GRASS      ; $02
	txsymbol LIGHTNING  ; $03
	txsymbol WATER      ; $04
	txsymbol FIGHTING   ; $05
	txsymbol PSYCHIC    ; $06
	txsymbol COLORLESS  ; $07
	txsymbol POISONED   ; $08
	txsymbol ASLEEP     ; $09
	txsymbol CONFUSED   ; $0a
	txsymbol PARALYZED  ; $0b
	txsymbol CURSOR_U   ; $0c
	txsymbol POKEMON    ; $0d
	txsymbol MOVE_DESCR ; $0e
	txsymbol CURSOR_R   ; $0f
	txsymbol HP         ; $10
	txsymbol Lv         ; $11
	txsymbol E          ; $12
	txsymbol No         ; $13
	txsymbol PLUSPOWER  ; $14
	txsymbol DEFENDER   ; $15
	txsymbol HP_OK      ; $16
	txsymbol HP_NOK     ; $17
	txsymbol BOX_TOP_L  ; $18
	txsymbol BOX_TOP_R  ; $19
	txsymbol BOX_BTM_L  ; $1a
	txsymbol BOX_BTM_R  ; $1b
	txsymbol BOX_TOP    ; $1c
	txsymbol BOX_BOTTOM ; $1d
	txsymbol BOX_LEFT   ; $1e
	txsymbol BOX_RIGHT  ; $1f
	txsymbol 0          ; $20
	txsymbol 1          ; $21
	txsymbol 2          ; $22
	txsymbol 3          ; $23
	txsymbol 4          ; $24
	txsymbol 5          ; $25
	txsymbol 6          ; $26
	txsymbol 7          ; $27
	txsymbol 8          ; $28
	txsymbol 9          ; $29
	txsymbol DOT        ; $2a
	txsymbol PLUS       ; $2b
	txsymbol MINUS      ; $2c
	txsymbol CROSS      ; $2d
	txsymbol SLASH      ; $2e
	txsymbol CURSOR_D   ; $2f
	txsymbol PRIZE      ; $30
