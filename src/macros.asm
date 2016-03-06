;;; engine macros

dbw: MACRO
	db \1
	dw \2
ENDM

lb: MACRO ; r, hi, lo
	ld \1, (\2) << 8 + ((\3) & $ff)
ENDM

bank1call: MACRO
	rst $18
	dw \1
ENDM

farcall: MACRO
	rst $28
	db BANK(\1)
	dw \1
ENDM

; used when the specified bank does not match the bank of the specified function
; otherwise, farcall is preferred
farcallx: MACRO
	rst $28
	db \1
	dw \2
ENDM

emptybank: MACRO
	rept $4000
	db $ff
	endr
ENDM

rgb: MACRO
	dw (\3 << 10 | \2 << 5 | \1)
ENDM

text: MACRO
	dw ((\1 + ($4000 * (BANK(\1) - 1))) - (TextOffsets + ($4000 * (BANK(TextOffsets) - 1)))) & $ffff
	db ((\1 + ($4000 * (BANK(\1) - 1))) - (TextOffsets + ($4000 * (BANK(TextOffsets) - 1)))) >> 16
\1_ EQU const_value
GLOBAL \1_
const_value = const_value + 1
ENDM

text_hl: MACRO
	ld hl, \1_
ENDM

text_de: MACRO
	ld de, \1_
ENDM

sgb: MACRO
	db \1 * 8 + \2 ; sgb_command * 8 + length
ENDM

;;; notes/instruments macros

C_: MACRO
	db $10 | (\1 - 1)
ENDM

C#: MACRO
	db $20 | (\1 - 1)
ENDM

D_: MACRO
	db $30 | (\1 - 1)
ENDM

D#: MACRO
	db $40 | (\1 - 1)
ENDM

E_: MACRO
	db $50 | (\1 - 1)
ENDM

F_: MACRO
	db $60 | (\1 - 1)
ENDM

F#: MACRO
	db $70 | (\1 - 1)
ENDM

G_: MACRO
	db $80 | (\1 - 1)
ENDM

G#: MACRO
	db $90 | (\1 - 1)
ENDM

A_: MACRO
	db $A0 | (\1 - 1)
ENDM

A#: MACRO
	db $B0 | (\1 - 1)
ENDM

B_: MACRO
	db $C0 | (\1 - 1)
ENDM

bass: MACRO
	db $10 | (\1 - 1)
ENDM

snare1: MACRO ; medium length
	db $30 | (\1 - 1)
ENDM

snare2: MACRO ; medium length
	db $50 | (\1 - 1)
ENDM

snare3: MACRO ; short
	db $70 | (\1 - 1)
ENDM

snare4: MACRO ; long
	db $90 | (\1 - 1)
ENDM

snare5: MACRO ; long
	db $C0 | (\1 - 1)
ENDM

rest: MACRO
	db \1 - 1
ENDM

speed: MACRO
	db $d0, \1
ENDM

octave: MACRO
	db ($d << 4) | \1
ENDM

inc_octave: MACRO
	db $d7
ENDM

dec_octave: MACRO
	db $d8
ENDM

tie: MACRO
	db $d9
ENDM

musicdc: MACRO
	db $dc, \1
ENDM

MainLoop: MACRO
	db $dd
ENDM

EndMainLoop: MACRO
	db $de
ENDM

Loop: MACRO
	db $df, \1
ENDM

EndLoop: MACRO
	db $e0
ENDM

; unused
;music_jp: MACRO
;	db $e1
;	dw \1
;ENDM

music_call: MACRO
	db $e2
	dw \1
ENDM

music_ret: MACRO
	db $e3
ENDM

musice4: MACRO
	db $e4, \1
ENDM

duty: MACRO
	db $e5, \1 << 6
ENDM

volume: MACRO
	db $e6, \1
ENDM

wave: MACRO
	db $e7, \1
ENDM

musice8: MACRO
	db $e8, \1
ENDM

musice9: MACRO
	db $e9, \1
ENDM

vibrato_type: MACRO
	db $ea, \1
ENDM

vibrato_delay: MACRO
	db $eb, \1
ENDM

; unused
;musicec: MACRO
;	db $ec, \1
;ENDM

; unused
;musiced: MACRO
;	db $ed, \1
;ENDM

music_end: MACRO
	db $ff
ENDM

sfx_0: MACRO
	db \1, \2
ENDM

sfx_1: MACRO
	db $10, \1
ENDM

sfx_2: MACRO
	db $20 | \1
ENDM

sfx_loop: MACRO
	db $30, \1
ENDM

sfx_endloop: MACRO
	db $40
ENDM

sfx_5: MACRO
	db $50, \1
ENDM

sfx_6: MACRO
	db $60, \1
ENDM

sfx_8: MACRO
	db $80, \1
ENDM

sfx_end: MACRO
	db $f0
ENDM

;;; card macros

energy: MACRO
fg = 0
lw = 0
fp = 0
c_ = 0

	if _NARG > 1

	rept _NARG / 2

	if \1 == FIRE
fg = fg + \2 * $10
	endc
	if \1 == GRASS
fg = fg + \2
	endc
	if \1 == LIGHTNING
lw = lw + \2 * $10
	endc
	if \1 == WATER
lw = lw + \2
	endc
	if \1 == FIGHTING
fp = fp + \2 * $10
	endc
	if \1 == PSYCHIC
fp = fp + \2
	endc
	if \1 == COLORLESS
c_ = c_ + \2 * $10
	endc

	shift
	shift

	endr

	endc
	db fg, lw, fp, c_
ENDM

gfx: MACRO
	dw ($4000 * (BANK(\1) - BANK(GrassEnergyCardGfx)) + (\1 - $4000)) / 8
ENDM

tx: MACRO
	dw \1_
ENDM

card_data_struct: MACRO
\1Type::          db
\1Gfx::           dw
\1Name::          dw
\1Rarity::        db
\1Set::           db
\1ID::            db
\1EnergyCardEffectCommands::  ; dw
\1TrainerCardEffectCommands:: ; dw
\1HP::            db
\1Stage::         db
\1EnergyCardDescription::     ; dw
\1TrainerCardDescription::    ; dw
\1PreEvoName::    dw
\1Move1::         move_data_struct \1Move1
\1Move2::         move_data_struct \1Move2
\1RetreatCost::   db
\1Weakness::      db
\1Resistance::    db
\1Kind::          dw
\1PokedexNumber:: db
\1Unknown1::      db
\1Level::         db
\1Length::        dw
\1Weight::        dw
\1Description::   dw
\1Unknown2::      db
ENDM

move_data_struct: MACRO
\1Energy::         ds $4
\1Name::           dw
\1Description::    ds $4
\1Damage::         db
\1Category::       db
\1EffectCommands:: dw
\1Flag1::          db
\1Flag2::          db
\1Flag3::          db
\1Unknown1::       db
\1Unknown2::       db
ENDM
