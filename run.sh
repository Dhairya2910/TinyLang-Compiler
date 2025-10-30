#!/bin/bash
# --- Compile and run Flex & Bison project automatically ---

echo "Cleaning old files..."
rm -f lex.yy.c parser.tab.c parser.tab.h parser output.c

echo "Running Flex and Bison..."
flex lexer.l
bison -d parser.y

echo "Compiling..."
gcc parser.tab.c lex.yy.c -o parser

echo "Generating the C program"
./parser < test.tiny

echo "Running the program..."
gcc output.c -o output

echo "Output :"
./output

