%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declare yylex
int yylex();
void yyerror(const char *s);
%}

/* Define tokens */
%token NUMBER ID LET ASSIGN SEMICOLON

/* Define YYSTYPE union */
%union {
    int num;
    char* id;
}

/* Associate types with tokens */
%type <num> NUMBER
%type <id> ID

%%

program:
    program stmt
  | /* empty */
  ;

stmt:
    LET ID ASSIGN expr SEMICOLON   { printf("Assign %s = expr\n", $2); free($2); }
  ;

expr:
    NUMBER     { printf("Number %d\n", $1); }
  | ID         { printf("Identifier %s\n", $1); free($1); }
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
