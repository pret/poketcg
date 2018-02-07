GenerateBoosterPack: ; 1e1c4 (7:61c4)
	push hl
	push bc
	push de
	ld [wBoosterIndex], a
.noCardsFoundLoop
	call InitBoosterData
	call GenerateBoosterEnergies
	call GenerateBoosterNonEnergies
	jr c, .noCardsFoundLoop
	call PutEnergiesAndNonEnergiesTogether
	call AddBoosterCardsToCollection
	pop de
	pop bc
	pop hl
	ret

; generate all Pokemon or Trainer cards (if any) for the current booster pack
GenerateBoosterNonEnergies: ; 1e1df (7:61df)
	ld a, STAR
	ld [wBoosterCurRarity], a
.generateCardLoop
	call FindCurRarityChance
	ld a, [hl]
	or a
	jr z, .noMoreOfCurrentRarity
	call FindCardsInSetAndRarity
	call FindTotalTypeChances
	or a
	jr z, .noValidCards
	call Random
	call DetermineBoosterCardType
	call FindBoosterCard
	call UpdateBoosterCardTypesChanceByte
	call AddBoosterCardToDrawnNonEnergies
	call FindCurRarityChance
	dec [hl]
	jr .generateCardLoop
.noMoreOfCurrentRarity
	ld a, [wBoosterCurRarity]
	dec a
	ld [wBoosterCurRarity], a
	bit 7, a ; any rarity left to check?
	jr z, .generateCardLoop
	or a
	ret
.noValidCards
	rst $38
	scf
	ret

; return hl pointing to wBoosterData<Rarity>Amount[wBoosterCurRarity]
FindCurRarityChance: ; 1e219 (7:6219)
	push bc
	ld hl, wBoosterDataCommonAmount
	ld a, [wBoosterCurRarity]
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	ret

FindCardsInSetAndRarity: ; 1e226 (7:6226)
	ld c, NUM_BOOSTER_CARD_TYPES
	ld hl, wBoosterAmountOfCardTypeTable
	xor a
.deleteTypeTableLoop
	ld [hli], a
	dec c
	jr nz, .deleteTypeTableLoop
	xor a
	ld hl, wBoosterViableCardList
	ld [hl], a
	ld de, $1
.checkCardViableLoop
	push de
	ld a, e
	ld [wBoosterTempCard], a
	call IsByteInTempCardCollectionZero
	jr c, .finishedWithCurrentCard
	call CheckCardViable
	jr c, .finishedWithCurrentCard
	ld a, [wBoosterCurrentCardType]
	call GetCardType
	push af
	push hl
	ld c, a
	ld b, $00
	ld hl, wBoosterAmountOfCardTypeTable
	add hl, bc
	inc [hl]
	pop hl
	ld a, [wBoosterTempCard]
	ld [hli], a
	pop af
	ld [hli], a
	xor a
	ld [hl], a
.finishedWithCurrentCard
	pop de
	inc e
	ld a, e
	cp NUM_CARDS + 1
	jr c, .checkCardViableLoop
	ret

CheckCardViable: ; 1e268 (7:6268)
	push bc
	ld a, e
	call GetCardHeader
	ld [wBoosterCurrentCardType], a
	ld a, b
	ld [wBoosterCurrentCardRarity], a
	ld a, c
	ld [wBoosterCurrentCardSet], a
	ld a, [wBoosterCurrentCardRarity]
	ld c, a
	ld a, [wBoosterCurRarity]
	cp c
	jr nz, .invalidCard
	ld a, [wBoosterCurrentCardType]
	call GetCardType
	cp BOOSTER_CARD_TYPE_ENERGY
	jr z, .returnValidCard
	ld a, [wBoosterCurrentCardSet]
	swap a
	and $0f
	ld c, a
	ld a, [wBoosterDataSet]
	cp c
	jr nz, .invalidCard
.returnValidCard
	or a
	jr .return
.invalidCard
	scf
.return
	pop bc
	ret

; Map a card's TYPE_* constant given in a to its BOOSTER_CARD_TYPE_* constant
GetCardType: ; 1e2a0 (7:62a0)
	push hl
	push bc
	ld hl, CardTypeTable
	cp NUM_CARD_TYPES
	jr nc, .loadType
	ld c, a
	ld b, $00
	add hl, bc
.loadType
	ld a, [hl]
	pop bc
	pop hl
	ret

