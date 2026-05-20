#!/bin/sh
_rem=--[=[
# Make FOIL tests where we expand in to Quadratics
# If you want nice Unicode squared instead of x^2 notation do this
# ./FOIL.lua | perl -pe 's/\^2/²/g'

LUNACY=""
if command -v lunacy64 >/dev/null 2>&1 ; then
  LUNACY=lunacy64
elif command -v lua5.1 >/dev/null 2>&1 ; then
  LUNACY=lua5.1
elif command -v lua-5.1 >/dev/null 2>&1 ; then
  LUNACY=lua-5.1
elif command -v lunacy >/dev/null 2>&1 ; then
  LUNACY=lunacy
elif command -v luajit >/dev/null 2>&1 ; then
  LUNACY=luajit # I assume luajit will remain frozen at Lua 5.1
fi
if [ -z "$LUNACY" ] ; then
  echo Please install Lunacy or Lua 5.1
  echo https://github.com/samboy/lunacy
  exit 1
fi

exec $LUNACY $0 "$@"

# ]=]1
-- This script is written in Lua 5.1

-- This script has been donated to the public domain in 2026 by Sam Trenholme
-- If, for some reason, a public domain declation is not acceptable, it
-- may be licensed under the following terms:

-- Copyright 2026 Sam Trenholme
-- Permission to use, copy, modify, and/or distribute this software for
-- any purpose with or without fee is hereby granted.
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
-- WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
-- OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-- Utility functions --
-- Since Lunacy doesn't have split(), we make
-- it ourselves.  Like Perl’s split(), this can
-- split on regular expressions
-- Input is string, regex, output is an array with the string parts
function split(s, splitOn)
  if not splitOn then splitOn = "," end
  local place = true
  local out = {}
  local mark
  local last = 1
  while place do
    place, mark = string.find(s, splitOn, last, false)
    if place then
      table.insert(out,string.sub(s, last, place - 1))
      last = mark + 1
    end
  end
  table.insert(out,string.sub(s, last, -1))
  return out
end

-- We need to go through tables in sorted order sometimes
-- Like pairs() but sorted
-- This assumes all keys are of the same type
function sPairs(inputTable,sFunc)
  if not sFunc then
    sFunc = function(a, b)
      local ta = type(a)
      local tb = type(b)
      if(ta == tb)
        then return a < b
      end
      return ta < tb
    end
  end
  local keyList = {}
  local index = 1
  for k,_ in pairs(inputTable) do
    table.insert(keyList,k)
  end
  table.sort(keyList,sFunc)
  return function()
    rvalue = keyList[index]
    index = index + 1
    return rvalue, inputTable[rvalue]
  end
end

gSeed = tostring(os.time())
gCSV = false
gLo = 1
gHi = 9
gXnum = false
gNoNeg = false
if #arg >= 1 then
  gSeed = arg[1]
else
  print("Seed: " .. gSeed)
end
if gSeed:match("^[Hh%-%?]") then
  print("FOIL Version 2026-05-19")
  print(
   "Usage: FOIL {seed} {CSV} {low} {high} {allow non-1 x} {forbid negatives}") 
  os.exit(0)
end
if #arg >= 2 then
  if arg[2]:match("[Ff]") then 
    gCSV = false
  else 
    gCSV = true
  end
end
if #arg >= 3 then
  gLo = tonumber(arg[3])
end
if #arg >= 4 then
  gHi = tonumber(arg[4])
end
if #arg >= 5 then
  if arg[5]:match("[Ff]") then 
    gXnum = false
  else 
    gXnum = true
  end
end
if #arg >= 6 then
  if arg[6]:match("[Ff]") then 
    gNoNeg = false
  else 
    gNoNeg = true
  end
end

if not rg32 then 
  print("Warning: rg32 (RadioGatún[32]) RNG not present")
  rg32 = math -- Very crude polyfill, only Lunacy uses rg32 for math.random()
  gSeed = tonumber(gSeed) -- Other RNGs don’t accept strings
end 

rg32.randomseed(gSeed)

function doFOIL(min, max, allowXmultipliers, forbidNegative)
  function showSign(a)
    if a < 0 then return "-"
    elseif a == 0 then return ""
    elseif a > 0 then return "+" end
  end
  function showMultTerm(a, power) 
    function showPower(power)
      if power == 2 then return "x^2" 
      elseif power == 1 then return "x"
      else return "" end
    end
    if a==0 then return ""
    elseif math.abs(a)==1 and power > 0 then return showPower(power) end
    return tostring(math.abs(a)) .. showPower(power) 
  end
  function showTerm(a, power, hideSign) 
    local out = ""
    if not hideSign then
      out = " " .. showSign(a) .. " " .. showMultTerm(a,power) .. " "
    elseif a > 0 then
      out = " " .. showMultTerm(a,power) .. " "
    else
      out = " -" .. showMultTerm(a,power) .. " "
    end
    out = out:gsub("%s+"," ")
    return out
  end

  if not min then min = 1 end
  if not max then max = 9 end
  local x1 = 1
  local x2 = 1
  if allowXmultipliers then
    x1 = rg32.random(min,max)
    if not forbidNegative and rg32.random(1,2)==1 then x1 = -x1 end
    x2 = rg32.random(min,max)
    if not forbidNegative and rg32.random(1,2)==1 then x2 = -x2 end
  end
  local int1 = rg32.random(min,max)
  if not forbidNegative and rg32.random(1,2)==1 then int1 = -int1 end
  local int2 = rg32.random(min,max)
  if not forbidNegative and rg32.random(1,2)==1 then int2 = -int2 end

  -- answer2 * x^2 + answer1 * x + answer0
  local answer2 = x1 * x2
  local answer1 = x1 * int2 + x2 * int1
  local answer0 = int1 * int2

  -- Also, partial solution with FOIL
  local F = x1 * x2
  local O = x1 * int2
  local I = x2 * int1
  local L = int1 * int2
  
  local problem = "(" .. showTerm(x1,1,1) .. showTerm(int1,0) .. ")" ..
            "(" .. showTerm(x2,1,1) .. showTerm(int2,0) .. ")"
  problem = problem:gsub("%s+"," ")
  problem = problem:gsub("%(%s+","(")
  problem = problem:gsub("%s+%)",")")
  local FOIL = showTerm(F,2,true) .. showTerm(O,1) .. 
               showTerm(I,1) .. showTerm(L,0)
  FOIL = FOIL:gsub("%s+"," ")
  FOIL = FOIL:gsub("^%s+","")
  FOIL = FOIL:gsub("%s+$","")
  local solution = showMultTerm(answer2,2) .. " " .. showSign(answer1) .. " "
             .. showMultTerm(answer1,1) .. " " .. showSign(answer0) .. " " ..
             showMultTerm(answer0,0)
  solution = solution:gsub("%s+"," ")
  return problem, FOIL, solution
end

function convertOut(b,c,d) 
  local out = b
  for a=1,20-b:len() do out = out .. " " end
  out = out .. c
  for a=1,30-c:len() do out = out .. " " end
  out = out .. d
  return out
end

for a=1,10 do  
  local b,c,d = doFOIL(gLo,gHi,gXnum,gNoNeg)
  if gCSV then
    print('"' .. b .. '","' .. c .. '","' .. d .. '"')
  else
    print(convertOut(b,c,d))
  end
end
