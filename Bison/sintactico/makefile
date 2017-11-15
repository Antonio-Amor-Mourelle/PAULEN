all: pruebaMorfo

lex.yy.c: alfa.l
	flex alfa.l	

pruebaMorfo: main.c lex.yy.c
	gcc -o pruebaMorfo main.c lex.yy.c

clean: 
	rm -f lex.yy.c pruebaMorfo
