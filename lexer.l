%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

digit     [0-9]
letter    [a-zA-Z]
ident     {letter}({letter}|{digit}|_)*
string    \"([^\"\n])*\"
char      \'[a-zA-Z]\'

%%

"int"           { return INT; }
"float"         { return FLOAT; }
"char"          { return CHAR; }
"bool"          { return BOOL; }
"for"           { return FOR; }
"while"         { return WHILE; }
"print"         { return PRINT; }
"scan"          { return SCAN; }
"true"          { return TRUE; }
"false"         { return FALSE; }
"if"            { return IF; }
"else if"       { return ELSEIF; }
"else"          { return ELSE; }

{ident}         { yylval.sval = strdup(yytext); return IDENT; }
{digit}+        { yylval.sval = strdup(yytext); return NUMBER; }
{string}        { yylval.sval = strdup(yytext); return STRING; }
{char}          { yylval.sval = strdup(yytext); return CHAR_LITERAL; }

"=="            { return EQ; }
"!="            { return NEQ; }
"<="            { return LE; }
">="            { return GE; }
"<"             { return LT; }
">"             { return GT; }

"="             { return ASSIGN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }

";"             { return SEMI; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }

[ \t\r\n]+      ;

.               { printf("Unknown char: %s\n", yytext); }

%%

int yywrap() { return 1; }