#include <stdio.h>
#include "y.tab.h"

extern char* yytext;
extern FILE* yyin;
extern int yylex(void);
extern int fila;
extern int columna;
FILE *out;

int main(int argc, char **argv){
	
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
