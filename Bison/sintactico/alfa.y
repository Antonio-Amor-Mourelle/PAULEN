%{
#include <stdlib.h>
#include <stdio.h>
extern int yylex();
extern char* yytext;
extern FILE* out;
extern int error_morfologico;

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

programa : TOK_MAIN '{' declaraciones funciones sentencias '}'  {fprintf(out, ";R1:\t<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n");}
declaraciones : declaracion {fprintf(out, ";R2:\t<declaraciones> ::= <declaracion>\n");}
                | declaracion declaraciones {fprintf(out, ";R3:\t<declaraciones> ::= <declaracion> <declaraciones>\n");}
declaracion : clase identificadores ';' {fprintf(out, ";R4:\t<declaracion> ::= <clase> <identificadores>\n");}
clase : clase_escalar {fprintf(out, ";R5:\t<clase> ::= <clase_escalar>\n");}
        | clase_vector {fprintf(out, ";R7:\t<clase> ::= <clase_vector>\n");}
clase_escalar : tipo {fprintf(out, ";R9:\t<clase_escalar> ::= <tipo>\n");}
tipo : TOK_INT {fprintf(out, ";R10:\t<tipo> ::= int\n");}
       | TOK_BOOLEAN {fprintf(out, ";R11:\t<tipo> ::= boolean\n");}
clase_vector : TOK_ARRAY tipo '[' constante_entera ']' {fprintf(out, ";R15:<clase_vector> ::= array <tipo> [ <constante_entera> ]\t\n");}
identificadores : identificador {fprintf(out, ";R18:\t<identificadores> ::= <identificador>\n");}
                  | identificador','identificadores {fprintf(out, ";R19:\t<identificadores> ::= <identificador> , <identificadores>\n");}
funciones : funcion funciones {fprintf(out, ";R20:\t<funciones> ::= <funcion> <funciones>\n");}
            | {fprintf(out, ";R21:\t<funciones> ::= \n");}
funcion : TOK_FUNCTION tipo identificador '(' parametros_funcion ')' '{' declaraciones_funcion sentencias '}' {fprintf(out, ";R22:\t<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }\n");}
parametros_funcion : parametro_funcion resto_parametros_funcion {fprintf(out, ";R23:\t<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n");}
                     | {fprintf(out, ";R24:\t<parametros_funcion> ::= \n");}
resto_parametros_funcion : ';' parametro_funcion resto_parametros_funcion {fprintf(out, ";R25:\t<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>\n");}
                           | {fprintf(out, ";R26:\t<resto_parametros_funcion> ::= \n");}
parametro_funcion : tipo identificador {fprintf(out, ";R*:\t\n");}
declaraciones_funcion : declaraciones {fprintf(out, ";R*:\t\n");}
                        | /**/ {fprintf(out, ";R*:\t\n");}
sentencias : sentencia {fprintf(out, ";R*:\t\n");}
             | sentencia sentencias {fprintf(out, ";R*:\t\n");}
sentencia : sentencia_simple ';' {fprintf(out, ";R*:\t\n");}
             | bloque {fprintf(out, ";R*:\t\n");}
sentencia_simple : asignacion {fprintf(out, ";R*:\t\n");}
                   | lectura {fprintf(out, ";R*:\t\n");}
                   | escritura {fprintf(out, ";R*:\t\n");}
                   | retorno_funcion {fprintf(out, ";R*:\t\n");}
bloque : condicional {fprintf(out, ";R*:\t\n");}
         | bucle {fprintf(out, ";R*:\t\n");}
asignacion : identificador '=' exp {fprintf(out, ";R*:\t\n");}
             | elemento_vector '=' exp {fprintf(out, ";R*:\t\n");}
elemento_vector : identificador '[' exp ']'  {fprintf(out, ";R*:\t\n");}
condicional : TOK_IF '(' exp ')' '{' sentencias '}' {fprintf(out, ";R*:\t\n");}
              | TOK_IF '(' exp ')' '{' sentencias '}' TOK_ELSE '{' sentencias '}' {fprintf(out, ";R*:\t\n");}
/*hasta aqui esther*/
bucle : TOK_WHILE '(' exp ')' '{' sentencias '}' {fprintf(out, ";R*:\t\n");}
lectura : TOK_SCANF identificador {fprintf(out, ";R*:\t\n");}
escritura : TOK_PRINTF exp {fprintf(out, ";R*:\t\n");}
retorno_funcion : TOK_RETURN exp {fprintf(out, ";R*:\t\n");}
exp : exp '+' exp {fprintf(out, ";R*:\t\n");}
      | exp '-' exp {fprintf(out, ";R*:\t\n");}
      | exp '/' exp {fprintf(out, ";R*:\t\n");}
      | exp '*' exp {fprintf(out, ";R*:\t\n");}
      | '-' %prec MENOSU exp {fprintf(out, ";R*:\t\n");}
      | exp TOK_AND exp {fprintf(out, ";R*:\t\n");}
      | exp TOK_OR exp {fprintf(out, ";R*:\t\n");}
      | '!' exp {fprintf(out, ";R*:\t\n");}
      | identificador {fprintf(out, ";R*:\t\n");}
      | constante {fprintf(out, ";R*:\t\n");}
      | '(' exp ')' {fprintf(out, ";R*:\t\n");}
      | '(' comparacion ')' {fprintf(out, ";R*:\t\n");}
      | elemento_vector {fprintf(out, ";R*:\t\n");}
      | identificador '(' lista_expresiones ')' {fprintf(out, ";R*:\t\n");}
lista_expresiones : exp resto_lista_expresiones {fprintf(out, ";R*:\t\n");}
                    | /**/ {fprintf(out, ";R*:\t\n");}
resto_lista_expresiones : ',' exp resto_lista_expresiones {fprintf(out, ";R*:\t\n");}
                          | /**/ {fprintf(out, ";R*:\t\n");}
comparacion : exp TOK_IGUAL exp {fprintf(out, ";R*:\t\n");}
              | exp TOK_DISTINTO exp {fprintf(out, ";R*:\t\n");}
              | exp TOK_MENORIGUAL exp {fprintf(out, ";R*:\t\n");}
              | exp TOK_MAYORIGUAL exp {fprintf(out, ";R*:\t\n");}
              | exp '<' exp {fprintf(out, ";R*:\t\n");}
              | exp '>' exp {fprintf(out, ";R*:\t\n");}
constante : constante_logica {fprintf(out, ";R*:\t\n");}
            | constante_entera {fprintf(out, ";R*:\t\n");}
constante_logica : TOK_TRUE {fprintf(out, ";R*:\t\n");}
                   | TOK_FALSE {fprintf(out, ";R*:\t\n");}
constante_entera: numero {fprintf(out, ";R*:\t\n");}
numero : TOK_CONSTANTE_ENTERA {fprintf(out, ";R*:\t\n");}
identificador :TOK_IDENTIFICADOR {fprintf(out, ";R*:\t\n");}


%%