CardTypeTable:  ; 1e2b1 (7:62b1)
	db BOOSTER_CARD_TYPE_FIRE      ; TYPE_PKMN_FIRE
	db BOOSTER_CARD_TYPE_GRASS     ; TYPE_PKMN_GRASS
	db BOOSTER_CARD_TYPE_LIGHTNING ; TYPE_PKMN_LIGHTNING
	db BOOSTER_CARD_TYPE_WATER     ; TYPE_PKMN_WATER
	db BOOSTER_CARD_TYPE_FIGHTING  ; TYPE_PKMN_FIGHTING
	db BOOSTER_CARD_TYPE_PSYCHIC   ; TYPE_PKMN_PSYCHIC
	db BOOSTER_CARD_TYPE_COLORLESS ; TYPE_PKMN_COLORLESS
	db BOOSTER_CARD_TYPE_TRAINER   ; TYPE_PKMN_UNUSED
	db BOOSTER_CARD_TYPE_ENERGY    ; TYPE_ENERGY_FIRE
	db BOOSTER_CARD_TYPE_ENERGY    ; TYPE_ENERGY_GRASS
	db BOOSTER_CARD_TYPE_ENERGY    ; TYPE_ENERGY_LIGHTNING
	db BOOSTER_CARD_TYPE_ENERGY    ; TYPE_ENERGY_WATER
	db BOOSTER_CARD_TYPE_ENERGY    ; TYPE_ENERGY_FIGHTING
	db BOOSTER_CARD_TYPE_ENERGY    ; TYPE_ENERGY_PSYCHIC
	db BOOSTER_CARD_TYPE_ENERGY    ; TYPE_ENERGY_COLORLESS
	db BOOSTER_CARD_TYPE_TRAINER   ; TYPE_ENERGY_UNUSED
	db BOOSTER_CARD_TYPE_TRAINER   ; TYPE_TRAINER

FindTotalTypeChances: ; 1e2c2 (7:62c2)
	ld c, NUM_BOOSTER_CARD_TYPES
	xor a
	ld hl, wBoosterTempTypeChanceTable
.deleteTempTypeChanceTableLoop
	ld [hli], a
	dec c
	jr nz, .deleteTempTypeChanceTableLoop
	ld [wd4ca], a
	ld bc, $00
.checkIfTypeIsValid
	push bc
	ld hl, wBoosterAmountOfCardTypeTable
	add hl, bc
	ld a, [hl]
	or a
	jr z, .amountOfTypeOrChanceZero
	ld hl, wBoosterDataTypeChances
	add hl, bc
	ld a, [hl]
	or a
	jr z, .amountOfTypeOrChanceZero
	ld hl, wBoosterTempTypeChanceTable
	add hl, bc
	ld [hl], a
	ld a, [wd4ca]
	add [hl]
	ld [wd4ca], a
.amountOfTypeOrChanceZero
	pop bc
	inc c
	ld a, c
	cp NUM_BOOSTER_CARD_TYPES
	jr c, .checkIfTypeIsValid
	ld a, [wd4ca]
	ret

DetermineBoosterCardType: ; 1e2fa (7:62fa)
	ld [wd4ca], a
	ld c, $00
	ld hl, wBoosterTempTypeChanceTable
.loopThroughCardTypes
	ld a, [hl]
	or a
	jr z, .skipNoChanceType
	ld a, [wd4ca]
	sub [hl]
	ld [wd4ca], a
	jr c, .foundCardType
.skipNoChanceType
	inc hl
	inc c
	ld a, c
	cp a, NUM_BOOSTER_CARD_TYPES
	jr c, .loopThroughCardTypes
	ld a, BOOSTER_CARD_TYPE_ENERGY
.foundCardType
	ld a, c
	ld [wBoosterSelectedCardType], a
	ret

FindBoosterCard: ; 1e31d (7:631d)
	ld a, [wBoosterSelectedCardType]
	ld c, a
	ld b, $00
	ld hl, wBoosterAmountOfCardTypeTable
	add hl, bc
	ld a, [hl]
	call Random
	ld [wd4ca], a
	ld hl, wBoosterViableCardList
.findMatchingCardLoop
	ld a, [hli]
	or a
	jr z, .noValidCardFound
	ld [wBoosterTempCard], a
	ld a, [wBoosterSelectedCardType]
	cp [hl]
	jr nz, .cardIncorrectType
	ld a, [wd4ca]
	or a
	jr z, .returnWithCurrentCard
	dec a
	ld [wd4ca], a
.cardIncorrectType
	inc hl
	jr .findMatchingCardLoop
.returnWithCurrentCard
	or a
	ret
.noValidCardFound
	rst $38
	scf
	ret

