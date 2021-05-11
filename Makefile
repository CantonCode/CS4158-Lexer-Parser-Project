flex: 
	flex myLexer.l

bison:  
	bison -vd yac.y

gcc: 
	gcc yac.tab.c lex.yy.c -lm -lfl

start: 
	./a.out

run: 
	flex 
	bison 
	gcc 
	start
