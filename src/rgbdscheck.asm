IF !DEF(__RGBDS_MAJOR__) || !DEF(__RGBDS_MINOR__) || !DEF(__RGBDS_PATCH__)
	fail "poketcg requires rgbds v0.8.0 or newer."
ENDC
IF __RGBDS_MAJOR__ == 0 && __RGBDS_MINOR__ < 8
	fail "poketcg requires rgbds v0.8.0 or newer."
ENDC
