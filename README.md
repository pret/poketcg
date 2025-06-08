# Pokémon TCG [![Build Status][ci-badge]][ci]

This is a disassembly of Pokémon TCG.

It builds the following ROM:

- Pokémon Trading Card Game (U) [C][!].gbc `sha1: 0f8670a583255cff3e5b7ca71b5d7454d928fc48`

To assemble, first download RGBDS (https://github.com/gbdev/rgbds/releases) and extract it to /usr/local/bin.
Run `make` in your shell.

This will output a file named "poketcg.gbc".


## See also

- [**Wiki**][wiki] (includes [tutorials][tutorials])
- [**Symbols**][symbols]
- [**Tools**][tools]

You can find us on [Discord (pret, #poketcg)](https://discord.gg/d5dubZ3).

For other pret projects, see [pret.github.io](https://pret.github.io/).

[wiki]: https://github.com/pret/poketcg/wiki
[tutorials]: https://github.com/pret/poketcg/wiki/Tutorials
[symbols]: https://github.com/pret/poketcg/tree/symbols
[tools]: https://github.com/pret/gb-asm-tools
[ci]: https://github.com/pret/poketcg/actions
[ci-badge]: https://github.com/pret/poketcg/actions/workflows/main.yml/badge.svg
