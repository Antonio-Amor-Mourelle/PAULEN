%{
#include "alfa.h"
#include "tablaSimbolos.h"
#include "generacion.h"
#include <stdlib.h>
#include <stdio.h>
extern int yylex();
extern char* yytext;
extern int yyleng;
extern FILE* out;
extern FILE* fpasm;
extern int error_morfologico;
extern int fila;
extern int columna;

int error_semantico = 0;
int tipo_actual; /*Entero o booleano*/
int clase_actual; /*Escalar o vector*/
int  tamanio_vector_actual = 0; /*Tamanno de un vector*/
int pos_variable_local_actual=1; /*Posicion de una variable local en su declaracion*/

int etiqueta = 0; /*Variable que cuenta el numero de etiquetas ensamblador para los saltos*/

void yyerror(char *s){
	if(!error_morfologico && !error_semantico)
		fprintf(stderr, "\t****Error sintactico en [lin %d, col %d]\n", fila, columna-yyleng);
	else if(error_semantico)
		fprintf(stderr, "%s\n", s);

	else
		fprintf(stderr, "%s\n", s);
	return;
}

%}

%union{
	tipo_atributos atributos;
}



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
%token <atributos> TOK_IDENTIFICADOR
%token <atributos> TOK_CONSTANTE_ENTERA

%type <atributos> condicional
%type <atributos> if_exp
%type <atributos> if_exp_sentencias
%type <atributos> comparacion
%type <atributos> elemento_vector
%type <atributos> exp
%type <atributos> tipo
%type <atributos> constante
%type <atributos> constante_entera
%type <atributos> constante_logica
%type <atributos> identificador

%type <atributos> while
%type <atributos> while_exp
%type <atributos> bucle





%left TOK_AND TOK_OR
%right '!'
%left '<' '>' TOK_MENORIGUAL TOK_MAYORIGUAL
%left '+' '-'
%left '*' '/'
%right MENOSU

%%

programa : TOK_MAIN '{' declaraciones escritura1 funciones escritura2 sentencias '}'  {
	escribir_fin(fpasm);
	fprintf(out, ";R1:\t<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n");}
escritura1: {
	int i, tam;
	NODO_HASH * aux;
	/*Escritura de la seccion data*/
	escribir_cabecera_compatibilidad(fpasm);
	/*Mensajes generales*/
	escribir_subseccion_data(fpasm);
	escribir_cabecera_bss(fpasm);
	/*Decalracion de las variables de la tabla de simbolos*/
	for (i=0; i<tabla->global->tam; i++){
		aux = tabla->global->tabla[i];
		while(aux){
			tam = aux->info->tamano ? aux->info->tamano : 1;
			declarar_variable(fpasm, aux->info->lexema,  aux->info->tipo, tam);
			aux = aux->siguiente;
		}
	}
	/*Escritura del segmento de codigo. Todo listo para despues escribir main:*/
	escribir_segmento_codigo(fpasm);
	}
escritura2: {escribir_inicio_main(fpasm);}
declaraciones : declaracion {fprintf(out, ";R2:\t<declaraciones> ::= <declaracion>\n");}
                | declaracion declaraciones {fprintf(out, ";R3:\t<declaraciones> ::= <declaracion> <declaraciones>\n");}
declaracion : clase identificadores ';' {fprintf(out, ";R4:\t<declaracion> ::= <clase> <identificadores> ;\n");}
clase : clase_escalar {clase_actual = ESCALAR; fprintf(out, ";R5:\t<clase> ::= <clase_escalar>\n");}
        | clase_vector {clase_actual = VECTOR; fprintf(out, ";R7:\t<clase> ::= <clase_vector>\n");}
clase_escalar : tipo {tamanio_vector_actual=0; fprintf(out, ";R9:\t<clase_escalar> ::= <tipo>\n");}
tipo : TOK_INT {tipo_actual = INT; fprintf(out, ";R10:\t<tipo> ::= int\n");}
       | TOK_BOOLEAN {tipo_actual = BOOLEAN; fprintf(out, ";R11:\t<tipo> ::= boolean\n");}
