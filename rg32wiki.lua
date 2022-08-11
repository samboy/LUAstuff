-- Placed in the public domain 2020, 2022 Sam Trenholme

-- This is a version of RadioGatun[32] (RG32) which uses bit32.
-- Wikipedia has bit32 in an external library
if not bit32 then
  bit32 = require("bit32")
end

local p = {}

-- Note that belt and mill are 1-indexed here
local function beltMill(belt, mill)

  -- Mill to belt feedforward
  for z = 0, 11 do
    offset = z + ((z % 3) * 13) + 1
    belt[offset] = bit32.bxor(belt[offset],mill[z + 2])
  end

  -- Mill core
  local rotate = 0
  local millPrime = {}
  for z = 0, 18 do
    rotate = rotate + z
    local view = (z * 7) % 19
    local num = mill[view + 1]
    view = (view + 1) % 19
    local viewPrime = (view + 1) % 19
    num = bit32.bxor(num,bit32.bor(mill[view + 1],
                     bit32.bnot(mill[viewPrime + 1])))
    num = bit32.rrotate(num,rotate)
    millPrime[z + 1] = num
  end
  for z = 0, 18 do
    local view = (z + 1) % 19
    local viewPrime = (z + 4) % 19
    mill[z + 1] = bit32.bxor(millPrime[z + 1],
        millPrime[view + 1],millPrime[viewPrime + 1])
  end

  -- Belt rotate
  for z = 39, 1, -1 do
     belt[z + 1] = belt[z]
  end
  for z = 0, 2 do
     belt[(z * 13) + 1] = belt[((z + 1) * 13) + 1]
  end

  -- Belt to mill
  for z = 0, 2 do
     mill[14 + z] = bit32.bxor(belt[(z * 13) + 1],mill[14 + z])
  end

  mill[1] = bit32.bxor(mill[1],1)
end

-- Debug function to show the belt and mill
local function showBeltMill(belt, mill)
  for z = 1, 13 do
    print(string.format("%2d %08x %08x %08x %08x",z,mill[z],belt[z],
                        belt[z + 13],belt[z + 26]))
  end
  for z = 14, 19 do
    print(string.format("%2d %08x",z,mill[z]))
  end
end

local function initBeltMill()
  local belt = {}
  local mill = {}
  for z = 1, 40 do
    belt[z] = 0
  end
  for z = 1, 19 do
    mill[z] = 0
  end
  return belt, mill
end

-- Output strings which are hex numbers in the same endian order
-- as RadioGatun[32] test vectors, given a float
local function makeLittleEndianHex(i)
  local out = ""
  for z = 1, 4 do
    i = math.floor(i)
    out = out .. string.format("%02X",i % 256)
    i = i / 256
  end
  return out
end

-- Output a 256-bit digest string, given a radiogatun state.  Affects belt and
-- mill, returns string
local function makeRG32sum(belt, mill)
  local out = ""
  for z = 1, 4 do
    out = out .. makeLittleEndianHex(mill[2]) .. makeLittleEndianHex(mill[3])
    beltMill(belt, mill)
  end
  return out
end

-- RadioGatun input map; given string return belt, mill, and "phase"
local function RG32inputMap(i)
  local belt, mill
  belt, mill = initBeltMill()
  local phase = 0;
  for a = 1, string.len(i) do
    local c = string.byte(i, a)
    local b
    c = c % 256
    c = c * (2 ^ (8 * (phase % 4)))
    b = math.floor(phase / 4) % 3
    belt[(13 * b) + 1] = bit32.bxor(belt[(13 * b) + 1],c)
    mill[17 + b] = bit32.bxor(mill[17 + b],c)
    phase = phase + 1
    if phase % 12 == 0 then
      beltMill(belt, mill)
    end
  end

  -- Padding byte
  local b = math.floor(phase / 4) % 3
  local c = 2 ^ (8 * (phase % 4))
  belt[(13 * b) + 1] = bit32.bxor(belt[(13 * b) + 1],c)
  mill[17 + b] = bit32.bxor(mill[17 + b],c)

  -- Blank rounds
  for z = 1, 18 do
    beltMill(belt,mill)
  end
  return belt, mill
end

function rg32sum(i)
  local belt, mill = RG32inputMap(i)
  -- print(lunacyVerifyVector(i)) -- DEBUG
  return makeRG32sum(belt,mill)
end

-- We allow Background color to be set as per the Wikipedia page on rg32
function p.rg32(frame)
  local input = "1234"
  if mw then
    local args = frame.args
    local pargs = frame:getParent().args
  else
    args = {}
    args[1] = frame
  end
  if args[1] then
    input = tostring(args[1])
  elseif pargs[1] then
    input = tostring(pargs[1])
  end
  local rginput
  rginput = input:gsub("{{Background color|#%w+|(%w+)}}","%1")
  rginput = rginput:gsub("<[^>]+>","") -- Remove HTML tags
  local sum = rg32sum(rginput)
  return(' RadioGatun[32]("' .. input .. '") =\n ' .. sum)
end

-- This script is a standalone Lua script outside of the Wikipedia
if not mw then
  if arg and arg[1] then
    print(p.rg32(arg[1]))
  else
    print(p.rg32(
'The quick brown fox jumps over the lazy {{Background color|#87CEEB|d}}og'))
  end
end

return p