; lowers the chance of getting the same type multiple times.
; more specifically, when a card of type T is drawn, T's new chances become
; min (1, wBoosterDataTypeChances[T] - wBoosterAveragedTypeChances).
UpdateBoosterCardTypesChanceByte: ; 1e350 (7:6350)
	push hl
	push bc
	ld a, [wBoosterSelectedCardType]
	ld c, a
	ld b, $00
	ld hl, wBoosterDataTypeChances
	add hl, bc
	ld a,[wBoosterAveragedTypeChances]
	ld c, a
	ld a, [hl]
	sub c
	ld [hl], a
	jr z, .chanceLessThanOne
	jr nc, .stillSomeChanceLeft
.chanceLessThanOne
	ld a, $01
	ld [hl], a
.stillSomeChanceLeft
	pop bc
	pop hl
	ret

; generates between 0 and 10 energy cards for the current booster.
; the amount of energies and their probabilities vary with each booster.
GenerateBoosterEnergies: ; 1e3db (7:63db)
	ld hl, wBoosterDataEnergyFunctionPointer + 1
	ld a, [hld]
	or a
	jr z, .noFunctionPointer
	ld l, [hl]
	ld h, a
	jp hl
.noFunctionPointer
	ld a, [hl]
	or a
	ret z ; return if no hardcoded energy either
	push af
	call AddBoosterEnergyToDrawnEnergies
	pop af
	ret

AddBoosterEnergyToDrawnEnergies: ; 1e380 (7:6380)
	ld [wBoosterTempCard], a
	call AddBoosterCardToDrawnEnergies
	ret

; generates a random energy card
GenerateEndingEnergy: ; 1e387 (7:6387)
	ld a, COLORLESS - FIRE
	call Random
	add a, $01
	jr AddBoosterEnergyToDrawnEnergies

; generates a booster with 10 random energies
GenerateRandomEnergyBooster:  ; 1e390 (7:6390)
	ld a, NUM_CARDS_IN_BOOSTER
.generateEnergyLoop
	push af
	call GenerateEndingEnergy
	pop af
	dec a
	jr nz, .generateEnergyLoop
	jr ZeroBoosterRarityData

GenerateEnergyBoosterLightningFire:  ; 1e39c (7:639c)
	ld hl, EnergyBoosterLightningFireData
	jr GenerateTwoTypesEnergyBooster

GenerateEnergyBoosterWaterFighting:  ; 1e3a1 (7:63a1)
	ld hl, EnergyBoosterWaterFightingData
	jr GenerateTwoTypesEnergyBooster

GenerateEnergyBoosterGrassPsychic:  ; 1e3a6 (7:63a6)
	ld hl, EnergyBoosterGrassPsychicData
	jr GenerateTwoTypesEnergyBooster

; generates a booster with 5 energies of 2 different types each
GenerateTwoTypesEnergyBooster:  ; 1e3ab (7:63ab)
	ld b, $02
.addTwoEnergiesToBoosterLoop
	ld c, NUM_CARDS_IN_BOOSTER / 2
.addEnergyToBoosterLoop
	push hl
	push bc
	ld a, [hl]
	call AddBoosterEnergyToDrawnEnergies
	pop bc
	pop hl
	dec c
	jr nz, .addEnergyToBoosterLoop
	inc hl
	dec b
	jr nz, .addTwoEnergiesToBoosterLoop
ZeroBoosterRarityData:
	xor a
	ld [wBoosterDataCommonAmount], a
	ld [wBoosterDataUncommonAmount], a
	ld [wBoosterDataRareAmount], a
	ret

EnergyBoosterLightningFireData:
	db LIGHTNING_ENERGY, FIRE_ENERGY
EnergyBoosterWaterFightingData:
	db WATER_ENERGY, FIGHTING_ENERGY
EnergyBoosterGrassPsychicData:
	db GRASS_ENERGY, PSYCHIC_ENERGY

AddBoosterCardToDrawnEnergies: ; 1e3cf (7:63cf)
	push hl
	ld hl, wBoosterTempEnergiesDrawn
	call CopyToFirstEmptyByte
	call AddBoosterCardToTempCardCollection
	pop hl
	ret

AddBoosterCardToDrawnNonEnergies: ; 1e3db (7:63db)
	push hl
	ld hl, wBoosterTempNonEnergiesDrawn
	call CopyToFirstEmptyByte
	call AddBoosterCardToTempCardCollection
	pop hl
	ret

CopyToFirstEmptyByte: ; 1e3e7 (7:63e7)
	ld a, [hli]
	or a
	jr nz, CopyToFirstEmptyByte
	dec hl
	ld a, [wBoosterTempCard]
	ld [hli], a
	xor a
	ld [hl], a
	ret

; trim empty slots in wBoosterCardsDrawn between regular cards and energies
PutEnergiesAndNonEnergiesTogether: ; 1e3f3 (7:63f3)
	push hl
	ld hl, wBoosterTempEnergiesDrawn
