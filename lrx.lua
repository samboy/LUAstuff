#!/usr/bin/env lunacy64
-- This script does regular expression parsing similar to perl -pe, but
-- using Lua5.1/Lunacy regexes instead of Perl regex.  

-- This script processes input from standard input and outputs to standard
-- output.  The script takes a variable number of arguments, but needs
-- to have at least one argument.

-- If the script is given one argument

-- This script has been donated to the public domain in 2022 by Sam Trenholme
-- If, for some reason, a public domain declation is not acceptable, it
-- may be licensed under the following terms:

-- Copyright 2022 Sam Trenholme
-- Permission to use, copy, modify, and/or distribute this software for 
-- any purpose with or without fee is hereby granted.
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
-- WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
-- OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

before = {}
after = {}
index = 1
for a=1,#arg,2 do
  before[index] = arg[a]
  if arg[a + 1] then 
    after[index] = arg[a + 1]
  else
    after[index] = ""
  end
  index = index + 1
end

-- This is code which reads and processes lines from 
-- standard input
l = io.read()
while l do
  for a=1,#before do
    l = string.gsub(l,before[a],after[a])
  end
  print(l)
  l = io.read()
end
