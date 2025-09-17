#!/usr/bin/env lua-5.1

-- Donated to the public domain by Sam Trenholme 2025

function findPrimes(a) 
  local out = {2}
  for b=3,a do
    isComposite = false
    c = 1
    while out[c] * out[c] <= b do
      if(b / out[c] == 
         math.floor(b / out[c])) then
        isComposite = true
        break
      end 
      c = c + 1
    end 
    if not isComposite then 
      out[#out + 1] = b 
    end
  end
  return out
end

function listArray(a)
  local out = ""
  for b=1,#a do
    out = out .. tostring(a[b]) .. " "
  end
  return out
end

function factor(a)
  local out={}
  local primes=findPrimes(a^.5 + 1)
  for b = 1,#primes do
    while(a / primes[b] == 
          math.floor(a/primes[b])) do
      out[#out + 1] = primes[b]
      a = a / primes[b]
    end
  end
  if #out == 0 then
    out={a}
  end
  return out
end

function GCD(a,b)
  local fa = factor(a)
  local fb = factor(b)
  local out = 1
  b = 1
  for a=1,#fa do
    if fb[b] and fa[a] == fb[b] then
      out = out * fa[a]
      b = b + 1
    end 
    while fb[b] and fb[b] < fa[a] do
      b = b + 1
    end
  end 
  return out
end

if not arg[1] then arg[1] = 1 end
if not arg[2] then arg[2] = 1 end
print(GCD(arg[1],arg[2]))
