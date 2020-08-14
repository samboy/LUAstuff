The attached patch makes SipHash the string has compression algorithm
for Lua 5.4.0.  While there have been other patches for Lua to
fix the hash collision security issues, this patch has the advantage of
being fairly simple and using strong cryptography.

To apply:

```
tar xvzf lua-5.4.0.tar.gz
patch -p0 < lua-5.4.0-SipHash.patch
```

`lua-5.4.0.tar.gz` is available at lua.org and has the SHA-256 sum:

```
2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333
```

Note that this patch results in lstring.c having two harmless
compile warnings.

SipHash.h uses a fixed key in the patch, which should probably be changed.
There are various ways to change the key, such as running the included
make.SipHash.h.lua script in a *NIX system with `/dev/urandom`.

I have, as an informal benchmark, run my code which uses Lua to generate
an entire static site tracking COVID-19 growth for every single county
in the United States.  This creates multiple huge tables as we hold
in memory all of the calculations done against COVID-19 cases and deaths
for all 4,000+ counties in the US, with a separate sub-table for each day
for each county.  Lua, processing this data, uses 550 megs when compiled
as a 32-bit program and 700-800 megs when compiled as a 64-bit program.

Some results on a 2007 era Core Duo T8100, running a 64-bit binary:

```
SipHash compile			Stock Lua 5.4.0
real    0m23.038s		real    0m22.653s
user    0m22.414s		user    0m22.034s
sys     0m0.619s		sys     0m0.617s

real    0m23.491s		real    0m24.177s
user    0m22.859s		user    0m23.289s
sys     0m0.595s		sys     0m0.598s

real    0m23.375s		real    0m23.262s
user    0m22.803s		user    0m22.693s
sys     0m0.569s		sys     0m0.566s
```

Note that there is about a 20% slowdown when we run the same benchmark
as an i386 binary compiled with GCC 3.2.3 from 2002.  SipHash is
incredibly fast on a modern 64-bit processor because it can run
its core algorithm using only four 64-bit registers.  I would
suspect that there would be less slowdown on a 32-bit ARM or other
RISC architecture because they do not have the register starvation
i386 has.

To replicate this benchmark:

```
git clone https://github.com/Samboy/covid-19-html/
cd covid-19-html
git clone https://github.com/nytimes/covid-19-data/
cp covid-19-data/us-counties.csv data.csv
time lua examine-growth.lua benchmark
```

Despite the size of this dataset, I’m not seeing a performance
difference between using SipHash as a hash compressor vs. using Lua’s
default hash compressor on my 2017 i7-7600U based ThinkPad. [3] SipHash
uses more CPU, yes, but it’s incredibly efficient.

In terms of collisions, SipHash is about as good as a random oracle
(i.e. We make a completely random hash from a given input string) with
a given output width; it’s cryptographically strong.

