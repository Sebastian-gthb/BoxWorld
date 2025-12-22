#!/usr/bin/env python3

import os
import sys

filename = "level.xsb"


workdir = os.path.dirname(os.path.realpath(__file__))
os.chdir(workdir)
print("Working directory =", workdir)


x=0
y=0

z = (os.path.getsize(filename))
if z > 288:
    print("Error: Size of level file is ",z," byte and to large! Maximum 16x16 = 256byte + some carriage return")
    sys.exit()

with open(filename, 'r') as lvlfile:
    lvllines = lvlfile.readlines()
    
for line in lvllines:                       #determine the sise of the level
    y += 1                  #count lines in file (y-size of level)
    z = len(line) -1        #count length of line (max x-size of level)
    if z > x : x = z        #save the maximum x-size
    #print(len(line) -1)
    
print("Level size: x=", x, "  y=", y)

if x > 16 or y > 16:
    print("Error: Level file to large! Max size is 16 x 16.")
    sys.exit()

for yf in range (0, y):                     #print level map and find the start position
    for xf in range (0, x):
        try:
            lvlobject = lvllines[yf][xf]
            print(lvlobject, end='')
            if (lvlobject == "@") or ("+"):
                xstart=xf
                ystart=yf
        except IndexError:
            print("Error: Level ist not full filled! Each line must have the full size.")
            sys.exit()           
    print("\n", end='')

print("Start is at x=",xstart," y=", ystart)


xf = 0
yf = 0
lvlarraypos = 0
lvlobject = lvllines[yf][xf]      #load first level object


working = True

while(working):
    xf += 1
    lvlobject = lvllines[yf][xf]
    working=False
    
    
    