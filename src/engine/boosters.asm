GenerateBoosterPack: ; 1e1c4 (7:61c4)
	push hl
	push bc
	push de
	ld [wBoosterDataIndex], a
.noCardsFoundLoop
	call InitBoosterData
	call GenerateBoosterEnergy
	call GenerateBoosterCard
	jr c, .noCardsFoundLoop
	call CopyBoosterEnergiesToBooster
	call AddBoosterCardsToCollection
	pop de
	pop bc
	pop hl
	ret

GenerateBoosterCard: ; 1e1df (7:61df)
	ld a, STAR
	ld [wBoosterCurrRarity], a
.generateCardLoop
	call FindCurrRarityChance
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
	call AddCardToBoosterList
	call FindCurrRarityChance
	dec [hl]
	jr .generateCardLoop
.noMoreOfCurrentRarity
	ld a, [wBoosterCurrRarity]
	dec a
	ld [wBoosterCurrRarity], a
	bit 7, a
	jr z, .generateCardLoop
	or a
	ret
.noValidCards
	rst $38
	scf
	ret

FindCurrRarityChance: ; 1e219 (7:6219)
	push bc
	ld hl, wBoosterDataCommonAmount
	ld a, [wBoosterCurrRarity]
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	ret

FindCardsInSetAndRarity: ; 1e226 (7:6226)
	ld c, BOOSTER_CARD_TYPE_AMOUNT
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
	ld [wBoosterTempData], a
	call CheckByteInWramZeroed
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
	ld a, [wBoosterTempData]
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
	ld a, [wBoosterCurrRarity]
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
	ld a, [wBoosterDataRarityIndex]
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

GetCardType: ; 1e2a0 (7:62a0)
	push hl
	push bc
	ld hl, CardTypeTable
	cp $11
	jr nc, .skipToTypeLoad
	ld c, a
	ld b, $00
	add hl, bc
.skipToTypeLoad
	ld a, [hl]
	pop bc
	pop hl
	ret

CardTypeTable:  ; 1e2b1 (7:62b1)
	db BOOSTER_CARD_TYPE_FIRE
	db BOOSTER_CARD_TYPE_GRASS
	db BOOSTER_CARD_TYPE_LIGHTNING
	db BOOSTER_CARD_TYPE_WATER
	db BOOSTER_CARD_TYPE_FIGHTING
	db BOOSTER_CARD_TYPE_PSYCHIC
	db BOOSTER_CARD_TYPE_COLORLESS
	db BOOSTER_CARD_TYPE_TRAINER
	db BOOSTER_CARD_TYPE_ENERGY
	db BOOSTER_CARD_TYPE_ENERGY
	db BOOSTER_CARD_TYPE_ENERGY
	db BOOSTER_CARD_TYPE_ENERGY
	db BOOSTER_CARD_TYPE_ENERGY
	db BOOSTER_CARD_TYPE_ENERGY
	db BOOSTER_CARD_TYPE_ENERGY
	db BOOSTER_CARD_TYPE_TRAINER
	db BOOSTER_CARD_TYPE_TRAINER

FindTotalTypeChances: ; 1e2c2 (7:62c2)
	ld c, BOOSTER_CARD_TYPE_AMOUNT
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
	ld hl, wBoosterDataTypeChanceData
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
	cp $09
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
	cp a, BOOSTER_CARD_TYPE_AMOUNT
	jr c, .loopThroughCardTypes
	ld a, $08
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
	ld [wBoosterTempData], a
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

;lowers the chance of getting the same type multiple times
UpdateBoosterCardTypesChanceByte: ; 1e350 (7:6350)
	push hl
	push bc
	ld a, [wBoosterSelectedCardType]
	ld c, a
	ld b, $00
	ld hl, wBoosterDataTypeChanceData
	add hl, bc
	ld a,[wBoosterDataAveragedChance]
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

GenerateBoosterEnergy: ; 1e3db (7:63db)
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
	ret z
	push af
	call AddBoosterEnergyToWram
	pop af
	ret

AddBoosterEnergyToWram: ; 1e380 (7:6380)
	ld [wBoosterTempData], a
	call AddCardToBoosterEnergies
	ret

GenerateEndingEnergy: ; 1e387 (7:6387)
	ld a, $06
	call Random
	add a, $01
	jr AddBoosterEnergyToWram

GenerateRandomEnergyBoosterPack:  ; 1e390 (7:6390)
	ld a, $0a
