----------------------- sortedTableKeys() -----------------------
--  Input: A table
--  Output: An array (i.e. table with only numeric keys, starting at 1
--          and counting upwards without any gaps in the numeric sequence)
--          with the input table's keys lexically (alphabetically) sorted
--
--  I created this routine when I wanted to make a version of pairs()
--  guaranteed to traverse a table in a (mostly) deterministic fashion.

function sortedTableKeys(t)
  local a = {}
  local b = 1
  for k,_ in pairs(t) do -- pairs() use OK; will sort
    a[b] = k
    b = b + 1
  end
  table.sort(a, function(y,z) return tostring(y) < tostring(z) end)
  return a
end

----------------------- tablePrint() -----------------------
-- Print out a table on standard output.  Does not traverse sub-tables
function tablePrint(t)
  for k,v in pairs(t) do
    print(k, v)
  end
end

----------------------- _tableIter() -----------------------
-- This is a private function that is used so we can have a sorted
-- form of pairs(table)
function _tableIter(t, _)
  local k = t[t.i]
  local v
  if k then
    v = t.t[k]
  else
    return nil
  end
  t.i = t.i + 1
  if v then
    return k, v
  end
end

----------------------- sPairs(t) -----------------------
-- Input: Table
-- Ouput: Iterator used by "for" which will go through the keys in
-- a table in a sorted order, e.g. 
-- someTable = {foo = "bar", bar = "hello" , aaa = "zzz", aab = "xyz" }
-- for key, value in sPairs(someTable) do print(key, value) end
function sPairs(t)
  local tt = sortedTableKeys(t)
  tt.t = t
  tt.i = 1
  return _tableIter, tt, 0
end
