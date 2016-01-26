CARD_DATA_LENGTH EQU $41
DECK_SIZE        EQU  60
BENCH_SIZE       EQU   5

;;; card types (byte 1 of every card data)
FIRE      EQU $0
GRASS     EQU $1
LIGHTNING EQU $2
WATER     EQU $3
FIGHTING  EQU $4
PSYCHIC   EQU $5
COLORLESS EQU $6

FIRE_ENERGY_CARD             EQU $8
GRASS_ENERGY_CARD            EQU $9
LIGHTNING_ENERGY_CARD        EQU $A
WATER_ENERGY_CARD            EQU $B
FIGHTING_ENERGY_CARD         EQU $C
PSYCHIC_ENERGY_CARD          EQU $D
DOUBLE_COLORLESS_ENERGY_CARD EQU $E

TRAINER_CARD EQU $10

;;; weakness/resistance (bytes 2 and 3 of Pokemon cards post-move data)
WR_FIRE      EQU $80
WR_GRASS     EQU $40
WR_LIGHTNING EQU $20
WR_WATER     EQU $10
WR_FIGHTING  EQU $08
WR_PSYCHIC   EQU $04

;;; move category (6th param of Pokemon cards move data)
DAMAGE_NORMAL EQU  $0
DAMAGE_PLUS   EQU  $1
DAMAGE_MINUS  EQU  $2
DAMAGE_X      EQU  $3
POKEMON_POWER EQU  $4
RESIDUAL      EQU $80

;;; flags 1 (8th param of Pokemon cards move data)
INFLICT_POISON           EQU %00000001
INFLICT_SLEEP            EQU %00000010
INFLICT_PARALYSIS        EQU %00000100
INFLICT_CONFUSION        EQU %00001000
LOW_RECOIL               EQU %00010000
DAMAGE_TO_OPPONENT_BENCH EQU %00100000
HIGH_RECOIL              EQU %01000000
DRAW_CARD                EQU %10000000

;;; flags 2 (9th param of Pokemon cards move data)
; bits 5, 6 and 7 cover a wide variety of effects
SWITCH_OPPONENT_POKEMON  EQU %00000001
HEAL_USER                EQU %00000010
NULLIFY_OR_WEAKEN_ATTACK EQU %00000100
DISCARD_ENERGY           EQU %00001000
ATTACHED_ENERGY_BOOST    EQU %00010000
FLAG_2_BIT_5             EQU %00100000
FLAG_2_BIT_6             EQU %01000000
FLAG_2_BIT_7             EQU %10000000

;;; flags 2 (10th param of Pokemon cards move data)
; bit 1 covers a wide variety of effects
; bits 2-7 are unused
BOOST_IF_TAKEN_DAMAGE    EQU %00000001
FLAG_3_BIT_1             EQU %00000010
