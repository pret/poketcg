; generate a booster pack identified by its BOOSTER_* constant in a,
; and add the drawn cards to the player's collection (sCardCollection).
GenerateBoosterPack: ; 1e1c4 (7:61c4)
	push hl
	push bc
	push de
	ld [wBoosterPackID], a
.no_cards_found_loop
	call InitBoosterData
	call GenerateBoosterEnergies
	call GenerateBoosterNonEnergies
	jr c, .no_cards_found_loop
	call PutEnergiesAndNonEnergiesTogether
	call AddBoosterCardsToCollection
	pop de
	pop bc
	pop hl
	ret

; generate all Pokemon or Trainer cards (if any) for the current booster pack
; return carry if ran out of cards to add to the booster pack
GenerateBoosterNonEnergies: ; 1e1df (7:61df)
	ld a, STAR
	ld [wBoosterCurrentRarity], a
.generate_card_loop
	call GetCurrentRarityAmount
	ld a, [hl]
	or a
	jr z, .no_more_of_current_rarity
	call FindCardsInSetAndRarity
	call CalculateTypeChances
	or a
	jr z, .no_valid_cards
	call Random
	call DetermineBoosterCardType
	call DetermineBoosterCard
	call UpdateBoosterCardTypesChanceByte
	call AddBoosterCardToDrawnNonEnergies
	call GetCurrentRarityAmount
	dec [hl] ; decrement amount left of current rarity
	jr .generate_card_loop
.no_more_of_current_rarity
	ld a, [wBoosterCurrentRarity]
	dec a
	ld [wBoosterCurrentRarity], a
	bit 7, a ; any rarity left to check?
	jr z, .generate_card_loop
	or a
	ret
.no_valid_cards
	debug_ret
	scf
	ret

; return hl pointing to wBoosterData_CommonAmount, wBoosterData_UncommonAmount,
; or wBoosterData_RareAmount, depending on the value at [wBoosterCurrentRarity]
GetCurrentRarityAmount: ; 1e219 (7:6219)
	push bc
	ld hl, wBoosterData_CommonAmount
	ld a, [wBoosterCurrentRarity]
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	ret

; loop through all existing cards to see which ones belong to the current set and rarity,
; and add them to wBoosterViableCardList. Also fill wBoosterAmountOfCardTypeTable with
; the amount of available cards of each type, for the current set and rarity.
; Skip any card already drawn in the current pack.
FindCardsInSetAndRarity: ; 1e226 (7:6226)
	ld c, NUM_BOOSTER_CARD_TYPES
	ld hl, wBoosterAmountOfCardTypeTable
	xor a
.delete_type_table_loop
	ld [hli], a
	dec c
	jr nz, .delete_type_table_loop
	xor a
	ld hl, wBoosterViableCardList
	ld [hl], a
	ld de, 1 ; GRASS_ENERGY
.check_card_viable_loop
	push de
	ld a, e
	ld [wBoosterCurrentCard], a
	call CheckCardAlreadyDrawn
	jr c, .finished_with_current_card
	call CheckCardInSetAndRarity
	jr c, .finished_with_current_card
	ld a, [wBoosterCurrentCardType]
	call GetBoosterCardType
	push af
	push hl
	ld c, a
	ld b, $00
	ld hl, wBoosterAmountOfCardTypeTable
	add hl, bc
	inc [hl]
	pop hl
	ld a, [wBoosterCurrentCard]
	ld [hli], a
	pop af
	ld [hli], a
	xor a
	ld [hl], a
.finished_with_current_card
	pop de
	inc e
	ld a, e
	cp NUM_CARDS + 1
	jr c, .check_card_viable_loop
	ret

