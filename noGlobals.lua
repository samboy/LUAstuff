-- This code forces all global variables to be declared first
-- Based on https://www.lua.org/pil/14.2.html but different enough to
-- be its own work
function set(name, val)
  rawset(_G, name, val or false)
end
function exists(name)
  if rawget(_G, name) then return true end
  return false
end
throwError = {__newindex = function(self,name) 
                           error("Unknown global " .. name) end,
              __index = function(self,name) 
                           error("Unknown global " .. name) end }
setmetatable(_G,throwError)

-- To use: set("a") a = 1 -- etc.
