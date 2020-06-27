function sorted_table_keys(t)
  local a = {}
  local b = 1
  for k,_ in pairs(t) do -- pairs() use OK; will sort
    a[b] = k
    b = b + 1
  end
  table.sort(a, function(y,z) return tostring(y) < tostring(z) end)
  return a
end