clase_vector : TOK_ARRAY tipo '[' TOK_CONSTANTE_ENTERA ']' {
	if ((tamanio_vector_actual < 1 ) || (tamanio_vector_actual > MAX_TAMANIO_VECTOR)){
		yyerror("Tamanno vector erroneo");
	 } else {
		tamanio_vector_actual = $4.valor_entero;
		fprintf(out, ";R15:<clase_vector> ::= array <tipo> [ <constante_entera> ]\t\n");
	}
}
identificadores : identificador {fprintf(out, ";R18:\t<identificadores> ::= <identificador>\n");}
                  | identificador','identificadores {fprintf(out, ";R19:\t<identificadores> ::= <identificador> , <identificadores>\n");}
funciones : funcion funciones {fprintf(out, ";R20:\t<funciones> ::= <funcion> <funciones>\n");}
            | {fprintf(out, ";R21:\t<funciones> ::= \n");}
funcion : TOK_FUNCTION tipo identificador '(' parametros_funcion ')' '{' declaraciones_funcion sentencias '}' {fprintf(out, ";R22:\t<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }\n");}
parametros_funcion : parametro_funcion resto_parametros_funcion {fprintf(out, ";R23:\t<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n");}
                     | {fprintf(out, ";R24:\t<parametros_funcion> ::= \n");}
resto_parametros_funcion : ';' parametro_funcion resto_parametros_funcion {fprintf(out, ";R25:\t<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>\n");}
                           | {fprintf(out, ";R26:\t<resto_parametros_funcion> ::= \n");}
parametro_funcion : tipo identificador {fprintf(out, ";R27:\t<parametro_funcion> ::= <tipo> <identificador>\n");}
declaraciones_funcion : declaraciones {fprintf(out, ";R28:\t<declaraciones_funcion> ::= <declaraciones>\n");}
                        | /**/ {fprintf(out, ";R29:\t<declaraciones_funcion> ::= \n");}
sentencias : sentencia {fprintf(out, ";R30:\t<sentencias> ::= <sentencia>\n");}
             | sentencia sentencias {fprintf(out, ";R31:\t<sentencias> ::= <sentencia> <sentencias>\n");}
sentencia : sentencia_simple ';' {fprintf(out, ";R32:\t<sentencia> ::= <sentencia_simple> ;\n");}
             | bloque {fprintf(out, ";R33:\t<sentencia> ::= <bloque>\n");}
sentencia_simple : asignacion {fprintf(out, ";R34:\t<sentencia_simple> ::= <asignacion>\n");}
                   | lectura {fprintf(out, ";R35:\t<sentencia_simple> ::= <lectura>\n");}
                   | escritura {fprintf(out, ";R36:\t<sentencia_simple> ::= <escritura>\n");}
                   | retorno_funcion {fprintf(out, ";R38:\t<sentencia_simple> ::= <retorno_funcion>\n");}
bloque : condicional {fprintf(out, ";R40:\t<bloque> ::= <condicional>\n");}
         | bucle {fprintf(out, ";R41:\t<bloque> ::= <bucle>\n");}
asignacion : TOK_IDENTIFICADOR '=' exp {
		INFO_SIMBOLO *simbolo;
		simbolo = uso_global($1.lexema);
		if(!simbolo) {error_semantico = 1; yyerror("Variable sin declarar");}
		if(simbolo->categoria == FUNCION) {error_semantico = 1; yyerror("No se puede hacer una asignacion a una funcion");}
		if(simbolo->clase == VECTOR){error_semantico = 1; yyerror("No se puede hacer una asignacion a un vector");}
		if(simbolo->tipo != $3.tipo){error_semantico = 1; yyerror("Los tipos de la expresion no coinciden");}

		/*Codigo ensamblador*/
		asignar(fpasm, $1.lexema, $3.es_direccion);
		fprintf(out, ";R43:\t<asignacion> ::= <identificador> = <exp>\n");}
             | elemento_vector '=' exp {fprintf(out, ";R44:\t<asignacion> ::= <elemento_vector> = <exp>\n");}