; return nc if card e belongs to the current set and rarity
CheckCardInSetAndRarity: ; 1e268 (7:6268)
	push bc
	ld a, e
	call GetCardTypeRarityAndSet
	ld [wBoosterCurrentCardType], a
	ld a, b
	ld [wBoosterCurrentCardRarity], a
	ld a, c
	ld [wBoosterCurrentCardSet], a
	ld a, [wBoosterCurrentCardRarity]
	ld c, a
	ld a, [wBoosterCurrentRarity]
	cp c
	jr nz, .invalid_card
	ld a, [wBoosterCurrentCardType]
	call GetBoosterCardType
	cp BOOSTER_CARD_TYPE_ENERGY
	jr z, .return_valid_card
	ld a, [wBoosterCurrentCardSet]
	swap a
	and $0f
	ld c, a
	ld a, [wBoosterData_Set]
	cp c
	jr nz, .invalid_card
.return_valid_card
	or a
	jr .return
.invalid_card
	scf
.return
	pop bc
	ret

; Convert a card's TYPE_* constant given in a to its BOOSTER_CARD_TYPE_* constant
; return the result in a
GetBoosterCardType: ; 1e2a0 (7:62a0)
	push hl
	push bc
	ld hl, CardTypeTable
	cp NUM_CARD_TYPES
	jr nc, .load_type
	ld c, a
	ld b, $00
	add hl, bc
.load_type
	ld a, [hl]
	pop bc
	pop hl
	ret

CardTypeTable: ; 1e2b1 (7:62b1)
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

; calculate the chance of each type (BOOSTER_CARD_TYPE_*) for the next card
; return a = [wd4ca]: sum of all chances
CalculateTypeChances: ; 1e2c2 (7:62c2)
	ld c, NUM_BOOSTER_CARD_TYPES
	xor a
	ld hl, wBoosterTempTypeChancesTable
.delete_temp_type_chance_table_loop
	ld [hli], a
	dec c
	jr nz, .delete_temp_type_chance_table_loop
	ld [wd4ca], a
	ld bc, $00
.check_if_type_is_valid
	push bc
	ld hl, wBoosterAmountOfCardTypeTable
	add hl, bc
	ld a, [hl]
	or a
	jr z, .amount_of_type_or_chance_zero
	ld hl, wBoosterData_TypeChances
	add hl, bc
	ld a, [hl]
	or a
	jr z, .amount_of_type_or_chance_zero
	ld hl, wBoosterTempTypeChancesTable
	add hl, bc
	ld [hl], a
	ld a, [wd4ca]
	add [hl]
	ld [wd4ca], a
.amount_of_type_or_chance_zero
	pop bc
	inc c
	ld a, c
	cp NUM_BOOSTER_CARD_TYPES
	jr c, .check_if_type_is_valid
	ld a, [wd4ca]
	ret

; input: a = random number (between 0 and the sum of all chances)
; store the randomly generated booster card type in [wBoosterJustDrawnCardType]
DetermineBoosterCardType: ; 1e2fa (7:62fa)
	ld [wd4ca], a
	ld c, $00
	ld hl, wBoosterTempTypeChancesTable
.loop_through_card_types
	ld a, [hl]
	or a
	jr z, .skip_no_chance_type
	ld a, [wd4ca]
	sub [hl]
	ld [wd4ca], a
	jr c, .found_card_type
.skip_no_chance_type
	inc hl
	inc c
	ld a, c
	cp NUM_BOOSTER_CARD_TYPES
	jr c, .loop_through_card_types
	ld a, BOOSTER_CARD_TYPE_ENERGY
.found_card_type
	ld a, c
	ld [wBoosterJustDrawnCardType], a
	ret

; generate a random number between 0 and the amount of cards matching the current type.
; use that number to determine the card to draw from the booster pack.
; return the card in a.
DetermineBoosterCard: ; 1e31d (7:631d)
	ld a, [wBoosterJustDrawnCardType]
	ld c, a
	ld b, $00
	ld hl, wBoosterAmountOfCardTypeTable
	add hl, bc
	ld a, [hl]
	call Random
	ld [wd4ca], a
	ld hl, wBoosterViableCardList
