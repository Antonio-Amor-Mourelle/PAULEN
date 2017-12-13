OBJ=generacion.c tablaHash.c tablaSimbolos.c lex.yy.c y.tab.c main.c tablaSimbolos.c
all: alfa

lex.yy.c: alfa.l
	flex $^	

y.tab.c: alfa.y
	bison -ydv $^

alfa: $(OBJ)
	gcc -o $@ $^

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h y.output generacion.o tablaHash.o tablaSimbolos.o lex.yy.o y.tab.o main.o tablaSimbolos.o alfa