.generateEnergyLoop
	push af
	call GenerateEndingEnergy
	pop af
	dec a
	jr nz, .generateEnergyLoop
	jr ZeroBoosterRarityData

GenerateEnergyBoosterLightningFire:  ; 1e39c (7:639c)
	ld hl, EnergyBoosterLightningFireData
	jr CreateEnergyBooster

GenerateEnergyBoosterWaterFighting:  ; 1e3a1 (7:63a1)
	ld hl, EnergyBoosterWaterFightingData
	jr CreateEnergyBooster

GenerateEnergyBoosterGrassPsychic:  ; 1e3a6 (7:63a6)
	ld hl, EnergyBoosterGrassPsychicData
	jr CreateEnergyBooster

CreateEnergyBooster:  ; 1e3ab (7:63ab)
	ld b, $02
.addTwoEnergiesToBoosterLoop
	ld c, $05
.addEnergyToBoosterLoop
	push hl
	push bc
	ld a, [hl]
	call AddBoosterEnergyToWram
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

AddCardToBoosterEnergies: ; 1e3cf (7:63cf)
	push hl
	ld hl, wPlayerDeck + $b
	call CopyToFirstEmptyByte
	call AddBoosterCardToTempCardCollection
	pop hl
	ret

AddCardToBoosterList: ; 1e3db (7:63db)
	push hl
	ld hl, wPlayerDeck
	call CopyToFirstEmptyByte
	call AddBoosterCardToTempCardCollection
	pop hl
	ret

CopyToFirstEmptyByte: ; 1e3e7 (7:63e7)
	ld a, [hli]
	or a
	jr nz, CopyToFirstEmptyByte
	dec hl
	ld a, [wBoosterTempData]
	ld [hli], a
	xor a
	ld [hl], a
	ret

CopyBoosterEnergiesToBooster: ; 1e3f3 (7:63f3)
	push hl
	ld hl, wPlayerDeck + $b
.loopThroughExtraCards
	ld a, [hli]
	or a
	jr z, .endOfCards
	ld [wBoosterTempData], a
	push hl
	ld hl, wPlayerDeck
	call CopyToFirstEmptyByte
	pop hl
	jr .loopThroughExtraCards
.endOfCards
	pop hl
	ret

AddBoosterCardsToCollection:; 1e40a (7:640a)
	push hl
	ld hl, wPlayerDeck
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
	ld a, [wBoosterTempData]
	ld l, a
	inc [hl]
	pop hl
	ret

CheckByteInWramZeroed: ; 1e423 (7:6423)
	push hl
	ld h, wTempCardCollection >> 8
	ld a, [wBoosterTempData]
	ld l, a
	ld a, [hl]
	pop hl
	cp $01
	ccf
	ret

;clears wPlayerDeck and wTempCardCollection
;copies rarity amounts to ram and averages them into wBoosterDataAveragedChance
InitBoosterData: ; 1e430 (7:6430)
	ld c, $16
	ld hl, wPlayerDeck
	xor a
.clearPlayerDeckLoop
	ld [hli], a
	dec c
	jr nz, .clearPlayerDeckLoop
	ld c, $00
	ld hl, wTempCardCollection
	xor a
.clearTempCardCollectionLoop
	ld [hli], a
	dec c
	jr nz, .clearTempCardCollectionLoop
	call FindBoosterDataPointer
	ld de, wBoosterDataRarityIndex
	ld bc, $c
	call CopyData
	call LoadRarityAmountsToWram
	ld bc, $0
	ld d, BOOSTER_CARD_TYPE_AMOUNT
	ld e, $0
	ld hl, wBoosterDataTypeChanceData
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
	ld [wBoosterDataAveragedChance], a
	ret

FindBoosterDataPointer: ; 1e46f (7:646f)
	push bc
	ld a, [wBoosterDataIndex]
	add a
	ld c, a
	ld b, $0
	ld hl, BoosterData_PtrTbl
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	ret