.find_matching_card_loop
	ld a, [hli]
	or a
	jr z, .no_valid_card_found
	ld [wBoosterCurrentCard], a
	ld a, [wBoosterJustDrawnCardType]
	cp [hl]
	jr nz, .card_incorrect_type
	ld a, [wd4ca]
	or a
	jr z, .got_valid_card
	dec a
	ld [wd4ca], a
.card_incorrect_type
	inc hl
	jr .find_matching_card_loop
.got_valid_card
	or a
	ret
.no_valid_card_found
	debug_ret
	scf
	ret

; lowers the chance of getting the same type of card multiple times.
; more specifically, when a card of type T is drawn, T's new chances become
; max (1, [wBoosterData_TypeChances[T]] - [wBoosterAveragedTypeChances]).
UpdateBoosterCardTypesChanceByte: ; 1e350 (7:6350)
	push hl
	push bc
	ld a, [wBoosterJustDrawnCardType]
	ld c, a
	ld b, $00
	ld hl, wBoosterData_TypeChances
	add hl, bc
	ld a, [wBoosterAveragedTypeChances]
	ld c, a
	ld a, [hl]
	sub c
	ld [hl], a
	jr z, .chance_less_than_one
	jr nc, .still_some_chance_left
.chance_less_than_one
	ld a, 1
	ld [hl], a
.still_some_chance_left
	pop bc
	pop hl
	ret

; generates between 0 and 10 energy cards for the current booster.
; the amount of energies and their probabilities vary with each booster.
GenerateBoosterEnergies: ; 1e3db (7:63db)
	ld hl, wBoosterData_EnergyFunctionPointer + 1
	ld a, [hld]
	or a
	jr z, .no_function_pointer
	ld l, [hl]
	ld h, a
	jp hl
.no_function_pointer
	ld a, [hl]
	or a
	ret z ; return if no hardcoded energy either
	push af
	call AddBoosterEnergyToDrawnEnergies
	pop af
	ret

; add the (energy) card at a to wBoosterTempNonEnergiesDrawn and wTempCardCollection
AddBoosterEnergyToDrawnEnergies: ; 1e380 (7:6380)
	ld [wBoosterCurrentCard], a
	call AddBoosterCardToDrawnEnergies
	ret

; generates a random energy card
GenerateRandomEnergy: ; 1e387 (7:6387)
	ld a, NUM_COLORED_TYPES
	call Random
	add $01
	jr AddBoosterEnergyToDrawnEnergies

; generates a booster with 10 random energies
GenerateRandomEnergyBooster: ; 1e390 (7:6390)
	ld a, NUM_CARDS_IN_BOOSTER
.generate_energy_loop
	push af
	call GenerateRandomEnergy
	pop af
	dec a
	jr nz, .generate_energy_loop
	jr ZeroBoosterRarityData

; generates a booster with 5 Lightning energies and 5 Fire energies
GenerateEnergyBoosterLightningFire: ; 1e39c (7:639c)
	ld hl, EnergyBoosterLightningFireData
	jr GenerateTwoTypesEnergyBooster

; generates a booster with 5 Water energies and 5 Fighting energies
GenerateEnergyBoosterWaterFighting: ; 1e3a1 (7:63a1)
	ld hl, EnergyBoosterWaterFightingData
	jr GenerateTwoTypesEnergyBooster

; generates a booster with 5 Grass energies and 5 Psychic energies
GenerateEnergyBoosterGrassPsychic: ; 1e3a6 (7:63a6)
	ld hl, EnergyBoosterGrassPsychicData
	jr GenerateTwoTypesEnergyBooster

; generates a booster with 5 energies of 2 different types each
GenerateTwoTypesEnergyBooster: ; 1e3ab (7:63ab)
	ld b, $02
.add_two_energies_to_booster_loop
	ld c, NUM_CARDS_IN_BOOSTER / 2
