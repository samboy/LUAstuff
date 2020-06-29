#!/usr/bin/env lua-5.1

-- If you have access to the Lua C API, or if you are using a version
-- of Lua more recent than 5.1, there are faster ways to run RadioGatun[32]
-- in Lua.  The best way to run it is to write a C function suite which
-- runs RadioGatun[32] as compiled C code which Lua then can access.  This
-- is how both ObHack and Lunacy run RadioGatun[32]

-- Lua 5.2 adds native bitwise operations, which can run a lot faster 
-- than this does.  This is for Roblox users, Lightroom Classic users,
-- or anyone else stuck at Lua 5.1.

-- This is an implementation of RadioGatun[32] for pure Lua 5.1
-- Lua suffers from an "Internet Explorer 6" problem.  While Lua
-- 5.3 has native bitwise operations, Lua 5.1 does *not*.  However,
-- there are multiple places where "Lua scripting" means Lua 5.1
-- scripting, even though Lua 5.3 has been out for over five years.

-- 4x4 xor table
xorT = {{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
        { 1, 0, 3, 2, 5, 4, 7, 6, 9, 8, 11, 10, 13, 12, 15, 14 },
        { 2, 3, 0, 1, 6, 7, 4, 5, 10, 11, 8, 9, 14, 15, 12, 13 },
        { 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12 },
        { 4, 5, 6, 7, 0, 1, 2, 3, 12, 13, 14, 15, 8, 9, 10, 11 },
        { 5, 4, 7, 6, 1, 0, 3, 2, 13, 12, 15, 14, 9, 8, 11, 10 },
        { 6, 7, 4, 5, 2, 3, 0, 1, 14, 15, 12, 13, 10, 11, 8, 9 },
        { 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8 },
        { 8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 7 },
        { 9, 8, 11, 10, 13, 12, 15, 14, 1, 0, 3, 2, 5, 4, 7, 6 },
        { 10, 11, 8, 9, 14, 15, 12, 13, 2, 3, 0, 1, 6, 7, 4, 5 },
        { 11, 10, 9, 8, 15, 14, 13, 12, 3, 2, 1, 0, 7, 6, 5, 4 },
        { 12, 13, 14, 15, 8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3 },
        { 13, 12, 15, 14, 9, 8, 11, 10, 5, 4, 7, 6, 1, 0, 3, 2 },
        { 14, 15, 12, 13, 10, 11, 8, 9, 6, 7, 4, 5, 2, 3, 0, 1 },
        { 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 }}

-- 4x4 or-not table (a|~b)
orNotT = {{ 15, 14, 13, 12, 11, 10,  9,  8,  7,  6,  5,  4,  3,  2,  1,  0 },
          { 15, 15, 13, 13, 11, 11,  9,  9,  7,  7,  5,  5,  3,  3,  1,  1 },
          { 15, 14, 15, 14, 11, 10, 11, 10,  7,  6,  7,  6,  3,  2,  3,  2 },
          { 15, 15, 15, 15, 11, 11, 11, 11,  7,  7,  7,  7,  3,  3,  3,  3 },
          { 15, 14, 13, 12, 15, 14, 13, 12,  7,  6,  5,  4,  7,  6,  5,  4 },
          { 15, 15, 13, 13, 15, 15, 13, 13,  7,  7,  5,  5,  7,  7,  5,  5 },
          { 15, 14, 15, 14, 15, 14, 15, 14,  7,  6,  7,  6,  7,  6,  7,  6 },
          { 15, 15, 15, 15, 15, 15, 15, 15,  7,  7,  7,  7,  7,  7,  7,  7 },
          { 15, 14, 13, 12, 11, 10,  9,  8, 15, 14, 13, 12, 11, 10,  9,  8 },
          { 15, 15, 13, 13, 11, 11,  9,  9, 15, 15, 13, 13, 11, 11,  9,  9 },
          { 15, 14, 15, 14, 11, 10, 11, 10, 15, 14, 15, 14, 11, 10, 11, 10 },
          { 15, 15, 15, 15, 11, 11, 11, 11, 15, 15, 15, 15, 11, 11, 11, 11 },
          { 15, 14, 13, 12, 15, 14, 13, 12, 15, 14, 13, 12, 15, 14, 13, 12 },
          { 15, 15, 13, 13, 15, 15, 13, 13, 15, 15, 13, 13, 15, 15, 13, 13 },
          { 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14 },
          { 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 }}

-- We do not use these for RG32, but for people who want "and" and "or"...
andT = {{  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },
        {  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1 },
        {  0,  0,  2,  2,  0,  0,  2,  2,  0,  0,  2,  2,  0,  0,  2,  2 },
        {  0,  1,  2,  3,  0,  1,  2,  3,  0,  1,  2,  3,  0,  1,  2,  3 },
        {  0,  0,  0,  0,  4,  4,  4,  4,  0,  0,  0,  0,  4,  4,  4,  4 },
        {  0,  1,  0,  1,  4,  5,  4,  5,  0,  1,  0,  1,  4,  5,  4,  5 },
        {  0,  0,  2,  2,  4,  4,  6,  6,  0,  0,  2,  2,  4,  4,  6,  6 },
        {  0,  1,  2,  3,  4,  5,  6,  7,  0,  1,  2,  3,  4,  5,  6,  7 },
        {  0,  0,  0,  0,  0,  0,  0,  0,  8,  8,  8,  8,  8,  8,  8,  8 },
        {  0,  1,  0,  1,  0,  1,  0,  1,  8,  9,  8,  9,  8,  9,  8,  9 },
        {  0,  0,  2,  2,  0,  0,  2,  2,  8,  8, 10, 10,  8,  8, 10, 10 },
        {  0,  1,  2,  3,  0,  1,  2,  3,  8,  9, 10, 11,  8,  9, 10, 11 },
        {  0,  0,  0,  0,  4,  4,  4,  4,  8,  8,  8,  8, 12, 12, 12, 12 },
        {  0,  1,  0,  1,  4,  5,  4,  5,  8,  9,  8,  9, 12, 13, 12, 13 },
        {  0,  0,  2,  2,  4,  4,  6,  6,  8,  8, 10, 10, 12, 12, 14, 14 },
        {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 }}

orT = {{  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 },
       {  1,  1,  3,  3,  5,  5,  7,  7,  9,  9, 11, 11, 13, 13, 15, 15 },
       {  2,  3,  2,  3,  6,  7,  6,  7, 10, 11, 10, 11, 14, 15, 14, 15 },
       {  3,  3,  3,  3,  7,  7,  7,  7, 11, 11, 11, 11, 15, 15, 15, 15 },
       {  4,  5,  6,  7,  4,  5,  6,  7, 12, 13, 14, 15, 12, 13, 14, 15 },
       {  5,  5,  7,  7,  5,  5,  7,  7, 13, 13, 15, 15, 13, 13, 15, 15 },
       {  6,  7,  6,  7,  6,  7,  6,  7, 14, 15, 14, 15, 14, 15, 14, 15 },
       {  7,  7,  7,  7,  7,  7,  7,  7, 15, 15, 15, 15, 15, 15, 15, 15 },
       {  8,  9, 10, 11, 12, 13, 14, 15,  8,  9, 10, 11, 12, 13, 14, 15 },
       {  9,  9, 11, 11, 13, 13, 15, 15,  9,  9, 11, 11, 13, 13, 15, 15 },
       { 10, 11, 10, 11, 14, 15, 14, 15, 10, 11, 10, 11, 14, 15, 14, 15 },
       { 11, 11, 11, 11, 15, 15, 15, 15, 11, 11, 11, 11, 15, 15, 15, 15 },
       { 12, 13, 14, 15, 12, 13, 14, 15, 12, 13, 14, 15, 12, 13, 14, 15 },
       { 13, 13, 15, 15, 13, 13, 15, 15, 13, 13, 15, 15, 13, 13, 15, 15 },
       { 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15 },
       { 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 }}

-- Like Javascript, we only run bitwise operations across 32 bits
-- Here, tbl is one of the tables above
function bitwise(a, b, tbl) 
  a = math.floor(a)
  a = a % 4294967296
  b = math.floor(b)
  b = b % 4294967296
  local out = 0
  for z = 0, 7 do
    local ap = (a % 16) + 1
    local bp = (b % 16) + 1
    out = out + (tbl[ap][bp] * (16 ^ z))
    a = math.floor(a/16)
    b = math.floor(b/16)
  end
  return out
end

-- Circular rotate right n bits
function ror(a, bits) 
  bits = bits % 32
  a = math.floor(a)
  a = a % 4294967296
  local b = a * (2 ^ (32 - bits))
  a = math.floor(a / (2 ^ bits))
  b = b % 4294967296
  return a + b
end

function xor(a,b) return bitwise(a,b,xorT) end
function orNot(a,b) return bitwise(a,b,orNotT) end

-- Note that belt and mill are 1-indexed here
function beltMill(belt, mill) 

  -- Mill to belt feedforward
  for z = 0, 11 do
    offset = z + ((z % 3) * 13) + 1
    belt[offset] = xor(belt[offset],mill[z + 2])
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
    num = xor(num,orNot(mill[view + 1],mill[viewPrime + 1]))
    num = ror(num,rotate)
    millPrime[z + 1] = num
  end
  for z = 0, 18 do
    local view = (z + 1) % 19
    local viewPrime = (z + 4) % 19
    mill[z + 1] = xor(millPrime[z + 1],
	xor(millPrime[view + 1],millPrime[viewPrime + 1]))
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
     mill[14 + z] = xor(belt[(z * 13) + 1],mill[14 + z])
  end

  -- Iota is xor by 1, which we can do more quickly as follows
  if(mill[1] % 2 == 0) then 
    mill[1] = mill[1] + 1 
  else 
    mill[1] = mill[1] - 1 
  end
end

-- Debug function to show the belt and mill
function showBeltMill(belt, mill)
  for z = 1, 13 do
    print(string.format("%2d %08x %08x %08x %08x",z,mill[z],belt[z],
                        belt[z + 13],belt[z + 26]))
  end
  for z = 14, 19 do
    print(string.format("%2d %08x",z,mill[z]))
  end
end

function initBeltMill()
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

-- Example debug usage
belt, mill = initBeltMill()
-- We'll just have a 32-bit seed
-- This is the subset of RadioGatun[32] where the string is
-- precisely four bytes long
seed = 0x34333231
belt[1] = seed
mill[17] = seed
belt[14] = 1
mill[18] = 1
-- Blank rounds
for z = 1, 18 do
  beltMill(belt,mill)
end
-- Now, make some numbers from that
function makeHex(i) 
  local out = ""
  for z = 1, 4 do
    out = out .. string.format("%02x",i % 256)
    i = math.floor(i / 256)
  end
  return out
end
out = ""
for z = 1, 4 do
  out = out .. makeHex(mill[2]) .. makeHex(mill[3])
  beltMill(belt, mill)
end
print(out) -- RadioGatun[32] of the string "1234"
-- CODE HERE: Real input mapper
 
