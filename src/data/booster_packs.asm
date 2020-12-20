BoosterSetRarityAmountsTable: ; 1e4d4 (7::64d4)
;	db energies, commons, uncommons, rares
; commons + uncommons + rares needs to be equal to 10 minus the number of energy cards
; defined in the pack's data below; otherwise, the number of cards in the pack won't be 10.
	db 1, 5, 3, 1 ; COLOSSEUM
	db 1, 5, 3, 1 ; EVOLUTION
	db 0, 6, 3, 1 ; MYSTERY
	db 0, 6, 3, 1 ; LABORATORY

booster_set: MACRO
	db \1 >> 4
ENDM

; For the energy or energy generation function, there are three options:
; - Pointer to a function that generates energies (some generate one, some generate a full pack)
; - A single energy of a specific type
; - $0000 if no card in the pack is an energy

; As for Card Type Chances, note that whenever one card of the 10 is drawn, the chances of
; the type of that card are reduced by the original average of all 8 types (capping the result at 1).
; This average always outputs 17 (except for the energy-only packs).

BoosterPack_ColosseumNeutral:: ; 1e4e4 (7:64e4)
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

BoosterPack_ColosseumGrass:: ; 1e4f0 (7:64f0)
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

BoosterPack_ColosseumFire:: ; 1e4fc (7:64fc)
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

BoosterPack_ColosseumWater:: ; 1e508 (7:6508)
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

BoosterPack_ColosseumLightning:: ; 1e514 (7:6514)
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

BoosterPack_ColosseumFighting:: ; 1e520 (7:6520)
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

BoosterPack_ColosseumTrainer:: ; 1e52c (7:652c)
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

BoosterPack_EvolutionNeutral:: ; 1e538 (7:6538)
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

BoosterPack_EvolutionGrass:: ; 1e544 (7:6544)
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

BoosterPack_EvolutionNeutralFireEnergy:: ; 1e550 (7:6550)
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

BoosterPack_EvolutionWater:: ; 1e55c (7:655c)
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

BoosterPack_EvolutionFighting:: ; 1e568 (7:6568)
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

BoosterPack_EvolutionPsychic:: ; 1e574 (7:6574)
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

BoosterPack_EvolutionTrainer:: ; 1e580 (7:6580)
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

BoosterPack_MysteryNeutral:: ; 1e58c (7:658c)
	booster_set MYSTERY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_MysteryGrassColorless:: ; 1e598 (7:6598)
	booster_set MYSTERY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_MysteryWaterColorless:: ; 1e5a4 (7:65a4)
	booster_set MYSTERY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_MysteryLightningColorless:: ; 1e5b0 (7:65b0)
	booster_set MYSTERY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_MysteryFightingColorless:: ; 1e5bc (7:65bc)
	booster_set MYSTERY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_MysteryTrainerColorless:: ; 1e5c8 (7:65c8)
	booster_set MYSTERY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_LaboratoryMostlyNeutral:: ; 1e5d4 (7:65d4)
	booster_set LABORATORY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_LaboratoryGrass:: ; 1e5e0 (7:65e0)
	booster_set LABORATORY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_LaboratoryWater:: ; 1e5ec (7:65ec)
	booster_set LABORATORY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_LaboratoryPsychic:: ; 1e5f8 (7:65f8)
	booster_set LABORATORY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_LaboratoryTrainer:: ; 1e604 (7:6604)
	booster_set LABORATORY ; booster pack set
	dw $0000 ; energy or energy generation function

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

BoosterPack_EnergyLightningFire:: ; 1e610 (7:6610)
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

BoosterPack_EnergyWaterFighting:: ; 1e61c (7:661c)
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

BoosterPack_EnergyGrassPsychic:: ; 1e628 (7:6628)
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

BoosterPack_RandomEnergies:: ; 1e634 (7:6634)
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