elemento_vector : identificador '[' exp ']'  {fprintf(out, ";R48:\t<elemento_vector> ::= <identificador> [ <exp> ]\n");}
condicional : if_exp_sentencias {fprintf(out, ";R50:\t<condicional> ::= if ( <exp> ) { <sentencias> }\n");}
              | if_exp_sentencias TOK_ELSE '{' sentencias '}' {
	
	/*Ensamblador*/
	fin_if_else(fpasm, $1.etiqueta);

	fprintf(out, ";R51:\t<condicional> ::= if ( <exp> ) { <sentencias> } else { <sentencias> }\n");}
if_exp_sentencias: if_exp sentencias '}' {
	$$.etiqueta=$1.etiqueta;
	/*Llamamos a la funcion ensamblador*/
	fin_then(fpasm, $$.etiqueta);	
}
if_exp: TOK_IF '(' exp ')' '{' {
	if($3.tipo!=BOOLEAN) yyerror("La expresion debe ser booleana");
	$$.etiqueta=etiqueta++;

	/*Llamamos a la funcion ensamblador*/
	if_then_else(fpasm, $3.es_direccion, $$.etiqueta);
}

while : TOK_WHILE '(' {
	$$.etiqueta = etiqueta++;
	/*Ensamblador*/
	inicio_while(fpasm,$$.etiqueta);
}

while_exp : while exp ')' '{' {
		if($2.tipo!=BOOLEAN){error_semantico = 1; yyerror("while sin expresion");}
		$$.etiqueta=$1.etiqueta;
		/*Ensamblador*/
		cpm_while(fpasm,$$.etiqueta);

}

bucle : while_exp sentencias '}' {
	/*Ensamblador*/
	fin_while(fpasm,$1.etiqueta);
	/*Imprimimos traza*/
	fprintf(out, ";R52:\t<bucle> ::= while ( <exp> ) { <sentencias> }\n");}

lectura : TOK_SCANF TOK_IDENTIFICADOR {
	fprintf(out, ";R54:\t<lectura> ::= scanf <identificador>\n");
	/*Buscar el identificador en la tabla*/
	INFO_SIMBOLO *simbolo;
	simbolo = uso_global($2.lexema);
	if(!simbolo) {error_semantico = 1; yyerror("Variable sin declarar ");}
	if(simbolo->categoria == FUNCION) {error_semantico = 1; yyerror("No se puede hacer una lectura en una funcion");}
	if(simbolo->clase == VECTOR){error_semantico = 1; yyerror("No se puede hacer una lectura en un vector");}
	leer(fpasm, $2.lexema, simbolo->tipo);
	
}
escritura : TOK_PRINTF exp {
	if($2.es_direccion)
		escribir_operando(fpasm, $2.lexema, 1);
	escribir(fpasm, $2.es_direccion, $2.tipo);

	fprintf(out, ";R56:\t<escritura> ::= printf <exp>\n");}
