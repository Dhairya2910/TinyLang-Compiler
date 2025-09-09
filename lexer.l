%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%
"let"           { return LET; }
"="             { return ASSIGN; }
";"             { return SEMICOLON; }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.id = strdup(yytext); return ID; }
[ \t\n]+        ;
.               { return yytext[0]; }
%%
