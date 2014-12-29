%option noyywrap
%{
#include <stdio.h>
#define YY_DECL extern int yylex()
#include "ec.tab.h"
%}

%%

"=" { return '='; }
";" { return ';'; }
"+" { return '+'; }
"-" { return '-'; }
"/" { return '/'; }
"*" { return '+'; }
"(" { return '('; }
")" { return ')'; }
":" { return ':'; }
"," { return ','; }
"for" { return FOR; }
"write:" { return WRITE; }
"<"|"<="|">"|">="|"&&"|"||" { yylval.sval = strdup(yytext); return LOGICAL; }
[0-9]+ { yylval.sval = strdup(yytext); return FLOAT; }
[0-9]+"."[0-9]* { yylval.sval = strdup(yytext); return FLOAT; }
"."[0-9]+ { yylval.sval = strdup(yytext); return FLOAT; }
d { return DERIVATIVE;}
[a-ce-zA-Z][a-zA-Z]* { yylval.sval = strdup(yytext); return IDENTIFIER;}
[ \t\n]   ;
.         {printf("Unrecognized char: %s\n", yytext);}

%%
