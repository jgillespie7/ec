ec: ec.tab.c lex.yy.c
	gcc -o ec ec.tab.c lex.yy.c

ec.tab.c: ec.y
	bison -d ec.y

lex.yy.c: ec.l
	flex ec.l
