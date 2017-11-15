%{
#include <stdlib.h>
#include <stdio.h>
extern int yylex();
extern char* yytext;
extern FILE* out;
extern int f;

void yyerror(char *s){
}


%}

%token 

%left '+' '-'
%left '*' '/'
%right MENOSU

%%



%%

