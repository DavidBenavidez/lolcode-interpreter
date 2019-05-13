%{
void yyerror (char *s);
int yylex();
#include "symbol_table.h"
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
extern FILE *yyin;
TABLE *root = NULL;
char stringconcat[999];
int isInteger = 1;
int exprTrue = 0;
void declareVariable();
%}

%start body
%union
{
  int number;
  char *string;
  float floatVal;
}
// Basic and Data types
%token PART
%token HAI
%token KTHXBYE
%token VAR
%token ITZ
%token <string> IDENTIFIER
%token <number> NUMBR
%token <floatVal> NUMBAR
%token <string> YARN
%token <number> TROOF

// Arithmetic Operations
%type <floatVal> ARITHMETIC
%token SUM DIFF QUOSHUNT PRODUKT MOD SMALLR BIGGR OF AN

// Input/Ouput
%token VISIBLE
%token GIMMEH 

// Boolean Expressions
%type <number> BOOLEAN_EXPR BOOLEAN_OUTPUTS
%token BOTH EITHER WON NOT

// Comparison Expression
%type <number> COMP_EXPR
%token SAEM DIFFRINT 

// Concatenation
%type <string> CONCATENATION
%token SMOOSH 

// Assignment
%token R 

// If-else satetment
%token INITIF IF ELSE ENDIF 
// %token WTF 
// %token OMG 
%%

/* descriptions of expected inputs     corresponding actions (in C) */

body    : HAI main KTHXBYE
        | HAI KTHXBYE
		;

main	:	program_parts
		|	main program_parts
		;

program_parts	:	VARIABLE
				|	VISIBLE TO_PRINT
				|	INPUT
				|	BOOLEAN_EXPR
				|	COMP_EXPR
				|	CONCATENATION
				|	ASSIGNMENT	
				| 	IFELSE
				;

BOOLEAN_OUTPUTS	: 	BOOLEAN_EXPR
				|	COMP_EXPR
				;

IFELSE	:	BOOLEAN_OUTPUTS INITIF IF	{
											if($1 == 1) printf("Hey!\n");
										}


ASSIGNMENT	:	IDENTIFIER R ARITHMETIC	{
											(isInteger == 1) ? insert_numbr(&root, $1, (int)$3) : insert_numbar(&root, $1, $3);
											isInteger = 1;
										}
			|	IDENTIFIER R IDENTIFIER	{assign_var(&root, $1, $3);}
			|	IDENTIFIER R CONCATENATION	{insert_yarn(&root, $1, $3);}

CONCATENATION	:	SMOOSH YARN CONCATENATION	{ 
													RemoveChars($2, '\"');
													$$ = strcat($2, $3);
													memset(stringconcat, 0, 999);
												}
				|	AN YARN CONCATENATION	{ 
												RemoveChars($2, '\"');
												$$ = strcat($2, $3);
											}
				|	AN YARN	{ 
								RemoveChars($2, '\"');
								$$ = strcat(stringconcat, $2);
							}

COMP_EXPR	:	BOTH SAEM ARITHMETIC AN ARITHMETIC	{
														// Check data types of 3 and 5
														$$ = ($3 == $5) ? 1 : 0;
													}
			| 	DIFFRINT ARITHMETIC AN ARITHMETIC	{
														$$ = ($2 != $4) ? 1 : 0;
													}

BOOLEAN_EXPR	:	BOTH OF TROOF AN TROOF	{$$ = ($3 == $5) ? 1 : 0;}
				|	EITHER OF TROOF AN TROOF	{$$ = ($3 == 1 || $5 == 1) ? 1 : 0;}
				|	WON OF TROOF AN TROOF	{$$ = ($3 != $5) ? 1 : 0;}
				|	NOT TROOF	{$$ = ($2 == 0) ? 1 : 0;}

INPUT	:	GIMMEH IDENTIFIER	{get_input(&root, $2);}

