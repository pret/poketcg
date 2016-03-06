PLAYER_TURN   EQUS "wPlayerDuelVariables >> $8"
OPPONENT_TURN EQUS "wOpponentDuelVariables >> $8"

DUEL_WON  EQU $1
DUEL_LOST EQU $2
DUEL_DRAW EQU $3

DUELVARS_CARD_LOCATIONS                  EQUS "wPlayerCardLocations & $ff"              ; 00
DUELVARS_HAND                            EQUS "wPlayerHand & $ff"                       ; 42
DUELVARS_DECK_CARDS                      EQUS "wPlayerDeckCards & $ff"                  ; 7e
DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK     EQUS "wPlayerNumberOfCardsNotInDeck & $ff"     ; ba
DUELVARS_ARENA_CARD                      EQUS "wPlayerArenaCard & $ff"                  ; bb
DUELVARS_BENCH                           EQUS "wPlayerBench & $ff"                      ; bc
DUELVARS_ARENA_CARD_HP                   EQUS "wPlayerArenaCardHP & $ff"                ; c8
DUELVARS_BENCH1_CARD_HP                  EQUS "wPlayerBench1CardHP & $ff"               ; c9
DUELVARS_BENCH2_CARD_HP                  EQUS "wPlayerBench2CardHP & $ff"               ; ca
DUELVARS_BENCH3_CARD_HP                  EQUS "wPlayerBench3CardHP & $ff"               ; cb
DUELVARS_BENCH4_CARD_HP                  EQUS "wPlayerBench4CardHP & $ff"               ; cc
DUELVARS_BENCH5_CARD_HP                  EQUS "wPlayerBench5CardHP & $ff"               ; cd
DUELVARS_ARENA_CARD_SUBSTATUS1           EQUS "wPlayerArenaCardSubstatus1 & $ff"        ; e7
DUELVARS_ARENA_CARD_SUBSTATUS2           EQUS "wPlayerArenaCardSubstatus2 & $ff"        ; e8
DUELVARS_ARENA_CARD_SUBSTATUS3           EQUS "wPlayerArenaCardSubstatus3 & $ff"        ; e9
DUELVARS_ARENA_CARD_SUBSTATUS4           EQUS "wPlayerArenaCardSubstatus4 & $ff"        ; ea
DUELVARS_ARENA_CARD_SUBSTATUS5           EQUS "wPlayerArenaCardSubstatus5 & $ff"        ; eb
DUELVARS_PRIZES                          EQUS "wPlayerPrizes & $ff"                     ; ec
DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE EQUS "wPlayerNumberOfCardsInDiscardPile & $ff" ; ed
DUELVARS_NUMBER_OF_CARDS_IN_HAND         EQUS "wPlayerNumberOfCardsInHand & $ff"        ; ee
DUELVARS_NUMBER_OF_POKEMON_IN_PLAY       EQUS "wPlayerNumberOfPokemonInPlay & $ff"      ; ef
DUELVARS_ARENA_CARD_STATUS               EQUS "wPlayerArenaCardStatus & $ff"            ; f0
DUELVARS_DUELIST_TYPE                    EQUS "wPlayerDuelistType & $ff"                ; f1
DUELVARS_ARENA_CARD_DISABLED_MOVE_INDEX  EQUS "wPlayerArenaCardDisabledMoveIndex & $ff" ; f2

;;; card locations
CARD_LOCATION_DECK         EQU $00
CARD_LOCATION_HAND         EQU $01
CARD_LOCATION_DISCARD_PILE EQU $02
CARD_LOCATION_PRIZE        EQU $08
CARD_LOCATION_ARENA        EQU $10
CARD_LOCATION_BENCH_1      EQU $11
CARD_LOCATION_BENCH_2      EQU $12
CARD_LOCATION_BENCH_3      EQU $13
CARD_LOCATION_BENCH_4      EQU $14
CARD_LOCATION_BENCH_5      EQU $15

;;; status conditions
; two statuses can be combined if they are identified by a different nybble
NO_STATUS       EQU $00
CONFUSED        EQU $01
ASLEEP          EQU $02
PARALYZED       EQU $03
POISONED        EQU $80
DOUBLE_POISONED EQU $c0

PASSIVE_STATUS_MASK  EQU $f ; confused, asleep or paralyzed

;;; substatus conditions
SUBSTATUS1_AGILITY      EQU $0c
SUBSTATUS1_FLY          EQU $0d
SUBSTATUS1_HARDEN       EQU $0e
SUBSTATUS1_NO_DAMAGE_F  EQU $0f
SUBSTATUS1_NO_DAMAGE_10 EQU $10
SUBSTATUS1_NO_DAMAGE_11 EQU $11
SUBSTATUS1_REDUCE_BY_20 EQU $13
SUBSTATUS1_BARRIER      EQU $14
SUBSTATUS1_HALVE_DAMAGE EQU $15
SUBSTATUS1_DESTINY_BOND EQU $16
SUBSTATUS1_NO_DAMAGE_17 EQU $17
SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE EQU $19
SUBSTATUS1_REDUCE_BY_10 EQU $1e

SUBSTATUS2_SMOKESCREEN  EQU $01
SUBSTATUS2_SAND_ATTACK  EQU $02
SUBSTATUS2_REDUCE_BY_20 EQU $03
SUBSTATUS2_AMNESIA      EQU $04
SUBSTATUS2_TAIL_WAG     EQU $05
SUBSTATUS2_LEER         EQU $06
SUBSTATUS2_POUNCE       EQU $07
SUBSTATUS2_BONE_ATTACK  EQU $0b
SUBSTATUS2_GROWL        EQU $12

SUBSTATUS5_THIS_TURN_DOUBLE_DAMAGE EQU 0
