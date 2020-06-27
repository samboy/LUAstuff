----------------------- rSplit() -----------------------
-- Input: A string we will split, a character (class) we split on
-- Output: An array (numeric indexed table) with the split string
-- Should the character we split on not be in the string to split, 
-- we will have a one-element array with the input string
-- Example usage:
-- a = "1,2,3" t = rSplit(a,",") for k,v in pairs(t) do print(k,v) end
function rSplit(i, c)
  local out = {}
  local n = 1
  local q
  for q in string.gmatch(i, "[^" .. tostring(c) .. "]") do
    out[n] = q
    n = n + 1
  end
  return out
end 
