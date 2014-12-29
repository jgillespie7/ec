%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

int printcount;
%}

//using union for future potential expansion
%union {
  char* sval;
}

%token <sval> IDENTIFIER FLOAT
%token DERIVATIVE
%token FOR WRITE
%token '(' ')' 
%left '+' '-' '/' '*'
%left <sval> LOGICAL
%type <sval> expression term printlist

%%
file:
  file statement{;}
  | statement {;}

statement:
  IDENTIFIER '=' expression ';' { printf("double %s = %s;\n", $1, $3); }
  | DERIVATIVE IDENTIFIER '=' expression ';' {
                        printf("%s += (%s)*dt;\n", $2, $4); }
  | FOR expression ':' { printf("while (%s){\n", $2);
                         printf("t += dt;\n"); }
  | WRITE printlist { char* format = malloc(4*printcount);
                      int i;
                      sprintf(format, "%%f");
                      for (i=1; i<printcount; i++){
                        sprintf(format, "%s %%f", format);
                      }
                      printf("printf(\"%s\\n\", %s);\n", format, $2); }
  ;

printlist:
  IDENTIFIER  { printcount = 1;
                int n = snprintf(NULL, 0, "%s", $1);
                $$ = malloc(n + 1);
                sprintf($$, "%s", $1); }
  | printlist ',' IDENTIFIER { printcount++;
                               int n = snprintf(NULL, 0, "%s, %s", $1, $3);
                               $$ = malloc(n + 1);
                               sprintf($$, "%s, %s", $1, $3); }
  ;

expression:
  term 
  | expression '+' term { int n = snprintf(NULL, 0, "%s + %s", $1, $3);
                               $$ = malloc(n + 1);
                               sprintf($$, "%s + %s", $1, $3); }
  | expression '-' term { int n = snprintf(NULL, 0, "%s - %s", $1, $3);
                               $$ = malloc(n + 1);
                               sprintf($$, "%s - %s", $1, $3); }
  | expression '/' term { int n = snprintf(NULL, 0, "%s / %s", $1, $3);
                               $$ = malloc(n + 1);
                               sprintf($$, "%s / %s", $1, $3); }
  | expression '*' term { int n = snprintf(NULL, 0, "%s * %s", $1, $3);
                               $$ = malloc(n + 1);
                               sprintf($$, "%s * %s", $1, $3); }
  | expression LOGICAL term { int n = snprintf(NULL, 0, "%s %s %s", $1, $2, $3);
                               $$ = malloc(n + 1);
                               sprintf($$, "%s %s %s", $1, $2, $3); }
  ;

term:
  IDENTIFIER { int n = snprintf(NULL, 0, "%s", $1);
               $$ = malloc(n + 1);
               sprintf($$, "%s", $1); }
  | FLOAT { int n = snprintf(NULL, 0, "%s", $1);
            $$ = malloc(n + 1);
            sprintf($$, "%s", $1); }
  | '-' term { int n = snprintf(NULL, 0, "-%s", $2);
                    $$ = malloc(n + 1);
                    sprintf($$, "-%s", $2); }
  | '(' expression ')' { int n = snprintf(NULL, 0, "(%s)", $2);
                         $$ = malloc(n + 1);
                         sprintf($$, "(%s)", $2); }
  ;

%%

int main(int argc, char** argv){
  if (argc > 1) {
    FILE* input = fopen( argv[1], "r");
    if (!input) {
        printf("Error: Could not open file %s\n", argv[1]);
        return -1;
      }
    yyin = input;
  }
  else {
    printf("No input file\n");
    return 0;
  }
  printf("#include <stdio.h>\n\n");
  printf("int main(){\n");
  printf("double dt = 0.01;\n");
  do {
    yyparse();
  } while (!feof(yyin));
  printf("}\n}\n");
}

void yyerror(const char *s){
  printf("Parse error! Message: %s\n", s);
  exit(-1);
}
