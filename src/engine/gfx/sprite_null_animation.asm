; in case GetAnimationFramePointer fails to get a valid pointer
; it defaults to this animation data
SpriteNullAnimationPointer::
	dw SpriteNullAnimationFrame

SpriteNullAnimationFrame:
	db 0
