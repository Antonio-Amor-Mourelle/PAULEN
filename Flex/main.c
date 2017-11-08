#include <stdio.h>
#include "tokens.h"

extern char* yytext;
extern FILE* yyin;
extern int yylex(void);
extern int fila;
extern int columna;

int main(int argc, char **argv){

	FILE *out;
	int var = 0;
	
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
	do {
		var = yylex();

		switch(var){
			case TOK_MAIN:
				fprintf(out,"TOK_MAIN\t%d\t%s\n",var, yytext);
				break;
			case TOK_INT:
				fprintf(out,"TOK_INT\t%d\t%s\n",var, yytext);
				break;
			case TOK_BOOLEAN:
				fprintf(out,"TOK_BOOLEAN\t%d\t%s\n",var, yytext);
				break;
			case TOK_ARRAY:
				fprintf(out,"TOK_ARRAY\t%d\t%s\n",var, yytext);
				break;
			case TOK_FUNCTION:
				fprintf(out,"TOK_FUNCTION\t%d\t%s\n",var, yytext);
				break;
			case TOK_IF:
				fprintf(out,"TOK_IF\t%d\t%s\n",var, yytext);
				break;
			case TOK_ELSE:
				fprintf(out,"TOK_ELSE\t%d\t%s\n",var, yytext);
				break;
			case TOK_WHILE:
				fprintf(out,"TOK_WHILE\t%d\t%s\n",var, yytext);
				break;
			case TOK_SCANF:
				fprintf(out,"TOK_SCANF\t%d\t%s\n",var, yytext);
				break;
			case TOK_PRINTF:
				fprintf(out,"TOK_PRINTF\t%d\t%s\n",var, yytext);
				break;
			case TOK_RETURN:
				fprintf(out,"TOK_RETURN\t%d\t%s\n",var, yytext);
				break;
			case TOK_PUNTOYCOMA:
				fprintf(out,"TOK_PUNTOYCOMA\t%d\t%s\n",var, yytext);
				break;
			case TOK_COMA:
				fprintf(out,"TOK_COMA\t%d\t%s\n",var, yytext);
				break;
			case TOK_PARENTESISIZQUIERDO:
				fprintf(out,"TOK_PARENTESISIZQUIERDO\t%d\t%s\n",var, yytext);
				break;
			case TOK_PARENTESISDERECHO:
				fprintf(out,"TOK_PARENTESISDERECHO\t%d\t%s\n",var, yytext);
				break;
			case TOK_CORCHETEIZQUIERDO:
				fprintf(out,"TOK_CORCHETEIZQUIERDO\t%d\t%s\n",var, yytext);
				break;
			case TOK_CORCHETEDERECHO:
				fprintf(out,"TOK_CORCHETEDERECHO\t%d\t%s\n",var, yytext);
				break;
			case TOK_LLAVEIZQUIERDA:
				fprintf(out,"TOK_LLAVEIZQUIERDA\t%d\t%s\n",var, yytext);
				break;
			case TOK_LLAVEDERECHA:
				fprintf(out,"TOK_LLAVEDERECHA\t%d\t%s\n",var, yytext);
				break;
			case TOK_ASIGNACION:
				fprintf(out,"TOK_ASIGNACION\t%d\t%s\n",var, yytext);
				break;
			case TOK_MAS:
				fprintf(out,"TOK_MAS\t%d\t%s\n",var, yytext);
				break;
			case TOK_MENOS:
				fprintf(out,"TOK_MENOS\t%d\t%s\n",var, yytext);
				break;
			case TOK_DIVISION:
				fprintf(out,"TOK_DIVISION\t%d\t%s\n",var, yytext);
				break;
			case TOK_ASTERISCO:
				fprintf(out,"TOK_ASTERISCO\t%d\t%s\n",var, yytext);
				break;
			case TOK_AND:
				fprintf(out,"TOK_AND\t%d\t%s\n",var, yytext);
				break;
			case TOK_OR:
				fprintf(out,"TOK_OR\t%d\t%s\n",var, yytext);
				break;
			case TOK_NOT:
				fprintf(out,"TOK_NOT\t%d\t%s\n",var, yytext);
				break;
			case TOK_IGUAL:
				fprintf(out,"TOK_IGUAL\t%d\t%s\n",var, yytext);
				break;
			case TOK_DISTINTO:
				fprintf(out,"TOK_DISTINTO\t%d\t%s\n",var, yytext);
				break;
			case TOK_MENORIGUAL:
				fprintf(out,"TOK_MENORIGUAL\t%d\t%s\n",var, yytext);
				break;
			case TOK_MAYORIGUAL:
				fprintf(out,"TOK_MAYORIGUAL\t%d\t%s\n",var, yytext);
				break;
			case TOK_MENOR:
				fprintf(out,"TOK_MENORIGUAL\t%d\t%s\n",var, yytext);
				break;
			case TOK_MAYOR:
				fprintf(out,"TOK_MAYORIGUAL\t%d\t%s\n",var, yytext);
				break;
			case TOK_IDENTIFICADOR:
				fprintf(out,"TOK_IDENTIFICADOR\t%d\t%s\n",var, yytext);
				break;
			case TOK_CONSTANTE_ENTERA:
				fprintf(out,"TOK_CONSTANTE_ENTERA\t%d\t%s\n",var, yytext);
				break;
			case TOK_TRUE:
				fprintf(out,"TOK_TRUE\t%d\t%s\n",var, yytext);
				break;
			case TOK_FALSE:
				fprintf(out,"TOK_FALSE\t%d\t%s\n",var, yytext);
				break;
			case TOK_ERROR:
				fprintf(stderr, "****Error en [lin %d, col %d]: simbolo no permitido (%s)\n", fila, columna, yytext);
				fclose(yyin);
				fclose(out);
				return -1;
			case TOK_ERRORLONGITUD:
				fprintf(stderr, "****Error en [lin %d, col %d]: identificador demasiado largo (%s)\n", fila, columna, yytext);
				fclose(yyin);
				fclose(out);
				return -1;
			default:
				break;
		}
	}while(var);
	fclose(yyin);
	fclose(out);

	return 0;
		


}
