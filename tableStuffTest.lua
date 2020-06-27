#!/usr/bin/env lua
require("tableStuff")
someTable = {foo = "bar", bar = "hello" , aaa = "zzz", aab = "xyz" }
for key, value in sPairs(someTable) do print(key, value) end
