; control characters
	charmap "<RAMNAME>", TX_RAM1
	charmap "<RAMTEXT>", TX_RAM2
	charmap "<RAMNUM>",  TX_RAM3

; ascii half-width font
	charmap "\n", $0a
	charmap " ", $20
	charmap "!", $21
	charmap "”", $22
	charmap "≠", $23
	charmap "♂", $24
	charmap "♀", $25
	charmap "&", $26
	charmap "'", $27
	charmap "(", $28
	charmap ")", $29
	charmap "*", $2a
	charmap "+", $2b
	charmap ",", $2c
	charmap "-", $2d
	charmap ".", $2e
	charmap "/", $2f
	charmap "0", $30
	charmap "1", $31
	charmap "2", $32
	charmap "3", $33
	charmap "4", $34
	charmap "5", $35
	charmap "6", $36
	charmap "7", $37
	charmap "8", $38
	charmap "9", $39
	charmap ":", $3a
	charmap ";", $3b
	charmap "<", $3c
	charmap "=", $3d
	charmap ">", $3e
	charmap "?", $3f
	charmap "É", $40
	charmap "A", $41
	charmap "B", $42
	charmap "C", $43
	charmap "D", $44
	charmap "E", $45
	charmap "F", $46
	charmap "G", $47
	charmap "H", $48
	charmap "I", $49
	charmap "J", $4a
	charmap "K", $4b
	charmap "L", $4c
	charmap "M", $4d
	charmap "N", $4e
	charmap "O", $4f
	charmap "P", $50
	charmap "Q", $51
	charmap "R", $52
	charmap "S", $53
	charmap "T", $54
	charmap "U", $55
	charmap "V", $56
	charmap "W", $57
	charmap "X", $58
	charmap "Y", $59
	charmap "Z", $5a
	charmap "[", $5b
	charmap "\\", $5c
	charmap "]", $5d
	charmap "^", $5e
	charmap "_", $5f
	charmap "é", $60
	charmap "a", $61
	charmap "b", $62
	charmap "c", $63
	charmap "d", $64
	charmap "e", $65
	charmap "f", $66
	charmap "g", $67
	charmap "h", $68
	charmap "i", $69
	charmap "j", $6a
	charmap "k", $6b
	charmap "l", $6c
	charmap "m", $6d
	charmap "n", $6e
	charmap "o", $6f
	charmap "p", $70
	charmap "q", $71
	charmap "r", $72
	charmap "s", $73
	charmap "t", $74
	charmap "u", $75
	charmap "v", $76
	charmap "w", $77
	charmap "x", $78
	charmap "y", $79
	charmap "z", $7a
	charmap "\{", $7b
	charmap "¦", $7c
	charmap "}", $7d
	charmap "|", $7e
	charmap "‾", $7f

MACRO fwcharmap
	charmap STRCAT("FW{x:\1}_", \2), \3
ENDM

