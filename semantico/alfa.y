%{
#define _GNU_SOURCE
#include "alfa.h"
#include "tablaSimbolos.h"
#include "generacion.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
extern int yylex();
extern char* yytext;
extern int yyleng;
extern FILE* out;
extern FILE* fpasm;
extern int error_morfologico;
extern int fila;
extern int columna;

char *cadaux;

int error_semantico = 0;
int tipo_actual; /*Entero o booleano*/
int clase_actual; /*Escalar o vector*/
int tamanio_vector_actual = 0; /*Tamanno de un vector*/

int pos_variable_local_actual=1; /*Posicion de una variable local en su declaracion*/
int num_variables_locales_actual=0; /*numero de variables locales de una funcion*/ 
int num_parametros_actual=0;/*numero de parametros de una funcion*/
int pos_parametro_actual=0; /*posicion del parametro actual*/
int tipo_funcion_actual; /*Tipo de la funcion para la comprobacion de tipo de retorno*/

int num_return;

int en_explist = 0; /*Controla si una variable se pasa como parametro a una funcion, ya
		que el convenio de llamadas exige pasar los argumentos por valor*/
int num_parametros_llamada_actual = 0; /*Para saber si los parametros de una funcion son los
		mismos declarados en la tabla de simbolos*/


int ambito_local=0;/* FLAG del ambito local, 1 si estamos en el ambito local*/

int etiqueta = 0; /*Variable que cuenta el numero de etiquetas ensamblador para los saltos*/

void yyerror(char *s){
	if(!error_morfologico && !error_semantico)
		fprintf(stderr, "****Error sintactico en [lin %d, col %d]\n", fila, columna-yyleng);
	else if(error_semantico)
		fprintf(stderr, "****Error semantico en lin %d: %s\n",fila, s);

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
%type <atributos> idf_llamada

%type <atributos> while
%type <atributos> while_exp

%type <atributos> idpf
%type <atributos> fn_name
%type <atributos> fn_declaration



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
	if (($4.valor_entero < 1 ) || ($4.valor_entero > MAX_TAMANIO_VECTOR)){
		error_semantico=1;
		/*TODO CAMBIAR COMPROBACION DE SITIO*/
		asprintf(&cadaux,"El tamanyo del vector excede los limites permitidos(1,%d)", MAX_TAMANIO_VECTOR);
		yyerror(cadaux);
		free(cadaux);
		return -1;
	 } else {
		/*Propagacion de atributos semanticos*/
		tamanio_vector_actual = $4.valor_entero;
		fprintf(out, ";R15:<clase_vector> ::= array <tipo> [ <constante_entera> ]\t\n");
	}
}
identificadores : identificador {fprintf(out, ";R18:\t<identificadores> ::= <identificador>\n");}
                  | identificador','identificadores {fprintf(out, ";R19:\t<identificadores> ::= <identificador> , <identificadores>\n");}
funciones : funcion funciones {fprintf(out, ";R20:\t<funciones> ::= <funcion> <funciones>\n");}
            | {fprintf(out, ";R21:\t<funciones> ::= \n");}
fn_name : TOK_FUNCTION tipo TOK_IDENTIFICADOR {
	strcpy($$.lexema,$3.lexema);
	/*codigo declarar funcion*/
	/*seteamos variables globales*/
	num_variables_locales_actual=0;
	pos_variable_local_actual=1;
	num_parametros_actual=0;
	pos_parametro_actual=0;
	num_return=0;
	/*insertamos la nueva funcion, pero falta cambiar algunos parametros*/
	if(declarar_funcion($$.lexema, FUNCION, tipo_actual, ESCALAR, 0, 
			num_variables_locales_actual, pos_variable_local_actual,
			 num_parametros_actual, pos_parametro_actual)==ERR){
		error_semantico=1;yyerror("Declaracion duplicada.");return -1;
	}
	/*nos situamos en el ambito local*/
	ambito_local=1;
	tipo_funcion_actual = tipo_actual;
	
}
fn_declaration : fn_name '(' parametros_funcion ')' '{' declaraciones_funcion {
	strcpy($$.lexema,$1.lexema);	
	INFO_SIMBOLO *simbolo;
	/*actualizamos en la tabla local*/
	simbolo = uso_local($$.lexema);
	simbolo->num_params=num_parametros_actual;
	/*actualizamos en la tabla global*/
	simbolo = uso_global($$.lexema);
	simbolo->num_params=num_parametros_actual;
	
	/*codigo ensamblador*/
	inicio_declarar_funcion(fpasm, $$.lexema, num_variables_locales_actual);
}
funcion : fn_declaration sentencias '}' {
	/*cerramos la tabla de simbolos local*/
	INFO_SIMBOLO *simbolo;
	simbolo = uso_local($1.lexema);
	simbolo->num_variables=num_variables_locales_actual;
	simbolo = uso_global($1.lexema);
	simbolo->num_variables=num_variables_locales_actual;
	ambito_local=0;
	fin_funcion();
	/*comprobar numero de retornos > 0*/
	if(num_return==0){
		asprintf(&cadaux,"Funcion %s sin sentencia de retorno.",$1.lexema);
		error_semantico=1;
		yyerror(cadaux);
		free(cadaux);
		return -1;	
	}
	/*codigo ensamblador*/
	/*imprimimos traza*/
	fprintf(out, ";R22:\t<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }\n");
	
}

parametros_funcion : parametro_funcion resto_parametros_funcion {fprintf(out, ";R23:\t<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n");}
                     | {fprintf(out, ";R24:\t<parametros_funcion> ::= \n");}
resto_parametros_funcion : ';' parametro_funcion resto_parametros_funcion {
	fprintf(out, ";R25:\t<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>\n");
}
                           | {fprintf(out, ";R26:\t<resto_parametros_funcion> ::= \n");}
parametro_funcion : tipo idpf {fprintf(out, ";R27:\t<parametro_funcion> ::= <tipo> <identificador>\n");
}
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
		if(ambito_local)
			simbolo =  uso_local($1.lexema);
		else 
			simbolo = uso_global($1.lexema);
		if(!simbolo) {
			error_semantico = 1; 
			asprintf(&cadaux, "Acceso a variable no declarada (%s).",$1.lexema);
			yyerror(cadaux);
			free(cadaux);
			return -1;}
		if(simbolo->categoria == FUNCION) {error_semantico = 1; yyerror("Asignacion incompatible.");return -1;}
		if(simbolo->clase == VECTOR){error_semantico = 1; yyerror("Asignacion incompatible.");return -1;}
		if(simbolo->tipo != $3.tipo){error_semantico = 1; yyerror("Asignacion incompatible.");return -1;}
		
		/*Codigo ensamblador*/
		if(simbolo->categoria == PARAMETRO)
			asignar_parametro(fpasm, num_parametros_actual, simbolo->pos_param, $3.es_direccion);
		else if(simbolo->pos_variable)
			asignar_variable_local(fpasm, simbolo->pos_variable, $3.es_direccion);
		else 
			asignar(fpasm, $1.lexema, $3.es_direccion);
	
		fprintf(out, ";R43:\t<asignacion> ::= <identificador> = <exp>\n");}
             | elemento_vector '=' exp {
	/*Comprobaciones semanticas*/
	if($1.tipo != $3.tipo){
		error_semantico = 1;
		yyerror("Asignacion incompatible.");
		return -1;		
	}
	/*TODO asignar en ensamblador*/
	asignar_vector(fpasm, $3.es_direccion);

	fprintf(out, ";R44:\t<asignacion> ::= <elemento_vector> = <exp>\n");
}
elemento_vector : TOK_IDENTIFICADOR '[' exp ']'  {
	/*TODO*/
	/*Buscamos el identificador en la tabla de simbolos. Solo se busca en la global porque no 
	se permite declarar vectores dentro de una funcion*/
	INFO_SIMBOLO *simbolo;	
	simbolo = uso_global($1.lexema);
	if(!simbolo) {
		error_semantico = 1;
		asprintf(&cadaux, "Acceso a variable no declarada (%s).",$1.lexema);
		yyerror(cadaux);
		free(cadaux);
		return -1;
	}
	if($3.tipo != INT){
		error_semantico = 1;
		yyerror("El indice en una operacion de indexacion tiene que ser de tipo entero.");
		return -1;
	}
	if(simbolo->clase != VECTOR){
		error_semantico = 1;
		yyerror("Intento de indexacion de una variable que no es de tipo vector.");
		return -1;
	}
	$$.tipo = simbolo->tipo;
	$$.es_direccion = 1;
	/*TODO generar el codigo ensamblador que comprueba que se accede al vector en el limite permitido*/
	/*Metemos el elemento vector en la pila*/
	escribir_elemento_vector(fpasm, $1.lexema, $3.es_direccion, simbolo->tamano, en_explist);
	fprintf(out, ";R48:\t<elemento_vector> ::= <identificador> [ <exp> ]\n");
}
condicional : if_exp_sentencias {fin_if_else(fpasm, $1.etiqueta); fprintf(out, ";R50:\t<condicional> ::= if ( <exp> ) { <sentencias> }\n");}
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
	if($3.tipo!=BOOLEAN){ error_semantico=1;yyerror("Condicional con condicion del tipo int.");return -1;}
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
		if($2.tipo!=BOOLEAN){error_semantico = 1; yyerror("Bucle con condicion de tipo int."); return -1;}
		$$.etiqueta=$1.etiqueta;
		/*Ensamblador*/
		cmp_while(fpasm,$2.es_direccion,$$.etiqueta);

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
	if(ambito_local)
		simbolo = uso_local($2.lexema);
	else 
		simbolo = uso_global($2.lexema);
	if(!simbolo) {
		error_semantico = 1;
		asprintf(&cadaux, "Acceso a variable no declarada (%s).",$2.lexema);
		yyerror(cadaux);
		free(cadaux);
		return -1;
	}
	if(simbolo->categoria == FUNCION) {error_semantico = 1; yyerror("Variable local de tipo no escalar.");return -1;}
	if(simbolo->clase == VECTOR){error_semantico = 1; yyerror("Variable local de tipo no escalar.");return -1;}

	if(simbolo->categoria == PARAMETRO)
		leer_parametro(fpasm, num_parametros_actual, simbolo->pos_param, simbolo->tipo);
	else if(simbolo->pos_variable != 0)
		leer_variable_local(fpasm, simbolo->pos_variable, simbolo->tipo);
	else 
		leer(fpasm, $2.lexema, simbolo->tipo);
}
escritura : TOK_PRINTF exp {
	/*PREGUNTAR si esto es necesario*/
/*
	if($2.es_direccion)
		escribir_operando(fpasm, $2.lexema, 1, 0);
*/
	/**/
	escribir(fpasm, $2.es_direccion, $2.tipo);

	fprintf(out, ";R56:\t<escritura> ::= printf <exp>\n");}
