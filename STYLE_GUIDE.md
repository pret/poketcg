If you have plans to contribute to the poketcg disassembly, consider giving this a quick read (and, also, thank you!). But, please, don't be intimidated by it! I think it contains some useful pointers to help make your work as readable and clean as possible for other contributors and eventual users, as well as to make the style consistent accross the repository.


# Table of contents

- [Disassembling code](#disassembling-code)
- [Labels](#labels)
- [Naming labels](#naming-labels)
  * [Function labels](#function-labels)
  * [Data labels](#data-labels)
  * [Text labels](#text-labels)
  * [Local labels](#local-labels)
- [Adding documentation](#adding-documentation)
  * [Documenting code](#documenting-code)
  * [Documenting data](#documenting-data)
- [RAM addresses](#ram-addresses)
- [Constants](#constants)
- [Numbers](#numbers)
- [Macros](#macros)
- [Refractoring](#refractoring)


# Disassembling code

For disassembling code, use the tools/tcgdisasm.py python script. Make sure to always build poketcg before disassembling if you made or pulled any new changes to the source, so that the sym file has the updated labels and the tcgdisasm.py output is accurate.


# Labels

The preferred syntax for labels is ``PascalCaseLabel:`` for global labels, and ``.snake_case_label`` for local labels (if the global label needs to be exported, add the second semicolon in the declaration).

As long as a label can be made local due to not being referenced from non-local code, a local label is preferred over a global label. This also applies to data structures that are local to a given function.

There might be cases where a label "feels" local but needs to be referenced from outside the local scope. For example, there could be a function with 10 local labels, and one of them, which may not necessarily be referenced from inside the function, is referenced externally. If turning that specific label into a global label would require converting some of the others affecting the readability of the function, it's okay to keep it as a local label and reference it externally as ``GlobalLabel.local_label``.


# Naming labels

For unnamed functions and labels, the preferred syntax is ``Func_9000`` and ``.asm_9000`` for consistency with the rest of the repository. This is how tcgdisasm.py outputs them. Also keep the address comments output by the script.

## Function labels

When naming a function, it should be concise but also capture the purpose and context of the function as much as possible. If the name is too generic, it will hardly help identifying what the function is doing. For example, ``SetCardListHeaderText`` is better than ``SetHeader`` because the latter doesn't tell anything about the context. Also, if the name if too ambiguous, it's very likely that there is some other function that performs a similar things under different conditions that would receive the same name as it, or the names given to them suggest that they don't do similar things. When multiple functions are used in the same context, but do different things or do the same things in different conditions, you should try to give them names that suggest what their similarities and differences are. For example:

* ``GetTextLengthInTiles``
* ``GetTextLengthInHalfTiles``
* ``OpenTurnHolderPlayAreaScreen``
* ``OpenNonTurnHolderDiscardPileScreen``
* ``LoadCardDataToBuffer1_FromCardID``
* ``LoadCardDataToBuffer1_FromDeckIndex``
* ``CheckIfEnoughEnergiesToMove``
* ``CheckIfEnoughEnergiesOfType``

Sometimes a function is the most top-level function of this kind, so it can be given a very direct name that suggests it, like:

* ``ProcessText``

Then, in the above example, you can label ``ProcessText`` subroutines and/or functions that simply fall through to ``ProcessText`` but with some twist accordingly:

* ``ProcessTextFromID``
* ``ProcessTextFromPointerToID``
* ``InitTextPrinting_ProcessTextFromID``
* ``InitTextPrinting_ProcessTextFromPointerToID``

Here, the first two are "``ProcessText`` with a twist" and the last two do something else in addition to that. You can use ``_`` in function labels for readability and to prefix functions that belong to the same specific module, but don't overuse it.

Another common case is functions that are declared in the home bank for accessibility but their code resides somehwere else. In these cases you can prepend ``_`` to the non-home function to suggest that it's not intended to be called directly. For example:

```
CopyCardNameAndLevel: ; 29f5 (0:29f5)
	farcall _CopyCardNameAndLevel
	ret
; 0x29fa  
 ```
## Data labels

The conventions indicated for function labels also apply to data labels. For example, the following four point to similar data structures:

* ``ItemSelectionMenuParameters``
* ``AttackMenuParameters``
* ``WideTextBoxMenuParameters``
* ``NarrowTextBoxMenuParameters``

## Text labels

For text labels, if the text they point to is short, the label should be nearly identical to the text, but with ``Text`` appended to the label. For example: 

```
PleaseSelectHandText: ; 373b5 (d:73b5)
	text "Please select"
	line "Hand."
	done
```

If the text is longer, the least relevant words can usually be trimmed from the label. For duplicate texts, you can append ``Text_2`` to the second one instead of ``Text``.

There are some exceptions, such as card names or descriptions, deck names, NPC texts, or a group of texts belonging to a specific feature such as the practice duel instruction texts. These may be formatted differently rather than after the text they contain. For example:

``EkansName``
``EkansDescription``
``Turn4DrMason1PracticeDuelText``
``Turn4DrMason2PracticeDuelText``

## Local labels

In contrast to golbal label names, local label names should be simpler, since the context is already assumed to the that of the function they are at. Sometimes a ``.loop``, ``.next``, or ``.done`` label suffices, or the corresponding ``.do_this`` or ``.do_that``.


# Adding documentation

## Documenting code

After some function has been properly labeled and figured out, you can add a comment header to it just above the function name. This is the most common way to document code:

```
; draw a 20x6 text box aligned to the bottom of the screen
; and print the text at hl without letter delay
DrawWideTextBox_PrintTextNoDelay: ; 2a36 (0:2a36)
```

For small or utility functions, it's usually most useful to focus on the "What" and on the "When" (context), rather than on the "How". The goal here is to give as much information about the function as possible so that a viewer doesn't need to get into the function's code itself to find out what the function does, or that just a quick glance at it reveals what there is to know about it. This is particularly useful for tracking down parent routines that call it as a subroutine, so that you only need to give the subroutine's header a quick read before going back to tracking down on the parent routine. 

Another important thing to document in many cases is the input and output parameters of a function, which is some combination of registers, flags, and/or RAM addresses. For functions that do a specific thing, this is often the most effective manner to tell what comes in and what comes out. Chances are, when you work on understanding some previously undocumented block of code, you are the person in the world that knows most about it, so just document it in the manner that, for you, best expresses what you've understood about it.

More examples below.

```
; copies b bytes of data to sp-$1f and to hl, and returns hl += BG_MAP_WIDTH
; d = value of byte 0
; e = value of byte b
; a = value of bytes [1, b-1]
; b is supposed to be BG_MAP_WIDTH or smaller, else the stack would get corrupted
CopyLine: ; 1ea5 (0:1ea5)
```

```
; check if a pokemon card has enough energy attached to it in order to use a move
; input:
;   d = deck index of card (0 to 59)
;   e = attack index (0 or 1)
;   wAttachedEnergies and wTotalAttachedEnergies
; returns: carry if not enough energy, nc if enough energy.
_CheckIfEnoughEnergiesToMove: ; 48ac (1:48ac)
```

```
; return carry if the turn holder's arena Pokemon card is double poisoned or asleep.
; also, if confused, paralyzed, or asleep, return the status condition in a.
IsArenaPokemonAsleepOrDoublePoisoned: ; 6c68 (1:6c68)
```

Function headers can also be effective to highlight the difference between functions that do similar things, but with a twist or an additional feaure. For example:

```
; draw a 12x6 text box aligned to the bottom left of the screen
DrawNarrowTextBox: ; 2a6f (0:2a6f)
```

```
; draw a 12x6 text box aligned to the bottom left of the screen
; and print the text at hl without letter delay
DrawNarrowTextBox_PrintTextNoDelay: ; 2a3e (0:2a3e)
```

```
; draw a 20x6 text box aligned to the bottom of the screen
; and print the text at hl with letter delay
DrawWideTextBox_PrintText: ; 2a59 (0:2a59)
```

Sometimes, a function is large enough that just adding a comment header doesn't cut it. These are usually top level functions that call multiple subroutines themselves. These are usually fully documented last, as they usually require knowing what the smaller pieces inside it do. In these cases, inline comments are very helpful to complement the code when someone is walking through the function. In these cases, writing comments in a new line in-between code lines is usually preferred over comments in the same line as the code, unless it's a very short comment. 

It may be possible that just the use of proper constants and labels (along with the header comments) suffices and inline comments aren't necessary though. Depends on what you think on each case.

## Documenting data

It's also useful to add comment headers to data structures. This is usually done to explain what they contain and perhaps what function or code uses it and with what purpose. Inline comments are often helpful to highlight the meaning of each unique parameter. For example:

```
BoosterPack_ColosseumNeutral:: ; 1e4e4 (7:64e4)
	booster_set COLOSSEUM ; booster pack set
	dw GenerateRandomEnergy ; energy or energy generation function

; Card Type Chances
	db 20 ; Grass Type Chance
	db 20 ; Fire Type Chance
	db 20 ; Water Type Chance
	db 20 ; Lightning Type Chance
	db 20 ; Fighting Type Chance
	db 20 ; Psychic Type Chance
	db 20 ; Colorless Type Chance
	db 20 ; Trainer Card Chance
	db  0 ; Energy Card Chance
```

For data structures, the header comments often go below the label, so that it's "closer" to the data that it is describing:

```
DuelHorizontalSeparatorTileData: ; 5199 (1:5199)
; x, y, tiles[], 0
	db 0, 4, $37, $37, $37, $37, $37, $37, $37, $37, $37, $31, $32, 0
	db 9, 5, $33, $34, 0
	db 9, 6, $33, $34, 0
	db 9, 7, $35, $36, $37, $37, $37, $37, $37, $37, $37, $37, $37, 0
	db $ff
; 0x51c0
```


# RAM addresses

Naming RAM addresses and using them in code is extremely helpful towards having easily readable code. RAM addresses are pascal case and prefixed with a letter depending on whether they are a WRAM address (``wAddressName``), a VRAM address (``vÀddressName``), a HRAM address (``hAddressName``), or a hardware register (for example, ``rLCDC``). These all go in their respective files, which are, wram.asm, vram.asm, hram.asm, and constants/hardware_constants.asm. You will most often want to label some WRAM addresses, or maybe some HRAM address, but VRAM addresses should already be covered and hardware constants are all already defined.

Note how RAM addresses aren't always necessarily one byte long. A simple example would be addresses that hold some pointer which would be 16-bit long. It's important that the ``ds`` below indicates what it's actual size is. If for example there's a 5-byte space unassigned below a ``ds 1`` address, it's better to have ``ds 1`` followed by ``ds 5`` rather than a single ``ds 6``. Speaking of ``ds``, prefer ``ds 1`` to ``db`` and ``ds 2`` to ``dw`` for declaring the size of a memory address.

Whenever you figure out the meaning of some RAM address, you should be looking to give it an adequate name. The tips about clarity and avoiding ambiguity discussed for label names mostly apply here. Don't make the RAM address name too long, but also make sure it suggests the gist of what the RAM address is used for and isn't confusing with other addresses with similar uses (or the same use in a different context). Obviously, it's often not possible to give some address a perfect name, so use the one that sounds best to you with these suggestions in mind. It should also be noted that, even if you don't yet have a clue about what a RAM address does (or don't know it to enough extent to properly name it), it's better to still assign it a "default" name (e.g. ``wd123``), than use the hardcoded value output by the disassembler (e.g. ``$d123``). This makes it eventually easier to rename all its references at once.

When naming WRAM addresses that belong to the same context or feature, try to make them look like so. This is often the case with a block of WRAM addresses that map directly to some data structure that is loaded to memory. Examples of this are ``wLoadedCard1`` and ``wLoadedCard2`` each of which is followed by addresses like ``wLoadedCard1Type``, ``wLoadedCard1Name``, or ``wLoadedCard1Rarity``. These are a group of WRAM addresses allocated to temporarily hold data of a card, following the data structures that define the characteristics of each existing card in the game. These blocks of WRAM addresses are often supported by macros (defined themselves in macros/wram.asm), so that they look like this in wram.asm:

```
wLoadedCard1:: ; cc24
	card_data_struct wLoadedCard1
wLoadedCard2:: ; cc65
	card_data_struct wLoadedCard2
```

Lastly, adding some line of commentary to the memory address is helpful when just the name itself doesn't quite tell the whole story. Usually, this is done to clarify where the memory address is used, or to explain which kind of different values it may hold and perhaps what each of them means (or just to mention the support of specific values, such as $00 or $ff). If the RAM address is supposed to hold a value that maps directly to some group of already defined constants, this is the perfect place to indicate it. Adding commentary to an address that contains a bit field is also particularly useful to describe what each bit means, since that's not doable with just the address name.

Some examples:

```
; 60-byte array that maps each card to its position in the deck or anywhere else
; This array is initialized to 00, 01, 02, ..., 59, until deck is shuffled.
; Cards in the discard pile go first, cards still in the deck go last, and others go in-between.
wPlayerDeckCards:: ; c27e
	ds DECK_SIZE
```

```
; a DUELTYPE_* constant. note that for a practice duel, wIsPracticeDuel must also be set to $1
wDuelType:: ; cc09
	ds $1
```

```
; information about the text being currently processed, including font width,
; the rom bank, and the memory address of the next character to be printed.
; supports up to four nested texts (used with TX_RAM).
wTextHeader1:: ; ce2b
	text_header wTextHeader1
wTextHeader2:: ; ce30
	text_header wTextHeader2
wTextHeader3:: ; ce35
	text_header wTextHeader3
wTextHeader4:: ; ce3a
	text_header wTextHeader4
```

```
; selects a PLAY_AREA_* slot in order to display information related to it. used by functions
; such as PrintPlayAreaCardLocation, PrintPlayAreaCardInformation and PrintPlayAreaCardHeader
wCurPlayAreaSlot:: ; cbc9

; X position to display the attached energies, HP bar, and Pluspower/Defender icons
; obviously different for player and opponent side. used by DrawDuelHUD.
wHUDEnergyAndHPBarsX:: ; cbc9
	ds $1
```

The last one is also an example of a single addresses used for multiple well-differentiated purposes. In this specific case, it's a good idea to assign as many separate names to it, and then use them accordingly in the code.


# Constants

Using constants in place of hardcoded numbers is another of the main pillars for achieving self-documenting code in the disassembly. The format used for constants is SNAKE_UPPERCASE. Normally, they would look like ``SHAREDPREFIX_CONSTANT_NAME``, with ``SHAREDPREFIX_`` shared by all constants belonging to the same group (category). 

The way I would approach this is, whenever you see any hardcoded number in the code, as yourself: does it make sense to replace it with some constant? More often than not, the answer would be yes. There are obviously exceptions, such as arithmetic operations or screen coordinates that don't win much by receiving a constant. But as soon as you know what some number stands for, if you think a constant would be appropriate, first look up the constants/ directory in case it already exists, and, if it doesn't, feel free to create it. Put it into a existing constants/ file or create a new file if none fits.

A constant almost never comes alone. For example a single ``BULBASAUR`` or ``BULBASAUR_AND_FRIENDS_DECK`` constant wouldn't make much sense if it's not defined along with the constants for the rest of the cards and decks respectively. In a lot of cases, a group of constants belong to a specific memory address. For example, the ``wPlayerCardLocations`` buffer is associated to several constants, such as ``CARD_LOCATION_DECK``, ``CARD_LOCATION_HAND``, and ``CARD_LOCATION_DISCARD_PILE``. This means that every read or write to ``wPlayerCardLocations`` will involve the use of some of those constants.

There are, however, other cases where individual constants also help improve the readability of the code (or data structure) that is going to use them. Sizes/lengths and maximum values are good examples of this. For example, ``MAX_BENCH_POKEMON``, ``MAX_PLAY_AREA_POKEMON``, ``DECK_SIZE``, or just a generic one like ``SCREEN_WIDTH``. Do this when there are multiple candidates to replace in the code. For example, if a specific feature drew a cursor in screen coordinates 8,9 and nothing else did it, it wouldn't make sense to create a constant like ``FEATURE_X_CURSOR_COORDS`` just to replace those very specific numbers (an inline comment near the instruction might be appropriate instead).

Speaking of generic constants, there are multiple constants aleady defined for dealing with close-to-hardware stuff that you should be looking to use when appropriate (button constans such as ``A_BUTTON`` are another good examples of this). The already defined text constants (and macros) help dealing with text-related code and data, and are particularly helpful for distingushing between the different game fonts.

Constants for WRAM address offsets (i.e. for the likes of ``wAddressN - wAddress``) are sometimes a good idea às well, and typically follow the addresses defined in some WRAM macro. For example, look at the constants defined with the previously seen ``card_data_struct`` macro in mind:

```
CARD_DATA_TYPE                  EQU $00
CARD_DATA_GFX                   EQU $01
CARD_DATA_NAME                  EQU $03
CARD_DATA_RARITY                EQU $05
(...)
TRN_CARD_DATA_LENGTH    EQU $0e
ENERGY_CARD_DATA_LENGTH EQU $0e
PKMN_CARD_DATA_LENGTH   EQU $41
```

Some constants make sense to have as both a value and a flag. Again, button constants are a good example of this. For these, the convention is to use ``CONSTANT_NAME`` for the value, and ``CONSTANT_NAME_F`` for the flag, so you can use either of them depending on the assembly instruction (e.g. ``and CONSTANT_NAME`` or ``bit CONSTANT_NAME_F, a``. For example:

```
A_BUTTON_F EQU 0
B_BUTTON_F EQU 1
(...)

A_BUTTON   EQU 1 << A_BUTTON_F ; $01
B_BUTTON   EQU 1 << B_BUTTON_F ; $02
(...)
```

Bit mask constants are also useful if they are used multiple times. Buttons again are a simple enough example to illustrate this:

```
BUTTONS    EQU A_BUTTON | B_BUTTON | SELECT | START  ; $0f
D_PAD      EQU D_RIGHT  | D_LEFT   | D_UP   | D_DOWN ; $f0
```

Finally, note that constants that are exclusive to a specific feature or function should generally be local, and thus placed above the code that uses them. This is usually not the case, however, so you should usually be looking to declare them inside the constants/ directory as mentioned before. This kind of refractoring is also more appropriate when the disassembly is in a more advanced state as well.

# Numbers

Prefer decimal numbers over hexadecimal numbers when the number is referring to something that makes sense to be measured. For example, the length of a string or the screen coordinates where something is to be placed. Stick to hexadecimal numbers for internal stuff, such as IDs, pointers, bank numbers, etc. Most hexadecimal numbers are typically things that should be replaced by some constant or label eventually. For bit masks, use binary numbers if there's also no constant for them. ``-1`` is preferred over ``$ff`` as a logical "empty" or "false", whereas ``$ff`` is used to terminate data structures.


# Macros

Macros are particularly useful for making data structures more readable. If some block of data is just a bunch ``db`` and/or ``dw`` entries it may not benefit much for a macro, but as soon as there are ways to simplify it, a macro should be welcome. In general, don't hesitate to make a complex macro if it gratly simplfies the way the data that uses it is laid out. Macros are defined in the macros/ directory, in different files depending on what type of macro it is. When creating a macro, capitalize the ``MACRO`` and ``ENDM`` words, and leave everything else lowercase. Macro names are ``snake_case``, though if it's just two words, no underscore is also fine.

When disassembling code and declaring data make sure to have a quick look at the existing macros defined in primarily macros/code/, macros/data/, and macros/text/ for an idea of where to use them. The tcgdisasm script already takes care of using the ``farcall`` and ``bank1call`` macros, but not others.

If a macro is very specific to a feature and you are almost 100% sure that it won't be ever used anywhere else, it's a good idea to put it along with the data structure that uses it (right above it) instead of in the macros/ directory. This makes the macro more immediate to look up. As a more general suggestion, I would advice against creating a macro for a data structure that has not been fully understood. The macro tends to hide its internal structure, which makes it harder to eventaully refractor and also to follow the code that travels through said data structure.


# Refractoring

If some data structure is large enough to warrant its own file inside the src/data/ directory, or a big module of code that comprises all the code corresponding to a given game feature, feel free to move it over to its own separate place. For the most part, it's generally not a good idea to split or move things around too much when there's still a lot of work to do because it makes it more annoying to locate and modify things.
