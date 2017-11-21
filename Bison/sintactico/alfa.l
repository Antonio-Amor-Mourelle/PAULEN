%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>

#define TOK_ERROR -1
int error_morfologico = 0;
int fila=1, columna=1;
extern FILE* out;
%}

%option noyywrap

%%

main {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_MAIN;}
array {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_ARRAY;}
int {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_INT;}
boolean {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_BOOLEAN;}
function {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_FUNCTION;}
if {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_IF;}
else {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_ELSE;}
while {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_WHILE;}
"true" {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_TRUE;}
"false" {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_FALSE;}
scanf {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_SCANF;}
printf {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_PRINTF;}
"return" {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_RETURN;}
";" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"(" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
")" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"[" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"]" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"{" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"}" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"=" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"*" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"+" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"-" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"/" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"&&" {fprintf(out, ";D:\t%s\n", yytext); columna+=2;return TOK_AND;}
"||" {fprintf(out, ";D:\t%s\n", yytext); columna+=2; return TOK_OR;}
"==" {fprintf(out, ";D:\t%s\n", yytext); columna+=2; return TOK_IGUAL;}
"!=" {fprintf(out, ";D:\t%s\n", yytext); columna+=2; return TOK_DISTINTO;}
"!" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"," {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"<=" {fprintf(out, ";D:\t%s\n", yytext); columna+=2; return TOK_MENORIGUAL;}
">=" {fprintf(out, ";D:\t%s\n", yytext); columna+=2; return TOK_MAYORIGUAL;}
"<" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
">" {fprintf(out, ";D:\t%s\n", yytext); columna++; return yytext[0];}
"//".*\n {fila++; columna=1;}
\n {fila++; columna=1;}
[ \t] {columna++;}
([0-9])+ {fprintf(out, ";D:\t%s\n", yytext); columna+=yyleng; return TOK_CONSTANTE_ENTERA;}
[A-Za-z]([A-Za-z0-9])* {if(yyleng > 100){
				error_morfologico = 1; 
				fprintf(stderr, "\t****Error en [lin %d, col %d]: identificador demasiado largo (%s)\n", fila, columna, yytext); 
				return TOK_ERROR;
			} 
			fprintf(out, ";D:\t%s\n", yytext); 
			columna+=yyleng; 
			return TOK_IDENTIFICADOR;}
. {error_morfologico = 1; fprintf(stderr, "\t****Error en [lin %d, col %d]: simbolo no permitido (%s)\n", fila, columna, yytext); return TOK_ERROR;}
%%
