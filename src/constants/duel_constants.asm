MAX_BENCH_POKEMON     EQU 5
MAX_PLAY_AREA_POKEMON EQU 6 ; arena + bench
MAX_HP                EQU 120
HP_BAR_LENGTH         EQU MAX_HP / 10

STARTING_HAND_SIZE EQU 7

; hWhoseTurn constants
PLAYER_TURN   EQUS "HIGH(wPlayerDuelVariables)"
OPPONENT_TURN EQUS "HIGH(wOpponentDuelVariables)"

; wDuelType constants
DUELTYPE_LINK     EQU $1
DUELTYPE_PRACTICE EQU $80
; for normal duels (vs AI), wDuelType is $80 + [wOpponentDeckID]

; wDuelFinished constants
DUEL_NOT_FINISHED EQU $0
TURN_PLAYER_WON   EQU $1
TURN_PLAYER_LOST  EQU $2
TURN_PLAYER_TIED  EQU $3

; wDuelResult constants
DUEL_WIN  EQU $0
DUEL_LOSS EQU $1

; wPlayerDuelVariables or wOpponentDuelVariables constants
DUELVARS_CARD_LOCATIONS                   EQUS "LOW(wPlayerCardLocations)"               ; 00
DUELVARS_PRIZE_CARDS                      EQUS "LOW(wPlayerPrizeCards)"                  ; 3c
DUELVARS_HAND                             EQUS "LOW(wPlayerHand)"                        ; 42
DUELVARS_DECK_CARDS                       EQUS "LOW(wPlayerDeckCards)"                   ; 7e
DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK      EQUS "LOW(wPlayerNumberOfCardsNotInDeck)"      ; ba
DUELVARS_ARENA_CARD                       EQUS "LOW(wPlayerArenaCard)"                   ; bb
DUELVARS_BENCH                            EQUS "LOW(wPlayerBench)"                       ; bc
DUELVARS_ARENA_CARD_FLAGS              EQUS "LOW(wPlayerArenaCardFlags)"              ; c2
DUELVARS_ARENA_CARD_HP                    EQUS "LOW(wPlayerArenaCardHP)"                 ; c8
DUELVARS_BENCH1_CARD_HP                   EQUS "LOW(wPlayerBench1CardHP)"                ; c9
DUELVARS_BENCH2_CARD_HP                   EQUS "LOW(wPlayerBench2CardHP)"                ; ca
DUELVARS_BENCH3_CARD_HP                   EQUS "LOW(wPlayerBench3CardHP)"                ; cb
DUELVARS_BENCH4_CARD_HP                   EQUS "LOW(wPlayerBench4CardHP)"                ; cc
DUELVARS_BENCH5_CARD_HP                   EQUS "LOW(wPlayerBench5CardHP)"                ; cd
DUELVARS_ARENA_CARD_STAGE                 EQUS "LOW(wPlayerArenaCardStage)"              ; ce
DUELVARS_BENCH1_CARD_STAGE                EQUS "LOW(wPlayerBench1CardStage)"             ; cf
DUELVARS_BENCH2_CARD_STAGE                EQUS "LOW(wPlayerBench2CardStage)"             ; d0
DUELVARS_BENCH3_CARD_STAGE                EQUS "LOW(wPlayerBench3CardStage)"             ; d1
DUELVARS_BENCH4_CARD_STAGE                EQUS "LOW(wPlayerBench4CardStage)"             ; d2
DUELVARS_BENCH5_CARD_STAGE                EQUS "LOW(wPlayerBench5CardStage)"             ; d3
DUELVARS_ARENA_CARD_CHANGED_TYPE         EQUS "LOW(wPlayerArenaCardChangedType)"       ; d4
DUELVARS_BENCH1_CARD_CHANGED_COLOR        EQUS "LOW(wPlayerBench1CardChangedType)"      ; d5
DUELVARS_BENCH2_CARD_CHANGED_COLOR        EQUS "LOW(wPlayerBench2CardChangedType)"      ; d6
DUELVARS_BENCH3_CARD_CHANGED_COLOR        EQUS "LOW(wPlayerBench3CardChangedType)"      ; d7
DUELVARS_BENCH4_CARD_CHANGED_COLOR        EQUS "LOW(wPlayerBench4CardChangedType)"      ; d8
DUELVARS_BENCH5_CARD_CHANGED_COLOR        EQUS "LOW(wPlayerBench5CardChangedType)"      ; d9
DUELVARS_ARENA_CARD_ATTACHED_DEFENDER     EQUS "LOW(wPlayerArenaCardAttachedDefender)"   ; da
DUELVARS_BENCH1_CARD_ATTACHED_DEFENDER    EQUS "LOW(wPlayerBench1CardAttachedDefender)"  ; db
DUELVARS_BENCH2_CARD_ATTACHED_DEFENDER    EQUS "LOW(wPlayerBench2CardAttachedDefender)"  ; dc
DUELVARS_BENCH3_CARD_ATTACHED_DEFENDER    EQUS "LOW(wPlayerBench3CardAttachedDefender)"  ; dd
DUELVARS_BENCH4_CARD_ATTACHED_DEFENDER    EQUS "LOW(wPlayerBench4CardAttachedDefender)"  ; de
DUELVARS_BENCH5_CARD_ATTACHED_DEFENDER    EQUS "LOW(wPlayerBench5CardAttachedDefender)"  ; df
DUELVARS_ARENA_CARD_ATTACHED_PLUSPOWER    EQUS "LOW(wPlayerArenaCardAttachedPluspower)"  ; e0
DUELVARS_BENCH1_CARD_ATTACHED_PLUSPOWER   EQUS "LOW(wPlayerBench1CardAttachedPluspower)" ; e1
DUELVARS_BENCH2_CARD_ATTACHED_PLUSPOWER   EQUS "LOW(wPlayerBench2CardAttachedPluspower)" ; e2
DUELVARS_BENCH3_CARD_ATTACHED_PLUSPOWER   EQUS "LOW(wPlayerBench3CardAttachedPluspower)" ; e3
DUELVARS_BENCH4_CARD_ATTACHED_PLUSPOWER   EQUS "LOW(wPlayerBench4CardAttachedPluspower)" ; e4
DUELVARS_BENCH5_CARD_ATTACHED_PLUSPOWER   EQUS "LOW(wPlayerBench5CardAttachedPluspower)" ; e5
DUELVARS_ARENA_CARD_SUBSTATUS1            EQUS "LOW(wPlayerArenaCardSubstatus1)"         ; e7
DUELVARS_ARENA_CARD_SUBSTATUS2            EQUS "LOW(wPlayerArenaCardSubstatus2)"         ; e8
DUELVARS_ARENA_CARD_CHANGED_WEAKNESS      EQUS "LOW(wPlayerArenaCardChangedWeakness)"    ; e9
DUELVARS_ARENA_CARD_CHANGED_RESISTANCE    EQUS "LOW(wPlayerArenaCardChangedResistance)"  ; ea
DUELVARS_ARENA_CARD_SUBSTATUS3            EQUS "LOW(wPlayerArenaCardSubstatus3)"         ; eb
DUELVARS_PRIZES                           EQUS "LOW(wPlayerPrizes)"                      ; ec
DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE  EQUS "LOW(wPlayerNumberOfCardsInDiscardPile)"  ; ed
DUELVARS_NUMBER_OF_CARDS_IN_HAND          EQUS "LOW(wPlayerNumberOfCardsInHand)"         ; ee
DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA   EQUS "LOW(wPlayerNumberOfPokemonInPlayArea)"   ; ef
DUELVARS_ARENA_CARD_STATUS                EQUS "LOW(wPlayerArenaCardStatus)"             ; f0
DUELVARS_DUELIST_TYPE                     EQUS "LOW(wPlayerDuelistType)"                 ; f1
DUELVARS_ARENA_CARD_DISABLED_MOVE_INDEX   EQUS "LOW(wPlayerArenaCardDisabledMoveIndex)"  ; f2
DUELVARS_ARENA_CARD_LAST_TURN_DAMAGE      EQUS "LOW(wPlayerArenaCardLastTurnDamage)"     ; f3
DUELVARS_ARENA_CARD_LAST_TURN_STATUS      EQUS "LOW(wPlayerArenaCardLastTurnStatus)"     ; f5
DUELVARS_ARENA_CARD_LAST_TURN_SUBSTATUS2  EQUS "LOW(wPlayerArenaCardLastTurnSubstatus2)" ; f6
DUELVARS_ARENA_CARD_LAST_TURN_CHANGE_WEAK EQUS "LOW(wPlayerArenaCardLastTurnChangeWeak)" ; f7
DUELVARS_ARENA_CARD_LAST_TURN_EFFECT      EQUS "LOW(wPlayerArenaCardLastTurnEffect)"     ; f8