.add_energy_to_booster_loop
	push hl
	push bc
	ld a, [hl]
	call AddBoosterEnergyToDrawnEnergies
	pop bc
	pop hl
	dec c
	jr nz, .add_energy_to_booster_loop
	inc hl
	dec b
	jr nz, .add_two_energies_to_booster_loop
;	fallthrough

ZeroBoosterRarityData: ; 1e3be (7:63be)
	xor a
	ld [wBoosterData_CommonAmount], a
	ld [wBoosterData_UncommonAmount], a
	ld [wBoosterData_RareAmount], a
	ret

EnergyBoosterLightningFireData:
	db LIGHTNING_ENERGY, FIRE_ENERGY

EnergyBoosterWaterFightingData:
	db WATER_ENERGY, FIGHTING_ENERGY

EnergyBoosterGrassPsychicData:
	db GRASS_ENERGY, PSYCHIC_ENERGY

; add the (energy) card at [wBoosterCurrentCard] to wBoosterTempNonEnergiesDrawn and wTempCardCollection
AddBoosterCardToDrawnEnergies: ; 1e3cf (7:63cf)
	push hl
	ld hl, wBoosterTempEnergiesDrawn
	call AppendCurrentCardToHL
	call AddBoosterCardToTempCardCollection
	pop hl
	ret

; add the (non-energy) card at [wBoosterCurrentCard] to wBoosterTempNonEnergiesDrawn and wTempCardCollection
AddBoosterCardToDrawnNonEnergies: ; 1e3db (7:63db)
	push hl
	ld hl, wBoosterTempNonEnergiesDrawn
	call AppendCurrentCardToHL
	call AddBoosterCardToTempCardCollection
	pop hl
	ret

; put the card at [wBoosterCurrentCard] at the end of the booster card list at hl
AppendCurrentCardToHL: ; 1e3e7 (7:63e7)
	ld a, [hli]
	or a
	jr nz, AppendCurrentCardToHL
	dec hl
	ld a, [wBoosterCurrentCard]
	ld [hli], a
	xor a
	ld [hl], a
	ret

; trim empty slots in wBoosterCardsDrawn between non-energy cards and energies
PutEnergiesAndNonEnergiesTogether: ; 1e3f3 (7:63f3)
	push hl
	ld hl, wBoosterTempEnergiesDrawn
.loop_through_extra_cards
	ld a, [hli]
	or a
	jr z, .end_of_cards
	ld [wBoosterCurrentCard], a
	push hl
	ld hl, wBoosterTempNonEnergiesDrawn
	call AppendCurrentCardToHL
	pop hl
	jr .loop_through_extra_cards
.end_of_cards
	pop hl
	ret

; add the final cards drawn from the booster pack to the player's collection (sCardCollection)
AddBoosterCardsToCollection: ; 1e40a (7:640a)
	push hl
	ld hl, wBoosterCardsDrawn
.add_cards_loop
	ld a, [hli]
	or a
	jr z, .no_cards_left
	call AddCardToCollection
	jr .add_cards_loop
.no_cards_left
	pop hl
	ret

; add the card at [wBoosterCurrentCard] to wTempCardCollection
AddBoosterCardToTempCardCollection: ; 1e419 (7:6419)
	push hl
	ld h, HIGH(wTempCardCollection)
	ld a, [wBoosterCurrentCard]
	ld l, a
	inc [hl]
	pop hl
	ret

; check if the card at [wBoosterCurrentCard] has already been added to wTempCardCollection
CheckCardAlreadyDrawn: ; 1e423 (7:6423)
	push hl
	ld h, HIGH(wTempCardCollection)
	ld a, [wBoosterCurrentCard]
	ld l, a
	ld a, [hl]
	pop hl
	cp $01
	ccf
	ret

