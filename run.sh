lex lolcode.l 
yacc -d lolcode.y 
cc lex.yy.c y.tab.c -ll -ly
./a.out sample.lol