; TX_FULLWIDTH3
	fwcharmap TX_FULLWIDTH3, "A", $30
	fwcharmap TX_FULLWIDTH3, "B", $31
	fwcharmap TX_FULLWIDTH3, "C", $32
	fwcharmap TX_FULLWIDTH3, "D", $33
	fwcharmap TX_FULLWIDTH3, "E", $34
	fwcharmap TX_FULLWIDTH3, "F", $35
	fwcharmap TX_FULLWIDTH3, "G", $36
	fwcharmap TX_FULLWIDTH3, "H", $37
	fwcharmap TX_FULLWIDTH3, "I", $38
	fwcharmap TX_FULLWIDTH3, "J", $39
	fwcharmap TX_FULLWIDTH3, "K", $3a
	fwcharmap TX_FULLWIDTH3, "L", $3b
	fwcharmap TX_FULLWIDTH3, "M", $3c
	fwcharmap TX_FULLWIDTH3, "N", $3d
	fwcharmap TX_FULLWIDTH3, "O", $3e
	fwcharmap TX_FULLWIDTH3, "P", $3f
	fwcharmap TX_FULLWIDTH3, "Q", $40
	fwcharmap TX_FULLWIDTH3, "R", $41
	fwcharmap TX_FULLWIDTH3, "S", $42
	fwcharmap TX_FULLWIDTH3, "T", $43
	fwcharmap TX_FULLWIDTH3, "U", $44
	fwcharmap TX_FULLWIDTH3, "V", $45
	fwcharmap TX_FULLWIDTH3, "W", $46
	fwcharmap TX_FULLWIDTH3, "X", $47
	fwcharmap TX_FULLWIDTH3, "Y", $48
	fwcharmap TX_FULLWIDTH3, "Z", $49
	fwcharmap TX_FULLWIDTH3, "g", $4a
	fwcharmap TX_FULLWIDTH3, "c", $4b
	fwcharmap TX_FULLWIDTH3, "m", $4c
	fwcharmap TX_FULLWIDTH3, "r.", $4d
	fwcharmap TX_FULLWIDTH3, "♀", $4e
	fwcharmap TX_FULLWIDTH3, "♂", $4f
	fwcharmap TX_FULLWIDTH3, "【", $50
	fwcharmap TX_FULLWIDTH3, "】", $51
	fwcharmap TX_FULLWIDTH3, "●", $52
	fwcharmap TX_FULLWIDTH3, "◆", $53
	fwcharmap TX_FULLWIDTH3, "★", $54
	fwcharmap TX_FULLWIDTH3, "☆", $55
	fwcharmap TX_FULLWIDTH3, "_", $56
	fwcharmap TX_FULLWIDTH3, "▪", $57
	fwcharmap TX_FULLWIDTH3, "℃", $58
	fwcharmap TX_FULLWIDTH3, "゛", $59
	fwcharmap TX_FULLWIDTH3, "°", $5a
	fwcharmap TX_FULLWIDTH3, "゜", $5b
	fwcharmap TX_FULLWIDTH3, "ˍ", $5c
	fwcharmap TX_FULLWIDTH3, "&", $5d
	fwcharmap TX_FULLWIDTH3, ":", $5e
	fwcharmap TX_FULLWIDTH3, "○", $5f
	fwcharmap TX_FULLWIDTH3, "※", $60
	fwcharmap TX_FULLWIDTH3, "о", $61
	fwcharmap TX_FULLWIDTH3, "^", $62
	fwcharmap TX_FULLWIDTH3, "♪", $63
	fwcharmap TX_FULLWIDTH3, "a", $64
	fwcharmap TX_FULLWIDTH3, "b", $65
	fwcharmap TX_FULLWIDTH3, "d", $66
	fwcharmap TX_FULLWIDTH3, "e", $67
	fwcharmap TX_FULLWIDTH3, "f", $68
	fwcharmap TX_FULLWIDTH3, "h", $69
	fwcharmap TX_FULLWIDTH3, "i", $6a
	fwcharmap TX_FULLWIDTH3, "j", $6b
	fwcharmap TX_FULLWIDTH3, "k", $6c
	fwcharmap TX_FULLWIDTH3, "l", $6d
	fwcharmap TX_FULLWIDTH3, "n", $6e
	fwcharmap TX_FULLWIDTH3, "o", $6f
	fwcharmap TX_FULLWIDTH3, "p", $70
	fwcharmap TX_FULLWIDTH3, "q", $71
	fwcharmap TX_FULLWIDTH3, "s", $72
	fwcharmap TX_FULLWIDTH3, "t", $73
	fwcharmap TX_FULLWIDTH3, "u", $74
	fwcharmap TX_FULLWIDTH3, "v", $75
	fwcharmap TX_FULLWIDTH3, "w", $76
	fwcharmap TX_FULLWIDTH3, "x", $77
	fwcharmap TX_FULLWIDTH3, "y", $78
	fwcharmap TX_FULLWIDTH3, "z", $79
	fwcharmap TX_FULLWIDTH3, "'", $7a
	fwcharmap TX_FULLWIDTH3, "”", $7b
	fwcharmap TX_FULLWIDTH3, "■", $7c
	fwcharmap TX_FULLWIDTH3, "r", $8e
	fwcharmap TX_FULLWIDTH3, "「", $97
	fwcharmap TX_FULLWIDTH3, "＼", $98
	fwcharmap TX_FULLWIDTH3, "」", $99
	fwcharmap TX_FULLWIDTH3, "|", $9a
	fwcharmap TX_FULLWIDTH3, "ˉ", $9b
	fwcharmap TX_FULLWIDTH3, " ", $9c
	fwcharmap TX_FULLWIDTH3, "!", $9d
	fwcharmap TX_FULLWIDTH3, "#", $9f
	fwcharmap TX_FULLWIDTH3, "$", $a0
	fwcharmap TX_FULLWIDTH3, "%", $a1
	fwcharmap TX_FULLWIDTH3, "(", $a4
	fwcharmap TX_FULLWIDTH3, ")", $a5
	fwcharmap TX_FULLWIDTH3, "*", $a6
	fwcharmap TX_FULLWIDTH3, "+", $a7
	fwcharmap TX_FULLWIDTH3, "、", $a8
	fwcharmap TX_FULLWIDTH3, "-", $a9
	fwcharmap TX_FULLWIDTH3, "/", $ab
	fwcharmap TX_FULLWIDTH3, "0", $ac
	fwcharmap TX_FULLWIDTH3, "1", $ad
	fwcharmap TX_FULLWIDTH3, "2", $ae
	fwcharmap TX_FULLWIDTH3, "3", $af
	fwcharmap TX_FULLWIDTH3, "4", $b0
	fwcharmap TX_FULLWIDTH3, "5", $b1
	fwcharmap TX_FULLWIDTH3, "6", $b2
	fwcharmap TX_FULLWIDTH3, "7", $b3
	fwcharmap TX_FULLWIDTH3, "8", $b4
	fwcharmap TX_FULLWIDTH3, "9", $b5
	fwcharmap TX_FULLWIDTH3, ";", $b7
	fwcharmap TX_FULLWIDTH3, "<", $b8
	fwcharmap TX_FULLWIDTH3, "=", $b9
	fwcharmap TX_FULLWIDTH3, ">", $ba
	fwcharmap TX_FULLWIDTH3, "?", $bb
	fwcharmap TX_FULLWIDTH3, "@", $bc
	fwcharmap TX_FULLWIDTH3, "[", $d7
	fwcharmap TX_FULLWIDTH3, "¥", $d8
	fwcharmap TX_FULLWIDTH3, "]", $d9