; card location constants (DUELVARS_CARD_LOCATIONS)
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

; card location flags (DUELVARS_CARD_LOCATIONS)
CARD_LOCATION_PLAY_AREA_F  EQU 4 ; includes arena and bench
CARD_LOCATION_PLAY_AREA    EQU 1 << CARD_LOCATION_PLAY_AREA_F
CARD_LOCATION_JUST_DRAWN_F EQU 6
CARD_LOCATION_JUST_DRAWN   EQU 1 << CARD_LOCATION_JUST_DRAWN_F

; play area location offsets (CARD_LOCATION_* - CARD_LOCATION_PLAY_AREA)
PLAY_AREA_ARENA   EQU $0
PLAY_AREA_BENCH_1 EQU $1
PLAY_AREA_BENCH_2 EQU $2
PLAY_AREA_BENCH_3 EQU $3
PLAY_AREA_BENCH_4 EQU $4
PLAY_AREA_BENCH_5 EQU $5

; duelist types (DUELVARS_DUELIST_TYPE)
DUELIST_TYPE_PLAYER   EQU $00
DUELIST_TYPE_LINK_OPP EQU $01
DUELIST_TYPE_AI_OPP   EQU $80 ; $80 + [wOpponentDeckID]

; status conditions (DUELVARS_ARENA_CARD_STATUS)
; two statuses can be combined if they are identified by a different nybble
NO_STATUS       EQU $00
CONFUSED        EQU $01
ASLEEP          EQU $02
PARALYZED       EQU $03
POISONED        EQU $80
DOUBLE_POISONED EQU $c0


