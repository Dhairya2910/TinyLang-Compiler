%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

%}

/* Tokens */
%token IF ELSE WHILE FOR ELSEIF
%token EQ NEQ GE LE GT LT
%token ASSIGN PLUS MINUS MUL DIV
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token UNKNOWN

/* These tokens carry values */
%token <ival> NUMBER
%token <sval> IDENTIFIER

/* Define semantic value types */
%union {
    int ival;      /* for numbers */
    char *sval;    /* for identifiers */
}

/* Precedence rules */
%left PLUS MINUS
%left MUL DIV
%left EQ NEQ GT LT GE LE

%%

program
    : program statement
    | /* empty */
    ;

statement
    : expr SEMICOLON
    | assignment SEMICOLON
    | if_stmt
    | while_stmt
    | for_stmt
    | block
    ;

assignment
    : IDENTIFIER ASSIGN expr
    ;

expr
    : expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | expr EQ expr
    | expr NEQ expr
    | expr GT expr
    | expr LT expr
    | expr GE expr
    | expr LE expr
    | LPAREN expr RPAREN
    | NUMBER
    | IDENTIFIER
    ;

if_stmt
    : IF LPAREN expr RPAREN statement
    | IF LPAREN expr RPAREN statement ELSE statement
    | IF LPAREN expr RPAREN statement ELSEIF statement
    ;

while_stmt
    : WHILE LPAREN expr RPAREN statement
    ;

for_stmt
    : FOR LPAREN assignment SEMICOLON expr SEMICOLON assignment RPAREN statement
    ;

block
    : LBRACE program RBRACE
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