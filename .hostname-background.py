#!/usr/bin/env python3
#
# Sets random variation of provided RGB triple based on hostname,
# to make different hosts a bit more distinguishable

import colorsys
from random import random, seed
from sys import argv
from os import system, popen
from time import time
from zlib import crc32

assert len(argv) >= 4, (
       "Usage: %s r g b" % argv[0])

hostname = popen("hostname", "r").read().strip().encode("utf-8")
#print("hostname: %s" % hostname)
#print("seed: %s" % crc32(hostname))
seed(crc32(hostname))
r, g, b = (int(x, 16) for x in argv[1:4])
h, s, v = colorsys.rgb_to_hsv(r, g, b)
h += random() * 0.2 - 0.1
s = max(min(s + random() * 0.3 - 0.15, 1.0), 0)
v = max(min(v + random() * 32 - 16, 255), 0)
r, g, b = colorsys.hsv_to_rgb(h, s, v)
r = int(r)
g = int(g)
b = int(b)

system("bsetroot -solid rgb:%02x/%02x/%02x" % (r, g, b))
