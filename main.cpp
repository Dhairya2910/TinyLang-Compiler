#include <iostream>
extern int yyparse();

int main() {
    std::cout << "Enter TinyLang code:\n";
    yyparse();
    return 0;
}
