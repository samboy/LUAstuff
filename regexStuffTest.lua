#!/usr/bin/env lua
require("regexStuff")
require("tableStuff")
a="a,2,c,life,,12345"
tablePrint(rCharSplit(a,","))
print("")

b="This is a big  test!"
tablePrint(rCharSplit(b,"%s"))

--- rStrSplit
b="1,,2,3,45,Hello there!,6,789"
print("rStrSplit test #1 ---------------------------")
tablePrint(rStrSplit(a))
print("rStrSplit test #2 ---------------------------")
tablePrint(rStrSplit(b))
print("rStrSplit test #3 ---------------------------")
for i,v in ipairs(rStrSplit(a)) do
  print(v,string.len(v))
end
-- In comparison, this will not have a 0 len string
print("---------------------------------------------")
for i,v in ipairs(rCharSplit(a,",")) do
  print(v,string.len(v))
end

