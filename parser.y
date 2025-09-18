/* =====================
 * Section 1: C Prologue
 * ===================== */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declaration for the input file pointer from Flex */
extern FILE *yyin;

/* Function prototypes */
int yylex(void);
void yyerror(const char *s);

/* The output file for the generated C code. */
FILE *out;

/* A helper function to remove quotes from string and char literals. */
char* strip_quotes(char* s) {
    if (s == NULL || (s[0] != '"' && s[0] != '\'')) return s;
    s[strlen(s) - 1] = '\0'; // Remove the last quote
    char* new_s = strdup(s + 1); // Copy from the second character
    free(s); // Free the original string from the lexer
    return new_s;
}
%}

/* ============================
 * Section 2: Bison Declarations
 * ============================ */
%union {
    char* sval;
}

/* Tokens with no value */
%token FOR WHILE PRINT SCAN TRUE FALSE
%token PLUS MINUS MUL DIV
%token ASSIGN EQ NEQ LT GT LE GE
%token SEMI LPAREN RPAREN LBRACE RBRACE
%token IF ELSE ELSEIF
%token INT FLOAT BOOL CHAR

/* Tokens with a string value <sval> */
%token <sval> IDENT NUMBER STRING CHAR_LITERAL

/* Non-terminal types */
%type <sval> type expr simple_assign

/* Operator precedence and associativity (lowest to highest) */
%right ASSIGN
%left EQ NEQ LT GT LE GE
%left PLUS MINUS
%left MUL DIV

%start program
%%
/* ======================
 * Section 3: Grammar Rules
 * ====================== */
program:
    statement_list
    ;

statement_list:
    /* empty */
    | statement_list statement
    ;

statement:
    declaration SEMI
    | assignment SEMI
    | printStmt SEMI
    | scanStmt SEMI
    | forStmt
    | whileStmt
    | ifStmt
    | block
    ;

block:
    LBRACE { fprintf(out, "{\n"); } statement_list RBRACE { fprintf(out, "}\n"); }
    ;

declaration:
    type IDENT { fprintf(out, "    %s %s;\n", $1, $2); free($1); free($2); }
    | type IDENT ASSIGN expr { fprintf(out, "    %s %s = %s;\n", $1, $2, $4); free($1); free($2); free($4); }
    ;

assignment:
    IDENT ASSIGN expr { fprintf(out, "    %s = %s;\n", $1, $3); free($1); free($3); }
    ;

type:
    INT   { $$ = strdup("int"); }
    | FLOAT { $$ = strdup("float"); }
    | CHAR  { $$ = strdup("char"); }
    | BOOL  { $$ = strdup("int"); /* Bools are often ints in C */ }
    ;

printStmt:
    PRINT LPAREN expr RPAREN { fprintf(out, "    printf(\"%%d\\n\", (int)(%s));\n", $3); free($3); }
    ;

scanStmt:
    SCAN LPAREN IDENT RPAREN { fprintf(out, "    scanf(\"%%d\", &%s);\n", $3); free($3); }
    ;

forStmt:
    FOR LPAREN simple_assign SEMI expr SEMI simple_assign RPAREN
    { fprintf(out, "for (%s; %s; %s) ", $3, $5, $7); free($3); free($5); free($7); }
    block
    ;

simple_assign:
    IDENT ASSIGN expr { asprintf(&$$, "%s = %s", $1, $3); free($1); free($3); }
    ;

whileStmt:
    WHILE LPAREN expr RPAREN { fprintf(out, "while (%s) ", $3); free($3); } block
    ;

ifStmt:
    IF LPAREN expr RPAREN { fprintf(out, "if (%s) ", $3); free($3); } block opt_else
    ;

opt_else:
    /* empty */
    | ELSE { fprintf(out, " else "); } block
    | ELSEIF LPAREN expr RPAREN { fprintf(out, " else if (%s) ", $3); free($3); } block opt_else
    ;

expr:
    expr PLUS expr      { asprintf(&$$, "%s + %s", $1, $3); free($1); free($3); }
    | expr MINUS expr     { asprintf(&$$, "%s - %s", $1, $3); free($1); free($3); }
    | expr MUL expr       { asprintf(&$$, "%s * %s", $1, $3); free($1); free($3); }
    | expr DIV expr       { asprintf(&$$, "%s / %s", $1, $3); free($1); free($3); }
    | expr GE expr        { asprintf(&$$, "%s >= %s", $1, $3); free($1); free($3); }
    | expr GT expr        { asprintf(&$$, "%s > %s", $1, $3); free($1); free($3); }
    | expr LE expr        { asprintf(&$$, "%s <= %s", $1, $3); free($1); free($3); }
    | expr LT expr        { asprintf(&$$, "%s < %s", $1, $3); free($1); free($3); }
    | expr EQ expr        { asprintf(&$$, "%s == %s", $1, $3); free($1); free($3); }
    | expr NEQ expr       { asprintf(&$$, "%s != %s", $1, $3); free($1); free($3); }
    | IDENT ASSIGN expr   { asprintf(&$$, "%s = %s", $1, $3); free($1); free($3); }
    | LPAREN expr RPAREN  { asprintf(&$$, "(%s)", $2); free($2); }
    | IDENT               { $$ = $1; }
    | NUMBER              { $$ = $1; }
    | STRING              { $$ = strip_quotes($1); }
    | CHAR_LITERAL        { $$ = strip_quotes($1); }
    | TRUE                { $$ = strdup("1"); }
    | FALSE               { $$ = strdup("0"); }
    ;
%%
/* =====================
 * Section 4: C Epilogue
 * ===================== */
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }

    out = fopen("output.c", "w");
    if (!out) {
        perror("output.c");
        return 1;
    }

    fprintf(out, "#include <stdio.h>\n\n");
    fprintf(out, "int main() {\n");
    yyparse();
    fprintf(out, "    return 0;\n");
    fprintf(out, "}\n");
    fclose(out);

    printf("Successfully generated output.c\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parse Error: %s\n", s);
}