DOUBLE_POISONED_F EQU 6
POISONED_F        EQU 7


CNF_SLP_PRZ   EQU $0f ; confused, asleep or paralyzed
PSN_DBLPSN    EQU $f0 ; poisoned or double poisoned
PSN_DAMAGE    EQU 10
DBLPSN_DAMAGE EQU 20

; substatus conditions (DUELVARS_ARENA_CARD_SUBSTATUS*)

; SUBSTATUS1 are checked on a defending Pokemon
SUBSTATUS1_AGILITY      EQU $0c
SUBSTATUS1_FLY          EQU $0d
SUBSTATUS1_HARDEN       EQU $0e
SUBSTATUS1_NO_DAMAGE_STIFFEN  EQU $0f
SUBSTATUS1_NO_DAMAGE_10 EQU $10
SUBSTATUS1_NO_DAMAGE_11 EQU $11
SUBSTATUS1_REDUCE_BY_20 EQU $13
SUBSTATUS1_BARRIER      EQU $14
SUBSTATUS1_HALVE_DAMAGE EQU $15
SUBSTATUS1_DESTINY_BOND EQU $16
SUBSTATUS1_NO_DAMAGE_17 EQU $17
SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE EQU $19
SUBSTATUS1_REDUCE_BY_10 EQU $1e

; SUBSTATUS2 are checked on an attacking Pokemon
SUBSTATUS2_SMOKESCREEN    EQU $01
SUBSTATUS2_SAND_ATTACK    EQU $02
SUBSTATUS2_REDUCE_BY_20   EQU $03
SUBSTATUS2_AMNESIA        EQU $04
SUBSTATUS2_TAIL_WAG       EQU $05
SUBSTATUS2_LEER           EQU $06
SUBSTATUS2_POUNCE         EQU $07
SUBSTATUS2_CONVERSION2    EQU $08
SUBSTATUS2_UNABLE_RETREAT EQU $09
SUBSTATUS2_BONE_ATTACK    EQU $0b
SUBSTATUS2_GROWL          EQU $12

SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE EQU 0
SUBSTATUS3_HEADACHE                EQU 1

; DUELVARS_ARENA_CARD_FLAGS constants
USED_PKMN_POWER_THIS_TURN_F EQU 5
USED_LEEK_SLAP_THIS_DUEL_F  EQU 6
CAN_EVOLVE_THIS_TURN_F      EQU 7

USED_PKMN_POWER_THIS_TURN   EQU 1 << USED_PKMN_POWER_THIS_TURN_F
USED_LEEK_SLAP_THIS_DUEL    EQU 1 << USED_LEEK_SLAP_THIS_DUEL_F
CAN_EVOLVE_THIS_TURN        EQU 1 << CAN_EVOLVE_THIS_TURN_F

; DUELVARS_ARENA_CARD_LAST_TURN_EFFECT constants
	const_def
	const LAST_TURN_EFFECT_NONE           ; $00
	const LAST_TURN_EFFECT_DISCARD_ENERGY ; $01
	const LAST_TURN_EFFECT_AMNESIA        ; $02

; *_CHANGED_COLOR constants
HAS_CHANGED_COLOR_F EQU 7
HAS_CHANGED_COLOR   EQU 1 << HAS_CHANGED_COLOR_F

; flag in wDamage + 1 that indicates
; whether damage is unaffected by Weakness/Resistance
UNAFFECTED_BY_WEAKNESS_RESISTANCE_F EQU 7

