BoosterSetRarityAmountsTable:
;	db energies, commons, uncommons, rares
; commons + uncommons + rares needs to be equal to 10 minus the number of energy cards
; defined in the pack's data below; otherwise, the number of cards in the pack won't be 10.
	db 1, 5, 3, 1 ; COLOSSEUM
	db 1, 5, 3, 1 ; EVOLUTION
	db 0, 6, 3, 1 ; MYSTERY
	db 0, 6, 3, 1 ; LABORATORY

MACRO booster_set
	db \1 >> 4
ENDM

; For the energy or energy generation function, there are three options:
; - Pointer to a function that generates energies (some generate one, some generate a full pack)
; - A single energy of a specific type
; - NULL if no card in the pack is an energy

; As for Card Type Chances, note that whenever one card of the 10 is drawn, the chances of
; the type of that card are reduced by the original average of all 8 types (capping the result at 1).
; This average always outputs 17 (except for the energy-only packs).

BoosterPack_ColosseumNeutral::
	booster_set COLOSSEUM ; booster pack set
	dw GenerateRandomEnergy ; energy or energy generation function

; Card Type Chances
	db 20 ; Grass Type Chance
	db 20 ; Fire Type Chance
	db 20 ; Water Type Chance
	db 20 ; Lightning Type Chance
	db 20 ; Fighting Type Chance
	db 20 ; Psychic Type Chance
	db 20 ; Colorless Type Chance
	db 20 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_ColosseumGrass::
	booster_set COLOSSEUM ; booster pack set
	dw GRASS_ENERGY ; energy or energy generation function

; Card Type Chances
	db 48 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_ColosseumFire::
	booster_set COLOSSEUM ; booster pack set
	dw FIRE_ENERGY ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 48 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_ColosseumWater::
	booster_set COLOSSEUM ; booster pack set
	dw WATER_ENERGY ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 48 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_ColosseumLightning::
	booster_set COLOSSEUM ; booster pack set
	dw LIGHTNING_ENERGY ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 48 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_ColosseumFighting::
	booster_set COLOSSEUM ; booster pack set
	dw FIGHTING_ENERGY ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 48 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_ColosseumTrainer::
	booster_set COLOSSEUM ; booster pack set
	dw GenerateRandomEnergy ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 48 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EvolutionNeutral::
	booster_set EVOLUTION ; booster pack set
	dw GenerateRandomEnergy ; energy or energy generation function

; Card Type Chances
	db 20 ; Grass Type Chance
	db 20 ; Fire Type Chance
	db 20 ; Water Type Chance
	db 20 ; Lightning Type Chance
	db 20 ; Fighting Type Chance
	db 20 ; Psychic Type Chance
	db 20 ; Colorless Type Chance
	db 20 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EvolutionGrass::
	booster_set EVOLUTION ; booster pack set
	dw GRASS_ENERGY ; energy or energy generation function

; Card Type Chances
	db 48 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EvolutionNeutralFireEnergy::
	booster_set EVOLUTION ; booster pack set
	dw FIRE_ENERGY ; energy or energy generation function

; Card Type Chances
	db 20 ; Grass Type Chance
	db 20 ; Fire Type Chance
	db 20 ; Water Type Chance
	db 20 ; Lightning Type Chance
	db 20 ; Fighting Type Chance
	db 20 ; Psychic Type Chance
	db 20 ; Colorless Type Chance
	db 20 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EvolutionWater::
	booster_set EVOLUTION ; booster pack set
	dw WATER_ENERGY ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 48 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EvolutionFighting::
	booster_set EVOLUTION ; booster pack set
	dw FIGHTING_ENERGY ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 48 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EvolutionPsychic::
	booster_set EVOLUTION ; booster pack set
	dw PSYCHIC_ENERGY ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 48 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EvolutionTrainer::
	booster_set EVOLUTION ; booster pack set
	dw GenerateRandomEnergy ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 48 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_MysteryNeutral::
	booster_set MYSTERY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 17 ; Grass Type Chance
	db 17 ; Fire Type Chance
	db 17 ; Water Type Chance
	db 17 ; Lightning Type Chance
	db 17 ; Fighting Type Chance
	db 17 ; Psychic Type Chance
	db 17 ; Colorless Type Chance
	db 17 ; Trainer Card Chance
	db 17 ; Energy Card Chance

BoosterPack_MysteryGrassColorless::
	booster_set MYSTERY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 48 ; Grass Type Chance
	db 12 ; Fire Type Chance
	db 12 ; Water Type Chance
	db 12 ; Lightning Type Chance
	db 12 ; Fighting Type Chance
	db 12 ; Psychic Type Chance
	db 22 ; Colorless Type Chance
	db 12 ; Trainer Card Chance
	db 12 ; Energy Card Chance

