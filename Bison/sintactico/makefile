all: pruebaSintactico

lex.yy.c: alfa.l
	flex $^	

y.tab.c: alfa.y 
	bison -ydv $^

pruebaSintactico: lex.yy.c y.tab.c
	gcc -o $@ $^

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h ruebaMorfo
