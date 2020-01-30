%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *fp;
FILE * f1;

char *type;
%}

%token <String> INT FLOAT CHAR VOID
%token <String> WHILE FOR
%token <String> IF ELSE
%token <String> NUM ID TEXT

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

%type <String> pgmstart STMTS STMT1 STMT TYPE IDS STMT_DECLARE ID_INIT
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
		| NUM
		| TEXT
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




STMT_DECLARE 	: TYPE {type = strdup($1);} IDS ';' {printf("Dim %s\n",$3);}
				;

IDS 	: ID_INIT			{sprintf($$,"%s",$1);}
		| IDS ',' ID_INIT	{sprintf($$,"%s, %s",$1,$3);}
		;

ID_INIT		:	ID				{sprintf($$,"%s as %s",$1,type);}
			| 	ID ASGN EXP  	{sprintf($$,"%s as %s = %s",$1,type,$3);}
			;




STMT_ASSGN	: ID ASGN EXP ';'	{/*strcat($$,$1); strcat($$,$2); strcat($$,$3);*/ printf("%s = %s\n",$1,$3);}
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
