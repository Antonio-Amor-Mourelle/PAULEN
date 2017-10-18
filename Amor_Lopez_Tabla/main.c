#include "tablaSimbolos.h"

int main(int argc, char **argv) {
    FILE *in, *out;
    char id[64];
    int val;
    
    tabla = crear_tabla_simbolos();
    if(!tabla){
        fprintf(stderr, "Error creando la tabla de simbolos.\n");
        return -1;
    }

    in = fopen("entrada.txt", "r");
    if (!in) {
        fprintf(stderr, "Error abriendo fichero de entrada.\n");
        return -1;
    }

    out = fopen("salida.txt", "w");
    if (!out) {
        fprintf(stderr, "Error abriendo fichero de salida.\n");
        return -1;
    }

    while(fscanf(in, "%s\t%d\n", id, val)>=0){
        if (val >= 0){
            /*Caso se inserta un simbolo*/
            if(tabla->local)
                /*Se inserta el simbolo en el ambito local*/
                declarar_local(id, VARIABLE, 0,
        0, val, 0);
            else 
                declarar_global(id, VARIABLE, 0,
        0, val, 0);
        }
    }


}
