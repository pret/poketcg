ReceiveDeckConfiguration:
	farcall _ReceiveDeckConfiguration
	ret

SendDeckConfiguration:
	farcall _SendDeckConfiguration
	ret

ReceiveCard:
	farcall _ReceiveCard
	ret

SendCard:
	farcall _SendCard
	ret

; handles all the Card Pop! functionality
DoCardPop:
	farcall _DoCardPop
	ret

Func_7576:
	farcall Func_1991f
	ret

PreparePrinterConnection:
	farcall _PreparePrinterConnection
	ret

PrintDeckConfiguration:
	farcall _PrintDeckConfiguration
	ret

PrintCardList:
	farcall _PrintCardList
	ret

Func_758a:
	farcall Func_19eb4
	ret

SetUpAndStartLinkDuel:
	farcall _SetUpAndStartLinkDuel
	ret

Func_7594:
	farcall Func_1a61f
	ret

OpenBoosterPack:
	farcall _OpenBoosterPack
	ret