; effect command constants (TryExecuteEffectCommandFunction)
; ordered by (roughly) execution time
EFFECTCMDTYPE_INITIAL_EFFECT_1         EQU $01
EFFECTCMDTYPE_INITIAL_EFFECT_2         EQU $02
EFFECTCMDTYPE_DISCARD_ENERGY           EQU $06
EFFECTCMDTYPE_REQUIRE_SELECTION        EQU $05
EFFECTCMDTYPE_BEFORE_DAMAGE            EQU $03
EFFECTCMDTYPE_AFTER_DAMAGE             EQU $04
EFFECTCMDTYPE_AI_SELECTION             EQU $08
EFFECTCMDTYPE_AI_SWITCH_DEFENDING_PKMN EQU $0a
EFFECTCMDTYPE_PKMN_POWER_TRIGGER       EQU $07
EFFECTCMDTYPE_AI                       EQU $09

; wDamageEffectiveness constants
WEAKNESS   EQU 1
RESISTANCE EQU 2

; wNoDamageOrEffect constants
NO_DAMAGE_OR_EFFECT_AGILITY      EQU $01
NO_DAMAGE_OR_EFFECT_BARRIER      EQU $02
NO_DAMAGE_OR_EFFECT_FLY          EQU $03
NO_DAMAGE_OR_EFFECT_TRANSPARENCY EQU $04
NO_DAMAGE_OR_EFFECT_NSHIELD      EQU $05

; OppAction_* constants (OppActionTable)
	const_def
	const OPPACTION_ERROR                     ; $00
	const OPPACTION_PLAY_BASIC_PKMN           ; $01
	const OPPACTION_EVOLVE_PKMN               ; $02
	const OPPACTION_PLAY_ENERGY               ; $03
	const OPPACTION_ATTEMPT_RETREAT           ; $04
	const OPPACTION_FINISH_NO_ATTACK          ; $05
	const OPPACTION_PLAY_TRAINER              ; $06
	const OPPACTION_EXECUTE_TRAINER_EFFECTS   ; $07
	const OPPACTION_BEGIN_ATTACK              ; $08
	const OPPACTION_USE_ATTACK                ; $09
	const OPPACTION_ATTACK_ANIM_AND_DAMAGE    ; $0a
	const OPPACTION_DRAW_CARD                 ; $0b
	const OPPACTION_USE_PKMN_POWER            ; $0c
	const OPPACTION_EXECUTE_PKMN_POWER_EFFECT ; $0d
	const OPPACTION_FORCE_SWITCH_ACTIVE       ; $0e
	const OPPACTION_NO_ACTION_0F              ; $0f
	const OPPACTION_NO_ACTION_10              ; $10
	const OPPACTION_TOSS_COIN_A_TIMES         ; $11
	const OPPACTION_6B30                      ; $12
	const OPPACTION_NO_ACTION_13              ; $13
	const OPPACTION_USE_METRONOME_ATTACK      ; $14
	const OPPACTION_6B15                      ; $15
	const OPPACTION_DUEL_MAIN_SCENE           ; $16

; constants for PracticeDuelActionTable entries
	const_def 1
	const PRACTICEDUEL_DRAW_SEVEN_CARDS
	const PRACTICEDUEL_PLAY_GOLDEEN
	const PRACTICEDUEL_PUT_STARYU_IN_BENCH
	const PRACTICEDUEL_VERIFY_INITIAL_PLAY
	const PRACTICEDUEL_DONE_PUTTING_ON_BENCH
	const PRACTICEDUEL_PRINT_TURN_INSTRUCTIONS
	const PRACTICEDUEL_VERIFY_PLAYER_TURN_ACTIONS
	const PRACTICEDUEL_REPEAT_INSTRUCTIONS
	const PRACTICEDUEL_PLAY_STARYU_FROM_BENCH
	const PRACTICEDUEL_REPLACE_KNOCKED_OUT_POKEMON

; wEffectFailed constants
EFFECT_FAILED_NO_EFFECT    EQU $01
EFFECT_FAILED_UNSUCCESSFUL EQU $02

; wAnimationQueue length
ANIMATION_QUEUE_LENGTH EQU 7

PRIZES_1	EQU $01
PRIZES_2	EQU $02
PRIZES_3	EQU $03
PRIZES_4	EQU $04
PRIZES_5	EQU $05
PRIZES_6	EQU $06

; constants to use as input to LookForCardInDeck
SEARCHEFFECT_CARD_ID        EQU $0
SEARCHEFFECT_NIDORAN        EQU $1
SEARCHEFFECT_BASIC_FIGHTING EQU $2
SEARCHEFFECT_BASIC_ENERGY   EQU $3
SEARCHEFFECT_POKEMON        EQU $4
