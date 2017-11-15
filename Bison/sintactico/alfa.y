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

%token TOK_MAIN
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
%token TOK_MENORIGUAL
%token TOK_MAYORIGUAL
%token TOK_IDENTIFICADOR
%token TOK_CONSTANTE_ENTERA

%left TOK_AND TOK_OR
%right '!'
%left '<' '>' TOK_MENORIGUAL TOK_MAYORIGUAL
%left '+' '-'
%left '*' '/'
%right MENOSU

%%

programa : TOK_MAIN '{' declaraciones funciones sentencias '}'  {}
declaraciones : declaracion {}
                | declaracion declaraciones {}
declaracion : clase identificadores ';' {}
clase : clase_escalar {}
        | clase_vector {}
clase_escalar : tipo {}
tipo : TOK_INT {}
       | TOK_BOOLEAN {}
clase_vector : TOK_ARRAY tipo '[' constante_entera ']' {}
identificadores : identificador {}
                  | identificador','identificadores
funciones : funcion funciones
            | /**/
funcion : TOK_FUNCTION tipo identificador '(' parametros_funcion ')' '{' declaraciones_funcion sentencias '}'
parametros_funcion : parametro_funcion resto_parametros_funcion
                     | /**/
resto_parametros_funcion : ';' parametro_funcion resto_parametros_funcion
                           | /**/
parametro_funcion : tipo identificador
declaraciones_funcion : declaraciones
                        | /**/
sentencias : sentencia
             | sentencia sentencias
sentencia : sentencia_simple ';'
             | bloque
sentencia_simple : asignacion
                   | lectura
                   | escritura
                   | retorno_funcion
bloque : condicional
         | bucle
asignacion : identificador '=' exp
             | elemento_vector '=' exp
elemento_vector : identificador '[' exp ']' 
condicional : TOK_IF '(' exp ')' '{' sentencias '}'
              | TOK_IF '(' exp ')' '{' sentencias '}' TOK_ELSE '{' sentencias '}'
bucle : TOK_WHILE '(' exp ')' '{' sentencias '}'
lectura : TOK_SCANF identificador
escritura : TOK_PRINTF exp
retorno_funcion : TOK_RETURN exp
exp : exp '+' exp
      | exp '-' exp
      | exp '/' exp
      | exp '*' exp
      | '-' %prec MENOSU exp
      | exp TOK_AND exp
      | exp TOK_OR exp
      | '!' exp
      | identificador
      | constante
      | '(' exp ')'
      | '(' comparacion ')'
      | elemento_vector
      | identificador '(' lista_expresiones ')'
lista_expresiones : exp resto_lista_expresiones
                    | /**/
resto_lista_expresiones : ',' exp resto_lista_expresiones
                          | /**/
comparacion : exp TOK_IGUAL exp
              | exp TOK_DISTINTO exp
              | exp TOK_MENORIGUAL exp
              | exp TOK_MAYORIGUAL exp
              | exp '<' exp
              | exp '>' exp
constante : constante_logica
            | constante_entera
constante_logica : TOK_TRUE
                   | TOK_FALSE
constante_entera: numero
numero : TOK_CONSTANTE_ENTERA
identificador :TOK_IDENTIFICADOR


%%
