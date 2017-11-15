%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>

extern FILE* out;
int f;
%}

%option noyywrap

%%
"(" {fprintf(out, "TOKEN: (\n"); return yytext[0];}
")" {fprintf(out, "TOKEN: )\n"); return yytext[0];}
"*" {fprintf(out, "TOKEN: *\n"); return yytext[0];}
"+" {fprintf(out, "TOKEN: +\n");return yytext[0];}
"-" {fprintf(out, "TOKEN: -\n");return yytext[0];}
"/" {fprintf(out, "TOKEN: /\n");return yytext[0];}
"//".*\n {}
\n {}
[ \t] {}
([0-9])+ {fprintf(out, "TOKEN: %s\n", yytext);return TOK_CONSTANTE_ENTERA;}
([0-9])+"."([0-9])+ {fprintf(out, "TOKEN: %s\n", yytext);return TOK_CONSTANTE_REAL;}
. {f = 1; fprintf(out, "ERROR MORFOLOGICO\n"); return TOK_ERROR;}
%%
