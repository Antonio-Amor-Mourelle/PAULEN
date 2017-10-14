#include "tablaSimbolos.h"
#include <stdlib.h>


TablaSimbolos * crear_tabla_simbolos() {
    TablaSimbolos *tabla;
    
    /*Reservamos memoria para la tabla de simbolos*/
    tabla = (TablaSimbolos *)malloc(sizeof(TablaSimbolos));
    
    if(!tabla)
        return NULL;
    
    /*Inicializamos la tabla global*/
    tabla->global = crear_tabla(TAMANO);
    
    if (!tabla->global){
        free(tabla);
        return NULL;
    }
    
    return tabla;
}

STATUS declarar_global(const char *lexema, CATEGORIA categ, TIPO tipo,
        CLASE clase, int adic1, int adic2);

STATUS declarar_local(const char *lexema, CATEGORIA categ, TIPO tipo,
        CLASE clase, int adic1, int adic2){
    if(!tabla || !tabla->local)
        return ERR;
    
    /*La funcion insertar_simbolo de hash ya busca primero 
     el simbolo en la tabla*/
    return insertar_simbolo(tabla->local, lexema, categ, tipo, clase,
            adic1, adic2);
}

INFO_SIMBOLO * uso_global(const char *lexema);

INFO_SIMBOLO * uso_local(const char *lexema){
    INFO_SIMBOLO *info;
    
    if(!tabla || !tabla->global || !tabla->local)
        return NULL;
    
    /*Buscamos el simbolo primero en la tabla local*/
    info = buscar_simbolo(tabla->local, lexema);
    
    if(info)
        return info;
    
    /*Si no se ha encontrado lo buscamos en la tabla global*/
    info = buscar_simbolo(tabla->global, lexema);
    
    return info;
}

STATUS declarar_funcion(const char *lexema, CATEGORIA categ, TIPO tipo,
        CLASE clase, int adic1, int adic2);

STATUS fin_funcion(const char *lexema){    
    if(!tabla || !tabla->local)
        return ERR;
    
    liberar_tabla(tabla->local);
    
    
    return OK;
}
