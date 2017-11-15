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

%token TOK_IDENTIFICADOR
%token TOK_CONSTANTE_ENTERA

%left '+' '-'
%left '*' '/'
%right MENOSU

%%
<clase_vector> : TOK_ARRAY <tipo> '[' <constante_entera> ']'
<identificadores> : <identificador>
                  | <identificador>','<identificadores>
<funciones> : <funcion> <funciones>
            | /**/
<funcion> : TOK_FUNCTION <tipo> <identificador> '(' <parametros_funcion> ')' '{' <declaraciones_funcion> <sentencias> '}'
<parametros_funcion> : <parametro_funcion> <resto_parametros_funcion>
                     | /**/
<resto_parametros_funcion> : ';' <parametro_funcion> <resto_parametros_funcion>
                           | /**/
<parametro_funcion> : <tipo> <identificador>
<declaraciones_funcion> : <declaraciones>
                        | /**/
<sentencias> : <sentencia>
             | <sentencia> <sentencias>
<sentencias> : <sentencia_simple> ';'
             | <bloque>





















<lista_expresiones> : <exp> <resto_lista_expresiones>
                    | /**/
<resto_lista_expresiones> : ',' <exp> <resto_lista_expresiones>
                          | /**/
<comparacion> : <exp> TOK_IGUAL <exp>
              | <exp> TOK_DISTINTO <exp>
              | <exp> TOK_MENORIGUAL <exp>
              | <exp> TOK_MAYORIGUAL <exp>
              | <exp> TOK_MENOR <exp>
              | <exp> TOK_MAYOR <exp>
<constante> : <constante_logica>
            | <constante_entera>
<constante_logica> : TOK_TRUE
                   | TOK_FALSE
<constante_entera>: <numero>
<numero> : TOK_CONSTANTE_ENTERA

<identificador> :TOK_IDENTIFICADOR


%%