.loopThroughExtraCards
	ld a, [hli]
	or a
	jr z, .endOfCards
	ld [wBoosterTempCard], a
	push hl
	ld hl, wBoosterTempNonEnergiesDrawn
	call CopyToFirstEmptyByte
	pop hl
	jr .loopThroughExtraCards
.endOfCards
	pop hl
	ret

AddBoosterCardsToCollection:; 1e40a (7:640a)
	push hl
	ld hl, wBoosterCardsDrawn
.addCardsLoop
	ld a, [hli]
	or a
	jr z, .noCardsLeft
	call AddCardToCollection
	jr .addCardsLoop
.noCardsLeft
	pop hl
	ret

AddBoosterCardToTempCardCollection: ; 1e419 (7:6419)
	push hl
	ld h, wTempCardCollection >> 8
	ld a, [wBoosterTempCard]
	ld l, a
	inc [hl]
	pop hl
	ret

IsByteInTempCardCollectionZero: ; 1e423 (7:6423)
	push hl
	ld h, wTempCardCollection >> 8
	ld a, [wBoosterTempCard]
	ld l, a
	ld a, [hl]
	pop hl
	cp $01
	ccf
	ret

; clears wBoosterCardsDrawn and wTempCardCollection
; copies booster data to wBoosterData* *CurSet, *EnergyFunctionPointer, and *TypeChances
; copies rarity amounts to wBoosterData*Amount and averages them into wBoosterAveragedTypeChances
InitBoosterData: ; 1e430 (7:6430)
	ld c, wBoosterCardsDrawnEnd - wBoosterCardsDrawn
	ld hl, wBoosterCardsDrawn
	xor a
.clearPlayerDeckLoop
	ld [hli], a
	dec c
	jr nz, .clearPlayerDeckLoop
	ld c, $00 ; $100
	ld hl, wTempCardCollection
	xor a
.clearTempCardCollectionLoop
	ld [hli], a
	dec c
	jr nz, .clearTempCardCollectionLoop
	call FindBoosterDataPointer
	ld de, wBoosterDataSet
	ld bc, wBoosterDataTypeChances - wBoosterDataSet + NUM_BOOSTER_CARD_TYPES ; Pack2 - Pack1
	call CopyDataHLtoDE	; load booster pack data to wram
	call LoadRarityAmountsToWram
	ld bc, $0
	ld d, NUM_BOOSTER_CARD_TYPES
	ld e, $0
	ld hl, wBoosterDataTypeChances
.addChanceBytesLoop
	ld a, [hli]
	or a
	jr z, .skipChanceByte
	add c
	ld c, a
	inc e
.skipChanceByte
	dec d
	jr nz, .addChanceBytesLoop
	call DivideBCbyDE
	ld a, c
	ld [wBoosterAveragedTypeChances], a
	ret

FindBoosterDataPointer: ; 1e46f (7:646f)
	push bc
	ld a, [wBoosterIndex]
	add a
	ld c, a
	ld b, $0
	ld hl, BoosterDataJumptable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	ret

BoosterDataJumptable: ; 1e480 (7:6480)
	dw PackColosseumNeutral
	dw PackColosseumGrass
	dw PackColosseumFire
	dw PackColosseumWater
	dw PackColosseumLightning
	dw PackColosseumFighting
	dw PackColosseumTrainer
	dw PackEvolutionNeutral
	dw PackEvolutionGrass
	dw PackEvolutionNeutralFireEnergy
	dw PackEvolutionWater
	dw PackEvolutionFighting
	dw PackEvolutionPsychic
	dw PackEvolutionTrainer
	dw PackMysteryNeutral
	dw PackMysteryGrassColorless
	dw PackMysteryWaterColorless
	dw PackMysteryLightningColorless
	dw PackMysteryFightingColorless
	dw PackMysteryTrainerColorless
	dw PackLaboratoryMostlyNeutral
	dw PackLaboratoryGrass
	dw PackLaboratoryWater
	dw PackLaboratoryPsychic
	dw PackLaboratoryTrainer
	dw PackEnergyLightningFire
	dw PackEnergyWaterFighting
	dw PackEnergyGrassPsychic
	dw PackRandomEnergies

LoadRarityAmountsToWram: ; 1e4ba (7:64ba)
	ld a, [wBoosterDataSet]
	add a
	add a
	ld c, a
	ld b, $00
	ld hl, BoosterSetRarityAmountTable
	add hl, bc
	inc hl
	ld a, [hli]
	ld [wBoosterDataCommonAmount], a
	ld a, [hli]
	ld [wBoosterDataUncommonAmount], a
	ld a, [hli]
	ld [wBoosterDataRareAmount], a
	ret

INCLUDE "data/booster_packs.asm"

	INCROM $1e640, $20000