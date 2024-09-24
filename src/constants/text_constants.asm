DEF TX_END        EQU $00 ; terminates the text

; usage: TX_FULLWIDTH*, char1, TX_FULLWIDTH*, char2, ...
DEF TX_FULLWIDTH0 EQU $00
; source: gfx/fonts/full_width/1_kanji2.1bpp
DEF TX_FULLWIDTH1 EQU $01
; source: gfx/fonts/full_width/2_kanji3.1bpp
DEF TX_FULLWIDTH2 EQU $02
; source: gfx/fonts/full_width/3.1bpp (contains latin letters and symbols)
DEF TX_FULLWIDTH3 EQU $03
; source: gfx/fonts/full_width/4.1bpp
DEF TX_FULLWIDTH4 EQU $04

DEF TX_CTRL_START EQU $05

; usage: TX_SYMBOL, char1, TX_SYMBOL, char2, ...
; source: gfx/fonts/symbols.2bpp
; note: precede each symbol with TX_SYMBOL only when it's going to be processed as text.
; if copying directly to VRAM, don't precede symbols with TX_SYMBOL as they are just tile numbers.
DEF TX_SYMBOL     EQU $05

; usage: TX_HALFWIDTH, char1, char2, ...
; source: gfx/fonts/half_width.1bpp
DEF TX_HALFWIDTH  EQU $06 ; sets wFontWidth to HALF_WIDTH

; usage: <half width text>, TX_HALF2FULL, <full width text>
DEF TX_HALF2FULL  EQU $07 ; sets wFontWidth to FULL_WIDTH, and hJapaneseSyllabary to TX_KATAKANA

DEF TX_RAM1       EQU $09 ; prints the player's name or, in a duel, the turn duelist's name
DEF TX_LINE       EQU "\n" ; advances to a new line
DEF TX_RAM2       EQU $0b ; prints text from wTxRam2 or wTxRam2_b
DEF TX_RAM3       EQU $0c ; prints a number from wTxRam3 or wTxRam3_b

; usage: TX_FULLWIDTH*, char1, char2, ...
; sources:
   ; gfx/fonts/full_width/0_1_hiragana.1bpp (characters below $60)
   ; gfx/fonts/full_width/0_2_digits_kanji1.1bpp (characters above or equal to $60)
DEF TX_HIRAGANA EQU $0e ; sets hJapaneseSyllabary to TX_HIRAGANA
; sources:
   ; gfx/fonts/full_width/0_0_katakana.1bpp (characters below $60)
   ; gfx/fonts/full_width/0_2_digits_kanji1.1bpp (characters above or equal to $60)
DEF TX_KATAKANA EQU $0f ; sets hJapaneseSyllabary to TX_KATAKANA

; db char1, char2, ... defaults to the value at hJapaneseSyllabary, unless
; wFontWidth was set to HALF_WIDTH by TX_HALFWIDTH (it is FULL_WIDTH by default).
; hJapaneseSyllabary is TX_KATAKANA by default.

DEF TX_CTRL_END   EQU $10

; wFontWidth constants
DEF FULL_WIDTH EQU $0
DEF HALF_WIDTH EQU $1 ; non-0

; wLineSeparation constants
DEF DOUBLE_SPACED EQU 0
DEF SINGLE_SPACED EQU 1 ; non-0
