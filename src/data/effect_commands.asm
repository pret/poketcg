EffectCommands: ; 186f7 (6:46f7)
; Each move has a two-byte effect pointer (move's 7th param) that points to one of these structures.
; Similarly, trainer cards have a two-byte pointer (7th param) to one of these structures, which determines the card's function.
; Energy cards also point to one of these, but their data is just $00.
; 	db CommandId ($01 - $0a)
; 	dw Function
; 	...
; 	db $00

; Apparently every command has a "time", and a function is called multiple times during a turn
; with an argument identifying the command Id. If said command Id is found in the
; current move effect's array, its assigned function is immediately executed.

; Similar move effects of different Pokemon cards all point to a different command list, 
; even though in some cases their commands and function pointers match.
; xxx use <TrainerCardName>EffectCommands or <EnergyCardName>EffectCommands for these types of cards.

EkansSpitPoisonEffectCommands:
	dbw $03, $46F8
 	dbw $09, $46F0
	db  $00
	
EkansWrapEffectCommands:
	dbw $03, $4011
	db  $00
	
ArbokTerrorStrikeEffectCommands:
	dbw $04, $4726
 	dbw $05, $470A
 	dbw $0A, $470A
	db  $00
	
ArbokPoisonFangEffectCommands:
	dbw $03, $4007
 	dbw $09, $4730
	db  $00
	WeepinbellPoisonPowderEffectCommands:
	dbw $03, $4000
 	dbw $09, $4738
	db  $00
	VictreebelLureEffectCommands:
	dbw $01, $4740
 	dbw $04, $476A
 	dbw $05, $474B
 	dbw $08, $4764
	db  $00
	VictreebelAcidEffectCommands:
	dbw $03, $477E
	db  $00
	PinsirIronGripEffectCommands:
	dbw $03, $4011
	db  $00
	
CaterpieStringShotEffectCommands:
	dbw $03, $4011
	db  $00
GloomPoisonPowderEffectCommands:
	dbw $03, $4007
 	dbw $09, $478B
	db  $00
GloomFoulOdorEffectCommands:
	dbw $03, $4793
	db  $00
KakunaStiffenEffectCommands:
	dbw $03, $47A0
	db  $00
KakunaPoisonPowderEffectCommands:
	dbw $03, $4000
 	dbw $09, $47B4
	db  $00
GolbatLeechLifeEffectCommands:
	dbw $04, $47BC
	db  $00
VenonatStunSporeEffectCommands:
	dbw $03, $4011
	db  $00
VenonatLeechLifeEffectCommands:
	dbw $04, $47C6
	db  $00
ScytherSwordsDanceEffectCommands:
	dbw $03, $47D0
	db  $00
ZubatSupersonicEffectCommands:
	dbw $03, $47DC
	db  $00
ZubatLeechLifeEffectCommands:
	dbw $04, $47E3
	db  $00
BeedrillTwineedleEffectCommands:
	dbw $03, $47F5
 	dbw $09, $47ED
	db  $00
BeedrillPoisonStingEffectCommands:
	dbw $03, $4000
 	dbw $09, $480D
	db  $00
ExeggcuteHypnosisEffectCommands:
	dbw $03, $4030
	db  $00
ExeggcuteLeechSeedEffectCommands:
	dbw $04, $4815
	db  $00
KoffingFoulGasEffectCommands:
	dbw $03, $482A
 	dbw $09, $4822
	db  $00
MetapodStiffenEffectCommands:
	dbw $03, $4836
	db  $00
MetapodStunSporeEffectCommands:
	dbw $03, $4011
	db  $00
OddishStunSporeEffectCommands:
	dbw $03, $4011
	db  $00
OddishSproutEffectCommands:
	dbw $01, $484A
 	dbw $04, $48CC
 	dbw $05, $485A
 	dbw $08, $48B7
	db  $00
ExeggutorTeleportEffectCommands:
	dbw $01, $48EC
 	dbw $04, $491A
 	dbw $05, $48F7
 	dbw $08, $490F
	db  $00
ExeggutorBigEggsplosionEffectCommands:
	dbw $03, $4944
 	dbw $09, $4925
	db  $00
NidokingThrashEffectCommands:
	dbw $03, $4973
 	dbw $04, $4982
 	dbw $09, $496B
	db  $00
NidokingToxicEffectCommands:
	dbw $03, $4994
 	dbw $09, $498C
	db  $00
NidoqueenBoyfriendsEffectCommands:
	dbw $03, $4998
	db  $00
NidoranFFurySweepesEffectCommands:
	dbw $03, $49C6
 	dbw $09, $49BE
	db  $00
NidoranFCallforFamilyEffectCommands:
	dbw $01, $49DB
 	dbw $04, $4A6E
 	dbw $05, $49EB
 	dbw $08, $4A55
	db  $00
NidoranMHornHazardEffectCommands:
	dbw $03, $4A96
 	dbw $09, $4A8E
	db  $00
NidorinaSupersonicEffectCommands:
	dbw $03, $4AAC
	db  $00
NidorinaDoubleKickEffectCommands:
	dbw $03, $4ABB
 	dbw $09, $4AB3
	db  $00
NidorinoDoubleKickEffectCommands:
	dbw $03, $4ADB
 	dbw $09, $4AD3
	db  $00
ButterfreeWhirlwindEffectCommands:
	dbw $04, $4B09
 	dbw $05, $4AF3
 	dbw $0A, $4AF3
	db  $00
ButterfreeMegaDrainEffectCommands:
	dbw $04, $4B0F
	db  $00
ParasSporeEffectCommands:
	dbw $03, $4030
	db  $00
ParasectSporeEffectCommands:
	dbw $03, $4030
	db  $00
WeedlePoisonStingEffectCommands:
	dbw $03, $4000
 	dbw $09, $4B27
	db  $00
IvysaurPoisonPowderEffectCommands:
	dbw $03, $4007
 	dbw $09, $4B2F
	db  $00
BulbasaurLeechSeedEffectCommands:
	dbw $04, $4B37
	db  $00
VenusaurEnergyTransEffectCommands:
	dbw $02, $4B44
 	dbw $03, $4B77
 	dbw $04, $4BFB
 	dbw $05, $4B6F
	db  $00
GrimerNastyGooEffectCommands:
	dbw $03, $4011
	db  $00
GrimerMinimizeEffectCommands:
	dbw $03, $4C30
	db  $00
MukToxicGasEffectCommands:
	dbw $01, $4C36
	db  $00
MukSludgeEffectCommands:
	dbw $03, $4000
 	dbw $09, $4C38
	db  $00
BellsproutCallforFamilyEffectCommands:
	dbw $01, $4C40
 	dbw $04, $4CC2
 	dbw $05, $4C50
 	dbw $08, $4CAD
	db  $00
WeezingSmogEffectCommands:
	dbw $03, $4000
 	dbw $09, $4CE2
	db  $00
WeezingSelfdestructEffectCommands:
	dbw $04, $4CEA
	db  $00
VenomothShiftEffectCommands:
	dbw $02, $4D09
 	dbw $03, $4D5D
 	dbw $05, $4D21
	db  $00
VenomothVenomPowderEffectCommands:
	dbw $03, $4D8C
 	dbw $09, $4D84
	db  $00
TangelaBindEffectCommands:
	dbw $03, $4011
	db  $00
TangelaPoisonPowderEffectCommands:
	dbw $03, $4007
 	dbw $09, $4DA0
	db  $00
VileplumeHealEffectCommands:
	dbw $02, $4DA8
 	dbw $03, $4DC7
	db  $00
VileplumePetalDanceEffectCommands:
	dbw $03, $4E2B
 	dbw $09, $4E23
	db  $00
TangelaStunSporeEffectCommands:
	dbw $03, $4011
	db  $00
TangelaPoisonWhipEffectCommands:
	dbw $03, $4007
 	dbw $09, $4E4B
	db  $00
VenusaurSolarPowerEffectCommands:
	dbw $02, $4E53
 	dbw $03, $4E82
	db  $00
VenusaurMegaDrainEffectCommands:
	dbw $04, $4EB0
	db  $00
OmastarWaterGunEffectCommands:
	dbw $03, $4F05
 	dbw $09, $4F05
	db  $00
OmastarSpikeCannonEffectCommands:
	dbw $03, $4F12
 	dbw $09, $4F0A
	db  $00
OmanyteClairvoyanceEffectCommands:
	dbw $01, $4F2A
	db  $00
OmanyteWaterGunEffectCommands:
	dbw $03, $4F2C
 	dbw $09, $4F2C
	db  $00
WartortleWithdrawEffectCommands:
	dbw $03, $4F32
	db  $00
BlastoiseRainDanceEffectCommands:
	dbw $01, $4F46
	db  $00
BlastoiseHydroPumpEffectCommands:
	dbw $03, $4F48
 	dbw $09, $4F48
	db  $00
GyaradosBubblebeamEffectCommands:
	dbw $03, $4011
	db  $00
KinglerFlailEffectCommands:
	dbw $03, $4F54
 	dbw $09, $4F4E
	db  $00
KrabbyCallforFamilyEffectCommands:
	dbw $01, $4F5D
 	dbw $04, $4FDF
 	dbw $05, $4F6D
 	dbw $08, $4FCA
	db  $00
MagikarpFlailEffectCommands:
	dbw $03, $5005
 	dbw $09, $4FFF
	db  $00
PsyduckHeadacheEffectCommands:
	dbw $03, $500E
	db  $00
PsyduckFurySweepesEffectCommands:
	dbw $03, $501E
 	dbw $09, $5016
	db  $00
GolduckPsyshockEffectCommands:
	dbw $03, $4011
	db  $00
GolduckHyperBeamEffectCommands:
	dbw $04, $506B
 	dbw $05, $5033
 	dbw $08, $5065
	db  $00
SeadraWaterGunEffectCommands:
	dbw $03, $5085
 	dbw $09, $5085
	db  $00
SeadraAgilityEffectCommands:
	dbw $03, $508B
	db  $00
ShellderSupersonicEffectCommands:
	dbw $03, $509D
	db  $00
ShellderHideinShellEffectCommands:
	dbw $03, $50A4
	db  $00
VaporeonQuickAttackEffectCommands:
	dbw $03, $50C0
 	dbw $09, $50B8
	db  $00
VaporeonWaterGunEffectCommands:
	dbw $03, $50D3
 	dbw $09, $50D3
	db  $00
DewgongIceBeamEffectCommands:
	dbw $03, $4011
	db  $00
StarmieRecoverEffectCommands:
	dbw $01, $50D9
 	dbw $02, $50F0
 	dbw $04, $5114
 	dbw $06, $510E
 	dbw $08, $5103
	db  $00
StarmieStarFreezeEffectCommands:
	dbw $03, $4011
	db  $00
SquirtleBubbleEffectCommands:
	dbw $03, $4011
	db  $00
SquirtleWithdrawEffectCommands:
	dbw $03, $5120
	db  $00
HorseaSmokescreenEffectCommands:
	dbw $03, $5134
	db  $00
TentacruelSupersonicEffectCommands:
	dbw $03, $513A
	db  $00
TentacruelJellyfishStingEffectCommands:
	dbw $03, $4007
 	dbw $09, $5141
	db  $00
PoliwhirlAmnesiaEffectCommands:
	dbw $01, $5149
 	dbw $02, $516F
 	dbw $03, $5179
 	dbw $08, $5173
	db  $00
PoliwhirlDoubleslapEffectCommands:
	dbw $03, $51C8
 	dbw $09, $51C0
	db  $00
PoliwrathWaterGunEffectCommands:
	dbw $03, $51E0
 	dbw $09, $51E0
	db  $00
PoliwrathWhirlpoolEffectCommands:
	dbw $04, $5214
 	dbw $05, $51E6
 	dbw $08, $520E
	db  $00
PoliwagWaterGunEffectCommands:
	dbw $03, $5227
 	dbw $09, $5227
	db  $00
CloysterClampEffectCommands:
	dbw $03, $522D
	db  $00
CloysterSpikeCannonEffectCommands:
	dbw $03, $524E
 	dbw $09, $5246
	db  $00
ArticunoFreezeDryEffectCommands:
	dbw $03, $4011
	db  $00
ArticunoBlizzardEffectCommands:
	dbw $03, $5266
 	dbw $04, $526F
	db  $00
TentacoolCowardiceEffectCommands:
	dbw $02, $528B
 	dbw $03, $52C3
 	dbw $05, $52AE
	db  $00
LaprasWaterGunEffectCommands:
	dbw $03, $52EB
 	dbw $09, $52EB
	db  $00
LaprasConfuseRayEffectCommands:
	dbw $03, $401D
	db  $00
ArticunoQuickfreezeEffectCommands:
	dbw $01, $52F1
 	dbw $07, $52F3
	db  $00
ArticunoIceBreathEffectCommands:
	dbw $03, $5329
 	dbw $04, $532E
	db  $00
VaporeonFocusEnergyEffectCommands:
	dbw $03, $533F
	db  $00
ArcanineFlamethrowerEffectCommands:
	dbw $01, $5363
 	dbw $02, $5371
 	dbw $06, $5379
 	dbw $08, $5375
	db  $00
ArcanineTakeDownEffectCommands:
	dbw $04, $537F
	db  $00
ArcanineQuickAttackEffectCommands:
	dbw $03, $538D
 	dbw $09, $5385
	db  $00
ArcanineFlamesofRageEffectCommands:
	dbw $01, $53A0
 	dbw $02, $53AE
 	dbw $03, $53EF
 	dbw $06, $53DE
 	dbw $08, $53D5
 	dbw $09, $53E9
	db  $00
RapidashStompEffectCommands:
	dbw $03, $5400
 	dbw $09, $53F8
	db  $00
RapidashAgilityEffectCommands:
	dbw $03, $5413
	db  $00
NinetailsLureEffectCommands:
	dbw $01, $5425
 	dbw $04, $544F
 	dbw $05, $5430
 	dbw $08, $5449
	db  $00
NinetailsFireBlastEffectCommands:
	dbw $01, $5463
 	dbw $02, $5471
 	dbw $06, $5479
 	dbw $08, $5475
	db  $00
CharmanderEmberEffectCommands:
	dbw $01, $547F
 	dbw $02, $548D
 	dbw $06, $5495
 	dbw $08, $5491
	db  $00
MoltresWildfireEffectCommands:
	dbw $01, $549B
 	dbw $02, $54A9
 	dbw $04, $54F4
 	dbw $06, $54E1
 	dbw $08, $54DD
	db  $00
Moltres1DiveBombEffectCommands:
	dbw $03, $552B
 	dbw $09, $5523
	db  $00
FlareonQuickAttackEffectCommands:
	dbw $03, $5549
 	dbw $09, $5541
	db  $00
FlareonFlamethrowerEffectCommands:
	dbw $01, $555C
 	dbw $02, $556A
 	dbw $06, $5572
 	dbw $08, $556E
	db  $00
MagmarFlamethrowerEffectCommands:
	dbw $01, $5578
 	dbw $02, $5586
 	dbw $06, $558E
 	dbw $08, $558A
	db  $00
MagmarSmokescreenEffectCommands:
	dbw $03, $5594
	db  $00
MagmarSmogEffectCommands:
	dbw $03, $4000
 	dbw $09, $559A
	db  $00
CharmeleonFlamethrowerEffectCommands:
	dbw $01, $55A2
 	dbw $02, $55B0
 	dbw $06, $55B8
 	dbw $08, $55B4
	db  $00
CharizardEnergyBurnEffectCommands:
	dbw $01, $55BE
	db  $00
CharizardFireSpinEffectCommands:
	dbw $01, $55C0
 	dbw $02, $55CD
 	dbw $06, $5614
 	dbw $08, $5606
	db  $00
VulpixConfuseRayEffectCommands:
	dbw $03, $401D
	db  $00
FlareonRageEffectCommands:
	dbw $03, $563E
 	dbw $09, $5638
	db  $00
NinetailsMixUpEffectCommands:
	dbw $04, $5647
	db  $00
NinetailsDancingEmbersEffectCommands:
	dbw $03, $56AB
 	dbw $09, $56A3
	db  $00
MoltresFiregiverEffectCommands:
	dbw $01, $56C0
 	dbw $07, $56C2
	db  $00
Moltres2DiveBombEffectCommands:
	dbw $03, $5776
 	dbw $09, $576E
	db  $00
AbraPsyshockEffectCommands:
	dbw $03, $4011
	db  $00
GengarCurseEffectCommands:
	dbw $02, $57FC
 	dbw $03, $58BB
 	dbw $05, $5834
	db  $00
GengarDarkMindEffectCommands:
	dbw $04, $593C
 	dbw $05, $5903
 	dbw $08, $592A
	db  $00
GastlySleepingGasEffectCommands:
	dbw $03, $594F
	db  $00
GastlyDestinyBondEffectCommands:
	dbw $01, $5956
 	dbw $02, $5964
 	dbw $03, $5987
 	dbw $06, $5981
 	dbw $08, $5976
	db  $00
GastlyLickEffectCommands:
	dbw $03, $4011
	db  $00
GastlyEnergyConversionEffectCommands:
	dbw $01, $598D
 	dbw $04, $59B4
 	dbw $05, $5994
 	dbw $08, $599B
	db  $00
HaunterHypnosisEffectCommands:
	dbw $03, $4030
	db  $00
HaunterDreamEaterEffectCommands:
	dbw $01, $59D6
	db  $00
HaunterTransparencyEffectCommands:
	dbw $01, $59E5
	db  $00
HaunterNightmareEffectCommands:
	dbw $03, $4030
	db  $00
HypnoProphecyEffectCommands:
	dbw $01, $59E7
 	dbw $04, $5A41
 	dbw $05, $5A00
 	dbw $08, $5A3C
	db  $00
HypnoDarkMindEffectCommands:
	dbw $04, $5B64
 	dbw $05, $5B2B
 	dbw $08, $5B52
	db  $00
DrowzeeConfuseRayEffectCommands:
	dbw $03, $401D
	db  $00
MrMimeInvisibleWallEffectCommands:
	dbw $01, $5B77
	db  $00
MrMimeMeditateEffectCommands:
	dbw $03, $5B7F
 	dbw $09, $5B79
	db  $00
AlakazamDamageSwapEffectCommands:
	dbw $02, $5B8E
 	dbw $03, $5BA2
 	dbw $04, $5C27
	db  $00
AlakazamConfuseRayEffectCommands:
	dbw $03, $401D
	db  $00
MewPsywaveEffectCommands:
	dbw $03, $5C49
	db  $00
MewDevolutionBeamEffectCommands:
	dbw $01, $5C53
 	dbw $02, $5C64
 	dbw $03, $5CB6
 	dbw $04, $5CBB
 	dbw $08, $5C9E
	db  $00
MewNeutralizingShieldEffectCommands:
	dbw $01, $5D79
	db  $00
MewPsyshockEffectCommands:
	dbw $03, $4011
	db  $00
MewtwoPsychicEffectCommands:
	dbw $03, $5D81
 	dbw $09, $5D7B
	db  $00
MewtwoMrMimeKindAndBarrierEffectCommands:
	dbw $01, $5D8E
 	dbw $02, $5D9C
 	dbw $03, $5DBF
 	dbw $06, $5DB9
 	dbw $08, $5DAE
	db  $00
Mewtwo3EnergyAbsorptionEffectCommands:
	dbw $01, $5DC5
 	dbw $04, $5DEC
 	dbw $05, $5DCC
 	dbw $08, $5DD3
	db  $00
Mewtwo2EnergyAbsorptionEffectCommands:
	dbw $01, $5DFF
 	dbw $04, $5E26
 	dbw $05, $5E06
 	dbw $08, $5E0D
	db  $00
SlowbroStrangeBehaviorEffectCommands:
	dbw $02, $5E39
 	dbw $03, $5E5B
 	dbw $04, $5EB3
	db  $00
SlowbroPsyshockEffectCommands:
	dbw $03, $4011
	db  $00
SlowpokeSpacingOutEffectCommands:
	dbw $01, $5ED5
 	dbw $03, $5EE0
 	dbw $04, $5EF1
	db  $00
SlowpokeScavengeEffectCommands:
	dbw $01, $5F05
 	dbw $02, $5F1A
 	dbw $04, $5F5F
 	dbw $05, $5F46
 	dbw $06, $5F40
 	dbw $08, $5F2D
	db  $00
SlowpokeAmnesiaEffectCommands:
	dbw $01, $5F74
 	dbw $02, $5F7B
 	dbw $03, $5F85
 	dbw $08, $5F7F
	db  $00
KadabraRecoverEffectCommands:
	dbw $01, $5F89
 	dbw $02, $5FA0
 	dbw $04, $5FC3
 	dbw $06, $5FBD
 	dbw $08, $5FB2
	db  $00
JynxDoubleslapEffectCommands:
	dbw $03, $5FD7
 	dbw $09, $5FCF
	db  $00
JynxMeditateEffectCommands:
	dbw $03, $5FF2
 	dbw $09, $5FEC
	db  $00
MewMysteryAttackEffectCommands:
	dbw $03, $6009
 	dbw $04, $603E
 	dbw $09, $6001
	db  $00
GeodudeStoneBarrageEffectCommands:
	dbw $03, $6052
 	dbw $09, $604A
	db  $00
OnixHardenEffectCommands:
	dbw $03, $6075
	db  $00
PrimeapeFurySweepesEffectCommands:
	dbw $03, $6083
 	dbw $09, $607B
	db  $00
PrimeapeTantrumEffectCommands:
	dbw $03, $6099
	db  $00
MachampStrikesBackEffectCommands:
	dbw $01, $60AF
	db  $00
KabutoKabutoArmorEffectCommands:
	dbw $01, $60B1
	db  $00
KabutopsAbsorbEffectCommands:
	dbw $04, $60B3
	db  $00
CuboneSnivelEffectCommands:
	dbw $03, $60CB
	db  $00
CuboneRageEffectCommands:
	dbw $03, $60D7
 	dbw $09, $60D1
	db  $00
MarowakBonemerangEffectCommands:
	dbw $03, $60E8
 	dbw $09, $60E0
	db  $00
MarowakCallforFriendEffectCommands:
	dbw $01, $6100
 	dbw $04, $6194
 	dbw $05, $6110
 	dbw $08, $6177
	db  $00
MachokeKarateChopEffectCommands:
	dbw $03, $61BA
 	dbw $09, $61B4
	db  $00
MachokeSubmissionEffectCommands:
	dbw $04, $61D1
	db  $00
GolemSelfdestructEffectCommands:
	dbw $04, $61D7
	db  $00
GravelerHardenEffectCommands:
	dbw $03, $61F6
	db  $00
RhydonRamEffectCommands:
	dbw $04, $6212
 	dbw $05, $61FC
 	dbw $0A, $61FC
	db  $00
RhyhornLeerEffectCommands:
	dbw $03, $621D
	db  $00
HitmonleeStretchKickEffectCommands:
	dbw $01, $6231
 	dbw $04, $625B
 	dbw $05, $623C
 	dbw $08, $6255
	db  $00
SandshrewSandAttackEffectCommands:
	dbw $03, $626B
	db  $00
SandslashFurySweepesEffectCommands:
	dbw $03, $6279
 	dbw $09, $6271
	db  $00
DugtrioEarthquakeEffectCommands:
	dbw $04, $628F
	db  $00
AerodactylPrehistoricPowerEffectCommands:
	dbw $01, $629A
	db  $00
MankeyPeekEffectCommands:
	dbw $02, $629C
 	dbw $03, $62B4
	db  $00
MarowakBoneAttackEffectCommands:
	dbw $03, $630F
	db  $00
MarowakWailEffectCommands:
	dbw $01, $631C
 	dbw $04, $6335
	db  $00
ElectabuzzThundershockEffectCommands:
	dbw $03, $4011
	db  $00
ElectabuzzThunderpunchEffectCommands:
	dbw $03, $63A1
 	dbw $04, $63B0
 	dbw $09, $6399
	db  $00
ElectabuzzLightScreenEffectCommands:
	dbw $03, $63BA
	db  $00
ElectabuzzQuickAttackEffectCommands:
	dbw $03, $63C8
 	dbw $09, $63C0
	db  $00
MagnemiteThunderWaveEffectCommands:
	dbw $03, $4011
	db  $00
MagnemiteSelfdestructEffectCommands:
	dbw $04, $63db
	db  $00
ZapdosThunderEffectCommands:
	dbw $03, $63FA
 	dbw $04, $6409
	db  $00
ZapdosThunderboltEffectCommands:
	dbw $03, $6419
	db  $00
ZapdosThunderstormEffectCommands:
	dbw $04, $6429
	db  $00
JolteonQuickAttackEffectCommands:
	dbw $03, $64C3
 	dbw $09, $64BB
	db  $00
JolteonPinMissileEffectCommands:
	dbw $03, $64DE
 	dbw $09, $64D6
	db  $00
FlyingPikachuThundershockEffectCommands:
	dbw $03, $4011
	db  $00
FlyingPikachuFlyEffectCommands:
	dbw $03, $64FC
 	dbw $09, $64F4
	db  $00
PikachuThunderJoltEffectCommands:
	dbw $03, $651A
 	dbw $04, $6529
	db  $00
PikachuSparkEffectCommands:
	dbw $04, $6574
 	dbw $05, $6539
 	dbw $08, $6562
	db  $00
Pikachu3GrowlEffectCommands:
	dbw $03, $6589
	db  $00
Pikachu3ThundershockEffectCommands:
	dbw $03, $4011
	db  $00
Pikachu4GrowlEffectCommands:
	dbw $03, $658F
	db  $00
Pikachu4ThundershockEffectCommands:
	dbw $03, $4011
	db  $00
ElectrodeChainLightningEffectCommands:
	dbw $04, $6595
	db  $00
RaichuAgilityEffectCommands:
	dbw $03, $65DC
	db  $00
RaichuThunderEffectCommands:
	dbw $03, $65EE
 	dbw $04, $65FD
	db  $00
RaichuGigashockEffectCommands:
	dbw $04, $671F
 	dbw $05, $660D
 	dbw $08, $66C3
	db  $00
MagnetonThunderWaveEffectCommands:
	dbw $03, $4011
	db  $00
Magneton1SelfdestructEffectCommands:
	dbw $04, $6739
	db  $00
MagnetonSonicboomEffectCommands:
	dbw $03, $6758
 	dbw $04, $675E
 	dbw $09, $6758
	db  $00
Magneton2SelfdestructEffectCommands:
	dbw $04, $675F
	db  $00
ZapdosPealofThunderEffectCommands:
	dbw $01, $677E
 	dbw $07, $6780
	db  $00
ZapdosBigThunderEffectCommands:
	dbw $04, $67CB
	db  $00
MagnemiteMagneticStormEffectCommands:
	dbw $04, $67D5
	db  $00
ElectrodeSonicboomEffectCommands:
	dbw $03, $6870
 	dbw $04, $6876
 	dbw $09, $6870
	db  $00
ElectrodeEnergySpikeEffectCommands:
	dbw $01, $6877
 	dbw $04, $68F6
 	dbw $05, $687B
 	dbw $08, $68F1
	db  $00
JolteonDoubleKickEffectCommands:
	dbw $03, $6938
 	dbw $09, $6930
	db  $00
JolteonStunNeedleEffectCommands:
	dbw $03, $4011
	db  $00
EeveeTailWagEffectCommands:
	dbw $03, $694E
	db  $00
EeveeQuickAttackEffectCommands:
	dbw $03, $696A
 	dbw $09, $6962
	db  $00
SpearowMirrorMoveEffectCommands:
	dbw $01, $697F
 	dbw $02, $6981
 	dbw $03, $6987
 	dbw $04, $6989
 	dbw $05, $6983
 	dbw $08, $6985
 	dbw $09, $697D
	db  $00
FearowAgilityEffectCommands:
	dbw $03, $6AB8
	db  $00
DragoniteStepInEffectCommands:
	dbw $02, $6ACA
 	dbw $03, $6AE8
	db  $00
Dragonite2SlamEffectCommands:
	dbw $03, $6AFE
 	dbw $09, $6AF6
	db  $00
SnorlaxThickSkinnedEffectCommands:
	dbw $01, $6B15
	db  $00
SnorlaxBodySlamEffectCommands:
	dbw $03, $4011
	db  $00
FarfetchdLeekSlapEffectCommands:
	dbw $01, $6B1F
 	dbw $03, $6B34
 	dbw $06, $6B2C
 	dbw $09, $6B17
	db  $00
KangaskhanFetchEffectCommands:
	dbw $04, $6B40
	db  $00
KangaskhanCometPunchEffectCommands:
	dbw $03, $6B65
 	dbw $09, $6B5D
	db  $00
TaurosStompEffectCommands:
	dbw $03, $6B83
 	dbw $09, $6B7B
	db  $00
TaurosRampageEffectCommands:
	dbw $03, $6BA1
 	dbw $09, $6B96
	db  $00
DoduoFuryAttackEffectCommands:
	dbw $03, $6BC2
 	dbw $09, $6BBA
	db  $00
DodrioRetreatAidEffectCommands:
	dbw $01, $6BD7
	db  $00
DodrioRageEffectCommands:
	dbw $03, $6BDF
 	dbw $09, $6BD9
	db  $00
MeowthPayDayEffectCommands:
	dbw $04, $6BE8
	db  $00
DragonairSlamEffectCommands:
	dbw $03, $6C14
 	dbw $09, $6C0C
	db  $00
DragonairHyperBeamEffectCommands:
	dbw $04, $6C35
 	dbw $05, $6C2C
 	dbw $08, $6C2F
	db  $00
ClefableMetronomeEffectCommands:
	dbw $01, $6C77
 	dbw $02, $6C82
 	dbw $08, $6C7E
	db  $00
ClefableMinimizeEffectCommands:
	dbw $03, $6C88
	db  $00
PidgeotHurricaneEffectCommands:
	dbw $04, $6C8E
	db  $00
PidgeottoWhirlwindEffectCommands:
	dbw $04, $6CE9
 	dbw $05, $6CD3
 	dbw $0A, $6CD3
	db  $00
PidgeottoMirrorMoveEffectCommands:
	dbw $01, $6CF2
 	dbw $02, $6CF5
 	dbw $03, $6CFE
 	dbw $04, $6D01
 	dbw $05, $6CF8
 	dbw $08, $6CFB
 	dbw $09, $6CEF
	db  $00
ClefairySingEffectCommands:
	dbw $03, $6D04
	db  $00
ClefairyMetronomeEffectCommands:
	dbw $01, $6D0B
 	dbw $02, $6D16
 	dbw $08, $6D12
	db  $00
WigglytuffLullabyEffectCommands:
	dbw $03, $4030
	db  $00
WigglytuffDotheWaveEffectCommands:
	dbw $03, $6D87
 	dbw $09, $6D87
	db  $00
JigglypuffLullabyEffectCommands:
	dbw $03, $4030
	db  $00
JigglypuffFirstAidEffectCommands:
	dbw $01, $6D94
 	dbw $04, $6D9F
	db  $00
JigglypuffDoubleEdgeEffectCommands:
	dbw $04, $6DA6
	db  $00
PersianPounceEffectCommands:
	dbw $03, $6DAC
	db  $00
LickitungTongueWrapEffectCommands:
	dbw $03, $4011
	db  $00
LickitungSupersonicEffectCommands:
	dbw $03, $6DB2
	db  $00
PidgeyWhirlwindEffectCommands:
	dbw $04, $6DCF
 	dbw $05, $6DB9
 	dbw $0A, $6DB9
	db  $00
PorygonConversion1EffectCommands:
	dbw $01, $6DD5
 	dbw $02, $6DED
 	dbw $04, $6DFB
 	dbw $08, $6DF7
	db  $00
PorygonConversion2EffectCommands:
	dbw $01, $6E1F
 	dbw $02, $6E31
 	dbw $04, $6E5E
 	dbw $08, $6E3C
	db  $00
ChanseyScrunchEffectCommands:
	dbw $03, $6EE7
	db  $00
ChanseyDoubleEdgeEffectCommands:
	dbw $04, $6EFB
	db  $00
RaticateSuperFangEffectCommands:
	dbw $03, $6F07
 	dbw $09, $6F01
	db  $00
; Unreferenced?
	dbw $02, $6F18
 	dbw $03, $6F3C
 	dbw $05, $6F27
	db  $00
DragoniteHealingWindEffectCommands:
	dbw $01, $6F51
 	dbw $07, $6F53
	db  $00
Dragonite1SlamEffectCommands:
	dbw $03, $6FA4
 	dbw $09, $6F9C
	db  $00
MeowthCatPunchEffectCommands:
	dbw $04, $6FE0
	db  $00
DittoMorphEffectCommands:
	dbw $04, $6FF6
	db  $00
PidgeotSlicingWindEffectCommands:
	dbw $04, $70BF
	db  $00
PidgeotGaleEffectCommands:
	dbw $03, $70D0
 	dbw $04, $70D6
	db  $00
JigglypuffFriendshipSongEffectCommands:
	dbw $01, $710D
 	dbw $04, $7119
	db  $00
JigglypuffExpandEffectCommands:
	dbw $04, $7153
	db  $00
DoubleColorlessEnergyEffectCommands:
	db  $00
PsychicEnergyEffectCommands:
	db  $00
FightingEnergyEffectCommands:
	db  $00
LightningEnergyEffectCommands:
	db  $00
WaterEnergyEffectCommands:
	db  $00
FireEnergyEffectCommands:
	db  $00
GrassEnergyEffectCommands:
	db  $00
SuperPotionEffectCommands:
	dbw $01, $7159
 	dbw $02, $7167
 	dbw $03, $71B5
	db  $00
ImakuniEffectCommands:
	dbw $03, $7216
	db  $00
EnergyRemovalEffectCommands:
	dbw $01, $7252
 	dbw $02, $725F
 	dbw $03, $7273
 	dbw $08, $726F
	db  $00
EnergyRetrievalEffectCommands:
	dbw $01, $728E
 	dbw $02, $72A0
 	dbw $03, $72F8
 	dbw $05, $72B9
	db  $00
EnergySearchEffectCommands:
	dbw $01, $731C
 	dbw $03, $7372
 	dbw $05, $7328
	db  $00
ProfessorOakEffectCommands:
	dbw $03, $73A1
	db  $00
PotionEffectCommands:
	dbw $01, $73CA
 	dbw $02, $73D1
 	dbw $03, $73EF
	db  $00
GamblerEffectCommands:
	dbw $03, $73F9
	db  $00
ItemFinderEffectCommands:
	dbw $01, $743B
 	dbw $02, $744A
 	dbw $03, $7463
	db  $00
DefenderEffectCommands:
	dbw $02, $7488
 	dbw $03, $7499
	db  $00
MysteriousFossilEffectCommands:
	dbw $01, $74B3
 	dbw $03, $74BF
	db  $00
FullHealEffectCommands:
	dbw $01, $74C5
 	dbw $03, $74D1
	db  $00
ImposterProfessorOakEffectCommands:
	dbw $03, $74E1
	db  $00
ComputerSearchEffectCommands:
	dbw $01, $7513
 	dbw $02, $752A
 	dbw $03, $7545
 	dbw $05, $752E
	db  $00
ClefairyDollEffectCommands:
	dbw $01, $7561
 	dbw $03, $756D
	db  $00
MrFujiEffectCommands:
	dbw $01, $7573
 	dbw $02, $757E
 	dbw $03, $758F
	db  $00
PlusPowerEffectCommands:
	dbw $03, $75E0
	db  $00
SwitchEffectCommands:
	dbw $01, $75EE
 	dbw $02, $75F9
 	dbw $03, $760A
	db  $00
PokemonCenterEffectCommands:
	dbw $01, $7611
 	dbw $03, $7618
	db  $00
PokemonFluteEffectCommands:
	dbw $01, $7659
 	dbw $02, $7672
 	dbw $03, $768F
	db  $00
PokemonBreederEffectCommands:
	dbw $01, $76B3
 	dbw $02, $76C1
 	dbw $03, $76F4
	db  $00
ScoopUpEffectCommands:
	dbw $01, $7795
 	dbw $02, $77A0
 	dbw $03, $77C3
	db  $00
PokemonTraderEffectCommands:
	dbw $01, $7826
 	dbw $02, $7838
 	dbw $03, $788D
 	dbw $05, $7853
	db  $00
PokedexEffectCommands:
	dbw $01, $78E1
 	dbw $03, $79AA
 	dbw $05, $78ED
	db  $00
BillEffectCommands:
	dbw $03, $79C4
	db  $00
LassEffectCommands:
	dbw $03, $79E3
	db  $00
MaintenanceEffectCommands:
	dbw $01, $7A70
 	dbw $02, $7A7B
 	dbw $03, $7A85
	db  $00
PokeBallEffectCommands:
	dbw $01, $7AAD
 	dbw $03, $7B15
 	dbw $05, $7AB9
	db  $00
RecycleEffectCommands:
	dbw $01, $7B36
 	dbw $03, $7B68
 	dbw $05, $7B41
	db  $00
ReviveEffectCommands:
	dbw $01, $7B80
 	dbw $02, $7B93
 	dbw $03, $7BB0
	db  $00
DevolutionSprayEffectCommands:
	dbw $01, $7C0B
 	dbw $02, $7C24
 	dbw $03, $7C99
	db  $00
SuperEnergyRemovalEffectCommands:
	dbw $01, $7CD0
 	dbw $02, $7CE4
 	dbw $03, $7D73
	db  $00
SuperEnergyRetrievalEffectCommands:
	dbw $01, $7DA4
 	dbw $02, $7DB6
 	dbw $03, $7DFA
 	dbw $05, $7DBA
	db  $00
GustofWindEffectCommands:
	dbw $01, $7E6E
 	dbw $02, $7E79
 	dbw $03, $7E90
	db  $00
	