; TX_KATAKANA
	fwcharmap TX_KATAKANA, "ヲ", $10
	fwcharmap TX_KATAKANA, "ア", $11
	fwcharmap TX_KATAKANA, "イ", $12
	fwcharmap TX_KATAKANA, "ウ", $13
	fwcharmap TX_KATAKANA, "エ", $14
	fwcharmap TX_KATAKANA, "オ", $15
	fwcharmap TX_KATAKANA, "カ", $16
	fwcharmap TX_KATAKANA, "キ", $17
	fwcharmap TX_KATAKANA, "ク", $18
	fwcharmap TX_KATAKANA, "ケ", $19
	fwcharmap TX_KATAKANA, "コ", $1a
	fwcharmap TX_KATAKANA, "サ", $1b
	fwcharmap TX_KATAKANA, "シ", $1c
	fwcharmap TX_KATAKANA, "ス", $1d
	fwcharmap TX_KATAKANA, "セ", $1e
	fwcharmap TX_KATAKANA, "ソ", $1f
	fwcharmap TX_KATAKANA, "タ", $20
	fwcharmap TX_KATAKANA, "チ", $21
	fwcharmap TX_KATAKANA, "ツ", $22
	fwcharmap TX_KATAKANA, "テ", $23
	fwcharmap TX_KATAKANA, "ト", $24
	fwcharmap TX_KATAKANA, "ナ", $25
	fwcharmap TX_KATAKANA, "ニ", $26
	fwcharmap TX_KATAKANA, "ヌ", $27
	fwcharmap TX_KATAKANA, "ネ", $28
	fwcharmap TX_KATAKANA, "ノ", $29
	fwcharmap TX_KATAKANA, "ハ", $2a
	fwcharmap TX_KATAKANA, "ヒ", $2b
	fwcharmap TX_KATAKANA, "フ", $2c
	fwcharmap TX_KATAKANA, "ヘ", $2d
	fwcharmap TX_KATAKANA, "ホ", $2e
	fwcharmap TX_KATAKANA, "マ", $2f
	fwcharmap TX_KATAKANA, "ミ", $30
	fwcharmap TX_KATAKANA, "ム", $31
	fwcharmap TX_KATAKANA, "メ", $32
	fwcharmap TX_KATAKANA, "モ", $33
	fwcharmap TX_KATAKANA, "ヤ", $34
	fwcharmap TX_KATAKANA, "ユ", $35
	fwcharmap TX_KATAKANA, "ヨ", $36
	fwcharmap TX_KATAKANA, "ラ", $37
	fwcharmap TX_KATAKANA, "リ", $38
	fwcharmap TX_KATAKANA, "ル", $39
	fwcharmap TX_KATAKANA, "レ", $3a
	fwcharmap TX_KATAKANA, "ロ", $3b
	fwcharmap TX_KATAKANA, "ワ", $3c
	fwcharmap TX_KATAKANA, "ン", $3d
	fwcharmap TX_KATAKANA, "ガ", $3e
	fwcharmap TX_KATAKANA, "ギ", $3f
	fwcharmap TX_KATAKANA, "グ", $40
	fwcharmap TX_KATAKANA, "ゲ", $41
	fwcharmap TX_KATAKANA, "ゴ", $42
	fwcharmap TX_KATAKANA, "ザ", $43
	fwcharmap TX_KATAKANA, "ジ", $44
	fwcharmap TX_KATAKANA, "ズ", $45
	fwcharmap TX_KATAKANA, "ゼ", $46
	fwcharmap TX_KATAKANA, "ゾ", $47
	fwcharmap TX_KATAKANA, "ダ", $48
	fwcharmap TX_KATAKANA, "ヂ", $49
	fwcharmap TX_KATAKANA, "ヅ", $4a
	fwcharmap TX_KATAKANA, "デ", $4b
	fwcharmap TX_KATAKANA, "ド", $4c
	fwcharmap TX_KATAKANA, "バ", $4d
	fwcharmap TX_KATAKANA, "ビ", $4e
	fwcharmap TX_KATAKANA, "ブ", $4f
	fwcharmap TX_KATAKANA, "ベ", $50
	fwcharmap TX_KATAKANA, "ボ", $51
	fwcharmap TX_KATAKANA, "パ", $52
	fwcharmap TX_KATAKANA, "ピ", $53
	fwcharmap TX_KATAKANA, "プ", $54
	fwcharmap TX_KATAKANA, "ペ", $55
	fwcharmap TX_KATAKANA, "ポ", $56
	fwcharmap TX_KATAKANA, "ァ", $57
	fwcharmap TX_KATAKANA, "ィ", $58
	fwcharmap TX_KATAKANA, "ゥ", $59
	fwcharmap TX_KATAKANA, "ェ", $5a
	fwcharmap TX_KATAKANA, "ォ", $5b
	fwcharmap TX_KATAKANA, "ャ", $5c
	fwcharmap TX_KATAKANA, "ュ", $5d
	fwcharmap TX_KATAKANA, "ョ", $5e
	fwcharmap TX_KATAKANA, "ッ", $5f