; clears wBoosterCardsDrawn and wTempCardCollection.
; copies booster data to wBoosterDataCurSet, wBoosterData_EnergyFunctionPointer, and wBoosterData_TypeChances.
; copies rarity amounts to wBoosterData*Amount and averages them into wBoosterAveragedTypeChances.
InitBoosterData: ; 1e430 (7:6430)
	ld c, wBoosterCardsDrawnEnd - wBoosterCardsDrawn
	ld hl, wBoosterCardsDrawn
	xor a
.clear_player_deck_loop
	ld [hli], a
	dec c
	jr nz, .clear_player_deck_loop
	ld c, $00 ; $100
	ld hl, wTempCardCollection
	xor a
.clear_temp_card_collection_loop
	ld [hli], a
	dec c
	jr nz, .clear_temp_card_collection_loop
	call FindBoosterDataPointer
	ld de, wBoosterData_Set
	ld bc, wBoosterData_TypeChances - wBoosterData_Set + NUM_BOOSTER_CARD_TYPES ; Pack2 - Pack1
	call CopyDataHLtoDE ; load booster pack data to wram
	call LoadRarityAmountsToWram
	ld bc, $0
	ld d, NUM_BOOSTER_CARD_TYPES
	ld e, $0
	ld hl, wBoosterData_TypeChances
.add_chance_bytes_loop
	ld a, [hli]
	or a
	jr z, .skip_chance_byte
	add c
	ld c, a
	inc e
.skip_chance_byte
	dec d
	jr nz, .add_chance_bytes_loop
	call DivideBCbyDE
	ld a, c
	ld [wBoosterAveragedTypeChances], a
	ret

; get the pointer to the data of the booster pack at [wBoosterPackID]
FindBoosterDataPointer: ; 1e46f (7:646f)
	push bc
	ld a, [wBoosterPackID]
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
	dw BoosterPack_ColosseumNeutral
	dw BoosterPack_ColosseumGrass
	dw BoosterPack_ColosseumFire
	dw BoosterPack_ColosseumWater
	dw BoosterPack_ColosseumLightning
	dw BoosterPack_ColosseumFighting
	dw BoosterPack_ColosseumTrainer
	dw BoosterPack_EvolutionNeutral
	dw BoosterPack_EvolutionGrass
	dw BoosterPack_EvolutionNeutralFireEnergy
	dw BoosterPack_EvolutionWater
	dw BoosterPack_EvolutionFighting
	dw BoosterPack_EvolutionPsychic
	dw BoosterPack_EvolutionTrainer
	dw BoosterPack_MysteryNeutral
	dw BoosterPack_MysteryGrassColorless
	dw BoosterPack_MysteryWaterColorless
	dw BoosterPack_MysteryLightningColorless
	dw BoosterPack_MysteryFightingColorless
	dw BoosterPack_MysteryTrainerColorless
	dw BoosterPack_LaboratoryMostlyNeutral
	dw BoosterPack_LaboratoryGrass
	dw BoosterPack_LaboratoryWater
	dw BoosterPack_LaboratoryPsychic
	dw BoosterPack_LaboratoryTrainer
	dw BoosterPack_EnergyLightningFire
	dw BoosterPack_EnergyWaterFighting
	dw BoosterPack_EnergyGrassPsychic
	dw BoosterPack_RandomEnergies

; load rarity amounts of the booster pack set at [wBoosterData_Set] to wBoosterData*Amount
LoadRarityAmountsToWram: ; 1e4ba (7:64ba)
	ld a, [wBoosterData_Set]
	add a
	add a
	ld c, a
	ld b, $00
	ld hl, BoosterSetRarityAmountsTable
	add hl, bc
	inc hl
	ld a, [hli]
	ld [wBoosterData_CommonAmount], a
	ld a, [hli]
	ld [wBoosterData_UncommonAmount], a
	ld a, [hli]
	ld [wBoosterData_RareAmount], a
	ret

INCLUDE "data/booster_packs.asm"

	INCROM $1e640, $20000
