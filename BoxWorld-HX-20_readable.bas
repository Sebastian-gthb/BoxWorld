10 CLS : WIDTH 20,16 : MEMSET &HB00 : DEFINT A-Z : OPTIONBASE 0 : DIM A(16,16) : DIM B(255,0)
20 LOCATE 6,0 : PRINT "Box World" : PRINT " by Jeng-Long Jiang"; : GOSUB 460        'print title and play sound (SUB 460)
30 PRINT"    HX-20 Version" : PRINT "by Sebastian Berger"; : GOSUB460               'print 2nd part of the title and play sound
40 CLS : PRINT"Controls   ";CHR$(155);"W" : PRINT"      <-A  ";CHR$(156);"S  D->"   'print a helpscreen with the controls
50 PRINT"R=restart  O=off" : PRINT"P=print level"; : GOSUB460                       '... and play sound again
60 POKE &H11E,&HA : POKE &H11F,&H40 : RESTORE 480 : FOR I=&HA40 TO &HA6F : READ J : POKE I,J : NEXT I       'changing the custom characters for level items (space, floor, targets, boxes, boxes on targets, walls)
70 CLS : INPUT "LEVEL  (1-33)";L                                                    'ask for the start level
80 C=0 : IF L>0 AND L<29 THEN 110                                                   'for the first 28 levels goto line 110
90 IF L<34 THEN 120                                                                 'for level 29 to 33 goto line 120
100 SOUND 1,1 : GOTO 70                                                             'is the input out of range the implemented levels play a sound and ask again
110 ON L GOSUB 500,520,540,560,580,600,630,650,670,690,710,730,750,770,790,810,830,850,870,890,910,930,950,970,980,1010,1040,1070 : GOTO 130    'select the level data from the corresponding line and overjump the second GOSUB code
120 M = L-28 : ON M GOSUB 1110,1130,1150,1170,1190                                  'onfor higher level, use this GOSUB to select level data
130 READ X : READ Y : READ X1 : READ Y1 : FOR J=0 TO 15 : FOR I=0 TO 15 : A(I,J)=0 : NEXT I,J        'load the level header data (size and start position) and errase the level array (A)
140 B=(X+1)*(Y+1) : Z=0                                                             'B=level size in byte; Z=the level items that are extracted; at the end Z must be B if the level is completly extracted
150 READ D : IF D>9 THEN D=D-8 : E=5 : GOTO 190                                     'decompress the level; read the next byte of level data; if D>9 the we have multible (D-8 times) walls (E=5 for walls) and goto the loop to extract the E item D times
160 IF D>7 THEN D=D-6 : E=1 : GOTO 190                                              'if D>7 the we have multible (D-6 times) floor (E=1 for floor) and goto the loop to extract the E item D times
170 IF D>5 THEN D=D-4 : E=0 : GOTO 190                                              'if D>5 the we have multible (D-4 times) outside space (E=0 for outside space) and goto the loop to extract the E item D times
180 B(Z,0)=D : Z=Z+1 : GOTO 200                                                     'all other value of D are the items it self one time (0=otside space, 1=floor, 2=target, 3=box, 4=box on target, 5=wall); write it directly to the level array (B) and increment Z
190 FOR I=1 TO D : B(Z,0)=E : Z=Z+1 : NEXT I                                        'write E item D times in the level array (B) and incremet Z for each item
200 IF Z<B GOTO 150                                                                 'if the count of items (Z) has not reached the level size (B) loop again and load the next level data byte
210 Z=0 : A$=INKEY$ : A$=INKEY$ : A$=INKEY$ : A$=INKEY$                             'use Z now as byte counter to draw the level; read 3 times the keyboard buffer to empty some key pressed from the last level end
220 CLS : FOR J=0 TO Y : LOCATE 0,J : FOR I=0 TO X : A(I,J)=B(Z,0) : Z=Z+1 : IF A(I,J)=3 THEN C=C+1      'draw the hole decompressed level; count the boxes not on target (C)
230 PRINT CHR$(224+A(I,J)); : NEXT I,J                                              'this is part of this level drawing loop from the line above
240 LOCATES 0,Y1-1,0 : LOCATE X1,Y1 : PRINT CHR$(154);                              'scroll the screen to the line with the start position (LOCATES...); locate the cursor to the start position; print the player
250 A$=INPUT$(1) : IF A$="D" THEN X2=X1+1 : X3=X1+2 : Y2=Y1 : Y3=Y1 : GOTO 330      'read the next pressed key; depending on the arrow key, load the x,y value of the next and this next objects in X2 Y2 and X3 Y3 and jump to line 330
260                IF A$="A" THEN X2=X1-1 : X3=X1-2 : Y2=Y1 : Y3=Y1 : GOTO 330
270                IF A$="W" THEN Y2=Y1-1 : Y3=Y1-2 : X2=X1 : X3=X1 : GOTO 330
280                IF A$="S" THEN Y2=Y1+1 : Y3=Y1+2 : X2=X1 : X3=X1 : GOTO 330
290 IF A$="R" THEN 80                                                               'if R was pressed reload the level
300 IF A$="P" THEN I=0 : GOTO 440                                                   'if P war pressed set I to zero and jump to the printing routine
310 IF A$="O" THEN 430                                                              'if O was pressed... end the game
320 SOUND 1,1 : GOTO 250                                                            'for all other keys play a error beep and read the next pressed key
330 ON A(X2,Y2) GOSUB 390,390,350,350,470                                           'if the next object in direction walk floor or target goto 390, a box or box on target goto 350, or a wall then goto 470 (stuck beep)
340 IF C=0 THEN 420 ELSE 250                                                        'check if the level completed (C=all boxes not on target=0) then goto 420 or if not completed goto 250 and wait for the next input
350 IF A(X3,Y3)>2 THEN 470                                                          'subroutine for box moving... if the object after the box a 3=box, 4=box on target or 5=wall goto 470 (stuck beep)
360 IF A(X2,Y2)=3 AND A(X3,Y3)=2 THEN C=C-1                                         'if the object in front a box (3) and the object after this a target (2) then decrement C (count of boxes not on target) - the box will move on a target
370 IF A(X2,Y2)=4 AND A(X3,Y3)=1 THEN C=C+1                                         'if the object in front a box on target (4) and the object after this a flor (1) then increment C (count of boxes not on target) - box will move off a target to floor
380 A(X3,Y3)=A(X3,Y3)+2 : A(X2,Y2)=A(X2,Y2)-2                                       'in all cases a box will moved (from floor or target to floor or target) decrement the location of the box with 2 and increment the new location with 2
390 IF Y1<Y2 THEN LOCATES 0,Y1-1,0                                                  'subroutine for moving player and finish box moving... relocate the screen scrolling
400 LOCATE X1,Y1 : PRINT CHR$(224+A(X1,Y1)); : LOCATE X2,Y2 : PRINT CHR$(154);      'print the original level item to the old player position; print the new player position
410 LOCATE X3,Y3 : PRINT CHR$(224+A(X3,Y3)); : X1=X2 : Y1=Y2 : RETURN               'print a new moved box in front of the new player position; set the new player position X1,X2 and return
420 GOSUB 460 : L=L+1 : IF L<=33 THEN 80                                            'if the level was completed, increment the level (L); if the last level was not finished goto 80 (load the next level)
430 CLS : END                                                                       'end the programm
440 FOR I=0 TO Y STEP 4 : LOCATES 0,I : COPY : NEXT I                               'subroutine to print out the level on the mini printer... scroll throu the hole virtual screen and print each 4 lines
450 LOCATES 0,Y1-1,0 : GOTO 250                                                     'relocate the screen scrolling to the player position and goto 250 (wait for the next pressed key)
460 FOR I=1 TO 28 : J=I^2-56*(I^2\56) : SOUND J,1 : NEXTI : RETURN                  'subroutine play a generated melody and return
470 SOUND1,1 : RETURN                                                               'subroutine play a stuck beep and return
480 DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,66,36,24,36,66,0,255,249,189,159,255,0,255,135,195     'binary for the custom characters
490 DATA 225,255,119,7,119,119,112,119,0,198,40,31,107,136,0,0,0,0,0,0,0,0,0,0,0,0
500 RESTORE 510:RETURN                                                                    'the set DATA for the first level instruction
510 DATA 7,7,4,4,6,11,7,6,5,2,5,7,6,5,1,15,3,1,3,2,10,2,1,3,1,15,3,5,7,6,5,2,5,7,6,11,6   'the compressed level data for the first level
520 RESTORE 530:RETURN                                                                                                  'the set DATA for the second level instruction
530 DATA 8,8,1,1,13,7,0,5,9,5,7,0,5,1,3,3,5,0,12,1,3,1,5,0,5,2,12,1,11,2,5,0,10,9,1,2,5,0,5,9,5,8,5,0,5,9,12,0,13,7     'the compressed level data for the second level
540 RESTORE 550:RETURN                                                                                                '...an so on...
550 DATA 9,6,2,3,0,15,7,5,9,8,13,3,11,9,10,9,3,8,3,1,10,1,2,2,5,1,3,1,12,2,2,5,1,1,1,5,6,16,0
560 RESTORE 570:RETURN
570 DATA 5,7,1,2,0,12,0,10,8,5,0,5,1,3,1,5,0,10,3,1,12,1,3,1,10,2,3,8,10,2,2,4,2,15
580 RESTORE 590:RETURN
590 DATA 7,7,2,1,0,12,7,0,5,1,1,11,6,5,1,3,8,5,0,11,1,5,1,11,2,5,1,5,8,10,2,3,8,5,1,10,2,9,3,1,17
600 RESTORE 610:RETURN
610 DATA 12,10,11,8,7,15,7,12,9,8,5,7,5,9,2,11,1,5,7,5,1,5,1,5,9,1,10,6,5,1,5,1,3,1,3,5,2,1,5,6,5,1,5,8
620 DATA 4,8,5,1,5,6,5,1,2,5,3,1,3,1,5,1,5,6,10,9,1,5,1,5,1,11,0,5,1,11,2,9,8,5,0,5,9,8,10,9,5,0,20
630 RESTORE 630:RETURN
640 DATA 9,7,8,1,7,15,6,10,8,5,8,5,6,5,9,5,8,5,6,5,3,1,3,1,3,1,5,6,5,1,3,10,8,12,1,3,1,5,1,11,2,2,2,2,2,8,5,0,17,0
650 RESTORE 660:RETURN
660 DATA 9,6,8,3,7,14,6,11,9,1,5,0,10,2,1,3,10,1,11,2,2,3,1,3,9,10,2,2,1,3,1,3,1,14,10,8,5,7,7,12,0
670 RESTORE 680:RETURN
680 DATA 10,8,8,7,0,17,6,5,8,10,9,5,6,5,9,3,9,5,6,5,3,1,11,1,3,5,6,5,1,5,2,2,2,5,1,5,0,10,1,5,2,2,2,5,1,11,1,3,8,3,8,3,1,10,9,8,5,9,20
690 RESTORE 700:RETURN
700 DATA 7,6,1,3,6,14,6,5,9,1,12,3,3,3,1,10,8,3,2,2,1,10,1,3,2,2,2,14,8,5,7,0,12,0
710 RESTORE 720:RETURN
720 DATA 11,5,8,4,0,12,6,15,8,5,6,5,9,10,1,3,1,12,3,8,10,8,3,2,2,2,2,1,3,1,11,9,1,5,9,10,0,17,5,0
730 RESTORE 740:RETURN
740 DATA 7,6,5,1,6,13,0,11,9,5,0,5,8,3,2,1,11,8,2,3,2,1,12,1,4,3,1,5,6,5,9,10,6,13,0
750 RESTORE 760:RETURN
760 DATA 7,7,3,6,6,12,7,0,5,2,2,5,7,10,1,2,10,6,5,8,3,2,5,0,10,1,3,8,11,8,5,3,3,1,10,9,9,17
770 RESTORE 780:RETURN
780 DATA 7,6,1,3,17,8,5,9,10,1,3,2,2,3,1,10,1,3,2,4,1,11,1,3,2,2,3,1,10,8,5,9,17
790 RESTORE 800:RETURN
800 DATA 7,6,4,5,0,14,0,10,9,1,11,1,3,1,3,3,1,10,2,2,2,2,2,2,10,1,3,3,1,3,1,12,8,11,6,12,6
810 RESTORE 820:RETURN
820 DATA 9,8,6,7,6,13,7,6,5,9,12,6,5,1,3,9,1,12,1,3,1,10,1,10,2,2,2,1,3,9,10,2,2,2,3,5,3,1,14,1,5,1,3,1,5,7,5,9,8,5,7,15
830 RESTORE 840:RETURN
840 DATA 8,6,3,5,14,7,5,9,1,5,7,5,1,3,3,3,10,6,5,8,5,2,2,13,8,2,2,3,1,5,0,5,9,9,5,0,16
850 RESTORE 860:RETURN
860 DATA 9,8,7,7,6,16,6,5,9,5,2,1,5,0,10,8,3,2,2,2,5,0,5,8,3,1,5,4,2,11,1,10,3,5,1,11,9,3,8,3,1,10,9,5,9,1,16,8,5,7,7,12
870 RESTORE 880:RETURN
880 DATA 9,7,5,6,0,15,7,5,2,2,2,2,1,5,6,11,2,2,2,3,12,8,3,5,3,1,3,1,10,1,3,3,8,5,3,1,10,9,1,5,9,13,9,11,7,13,6
890 RESTORE 900:RETURN
900 DATA 6,7,4,6,16,2,2,3,2,2,10,2,2,5,2,2,10,1,3,3,3,1,10,8,3,8,10,1,3,3,3,1,10,8,5,8,16
910 RESTORE 920:RETURN
920 DATA 10,7,1,5,7,14,7,6,5,1,2,2,2,5,6,12,2,2,2,2,5,6,5,8,11,3,1,12,1,3,1,3,8,3,3,1,10,8,3,1,3,9,1,10,9,11,9,14,0,14
930 RESTORE 940:RETURN
940 DATA 8,8,7,7,16,0,5,9,9,5,0,5,1,5,3,3,8,5,0,5,1,2,2,2,5,1,5,0,10,2,2,2,3,1,10,0,5,1,10,1,3,1,5,0,5,3,8,3,8,5,0,5,8,5,9,5,0,16
950 RESTORE 960:RETURN
960 DATA 9,7,8,3,6,13,7,11,9,13,9,3,1,3,8,10,1,3,9,3,8,12,3,3,13,6,5,8,2,2,5,7,0,5,2,2,2,2,5,7,0,14,6
970 RESTORE 980:RETURN
980 RESTORE 990:RETURN
990 DATA 10,9,1,8,7,6,14,0,13,2,9,5,0,5,8,5,2,2,10,1,5,0,5,8,3,2,2,9,5,0,5,8,5,1,2,5,1,13,1,10,3,5,8,10,1,3,9,1,3,3,1,10,1,5,3,5,8,5
1000 DATA 8,10,9,20,7,7
1010 RESTORE 1020:RETURN
1020 DATA 12,11,10,8,0,17,7,0,5,9,10,8,12,0,5,1,3,9,9,8,5,0,10,3,11,1,10,8,5,0,5,8,10,1,4,1,5,1,10,0,5,1,3,2,2,2,2,2,2,1,5,0,10,1,11
1030 DATA 1,2,1,5,1,5,0,5,9,8,3,11,3,5,0,5,9,5,9,1,3,1,5,0,13,3,5,1,12,7,6,5,9,5,7,7,6,13,7,0
1040 RESTORE 1050:RETURN
1050 DATA 14,11,7,10,7,7,17,7,7,5,9,9,1,5,7,7,5,1,5,1,5,1,5,1,5,7,7,5,8,3,1,3,5,1,16,9,3,9,10,2,2,5,8,10,1,3,1,3,5,1,10,2,2,9,10,1,3
1060 DATA 1,3,8,10,2,2,5,8,10,1,15,2,2,5,1,5,1,3,1,3,1,5,7,5,2,2,9,8,3,8,5,7,5,8,11,9,11,7,12,1,13,7,6
1070 RESTORE 1080:RETURN
1080 DATA 15,12,2,6,7,0,12,7,7,6,13,8,5,7,7,6,5,8,3,1,3,1,5,0,16,9,3,8,5,0,5,4,2,4,2,4,11,1,3,1,3,1,11,2,4,2,4,2,5,0,5,3,1,3,8,5,8,4
1090 DATA 2,4,2,4,5,0,5,1,3,1,3,9,1,2,4,2,4,10,0,5,3,1,3,8,5,8,4,2,4,2,4,11,1,3,1,3,1,11,2,4,2,4,2,10,9,3,8,5,0,5,4,2,4,2,4,10,8,3,1
1100 DATA 3,1,5,0,20,8,5,7,7,7,7,12,7,7,6
1110 RESTORE 1120:RETURN
1120 DATA 8,6,4,5,16,0,5,2,2,2,2,2,2,5,0,5,8,3,1,5,1,11,1,3,1,5,1,3,1,11,3,1,3,1,3,1,5,0,5,9,9,5,0,16
1130 RESTORE 1140:RETURN
1140 DATA 11,6,2,3,6,21,9,2,9,1,10,9,10,3,10,8,10,8,3,2,1,2,1,2,3,12,1,3,10,3,10,1,5,6,5,9,1,2,9,5,6,18,0
1150 RESTORE 1160:RETURN
1160 DATA 8,7,7,1,7,18,2,9,10,8,3,3,3,8,10,2,10,2,10,2,10,9,3,9,10,8,3,2,5,1,14,9,5,7,0,13,0
1170 RESTORE 1180:RETURN
1180 DATA 7,7,4,6,0,14,6,5,2,1,2,2,5,6,5,2,1,3,2,5,0,11,8,3,11,1,3,8,3,1,10,1,5,3,10,1,10,9,9,17
1190 RESTORE 1200:RETURN
1200 DATA 13,11,3,7,7,0,14,7,7,11,9,1,11,7,0,5,9,5,3,9,11,6,5,9,3,9,3,3,1,5,6,5,1,3,3,1,5,3,9,1,5,6,10,9,3,9,3,1,15,1,5,3,14,2,2,8,5
1210 DATA 3,8,5,7,0,5,2,5,2,2,8,3,10,7,0,5,2,2,2,2,3,5,1,5,7,6,5,2,2,2,2,9,5,7,6,17,7,6
2000 'EOF