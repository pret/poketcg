MultichoiceTextbox_ConfigTable_ChooseDeckToDuelAgainst:
	db $04, $00     ; x, y to start drawing box
	db $10, $08     ; width, height of box
	db $06, $02     ; x, y coordinate to start printing next text
	tx LightningAndFireDeckChoiceText     ; text id to print next
	db $06, $04     ; x, y coordinate to start printing next text
	tx WaterAndFightingDeckChoiceText     ; text id to print next
	db $06, $06     ; x, y coordinate to start printing next text
	tx GrassAndPsychicDeckChoiceText      ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $05, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $03          ; cursor max index
	db SYM_CURSOR_R ; cursor image
	db SYM_SPACE    ; tile behind cursor
	dw NULL         ; function pointer if non-0

MultichoiceTextbox_ConfigTable_ChooseDeckStarterDeck:
	db $04, $00     ; x, y to start drawing box
	db $10, $08     ; width, height of box
	db $06, $02     ; x, y coordinate to start printing next text
	tx CharmanderAndFriendsDeckChoiceText     ; text id to print next
	db $06, $04     ; x, y coordinate to start printing next text
	tx SquirtleAndFriendsDeckChoiceText       ; text id to print next
	db $06, $06     ; x, y coordinate to start printing next text
	tx BulbasaurAndFriendsDeckChoiceText      ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $05, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $03          ; cursor max index
	db SYM_CURSOR_R ; cursor image
	db SYM_SPACE    ; tile behind cursor
	dw NULL         ; function pointer if non-0

SamNormalMultichoice_ConfigurationTable:
	db $0a, $00     ; x, y to start drawing box
	db $0a, $0a     ; width, height of box
	db $0c, $02     ; x, y coordinate to start printing next text
	tx SamNormalMenuText     ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $0b, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $04          ; cursor max index
	db SYM_CURSOR_R ; cursor image
	db SYM_SPACE    ; tile behind cursor
	dw NULL         ; function pointer if non-0

SamRulesMultichoice_ConfigurationTable:
	db $06, $00     ; x, y to start drawing box
	db $0e, $12     ; width, height of box
	db $08, $02     ; x coordinate to start printing text
	tx SamRulesMenuText     ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $07, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $08          ; cursor max index
	db SYM_CURSOR_R ; cursor image
	db SYM_SPACE    ; tile behind cursor
	dw NULL         ; function pointer if non-0
