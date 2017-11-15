all: ej2

ej2: main.c lex.yy.c y.tab.c
	gcc -o $@ $^

lex.yy.c: ej2.l
	flex $^

y.tab.c: ej2.y
	bison -dy $^

clean:
	rm -f lex.yy.c y.tab.c ej1.o ej2 y.tab.h
