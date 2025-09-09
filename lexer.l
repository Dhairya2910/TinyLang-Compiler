%{
#include "parser.tab.h"   // include Bison’s definitions
#include <stdlib.h>
#include <string.h>
%}

%%
"let"           { return LET; }
"="             { return ASSIGN; }
";"             { return SEMICOLON; }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.id = strdup(yytext); return ID; }
[ \t\n]+        ;  // skip whitespace
.               { return yytext[0]; }
%%

