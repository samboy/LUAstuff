#!/usr/bin/env lua

-- Simple calculator for Lua 5.1
while true do
  io.write("] ")
  local l = io.read()
  local z, y = pcall(loadstring(l))
  if z then 
    if y ~= nil then
      print(y)
    end
  else
    local a, b = pcall(loadstring("return " .. l))
    if a then print(b) end
  end
end
