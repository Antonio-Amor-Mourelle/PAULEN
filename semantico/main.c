#include <stdio.h>
#include "tablaSimbolos.h"

extern char* yytext;
extern FILE* yyin;
extern int yylex(void);
extern int yyparse(void);
extern int fila;
extern int columna;
FILE *out;
FILE *fpasm;
TablaSimbolos *tabla;

int main(int argc, char **argv){
	out = fopen("reglas_sintactico.txt", "w");
	
	tabla = crear_tabla_simbolos();
	fpasm = fopen("programa_ensamblador.asm", "w");
	
	if(argc<3){
		printf("Faltan parametros\n");
		return -1;	
	}
	
	yyin=fopen(argv[1], "r");
	if (!yyin){
		printf("No se encontro el fichero: %s\n", argv[1]);
		return -1; 
	}
    /*Cuidado, no llamar a la salida yyout*/
	fpasm=fopen(argv[2], "w");

	if (!fpasm){
		printf("No se encontro el fichero: %s\n", argv[2]);
		fclose(yyin);
		return -1;
	}
	yyparse();
	fclose(yyin);
	fclose(fpasm);
	fclose(out);

	return 0;
		


}
