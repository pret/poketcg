Poison50PercentEffect: ; 2c000 (b:4000)
        text_de PoisonCheckText
        call DisplayCoinTossScreen2_BankB
        ret nc

PoisonEffect: ; 2c007 (b:4007)
        lb bc, $0f, POISONED
        jr applyEffect

        lb bc, $0f, DOUBLE_POISONED
        jr applyEffect

Paralysis50PercentEffect: ; 2c011 (b:4011)
        text_de ParalysisCheckText
        call DisplayCoinTossScreen2_BankB
        ret nc
        lb bc, $f0, PARALYZED
        jr applyEffect

Confusion50PercentEffect: ; 2c01d (b:401d)
        text_de ConfusionCheckText
        call DisplayCoinTossScreen2_BankB
        ret nc
        lb bc, $f0, CONFUSED
        jr applyEffect

        text_de SleepCheckText
        call DisplayCoinTossScreen2_BankB
        ret nc

SleepEffect: ; 2c030 (b:4030)
        lb bc, $f0, ASLEEP
        jr applyEffect

applyEffect
        ld a, [$ff97]
        ld hl, $cc05
        cp [hl]
        jr nz, .asm_2c061
        ld a, [wccc4]
        cp $cb
        jr z, .asm_2c058
        cp $cc
        jr z, .asm_2c058
        cp $be
        jr nz, .asm_2c061
        call SwapTurn
        xor a
        call Func_34f0
        call SwapTurn
        jr c, .asm_2c061

.asm_2c058
        ld a, c
        ld [wccf1], a
        call Func_2c09c
        or a
        ret

.asm_2c061
        ld hl, wcccd
        push hl
        ld e, [hl]
        ld d, $0
        ld hl, $ccce
        add hl, de
        call SwapTurn
        ld a, [$ff97]
        ld [hli], a
        call SwapTurn
        ld [hl], b
        inc hl
        ld [hl], c
        pop hl
        inc [hl]
        inc [hl]
        inc [hl]
        scf
        ret
; 0x2c07e

DisplayCoinTossScreen2_BankB: ; 2c07e (b:407e)
        call DisplayCoinTossScreen2
        ret
; 0x2c082

INCBIN "baserom.gbc",$2c082,$2c09c - $2c082

Func_2c09c: ; 2c09c (b:409c)
        ld a, $1
        ld [wcced], a
        ret
; 0x2c0a2

INCBIN "baserom.gbc",$2c0a2,$30000 - $2c0a2
