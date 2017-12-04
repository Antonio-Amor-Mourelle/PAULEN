OBJ=generacion.c tablaHash.c tablaSimbolos.c lex.yy.c y.tab.c main.c tablaSimbolos.c
all: pruebaSemantico

lex.yy.c: alfa.l
	flex $^	

y.tab.c: alfa.y
	bison -ydv $^

pruebaSemantico: $(OBJ)
	gcc -o $@ $^

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h y.output *.o pruebaSemantico
