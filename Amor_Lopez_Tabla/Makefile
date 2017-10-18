CC = gcc -c -Wall
CFLAGS = -ansi -pedantic 


all: tabla_simbolos

tabla_simbolos: main.o tablaSimbolos.o tablaHash.o
	$(CC) -o $^

main.o: main.c tablaSimbolos.h
	$(CC) -c main.c

tablaHash.o: tablaHash.c tablaHash.h
	$(CC) -c tablaHash.c $(CFLAGS)

tablaSimbolos.o: tablaSimbolos.c tablaSimbolos.h tablaHash.h
	$(CC) -c tablaSimbolos.c $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o
