#!/usr/bin/env lua

-- Print a common log table suitable for a coffee mug

local live105 = false
if #arg >= 1 then
  if arg[1] == '-105' then live105 = true end
end

local function l(a) return math.log(a)/math.log(10) end
local function m(a) return string.format("%.4f",l(a)):gsub("^0","\t") end
local z = ""
for a=1,9 do
  z = z .. "\t" .. tostring(a)
  if live105 and a == 1 then
    z = z .. "\t1.05"
  end
end
print(z) 
for a=0,.9,.1 do
  local line = tostring(a):gsub("^0","")..m(1+a)
  if live105 then
    line = line .. m(1.05 + a)
  end
  line = line .. m(2+a)..m(3+a)..m(4+a)
  line = line .. m(5+a)..m(6+a)..m(7+a)..m(8+a)..m(9+a)
  print(line)
end

