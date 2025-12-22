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

#         outside  +--floor----+  +--target---+   +box-+   box-on-taret   wall
lvldict = {"-":0,  "@":1, " ":1,  "+":2, ".":2,   "$":3,   "*":4,        "#":5}
xf = 0
yf = 0
compobject = 0

compobject = lvldict[lvllines[yf][xf]]           #read the first level object and translate in the object code for the HX-20 and save it in compobject
#print("x=",xf," y=",yf, " obj=", lvlobject," cobj=",compobject)
xf += 1

working = True

while(working):
    lvlobject = lvldict[lvllines[yf][xf]]           #read next level object and translate in the object code for the HX-20
    readnext = False


    if lvlobject == 0:          #compress outside space
        if compobject == 6:
            combobject = 7
            readnext = True
        if compobject == 0:
            compobject = 6
            readnext = True

    if lvlobject == 1:          #compress floor
        if compobject == 8:
            compobject = 9
            readnext = True
        if compobject == 1:
            compobject = 8
            readnext = True

    if lvlobject == 5:          #compress wall
        if compobject > 9 and compobject < 99:
            compobject += 1
            readnext = True
        if compobject == 5:
            compobject = 10
            readnext = True


    if not readnext:
        print(compobject, ",", end='')
        compobject=lvlobject

    #print("x=",xf," y=",yf, " obj=", lvlobject," cobj=",compobject)

    xf += 1
    if xf == x:
        xf = 0
        yf += 1
    if yf == y:
        print(compobject, ",", end='')
        working=False
    
    
    