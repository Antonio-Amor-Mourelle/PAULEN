#ifndef TABLASIMBOLOS_H
#define TABLASIMBOLOS_H

#include "tablaHash.h"
#define TAMANO 1024

typedef struct {
    TABLA_HASH *global;
    TABLA_HASH *local;
} TablaSimbolos; 

extern TablaSimbolos *tabla;

TablaSimbolos * crear_tabla_simbolos();
STATUS declarar_global(const char *lexema, CATEGORIA categ, int tipo, int clase,
int tamano, int num_variables, int pos_variable, int num_params, int pos_param);
STATUS declarar_local(const char *lexema, CATEGORIA categ, int tipo, int clase,
int tamano, int num_variables, int pos_variable, int num_params, int pos_param);
INFO_SIMBOLO * uso_global(const char *lexema);
INFO_SIMBOLO * uso_local(const char *lexema);
STATUS declarar_funcion(const char *lexema, CATEGORIA categ, int tipo, int clase,
int tamano, int num_variables, int pos_variable, int num_params, int pos_param);
STATUS fin_funcion();
void destruir_tabla_simbolos();

#endif /* TABLASIMBOLOS_H */

