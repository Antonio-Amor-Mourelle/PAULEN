#include <string.h>
#include "tablaSimbolos.h"

int main(int argc, char **argv) {
    FILE *in = NULL, *out = NULL;
    INFO_SIMBOLO *res = NULL;
    STATUS retorno;
    char id[64];
    int val = -1;

    if (argc < 3) {
        fprintf(stderr, "Error en los parametros de entrada\n");
        return -1;
    }

    tabla = crear_tabla_simbolos();
    if (!tabla) {
        fprintf(stderr, "Error creando la tabla de simbolos.\n");
        return -1;
    }

    in = fopen(argv[1], "r");
    if (!in) {
        fprintf(stderr, "Error abriendo fichero de entrada.\n");
        return -1;
    }

    out = fopen(argv[2], "w");
    if (!out) {
        fprintf(stderr, "Error abriendo fichero de salida.\n");
        fclose(in);
        return -1;
    }

    while (fscanf(in, "%s\t%d\n", id, &val) >= 0) {
        if (val >= 0) {
            /*Caso se inserta un simbolo*/
            if (tabla->local)
                /*Se inserta el simbolo en el ambito local*/
                retorno = declarar_local(id, VARIABLE, 0, 0, val, 0);
            else
                retorno = declarar_global(id, VARIABLE, 0, 0, val, 0);

            if (retorno == OK)
                fprintf(out, "%s\n", id);
            else
                fprintf(out, "-1\t%s\n", id);

        } else if (strcmp("cierre", id) == 0 && val == -999) {
            /*Se cierra un ambito*/
            if (fin_funcion() == OK)
                fprintf(out, "cierre\n");
        } else if (val < -1) {
            /*Se crea un nuevo ambito*/
            if (declarar_funcion(id, FUNCION, 0, 0, val, 0) == OK)
                fprintf(out, "%s\n", id);
            else
                fprintf(out, "-1\t%s\n", id);
        } else {
            /*Buscamos el simbolo*/
            if (tabla->local) {
                /*Miramos si hay ambito local abierto*/
                res = uso_local(id);
            } else {
                /*Miramos el ambito local*/
                res = uso_global(id);
            }
            if (!res)
                fprintf(out, "%s\t-1\n", id);
            else {
                fprintf(out, "%s\t%d\n", id, res->adicional1);
            }

        }

        val = -1;
    }
    
    destruir_tabla_simbolos(tabla);
    
    fclose(in);
    fclose(out);
    return 0;

}