BoosterPack_MysteryWaterColorless::
	booster_set MYSTERY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 12 ; Grass Type Chance
	db 12 ; Fire Type Chance
	db 48 ; Water Type Chance
	db 12 ; Lightning Type Chance
	db 12 ; Fighting Type Chance
	db 12 ; Psychic Type Chance
	db 22 ; Colorless Type Chance
	db 12 ; Trainer Card Chance
	db 12 ; Energy Card Chance

BoosterPack_MysteryLightningColorless::
	booster_set MYSTERY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 12 ; Grass Type Chance
	db 12 ; Fire Type Chance
	db 12 ; Water Type Chance
	db 48 ; Lightning Type Chance
	db 12 ; Fighting Type Chance
	db 12 ; Psychic Type Chance
	db 22 ; Colorless Type Chance
	db 12 ; Trainer Card Chance
	db 12 ; Energy Card Chance

BoosterPack_MysteryFightingColorless::
	booster_set MYSTERY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 12 ; Grass Type Chance
	db 12 ; Fire Type Chance
	db 12 ; Water Type Chance
	db 12 ; Lightning Type Chance
	db 48 ; Fighting Type Chance
	db 12 ; Psychic Type Chance
	db 22 ; Colorless Type Chance
	db 12 ; Trainer Card Chance
	db 12 ; Energy Card Chance

BoosterPack_MysteryTrainerColorless::
	booster_set MYSTERY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 12 ; Grass Type Chance
	db 12 ; Fire Type Chance
	db 12 ; Water Type Chance
	db 12 ; Lightning Type Chance
	db 12 ; Fighting Type Chance
	db 12 ; Psychic Type Chance
	db 22 ; Colorless Type Chance
	db 48 ; Trainer Card Chance
	db 12 ; Energy Card Chance

BoosterPack_LaboratoryMostlyNeutral::
	booster_set LABORATORY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 20 ; Grass Type Chance
	db 20 ; Fire Type Chance
	db 20 ; Water Type Chance
	db 20 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 20 ; Psychic Type Chance
	db 20 ; Colorless Type Chance
	db 24 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_LaboratoryGrass::
	booster_set LABORATORY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 48 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_LaboratoryWater::
	booster_set LABORATORY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 48 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_LaboratoryPsychic::
	booster_set LABORATORY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 48 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 16 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_LaboratoryTrainer::
	booster_set LABORATORY ; booster pack set
	dw NULL ; energy or energy generation function

; Card Type Chances
	db 16 ; Grass Type Chance
	db 16 ; Fire Type Chance
	db 16 ; Water Type Chance
	db 16 ; Lightning Type Chance
	db 16 ; Fighting Type Chance
	db 16 ; Psychic Type Chance
	db 16 ; Colorless Type Chance
	db 48 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EnergyLightningFire::
	booster_set COLOSSEUM ; booster pack set
	dw GenerateEnergyBoosterLightningFire ; energy or energy generation function

; Card Type Chances
	db  0 ; Grass Type Chance
	db  0 ; Fire Type Chance
	db  0 ; Water Type Chance
	db  0 ; Lightning Type Chance
	db  0 ; Fighting Type Chance
	db  0 ; Psychic Type Chance
	db  0 ; Colorless Type Chance
	db  0 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EnergyWaterFighting::
	booster_set COLOSSEUM ; booster pack set
	dw GenerateEnergyBoosterWaterFighting ; energy or energy generation function

; Card Type Chances
	db  0 ; Grass Type Chance
	db  0 ; Fire Type Chance
	db  0 ; Water Type Chance
	db  0 ; Lightning Type Chance
	db  0 ; Fighting Type Chance
	db  0 ; Psychic Type Chance
	db  0 ; Colorless Type Chance
	db  0 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_EnergyGrassPsychic::
	booster_set COLOSSEUM ; booster pack set
	dw GenerateEnergyBoosterGrassPsychic ; energy or energy generation function

; Card Type Chances
	db  0 ; Grass Type Chance
	db  0 ; Fire Type Chance
	db  0 ; Water Type Chance
	db  0 ; Lightning Type Chance
	db  0 ; Fighting Type Chance
	db  0 ; Psychic Type Chance
	db  0 ; Colorless Type Chance
	db  0 ; Trainer Card Chance
	db  0 ; Energy Card Chance

BoosterPack_RandomEnergies::
	booster_set COLOSSEUM ; booster pack set
	dw GenerateRandomEnergyBooster ; energy or energy generation function

; Card Type Chances
	db  0 ; Grass Type Chance
	db  0 ; Fire Type Chance
	db  0 ; Water Type Chance
	db  0 ; Lightning Type Chance
	db  0 ; Fighting Type Chance
	db  0 ; Psychic Type Chance
	db  0 ; Colorless Type Chance
	db  0 ; Trainer Card Chance
	db  0 ; Energy Card Chance
