%{
    // C/C++ code (headers, includes)
    #include <stdio.h>
    #include "y.tab.h"   // needed later when using Bison
%}

%%
[0-9]+          { return NUMBER; }        // integers
"let"           { return LET; }           // keyword
"print"         { return PRINT; }
[a-zA-Z_][a-zA-Z0-9_]*  { return ID; }    // variable names
"="             { return ASSIGN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }
";"             { return SEMICOLON; }
[ \t\n]         { /* ignore whitespace */ }
.               { printf("Unknown char: %s\n", yytext); }
%%

int yywrap() { return 1; }