BoosterData_PtrTbl: ; 1e480 (7:6480)
	dw BoosterData_1e4e4
	dw BoosterData_1e4f0
	dw BoosterData_1e4fc
	dw BoosterData_1e508
	dw BoosterData_1e514
	dw BoosterData_1e520
	dw BoosterData_1e52c
	dw BoosterData_1e538
	dw BoosterData_1e544
	dw BoosterData_1e550
	dw BoosterData_1e55c
	dw BoosterData_1e568
	dw BoosterData_1e574
	dw BoosterData_1e580
	dw BoosterData_1e58c
	dw BoosterData_1e598
	dw BoosterData_1e5a4
	dw BoosterData_1e5b0
	dw BoosterData_1e5bc
	dw BoosterData_1e5c8
	dw BoosterData_1e5d4
	dw BoosterData_1e5e0
	dw BoosterData_1e5ec
	dw BoosterData_1e5f8
	dw BoosterData_1e604
	dw BoosterData_1e610
	dw BoosterData_1e61c
	dw BoosterData_1e628
	dw BoosterData_1e634

LoadRarityAmountsToWram: ; 1e4ba (7:64ba)
	ld a, [wBoosterDataRarityIndex]
	add a
	add a
	ld c, a
	ld b, $00
	ld hl, BoosterRarityAmountTable
	add hl, bc
	inc hl
	ld a, [hli]
	ld [wBoosterDataCommonAmount], a
	ld a, [hli]
	ld [wBoosterDataUncommonAmount], a
	ld a, [hli]
	ld [wBoosterDataRareAmount], a
	ret

BoosterRarityAmountTable: ; 1e4d4 (7::64d4)
	db $01, $05, $03, $01 ; other, commons, uncommons, rares
	db $01, $05, $03, $01 ; other, commons, uncommons, rares
	db $00, $06, $03, $01 ; other, commons, uncommons, rares
	db $00, $06, $03, $01 ; other, commons, uncommons, rares

BoosterData_1e4e4:: ; 1e4e4 (7:64e4)
	db $00 ;booster rarity table index
	dw GenerateEndingEnergy ; energy or energy generation function

; Card Type Chances
	db $14 ; Grass Type Chance
	db $14 ; Fire Type Chance
	db $14 ; Water Type Chance
	db $14 ; Lightning Type Chance
	db $14 ; Fighting Type Chance
	db $14 ; Psychic Type Chance
	db $14 ; Colorless Type Chance
	db $14 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e4f0:: ; 1e4f0 (7:64f0)
	db $00 ;booster rarity table index
	dw $0001 ; energy or energy generation function

; Card Type Chances
	db $30 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e4fc:: ; 1e4fc (7:64fc)
	db $00 ;booster rarity table index
	dw $0002 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $30 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e508:: ; 1e508 (7:6508)
	db $00 ;booster rarity table index
	dw $0003 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $30 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e514:: ; 1e514 (7:6514)
	db $00 ;booster rarity table index
	dw $0004 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $30 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e520:: ; 1e520 (7:6520)
	db $00 ;booster rarity table index
	dw $0005 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $30 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e52c:: ; 1e52c (7:652c)
	db $00 ;booster rarity table index
	dw GenerateEndingEnergy ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $30 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e538:: ; 1e538 (7:6538)
	db $01 ;booster rarity table index
	dw GenerateEndingEnergy ; energy or energy generation function

; Card Type Chances
	db $14 ; Grass Type Chance
	db $14 ; Fire Type Chance
	db $14 ; Water Type Chance
	db $14 ; Lightning Type Chance
	db $14 ; Fighting Type Chance
	db $14 ; Psychic Type Chance
	db $14 ; Colorless Type Chance
	db $14 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e544:: ; 1e544 (7:6544)
	db $01 ;booster rarity table index
	dw $0001 ; energy or energy generation function

; Card Type Chances
	db $30 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e550:: ; 1e550 (7:6550)
	db $01 ;booster rarity table index
	dw $0002 ; energy or energy generation function

; Card Type Chances
	db $14 ; Grass Type Chance
	db $14 ; Fire Type Chance
	db $14 ; Water Type Chance
	db $14 ; Lightning Type Chance
	db $14 ; Fighting Type Chance
	db $14 ; Psychic Type Chance
	db $14 ; Colorless Type Chance
	db $14 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e55c:: ; 1e55c (7:655c)
	db $01 ;booster rarity table index
	dw $0003 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $30 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e568:: ; 1e568 (7:6568)
	db $01 ;booster rarity table index
	dw $0005 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $30 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e574:: ; 1e574 (7:6574)
	db $01 ;booster rarity table index
	dw $0006 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $30 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e580:: ; 1e580 (7:6580)
	db $01 ;booster rarity table index
	dw GenerateEndingEnergy ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $30 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e58c:: ; 1e58c (7:658c)
	db $02 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $11 ; Grass Type Chance
	db $11 ; Fire Type Chance
	db $11 ; Water Type Chance
	db $11 ; Lightning Type Chance
	db $11 ; Fighting Type Chance
	db $11 ; Psychic Type Chance
	db $11 ; Colorless Type Chance
	db $11 ; Trainer Card Chance
	db $11 ; Energy Card Chance