; TX_HIRAGANA
	fwcharmap TX_HIRAGANA, "を", $10
	fwcharmap TX_HIRAGANA, "あ", $11
	fwcharmap TX_HIRAGANA, "い", $12
	fwcharmap TX_HIRAGANA, "う", $13
	fwcharmap TX_HIRAGANA, "え", $14
	fwcharmap TX_HIRAGANA, "お", $15
	fwcharmap TX_HIRAGANA, "か", $16
	fwcharmap TX_HIRAGANA, "き", $17
	fwcharmap TX_HIRAGANA, "く", $18
	fwcharmap TX_HIRAGANA, "け", $19
	fwcharmap TX_HIRAGANA, "こ", $1a
	fwcharmap TX_HIRAGANA, "さ", $1b
	fwcharmap TX_HIRAGANA, "し", $1c
	fwcharmap TX_HIRAGANA, "す", $1d
	fwcharmap TX_HIRAGANA, "せ", $1e
	fwcharmap TX_HIRAGANA, "そ", $1f
	fwcharmap TX_HIRAGANA, "た", $20
	fwcharmap TX_HIRAGANA, "ち", $21
	fwcharmap TX_HIRAGANA, "つ", $22
	fwcharmap TX_HIRAGANA, "て", $23
	fwcharmap TX_HIRAGANA, "と", $24
	fwcharmap TX_HIRAGANA, "な", $25
	fwcharmap TX_HIRAGANA, "に", $26
	fwcharmap TX_HIRAGANA, "ぬ", $27
	fwcharmap TX_HIRAGANA, "ね", $28
	fwcharmap TX_HIRAGANA, "の", $29
	fwcharmap TX_HIRAGANA, "は", $2a
	fwcharmap TX_HIRAGANA, "ひ", $2b
	fwcharmap TX_HIRAGANA, "ふ", $2c
	fwcharmap TX_HIRAGANA, "へ", $2d
	fwcharmap TX_HIRAGANA, "ほ", $2e
	fwcharmap TX_HIRAGANA, "ま", $2f
	fwcharmap TX_HIRAGANA, "み", $30
	fwcharmap TX_HIRAGANA, "む", $31
	fwcharmap TX_HIRAGANA, "め", $32
	fwcharmap TX_HIRAGANA, "も", $33
	fwcharmap TX_HIRAGANA, "や", $34
	fwcharmap TX_HIRAGANA, "ゆ", $35
	fwcharmap TX_HIRAGANA, "よ", $36
	fwcharmap TX_HIRAGANA, "ら", $37
	fwcharmap TX_HIRAGANA, "り", $38
	fwcharmap TX_HIRAGANA, "る", $39
	fwcharmap TX_HIRAGANA, "れ", $3a
	fwcharmap TX_HIRAGANA, "ろ", $3b
	fwcharmap TX_HIRAGANA, "わ", $3c
	fwcharmap TX_HIRAGANA, "ん", $3d
	fwcharmap TX_HIRAGANA, "が", $3e
	fwcharmap TX_HIRAGANA, "ぎ", $3f
	fwcharmap TX_HIRAGANA, "ぐ", $40
	fwcharmap TX_HIRAGANA, "げ", $41
	fwcharmap TX_HIRAGANA, "ご", $42
	fwcharmap TX_HIRAGANA, "ざ", $43
	fwcharmap TX_HIRAGANA, "じ", $44
	fwcharmap TX_HIRAGANA, "ず", $45
	fwcharmap TX_HIRAGANA, "ぜ", $46
	fwcharmap TX_HIRAGANA, "ぞ", $47
	fwcharmap TX_HIRAGANA, "だ", $48
	fwcharmap TX_HIRAGANA, "ぢ", $49
	fwcharmap TX_HIRAGANA, "づ", $4a
	fwcharmap TX_HIRAGANA, "で", $4b
	fwcharmap TX_HIRAGANA, "ど", $4c
	fwcharmap TX_HIRAGANA, "ば", $4d
	fwcharmap TX_HIRAGANA, "び", $4e
	fwcharmap TX_HIRAGANA, "ぶ", $4f
	fwcharmap TX_HIRAGANA, "べ", $50
	fwcharmap TX_HIRAGANA, "ぼ", $51
	fwcharmap TX_HIRAGANA, "ぱ", $52
	fwcharmap TX_HIRAGANA, "ぴ", $53
	fwcharmap TX_HIRAGANA, "ぷ", $54
	fwcharmap TX_HIRAGANA, "ぺ", $55
	fwcharmap TX_HIRAGANA, "ぽ", $56
	fwcharmap TX_HIRAGANA, "ぁ", $57
	fwcharmap TX_HIRAGANA, "ぃ", $58
	fwcharmap TX_HIRAGANA, "ぅ", $59
	fwcharmap TX_HIRAGANA, "ぇ", $5a
	fwcharmap TX_HIRAGANA, "ぉ", $5b
	fwcharmap TX_HIRAGANA, "ゃ", $5c
	fwcharmap TX_HIRAGANA, "ゅ", $5d
	fwcharmap TX_HIRAGANA, "ょ", $5e
	fwcharmap TX_HIRAGANA, "っ", $5f

