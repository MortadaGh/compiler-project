%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *fp;
FILE * f1;

%}

%token INT FLOAT CHAR VOID
%token WHILE FOR
%token IF ELSE
%token NUM ID
%right ASGN
%left LOR
%left LAND
%left EQ NE
%left LE GE LT GT
%left '+' '-'
%left '*' '/'

%nonassoc IFX IFX1
%nonassoc ELSE
  
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

STMT_DECLARE 	: TYPE ID IDS {printf("bye\n");}
				;


IDS 	: ';'
		| ','  ID IDS {printf("hi\n");}
        | ASGN EXP IDS
		;


STMT_ASSGN	: ID ASGN EXP ';'
			;


TYPE	: INT
        | FLOAT {$$ = "Single";     printf("%s\n",$$);}
        | CHAR  {$$ = "Char";       printf("%s\n",$$);}
		;

%%

int main(){
     while(yyparse()); 
    return 0;
}

yyerror(char* s){
    fprintf(stdout,"%s\n",s);
}
