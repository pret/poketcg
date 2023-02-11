MACRO portrait
	db \1 ; tileset
	db \2 ; palette
	dw \3 ; SGB pals
ENDM

PortraitGfxData:
	table_width 4, PortraitGfxData
	portrait TILESET_PLAYER,    PALETTE_119, SGBData_PlayerPortraitPals       ; INVALID_PIC
	portrait TILESET_PLAYER,    PALETTE_119, SGBData_PlayerPortraitPals       ; PLAYER_PIC
	portrait TILESET_RONALD,    PALETTE_121, SGBData_RonaldPortraitPals       ; RONALD_PIC
	portrait TILESET_SAM,       PALETTE_122, SGBData_SamPortraitPals          ; SAM_PIC
	portrait TILESET_IMAKUNI,   PALETTE_123, SGBData_ImakuniPortraitPals      ; IMAKUNI_PIC
	portrait TILESET_NIKKI,     PALETTE_124, SGBData_NikkiPortraitPals        ; NIKKI_PIC
	portrait TILESET_RICK,      PALETTE_125, SGBData_RickPortraitPals         ; RICK_PIC
	portrait TILESET_KEN,       PALETTE_126, SGBData_KenPortraitPals          ; KEN_PIC
	portrait TILESET_AMY,       PALETTE_127, SGBData_AmyPortraitPals          ; AMY_PIC
	portrait TILESET_ISAAC,     PALETTE_128, SGBData_IsaacPortraitPals        ; ISAAC_PIC
	portrait TILESET_MITCH,     PALETTE_129, SGBData_MitchPortraitPals        ; MITCH_PIC
	portrait TILESET_GENE,      PALETTE_130, SGBData_GenePortraitPals         ; GENE_PIC
	portrait TILESET_MURRAY,    PALETTE_131, SGBData_MurrayPortraitPals       ; MURRAY_PIC
	portrait TILESET_COURTNEY,  PALETTE_132, SGBData_CourtneyPortraitPals     ; COURTNEY_PIC
	portrait TILESET_STEVE,     PALETTE_133, SGBData_StevePortraitPals        ; STEVE_PIC
	portrait TILESET_JACK,      PALETTE_134, SGBData_JackPortraitPals         ; JACK_PIC
	portrait TILESET_ROD,       PALETTE_135, SGBData_RodPortraitPals          ; ROD_PIC
	portrait TILESET_JOSEPH,    PALETTE_136, SGBData_JosephPortraitPals       ; JOSEPH_PIC
	portrait TILESET_DAVID,     PALETTE_137, SGBData_DavidPortraitPals        ; DAVID_PIC
	portrait TILESET_ERIK,      PALETTE_138, SGBData_ErikPortraitPals         ; ERIK_PIC
	portrait TILESET_JOHN,      PALETTE_139, SGBData_JohnPortraitPals         ; JOHN_PIC
	portrait TILESET_ADAM,      PALETTE_140, SGBData_AdamPortraitPals         ; ADAM_PIC
	portrait TILESET_JONATHAN,  PALETTE_141, SGBData_JonathanPortraitPals     ; JONATHAN_PIC
	portrait TILESET_JOSHUA,    PALETTE_142, SGBData_JoshuaPortraitPals       ; JOSHUA_PIC
	portrait TILESET_NICHOLAS,  PALETTE_143, SGBData_NicholasPortraitPals     ; NICHOLAS_PIC
	portrait TILESET_BRANDON,   PALETTE_144, SGBData_BrandonPortraitPals      ; BRANDON_PIC
	portrait TILESET_MATTHEW,   PALETTE_145, SGBData_MatthewPortraitPals      ; MATTHEW_PIC
	portrait TILESET_RYAN,      PALETTE_146, SGBData_RyanPortraitPals         ; RYAN_PIC
	portrait TILESET_ANDREW,    PALETTE_147, SGBData_AndrewPortraitPals       ; ANDREW_PIC
	portrait TILESET_CHRIS,     PALETTE_148, SGBData_ChrisPortraitPals        ; CHRIS_PIC
	portrait TILESET_MICHAEL,   PALETTE_149, SGBData_MichaelPortraitPals      ; MICHAEL_PIC
	portrait TILESET_DANIEL,    PALETTE_150, SGBData_DanielPortraitPals       ; DANIEL_PIC
	portrait TILESET_ROBERT,    PALETTE_151, SGBData_RobertPortraitPals       ; ROBERT_PIC
	portrait TILESET_BRITTANY,  PALETTE_152, SGBData_BrittanyPortraitPals     ; BRITTANY_PIC
	portrait TILESET_KRISTIN,   PALETTE_153, SGBData_KristinPortraitPals      ; KRISTIN_PIC
	portrait TILESET_HEATHER,   PALETTE_154, SGBData_HeatherPortraitPals      ; HEATHER_PIC
	portrait TILESET_SARA,      PALETTE_155, SGBData_SaraPortraitPals         ; SARA_PIC
	portrait TILESET_AMANDA,    PALETTE_156, SGBData_AmandaPortraitPals       ; AMANDA_PIC
	portrait TILESET_JENNIFER,  PALETTE_157, SGBData_JenniferPortraitPals     ; JENNIFER_PIC
	portrait TILESET_JESSICA,   PALETTE_158, SGBData_JessicaPortraitPals      ; JESSICA_PIC
	portrait TILESET_STEPHANIE, PALETTE_159, SGBData_StephaniePortraitPals    ; STEPHANIE_PIC
	portrait TILESET_AARON,     PALETTE_160, SGBData_AaronPortraitPals        ; AARON_PIC
	portrait TILESET_PLAYER,    PALETTE_120, SGBData_LinkOpponentPortraitPals ; LINK_OPP_PIC
	assert_table_length NUM_PICS
