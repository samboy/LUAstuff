-- Lua 5.1/5.3
-- If there is a PIN pad where the entered numbers are visibly worn out
-- (so the robber knows which digits the PIN pad has), and the PIN is
-- 4 digits long (a reasonable assumption for the robber to make), how
-- many unique digits are the most secure.
--
-- It’s better to have three than four digits in the resulting PIN

-- Here, we assume the digits in the PIN are (1,2,3,4) or (1,2,3) or (1,2)
-- or just (1).  The problem is the same for whatever the actual PIN digits
-- are in any number system of base 4 or higher.

-- Credit: https://idiomdrottning.org/notice/A2nOhYqxMMclHtK6xk

uniquecount = {}
combo = {}
for a=1,4 do
  for b=1,4 do
    for c=1,4 do
      for d=1,4 do
        string = ""
        high = 1
        unique = 0
	if a > high then high = a end
	if b > high then high = b end
	if c > high then high = c end
	if d > high then high = d end
	seen = {}
	seen[a] = true 
	seen[b] = true
	seen[c] = true
	seen[d] = true
	for k,v in pairs(seen) do
	  unique = unique + 1
	end
        if high <= unique then
	  string = tostring(a) .. tostring(b) .. tostring(c) .. tostring(d)
	  combo[string] = unique
	  if uniquecount[unique] then
	    uniquecount[unique] = uniquecount[unique] + 1
	  else
	    uniquecount[unique] = 1
	  end
        end
      end
    end
  end
end

for k,v in pairs(uniquecount) do print(k,v) end
print("")
for k,v in pairs(combo) do print(k,v) end

