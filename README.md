# Pokémon TCG [![Build Status][ci-badge]][ci]

This is a disassembly of Pokémon TCG.

It builds the following ROM:

- Pokémon Trading Card Game (U) [C][!].gbc `sha1: 0f8670a583255cff3e5b7ca71b5d7454d928fc48`

To assemble, first download RGBDS (https://github.com/gbdev/rgbds/releases) and extract it to /usr/local/bin.
Run `make` in your shell.

This will output a file named "poketcg.gbc".


## See also

- [**Symbols**][symbols]
- **Discord:** [pret][discord]
- **IRC:** [libera#pret][irc]

Other disassembly projects:

- [**Pokémon TCG 2**][poketcg2]
- [**Pokémon Red/Blue**][pokered]
- [**Pokémon Yellow**][pokeyellow]
- [**Pokémon Gold/Silver**][pokegold]
- [**Pokémon Crystal**][pokecrystal]
- [**Pokémon Pinball**][pokepinball]
- [**Pokémon Ruby**][pokeruby]
- [**Pokémon FireRed**][pokefirered]
- [**Pokémon Emerald**][pokeemerald]

[poketcg2]: https://github.com/pret/poketcg2
[pokered]: https://github.com/pret/pokered
[pokeyellow]: https://github.com/pret/pokeyellow
[pokegold]: https://github.com/pret/pokegold
[pokecrystal]: https://github.com/pret/pokecrystal
[pokepinball]: https://github.com/pret/pokepinball
[pokeruby]: https://github.com/pret/pokeruby
[pokefirered]: https://github.com/pret/pokefirered
[pokeemerald]: https://github.com/pret/pokeemerald
[symbols]: https://github.com/pret/poketcg/tree/symbols
[discord]: https://discord.gg/d5dubZ3
[irc]: https://web.libera.chat/?#pret
[ci]: https://github.com/pret/poketcg/actions
[ci-badge]: https://github.com/pret/poketcg/actions/workflows/main.yml/badge.svg
