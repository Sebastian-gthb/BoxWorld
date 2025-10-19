10 CLS : WIDTH 20,16 : MEMSET &HB00 : DEFINT A-Z : OPTIONBASE 0 : DIM A(16,16)
20 LOCATE 6,0 : PRINT "Box World" : PRINT " by Jeng-Long Jiang" : GOSUB550
30 PRINT "    HX-20 Version" : PRINT " by Sebastian Berger" : GOSUB550
30 CLS : PRINT"Controls   ";CHR$(155);"W":PRINT"      <-A  ";CHR$(156);"S  D->"
40 PRINT"1,2,3,4=scroll ";CHR$(155);CHR$(156):PRINT"  SPACE=reset";:GOSUB550





550 SOUND 1,1 : RETURN