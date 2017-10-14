CC = gcc -c -Wall
CFLAGS = -ansi -pedantic 


all: tabla_simbolos

tabla_simbolos: tablaSimbolos.o tablaHash.o
	$(CC) -o $^
	mv tablaSimbolos.o $@.o

tablaHash.o: tablaHash.c tablaHash.h
	$(CC) -c tablaHash.c $(CFLAGS)

tablaSimbolos.o: tablaSimbolos.c tablaSimbolos.h tablaHash.h
	$(CC) -c tablaSimbolos.c $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o
