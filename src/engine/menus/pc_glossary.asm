_PCMenu_Glossary:
	ld a, [wd291]
	push af
	call InitMenuScreen
	lb de, $30, $ff
	call SetupText
	call FlashWhiteScreen
	farcall OpenGlossaryScreen
	pop af
	ld [wd291], a
	ret
