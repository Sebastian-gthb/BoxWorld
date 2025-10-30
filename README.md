This is Epson HX-20 version of the game Box World (a Sokoban clone) writen in Microsoft Basic.
The program code is optimized for size and has been greatly reduced and is difficult to read. If I finished, I upload an god to read version wir comments.

This version has the following features:
* use W-A-S-D as cursor keys instand of the confusing cursor keys of the HX-20
* custom symbols for walls, targets and boxes
* scolling level
* a funktion to print the level on the internal mini printer
* a level restart option
* a key to exit the program (A very simple function, but not common in all programs.)
* the level data are compressed to reduced program code
* an instruction screen to describe the controls

The controls are:
* W = walk up
* S = walk down
* A = walk left
* D = walk right
* R = restart level
* P = print level on mini printer
* O = exit programm (off)


The level data following this structure (example the first level):

DATA 7,7,4,4,6,11,7,6,5,2,5,7,6,5,1,11,11,5,3,1,3,2,10,2,1,3,1,11,11,5,3,5,7,6,5,2,5,7,6,11,6
* 1st number = x size (0 to 15 = 1 to 16 symbols) 7 = 8 symbols wide
* 2nd number = y size (0 to 15 = 1 to 16 symbols) 7 = 8 symbols high
* 3rd number = start position x (0 to 15) 4 = start on the 5 symbol
* 4th number = start position y (0 to 15) 4 = start on the 5 symbol
* following numbers are the level with this allocation
  * 0 = free space outside the level
  * 1 = floor
  * 2 = target for a box
  * 3 = box
  * 4 = box on a target
  * 5 = wall
* now the comression option
  * 6 = 2x "0" free space outside the level
  * 7 = 3x "0" free space outside the level
  * 8 = 2x "1" floor
  * 9 = 3x "1" floor
  * 10 = 2x "5" wall
  * 11 = 3x "5" wall

It must be a wall arround the playground! So the player should not go to x=0 or y=0 or x=15 or y=15.

Variables they are used:
* C = boxes not on target (0=level completed)
* L = current level (1 to ...)