#!/usr/bin/env lua

-- Print a common log table suitable for a coffee mug

function l(a) return math.log(a)/math.log(10) end
function m(a) return string.format("%.4f",l(a)):gsub("^0","\t") end
local z = ""
for a=1,9 do
  z = z .. "\t" .. tostring(a)
end
print(z) 
for a=0,.9,.1 do
  print(tostring(a):gsub("^0","")..m(1+a)..m(2+a)..m(3+a)..m(4+a)..
        m(5+a)..m(6+a)..m(7+a)..m(8+a)..m(9+a))
end

