%{
#include <stdlib.h>
#include <stdio.h>
extern int yylex();
extern FILE* out;
extern int f;

void yyerror(char *s){
	if(!f)
		fprintf(out, "ERROR SINTACTICO\nEXPRESION INCORRECTA\n");		
}


%}

%token TOK_CONSTANTE_ENTERA
%token TOK_CONSTANTE_REAL
%token TOK_ERROR

%left '+' '-'
%left '*' '/'
%right MENOSU

%%

S : exp {if(!f) fprintf(out, "EXPRESION CORRECTA\n");}
exp : exp '+' exp {fprintf(out,"REGLA: exp: exp + exp\n");}
    | exp '-' exp {fprintf(out,"REGLA: exp: exp - exp\n");}
    | exp '*' exp {fprintf(out,"REGLA: exp: exp * exp\n");}
    | exp '/' exp {fprintf(out,"REGLA: exp: exp / exp\n");}
    | '-' %prec MENOSU exp {fprintf(out,"REGLA: exp: -exp\n");}
    | '('exp')' {fprintf(out,"REGLA: exp: (exp)\n");}
    | cte {fprintf(out,"REGLA: exp: constante\n");}
cte : TOK_CONSTANTE_ENTERA {fprintf(out,"REGLA: constante: TOK_CONSTANTE_ENTERA\n");}
    | TOK_CONSTANTE_REAL {fprintf(out,"REGLA: constante: TOK_CONSTANTE_REAL\n");}


%%

