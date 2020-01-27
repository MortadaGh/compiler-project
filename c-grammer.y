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

STMT_DECLARE 	: TYPE ID IDS {printf("Type : "); printf("%s\n",$1);}
				;


IDS 	: ';' {printf("5i5i5i\n");}
		| ','  ID IDS {printf("hi\n");}
        | ASGN {printf("ASGN ");} EXP {printf("EXP ");} IDS {printf("========\n");}
		;


STMT_ASSGN	: ID ASGN EXP ';'
			;


TYPE	: INT
        | FLOAT {$$ = "Single";     printf("%s\n",$$);}
        | CHAR  {$$ = "Char";       printf("%s\n",$$);}
		;

%%

int main(){
     yyparse();
}

yyerror(char* s){
    fprintf(stdout,"%s\n",s);
}
