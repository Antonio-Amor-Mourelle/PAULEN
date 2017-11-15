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

%token TOK_ARRAY
%token TOK_INT
%token TOK_BOOLEAN
%token TOK_FUNCTION
%token TOK_IF
%token TOK_ELSE
%token TOK_WHILE
%token TOK_TRUE
%token TOK_FALSE
%token TOK_SCANF
%token TOK_PRINTF
%token TOK_RETURN
%token TOK_AND
%token TOK_OR
%token TOK_IGUAL
%token TOK_DISTINTO
%token TOK_NOT
%token TOK_COMA
%token TOK_MENORIGUAL
%token TOK_MAYORIGUAL
%token TOK_IDENTIFICADOR
%token TOK_CONSTANTE_ENTERA

%left '+' '-'
%left '*' '/'
%right MENOSU

%%

<programa> : TOK_MAIN '{' <declaraciones> <funciones> <sentencias> '}'
<declaraciones> : <declaracion>
                | <declaracion> <declaraciones>
<declaracion> : <clase> <identificadores> ';'
<clase> : <clase_escalar>
        | <clase_vector>
<clase_escalar> : <tipo>
<tipo> : TOK_INT 
       | TOK_BOOLEAN


/*AQUI VA EL CODIGO DE TON*/


<sentencia_simple> : <asignacion>
                   | <lectura>
                   | <escritura>
                   | <retorno_funcion>
<bloque> : <condicional>
         | <bucle>
<asignacion> : <identificador> '=' <exp>
             | <elemento_vector> '=' <exp>
<elemento_vector> : <identificador> '[' <exp> ']' 
<condicional> : TOK_IF '(' <exp> ')' '{' <sentencias> '}'
              | TOK_IF '(' <exp> ')' '{' <sentencias> '}' TOK_ELSE '{' <sentencias> '}'
<bucle> : TOK_WHILE '(' <exp> ')' '{' <sentencias> '}'
<lectura> : TOK_SCANF <identificador>
<escritura> : TOK_PRINTF <exp>
<retorno_funcion> : TOK_RETURN <exp>
<exp> : <exp> '+' <exp>
      | <exp> '-' <exp>
      | <exp> '/' <exp> 
      | <exp> '*' <exp> 
      | '-' %prec MENOSU <exp>
      | <exp> TOK_AND <exp>
      | <exp> TOK_OR <exp> 
      | '!' <exp> 
      | <identificador>
      | <constante>
      | '(' <exp> ')'
      | '(' <comparacion> ')'
      | <elemento_vector>
      | <identificador> '(' <lista_expresiones> ')'



/*AQUI VA EL SEGUNDO CODIGO DE TON*/




%%

