%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *fp;
FILE * f1;

char** ids = (char**) malloc (50*sizeof(char*));

%}

%token <String> INT FLOAT CHAR VOID
%token <String> WHILE FOR
%token <String> IF ELSE
%token <String> NUM ID

%right ASGN
%left LOR
%left LAND
%left EQ NE
%left LE GE LT GT
%left '+' '-'
%left '*' '/'

%nonassoc IFX IFX1
%nonassoc ELSE

%union {
	char *String;
}

%type <String> pgmstart STMTS STMT1 STMT TYPE IDS STMT_DECLARE 
%type <String> STMT_ASSGN STMT_IF STMT_WHILE STMT_FOR EXP IF_BODY ELSESTMT
%type <String> WHILE_BODY

%start pgmstart

%%

pgmstart 	: TYPE ID '(' ')' STMTS
			;

STMTS 	: '{' STMT1 '}'
		|
		;

STMT1	: STMT  STMT1
		|
		;

STMT 	: STMT_DECLARE    //all types of statements
		| STMT_ASSGN  
		| STMT_IF
		| STMT_WHILE
        | STMT_FOR
		| ';'
		;		

EXP 	: EXP LT EXP
		| EXP LE EXP
		| EXP GT EXP
		| EXP GE EXP
		| EXP NE EXP
		| EXP EQ EXP
		| EXP '+' EXP
		| EXP '-' EXP
		| EXP '*' EXP
		| EXP '/' EXP
		| EXP LOR EXP
		| EXP LAND EXP
		| '(' EXP ')'
		| ID
		| NUM {printf("NUM ");} 
		;

STMT_IF : IF '(' EXP ')' IF_BODY ELSESTMT 
		;

IF_BODY : STMTS
		| STMT
		;

ELSESTMT	: ELSE STMTS
			| 
			;

STMT_WHILE		: WHILE '(' EXP ')' WHILE_BODY  
				;

WHILE_BODY		: STMTS
				| STMT
				;

STMT_FOR : ; //TODO

STMT_DECLARE 	: TYPE ID IDS {printf("Dim %s%s as %s\n",$2,$3,$1);}
				;


IDS 	: ';'			{$$ = "";}
		| ','  ID IDS 	{char s[200]; strcpy(s," , "); strcat(s,$2); free($2);  strcpy($$,s);}
        | ASGN EXP IDS
		;


STMT_ASSGN	: ID ASGN EXP ';'
			;


TYPE	: INT	{$$ = "Integer";}
        | FLOAT {$$ = "Single";}
        | CHAR  {$$ = "Char";}
		;

%%

int main(){
     yyparse();
}

yyerror(char* s){
    fprintf(stdout,"%s\n",s);
}
