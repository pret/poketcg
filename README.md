# Pokémon TCG

This is a disassembly of Pokémon TCG.

It uses the following ROM as a base:

* Pokémon Trading Card Game (U) [C][!].gbc  `md5: 219b2cc64e5a052003015d4bd4c622cd`

To assemble, first download RGBDS (https://github.com/bentley/rgbds/releases) and extract it to /usr/local/bin.
Build RGBGFX (https://github.com/stag019/rgbgfx) and put it in /usr/local/bin.
Copy the above ROM to this directory as "baserom.gbc".
Run `make` in your shell.

This will output a file named "tcg.gbc".