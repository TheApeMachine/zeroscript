#include <iostream>
#include <fstream>
#include "lexer.h"

typedef uint32_t i32;
using namespace std;

int main(int argc, char *argv[]) {
  if(argc != 2) {
    cout << "Usage: " << argv[0] << " <filename.zero>" << endl;
    exit(1);
  }

  ifstream infile;
  infile.open(argv[1]);

  if(!infile.is_open()) {
    cout << "Error: could not open [" << argv[1] << "]" << endl;
    exit(1);
  }

  string line;
  string contents;

  while(getline(infile, line)) {
    contents += line + "\n";
  }

  infile.close();

  Lexer lexer;
  strings lexemes = lexer.lex(contents);

  for (int i = 2; i >= 0; i--)
    cout << lexemes[i] << endl;

  return 0;
}
