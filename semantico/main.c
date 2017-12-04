#include <stdio.h>
#include "tablaSimbolos.h"

extern char* yytext;
extern FILE* yyin;
extern int yylex(void);
extern int yyparse(void);
extern int fila;
extern int columna;
FILE *out;
TablaSimbolos *tabla;

int main(int argc, char **argv){

	tabla = crear_tabla_simbolos();
	
	if(argc<3){
		printf("Faltan parametros\n");
		return -1;	
	}
	
	yyin=fopen(argv[1], "r");
	if (!yyin){
		printf("No se encontro el fichero\n");
		return -1; 
	}
    /*Cuidado, no llamar a la salida yyout*/
	out=fopen(argv[2], "w");

	if (!out){
		printf("No se encontro el fichero\n");
		fclose(yyin);
		return -1;
	}
	yyparse();
	fclose(yyin);
	fclose(out);

	return 0;
		


}
