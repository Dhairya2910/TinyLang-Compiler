%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

DIGIT   [0-9]
INT     {DIGIT}+
ID      [A-Za-z_][A-Za-z0-9_]*

%%

"else if"       { return ELSEIF; }
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"for"           { return FOR; }

"=="            { return EQ; }
"!="            { return NEQ; }
">="            { return GE; }
"<="            { return LE; }
">"             { return GT; }
"<"             { return LT; }
"="             { return ASSIGN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }

"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
";"             { return SEMICOLON; }

{INT}           { yylval.ival = atoi(yytext); return NUMBER; }
{ID}            { yylval.sval = strdup(yytext); return IDENTIFIER; }

[ \t\n]+        { /* skip */ }
.               { return UNKNOWN; }
%%