; TX_KATAKANA, TX_HIRAGANA, and default font
	fwcharmap TX_FULLWIDTH0, "0", $60
	fwcharmap TX_FULLWIDTH0, "1", $61
	fwcharmap TX_FULLWIDTH0, "2", $62
	fwcharmap TX_FULLWIDTH0, "3", $63
	fwcharmap TX_FULLWIDTH0, "4", $64
	fwcharmap TX_FULLWIDTH0, "5", $65
	fwcharmap TX_FULLWIDTH0, "6", $66
	fwcharmap TX_FULLWIDTH0, "7", $67
	fwcharmap TX_FULLWIDTH0, "8", $68
	fwcharmap TX_FULLWIDTH0, "9", $69
	fwcharmap TX_FULLWIDTH0, "+", $6a
	fwcharmap TX_FULLWIDTH0, "-", $6b
	fwcharmap TX_FULLWIDTH0, "×", $6c
	fwcharmap TX_FULLWIDTH0, "/", $6d
	fwcharmap TX_FULLWIDTH0, "!", $6e
	fwcharmap TX_FULLWIDTH0, "?", $6f
	fwcharmap TX_FULLWIDTH0, " ", $70
	fwcharmap TX_FULLWIDTH0, "(", $71
	fwcharmap TX_FULLWIDTH0, ")", $72
	fwcharmap TX_FULLWIDTH0, "「", $73
	fwcharmap TX_FULLWIDTH0, "」", $74
	fwcharmap TX_FULLWIDTH0, "、", $75
	fwcharmap TX_FULLWIDTH0, "。", $76
	fwcharmap TX_FULLWIDTH0, "・", $77
	fwcharmap TX_FULLWIDTH0, "ー", $78
	fwcharmap TX_FULLWIDTH0, "~", $79

DEF FW_SPACE EQU $70

MACRO txsymbol
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
	txsymbol ATK_DESCR  ; $0e
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
