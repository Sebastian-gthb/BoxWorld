#!/usr/bin/env python3

import os
import sys

workdir = os.path.dirname(os.path.realpath(__file__))
os.chdir(workdir)
print("Working directory =", workdir)


x=0
y=0
with open("level.xsb", 'r') as lvlfile:
    
    for line in lvlfile:
        y += 1                  #count lines in file (y-size of level)
        z = len(line) -1        #count length of line (max x-size of level)
        if z > x : x = z        #save the maximum x-size
        #print(len(line) -1)
    
    print("Level size: x=", x, "  y=", y)
    