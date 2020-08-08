The attached patch makes SipHash the string has compression algorithm
for Lua 5.1.5 [1].  While there have been other patches for Lua 5.1 to
fix the hash collision security issues, this patch has the advantage of
being fairly simple and using strong cryptography which did not exist
for hash compression algorithms at the time.

SipHash.h uses a fixed key in the patch, which should probably be changed.
There are various ways to change the key, such as running the included
make.SipHash.h.lua script in a *NIX system with `/dev/urandom`.

I have, as an informal benchmark, run my code which uses Lua to generate
an entire static site tracking COVID-19 growth for every single county
in the United States. [2] This creates multiple huge tables as we hold
in memory all of the calculations done against COVID-19 cases and deaths
all 4,000+ counties in the US, with a separate sub-table for each day
for each county.  Lua, processing this data, uses 550 megs when compiled
as a 32-bit program and 700-800 megs when compiled as a 64-bit program.

Despite the size of this dataset, I’m not seeing a performance
difference between using SipHash as a hash compressor vs. using Lua’s
default hash compressor on my 2017 i7-7600U based ThinkPad. [3] SipHash
uses more CPU, yes, but it’s incredibly efficient.

In terms of collisions, SipHash is about as good as a random oracle
(i.e. We make a completely random hash from a given input string) with
a given output width; it’s cryptographically strong.

[1] There is a lot of great stuff in Lua 5.4, but there is a lot to
    be said about Lua 5.1, including LuaJIT, luau (Roblox), GopherLua,
    and LUA_GLOBALSINDEX (Yes, _ENV is great, but LUA_GLOBALSINDEX can be
    pretty convenient).  Mainly LuaJIT, so I can tell MaraDNS users we can
    move over to LuaJIT if Lua performance ever becomes a bottleneck.

[2] https://github.com/samboy/covid-19-html or https://samiam.org/COVID-19
    to see the generated site.  On a 2017 era Core i7-7600U 15W Laptop CPU,
    Lua makes the entire website with well over 4,000 pages and GNU Plot
    commands in under 90 seconds (GnuPlot makes the actual graphs).  On an
    old 2007-era Core 2 Duo T8100, the Lua part of the website takes about
    2 minutes, then we spend about 5 minutes having GNUplot draw the graphs
    then 25 minutes making the main PNG files smaller before uploading it.

[2] I will see if we’re getting performance hits when using a 2007
    era Core Duo or when Lua is compiled as a 32-bit program.

