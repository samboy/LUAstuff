# blackCastle, a public domain JSON parser

blackCastle is a public domain JSON parser.

## The name

This is called "Black Castle" because Douglas Crockford's (same guy
who invented JSON) old game "Galahad and the Holy Grail" had a very
difficult puzzle where a secret passage was hidden in the black castle;
the passage was so difficult to find, I had to run the program through
a 6502 monitor to find it.

A 1984 review of "Galahad and the Holy Grail" had the same complaint:
In "The book of Atari Software 1984", the reviewer could not find this
secret passage until Atari sent them a map and hint sheet.

To Douglas Crockford's credit, the 1985 Antic version of the game has
an arrow in the black castle pointing to the secret passage.

## Usage

```lua
require("blackCastle")
foo = blackCastle("file.json")
```

## Bugs

* This only parses JSON input 
* This parser can not handle backslashes in strings
* This parser assumes that strings are binary blobs w/o the `"` or `\`
  characters
* This does not generate JSON
* This only reads JSON from a file
* This uses tonumber for numeric generation 
* This parser doesn't care where or one puts (or doesn't put) a `,` or `:`
* This parser makes null in JSON the string "--NULL--"
* This parser is a quick and dirty hack.

## Useful non-JSON extensions

* The parser allows comments (with `#`).  At least one whitespace character
  should be before the `#`.
* The parser allows bare words for object keys.  A bare word must start
  with an ASCII letter, and can have letters, numbers, and `_` in it.
* The parser allows a comma after the last item in a list of array or
  object members.

## To do

In order to handle back slashes without adding an entire Unicode library,
the plan is to transfer the strings from the JSON blackCastle receives
in to Lua as-is:  Backslashes will be retained in the string, and to
handle stuff like `\u221e` without an entire Unicode library, the plan
is to just pass `\u221e` as is to Lua; likewise, if we get `∞` (the
infinity symbol, i.e. 221e), we will pass it to Lua as the UTF-8
characters `E2 88 9E`.

Update the library to allow the caller determine that JSON `null`
becomes.  This would allow us to handle null properly (since `nil` is
*not* the same as JSON `null`).
