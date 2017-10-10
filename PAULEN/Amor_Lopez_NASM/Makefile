CC = gcc
CFLAGS = -pedantic -Wall -pedantic

#directorios
#IDIR=includes
#ODIR=obj
#LDIR=lib
#SDIR=src
#SLDIR=srclib
#OLDIR=objlib

DEPS=generacion.h

#rutas de los ficheros
all: generacion_codigo

generacion_codigo: generacion.c $(DEPS)
	$(CC) $(CFLAGS) -c  generacion.c $<
	mv generacion.o $@.o

.PHONY: clean
clean:
	rm -f *.o

#####
