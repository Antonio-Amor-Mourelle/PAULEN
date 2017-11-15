%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>
#define TOK_ERROR -1
int error_morfologico = 0;
int error_longitud = 0;
int fila=1, columna=1;
%}

%option noyywrap

%%

main {columna+=yyleng; return yytext;}
array columna+=yyleng; {return yytext;}
int {columna+=yyleng; return yytext;}
boolean {columna+=yyleng; return yytext;}
function {columna+=yyleng; return yytext;}
if {columna+=yyleng; return yytext;}
else {columna+=yyleng; return yytext;}
while {columna+=yyleng; return yytext;}
"true" {columna+=yyleng; return yytext;}
"false" {columna+=yyleng; return yytext;}
scanf {columna+=yyleng; return yytext;}
printf {columna+=yyleng; return yytext;}
"return" {columna+=yyleng; return yytext;}
";" {columna++; return yytext[0];}
"(" {columna++; return yytext[0];}
")" {columna++; return yytext[0];}
"[" {columna++; return yytext[0];}
"]" {columna++; return yytext[0];}
"{" {columna++; return yytext[0];}
"}" {columna++; return yytext[0];}
"=" {columna++; return yytext[0];}
"*" {columna++; return yytext[0];}
"+" {columna++; return yytext[0];}
"-" {columna++; return yytext[0];}
"/" {columna++; return yytext[0];}
"&&" {columna+=2;return yytext;}
"||" {columna+=2; return yytext;}
"==" {columna+=2; return yytext;}
"!=" {columna+=2; return yytext;}
"!" {columna++; return yytext[0];}
"," {columna++; return yytext[0];}
"<=" {columna+=2; return yytext;}
">=" {columna+=2; return yytext;}
"<" {columna++; return yytext[0];}
">" {columna++; return yytext[0];}
"//".*\n {fila++; columna=1;}
\n {fila++; columna=1;}
[ \t] {columna++;}
([0-9])+ {columna+=yyleng; return TOK_CONSTANTE_ENTERA;}
[A-Za-z]([A-Za-z0-9])* {if(yyleng > 100){error_longitud = 1; return TOK_ERRORLONGITUD;} columna+=yyleng; return TOK_IDENTIFICADOR;}
. {error_morfologico = 1; return TOK_ERROR;}
%%
