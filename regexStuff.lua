----------------------- rCharSplit() -----------------------
-- Input: A string we will split, a character (class) we split on
-- Output: An array (numeric indexed table) with the split string
-- Should the character we split on not be in the string to split, 
-- we will have a one-element array with the input string
--
-- Note: Should the splitter regex be a single character, things will 
-- split as expected, but 0-length strings are converted in to a 
-- one-character long space (" ") string.
--
-- Example usage:
-- a = "1,2,3" t = rSplit(a,",") for k,v in pairs(t) do print(k,v) end
function rCharSplit(i, c)
  local out = {}
  local n = 1
  local q

  -- For one-character separators, like ",", we allow empty fields
  if string.len(tostring(c)) == 1 then
    i = string.gsub(i, tostring(c) .. tostring(c),
                    tostring(c) .. " " .. tostring(c))
  end

  for q in string.gmatch(i, "[^" .. tostring(c) .. "]+") do
    out[n] = q
    n = n + 1
  end
  return out
end 

----------------------- rStrSplit() -----------------------
-- This does a simple split for a given string
-- Input: string, split character 
--
function rStrSplit(s, splitOn)
  if not splitOn then splitOn = "," end
  local place = 1
  local out = {} 
  local last = 1
  while place do
    place = string.find(s, splitOn, place, true) 
    if place then
      table.insert(out,string.sub(s, last, place - 1))
      place = place + 1
      last = place
    end
  end 
  table.insert(out,string.sub(s, last, -1))
  return out
end
