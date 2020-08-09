#!/usr/bin/env lua
io.input("/dev/urandom")
print "#include <stdint.h>"
for i = 1,2 do
  s = "uint64_t sipKey" .. i .. " = 0x"
  for k = 1,8 do
    c = io.read(1)
    s = s .. string.format("%02x",string.byte(c,1,1))
  end
  s = s .. "ULL;"
  print(s)
end
