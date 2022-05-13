; poketcg requires rgbds 0.5.0 or newer.
DEF MAJOR EQU 0
DEF MINOR EQU 5
DEF PATCH EQU 0

IF !DEF(__RGBDS_MAJOR__) || !DEF(__RGBDS_MINOR__) || !DEF(__RGBDS_PATCH__)
	FAIL "poketcg requires rgbds {MAJOR}.{MINOR}.{PATCH} or newer."
ELIF (__RGBDS_MAJOR__ < MAJOR) || \
	(__RGBDS_MAJOR__ == MAJOR && __RGBDS_MINOR__ < MINOR) || \
	(__RGBDS_MAJOR__ == MAJOR && __RGBDS_MINOR__ == MINOR && __RGBDS_PATCH__ < PATCH)
	FAIL "poketcg requires rgbds {MAJOR}.{MINOR}.{PATCH} or newer."
ENDC
