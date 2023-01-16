ScenePointers:
	table_width 2, ScenePointers
	dw Scene_TitleScreen
	dw Scene_ColosseumBooster
	dw Scene_EvolutionBooster
	dw Scene_MysteryBooster
	dw Scene_LaboratoryBooster
	dw Scene_CharizardIntro
	dw Scene_ScytherIntro
	dw Scene_AerodactylIntro
	dw Scene_GradientBlackAndRed
	dw Scene_GradientWhiteAndRed
	dw Scene_GradientBlackAndGreen
	dw Scene_GradientWhiteAndGreen
	dw Scene_ColorWheel
	dw Scene_ColorTest
	dw Scene_GameBoyLinkConnecting
	dw Scene_GameBoyLinkTransmitting
	dw Scene_GameBoyLinkNotConnected
	dw Scene_GameBoyPrinterTransmitting
	dw Scene_GameBoyPrinterNotConnected
	dw Scene_CardPop
	dw Scene_CardPopError
	dw Scene_JapaneseTitleScreen
	dw Scene_Nintendo
	dw Scene_Companies
	dw Scene_JapaneseTitleScreen2
	dw Scene_Copyright
	dw Scene_JapaneseTitleScreen2
	dw Scene_ColorPalette
	assert_table_length NUM_SCENES

; format:
; dw compressed sgb packet
; dw custom sgb packet loading routine
; db palette (non-cgb), palette (cgb), palette offset
; db tilemap (non-cgb), tilemap (cgb), vram tile offset, vram0 or vram1
; db sprite
;
; if sprite is non-zero:
; db palette (non-cgb), palette (cgb), palette offset
; db animation (non-cgb), animation (cgb), x offset, y offset
; dw 0-terminator

Scene_TitleScreen:
	dw SGBData_TitleScreen
	dw NULL
	db PALETTE_25, PALETTE_25, $00
	db TILEMAP_TITLE_SCREEN, TILEMAP_TITLE_SCREEN_CGB, $00, $00
	db $00

Scene_JapaneseTitleScreen:
	dw SGBData_TitleScreen
	dw NULL
	db PALETTE_25, PALETTE_25, $00
	db TILEMAP_JAPANESE_TITLE_SCREEN, TILEMAP_JAPANESE_TITLE_SCREEN_CGB, $80, $00
	db $00

Scene_ColosseumBooster:
	dw SGBData_ColosseumBooster
	dw NULL
	db PALETTE_108, PALETTE_101, $01
	db TILEMAP_COLOSSEUM, TILEMAP_COLOSSEUM_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_EvolutionBooster:
	dw SGBData_EvolutionBooster
	dw NULL
	db PALETTE_108, PALETTE_102, $01
	db TILEMAP_EVOLUTION, TILEMAP_EVOLUTION_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_MysteryBooster:
	dw SGBData_MysteryBooster
	dw NULL
	db PALETTE_108, PALETTE_103, $01
	db TILEMAP_MYSTERY, TILEMAP_MYSTERY_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_LaboratoryBooster:
	dw SGBData_LaboratoryBooster
	dw NULL
	db PALETTE_108, PALETTE_104, $01
	db TILEMAP_LABORATORY, TILEMAP_LABORATORY_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_CharizardIntro:
	dw SGBData_CharizardIntro
	dw NULL
	db PALETTE_108, PALETTE_105, $01
	db TILEMAP_CHARIZARD_INTRO, TILEMAP_CHARIZARD_INTRO_CGB, $80, $00
	db $00

Scene_ScytherIntro:
	dw SGBData_ScytherIntro
	dw NULL
	db PALETTE_108, PALETTE_106, $01
	db TILEMAP_SCYTHER_INTRO, TILEMAP_SCYTHER_INTRO_CGB, $80, $00
	db $00

Scene_AerodactylIntro:
	dw SGBData_AerodactylIntro
	dw NULL
	db PALETTE_108, PALETTE_107, $01
	db TILEMAP_AERODACTYL_INTRO, TILEMAP_AERODACTYL_INTRO_CGB, $80, $00
	db $00

Scene_GradientBlackAndRed:
	dw NULL
	dw NULL
	db PALETTE_94, PALETTE_94, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientWhiteAndRed:
	dw NULL
	dw NULL
	db PALETTE_95, PALETTE_95, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientBlackAndGreen:
	dw NULL
	dw NULL
	db PALETTE_96, PALETTE_96, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientWhiteAndGreen:
	dw NULL
	dw NULL
	db PALETTE_97, PALETTE_97, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_ColorWheel:
	dw NULL
	dw NULL
	db PALETTE_98, PALETTE_98, $00
	db TILEMAP_SOLID_TILES_2, TILEMAP_SOLID_TILES_2, $01, $00
	db $00

