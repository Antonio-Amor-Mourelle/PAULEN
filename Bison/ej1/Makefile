all: ej1

ej1: main.c lex.yy.c y.tab.c
	gcc -o $@ $^

lex.yy.c: ej1.l
	flex $^

y.tab.c: ej1.y
	bison -dy $^

clean:
	rm -f lex.yy.c y.tab.c ej1.o ej1 y.tab.h
