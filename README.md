# What is this

This is a series of public domain functions to provide some “glue” to the
Lua language to fill in some gaps it has and make it more useful.

# Why does this exist

With the popularity of Roblox among children, I have decided to finally
become proficient in Lua (I actually have been programming in Lua since
2007, with my ObHack project, but I am finally getting around to
understanding Lua in depth).

Lua reminds me of Forth from the early 1980s: Like Forth, it has a steep
learning curve.  Like Forth, it is an incredibly powerful programming
lanauge in a very compact package.

This is a series of functions to fill in the gaps lacking from the base
Lua package.  For example, table (dictionary/hash/associative array) traversal
is non-deterministic in Lua; I have routines with deterministic traversal.

# What is here

`tableStuff.lua`: This has `tablePrint()`, which will print to standard 
output the entire contents of a table, including all sub-tables.  It includes
infinite loop protection; circular references will not be traversed.  This
also has `sPairs()` which is a (mostly) deterministic version of Lua’s
`pairs()` table traversal routine.

`regexStuff.lua`: While Lua comes with a fairly powerful, if quirky, regular
expression engine (Read: The engine, in the interests of keeping code size
down, is not Perl Regular Expression compatible), the engine does not
include `split`; this includes a simple `rCharSplit()` function to split
a string on single characters (or to split on whitespace using `%s`).

Tests are also included.