Scene_ColorTest:
	dw NULL
	dw NULL
	db PALETTE_99, PALETTE_99, $00
	db TILEMAP_SOLID_TILES_3, TILEMAP_SOLID_TILES_3, $01, $00
	db $00

Scene_ColorPalette:
	dw NULL
	dw NULL
	db PALETTE_110, PALETTE_110, $00
	db TILEMAP_SOLID_TILES_4, TILEMAP_SOLID_TILES_4, $fc, $01
	db $00

Scene_GameBoyLinkConnecting:
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK_CONNECTING, TILEMAP_GAMEBOY_LINK_CONNECTING_CGB, $90, $00
	db $00

Scene_GameBoyLinkTransmitting:
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK, TILEMAP_GAMEBOY_LINK_CGB, $90, $00
	db SPRITE_LINK
	db PALETTE_114, PALETTE_114, $00
	db SPRITE_ANIM_179, SPRITE_ANIM_176, $50, $50
	dw $00

Scene_GameBoyLinkNotConnected:
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK, TILEMAP_GAMEBOY_LINK_CGB, $90, $00
	db SPRITE_LINK
	db PALETTE_114, PALETTE_114, $00
	db SPRITE_ANIM_180, SPRITE_ANIM_177, $50, $50
	dw $00

Scene_GameBoyPrinterTransmitting:
	dw SGBData_GameBoyPrinter
	dw LoadScene_SetGameBoyPrinterAttrBlk
	db PALETTE_112, PALETTE_112, $00
	db TILEMAP_GAMEBOY_PRINTER, TILEMAP_GAMEBOY_PRINTER_CGB, $90, $00
	db SPRITE_PRINTER
	db PALETTE_115, PALETTE_115, $00
	db SPRITE_ANIM_183, SPRITE_ANIM_181, $50, $30
	dw $00

Scene_GameBoyPrinterNotConnected:
	dw SGBData_GameBoyPrinter
	dw LoadScene_SetGameBoyPrinterAttrBlk
	db PALETTE_112, PALETTE_112, $00
	db TILEMAP_GAMEBOY_PRINTER, TILEMAP_GAMEBOY_PRINTER_CGB, $90, $00
	db SPRITE_PRINTER
	db PALETTE_115, PALETTE_115, $00
	db SPRITE_ANIM_184, SPRITE_ANIM_182, $50, $30
	dw $00

Scene_CardPop:
	dw SGBData_CardPop
	dw LoadScene_SetCardPopAttrBlk
	db PALETTE_113, PALETTE_113, $00
	db TILEMAP_CARD_POP, TILEMAP_CARD_POP_CGB, $80, $00
	db SPRITE_CARD_POP
	db PALETTE_116, PALETTE_116, $00
	db SPRITE_ANIM_187, SPRITE_ANIM_185, $50, $40
	dw $00

Scene_CardPopError:
	dw SGBData_CardPop
	dw LoadScene_SetCardPopAttrBlk
	db PALETTE_113, PALETTE_113, $00
	db TILEMAP_CARD_POP, TILEMAP_CARD_POP_CGB, $80, $00
	db SPRITE_CARD_POP
	db PALETTE_116, PALETTE_116, $00
	db SPRITE_ANIM_188, SPRITE_ANIM_186, $50, $40
	dw $00

Scene_Nintendo:
	dw NULL
	dw NULL
	db PALETTE_27, PALETTE_27, $00
	db TILEMAP_NINTENDO, TILEMAP_NINTENDO, $00, $00
	db $00

Scene_Companies:
	dw NULL
	dw NULL
	db PALETTE_28, PALETTE_28, $00
	db TILEMAP_COMPANIES, TILEMAP_COMPANIES, $00, $00
	db $00

Scene_Copyright:
	dw NULL
	dw NULL
	db PALETTE_26, PALETTE_26, $00
	db TILEMAP_COPYRIGHT, TILEMAP_COPYRIGHT_CGB, $00, $00
	db $00

Scene_JapaneseTitleScreen2:
	dw NULL
	dw NULL
	db PALETTE_109, PALETTE_100, $00
	db TILEMAP_JAPANESE_TITLE_SCREEN_2, TILEMAP_JAPANESE_TITLE_SCREEN_2_CGB, $01, $00
	db $00
