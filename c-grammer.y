%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *fp;
FILE * f1;

char *type;
char s[1000000];
%}

%token <String> INT FLOAT CHAR VOID
%token <String> WHILE FOR
%token <String> IF ELSE
%token <String> NUM ID TEXT CHARACTERE
%token <String> LEFTBRACKET RIGHTBRACKET SEMICOLON LEFTPARENTHESIS RIGHTPARENTHESIS

%right ASGN
%left LOR
%left LAND
%left EQ NE
%left LE GE LT GT
%left PLUS MINUS
%left MUL DIV MOD

%nonassoc IFX IFX1
%nonassoc ELSE

%union {
	char *String;
}

%type <String> pgmstart STMTS STMT STMT1 TYPE IDS STMT_DECLARE ID_INIT
%type <String> STMT_ASSGN STMT_IF STMT_WHILE STMT_FOR EXP IF_BODY ELSESTMT
%type <String> WHILE_BODY FOR_BODY
%type <String> LT LE GT GE NE EQ LOR LAND PLUS MINUS MUL DIV ASGN MOD

%start pgmstart

%%

pgmstart 	: TYPE ID LEFTPARENTHESIS RIGHTPARENTHESIS STMTS {printf("%s",$5);}
			;

STMTS 	: LEFTBRACKET STMT1 RIGHTBRACKET {sprintf(s,"%s",$2); $$ = strdup(s);}
		| /*epsilon*/
		;

STMT1	: STMT 			{sprintf(s,"%s",$1); $$ = strdup(s);}
		| STMT1 STMT 	{sprintf(s,"%s\n%s",$1,$2); $$ = strdup(s);}
		;

STMT 	: STMT_DECLARE  {sprintf(s,"%s",$1); $$ = strdup(s);}  //all types of statements
		| STMT_ASSGN 	{sprintf(s,"%s",$1); $$ = strdup(s);}
		| STMT_IF		{sprintf(s,"%s",$1); $$ = strdup(s);}
		| STMT_WHILE	{sprintf(s,"%s",$1); $$ = strdup(s);}
        | STMT_FOR		{sprintf(s,"%s",$1); $$ = strdup(s);}
		| SEMICOLON
		;		

EXP 	: EXP LT EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP LE EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP GT EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP GE EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP NE EXP			{sprintf(s,"%s <> %s",$1,$3); $$ = strdup(s);}
		| EXP EQ EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP LOR EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP LAND EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP PLUS EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP MINUS EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP MUL EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP DIV EXP			{sprintf(s,"%s %s %s",$1,$2,$3); $$ = strdup(s);}
		| EXP MOD EXP			{sprintf(s,"%s Mod %s",$1,$3); $$ = strdup(s);}
		| EXP PLUS PLUS 		{sprintf(s,"%s %s= 1",$1,$2); $$ = strdup(s);}
		| EXP MINUS MINUS		{sprintf(s,"%s %s= 1",$1,$2); $$ = strdup(s);}
		| EXP PLUS ASGN EXP		{sprintf(s,"%s %s%s %s",$1,$2,$3,$4); $$ = strdup(s);}
		| EXP MINUS ASGN EXP	{sprintf(s,"%s %s%s %s",$1,$2,$3,$4); $$ = strdup(s);}
		| EXP MUL ASGN EXP		{sprintf(s,"%s %s%s %s",$1,$2,$3,$4); $$ = strdup(s);}
		| EXP DIV ASGN EXP		{sprintf(s,"%s %s%s %s",$1,$2,$3,$4); $$ = strdup(s);}
		| '(' EXP ')'			{sprintf(s,"( %s )",$2); $$ = strdup(s);}
		| ID
		| NUM
		| TEXT
		| CHARACTERE
		;

STMT_IF : IF LEFTPARENTHESIS EXP RIGHTPARENTHESIS IF_BODY ELSESTMT {sprintf(s,"If %s Then\n%s%sEnd If",$3,$5,$6); $$ = strdup(s);}
		;

IF_BODY : STMTS		{sprintf(s,"%s",$1); $$ = strdup(s);}
		| STMT 		{sprintf(s,"%s",$1); $$ = strdup(s);}
		;

ELSESTMT	: ELSE STMTS	{sprintf(s,"\nElse\n%s\n",$2); $$ = strdup(s);}
			| /*epsilon*/	{sprintf(s,"\n"); $$ = strdup(s);}
			;

STMT_WHILE		: WHILE LEFTPARENTHESIS EXP RIGHTPARENTHESIS WHILE_BODY  {sprintf(s,"While %s Then\n%s\nEnd While",$3,$5); $$ = strdup(s);}
				;

WHILE_BODY		: STMTS	{sprintf(s,"%s",$1); $$ = strdup(s);}
				| STMT	{sprintf(s,"%s",$1); $$ = strdup(s);}
				;


