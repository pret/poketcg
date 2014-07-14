# Pokémon TCG

This is a disassembly of Pokémon TCG.

It uses the following ROM as a base:

* Pokemon Trading Card Game (U) [C][!].gbc  `md5: 219b2cc64e5a052003015d4bd4c622cd`

To assemble, first download RGBDS (http://iimarck.us/etc/rgbds.zip) and extract
the exe's to /usr/local/bin.
Then copy the above ROM to this directory as "baserom.gbc".
Then run `easy_install git://github.com/drj11/pypng.git@master#egg=pypng`
Then run `make` in your shell.

This will output a file named "tcg.gbc".