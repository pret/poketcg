; poketcg requires rgbds 0.4.1 or newer.
MAJOR EQU 0
MINOR EQU 4
PATCH EQU 1

IF !DEF(__RGBDS_MAJOR__) || !DEF(__RGBDS_MINOR__) || !DEF(__RGBDS_PATCH__)
	fail "poketcg requires rgbds {MAJOR}.{MINOR}.{PATCH} or newer."
ELIF (__RGBDS_MAJOR__ < MAJOR) || \
	(__RGBDS_MAJOR__ == MAJOR && __RGBDS_MINOR__ < MINOR) || \
	(__RGBDS_MAJOR__ == MAJOR && __RGBDS_MINOR__ == MINOR && __RGBDS_PATCH__ < PATCH)
	fail "poketcg requires rgbds {MAJOR}.{MINOR}.{PATCH} or newer."
ENDC