STMT_FOR 	: FOR LEFTPARENTHESIS STMT_ASSGN  ID LT NUM SEMICOLON ID PLUS PLUS RIGHTPARENTHESIS FOR_BODY {sprintf(s,"For %s To %s - 1\n%s\nNext\n",$3,$6,$12); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN  ID LE NUM SEMICOLON ID PLUS PLUS RIGHTPARENTHESIS FOR_BODY {sprintf(s,"For %s To %s\n%s\nNext\n",$3,$6,$12); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN  ID GT NUM SEMICOLON ID MINUS MINUS RIGHTPARENTHESIS FOR_BODY {sprintf(s,"For %s To %s + 1\n%s\nNext\n",$3,$6,$12); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN  ID GE NUM SEMICOLON ID MINUS MINUS RIGHTPARENTHESIS FOR_BODY {sprintf(s,"For %s To %s\n%s\nNext\n",$3,$6,$12); $$ = strdup(s);}


			| FOR LEFTPARENTHESIS STMT_ASSGN  ID LT NUM SEMICOLON ID PLUS ASGN NUM RIGHTPARENTHESIS FOR_BODY {sprintf(s,"For %s To %s - 1 Step %s\n%s\nNext\n",$3,$6,$11,$13); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN  ID LE NUM SEMICOLON ID PLUS ASGN NUM RIGHTPARENTHESIS FOR_BODY {sprintf(s,"For %s To %s Step %s\n%s\nNext\n",$3,$6,$11,$13); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN  ID GT NUM SEMICOLON ID MINUS ASGN NUM RIGHTPARENTHESIS FOR_BODY {sprintf(s,"For %s To %s + 1 Step %s\n%s\nNext\n",$3,$6,$11,$13); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN  ID GE NUM SEMICOLON ID MINUS ASGN NUM RIGHTPARENTHESIS FOR_BODY {sprintf(s,"For %s To %s Step %s\n%s\nNext\n",$3,$6,$11,$13); $$ = strdup(s);}
			

			| FOR LEFTPARENTHESIS STMT_ASSGN ID LT NUM SEMICOLON ID MINUS MINUS RIGHTPARENTHESIS FOR_BODY {sprintf(s,"%s\nWhile %s %s %s\n%s\n%s -= 1\nEnd While",$3,$4,$5,$6,$12,$8); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN ID LE NUM SEMICOLON ID MINUS MINUS RIGHTPARENTHESIS FOR_BODY {sprintf(s,"%s\nWhile %s %s %s\n%s\n%s -= 1\nEnd While",$3,$4,$5,$6,$12,$8); $$ = strdup(s);}
			
			
			| FOR LEFTPARENTHESIS STMT_ASSGN ID LT NUM SEMICOLON ID MINUS ASGN NUM RIGHTPARENTHESIS FOR_BODY {sprintf(s,"%s\nWhile %s %s %s\n%s\n%s -= %s\nEnd While",$3,$4,$5,$6,$13,$8,$11); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN ID LE NUM SEMICOLON ID MINUS ASGN NUM RIGHTPARENTHESIS FOR_BODY {sprintf(s,"%s\nWhile %s %s %s\n%s\n%s -= %s\nEnd While",$3,$4,$5,$6,$13,$8,$11); $$ = strdup(s);}
			
			| FOR LEFTPARENTHESIS STMT_ASSGN ID GT NUM SEMICOLON ID PLUS ASGN NUM RIGHTPARENTHESIS FOR_BODY {sprintf(s,"%s\nWhile %s %s %s\n%s\n%s += %s\nEnd While",$3,$4,$5,$6,$13,$8,$11); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN ID GE NUM SEMICOLON ID PLUS ASGN NUM RIGHTPARENTHESIS FOR_BODY {sprintf(s,"%s\nWhile %s %s %s\n%s\n%s += %s\nEnd While",$3,$4,$5,$6,$13,$8,$11); $$ = strdup(s);}
			
			| FOR LEFTPARENTHESIS STMT_ASSGN ID GT NUM SEMICOLON ID PLUS PLUS RIGHTPARENTHESIS FOR_BODY {sprintf(s,"%s\nWhile %s %s %s\n%s\n%s += 1\nEnd While",$3,$4,$5,$6,$12,$8); $$ = strdup(s);}
			| FOR LEFTPARENTHESIS STMT_ASSGN ID GE NUM SEMICOLON ID PLUS PLUS RIGHTPARENTHESIS FOR_BODY {sprintf(s,"%s\nWhile %s %s %s\n%s\n%s += 1\nEnd While",$3,$4,$5,$6,$12,$8); $$ = strdup(s);}
			;

FOR_BODY	: STMTS	{sprintf(s,"%s",$1); $$ = strdup(s);}
			| STMT	{sprintf(s,"%s",$1); $$ = strdup(s);}
			;


STMT_DECLARE 	: TYPE {type = strdup($1);} IDS SEMICOLON {sprintf(s, "Dim %s",$3);$$ = strdup(s);}
				;

IDS 	: ID_INIT			{sprintf($$,"%s",$1);}
		| IDS ',' ID_INIT	{sprintf($$,"%s, %s",$1,$3);}
		;

ID_INIT		:	ID				{sprintf($$,"%s as %s",$1,type);}
			| 	ID ASGN EXP  	{sprintf($$,"%s as %s = %s",$1,type,$3);}
			;




STMT_ASSGN	: ID ASGN EXP SEMICOLON	{sprintf(s,"%s = %s",$1,$3); $$ = strdup(s);}
			| 
			;

TYPE	: INT	{$$ = strdup("Integer");}
        | FLOAT {$$ = strdup("Single");}
        | CHAR  {$$ = strdup("Char");}
		;

%%

int main(){
     yyparse();
}

yyerror(char* s){
    fprintf(stdout,"%s\n",s);
}
