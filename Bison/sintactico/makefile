all: pruebaSintactico

lex.yy.c: alfa.l
	flex $^	

y.tab.c: alfa.y 
	bison -ydv $^

pruebaSintactico: main.c lex.yy.c y.tab.c
	gcc -o $@ $^

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h y.output pruebaSintactico
