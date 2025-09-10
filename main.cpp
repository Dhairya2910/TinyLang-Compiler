#include <iostream>
using namespace std;

extern int yyparse();

int main() {
    cout << "Enter TinyLang code:\n";
    yyparse();
    return 0;
}