BoosterData_1e598:: ; 1e598 (7:6598)
	db $02 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $30 ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $0C ; Water Type Chance
	db $0C ; Lightning Type Chance
	db $0C ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $0C ; Trainer Card Chance
	db $0C ; Energy Card Chance

BoosterData_1e5a4:: ; 1e5a4 (7:65a4)
	db $02 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $0C ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $30 ; Water Type Chance
	db $0C ; Lightning Type Chance
	db $0C ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $0C ; Trainer Card Chance
	db $0C ; Energy Card Chance

BoosterData_1e5b0:: ; 1e5b0 (7:65b0)
	db $02 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $0C ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $0C ; Water Type Chance
	db $30 ; Lightning Type Chance
	db $0C ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $0C ; Trainer Card Chance
	db $0C ; Energy Card Chance

BoosterData_1e5bc:: ; 1e5bc (7:65bc)
	db $02 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $0C ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $0C ; Water Type Chance
	db $0C ; Lightning Type Chance
	db $30 ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $0C ; Trainer Card Chance
	db $0C ; Energy Card Chance

BoosterData_1e5c8:: ; 1e5c8 (7:65c8)
	db $02 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $0C ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $0C ; Water Type Chance
	db $0C ; Lightning Type Chance
	db $0C ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $30 ; Trainer Card Chance
	db $0C ; Energy Card Chance

BoosterData_1e5d4:: ; 1e5d4 (7:65d4)
	db $03 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $14 ; Grass Type Chance
	db $14 ; Fire Type Chance
	db $14 ; Water Type Chance
	db $14 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $14 ; Psychic Type Chance
	db $14 ; Colorless Type Chance
	db $18 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e5e0:: ; 1e5e0 (7:65e0)
	db $03 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $30 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e5ec:: ; 1e5ec (7:65ec)
	db $03 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $30 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e5f8:: ; 1e5f8 (7:65f8)
	db $03 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $30 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e604:: ; 1e604 (7:6604)
	db $03 ;booster rarity table index
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $30 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e610:: ; 1e610 (7:6610)
	db $00 ;booster rarity table index
	dw GenerateEnergyBoosterLightningFire ; energy or energy generation function

; Card Type Chances
	db $00 ; Grass Type Chance
	db $00 ; Fire Type Chance
	db $00 ; Water Type Chance
	db $00 ; Lightning Type Chance
	db $00 ; Fighting Type Chance
	db $00 ; Psychic Type Chance
	db $00 ; Colorless Type Chance
	db $00 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e61c:: ; 1e61c (7:661c)
	db $00 ;booster rarity table index
	dw GenerateEnergyBoosterWaterFighting ; energy or energy generation function

; Card Type Chances
	db $00 ; Grass Type Chance
	db $00 ; Fire Type Chance
	db $00 ; Water Type Chance
	db $00 ; Lightning Type Chance
	db $00 ; Fighting Type Chance
	db $00 ; Psychic Type Chance
	db $00 ; Colorless Type Chance
	db $00 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e628:: ; 1e628 (7:6628)
	db $00 ;booster rarity table index
	dw GenerateEnergyBoosterGrassPsychic ; energy or energy generation function

; Card Type Chances
	db $00 ; Grass Type Chance
	db $00 ; Fire Type Chance
	db $00 ; Water Type Chance
	db $00 ; Lightning Type Chance
	db $00 ; Fighting Type Chance
	db $00 ; Psychic Type Chance
	db $00 ; Colorless Type Chance
	db $00 ; Trainer Card Chance
	db $00 ; Energy Card Chance

BoosterData_1e634:: ; 1e634 (7:6634)
	db $00 ;booster rarity table index
	dw GenerateRandomEnergyBoosterPack ; energy or energy generation function

; Card Type Chances
	db $00 ; Grass Type Chance
	db $00 ; Fire Type Chance
	db $00 ; Water Type Chance
	db $00 ; Lightning Type Chance
	db $00 ; Fighting Type Chance
	db $00 ; Psychic Type Chance
	db $00 ; Colorless Type Chance
	db $00 ; Trainer Card Chance
	db $00 ; Energy Card Chance

INCBIN "baserom.gbc",$1e640,$20000 - $1e640
