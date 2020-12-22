#!/usr/bin/env lua

-- Print a common log table suitable for a coffee mug

local function l(a) return math.log(a)/math.log(10) end
local function m4(a) return string.format("%.4f",l(a)):gsub("^0","\t") end
local function m5(a) return string.format("%.5f",l(a)):gsub("^0","\t") end
local m = m4

local live105 = false
local live101 = false
local increment = .1
if #arg >= 1 then
  local n = tonumber(arg[1])
  if arg[1] == '-105' then live105 = true end
  if arg[1] == '-101' then live101 = true increment = 0.02 m = m5 end
  if n and n > 0 and n < 1 then increment = n end
end

local z = ""
for a=1,9 do
  z = z .. "\t" .. tostring(a)
  if live105 and a == 1 then
    z = z .. "\t1.05"
  end
  if live101 and a == 1 then
    z = z .. "\t1.01"
  end
  if live101 and a == 2 then
    z = z .. "\t2.01"
  end
end
print(z) 
local a = 0
local b = 0
while a < 1 do
  local line = tostring(a):gsub("^0","")..m(1+a)
  if live105 then line = line .. m(1.05 + a) end
  if live101 then line = line .. m(1.01 + a) end
  line = line .. m(2+a)
  if live101 then line = line .. m(2.01 + a) end
  line = line .. m(3+a) .. m(4+a)
  line = line .. m(5+a) .. m(6+a) .. m(7+a) .. m(8+a) .. m(9+a)
  print(line)
  b = b + 1
  a = increment * b
end

