MACRO portrait
	db \1 ; tileset
	db \2 ; palette
	dw \3 ; SGB pals
ENDM

PortraitGfxData:
	table_width 4
	portrait TILESET_PLAYER,    PALETTE_PLAYER_PIC,    SGBData_PlayerPortraitPals       ; INVALID_PIC
	portrait TILESET_PLAYER,    PALETTE_PLAYER_PIC,    SGBData_PlayerPortraitPals       ; PLAYER_PIC
	portrait TILESET_RONALD,    PALETTE_RONALD_PIC,    SGBData_RonaldPortraitPals       ; RONALD_PIC
	portrait TILESET_SAM,       PALETTE_SAM_PIC,       SGBData_SamPortraitPals          ; SAM_PIC
	portrait TILESET_IMAKUNI,   PALETTE_IMAKUNI_PIC,   SGBData_ImakuniPortraitPals      ; IMAKUNI_PIC
	portrait TILESET_NIKKI,     PALETTE_NIKKI_PIC,     SGBData_NikkiPortraitPals        ; NIKKI_PIC
	portrait TILESET_RICK,      PALETTE_RICK_PIC,      SGBData_RickPortraitPals         ; RICK_PIC
	portrait TILESET_KEN,       PALETTE_KEN_PIC,       SGBData_KenPortraitPals          ; KEN_PIC
	portrait TILESET_AMY,       PALETTE_AMY_PIC,       SGBData_AmyPortraitPals          ; AMY_PIC
	portrait TILESET_ISAAC,     PALETTE_ISAAC_PIC,     SGBData_IsaacPortraitPals        ; ISAAC_PIC
	portrait TILESET_MITCH,     PALETTE_MITCH_PIC,     SGBData_MitchPortraitPals        ; MITCH_PIC
	portrait TILESET_GENE,      PALETTE_GENE_PIC,      SGBData_GenePortraitPals         ; GENE_PIC
	portrait TILESET_MURRAY,    PALETTE_MURRAY_PIC,    SGBData_MurrayPortraitPals       ; MURRAY_PIC
	portrait TILESET_COURTNEY,  PALETTE_COURTNEY_PIC,  SGBData_CourtneyPortraitPals     ; COURTNEY_PIC
	portrait TILESET_STEVE,     PALETTE_STEVE_PIC,     SGBData_StevePortraitPals        ; STEVE_PIC
	portrait TILESET_JACK,      PALETTE_JACK_PIC,      SGBData_JackPortraitPals         ; JACK_PIC
	portrait TILESET_ROD,       PALETTE_ROD_PIC,       SGBData_RodPortraitPals          ; ROD_PIC
	portrait TILESET_JOSEPH,    PALETTE_JOSEPH_PIC,    SGBData_JosephPortraitPals       ; JOSEPH_PIC
	portrait TILESET_DAVID,     PALETTE_DAVID_PIC,     SGBData_DavidPortraitPals        ; DAVID_PIC
	portrait TILESET_ERIK,      PALETTE_ERIK_PIC,      SGBData_ErikPortraitPals         ; ERIK_PIC
	portrait TILESET_JOHN,      PALETTE_JOHN_PIC,      SGBData_JohnPortraitPals         ; JOHN_PIC
	portrait TILESET_ADAM,      PALETTE_ADAM_PIC,      SGBData_AdamPortraitPals         ; ADAM_PIC
	portrait TILESET_JONATHAN,  PALETTE_JONATHAN_PIC,  SGBData_JonathanPortraitPals     ; JONATHAN_PIC
	portrait TILESET_JOSHUA,    PALETTE_JOSHUA_PIC,    SGBData_JoshuaPortraitPals       ; JOSHUA_PIC
	portrait TILESET_NICHOLAS,  PALETTE_NICHOLAS_PIC,  SGBData_NicholasPortraitPals     ; NICHOLAS_PIC
	portrait TILESET_BRANDON,   PALETTE_BRANDON_PIC,   SGBData_BrandonPortraitPals      ; BRANDON_PIC
	portrait TILESET_MATTHEW,   PALETTE_MATTHEW_PIC,   SGBData_MatthewPortraitPals      ; MATTHEW_PIC
	portrait TILESET_RYAN,      PALETTE_RYAN_PIC,      SGBData_RyanPortraitPals         ; RYAN_PIC
	portrait TILESET_ANDREW,    PALETTE_ANDREW_PIC,    SGBData_AndrewPortraitPals       ; ANDREW_PIC
	portrait TILESET_CHRIS,     PALETTE_CHRIS_PIC,     SGBData_ChrisPortraitPals        ; CHRIS_PIC
	portrait TILESET_MICHAEL,   PALETTE_MICHAEL_PIC,   SGBData_MichaelPortraitPals      ; MICHAEL_PIC
	portrait TILESET_DANIEL,    PALETTE_DANIEL_PIC,    SGBData_DanielPortraitPals       ; DANIEL_PIC
	portrait TILESET_ROBERT,    PALETTE_ROBERT_PIC,    SGBData_RobertPortraitPals       ; ROBERT_PIC
	portrait TILESET_BRITTANY,  PALETTE_BRITTANY_PIC,  SGBData_BrittanyPortraitPals     ; BRITTANY_PIC
	portrait TILESET_KRISTIN,   PALETTE_KRISTIN_PIC,   SGBData_KristinPortraitPals      ; KRISTIN_PIC
	portrait TILESET_HEATHER,   PALETTE_HEATHER_PIC,   SGBData_HeatherPortraitPals      ; HEATHER_PIC
	portrait TILESET_SARA,      PALETTE_SARA_PIC,      SGBData_SaraPortraitPals         ; SARA_PIC
	portrait TILESET_AMANDA,    PALETTE_AMANDA_PIC,    SGBData_AmandaPortraitPals       ; AMANDA_PIC
	portrait TILESET_JENNIFER,  PALETTE_JENNIFER_PIC,  SGBData_JenniferPortraitPals     ; JENNIFER_PIC
	portrait TILESET_JESSICA,   PALETTE_JESSICA_PIC,   SGBData_JessicaPortraitPals      ; JESSICA_PIC
	portrait TILESET_STEPHANIE, PALETTE_STEPHANIE_PIC, SGBData_StephaniePortraitPals    ; STEPHANIE_PIC
	portrait TILESET_AARON,     PALETTE_AARON_PIC,     SGBData_AaronPortraitPals        ; AARON_PIC
	portrait TILESET_PLAYER,    PALETTE_LINK_OPP_PIC,  SGBData_LinkOpponentPortraitPals ; LINK_OPP_PIC
	assert_table_length NUM_PICS