retorno_funcion : TOK_RETURN exp {fprintf(out, ";R61:\t<retorno_funcion> ::= return <exp>\n");}
exp : exp '+' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Suma de tipos incompatibles");}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;

		
		/*Codigo ensamblador*/
		sumar(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos  'traza*/
		fprintf(out, ";R72:\t<exp> ::= <exp> + <exp>\n");}
      | exp '-' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Resta de tipos incompatibles");}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;
		
		/*Codigo ensamblador*/
		restar(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R73:\t<exp> ::= <exp> - <exp>\n");}
      | exp '/' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Division de tipos incompatibles");}
		/*COMPROBAR DIVISION POR CERO*/
		if($3.valor_entero==0 && !$3.es_direccion){error_semantico = 1; yyerror("Division entre 0"); return -1;}	
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;
		
		/*Codigo ensamblador*/
		dividir(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R74:\t<exp> ::= <exp> / <exp>\n");}
      | exp '*' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Multiplicacion de tipos incompatibles");}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;
		
		/*Codigo ensamblador*/
		multiplicar(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R75:\t<exp> ::= <exp> * <exp>\n");}
      | '-' %prec MENOSU exp {
		if($2.tipo==BOOLEAN){error_semantico = 1; yyerror("Resta de tipos incompatibles");}
		$$.tipo=$2.tipo;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		cambiar_signo(fpasm,$2.es_direccion);
		/*Imprimimos traza*/		
		fprintf(out, ";R76:\t<exp> ::= - <exp>\n");}
      | exp TOK_AND exp {
		if($1.tipo!=BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("AND de tipos incompatibles");}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		y(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R77:\t<exp> ::= <exp> && <exp>\n");}
      | exp TOK_OR exp {
		if($1.tipo!=BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("OR de tipos incompatibles");}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		o(fpasm,  $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R78:\t<exp> ::= <exp> || <exp>\n");}
      | '!' exp {
		if($2.tipo!=BOOLEAN){error_semantico = 1; yyerror("NOT de tipos incompatibles");}
		$$.tipo=$2.tipo;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		etiqueta++;
		no(fpasm, $2.es_direccion, etiqueta);
		
		/*Imprimimos traza*/
		fprintf(out, ";R79:\t<exp> ::= ! <exp>\n");}
      | TOK_IDENTIFICADOR {
		INFO_SIMBOLO *simbolo;
		simbolo = uso_global($1.lexema);
		if(!simbolo) {error_semantico = 1; yyerror("Variable sin declarar ");}
		if(simbolo->categoria == FUNCION) {error_semantico = 1; yyerror("No se puede hacer una asignacion a una funcion");}
		if(simbolo->clase == VECTOR){error_semantico = 1; yyerror("No se puede hacer una asignacion a un vector");}

		$$.tipo = simbolo->tipo;
		$$.es_direccion = 1;

		/*Codigo ensamblador*/
		escribir_operando(fpasm, $1.lexema, 1);
		/*Imprimimos traza*/
		fprintf(out, ";R80:\t<exp> ::= <identificador>\n");}
      | constante {
		$$.tipo = $1.tipo;
  		$$.es_direccion = $1.es_direccion;
		
		/*Imprimimos traza*/
		fprintf(out, ";R81:\t<exp> ::= <constante>\n");}
      | '(' exp ')' {
		$$.tipo = $2.tipo;
  		$$.es_direccion = $2.es_direccion;

		/*Imprimimos traza*/
		fprintf(out, ";R82:\t<exp> ::= ( <exp> )\n");}
      | '(' comparacion ')' {
		$$.tipo = $2.tipo;
  		$$.es_direccion = $2.es_direccion;

		/*Imprimimos traza*/
		fprintf(out, ";R83:\t<exp> ::= ( <comparacion> )\n");}
      | elemento_vector {
		$$.tipo = $1.tipo;
  		$$.es_direccion = $1.es_direccion;
		/*Imprimimos traza*/
		fprintf(out, ";R85:\t<exp> ::= <elemento_vector>\n");}
      | identificador '(' lista_expresiones ')' {fprintf(out, ";R88:\t<exp> ::= <identificador> ( <lista_expresiones> )\n");}
lista_expresiones : exp resto_lista_expresiones {fprintf(out, ";R89:\t<lista_expresiones> ::= <exp> <resto_lista_expresiones>\n");}
                    | /**/ {fprintf(out, ";R90:\t<lista_expresiones> ::= \n");}
resto_lista_expresiones : ',' exp resto_lista_expresiones {fprintf(out, ";R91:\t<resto_lista_expresiones> ::= , <exp> <resto_lista_expresiones> \n");}
                          | /**/ {fprintf(out, ";R92:\t<resto_lista_expresiones> ::= \n");}
comparacion : exp TOK_IGUAL exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion de tipos incompatibles");}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		etiqueta++;
		es_igual(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/
		
		fprintf(out, ";R93:\t<comparacion> ::= <exp> == <exp>\n");}
              | exp TOK_DISTINTO exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion de tipos incompatibles");}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero != $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_distinto(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/		
		fprintf(out, ";R94:\t<comparacion> ::= <exp> != <exp>\n");}
              | exp TOK_MENORIGUAL exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion de tipos incompatibles");}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero <= $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_menor_o_igual(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/		
		fprintf(out, ";R95:\t<comparacion> ::= <exp> <= <exp>\n");}
              | exp TOK_MAYORIGUAL exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion de tipos incompatibles");}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero >= $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_mayor_o_igual(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/		
		fprintf(out, ";R96:\t<comparacion> ::= <exp> >= <exp>\n");}
              | exp '<' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion de tipos incompatibles");}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero < $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_menor(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/		
		fprintf(out, ";R97:\t<comparacion> ::= <exp> < <exp>\n");}
              | exp '>' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion de tipos incompatibles");}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero > $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_mayor(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/
		fprintf(out, ";R98:\t<comparacion> ::= <exp> > <exp>\n");}
constante : constante_logica {
	$$.tipo = BOOLEAN;
	$$.es_direccion = 0;/*VER en el enunciado pone: $$.es_direccion =$1.es_direccion*/
	$$.valor_entero = $1.valor_entero;
	
	/*Imprimimos traza*/	
	fprintf(out, ";R99:\t<constante> ::= <constante_logica>\n");}
            | constante_entera {
	$$.tipo = INT;
	$$.es_direccion = 0;/*VER en el enunciado pone: $$.es_direccion =$1.es_direccion*/
	$$.valor_entero = $1.valor_entero;
	
	
	/*Imprimimos traza*/	
	fprintf(out, ";R100:\t<constante> ::= <constante_entera>\n");}
constante_logica : TOK_TRUE {
	$$.tipo = BOOLEAN;
	$$.es_direccion = 0;
	$$.valor_entero = 1;

	/*Metemos la constante en la pila*/
	escribir_operando(fpasm, "1", 0);

	/*Imprimimos traza*/
	fprintf(out, ";R102:\t<constante_logica> ::= true\n");}
                   | TOK_FALSE {
	$$.tipo = BOOLEAN;
	$$.es_direccion = 0;
	$$.valor_entero = 0;
	/*Metemos la constante en la pila*/
	escribir_operando(fpasm, "0", 0);
	/*Imprimimos traza*/
	fprintf(out, ";R103:\t<constante_logica> ::= false\n");}
constante_entera: TOK_CONSTANTE_ENTERA {
	char valor[16];
	/*Codigo semantico para las constantes*/
	$$.tipo = INT;
  	$$.es_direccion = 0;
  	$$.valor_entero = $1.valor_entero;
	sprintf(valor, "%d", $1.valor_entero);
	/*Metemos la constante en la pila*/
	escribir_operando(fpasm, valor, 0);
	fprintf(out, ";R104:\t<constante_entera> ::= TOK_CONSTANTE_ENTERA\n");
}
identificador : TOK_IDENTIFICADOR {
	if(declarar_global($1.lexema, VARIABLE, tipo_actual, clase_actual,
	tamanio_vector_actual, 0, 0, 0, 0)==ERR){
		error_semantico = 1;
		yyerror("Identificador ya declarado");
	} else {
		fprintf(out, ";R108:\t<identificador> ::= TOK_IDENTIFICADOR\n");
	}
}
%%
