%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int ival;
    char cval;
    char* sval;
}

/* Tokens */
%token FOR WHILE PRINT SCAN TRUE FALSE
%token IDENT NUMBER STRING CHAR
%token PLUS MINUS MUL DIV
%token ASSIGN EQ NEQ LT GT LE GE
%token SEMI LPAREN RPAREN LBRACE RBRACE

/* Add these tokens */
%token IF ELSE ELSEIF

%left PLUS MINUS
%left MUL DIV
%left LT GT LE GE EQ NEQ

%type <ival> NUMBER
%type <cval> CHAR
%type <sval> IDENT STRING
%start program

%%

program:
      statement_list
    ;

statement_list:
      /* empty */
    | statement_list statement
    ;

statement:
      assignment SEMI
    | printStmt SEMI
    | scanStmt SEMI
    | forStmt
    | whileStmt
    | ifStmt              /* Add a rule for if statements */
    ;

assignment:
      IDENT ASSIGN expr
    ;

printStmt:
      PRINT LPAREN expr RPAREN
    ;

scanStmt:
      SCAN LPAREN IDENT RPAREN
    ;

forStmt:
      FOR LPAREN assignment SEMI expr SEMI assignment RPAREN block
    ;

whileStmt:
      WHILE LPAREN expr RPAREN block
    ;

ifStmt:
    IF LPAREN expr RPAREN block opt_else
    ;

opt_else:
    /* empty */
    | ELSE block
    | ELSEIF LPAREN expr RPAREN block opt_else /* Handle `else if` */
    ;

block:
      LBRACE statement_list RBRACE
    ;

expr:
      expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | expr GE expr
    | expr GT expr
    | expr LE expr
    | expr LT expr
    | expr EQ expr
    | expr NEQ expr
    | LPAREN expr RPAREN
    | IDENT
    | NUMBER
    | STRING
    | CHAR
    | TRUE
    | FALSE
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter TinyLang program:\n");
    if (yyparse() == 0) {
        printf("Parsing successful!\n");
    }
    return 0;
}