retorno_funcion : TOK_RETURN exp {
		/*solo puede haber retornos dentro de funciones*/		
		if(!ambito_local){
			error_semantico=1;
			yyerror("Sentencia de retorno fuera del cuerpo de una funcion.");
			return -1;
		}
		if(tipo_funcion_actual != $2.tipo){
			error_semantico=1;
			yyerror("Asignacion incompatible.");
			return -1;
		}
		num_return++;
		/*Codigo ensamblador*/
		fin_declarar_funcion(fpasm, $2.es_direccion);
		/* Imprimimos la traza*/		
		fprintf(out, ";R61:\t<retorno_funcion> ::= return <exp>\n");}
exp : exp '+' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Operacion aritmetica con operandos boolean.");return -1;}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;

		
		/*Codigo ensamblador*/
		sumar(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos  'traza*/
		fprintf(out, ";R72:\t<exp> ::= <exp> + <exp>\n");}
      | exp '-' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Operacion aritmetica con operandos boolean.");return -1;}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;
		
		/*Codigo ensamblador*/
		restar(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R73:\t<exp> ::= <exp> - <exp>\n");}
      | exp '/' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Operacion aritmetica con operandos boolean.");return -1;}	
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;
		
		/*Codigo ensamblador*/
		dividir(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R74:\t<exp> ::= <exp> / <exp>\n");}
      | exp '*' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Operacion aritmetica con operandos boolean.");return -1;}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;
		
		/*Codigo ensamblador*/
		multiplicar(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R75:\t<exp> ::= <exp> * <exp>\n");}
      | '-' %prec MENOSU exp {
		if($2.tipo==BOOLEAN){error_semantico = 1; yyerror("Operacion aritmetica con operandos boolean.");return -1;}
		$$.tipo=$2.tipo;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		cambiar_signo(fpasm,$2.es_direccion);
		/*Imprimimos traza*/		
		fprintf(out, ";R76:\t<exp> ::= - <exp>\n");}
      | exp TOK_AND exp {
		if($1.tipo!=BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Operacion logica con operandos int.");return -1;}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		y(fpasm, $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R77:\t<exp> ::= <exp> && <exp>\n");}
      | exp TOK_OR exp {
		if($1.tipo!=BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Operacion logica con operandos int.");return -1;}
		$$.tipo=$1.tipo;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		o(fpasm,  $1.es_direccion, $3.es_direccion);
		/*Imprimimos traza*/
		fprintf(out, ";R78:\t<exp> ::= <exp> || <exp>\n");}
      | '!' exp {
		if($2.tipo!=BOOLEAN){error_semantico = 1; yyerror("Operacion logica con operandos int.");return -1;}
		$$.tipo=$2.tipo;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		etiqueta++;
		no(fpasm, $2.es_direccion, etiqueta);
		
		/*Imprimimos traza*/
		fprintf(out, ";R79:\t<exp> ::= ! <exp>\n");}
      | TOK_IDENTIFICADOR {
		/*TODO: cuidado al escribir el operando, distinguir entre 3 casos, variable global, 
		variable local o parametro de funcion*/
		INFO_SIMBOLO *simbolo;
		if(ambito_local){
			simbolo = uso_local($1.lexema);
		} else {
			simbolo = uso_global($1.lexema);
		}
		if(!simbolo) {
			error_semantico = 1;
			asprintf(&cadaux, "Acceso a variable no declarada (%s).",$1.lexema);
			yyerror(cadaux);
			free(cadaux);
			return -1;
		}
		if(simbolo->categoria == FUNCION) {error_semantico = 1; yyerror("Variable local de tipo no escalar.");return -1;}
		if(simbolo->clase == VECTOR){error_semantico = 1; yyerror("Variable local de tipo no escalar.");return -1;}
		/*Codigo ensamblador*/
		/*Comprobamos si el simbolo es un parametro*/
		if(simbolo->categoria == PARAMETRO){
			escribir_parametro(fpasm, num_parametros_actual, simbolo->pos_param);
			$$.es_direccion = 0;
		} else if (simbolo->pos_variable) {	
			escribir_variable_local(fpasm, simbolo->pos_variable);
			$$.es_direccion = 0;
		} else {
			escribir_operando(fpasm, $1.lexema, 1, en_explist);
			$$.es_direccion = 1;
		}
			
		$$.tipo = simbolo->tipo;
		

		
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
      | idf_llamada '(' lista_expresiones ')' {
	INFO_SIMBOLO *simbolo;
	char *cadaux;
	/*Comprobar que el identificador esta en la tabla de simbolos*/
	simbolo = uso_global($1.lexema);
	if(!simbolo){
		asprintf(&cadaux, "Acceso a variable no declarada (%s).",$1.lexema);
		error_semantico = 1;
		yyerror(cadaux);
		free(cadaux);
		return -1;
	}
	if(simbolo->categoria != FUNCION){
		error_semantico = 1;
		yyerror("Asignacion incompatible");
		return -1;
	}
	if(simbolo->num_params != num_parametros_llamada_actual){
		error_semantico = 1;
		yyerror("Numero incorrecto de parametros en llamada a funcion.");
		return -1;		
	}

	$$.tipo = simbolo->tipo;
	$$.es_direccion = 0;
	en_explist =0;
	/*Codigo ensamblador*/
	llamada_funcion(fpasm, $1.lexema, simbolo->num_params);
	
	fprintf(out, ";R88:\t<exp> ::= <identificador> ( <lista_expresiones> )\n");
}
idf_llamada : TOK_IDENTIFICADOR {
	if(en_explist){
		error_semantico = 1;
		yyerror("No esta permitido el uso de llamadas a funciones como parametros de otras funciones.");
		return -1;			
	}
	en_explist = 1;
	num_parametros_llamada_actual = 0;
	strcpy($$.lexema, $1.lexema); 
}
lista_expresiones : exp resto_lista_expresiones {num_parametros_llamada_actual++; fprintf(out, ";R89:\t<lista_expresiones> ::= <exp> <resto_lista_expresiones>\n");}
                    | /**/ {fprintf(out, ";R90:\t<lista_expresiones> ::= \n");}
resto_lista_expresiones : ',' exp resto_lista_expresiones {num_parametros_llamada_actual++; fprintf(out, ";R91:\t<resto_lista_expresiones> ::= , <exp> <resto_lista_expresiones> \n");}
                          | /**/ {fprintf(out, ";R92:\t<resto_lista_expresiones> ::= \n");}
comparacion : exp TOK_IGUAL exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion con operandos boolean.");return -1;}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;

		/*Codigo ensamblador*/
		etiqueta++;
		es_igual(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/
		
		fprintf(out, ";R93:\t<comparacion> ::= <exp> == <exp>\n");}
              | exp TOK_DISTINTO exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion con operandos boolean.");return -1;}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero != $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_distinto(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/		
		fprintf(out, ";R94:\t<comparacion> ::= <exp> != <exp>\n");}
              | exp TOK_MENORIGUAL exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion con operandos boolean.");return -1;}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero <= $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_menor_o_igual(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/		
		fprintf(out, ";R95:\t<comparacion> ::= <exp> <= <exp>\n");}
              | exp TOK_MAYORIGUAL exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion con operandos boolean.");return -1;}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero >= $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_mayor_o_igual(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/		
		fprintf(out, ";R96:\t<comparacion> ::= <exp> >= <exp>\n");}
              | exp '<' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion con operandos boolean.");return -1;}
		$$.tipo=BOOLEAN;
		$$.es_direccion = 0;
		$$.valor_entero=$1.valor_entero < $3.valor_entero;
		/*Codigo ensamblador*/
		etiqueta++;
		es_menor(fpasm, $1.es_direccion, $3.es_direccion, etiqueta);
		/*Imprimimos traza*/		
		fprintf(out, ";R97:\t<comparacion> ::= <exp> < <exp>\n");}
              | exp '>' exp {
		if($1.tipo==BOOLEAN || $1.tipo != $3.tipo){error_semantico = 1; yyerror("Comparacion con operandos boolean.");return -1;}
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
	escribir_operando(fpasm, "1", 0, 0);

	/*Imprimimos traza*/
	fprintf(out, ";R102:\t<constante_logica> ::= true\n");}
                   | TOK_FALSE {
	$$.tipo = BOOLEAN;
	$$.es_direccion = 0;
	$$.valor_entero = 0;
	/*Metemos la constante en la pila*/
	escribir_operando(fpasm, "0", 0, 0);
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
	escribir_operando(fpasm, valor, 0, 0);
	fprintf(out, ";R104:\t<constante_entera> ::= TOK_CONSTANTE_ENTERA\n");
}
idpf : TOK_IDENTIFICADOR{
	/*declaramos el parametro en la tabla local*//*como es parametro, solo interesa la pos*/
	if(declarar_local($1.lexema, PARAMETRO, tipo_actual, ESCALAR,0, 0, 0, 0, pos_parametro_actual)==ERR){
		error_semantico = 1;
		yyerror("Declaracion duplicada.");
		return -1;
	}
	
	/*aumentamos el numero de variables*/	
	num_parametros_actual++;
	pos_parametro_actual++;

}
identificador : TOK_IDENTIFICADOR {
	if(ambito_local){
		if(clase_actual == VECTOR){
			error_semantico = 1;
			yyerror("Variable local de tipo no escalar.");
			return -1;
		}
		if(declarar_local($1.lexema, VARIABLE, tipo_actual, ESCALAR, 
		0, 0, pos_variable_local_actual, 0, 0) == ERR){
			error_semantico = 1;
			yyerror("Declaracion duplicada.");
			return -1;
		}

		pos_variable_local_actual++;
		num_variables_locales_actual++;		
		
	} else {
		if(declarar_global($1.lexema, VARIABLE, tipo_actual, clase_actual,
		tamanio_vector_actual, 0, 0, 0, 0)==ERR){
			error_semantico = 1;
			yyerror("Declaracion duplicada.");
			return -1;
		}
			
	}
	fprintf(out, ";R108:\t<identificador> ::= TOK_IDENTIFICADOR\n");
}
%%