TO_PRINT	:	NUMBR TO_PRINT 	{printf("%d\n", $1);}
			|	NUMBAR TO_PRINT	{printf("%f\n", $1);}
			|	YARN TO_PRINT	{RemoveChars($1, '\"'); printf("%s\n", $1);}
			|	ARITHMETIC TO_PRINT	{(isInteger==0) ? printf("%f\n", $1) : printf("%d\n", (int)$1); isInteger = 1;}
			|	IDENTIFIER TO_PRINT	{print_var(&root, $1);} 
			|	CONCATENATION TO_PRINT	{printf("%s\n", $1);}
			|	BOOLEAN_EXPR TO_PRINT	{($1 == 1)? printf("WIN\n", $1) : printf("FAIL\n", $1);}
			|	COMP_EXPR TO_PRINT	{($1 == 1)? printf("WIN\n", $1) : printf("FAIL\n", $1);}
			|	NUMBR 	{printf("%d\n", $1);}
			|	NUMBAR	{printf("%f\n", $1);}
			|	YARN	{RemoveChars($1, '\"'); printf("%s\n", $1);}
			|	ARITHMETIC	{(isInteger==0) ? printf("%f\n", $1) : printf("%d\n", (int)$1); isInteger = 1;}
			|	IDENTIFIER	{print_var(&root, $1);}
			|	CONCATENATION	{printf("%s\n", $1);}
			|	BOOLEAN_EXPR	{($1 == 1) ? printf("WIN\n", $1) : printf("FAIL\n", $1);}
			|	COMP_EXPR	{($1 == 1) ? printf("WIN\n", $1) : printf("FAIL\n", $1);}


VARIABLE	:	VAR IDENTIFIER	{init_lexeme(&root, $2);}
			|	VAR IDENTIFIER ITZ NUMBR	{
												init_lexeme(&root, $2);
												insert_numbr(&root, $2, $4);
											}
			|	VAR IDENTIFIER ITZ NUMBAR	{
												init_lexeme(&root, $2);
												insert_numbar(&root, $2, $4);
											}
			|	VAR IDENTIFIER ITZ YARN	{
											init_lexeme(&root, $2);
											insert_yarn(&root, $2, $4);
										}
			|	VAR IDENTIFIER ITZ TROOF	{
												init_lexeme(&root, $2);
												insert_troof(&root, $2, $4);
											}
			|	VAR IDENTIFIER ITZ CONCATENATION	{
														init_lexeme(&root, $2);
														insert_yarn(&root, $2, $4);
													}
			|	VAR IDENTIFIER ITZ BOOLEAN_EXPR	{
													printf("Inside!\n");
													init_lexeme(&root, $2);
													insert_troof(&root, $2, $4);
													view(root);
												}
			|	VAR IDENTIFIER ITZ COMP_EXPR	{
													init_lexeme(&root, $2);
													insert_troof(&root, $2, $4);
													view(root);
												}		
			|	VAR IDENTIFIER ITZ ARITHMETIC	{
													init_lexeme(&root, $2);
													// If output is no longer an integer, insert a float
													(isInteger == 0) ? insert_numbar(&root, $2, $4) : insert_numbr(&root, $2, (int) $4);
													isInteger = 1;
												}
			|	VAR IDENTIFIER ITZ IDENTIFIER	{
													init_lexeme(&root, $2);
													assign_var(&root, $2, $4);
												}
ARITHMETIC	:	SUM OF ARITHMETIC AN ARITHMETIC	{$$ = $3 + $5;}	
			|	DIFF OF ARITHMETIC AN ARITHMETIC	{$$ = $3 - $5;}
			|	PRODUKT OF ARITHMETIC AN ARITHMETIC	{$$ = $3 * $5;}
			|	QUOSHUNT OF ARITHMETIC AN ARITHMETIC	{
															// Output is no longer an integer, it's now a float
															// isInteger = 0;
															$$ = $3 / $5;
														}
			|	MOD OF ARITHMETIC AN ARITHMETIC	{$$ = (int)$3 % (int)$5;}
			|	BIGGR OF ARITHMETIC AN ARITHMETIC	{$$ = ($3 > $5) ? $3 : $5;}
			|	SMALLR OF ARITHMETIC AN ARITHMETIC	{$$ = ($3 < $5) ? $3 : $5;}														
			|	NUMBR	{$$ = $1;}
			|	NUMBAR	{
							isInteger = 0;
							$$ = $1;
						}
			|	YARN	{
							RemoveChars($1, '\"'); // Remove quotations
							$$ = (check_type($1) == 1) ? atoi($1) : (isInteger = 0, atof($1)); // if type of string is int, return int, if float, return  float
						}
			|	TROOF	{
							$$ = ($1 == 1) ? 1 : 0; // if type of string is int, return int, if float, return  float
						}
			|	IDENTIFIER {$$ = get_var(&root, $1, &isInteger);}
%%                     /* C code */


int main (int argc, char *argv[]) {
	fflush(stdin);
	yyin = fopen(argv[1], "r");

	return(yyparse());
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 