; wPreviousAIFlags and wCurrentAIFlags constants
AI_FLAG_USED_PLUSPOWER     EQU 1 << 0
AI_FLAG_USED_SWITCH        EQU 1 << 1
AI_FLAG_USED_PROFESSOR_OAK EQU 1 << 2
AI_FLAG_MODIFIED_HAND      EQU 1 << 3
AI_FLAG_USED_GUST_OF_WIND  EQU 1 << 4

; used as input for AIProcessEnergyCards to determine what to check
; and whether to play card after the routine is over.
; I suspect AI_ENERGY_FLAG_DONT_PLAY to be a flag to signal the routine
; not to actually play the energy card after it's finished,
; but AIProcessEnergyCards checks whether ANY flag is set in order
; to decide not to play it, so it's redundant in the presence of another flag.
AI_ENERGY_FLAG_DONT_PLAY       EQU 1 << 0 ; whether to play energy card (?)
AI_ENERGY_FLAG_SKIP_EVOLUTION  EQU 1 << 1 ; whether to check if card has evolutions
AI_ENERGY_FLAG_SKIP_ARENA_CARD EQU 1 << 7 ; whether to include Arena card in determining which card to attach energy

; used to determine which Trainer cards for AI
; to process in AIProcessHandTrainerCards.
; these go in chronological order, except for
; AI_TRAINER_CARD_PHASE_14 which happens just before AI attacks.
; AI_TRAINER_CARD_PHASE_15 is reserved for Professor Oak card.
; if Professor Oak is played, all other Trainer card phases
; are processed again except AI_TRAINER_CARD_PHASE_15.
	const_def 1
	const AI_TRAINER_CARD_PHASE_01 ; $1
	const AI_TRAINER_CARD_PHASE_02 ; $2
	const AI_TRAINER_CARD_PHASE_03 ; $3
	const AI_TRAINER_CARD_PHASE_04 ; $4
	const AI_TRAINER_CARD_PHASE_05 ; $5
	const AI_TRAINER_CARD_PHASE_06 ; $6
	const AI_TRAINER_CARD_PHASE_07 ; $7
	const AI_TRAINER_CARD_PHASE_08 ; $8
	const AI_TRAINER_CARD_PHASE_09 ; $9
	const AI_TRAINER_CARD_PHASE_10 ; $a
	const AI_TRAINER_CARD_PHASE_11 ; $b
	const AI_TRAINER_CARD_PHASE_12 ; $c
	const AI_TRAINER_CARD_PHASE_13 ; $d
	const AI_TRAINER_CARD_PHASE_14 ; $e, just before attack
	const AI_TRAINER_CARD_PHASE_15 ; $f, for Professor Oak

; used by wAIBarrierFlagCounter to determine
; whether Player is running Mewtwo1 mill deck.
; flag set means true, flag not set means false.
AI_FLAG_MEWTWO_MILL EQU 1 << 7

; defines the behaviour of HandleAIEnergyTrans, for determining
; whether to move energy cards from the Bench to the Arena or vice-versa
; and the number of energy cards needed for achieving that.
AI_ENERGY_TRANS_RETREAT  EQU $9 ; moves energy cards needed for Retreat Cost
AI_ENERGY_TRANS_ATTACK   EQU $d ; moves energy cards needed for second attack
AI_ENERGY_TRANS_TO_BENCH EQU $e ; moves energy cards away from Arena card

; used to know which AI routine to call in
; the AIAction pointer tables in AIDoAction
	const_def 1
	const AIACTION_DO_TURN       ; $1
	const AIACTION_START_DUEL    ; $2
	const AIACTION_FORCED_SWITCH ; $3
	const AIACTION_KO_SWITCH     ; $4
	const AIACTION_TAKE_PRIZE    ; $5
