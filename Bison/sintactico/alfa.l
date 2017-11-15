%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>

int fila=1, columna=1;
%}

%option noyywrap

%%

main {columna+=yyleng; return TOK_MAIN;}
array columna+=yyleng; {return TOK_ARRAY;}
int {columna+=yyleng; return TOK_INT;}
boolean {columna+=yyleng; return TOK_BOOLEAN;}
function {columna+=yyleng; return TOK_FUNCTION;}
if {columna+=yyleng; return TOK_IF;}
else {columna+=yyleng; return TOK_ELSE;}
while {columna+=yyleng; return TOK_WHILE;}
"true" {columna+=yyleng; return TOK_TRUE;}
"false" {columna+=yyleng; return TOK_FALSE;}
scanf {columna+=yyleng; return TOK_SCANF;}
printf {columna+=yyleng; return TOK_PRINTF;}
"return" {columna+=yyleng; return TOK_RETURN;}
";" {columna++; return TOK_PUNTOYCOMA;}
"(" {columna++; return TOK_PARENTESISIZQUIERDO;}
")" {columna++; return TOK_PARENTESISDERECHO;}
"[" {columna++; return TOK_CORCHETEIZQUIERDO;}
"]" {columna++; return TOK_CORCHETEDERECHO;}
"{" {columna++; return TOK_LLAVEIZQUIERDA;}
"}" {columna++; return TOK_LLAVEDERECHA;}
"=" {columna++; return TOK_ASIGNACION;}
"*" {columna++; return TOK_ASTERISCO;}
"+" {columna++; return TOK_MAS;}
"-" {columna++; return TOK_MENOS;}
"/" {columna++; return TOK_DIVISION;}
"&&" {columna+=2;return TOK_AND;}
"||" {columna+=2; return TOK_OR;}
"==" {columna+=2; return TOK_IGUAL;}
"!=" {columna+=2; return TOK_DISTINTO;}
"!" {columna++; return TOK_NOT;}
"," {columna++; return TOK_COMA;}
"<=" {columna+=2; return TOK_MENORIGUAL;}
">=" {columna+=2; return TOK_MAYORIGUAL;}
"<" {columna++; return TOK_MENOR;}
">" {columna++; return TOK_MAYOR;}
"//".*\n {fila++; columna=1;}
\n {fila++; columna=1;}
[ \t] {columna++;}
[0-9]([0-9])* {columna+=yyleng; return TOK_CONSTANTE_ENTERA;}
[A-Za-z]([A-Za-z0-9])* {if(yyleng > 100) return TOK_ERRORLONGITUD; columna+=yyleng; return TOK_IDENTIFICADOR;}
. {return TOK_ERROR;}
%%
